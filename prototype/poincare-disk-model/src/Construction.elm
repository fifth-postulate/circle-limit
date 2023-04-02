module Construction exposing (Construction, Error, definePoint, empty, line, view)

import Construction.Name as Name exposing (Name(..), Named)
import Construction.Point as Point exposing (Point)
import Construction.Type as Type exposing (Type(..))
import Html exposing (Html)


type Construction
    = Construction Model


type alias Model =
    { steps : List (Named Type Step) }


empty : Construction
empty =
    Construction
        { steps = []
        }


definePoint : Point -> Construction -> Construction
definePoint p (Construction model) =
    let
        name =
            model.steps
                |> List.filter (Tuple.first >> Name.is Point)
                |> List.length
                |> (+) 1
                |> Name.name Point
    in
    Construction { model | steps = ( name, Define p ) :: model.steps }


line : Name Type -> Name Type -> Construction -> Result Error Construction
line a b ((Construction model) as construction) =
    let
        name =
            model.steps
                |> List.filter (Tuple.first >> Name.is Line)
                |> List.length
                |> (+) 1
                |> Name.name Line
    in
    case ( lookupPoint a construction, lookupPoint b construction ) of
        ( Ok _, Ok _ ) ->
            Construction { model | steps = ( name, LineThrough a b ) :: model.steps }
                |> Ok

        ( Err e, Ok _ ) ->
            Err e

        ( Ok _, Err e ) ->
            Err e

        ( Err e1, Err e2 ) ->
            [ e1, e2 ]
                |> Compound
                |> Err


lookupPoint : Name Type -> Construction -> Result Error Point.Point
lookupPoint name ((Construction model) as construction) =
    if Name.is Point name then
        model.steps
            |> List.filter (Tuple.first >> (==) name)
            |> List.head
            |> Maybe.andThen (Tuple.second >> toPoint construction)
            |> Result.fromMaybe (UnknownPoint name)

    else
        NotAPoint name
            |> Err


type Error
    = NotAPoint (Name Type)
    | UnknownPoint (Name Type)
    | Compound (List Error)


type Step
    = Define Point
    | LineThrough (Name Type) (Name Type)


toPoint : Construction -> Step -> Maybe Point
toPoint _ step =
    case step of
        Define p ->
            Just p

        _ ->
            Nothing


view : Construction -> Html msg
view (Construction model) =
    let
        wrap : Html msg -> Html msg
        wrap html =
            Html.li [] [ html ]
    in
    Html.ul [] <| List.map (viewNamedStep >> wrap) model.steps


viewNamedStep : Named Type Step -> Html msg
viewNamedStep ( name, step ) =
    Html.span []
        [ Name.view Type.toString name
        , viewSeparator
        , viewStep step
        ]


viewSeparator : Html msg
viewSeparator =
    Html.text ": "


viewStep : Step -> Html msg
viewStep step =
    case step of
        Define p ->
            Point.view p

        LineThrough a b ->
            viewLineThrough a b


viewLineThrough : Name Type -> Name Type -> Html msg
viewLineThrough a b =
    let
        coordinates =
            [ a, b ]
                |> List.map (Name.toString Type.toString)
                |> String.join ","
    in
    Html.text <| "line(" ++ coordinates ++ ")"

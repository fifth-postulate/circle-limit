module Construction exposing (Construction, Error, definePoint, empty, line, view)

import Construction.Name as Name exposing (Name(..), Named)
import Construction.Point as Point exposing (Point)
import Html exposing (Html)


type Construction
    = Construction Model


type alias Model =
    { steps : List (Named ConstructionStep) }


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
                |> List.filter (Tuple.first >> Name.isPoint)
                |> List.length
                |> (+) 1
                |> Point
    in
    Construction { model | steps = ( name, Define p ) :: model.steps }


line : Name -> Name -> Construction -> Result Error Construction
line a b (Construction model) =
    let
        name =
            model.steps
                |> List.filter (Tuple.first >> Name.isLine)
                |> List.length
                |> (+) 1
                |> Name.Line
    in
    -- TODO check if points are known
    Construction { model | steps = ( name, Line a b ) :: model.steps }
        |> Ok


type Error
    = UnknownPoint Name


type ConstructionStep
    = Define Point
    | Line Name Name


view : Construction -> Html msg
view (Construction model) =
    let
        wrap : Html msg -> Html msg
        wrap html =
            Html.li [] [ html ]
    in
    Html.ul [] <| List.map (viewStep >> wrap) model.steps


viewStep : Named ConstructionStep -> Html msg
viewStep ( name, step ) =
    Html.span []
        [ Name.view name
        , viewSeparator
        , viewConstructionStep step
        ]


viewSeparator : Html msg
viewSeparator =
    Html.text ": "


viewConstructionStep : ConstructionStep -> Html msg
viewConstructionStep step =
    case step of
        Define p ->
            Point.view p

        Line a b ->
            viewLine a b


viewLine : Name -> Name -> Html msg
viewLine a b =
    let
        coordinates =
            [ a, b ]
                |> List.map Name.toString
                |> String.join ","
    in
    Html.text <| "line(" ++ coordinates ++ ")"

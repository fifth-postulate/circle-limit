module Construction exposing (Construction, definePoint, empty, view)

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
                |> List.filter (Tuple.first >> isPoint)
                |> List.length
                |> (+) 1
                |> Point
    in
    Construction { model | steps = ( name, DefinePoint p ) :: model.steps }


type alias Named a =
    ( Name, a )


type Name
    = Point Int


isPoint : Name -> Bool
isPoint name =
    case name of
        Point _ ->
            True


type ConstructionStep
    = DefinePoint Point


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
        [ viewName name
        , viewSeparator
        , viewConstructionStep step
        ]


viewName : Name -> Html msg
viewName name =
    case name of
        Point index ->
            Html.text <| "P" ++ String.fromInt index


viewSeparator : Html msg
viewSeparator =
    Html.text ": "


viewConstructionStep : ConstructionStep -> Html msg
viewConstructionStep step =
    case step of
        DefinePoint p ->
            Point.view p

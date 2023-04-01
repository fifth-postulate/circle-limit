module Construction exposing (Construction, definePoint, empty, view)

import Construction.Point as Point exposing (Point)
import Html exposing (Html)


type Construction
    = Construction Model


type alias Model =
    { steps : List ConstructionStep }


empty : Construction
empty =
    Construction
        { steps = []
        }


definePoint : Point -> Construction -> Construction
definePoint p (Construction model) =
    Construction { model | steps = DefinePoint p :: model.steps }


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


viewStep : ConstructionStep -> Html msg
viewStep step =
    case step of
        DefinePoint p ->
            viewPoint p


viewPoint : Point -> Html msg
viewPoint point =
    Html.span []
        [ Html.text "define "
        , Point.view point
        ]

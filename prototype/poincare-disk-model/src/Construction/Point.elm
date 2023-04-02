module Construction.Point exposing (Point, point, view)

import Html.Styled as Html exposing (Html)


type Point
    = Point { x : Float, y : Float }


point : Float -> Float -> Point
point x y =
    Point { x = x, y = y }


view : Point -> Html msg
view (Point { x, y }) =
    let
        coordinates =
            [ x, y ]
                |> List.map String.fromFloat
                |> String.join ","

        representation =
            "(" ++ coordinates ++ ")"
    in
    Html.text representation

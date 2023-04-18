module Construction.Point exposing (Point, point, use, view)

import Html.Styled as Html exposing (Html)


type Point
    = Point { x : Float, y : Float }


point : Float -> Float -> Point
point x y =
    Point { x = x, y = y }


use : (Float -> Float -> a) -> Point -> a
use f (Point { x, y }) =
    f x y


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

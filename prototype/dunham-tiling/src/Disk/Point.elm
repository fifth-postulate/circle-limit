module Disk.Point exposing (Point, point, use, view)

import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


type Point
    = Point { x : Float, y : Float }


point : Float -> Float -> Point
point x y =
    Point { x = x, y = y }


use : (Float -> Float -> a) -> Point -> a
use f (Point { x, y }) =
    f x y


view : Point -> Svg msg
view (Point { x, y }) =
    let
        centerX =
            x
                |> String.fromFloat

        centerY =
            y
                |> String.fromFloat
    in
    Svg.circle [ cx centerX, cy centerY, r "0.01" ] []

module Disk.Point exposing (Point, difference, inversion, norm, point, scale, similar, sum, use, view)

import Html exposing (p)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)
import Tolerance


type Point
    = Point { x : Float, y : Float }


point : Float -> Float -> Point
point x y =
    Point { x = x, y = y }


use : (Float -> Float -> a) -> Point -> a
use f (Point { x, y }) =
    f x y


similar : Point -> Point -> Bool
similar a b =
    let
        d =
            difference a b
                |> norm
    in
    d < Tolerance.epsilon


difference : Point -> Point -> Point
difference (Point a) (Point b) =
    point (b.x - a.x) (b.y - a.y)


sum : Point -> Point -> Point
sum (Point a) (Point b) =
    point (a.x + b.x) (a.y + b.y)


scale : Float -> Point -> Point
scale f (Point { x, y }) =
    point (f * x) (f * y)


norm : Point -> Float
norm (Point { x, y }) =
    sqrt (x ^ 2 + y ^ 2)


inversion : Point -> Point
inversion p =
    let
        d =
            norm p
    in
    scale (1 / d ^ 2) p


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

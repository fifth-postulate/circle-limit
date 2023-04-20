module Disk.Line.Arc exposing (view)

import Disk.Line.Equation as Equation exposing (Equation, equation)
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


view : Point -> Point -> Svg msg
view a b =
    let
        c =
            Point.inversion a

        ab =
            bisector a b

        ac =
            bisector a c

        o =
            Equation.intersection ab ac

        ( centerX, centerY ) =
            Point.use Tuple.pair o

        radius =
            Point.norm <| Point.difference a o
    in
    Svg.g []
        [ Svg.circle
            [ cx <| String.fromFloat centerX
            , cy <| String.fromFloat centerY
            , r <| String.fromFloat radius
            , fill "none"
            , stroke "red"
            ]
            []
        ]


midpoint : Point -> Point -> Point
midpoint a b =
    Point.sum a b
        |> Point.scale (1 / 2)


bisector : Point -> Point -> Equation
bisector a b =
    let
        ( dx, dy ) =
            Point.use Tuple.pair <| Point.difference b a
    in
    equation (midpoint a b) -dy dx

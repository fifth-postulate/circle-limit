module Disk.Circle exposing (Circle, circle, inversion, through, unit)

import Disk.Line.Equation as Equation exposing (Equation, equation)
import Disk.Point as Point exposing (Point, norm, point)


type Circle
    = Circle { center : Point, radius : Float }


unit : Circle
unit =
    circle 1 <| point 0 0


circle : Float -> Point -> Circle
circle radius center =
    Circle { center = center, radius = radius }


through : Point -> Point -> Circle
through a b =
    let
        c =
            inversion unit a

        ab =
            bisector a b

        ac =
            bisector a c

        center =
            Equation.intersection ab ac

        radius =
            Point.norm <| Point.difference a center
    in
    circle radius center


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


inversion : Circle -> Point -> Point
inversion (Circle { center, radius }) p =
    let
        d =
            norm <| Point.difference p center
    in
    Point.difference p center
        |> Point.scale ((radius / d) ^ 2)
        |> Point.sum center

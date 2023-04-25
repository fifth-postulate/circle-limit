module Disk.Circle exposing (Circle, circle, inversion, unit)

import Disk.Point as Point exposing (Point, norm, point, scale)


type Circle
    = Circle { center : Point, radius : Float }


unit : Circle
unit =
    circle 1 <| point 0 0


circle : Float -> Point -> Circle
circle radius center =
    Circle { center = center, radius = radius }


inversion : Circle -> Point -> Point
inversion (Circle { center, radius }) p =
    let
        d =
            norm p
    in
    Point.difference p center
        |> scale ((radius / d) ^ 2)
        |> Point.sum center

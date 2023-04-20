module Disk.Line.Equation exposing (Equation, on, throughOrigin)

import Disk.Point as Point exposing (Point, point)
import Tolerance


type Equation
    = Line { dx : Float, dy : Float, p : Point }


throughOrigin : Float -> Float -> Equation
throughOrigin =
    equation <| point 0 0


equation : Point -> Float -> Float -> Equation
equation p dx dy =
    Line { dx = dx, dy = dy, p = p }


on : Point -> Equation -> Bool
on q (Line { dx, dy, p }) =
    let
        z =
            Point.difference q p

        isOnLine x y =
            Tolerance.epsilon >= (abs <| -dy * x + dx * y)
    in
    Point.use isOnLine z

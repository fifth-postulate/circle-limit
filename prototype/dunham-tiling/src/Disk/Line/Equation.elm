module Disk.Line.Equation exposing (Equation, equation, intersection, on, throughOrigin)

import Disk.Point as Point exposing (Point, point)
import Matrix exposing (matrix)
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


intersection : Equation -> Equation -> Point
intersection (Line u) (Line v) =
    let
        ( ux, uy ) =
            Point.use Tuple.pair u.p

        ( vx, vy ) =
            Point.use Tuple.pair v.p

        ( t, s ) =
            matrix u.dx -v.dx u.dy -v.dy
                |> Matrix.inverse
                |> Matrix.apply ( vx - ux, vy - uy )
    in
    point (ux + t * u.dx) (uy + t * u.dy)

module Disk.Line exposing (Line, inversion, segment, view)

import Disk.Circle as Circle
import Disk.Line.Arc as Arc
import Disk.Line.Equation as Equation
import Disk.Line.Segment as Segment
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


type Line
    = Segment { a : Point, b : Point }
    | Arc { a : Point, b : Point }
    | Degenerate Point


segment : Point -> Point -> Line
segment a b =
    if not <| Point.similar a b then
        let
            ( ax, ay ) =
                Point.use Tuple.pair a

            ( bx, by ) =
                Point.use Tuple.pair b

            equation =
                Equation.throughOrigin (bx - ax) (by - ay)

            onLine p =
                Equation.on p equation
        in
        if onLine a || onLine b then
            Segment { a = a, b = b }

        else
            Arc { a = a, b = b }

    else
        Degenerate a


inversion : Line -> Point -> Point
inversion line p =
    case line of
        Segment { a, b } ->
            let
                equation =
                    Equation.through a b
            in
            Equation.inversion equation p

        Arc { a, b } ->
            let
                circle =
                    Circle.through a b
            in
            Circle.inversion circle p

        Degenerate a ->
            Point.difference p a
                |> Point.use (curry <| Tuple.mapBoth negate negate)
                |> uncurry Point.point
                |> Point.sum a


uncurry : (a -> b -> c) -> ( a, b ) -> c
uncurry f ( a, b ) =
    f a b


curry : (( a, b ) -> c) -> a -> b -> c
curry f a b =
    f ( a, b )


view : Line -> Svg msg
view aLine =
    case aLine of
        Segment { a, b } ->
            Segment.view a b

        Arc { a, b } ->
            Arc.view a b

        Degenerate p ->
            Point.view p

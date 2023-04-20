module Disk.Line exposing (Line, segment, view)

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


view : Line -> Svg msg
view aLine =
    case aLine of
        Segment { a, b } ->
            Segment.view a b

        Arc { a, b } ->
            Arc.view a b

        Degenerate p ->
            Point.view p

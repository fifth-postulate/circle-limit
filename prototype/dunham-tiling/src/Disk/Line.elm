module Disk.Line exposing (Line, segment, view)

import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


type Line
    = Segment { a : Point, b : Point }


segment : Point -> Point -> Line
segment a b =
    Segment { a = a, b = b }


view : Line -> Svg msg
view (Segment { a, b }) =
    let
        ( ax, ay ) =
            Point.use Tuple.pair a

        ( bx, by ) =
            Point.use Tuple.pair b
    in
    Svg.line
        [ x1 <| String.fromFloat ax
        , y1 <| String.fromFloat ay
        , x2 <| String.fromFloat bx
        , y2 <| String.fromFloat by
        ]
        []

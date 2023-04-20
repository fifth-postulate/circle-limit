module Disk.Line.Arc exposing (view)

import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


view : Point -> Point -> Svg msg
view a b =
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
        , stroke "red"
        ]
        []

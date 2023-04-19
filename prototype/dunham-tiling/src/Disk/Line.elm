module Disk.Line exposing (Line, segment, view)

import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)
import Tolerance


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

            ls =
                lineEquation (bx - ax) (by - ay)

            onLine p =
                isOn p ls
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
            viewSegment a b

        Arc { a, b } ->
            viewArc a b

        Degenerate p ->
            Point.view p


viewSegment : Point -> Point -> Svg msg
viewSegment a b =
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


viewArc : Point -> Point -> Svg msg
viewArc a b =
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


type alias LineEquation =
    { dx : Float
    , dy : Float
    }


lineEquation : Float -> Float -> LineEquation
lineEquation dx dy =
    { dx = dx, dy = dy }


isOn : Point -> LineEquation -> Bool
isOn p { dx, dy } =
    let
        isOnLine x y =
            Tolerance.epsilon >= (abs <| -dy * x + dx * y)
    in
    Point.use isOnLine p

module Disk.Line exposing (Line, segment, view)

import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


epsilon : Float
epsilon =
    0.00000001


type Line
    = Segment { a : Point, b : Point }
    | Degenerate Point


segment : Point -> Point -> Line
segment a b =
    if not <| Point.similar epsilon a b then
        Segment { a = a, b = b }

    else
        Degenerate a


view : Line -> Svg msg
view aLine =
    case aLine of
        Segment { a, b } ->
            let
                ( ax, ay ) =
                    Point.use Tuple.pair a

                ( bx, by ) =
                    Point.use Tuple.pair b

                ls =
                    lineEquation (bx - ax) (by - ay)

                onLine p =
                    isOn epsilon p ls
            in
            if onLine a || onLine b then
                Svg.line
                    [ x1 <| String.fromFloat ax
                    , y1 <| String.fromFloat ay
                    , x2 <| String.fromFloat bx
                    , y2 <| String.fromFloat by
                    ]
                    []

            else
                Svg.line
                    [ x1 <| String.fromFloat ax
                    , y1 <| String.fromFloat ay
                    , x2 <| String.fromFloat bx
                    , y2 <| String.fromFloat by
                    , stroke "red"
                    ]
                    []

        Degenerate p ->
            Point.view p


type alias LineEquation =
    { dx : Float
    , dy : Float
    }


lineEquation : Float -> Float -> LineEquation
lineEquation dx dy =
    { dx = dx, dy = dy }


isOn : Float -> Point -> LineEquation -> Bool
isOn tolerance p { dx, dy } =
    let
        isOnLine x y =
            tolerance >= (abs <| -dy * x + dx * y)
    in
    Point.use isOnLine p

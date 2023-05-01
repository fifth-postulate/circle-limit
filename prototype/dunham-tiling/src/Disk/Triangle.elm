module Disk.Triangle exposing (Triangle, inversion, triangle, view)

import Disk.Line as Line exposing (Line, segment)
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


type Triangle
    = Triangle { a : Point, b : Point, c : Point }


triangle : Point -> Point -> Point -> Triangle
triangle a b c =
    Triangle { a = a, b = b, c = c }


inversion : Line -> Triangle -> Triangle
inversion line (Triangle { a, b, c }) =
    let
        t p =
            Line.inversion line p
    in
    triangle (t a) (t c) (t b)


view : Triangle -> Svg msg
view (Triangle { a, b, c }) =
    Svg.g [ stroke "gray", strokeWidth "0.005" ]
        [ Svg.g [] <| List.map Line.view [ segment a b, segment b c, segment a c ]
        , Svg.g [] <| List.map Point.view [ a, b, c ]
        ]

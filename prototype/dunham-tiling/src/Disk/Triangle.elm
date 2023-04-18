module Disk.Triangle exposing (Triangle, triangle, view)

import Disk.Line as Line exposing (segment)
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


type Triangle
    = Triangle { a : Point, b : Point, c : Point }


triangle : Point -> Point -> Point -> Triangle
triangle a b c =
    Triangle { a = a, b = b, c = c }


view : Triangle -> Svg msg
view (Triangle { a, b, c }) =
    Svg.g []
        [ Svg.g [ stroke "black", strokeWidth "0.001" ] <| List.map Line.view [ segment a b, segment b c, segment c a ]
        , Svg.g [] <| List.map Point.view [ a, b, c ]
        ]

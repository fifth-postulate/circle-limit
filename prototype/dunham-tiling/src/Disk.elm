module Disk exposing (Disk, empty, view)

import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes as Attribute exposing (..)


type Disk
    = Disk
        { points : List Point
        }


empty : Disk
empty =
    Disk { points = [] }


type Point
    = Point { x : Float, y : Float }


view : Disk -> Svg msg
view (Disk model) =
    let
        epsilon =
            0.005
    in
    Svg.svg
        [ width "640"
        , height "640"
        , Attribute.viewBox <| viewBox epsilon
        ]
        [ limitCircle
        , Svg.g [ strokeWidth "0.01" ] <| List.map viewPoint model.points
        ]


viewBox : Float -> String
viewBox epsilon =
    [ -1 - epsilon, -1 - epsilon, 2 + 2 * epsilon, 2 + 2 * epsilon ]
        |> List.map String.fromFloat
        |> String.join " "


limitCircle : Svg msg
limitCircle =
    Svg.circle
        [ cx "0"
        , cy "0"
        , r "1"
        , fill "none"
        , stroke "gray"
        , strokeWidth "0.001"
        ]
        []


viewPoint : Point -> Svg msg
viewPoint (Point { x, y }) =
    let
        centerX =
            x
                |> String.fromFloat

        centerY =
            y
                |> String.fromFloat
    in
    Svg.circle [ cx centerX, cy centerY, r "0.01" ] []

module Disk.Line.Arc exposing (view)

import Disk.Line.Equation as Equation exposing (Equation, equation)
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


view : Point -> Point -> Svg msg
view a b =
    let
        c =
            Point.inversion a

        ab =
            bisector a b

        ac =
            bisector a c

        o =
            Equation.intersection ab ac

        ( centerX, centerY ) =
            Point.use Tuple.pair o

        radius =
            Point.norm <| Point.difference a o

        pathDescription =
            [ Point.use Moveto a
            , Point.use (Arc radius) b
            ]
                |> toString
    in
    Svg.g []
        [ Svg.circle
            [ cx <| String.fromFloat centerX
            , cy <| String.fromFloat centerY
            , r <| String.fromFloat radius
            , fill "none"
            , stroke "red"
            ]
            []
        , Svg.path
            [ stroke "blue"
            , fill "none"
            , d pathDescription
            ]
            []
        ]


midpoint : Point -> Point -> Point
midpoint a b =
    Point.sum a b
        |> Point.scale (1 / 2)


bisector : Point -> Point -> Equation
bisector a b =
    let
        ( dx, dy ) =
            Point.use Tuple.pair <| Point.difference b a
    in
    equation (midpoint a b) -dy dx


type alias Path =
    List PathElement


type PathElement
    = Moveto Float Float
    | Arc Float Float Float


toString : Path -> String
toString ps =
    let
        toS p =
            case p of
                Moveto x y ->
                    "M" ++ (String.join "," <| List.map String.fromFloat [ x, y ])

                Arc radius x y ->
                    "A" ++ (String.join " " <| List.map String.fromFloat [ radius, radius, 0, 0, 0, x, y ])
    in
    ps
        |> List.map toS
        |> String.join " "

module Disk.Line.Arc exposing (view)

import Disk.Circle as Circle
import Disk.Line.Equation as Equation exposing (Equation, equation)
import Disk.Point as Point exposing (Point)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes exposing (..)


view : Point -> Point -> Svg msg
view a b =
    let
        c =
            Circle.inversion Circle.unit a

        ab =
            bisector a b

        ac =
            bisector a c

        o =
            Equation.intersection ab ac

        angle_a =
            Point.difference a o
                |> Point.use toAngle

        angle_b =
            Point.difference b o
                |> Point.use toAngle

        radius =
            Point.norm <| Point.difference a o

        pathDescription =
            [ Point.use Moveto a
            , Point.use (Arc radius) b <| determineFlag angle_a angle_b
            ]
                |> toString
    in
    Svg.path
        [ fill "none"
        , d pathDescription
        ]
        []


toAngle : Float -> Float -> Float
toAngle x y =
    atan2 y x


determineFlag : Float -> Float -> SweepFlag
determineFlag a b =
    let
        angle =
            normalize (b - a)
    in
    case compare angle pi of
        LT ->
            CounterClockWise

        EQ ->
            CounterClockWise

        GT ->
            ClockWise


normalize : Float -> Float
normalize angle =
    if angle < 0 then
        normalize (angle + 2 * pi)

    else if angle > 2 * pi then
        normalize (angle - 2 * pi)

    else
        angle


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
    | Arc Float Float Float SweepFlag


type SweepFlag
    = ClockWise
    | CounterClockWise


sweepFlag : SweepFlag -> Float
sweepFlag flag =
    case flag of
        ClockWise ->
            0

        CounterClockWise ->
            1


toString : Path -> String
toString ps =
    let
        toS p =
            case p of
                Moveto x y ->
                    "M" ++ (String.join "," <| List.map String.fromFloat [ x, y ])

                Arc radius x y flag ->
                    "A" ++ (String.join " " <| List.map String.fromFloat [ radius, radius, 0, 0, sweepFlag flag, x, y ])
    in
    ps
        |> List.map toS
        |> String.join " "

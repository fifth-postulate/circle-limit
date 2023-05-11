module Shafli exposing (Shafli, shafli, toDisk)

import Disk exposing (Disk)
import Disk.Line exposing (segment)
import Disk.Point exposing (Point, point)
import Disk.Triangle as Triangle exposing (triangle)
import Enumeration.Naive as Naive


type Shafli
    = Shafli { n : Int, k : Int }


shafli : Int -> Int -> Maybe Shafli
shafli n k =
    let
        angleDeficiency =
            (1 / toFloat n) + (1 / toFloat k)
    in
    if angleDeficiency < 0.5 then
        Just <| Shafli { n = n, k = k }

    else
        Nothing


toDisk : Shafli -> Disk
toDisk (Shafli { n, k }) =
    let
        angleA =
            pi / toFloat n

        angleB =
            pi / toFloat k

        angleC =
            pi / 2

        sinA =
            sin angleA

        sinB =
            sin angleB

        r =
            sin (angleC - angleA - angleB) / sqrt (1 - sinA * sinA - sinB * sinB)

        angle =
            2 * angleA

        toPoint index =
            circlePoint r <| angle * toFloat index

        o =
            point 0 0

        a =
            toPoint 0

        b =
            toPoint 1

        t =
            triangle o a b

        oa =
            Triangle.inversion (segment o a)

        ab =
            Triangle.inversion (segment a b)

        ob =
            Triangle.inversion (segment o b)

        transformations =
            Naive.generatedBy 6 [ oa, ab, ob ]
    in
    transformations
        |> List.map (\f -> f t)
        |> List.foldl Disk.addTriangle Disk.empty


circlePoint : Float -> Float -> Point
circlePoint radius angle =
    point (radius * cos angle) (radius * sin angle)

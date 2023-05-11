module Shafli exposing (Shafli, shafli, toDisk)

import Disk exposing (Disk)
import Disk.Line exposing (segment)
import Disk.Point exposing (Point, point)
import Disk.Triangle as Triangle exposing (triangle)


type Shafli
    = Shafli { n : Int, k : Int }


shafli : Int -> Int -> Shafli
shafli n k =
    Shafli { n = n, k = k }


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
            [ -- first corona
              identity
            , ob
            , oa
            , oa >> ob
            , ob >> oa
            , ob >> oa >> ob

            -- oa >> ob >> oa
            -- second corona
            , ab
            , ab >> ob
            , ab >> oa
            , ab >> oa >> ob
            , ab >> ob >> oa
            , ab >> ob >> oa >> ob

            -- third corona
            , ob >> ab
            , oa >> ab
            , ob >> ab >> ob
            , oa >> ab >> ob
            , ob >> ab >> oa
            , oa >> ab >> oa
            , ob >> ab >> oa >> ob
            , oa >> ab >> oa >> ob
            , ob >> ab >> ob >> oa
            , oa >> ab >> ob >> oa
            , ob >> ab >> ob >> oa >> ob
            , oa >> ab >> ob >> oa >> ob

            -- fourth corona
            , oa >> ob >> ab
            , ab >> ob >> ab
            , ob >> oa >> ab
            , ab >> oa >> ab
            , oa >> ob >> ab >> ob
            , ab >> ob >> ab >> ob
            , ob >> oa >> ab >> ob
            , ab >> oa >> ab >> ob
            , oa >> ob >> ab >> oa
            , ab >> ob >> ab >> oa
            , ob >> oa >> ab >> oa
            , ab >> oa >> ab >> oa
            , oa >> ob >> ab >> oa >> ob
            , ab >> ob >> ab >> oa >> ob
            , ob >> oa >> ab >> oa >> ob
            , ab >> oa >> ab >> oa >> ob
            , oa >> ob >> ab >> ob >> oa
            , ab >> ob >> ab >> ob >> oa
            , ob >> oa >> ab >> ob >> oa
            , ab >> oa >> ab >> ob >> oa
            , oa >> ob >> ab >> ob >> oa >> ob
            , ab >> ob >> ab >> ob >> oa >> ob
            , ob >> oa >> ab >> ob >> oa >> ob
            , ab >> oa >> ab >> ob >> oa >> ob
            ]
    in
    transformations
        |> List.map (\f -> f t)
        |> List.foldl Disk.addTriangle Disk.empty


circlePoint : Float -> Float -> Point
circlePoint radius angle =
    point (radius * cos angle) (radius * sin angle)

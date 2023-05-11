module Tiling exposing (main)

import Browser
import Css exposing (..)
import Disk exposing (Disk)
import Disk.Line exposing (segment)
import Disk.Point exposing (Point, point)
import Disk.Triangle as Triangle exposing (triangle)
import Html.Styled as Html exposing (Html)


main =
    Browser.element
        { init = init
        , view = view >> Html.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        n =
            4

        k =
            6

        angleA =
            pi / n

        angleB =
            pi / 7

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

        disk =
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
                |> List.map (\f -> f t)
                |> List.foldl Disk.addTriangle Disk.empty
    in
    ( { disk = disk }, Cmd.none )


circlePoint : Float -> Float -> Point
circlePoint radius angle =
    point (radius * cos angle) (radius * sin angle)


type alias Model =
    { disk : Disk }


view : Model -> Html Msg
view model =
    Html.section []
        [ Html.h1 [] [ Html.text "Hyperbolic Tiling" ]
        , Disk.view model.disk
        ]


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

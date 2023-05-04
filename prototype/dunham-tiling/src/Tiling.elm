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
        r =
            0.5

        n =
            6

        angle =
            2 * pi / toFloat n

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
            [ identity
            , ab
            , ob
            , oa >> ob
            , ob >> oa
            , ab >> ob
            , ab >> oa
            , ab >> oa
            , oa >> ob >> oa
            , ab >> ob >> oa
            , ab >> oa >> ob
            , ab >> oa >> ob >> oa
            , ob >> ab
            , ob >> ab >> oa
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

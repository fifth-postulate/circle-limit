module Tiling exposing (main)

import Browser
import Css exposing (..)
import Disk exposing (Disk)
import Disk.Point exposing (Point, point)
import Disk.Triangle exposing (triangle)
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
        o =
            point 0 0

        r =
            0.5

        n =
            6

        angle =
            2 * pi / toFloat n

        toPoint a =
            circlePoint r <| angle * toFloat a

        toTriangle ( a, b ) =
            triangle o a b

        triangles =
            List.range 0 n
                |> List.map (\i -> ( i, i + 1 ))
                |> List.map (Tuple.mapBoth toPoint toPoint)
                |> List.map toTriangle

        disk =
            List.foldl Disk.addTriangle Disk.empty triangles
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

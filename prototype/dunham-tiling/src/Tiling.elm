module Tiling exposing (main)

import Browser
import Css exposing (..)
import Disk exposing (Disk)
import Disk.Point exposing (point)
import Disk.Triangle exposing (triangle)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute


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
        fundamental =
            triangle (point 0 0) (point 0.25 0) (point 0.25 0.1) 

        disk =
            Disk.empty
                |> Disk.addTriangle fundamental
    in
    ( { disk = disk }, Cmd.none )


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

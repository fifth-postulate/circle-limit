module PoincareDiskModel exposing (main)

import Browser
import Construction exposing (Construction, definePoint)
import Construction.Point exposing (point)
import Html exposing (Html)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        construction =
            Construction.empty
                |> definePoint (point 0 0)
                |> definePoint (point 1 0)
    in
    ( { construction = construction }, Cmd.none )


type alias Model =
    { construction : Construction }


view : Model -> Html Msg
view model =
    Html.section []
        [ Html.h1 [] [ Html.text "Geometric Constructions" ]
        , Construction.view model.construction
        ]


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

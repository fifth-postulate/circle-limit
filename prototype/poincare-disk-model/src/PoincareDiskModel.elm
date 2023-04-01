module PoincareDiskModel exposing (main)

import Browser
import Construction exposing (Construction, definePoint, line)
import Construction.Name exposing (Name(..))
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
                |> try (line (Point 0) (Point 1))
    in
    ( { construction = construction }, Cmd.none )


try : (a -> Result e a) -> a -> a
try operation subject =
    operation subject
        |> Result.withDefault subject


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

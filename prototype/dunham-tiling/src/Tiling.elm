module Tiling exposing (main)

import Browser
import Css exposing (..)
import Disk exposing (Disk)
import Disk.Line exposing (segment)
import Disk.Point exposing (Point, point)
import Disk.Triangle as Triangle exposing (triangle)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import Shafli exposing (Shafli, shafli)


main =
    Browser.element
        { init = init
        , view = view >> Html.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { n : String, k : String }


toShafli : Model -> Maybe Shafli
toShafli { n, k } =
    case ( String.toInt n, String.toInt k ) of
        ( Just d, Just a ) ->
            Just <| shafli d a

        _ ->
            Nothing


init : () -> ( Model, Cmd Msg )
init _ =
    ( { n = "5", k = "4" }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.section []
        [ Html.h1 [] [ Html.text "Hyperbolic Tiling" ]
        , viewControls model
        , viewShafli model
        ]


viewControls : Model -> Html Msg
viewControls { n, k } =
    Html.div []
        [ Html.span [ Attribute.for "n" ] [ Html.text "n:" ]
        , Html.input [ Attribute.type_ "text", Attribute.value n, Event.onInput UpdateN ] []
        , Html.span [ Attribute.for "k" ] [ Html.text "k:" ]
        , Html.input [ Attribute.id "k", Attribute.type_ "text", Attribute.value k, Event.onInput UpdateK ] []
        ]


viewShafli : Model -> Html msg
viewShafli model =
    case toShafli model of
        Just shafli ->
            Disk.view <| Shafli.toDisk shafli

        Nothing ->
            viewProblem


viewProblem : Html msg
viewProblem =
    Html.p [] [ Html.text "Could not create a tiling" ]


type Msg
    = UpdateN String
    | UpdateK String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateN n ->
            ( { model | n = n }, Cmd.none )

        UpdateK k ->
            ( { model | k = k }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

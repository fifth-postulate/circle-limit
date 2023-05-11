module Tiling exposing (main)

import Browser
import Css exposing (..)
import Disk
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


toShafli : Model -> Result Error Shafli
toShafli { n, k } =
    case ( String.toInt n, String.toInt k ) of
        ( Just d, Just a ) ->
            shafli d a
                |> Result.fromMaybe NotHyperbolic

        ( Nothing, Just _ ) ->
            Err <| NotInteger [ ( N, n ) ]

        ( Just _, Nothing ) ->
            Err <| NotInteger [ ( K, k ) ]

        ( Nothing, Nothing ) ->
            Err <| NotInteger [ ( N, n ), ( K, k ) ]


type Error
    = NotInteger (List ( Argument, String ))
    | NotHyperbolic


type Argument
    = N
    | K


init : () -> ( Model, Cmd Msg )
init _ =
    ( { n = "9", k = "5" }, Cmd.none )


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
        Ok shafli ->
            Disk.view <| Shafli.toDisk shafli

        Err error ->
            viewProblem error


viewProblem : Error -> Html msg
viewProblem error =
    let
        toDescription ( argument, _ ) =
            case argument of
                N ->
                    "n"

                K ->
                    "k"

        description =
            case error of
                NotInteger problems ->
                    "not integer: " ++ (String.join ", " <| List.map toDescription problems)

                NotHyperbolic ->
                    "not hyperbolic"
    in
    Html.p [] [ Html.text <| "Could not create a tiling: " ++ description ]


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

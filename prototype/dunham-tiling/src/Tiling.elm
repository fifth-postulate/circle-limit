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


main =
    Browser.element
        { init = init
        , view = view >> Html.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { n : String, k : String }


type alias Shafli =
    { n : Int, k : Int }


toShafli : Model -> Maybe Shafli
toShafli { n, k } =
    case ( String.toInt n, String.toInt k ) of
        ( Just d, Just a ) ->
            Just { n = d, k = a }

        _ ->
            Nothing


init : () -> ( Model, Cmd Msg )
init _ =
    ( { n = "5", k = "4" }, Cmd.none )


circlePoint : Float -> Float -> Point
circlePoint radius angle =
    point (radius * cos angle) (radius * sin angle)


toDisk : Shafli -> Disk
toDisk { n, k } =
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
            Disk.view <| toDisk shafli

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

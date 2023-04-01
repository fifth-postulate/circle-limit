module Construction.Name exposing (Name(..), Named, isLine, isPoint, toString, view)

import Html exposing (Html)


type alias Named a =
    ( Name, a )


type Name
    = Point Int
    | Line Int


isPoint : Name -> Bool
isPoint name =
    case name of
        Point _ ->
            True

        _ ->
            False


isLine : Name -> Bool
isLine name =
    case name of
        Line _ ->
            True

        _ ->
            False


toString : Name -> String
toString name =
    let
        identifier =
            case name of
                Point _ ->
                    "P"

                Line _ ->
                    "l"

        index =
            case name of
                Point i ->
                    i

                Line i ->
                    i
    in
    identifier ++ String.fromInt index


view : Name -> Html msg
view =
    toString >> Html.text

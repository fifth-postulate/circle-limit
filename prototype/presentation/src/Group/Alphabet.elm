module Group.Alphabet exposing (Alphabet, inverse, isInverse, letter, view)

import Html exposing (Html)


type Alphabet
    = Exact Symbol
    | Inverse Symbol


type alias Symbol =
    { symbol : Char }


toSymbol : Alphabet -> Symbol
toSymbol c =
    case c of
        Exact symbol ->
            symbol

        Inverse symbol ->
            symbol


letter : Char -> Alphabet
letter symbol =
    Exact { symbol = symbol }


inverse : Char -> Alphabet
inverse symbol =
    Inverse { symbol = symbol }


isInverse : Alphabet -> Alphabet -> Bool
isInverse u v =
    case ( u, v ) of
        ( Exact a, Inverse b ) ->
            a.symbol == b.symbol

        ( Inverse a, Exact b ) ->
            a.symbol == b.symbol

        _ ->
            False


view : Int -> Alphabet -> Html msg
view exponent c =
    let
        head =
            c
                |> toSymbol
                |> .symbol
                |> String.fromChar
                |> Html.text

        e =
            case c of
                Exact _ ->
                    exponent

                Inverse _ ->
                    -1 * exponent

        tail =
            case e of
                1 ->
                    []

                _ ->
                    [ Html.sup [] [ Html.text <| String.fromInt e ] ]
    in
    Html.span [] <| head :: tail

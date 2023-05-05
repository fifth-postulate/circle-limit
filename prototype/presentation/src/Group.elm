module Group exposing (main)

import Group.Alphabet as Alphabet exposing (Alphabet)
import Group.Word as Word exposing (Word)
import Html exposing (Html)


main =
    let
        a =
            Alphabet.letter 'a'

        a_ =
            Alphabet.inverse 'a'

        b =
            Alphabet.letter 'b'

        b_ =
            Alphabet.inverse 'b'

        l =
            [ a, b_, b_, a, a, b, a_ ]

        r =
            [ a, b_, a_, a_, b, b, a_ ]

        left =
            Word.fromLetters l

        right =
            Word.fromLetters r

        product =
            Word.multiply left right
    in
    Html.div []
        [ Word.view left
        , Html.text "×"
        , Word.view right
        , Html.text "="
        , Word.view product
        ]

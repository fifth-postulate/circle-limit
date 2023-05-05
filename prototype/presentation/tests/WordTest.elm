module WordTest exposing (..)

import AlphabetTest exposing (letter)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list)
import Group.Alphabet as Alphabet exposing (Alphabet)
import Group.Word as Word exposing (Word)
import Test exposing (..)


suite : Test
suite =
    describe "Group"
        [ describe "Word"
            [ describe "fromLetters"
                [ test "aBAAaabA is the empty word" <|
                    \_ ->
                        let
                            a =
                                Alphabet.letter 'a'

                            a_ =
                                Alphabet.inverse 'a'

                            b =
                                Alphabet.letter 'b'

                            b_ =
                                Alphabet.inverse 'b'

                            actual =
                                [ a, b_, a_, a_, a, a, b, a_ ]
                                    |> Word.fromLetters
                        in
                        Expect.equal Word.empty actual
                ]
            , describe "multiplication"
                [ fuzz word "empty word is left identity" <|
                    \w ->
                        Expect.equal w <| Word.multiply Word.empty w
                , fuzz word "empty word is right identity" <|
                    \w ->
                        Expect.equal w <| Word.multiply w Word.empty
                , fuzz word "multuplication with inverse is identity" <|
                    \w ->
                        let
                            w_ =
                                Word.inverse w
                        in
                        Expect.equal Word.empty <| Word.multiply w w_
                ]
            ]
        ]


word : Fuzzer Word
word =
    list letter
        |> Fuzz.map Word.fromLetters

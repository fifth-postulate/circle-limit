module AlphabetTest exposing (letter)

import Fuzz exposing (Fuzzer, char)
import Group.Alphabet as Alphabet exposing (Alphabet)


letter : Fuzzer Alphabet
letter =
    let
        constructor =
            Fuzz.oneOfValues [ Alphabet.letter, Alphabet.inverse ]
    in
    Fuzz.map2 apply constructor char


apply : (a -> b) -> a -> b
apply f a =
    f a

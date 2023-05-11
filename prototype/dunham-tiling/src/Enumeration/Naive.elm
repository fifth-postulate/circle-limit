module Enumeration.Naive exposing (generatedBy)


generatedBy : Int -> List (a -> a) -> List (a -> a)
generatedBy n generators =
    let
        g =
            1 + List.length generators
    in
    List.range 0 ((g ^ n) - 1)
        |> List.map (toTransformation n generators)


toTransformation : Int -> List (a -> a) -> Int -> (a -> a)
toTransformation =
    tailrec_toTransformation identity


tailrec_toTransformation : (a -> a) -> Int -> List (a -> a) -> Int -> (a -> a)
tailrec_toTransformation acc n generators index =
    if n == 0 then
        acc

    else
        let
            g =
                1 + List.length generators

            f =
                case modBy g index of
                    0 ->
                        identity

                    d ->
                        generators
                            |> List.drop (d - 1)
                            |> List.head
                            |> Maybe.withDefault identity
        in
        tailrec_toTransformation (acc >> f) (n - 1) generators (index // g)

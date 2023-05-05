module Group.Word exposing (Word, empty, fromLetters, inverse, multiply, view)

import Group.Alphabet as Alphabet exposing (Alphabet)
import Html exposing (Html)
import List exposing (head)


type Word
    = Empty
    | Sequence
        { head : Multiplicity Alphabet
        , prefix : List (Multiplicity Alphabet)
        }


type alias Multiplicity a =
    ( a, Int )


one : a -> Multiplicity a
one a =
    ( a, 1 )


empty : Word
empty =
    Empty


fromLetters : List Alphabet -> Word
fromLetters =
    List.map one >> reduce


reduce : List (Multiplicity Alphabet) -> Word
reduce ds =
    case ds of
        [] ->
            Empty

        c :: cs ->
            tailrec_reduce [] c cs


tailrec_reduce : List (Multiplicity Alphabet) -> Multiplicity Alphabet -> List (Multiplicity Alphabet) -> Word
tailrec_reduce prefix (( s, d ) as head) cs =
    case cs of
        [] ->
            if d == 0 then
                case prefix of
                    [] ->
                        Empty

                    h :: hs ->
                        Sequence
                            { head = h
                            , prefix = List.reverse hs
                            }

            else
                Sequence
                    { head = head
                    , prefix = List.reverse prefix
                    }

        (( t, e ) as h) :: ts ->
            if t == s then
                tailrec_reduce prefix ( s, d + e ) ts

            else if Alphabet.isInverse t s then
                tailrec_reduce prefix ( s, d - e ) ts

            else if d == 0 then
                case prefix of
                    [] ->
                        tailrec_reduce prefix h ts

                    p :: ps ->
                        tailrec_reduce ps p (h :: ts)

            else
                tailrec_reduce (head :: prefix) h ts


multiply : Word -> Word -> Word
multiply left right =
    case ( left, right ) of
        ( Empty, _ ) ->
            right

        ( _, Empty ) ->
            left

        ( Sequence l, Sequence r ) ->
            reduce <|
                List.concat
                    [ l.prefix
                    , [ l.head ]
                    , r.prefix
                    , [ r.head ]
                    ]


inverse : Word -> Word
inverse word =
    case word of
        Empty ->
            Empty

        Sequence w ->
            [ w.prefix, [ w.head ] ]
                |> List.concat
                |> List.reverse
                |> List.map (Tuple.mapSecond negate)
                |> reduce


view : Word -> Html msg
view word =
    case word of
        Empty ->
            Html.text "ɛ"

        Sequence { prefix, head } ->
            head
                |> List.singleton
                |> List.append prefix
                |> List.map (\( c, d ) -> Alphabet.view d c)
                |> Html.span []

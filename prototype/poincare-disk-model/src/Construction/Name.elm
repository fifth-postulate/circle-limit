module Construction.Name exposing (Name, Named, is, name, toString, view)

import Html exposing (Html)


type alias Named a b =
    ( Name a, b )


type Name a
    = Indexed a Int


name : a -> Int -> Name a
name =
    Indexed


is : a -> Name a -> Bool
is target (Indexed actual _) =
    target == actual


toString : (a -> String) -> Name a -> String
toString identifier (Indexed a index) =
    identifier a ++ String.fromInt index


view : (a -> String) -> Name a -> Html msg
view representation =
    (toString representation) >> Html.text

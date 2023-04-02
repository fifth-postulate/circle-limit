module Construction.Type exposing (Type(..), toString)


type Type
    = Point
    | Line


toString : Type -> String
toString t =
    case t of
        Point ->
            "P"

        Line ->
            "l"

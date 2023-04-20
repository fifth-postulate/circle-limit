module Matrix exposing (apply, inverse, matrix)


type Matrix
    = Matrix { a : Float, b : Float, c : Float, d : Float }


matrix : Float -> Float -> Float -> Float -> Matrix
matrix a b c d =
    Matrix { a = a, b = b, c = c, d = d }


determinant : Matrix -> Float
determinant (Matrix { a, b, c, d }) =
    a * d - b * c


scale : Float -> Matrix -> Matrix
scale f (Matrix { a, b, c, d }) =
    matrix (f * a) (f * b) (f * c) (f * d)


inverse : Matrix -> Matrix
inverse ((Matrix { a, b, c, d }) as m) =
    let
        det =
            determinant m
    in
    matrix d -b -c a
        |> scale (1 / det)


apply : ( Float, Float ) -> Matrix -> ( Float, Float )
apply ( x, y ) (Matrix { a, b, c, d }) =
    ( a * x + b * y, c * x + d * y )

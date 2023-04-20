module Disk exposing (Disk, addTriangle, empty, view)

import Disk.Triangle as Triangle exposing (Triangle)
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes as Attribute exposing (..)


type Disk
    = Disk
        { triangles : List Triangle
        }


empty : Disk
empty =
    Disk { triangles = [] }


addTriangle : Triangle -> Disk -> Disk
addTriangle t (Disk { triangles }) =
    Disk { triangles = t :: triangles }


view : Disk -> Svg msg
view (Disk model) =
    let
        epsilon =
            0.005

        viewBox =
            [ -1 - epsilon, -1 - epsilon, 2 + 2 * epsilon, 2 + 2 * epsilon ]
                |> List.map String.fromFloat
                |> String.join " "
    in
    Svg.svg
        [ width "640"
        , height "640"
        , Attribute.viewBox viewBox
        ]
        [ viewLimitCircle
        , viewTriangles model.triangles
        ]


viewLimitCircle : Svg msg
viewLimitCircle =
    Svg.circle
        [ cx "0"
        , cy "0"
        , r "1"
        , fill "none"
        , stroke "gray"
        , strokeWidth "0.001"
        ]
        []


viewTriangles : List Triangle -> Svg msg
viewTriangles ts =
    Svg.g [ strokeWidth "0.01" ] <| List.map Triangle.view ts

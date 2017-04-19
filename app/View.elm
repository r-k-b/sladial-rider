module View exposing (view)

import Types
    exposing
        ( Model
        , Msg(DragStart)
        )
import Mouse exposing (Position)
import Html exposing (Html, div, text, Attribute)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode
import Mouse exposing (Position)


(=>) =
    (,)


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)


view : Model -> Html Msg
view model =
    let
        realPosition =
            getPosition model
    in
        div
            [ onMouseDown
            , style
                [ "background-color" => "#3C8D2F"
                , "cursor" => "move"
                , "width" => "100px"
                , "height" => "100px"
                , "border-radius" => "4px"
                , "position" => "absolute"
                , "left" => px realPosition.x
                , "top" => px realPosition.y
                , "color" => "white"
                , "display" => "flex"
                , "align-items" => "center"
                , "justify-content" => "center"
                ]
            ]
            [ text "Drag Me!"
            ]


px : Int -> String
px number =
    toString number ++ "px"


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Decode.map DragStart Mouse.position)

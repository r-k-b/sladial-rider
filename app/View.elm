module View exposing (view)

import Types
    exposing
        ( Model
        , Msg(DragStart)
        , Slider
        )
import Mouse exposing (Vector)
import Html exposing (Html, div, text, Attribute, pre, code)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode
import Mouse exposing (Vector)


(=>) =
    (,)


slider : Slider -> Html Msg
slider s =
    div
        [ onMouseDown
        , style
            [ "background-color" => "#3C8D2F"
            , "cursor" => "move"
            , "width" => "100px"
            , "height" => "100px"
            , "border-radius" => "4px"
            , "position" => "absolute"
            , "left" => px s.origin.x
            , "top" => px s.origin.y
            , "transform" => rotate s.actualAngle
            , "color" => "white"
            , "display" => "flex"
            , "align-items" => "center"
            , "justify-content" => "center"
            , "user-select" => "none"
            ]
        ]
        [ text "Spin Me!"
        ]


sliderDebug : Slider -> Html Msg
sliderDebug s =
    pre
        [ style
            [ "user-select" => "none" ]
        ]
        [ code []
            [ text <| toString s
            ]
        ]


draggable : Vector -> Html Msg
draggable p =
    div
        [ onMouseDown
        , style
            [ "background-color" => "blue"
            , "cursor" => "move"
            , "width" => "100px"
            , "height" => "100px"
            , "border-radius" => "4px"
            , "position" => "absolute"
            , "left" => px p.x
            , "top" => px p.y
            , "color" => "white"
            , "display" => "flex"
            , "align-items" => "center"
            , "justify-content" => "center"
            , "user-select" => "none"
            ]
        ]
        [ text "Drag Me!"
        ]


view : Model -> Html Msg
view model =
    div []
        -- [ draggable realPosition
        [ slider model.slider
        , sliderDebug model.slider
        ]


px : Int -> String
px number =
    toString number ++ "px"


rotate : Float -> String
rotate angle =
    "rotate(" ++ toString angle ++ "rad)"


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Decode.map DragStart Mouse.position)

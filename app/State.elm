module State
    exposing
        ( init
        , update
        , updateHelp
        , subscriptions
        )

import Types
    exposing
        ( Angle
        , Drag
        , Model
        , Msg
            ( DragStart
            , DragAt
            , DragEnd
            )
        , Slider
        )
import Mouse exposing (Vector)


emptySlider =
    { origin = Vector 300 300
    , originToCenter = Vector 50 50
    , angleA = turns 0.001
    , angleB = turns 0
    , maxθ = turns 1
    , minθ = turns 0
    , damping = 0.01
    , inertia = 0.5
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        Nothing
        emptySlider
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg ({ drag, slider } as model) =
    let
        getAng =
            getAngle <| vectorAdd slider.origin slider.originToCenter
    in
        case msg of
            DragStart xy ->
                Model
                    (Just { prior = getAng xy, current = getAng xy })
                    slider

            DragAt xy ->
                Model
                    (Maybe.map (\{ current } -> Drag current <| getAng xy) drag)
                    (rotateSlider slider <| getAng xy)

            DragEnd _ ->
                Model
                    Nothing
                    slider


getAngle : Vector -> Vector -> Angle
getAngle a b =
    let
        vec =
            vectorSubtract a b

        ( r, θ ) =
            toPolar
                ( toFloat vec.x, toFloat vec.y )
    in
        θ


rotateSlider : Slider -> Angle -> Slider
rotateSlider s ang =
    { s | angleA = ang }


vectorAdd : Vector -> Vector -> Vector
vectorAdd a b =
    { x = a.x + b.x
    , y = a.y + b.y
    }


vectorSubtract : Vector -> Vector -> Vector
vectorSubtract a b =
    { x = a.x - b.x
    , y = a.y - b.y
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

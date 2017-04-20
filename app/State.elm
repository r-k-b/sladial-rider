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
    , actualAngle = turns 0
    , targetAngle = turns 0
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
                case drag of
                    Nothing ->
                        Model
                            Nothing
                            slider

                    Just drag ->
                        Model
                            (Just { prior = drag.current, current = getAng xy })
                            (rotateSlider slider <| normalisedAngle (getAng xy) drag.current)

            DragEnd _ ->
                Model
                    Nothing
                    (snapBack slider)


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
    let
        newTarget =
            s.targetAngle + ang

        newActual =
            clamp s.minθ s.maxθ newTarget
    in
        { s
            | actualAngle = newActual
            , targetAngle = newTarget
        }


{-| Reset the target angle (if it's out of range) once the user releases it.
-}
snapBack : Slider -> Slider
snapBack s =
    { s | targetAngle = s.actualAngle }


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


{-| Get the normalised difference between two angles.
Will be between -0.25 turns and +0.25 turns.
[(atan2 @ wikipedia)][https://en.wikipedia.org/wiki/Atan2]
-}
normalisedAngle : Angle -> Angle -> Angle
normalisedAngle a b =
    let
        diff =
            a - b
    in
        atan2 (sin diff) (cos diff)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

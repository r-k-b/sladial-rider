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
import Mouse exposing (Position)


emptySlider =
    { center = Position 300 300
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
    case msg of
        DragStart xy ->
            Model
                (Just <| getAngle slider.center xy <| getAngle slider.center xy)
                slider

        DragAt xy ->
            Model
                (Maybe.map (\{ current } -> Drag current (getAngle slider.center xy)) drag)
                slider

        DragEnd _ ->
            Model
                Nothing
                slider


getAngle : Position -> Position -> Angle
getAngle a b =
    let
        ( r, θ ) =
            toPolar
                ( toFloat a.x, toFloat a.y )
                ( toFloat b.x, toFloat b.y )
    in
        θ



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

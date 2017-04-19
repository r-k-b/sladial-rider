module State
    exposing
        ( init
        , getPosition
        , update
        , updateHelp
        , subscriptions
        )

import Types
    exposing
        ( Model
        , Drag
        , Msg
            ( DragStart
            , DragAt
            , DragEnd
            )
        )
import Mouse exposing (Position)


init : ( Model, Cmd Msg )
init =
    ( Model (Position 200 200) Nothing, Cmd.none )



-- UPDATE


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg ({ position, drag } as model) =
    case msg of
        DragStart xy ->
            Model position (Just (Drag xy xy))

        DragAt xy ->
            Model position (Maybe.map (\{ start } -> Drag start xy) drag)

        DragEnd _ ->
            Model (getPosition model) Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

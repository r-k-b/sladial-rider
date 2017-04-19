module Types
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


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position


type alias Model =
    { position : Position
    , drag : Maybe Drag
    }


type alias Drag =
    { start : Position
    , current : Position
    }

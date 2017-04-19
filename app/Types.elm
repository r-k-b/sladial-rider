module Types
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


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position


type alias Model =
    { drag : Maybe Drag
    , slider : Slider
    }


type alias Slider =
    { center : Position
    , angleA : Angle
    , angleB : Angle
    , maxθ : Angle
    , minθ : Angle
    , damping : Float
    , inertia : Float
    }


type alias Drag =
    { prior : Angle
    , current : Angle
    }


type alias Vector2 =
    { x : Float
    , y : Float
    }


type alias Angle =
    Float

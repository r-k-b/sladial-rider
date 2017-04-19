module Main exposing (main)

import Html
import State exposing (init, update, subscriptions)
import View exposing (view)
import Types
    exposing
        ( Model
        , Drag
        , Msg
            ( DragEnd
            , DragAt
            , DragStart
            )
        )


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

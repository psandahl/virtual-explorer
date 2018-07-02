module Composer.Model exposing (Model, Msg, init)

{-| Module implementing the composed model for complete application.
-}


{-| Model record.
-}
type alias Model =
    { placeHolder : Int
    }


{-| The message type.
-}
type Msg
    = Nop


{-| Initialize the model.
-}
init : ( Model, Cmd Msg )
init =
    ( { placeHolder = 0 }, Cmd.none )

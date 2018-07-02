module Composer.Model exposing (Model, Msg)

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

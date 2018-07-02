module Composer.Model exposing (Model, Msg)

{-| Module implementing the composed model for complete application.
-}

import Graphics.Model as Graphics


{-| Model record.
-}
type alias Model =
    { graphics : Graphics.Model
    }


{-| The message type.
-}
type Msg
    = Nop

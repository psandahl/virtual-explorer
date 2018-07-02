module Main exposing (main)

{-| Main module. Just forward everything to the Composer module.
-}

import Composer.Model exposing (Model, Msg)
import Composer.Update as Composer
import Composer.View as Composer
import Html


{-| Application entry.
-}
main : Program Never Model Msg
main =
    Html.program
        { init = Composer.init
        , update = Composer.update
        , view = Composer.view
        , subscriptions = Composer.subscriptions
        }

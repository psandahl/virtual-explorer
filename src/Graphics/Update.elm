module Graphics.Update exposing (init, setViewport, setCursor)

{-| Model manipulating functions for the graphics view.
-}

import Graphics.Model exposing (Model, Cursor(..))
import Math.Matrix4 as Mat4 exposing (Mat4)
import Window exposing (Size)


{-| Initialize the model.
-}
init : Model
init =
    { viewport = defaultViewport
    , projectionMatrix = makeProjectionMatrix defaultViewport
    , cursor = Default
    }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model
        | viewport = viewport
        , projectionMatrix = makeProjectionMatrix viewport
    }


{-| Set the cursor type.
-}
setCursor : Cursor -> Model -> Model
setCursor cursor model =
    { model | cursor = cursor }


{-| Give a default viewport before the browser reports the real one.
-}
defaultViewport : Size
defaultViewport =
    { width = 1024, height = 768 }


{-| Calculate the projection matrix for a viewport size.
-}
makeProjectionMatrix : Size -> Mat4
makeProjectionMatrix viewport =
    Mat4.makePerspective 45 (toFloat viewport.width / toFloat viewport.height) 1 1000

module Graphics.Update exposing (init, setViewport)

{-| Model manipulating functions for the graphics view.
-}

import Graphics.Model exposing (Model)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Window exposing (Size)


{-| Initialize the model.
-}
init : Model
init =
    { viewport = defaultViewport
    , projectionMatrix = makeProjectionMatrix defaultViewport
    }


{-| Set a new viewport.
-}
setViewport : Size -> Model -> Model
setViewport viewport model =
    { model
        | viewport = viewport
        , projectionMatrix = makeProjectionMatrix viewport
    }


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

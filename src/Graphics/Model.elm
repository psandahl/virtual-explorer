module Graphics.Model exposing (Model, Cursor(..))

{-| Module implementing the model for the graphics view.
-}

import Graphics.Terrain as Terrain
import Math.Matrix4 exposing (Mat4)
import Window exposing (Size)
import WebGL exposing (Mesh)


{-| The type of cursor that shall be shown by the graphics view.
-}
type Cursor
    = Default
    | Move
    | Crosshair


{-| Graphics state model. The model owns the projection matrix, which is
adapted to the current viewport size.
-}
type alias Model =
    { viewport : Size
    , projectionMatrix : Mat4
    , cursor : Cursor
    , terrainMesh : Mesh Terrain.Vertex
    }

module Graphics.Model exposing (Model, Cursor(..))

{-| Module implementing the model for the graphics view.
-}

import Graphics.Internal.SkyDome as SkyDome
import Graphics.Internal.TerrainPager as TerrainPager exposing (TerrainPager)
import Graphics.Internal.Terrain as Terrain
import Graphics.Internal.WaterSurface as WaterSurface
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
    , aspectRatio : Float
    , projectionMatrix : Mat4
    , cursor : Cursor
    , skyDomeMesh : Mesh SkyDome.Vertex
    , terrainMesh : Mesh Terrain.Vertex
    , waterMesh : Mesh WaterSurface.Vertex
    , terrainPager : TerrainPager
    }

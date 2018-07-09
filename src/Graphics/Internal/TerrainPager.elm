module Graphics.Internal.TerrainPager exposing (TerrainPager, init, page)

{-| Module that selects - pages - a set of terrain tiles from the camera position.
-}

import Camera.Model as Camera
import Graphics.Internal.Frustum exposing (Frustum)
import Math.Matrix4 as Mat4 exposing (Mat4)


{-| The terrain pager record.
-}
type alias TerrainPager =
    { tiles : List Mat4
    }


{-| Initialize the terrain pager.
-}
init : TerrainPager
init =
    { tiles =
        [ Mat4.makeTranslate3 0 0 0
        , Mat4.makeTranslate3 0 0 65
        , Mat4.makeTranslate3 0 0 130
        ]
    }


{-| Page a set of tiles (each tile represented as a model matrix) from the camera.
-}
page : Camera.Model -> TerrainPager -> List Mat4
page camera terrainPager =
    terrainPager.tiles

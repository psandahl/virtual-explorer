module Graphics.Internal.TerrainPager exposing (TerrainPager, Tile, init, page)

{-| Module that selects - pages - a set of terrain tiles from the camera position.
-}

import Camera.Model as Camera
import Graphics.Internal.Frustum as Frustum exposing (Frustum)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import Debug


{-| The terrain pager record.
-}
type alias TerrainPager =
    { tiles : List Tile
    }


type alias Tile =
    { point0 : Vec3
    , point1 : Vec3
    , point2 : Vec3
    , point3 : Vec3
    , translationMatrix : Mat4
    }


{-| Initialize the terrain pager.
-}
init : TerrainPager
init =
    { tiles =
        [ { point0 = Vec3.vec3 0 0 0
          , point1 = Vec3.vec3 64 0 0
          , point2 = Vec3.vec3 0 0 64
          , point3 = Vec3.vec3 64 0 64
          , translationMatrix = Mat4.makeTranslate3 0 0 0
          }
        , { point0 = Vec3.vec3 0 0 65
          , point1 = Vec3.vec3 64 0 65
          , point2 = Vec3.vec3 0 0 128
          , point3 = Vec3.vec3 64 0 128
          , translationMatrix = Mat4.makeTranslate3 0 0 65
          }
        , { point0 = Vec3.vec3 0 0 130
          , point1 = Vec3.vec3 64 0 130
          , point2 = Vec3.vec3 0 0 194
          , point3 = Vec3.vec3 64 0 194
          , translationMatrix = Mat4.makeTranslate3 0 0 130
          }
        ]
    }



{- tiles =
   [ Mat4.makeTranslate3 0 0 0
   , Mat4.makeTranslate3 0 0 65
   , Mat4.makeTranslate3 0 0 130
   ]
-}


{-| Page a set of tiles (each tile represented as a model matrix) from the camera.
-}
page : Float -> Camera.Model -> TerrainPager -> List Tile
page aspectRatio camera terrainPager =
    let
        frustum =
            Frustum.fromCamera aspectRatio camera

        selected =
            Debug.log "Selected: " <| List.filter (isInside frustum) terrainPager.tiles
    in
        selected


isInside : Frustum -> Tile -> Bool
isInside frustum tile =
    Frustum.containPoint tile.point0 frustum
        || Frustum.containPoint tile.point1 frustum
        || Frustum.containPoint tile.point2 frustum
        || Frustum.containPoint tile.point3 frustum

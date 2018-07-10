module Graphics.Internal.TerrainPager exposing (TerrainPager, Tile, init, page, oneTile)

{-| Module that selects - pages - a set of terrain tiles from the camera position.
-}

import Camera.Model as Camera
import Graphics.Internal.Frustum as Frustum exposing (Frustum)
import Graphics.Internal.Terrain as Terrain
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import Debug


{-| The terrain pager record.
-}
type alias TerrainPager =
    { tiles : List Tile
    }


{-| Tile record.
-}
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
        List.concat <|
            List.map
                (\column ->
                    List.map (oneTile column) <| List.range -3 2
                )
            <|
                List.range -3 2
    }


{-| Generate one tile. Use the column and row indices for setting the values.
-}
oneTile : Int -> Int -> Tile
oneTile column row =
    let
        ( width, height ) =
            Terrain.dimensions

        col0 =
            toFloat <| (column * (width - 1))

        col1 =
            toFloat <| ((column + 1) * (width - 1))

        row0 =
            toFloat <| (row * (height - 1))

        row1 =
            toFloat <| ((row + 1) * (height - 1))
    in
        { point0 = Vec3.vec3 col0 0 row0
        , point1 = Vec3.vec3 col1 0 row0
        , point2 = Vec3.vec3 col0 0 row1
        , point3 = Vec3.vec3 col1 0 row1
        , translationMatrix = Mat4.makeTranslate3 col0 0 row0
        }


{-| Page a set of tiles (each tile represented as a model matrix) from the camera.
-}
page : Float -> Camera.Model -> TerrainPager -> List Tile
page aspectRatio camera terrainPager =
    let
        frustum =
            Frustum.fromCamera aspectRatio camera

        selected =
            List.filter (isInside frustum) terrainPager.tiles

        dbg =
            Debug.log "(#tiles selected, #tiles) " <| ( List.length selected, List.length terrainPager.tiles )
    in
        selected


{-| Check if a tile is inside the frustum.
-}
isInside : Frustum -> Tile -> Bool
isInside frustum tile =
    Frustum.containPoint tile.point0 frustum
        || Frustum.containPoint tile.point1 frustum
        || Frustum.containPoint tile.point2 frustum
        || Frustum.containPoint tile.point3 frustum

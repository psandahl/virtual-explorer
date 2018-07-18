module Graphics.Internal.TerrainPager
    exposing
        ( TerrainPager
        , Tile
        , init
        , selectFromCamera
        )

{-| Module that creates and selects - pages - a set of terrain tiles from
the camera position.
-}

import Camera.Model as Camera
import Debug
import Graphics.Internal.Frustum as Frustum exposing (Frustum)
import Graphics.Internal.Terrain as Terrain
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import Settings


{-| The terrain pager record.
-}
type alias TerrainPager =
    { tiles : List Tile
    , translationMatrices : List Mat4
    }


{-| Tile record. The points are forming a box, where the first four points are
the the "bottom points" and the last four are the "top points".
-}
type alias Tile =
    { point0 : Vec3
    , point1 : Vec3
    , point2 : Vec3
    , point3 : Vec3
    , point4 : Vec3
    , point5 : Vec3
    , point6 : Vec3
    , point7 : Vec3
    , translationMatrix : Mat4
    }


{-| Initialize the terrain pager.
-}
init : Float -> Camera.Model -> TerrainPager
init aspectRatio camera =
    let
        tiles =
            List.concat <|
                List.map
                    (\column ->
                        List.map (oneTile column) <| List.range -10 9
                    )
                <|
                    List.range -10 9
    in
    { tiles = tiles, translationMatrices = pageFromCamera aspectRatio camera tiles }


{-| Select a set of tiles from the camera.
-}
selectFromCamera : Float -> Camera.Model -> TerrainPager -> TerrainPager
selectFromCamera aspectRatio camera terrainPager =
    { terrainPager | translationMatrices = pageFromCamera aspectRatio camera terrainPager.tiles }


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
    { point0 = Vec3.vec3 col0 (toFloat -Settings.maxTerrainAltitude) row0
    , point1 = Vec3.vec3 col1 (toFloat -Settings.maxTerrainAltitude) row0
    , point2 = Vec3.vec3 col0 (toFloat -Settings.maxTerrainAltitude) row1
    , point3 = Vec3.vec3 col1 (toFloat -Settings.maxTerrainAltitude) row1
    , point4 = Vec3.vec3 col0 (toFloat Settings.maxTerrainAltitude) row0
    , point5 = Vec3.vec3 col1 (toFloat Settings.maxTerrainAltitude) row0
    , point6 = Vec3.vec3 col0 (toFloat Settings.maxTerrainAltitude) row1
    , point7 = Vec3.vec3 col1 (toFloat Settings.maxTerrainAltitude) row1
    , translationMatrix = Mat4.makeTranslate3 col0 0 row0
    }


{-| Working horse for paging.
-}
pageFromCamera : Float -> Camera.Model -> List Tile -> List Mat4
pageFromCamera aspectRatio camera tiles =
    let
        frustum =
            Frustum.fromCamera aspectRatio camera

        selected =
            List.filter (isInside frustum) tiles

        dgb =
            Debug.log "pageFromCamera (#selected, total): " ( List.length selected, List.length tiles )
    in
    List.map (\tile -> tile.translationMatrix) selected


{-| Check if a tile is inside the frustum.
-}
isInside : Frustum -> Tile -> Bool
isInside frustum tile =
    Frustum.containPoint tile.point0 frustum
        || Frustum.containPoint tile.point1 frustum
        || Frustum.containPoint tile.point2 frustum
        || Frustum.containPoint tile.point3 frustum
        || Frustum.containPoint tile.point4 frustum
        || Frustum.containPoint tile.point5 frustum
        || Frustum.containPoint tile.point6 frustum
        || Frustum.containPoint tile.point7 frustum

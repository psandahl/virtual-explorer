module Graphics.Mesh.Terrain
    exposing
        ( Vertex
        , makeMesh
        , dimensions
        , vertexShader
        , fragmentShader
        )

{-| Module implementing the terrain graphics; generating the mesh and providing
the shaders for rendering the terrain.

The terrain itself is just a flat terrain tile. The only attribute for the
mesh is the position; the x components goes from 0 to dimensions vertices,
the z components goes from 0 to dimensions vertices. Y components are constant 0.
The height is then generated in the vertex shader.

The dimensions are quite small, because of limitations in the Elm runtime. If
the dimensions are to big there will be stack overruns because of too much
recursion.

-}

import List.Extra as List
import Math.Matrix4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3)
import WebGL as GL exposing (Mesh, Shader)


{-| Terrain vertex type.
-}
type alias Vertex =
    { aPosition : Vec3
    }


{-| Make a mesh with the dimensions configured by 'dimensions'.
-}
makeMesh : Mesh Vertex
makeMesh =
    let
        vertices =
            makeVertices dimensions

        indices =
            makeIndices dimensions
    in
        GL.indexedTriangles vertices indices


{-| Give the vertice count dimensions for a tile. (x, z).
-}
dimensions : ( Int, Int )
dimensions =
    ( 65, 65 )


{-| Make vertices for the given dimensions.
-}
makeVertices : ( Int, Int ) -> List Vertex
makeVertices ( cols, rows ) =
    List.initialize (cols * rows) <|
        \vertice ->
            let
                x =
                    vertice % cols

                z =
                    vertice // cols
            in
                { aPosition = Vec3.vec3 (toFloat x) 0 (toFloat z) }


{-| Make triangle indices for the given dimensions
-}
makeIndices : ( Int, Int ) -> List ( Int, Int, Int )
makeIndices ( cols, rows ) =
    -- Convert vertices count to quad count, and then to triangle count ...
    List.initialize ((cols - 1) * (rows - 1) * 2) <|
        \triangle ->
            let
                quad =
                    triangle // 2

                row =
                    quad // (rows - 1)

                col =
                    quad % (cols - 1)

                v0 =
                    col + (row * cols)

                v1 =
                    v0 + 1

                v2 =
                    col + ((row + 1) * cols)

                v3 =
                    v2 + 1
            in
                if isEven triangle then
                    ( v1, v0, v2 )
                else
                    ( v1, v2, v3 )


isEven : Int -> Bool
isEven n =
    n % 2 == 0


{-| Vertex shader for the terrain.
-}
vertexShader :
    Shader Vertex
        { uniforms
            | uModelMatrix : Mat4
            , uViewMatrix : Mat4
            , uProjectionMatrix : Mat4
        }
        { vColor : Vec3 }
vertexShader =
    [glsl|
precision mediump float;

attribute vec3 aPosition;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec3 vColor;

void main()
{
    vColor = vec3(1.0, 0.0, 0.0);

    mat4 mvp = uProjectionMatrix * uViewMatrix * uModelMatrix;
    gl_Position = mvp * vec4(aPosition, 1.0);
}
    |]


{-| Fragment shader for the terrain.
-}
fragmentShader : Shader {} uniforms { vColor : Vec3 }
fragmentShader =
    [glsl|
precision mediump float;

varying vec3 vColor;

void main()
{
    gl_FragColor = vec4(vColor, 1.0);
}
    |]

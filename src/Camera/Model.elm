module Camera.Model exposing (Model)

{-| The camera module implements the camera. The responsibility for the camera
is to hold the current position. A position that is a little bit fake as the
camera always is at (0, 0), but a change in position will give the impression
of the camera moving (as the terrain will shift when position is changed).

The camera has a variable height though.

Another responsibility of the camera is to hold the viewing angles pitch and yaw.

The camera does not have a view.

-}

import Math.Matrix4 exposing (Mat4)
import Math.Vector3 exposing (Vec3)
import Window exposing (Size)


{-| The camera model. Have the current viewport size, the heading angle,
the pitch angle, the position, the view direction and the view matrix.
-}
type alias Model =
    { viewport : Size
    , heading : Int
    , pitch : Int
    , position : Vec3
    , viewDirection : Vec3
    , upDirection : Vec3
    , viewMatrix : Mat4
    }

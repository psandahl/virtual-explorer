module Camera.Model exposing (Model)

{-| The camera module implements the camera. The responsibility for the camera
is to hold the current position. A position that is a little bit fake as the
camera always is at (0, 0), but a change in position will give the impression
of the camera moving (as the terrain will shift when position is changed).

Another responsibility of the camera is to hold the viewing angles pitch and yaw.

The camera does not have a view.

-}

import Window exposing (Size)


type alias Model =
    { viewport : Size
    , heading : Int
    }

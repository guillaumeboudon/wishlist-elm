module Page.Auth exposing (..)

import Html exposing (Html)
import Types exposing (..)



-- =============================================================================
-- > INIT
-- =============================================================================


type alias Model =
    Modelized Page


type alias Page =
    { email : String
    , password : String
    }


initPage : Page
initPage =
    { email = ""
    , password = ""
    }



-- =============================================================================
-- > VIEW
-- =============================================================================


view : Model -> Html msg
view model =
    Html.p [] [ Html.text "Auth" ]

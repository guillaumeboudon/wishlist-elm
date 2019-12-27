module Page.Auth exposing (..)

import Html exposing (Html)
import Route exposing (href)
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
    Html.div []
        [ Html.h1 [] [ Html.text "Auth" ]
        , Html.a [ href Route.Home ] [ Html.text "Go to Sign In page" ]
        ]

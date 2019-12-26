module Types exposing (..)

import Browser
import Browser.Navigation
import Route exposing (Route)
import Url exposing (Url)



-- =============================================================================
-- > Model
-- =============================================================================


type alias Model =
    { key : Browser.Navigation.Key
    , route : Route
    }


initialModel : Browser.Navigation.Key -> Model
initialModel key =
    { key = key
    , route = Route.NotFound
    }


setRouteIn : Model -> Route -> Model
setRouteIn model route =
    { model | route = route }



-- =============================================================================
-- > Msg
-- =============================================================================


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest

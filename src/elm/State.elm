module State exposing (..)

import Browser.Navigation as Nav
import Firebase.Auth as Auth
import Helper exposing (..)



-- =============================================================================
-- > State page
-- =============================================================================


type alias State page =
    { key : Nav.Key
    , auth : Auth.Auth
    , page : page
    }


initialState : Nav.Key -> RawState
initialState key =
    State
        key
        Auth.NotAuthenticated
        {}


setAuth : Auth.Auth -> State page -> State page
setAuth auth state =
    { state | auth = auth }


setPage : newPage -> State page -> State newPage
setPage newPage state =
    State
        state.key
        state.auth
        newPage


updatePage : (element -> page -> page) -> element -> State page -> State page
updatePage setElement element state =
    element
        |> flip setElement state.page
        |> flip setPage state



-- =============================================================================
-- > RawState
-- =============================================================================


type alias RawState =
    State {}


toRawState : State page -> RawState
toRawState state =
    setPage {} state

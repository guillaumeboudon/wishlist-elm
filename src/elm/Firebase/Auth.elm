module Firebase.Auth exposing (..)

import Browser.Navigation



-- =============================================================================
-- > Auth
-- =============================================================================


type Auth
    = NotAuthenticated
    | Authenticated Session



-- =============================================================================
-- > Session
-- =============================================================================


type alias Session =
    { email : String
    , uid : String
    }


fakeSession : Session
fakeSession =
    Session "foo@bar.baz" "0123456789"



-- =============================================================================
-- > Credentials
-- =============================================================================


type alias Credentials =
    { email : String
    , password : String
    }


initialAuthDetails : Credentials
initialAuthDetails =
    Credentials "" ""



-- =============================================================================
-- > Setters
-- =============================================================================


setEmail : String -> { a | email : String } -> { a | email : String }
setEmail email record =
    { record | email = email }


setPassword : String -> { a | password : String } -> { a | password : String }
setPassword password record =
    { record | password = password }


setUid : String -> { a | uid : String } -> { a | uid : String }
setUid uid record =
    { record | uid = uid }

port module Firebase.Auth exposing (..)

import Browser.Navigation
import Json.Decode as JD
import Json.Encode as JE



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



-- =============================================================================
-- > Credentials
-- =============================================================================


type alias Credentials =
    { email : String
    , password : String
    }



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



-- =============================================================================
-- > Update
-- =============================================================================


type Msg
    = SignUpError String
    | SignInError String
    | LoggedIn Session
    | LoggedOut



-- =============================================================================
-- > Interop
-- =============================================================================
{-
   > Ports ---------------------------------------------------------------------
-}


port authToJs : JE.Value -> Cmd msg


signIn : Credentials -> Cmd msg
signIn credentials =
    [ ( "type", JE.string "SIGN_IN" )
    , ( "email", JE.string credentials.email )
    , ( "password", JE.string credentials.password )
    ]
        |> JE.object
        |> authToJs


signUp : Credentials -> Cmd msg
signUp credentials =
    [ ( "type", JE.string "SIGN_UP" )
    , ( "email", JE.string credentials.email )
    , ( "password", JE.string credentials.password )
    ]
        |> JE.object
        |> authToJs


signOut : Cmd msg
signOut =
    [ ( "type", JE.string "SIGN_OUT" ) ]
        |> JE.object
        |> authToJs



{-
   > Subscriptions -------------------------------------------------------------
-}


port authFromJs : (JD.Value -> msg) -> Sub msg


decodeFromJs : JD.Value -> Msg
decodeFromJs value =
    case JD.decodeValue fromJsDecoder value of
        Ok msg ->
            msg

        Err _ ->
            LoggedOut


fromJsDecoder : JD.Decoder Msg
fromJsDecoder =
    let
        decodeType type_ =
            case type_ of
                "SIGN_UP_ERROR" ->
                    JD.map SignUpError errorCodeDecoder

                "SIGN_IN_ERROR" ->
                    JD.map SignInError errorCodeDecoder

                "LOGGED_IN" ->
                    JD.map LoggedIn sessionDecoder

                "LOGGED_OUT" ->
                    JD.succeed LoggedOut

                _ ->
                    JD.fail "Error"
    in
    JD.field "type" JD.string
        |> JD.andThen decodeType


errorCodeDecoder : JD.Decoder String
errorCodeDecoder =
    JD.field "errorCode" JD.string


sessionDecoder : JD.Decoder Session
sessionDecoder =
    JD.map2 Session
        (JD.field "email" JD.string)
        (JD.field "uid" JD.string)

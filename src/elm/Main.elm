module Main exposing (main)

-- import Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Firebase.Auth as Auth
import Helper exposing (..)
import Html exposing (Html)
import Html.Attributes as A
import Page.Auth
import Page.Home
import Page.NotFound
import Route exposing (Route)
import State exposing (RawState)
import Styles.Global
import Url exposing (Url)



-- =============================================================================
-- > Init
-- =============================================================================


type Model
    = Home RawState
    | Auth Page.Auth.Action Page.Auth.Model
    | NotFound RawState


initialModel : Nav.Key -> Model
initialModel key =
    State.initialState key
        |> Home


getRawState : Model -> RawState
getRawState model =
    case model of
        Home state ->
            State.toRawState state

        Auth _ state ->
            State.toRawState state

        NotFound state ->
            State.toRawState state


setAuth : Auth.Auth -> Model -> Model
setAuth auth model =
    case model of
        Home state ->
            Home <| State.setAuth auth state

        Auth action state ->
            Auth action <| State.setAuth auth state

        NotFound state ->
            NotFound <| State.setAuth auth state


getAuth : Model -> Auth.Auth
getAuth model =
    model
        |> getRawState
        |> .auth


getKey : Model -> Nav.Key
getKey model =
    model
        |> getRawState
        |> .key


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    initialModel key
        |> changeRouteTo (Route.fromUrl url)



-- =============================================================================
-- > Update
-- =============================================================================


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | PageAuthMsg Page.Auth.Msg
    | FirebaseAuthMsg Auth.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ChangedUrl url, _ ) ->
            model
                |> changeRouteTo (Route.fromUrl url)

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    url
                        |> Route.navigate (getKey model)
                        |> Tuple.pair model

                Browser.External href ->
                    href
                        |> Nav.load
                        |> Tuple.pair model

        ( PageAuthMsg authMsg, Auth action authModel ) ->
            case authMsg of
                Page.Auth.RequestSignIn ->
                    Page.Auth.getCredentials authModel.page
                        |> Auth.signIn
                        |> flip withCmd model

                Page.Auth.RequestSignUp ->
                    Page.Auth.getCredentials authModel.page
                        |> Auth.signUp
                        |> flip withCmd model

                _ ->
                    Page.Auth.update authMsg authModel
                        |> updateWith (Auth action) PageAuthMsg model

        ( FirebaseAuthMsg authMsg, _ ) ->
            updateAuth authMsg model

        ( _, _ ) ->
            model |> withoutCmd


updateAuth : Auth.Msg -> Model -> ( Model, Cmd Msg )
updateAuth authMsg model =
    let
        handleError : String -> ( Model, Cmd Msg )
        handleError errorCode =
            case model of
                Auth authAction authModel ->
                    authModel
                        |> Page.Auth.setErrorCode errorCode
                        |> Auth authAction
                        |> withoutCmd

                _ ->
                    model
                        |> changeRouteTo (Just Route.Home)
    in
    case authMsg of
        Auth.SignUpError errorCode ->
            handleError errorCode

        Auth.SignInError errorCode ->
            handleError errorCode

        Auth.LoggedIn session ->
            model
                |> setAuth (Auth.Authenticated session)
                |> changeRouteTo (Just Route.Home)

        Auth.LoggedOut ->
            model
                |> setAuth Auth.NotAuthenticated
                |> changeRouteTo (Just Route.Home)


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            model
                |> getRawState
                |> NotFound
                |> withoutCmd

        Just route ->
            case route of
                Route.Home ->
                    model
                        |> getRawState
                        |> Home
                        |> withoutCmd

                Route.Auth authRoute ->
                    case authRoute of
                        Route.SignOut ->
                            model
                                |> withCmd Auth.signOut

                        Route.SignIn ->
                            model
                                |> getRawState
                                |> State.setPage Page.Auth.initialPage
                                |> Auth Page.Auth.SignIn
                                |> withoutCmd

                        Route.SignUp ->
                            model
                                |> getRawState
                                |> State.setPage Page.Auth.initialPage
                                |> Auth Page.Auth.SignUp
                                |> withoutCmd



-- =============================================================================
-- > View
-- =============================================================================


view : Model -> Browser.Document Msg
view model =
    let
        subView =
            case model of
                Home _ ->
                    model
                        |> getAuth
                        |> Page.Home.view

                Auth action authModel ->
                    authModel
                        |> flip Page.Auth.view action
                        |> Html.map PageAuthMsg

                NotFound _ ->
                    Page.NotFound.view
    in
    { title = "Wishlist"
    , body = [ Html.div [ A.class Styles.Global.grayBackground ] [ subView ] ]
    }



-- =============================================================================
-- > Subscriptions
-- =============================================================================


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map FirebaseAuthMsg (Auth.authFromJs Auth.decodeFromJs)



-- =============================================================================
-- > Main
-- =============================================================================


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }

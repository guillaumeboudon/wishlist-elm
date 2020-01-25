module Page.Auth exposing (..)

import Firebase.Auth as Auth
import Helper exposing (..)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Route exposing (href)
import State exposing (..)
import UIKit as UI



-- =============================================================================
-- > Init
-- =============================================================================


type alias Model =
    State Page


type Action
    = SignIn
    | SignUp


type alias Page =
    { email : String
    , password : String
    , errorCode : String
    }


initialPage : Page
initialPage =
    Page "" "" ""


setEmail : String -> Model -> Model
setEmail email model =
    updatePage Auth.setEmail email model


setPassword : String -> Model -> Model
setPassword password model =
    updatePage Auth.setPassword password model


setErrorCode : String -> Model -> Model
setErrorCode errorCode model =
    updatePage (\a b -> { b | errorCode = a }) errorCode model


getCredentials : Page -> Auth.Credentials
getCredentials { email, password } =
    Auth.Credentials email password



-- =============================================================================
-- > Update
-- =============================================================================


type Msg
    = InputEmail String
    | InputPassword String
    | GoToHome
    | RequestSignIn
    | RequestSignUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputEmail email ->
            model
                |> setEmail email
                |> withoutCmd

        InputPassword password ->
            model
                |> setPassword password
                |> withoutCmd

        GoToHome ->
            ( model
            , Route.replaceUrl model.key Route.Home
            )

        _ ->
            model |> withoutCmd



-- =============================================================================
-- > View
-- =============================================================================


actionToText : Action -> String
actionToText action =
    case action of
        SignIn ->
            "Connexion"

        SignUp ->
            "Inscription"


actionToSubmitMsg : Action -> Msg
actionToSubmitMsg action =
    case action of
        SignIn ->
            RequestSignIn

        SignUp ->
            RequestSignUp


view : Model -> Action -> Html Msg
view model action =
    Html.div []
        [ Html.h1 [] [ Html.text <| actionToText action ]
        , Html.p [] [ Html.text model.page.errorCode ]
        , Html.form [ E.onSubmit <| actionToSubmitMsg action, UI.onReset GoToHome ]
            [ UI.inputEmail model.page.email "inputEmail" "Email" InputEmail
            , UI.inputPassword model.page.password "inputPassword" "Mot de passe" InputPassword
            , UI.buttonSubmit <| actionToText action
            , UI.buttonReset "Annuler"
            ]
        ]

module Page.Auth exposing (..)

import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode
import Route exposing (href)
import Types exposing (..)
import UIKit as UI
import Update



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


setEmail : String -> Model -> Model
setEmail email model =
    let
        page =
            model.page
    in
    { model | page = { page | email = email } }


setPassword : String -> Model -> Model
setPassword password model =
    let
        page =
            model.page
    in
    { model | page = { page | password = password } }



-- =============================================================================
-- > UPDATE
-- =============================================================================


type Msg
    = InputEmail String
    | InputPassword String
    | GoToHome
    | ValidateForm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputEmail email ->
            model
                |> setEmail email
                |> Update.identity

        InputPassword password ->
            model
                |> setPassword password
                |> Update.identity

        GoToHome ->
            ( model
            , Route.replaceUrl model.key Route.Home
            )

        ValidateForm ->
            model
                |> setEmail "<email validated>"
                |> setPassword "<password validated>"
                |> Update.identity



-- =============================================================================
-- > VIEW
-- =============================================================================


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "Connexion" ]
        , Html.form [ E.onSubmit ValidateForm, UI.onReset GoToHome ]
            [ UI.inputEmail model.page.email "inputEmail" "Email" InputEmail
            , UI.inputPassword model.page.password "inputPassword" "Mot de passe" InputPassword
            , UI.buttonSubmit "Se connecter"
            , UI.buttonReset "Annuler"
            ]
        ]

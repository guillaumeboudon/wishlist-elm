module Main exposing (main)

-- import Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Html.Attributes as A
import Page.Auth
import Page.Home
import Page.NotFound
import Route exposing (Route)
import Styles.Global
import Types exposing (..)
import Update
import Url exposing (Url)



-- =============================================================================
-- > Init
-- =============================================================================


type Model
    = Home RawModel
    | Auth Page.Auth.Model
    | NotFound RawModel


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    initialModel key
        |> changeRouteTo (Route.fromUrl url)


initialModel : Nav.Key -> Model
initialModel key =
    Home (initialRawModel key)


extractRawModel : Model -> RawModel
extractRawModel model =
    case model of
        Home subModel ->
            toRawModel subModel

        Auth subModel ->
            toRawModel subModel

        NotFound subModel ->
            toRawModel subModel


getKey : Model -> Nav.Key
getKey model =
    model
        |> extractRawModel
        |> .key



-- =============================================================================
-- > Update
-- =============================================================================


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedUrl url ->
            model
                |> changeRouteTo (Route.fromUrl url)

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    url
                        |> Route.navigate (getKey model)
                        |> Tuple.pair model

                Browser.External href ->
                    href
                        |> Nav.load
                        |> Tuple.pair model


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            model
                |> extractRawModel
                |> NotFound
                |> Update.identity

        Just route ->
            case route of
                Route.Home ->
                    model
                        |> extractRawModel
                        |> Home
                        |> Update.identity

                Route.Auth authRoute ->
                    model
                        |> extractRawModel
                        |> setPage Page.Auth.initPage
                        |> Auth
                        |> Update.identity



-- =============================================================================
-- > View
-- =============================================================================


view : Model -> Browser.Document Msg
view model =
    let
        subView =
            case model of
                Home _ ->
                    Page.Home.view

                Auth authModel ->
                    Page.Auth.view authModel

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
    Sub.none



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

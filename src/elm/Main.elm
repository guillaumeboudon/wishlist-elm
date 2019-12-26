module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (Html)
import Html.Attributes as A
import Route
import Styles.Global
import Types exposing (..)
import Update
import Url exposing (Url)



-- =============================================================================
-- > Init
-- =============================================================================


init : () -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    url
        |> Route.fromUrl
        |> setRouteIn (initialModel key)
        |> Update.identity



-- =============================================================================
-- > Update
-- =============================================================================


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedUrl url ->
            url
                |> Route.fromUrl
                |> setRouteIn model
                |> Update.identity

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    url
                        |> Route.fromUrl
                        |> Route.navigate model.key
                        |> Tuple.pair model

                Browser.External href ->
                    href
                        |> Browser.Navigation.load
                        |> Tuple.pair model



-- =============================================================================
-- > View
-- =============================================================================


view : Model -> Browser.Document Msg
view model =
    let
        routeToString =
            case model.route of
                Route.Home ->
                    "Home"

                Route.NotFound ->
                    "Not Found"
    in
    { title = "Wishlist"
    , body = [ Html.p [ A.class Styles.Global.grayBackground ] [ Html.text routeToString ] ]
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

module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as A
import Styles.Global



-- =============================================================================
-- > Init
-- =============================================================================


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "Hello, World!", Cmd.none )



-- =============================================================================
-- > Update
-- =============================================================================


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- =============================================================================
-- > View
-- =============================================================================


view : Model -> Browser.Document Msg
view model =
    { title = "Wishlist"
    , body = [ Html.p [ A.class Styles.Global.greenText ] [ Html.text model ] ]
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
        { init = \_ _ _ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = always NoOp
        , onUrlRequest = always NoOp
        }

module Route exposing (AuthRoute(..), Route(..), fromUrl, href, navigate, replaceUrl)

import Browser.Navigation exposing (Key)
import Html exposing (Attribute)
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s)



-- =============================================================================
-- > Route
-- =============================================================================


type Route
    = Home
    | Auth AuthRoute


type AuthRoute
    = SignIn
    | SignUp
    | SignOut


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map (Auth SignIn) (s "auth" </> s "sign_in")
        , Parser.map (Auth SignUp) (s "auth" </> s "sign_up")
        , Parser.map (Auth SignOut) (s "auth" </> s "sign_out")
        ]



-- =============================================================================
-- > Exposed Helpers
-- =============================================================================


href : Route -> Attribute msg
href route =
    Html.Attributes.href (toString route)


replaceUrl : Key -> Route -> Cmd msg
replaceUrl key route =
    Browser.Navigation.replaceUrl key (toString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


navigate : Key -> Url -> Cmd msg
navigate key url =
    url
        |> Url.toString
        |> Browser.Navigation.pushUrl key



-- =============================================================================
-- > Internal Helpers
-- =============================================================================


routePieces : Route -> List String
routePieces route =
    case route of
        Home ->
            []

        Auth authRoute ->
            case authRoute of
                SignIn ->
                    [ "auth", "sign_in" ]

                SignUp ->
                    [ "auth", "sign_up" ]

                SignOut ->
                    [ "auth", "sign_out" ]


toString : Route -> String
toString route =
    "/" ++ String.join "/" (routePieces route)

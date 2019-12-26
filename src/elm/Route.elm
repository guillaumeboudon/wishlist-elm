module Route exposing (Route(..), fromUrl, href, navigate, replaceUrl)

import Browser.Navigation exposing (Key)
import Html exposing (Attribute)
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)



-------------------------------------------------------------------------------
-- ROUTE
-------------------------------------------------------------------------------


type Route
    = Home
    | NotFound


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top ]



-------------------------------------------------------------------------------
-- EXPOSED HELPERS
-------------------------------------------------------------------------------


href : Route -> Attribute msg
href route =
    Html.Attributes.href (toString route)


replaceUrl : Key -> Route -> Cmd msg
replaceUrl key route =
    Browser.Navigation.replaceUrl key (toString route)


fromUrl : Url -> Route
fromUrl url =
    Parser.parse parser url
        |> Maybe.withDefault NotFound


navigate : Key -> Route -> Cmd msg
navigate key route =
    route
        |> toString
        |> Browser.Navigation.pushUrl key



-------------------------------------------------------------------------------
-- INTERNAL HELPERS
-------------------------------------------------------------------------------


toString : Route -> String
toString route =
    let
        pieces =
            case route of
                Home ->
                    []

                NotFound ->
                    []
    in
    "/" ++ String.join "/" pieces

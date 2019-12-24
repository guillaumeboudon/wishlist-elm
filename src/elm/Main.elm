module Main exposing (main)

import Browser
import Html
import Html.Attributes as A
import Styles.Global


main : Program () String msg
main =
    Browser.sandbox
        { init = "Hello, elm!"
        , update = \_ v -> v
        , view = \v -> Html.p [ A.class Styles.Global.greenText ] [ Html.text v ]
        }

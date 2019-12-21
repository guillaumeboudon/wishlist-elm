module Main exposing (main)

import Browser
import Html


main : Program () String msg
main =
    Browser.sandbox
        { init = "Hello, elm!"
        , update = \_ v -> v
        , view = \v -> Html.text v
        }

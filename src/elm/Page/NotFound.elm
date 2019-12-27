module Page.NotFound exposing (view)

import Html exposing (Html)


view : Html msg
view =
    Html.p [] [ Html.text "Not Found" ]

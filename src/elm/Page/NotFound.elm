module Page.NotFound exposing (view)

import Html exposing (Html)
import Route exposing (href)


view : Html msg
view =
    Html.div
        []
        [ Html.h1 [] [ Html.text "Not Found" ]
        , Html.a [ href Route.Home ] [ Html.text "Go to Home page" ]
        ]

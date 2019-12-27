module Page.Home exposing (view)

import Html exposing (Html)
import Route exposing (href)


view : Html msg
view =
    Html.div []
        [ Html.h1 [] [ Html.text "Home page" ]
        , Html.a [ href (Route.Auth Route.SignIn) ] [ Html.text "Go to Sign In page" ]
        ]

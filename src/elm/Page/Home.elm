module Page.Home exposing (view)

import Firebase.Auth as Auth
import Html exposing (Html)
import Route exposing (href)


authLinks : Auth.Auth -> List (Html msg)
authLinks auth =
    case auth of
        Auth.NotAuthenticated ->
            [ Html.a [ href (Route.Auth Route.SignIn) ] [ Html.text "Go to Sign In page" ]
            , Html.a [ href (Route.Auth Route.SignUp) ] [ Html.text "Go to Sign Up page" ]
            ]

        Auth.Authenticated _ ->
            [ Html.a [ href (Route.Auth Route.SignOut) ] [ Html.text "Go to Sign Out page" ] ]


view : Auth.Auth -> Html msg
view auth =
    Html.div []
        (List.concat
            [ [ Html.h1 [] [ Html.text "Home page" ] ]
            , authLinks auth
            ]
        )

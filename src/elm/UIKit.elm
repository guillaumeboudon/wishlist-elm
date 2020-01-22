module UIKit exposing (buttonReset, buttonSubmit, inputEmail, inputPassword, inputText, onReset, textarea)

import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode



-- =============================================================================
-- > Helpers
-- =============================================================================


onReset : msg -> Html.Attribute msg
onReset msg =
    E.on "reset" (Decode.succeed msg)



-- =============================================================================
-- > Forms
-- =============================================================================


formGroup : List (Html msg) -> Html msg
formGroup =
    Html.div [ A.class "form-group" ]


formLabel : Id -> Label -> Html msg
formLabel id label =
    Html.label [ A.for id ] [ Html.text label ]


type InputType
    = Text
    | Email
    | Password


type alias Value =
    String


type alias Id =
    String


type alias Label =
    String


inputTypeToString : InputType -> String
inputTypeToString inputType =
    case inputType of
        Text ->
            "text"

        Email ->
            "email"

        Password ->
            "password"


inputAttributes : Value -> Id -> (String -> msg) -> List (Html.Attribute msg)
inputAttributes value id toMsg =
    [ E.onInput toMsg
    , A.value value
    , A.id id
    , A.class "form-control"
    ]


inputFormGroup : InputType -> Value -> Id -> Label -> (String -> msg) -> Html msg
inputFormGroup inputType value id label toMsg =
    [ formLabel id label
    , Html.input
        ((A.type_ <| inputTypeToString inputType) :: inputAttributes value id toMsg)
        []
    ]
        |> formGroup


inputText : Value -> Id -> Label -> (String -> msg) -> Html msg
inputText =
    inputFormGroup Text


inputEmail : Value -> Id -> Label -> (String -> msg) -> Html msg
inputEmail =
    inputFormGroup Email


inputPassword : Value -> Id -> Label -> (String -> msg) -> Html msg
inputPassword =
    inputFormGroup Password


textarea : Value -> Id -> Label -> (String -> msg) -> Html msg
textarea value id label toMsg =
    [ formLabel id label
    , Html.textarea
        (inputAttributes value id toMsg)
        []
    ]
        |> formGroup


buttonReset : String -> Html msg
buttonReset text =
    Html.button
        [ A.type_ "reset" ]
        [ Html.text text ]


buttonSubmit : String -> Html msg
buttonSubmit text =
    Html.button
        [ A.type_ "submit" ]
        [ Html.text text ]

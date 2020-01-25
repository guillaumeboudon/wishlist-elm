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


formLabel : Id -> Label -> Required -> Html msg
formLabel id label required =
    let
        fullLabel =
            case required of
                True ->
                    label ++ " *"

                False ->
                    label
    in
    Html.label [ A.for id ] [ Html.text fullLabel ]


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


type alias Required =
    Bool


inputTypeToString : InputType -> String
inputTypeToString inputType =
    case inputType of
        Text ->
            "text"

        Email ->
            "email"

        Password ->
            "password"


inputAttributes : Value -> Id -> (String -> msg) -> Required -> List (Html.Attribute msg)
inputAttributes value id toMsg required =
    [ E.onInput toMsg
    , A.value value
    , A.id id
    , A.class "form-control"
    , A.required required
    ]


inputFormGroup : InputType -> Value -> Id -> Label -> (String -> msg) -> Required -> Html msg
inputFormGroup inputType value id label toMsg required =
    [ formLabel id label required
    , Html.input
        ((A.type_ <| inputTypeToString inputType) :: inputAttributes value id toMsg required)
        []
    ]
        |> formGroup


inputText : Value -> Id -> Label -> (String -> msg) -> Required -> Html msg
inputText value id label toMsg required =
    inputFormGroup Text value id label toMsg required


inputEmail : Value -> Id -> Label -> (String -> msg) -> Html msg
inputEmail value id label toMsg =
    inputFormGroup Email value id label toMsg True


inputPassword : Value -> Id -> Label -> (String -> msg) -> Html msg
inputPassword value id label toMsg =
    inputFormGroup Password value id label toMsg True


textarea : Value -> Id -> Label -> (String -> msg) -> Required -> Html msg
textarea value id label toMsg required =
    [ formLabel id label required
    , Html.textarea
        (inputAttributes value id toMsg required)
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

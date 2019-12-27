module Update exposing (..)


identity : model -> ( model, Cmd msg )
identity model =
    ( model, Cmd.none )


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd ( model, cmds ) =
    ( model, Cmd.batch [ cmds, cmd ] )

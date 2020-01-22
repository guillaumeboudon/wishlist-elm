module Helper exposing (..)

-- =============================================================================
-- > Update
-- =============================================================================


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd ( model, cmds ) =
    ( model, Cmd.batch [ cmds, cmd ] )


withCmd : Cmd msg -> model -> ( model, Cmd msg )
withCmd cmd model =
    ( model, cmd )


withoutCmd : model -> ( model, Cmd msg )
withoutCmd model =
    ( model, Cmd.none )



-- =============================================================================
-- > Miscellaneous
-- =============================================================================


flip : (a -> b -> c) -> b -> a -> c
flip f b a =
    f a b

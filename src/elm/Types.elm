module Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Route exposing (Route)
import Url exposing (Url)


type alias Modelized a =
    { key : Nav.Key
    , page : a
    }


type alias RawModel =
    Modelized {}


initialRawModel : Nav.Key -> RawModel
initialRawModel key =
    { key = key
    , page = {}
    }


toRawModel : Modelized a -> RawModel
toRawModel subModel =
    initialRawModel subModel.key


setPage : b -> Modelized a -> Modelized b
setPage page model =
    { key = model.key
    , page = page
    }

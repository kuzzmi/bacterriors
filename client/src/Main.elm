module Main exposing (..)

import Html exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    {}


type alias ID =
    String


type alias Position =
    ( Int, Int )


type alias Bacterrior =
    { id : ID
    , position : Position
    }


model : Model
model =
    {}



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> Model
update msg model =
    case msg of
        Noop ->
            model



-- VIEW


view : Model -> Html msg
view model =
    div [] [ text "Hello" ]

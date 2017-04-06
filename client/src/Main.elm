module Main exposing (..)

import Html exposing (..)
import Time exposing (Time)
import AnimationFrame


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
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
    , healthPoints : Int
    , level : Int
    , experience : Int
    }


init : ( Model, Cmd Msg )
init =
    model ! []


model : Model
model =
    {}



-- UPDATE


type Msg
    = Noop
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        Tick time ->
            model ! []



-- SUBSCRIPTIONS


subscriptions model =
    AnimationFrame.times Tick



-- VIEW


view : Model -> Html msg
view model =
    div [] [ text "Hello" ]

module Main exposing (..)

import Html exposing (..)
import Time exposing (Time)
import AnimationFrame
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Keyboard


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { bacterrior : Bacterrior
    , shouldMoveTo : Position
    }


type Key
    = KeyNone
    | KeyArrowUp
    | KeyArrowLeft
    | KeyArrowRight
    | KeyArrowDown


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
    { bacterrior =
        { id = "A"
        , position = ( 0, 0 )
        , healthPoints = 100
        , level = 1
        , experience = 0
        }
    , shouldMoveTo = ( 0, 0 )
    }



-- UPDATE


type Msg
    = Noop
    | Tick Time
    | KeyPress Key


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        Tick time ->
            let
                ( posX, posY ) =
                    model.bacterrior.position

                ( moveX, moveY ) =
                    model.shouldMoveTo

                bacterrior =
                    model.bacterrior

                update bacterrior =
                    { bacterrior | position = ( posX + moveX, posY + moveY ) }
            in
                { model
                    | bacterrior = update bacterrior
                    , shouldMoveTo = ( 0, 0 )
                }
                    ! []

        KeyPress key ->
            case key of
                KeyArrowUp ->
                    { model | shouldMoveTo = ( 0, -1 ) } ! []

                KeyArrowLeft ->
                    { model | shouldMoveTo = ( -1, 0 ) } ! []

                KeyArrowRight ->
                    { model | shouldMoveTo = ( 1, 0 ) } ! []

                KeyArrowDown ->
                    { model | shouldMoveTo = ( 0, 1 ) } ! []

                KeyNone ->
                    model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.times Tick
        , Keyboard.downs keyPressed
        ]


keyPressed : Keyboard.KeyCode -> Msg
keyPressed code =
    case code of
        37 ->
            KeyPress KeyArrowLeft

        38 ->
            KeyPress KeyArrowUp

        39 ->
            KeyPress KeyArrowRight

        40 ->
            KeyPress KeyArrowDown

        _ ->
            KeyPress KeyNone



-- VIEW


bacterriorView : Bacterrior -> Html Msg
bacterriorView bacterrior =
    let
        ( posX, posY ) =
            bacterrior.position
    in
        rect
            [ toString posX |> x
            , toString posY |> y
            , width "10"
            , height "10"
            , rx "1"
            , ry "1"
            ]
            []


view : Model -> Html Msg
view model =
    svg
        [ width "120", height "120", viewBox "0 0 120 120" ]
        [ bacterriorView model.bacterrior ]

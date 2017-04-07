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


type Key
    = KeyNone
    | KeyArrowUp
    | KeyArrowLeft
    | KeyArrowRight
    | KeyArrowDown


type alias Model =
    { playerId : ID
    , world : World
    , bacterriors : List Bacterrior
    , moveTo : Position
    , frame : Int
    }


type alias ID =
    String


type alias Position =
    ( Int, Int )


type alias Size =
    ( Int, Int )


type alias Bacterrior =
    { id : ID
    , speed : Int
    , position : Position
    }


type alias World =
    { size : Size
    , position : Position
    }


init : ( Model, Cmd Msg )
init =
    model ! []


model : Model
model =
    { playerId = "A"
    , bacterriors =
        [ { id = "A"
          , speed = 1
          , position = ( 0, 0 )
          }
        , { id = "B"
          , speed = 1
          , position = ( 25, 25 )
          }
        ]
    , world =
        { size = ( 500, 500 )
        , position = ( 30, 30 )
        }
    , moveTo = ( 0, 0 )
    , frame = 1
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
            updateGame model ! []

        KeyPress key ->
            case key of
                KeyArrowUp ->
                    { model | moveTo = ( 0, -1 ) } ! []

                KeyArrowLeft ->
                    { model | moveTo = ( -1, 0 ) } ! []

                KeyArrowRight ->
                    { model | moveTo = ( 1, 0 ) } ! []

                KeyArrowDown ->
                    { model | moveTo = ( 0, 1 ) } ! []

                KeyNone ->
                    model ! []


updateGame : Model -> Model
updateGame model =
    { model
        | bacterriors = List.map updateBacterrior model.bacterriors
        , world = updateWorld model
        , moveTo = ( 0, 0 )
        , frame = updateFrame model.frame
    }


updateFrame : Int -> Int
updateFrame frame =
    (frame + 1) % 60


updateWorld : Model -> World
updateWorld model =
    let
        ( posX, posY ) =
            model.world.position

        ( moveX, moveY ) =
            model.moveTo

        world =
            model.world
    in
        { world | position = ( posX + moveX, posY + moveY ) }


updateBacterrior : Bacterrior -> Bacterrior
updateBacterrior bacterrior =
    bacterrior



-- let
--     ( posX, posY ) =
--         bacterrior.position
--
--     ( moveX, moveY ) =
--         model.moveTo
--
--     shouldUpdatePosition =
--         model.frame % model.bacterrior.speed == 0
--
--     updatePosition bacterrior =
--         if shouldUpdatePosition then
--             { bacterrior | position = ( posX + moveX, posY + moveY ) }
--         else
--             bacterrior
-- in
--     updatePosition model.bacterrior
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
--  transform transformValue
--         transformValue =
--             "translate(" ++ (toString posX) ++ "," ++ (toString posY) ++ ")"


bacterriorView : Bacterrior -> Html Msg
bacterriorView bacterrior =
    let
        ( posX, posY ) =
            bacterrior.position
    in
        g []
            [ rect
                [ fill "#00A896"
                , stroke "#028090"
                , width "10"
                , height "10"
                , y "5"
                ]
                []
            , rect
                [ fill "#F0F3BD"
                , width "2"
                , height "2"
                , x "5"
                , y "7"
                ]
                []
            , rect
                [ fill "#00FF00"
                , width "10"
                , height "1"
                , x "0"
                , y "0"
                ]
                []
            , rect
                [ fill "#F0F3BD"
                , width "10"
                , height "1"
                , x "0"
                , y "1"
                ]
                []
            ]


worldView : World -> Html Msg
worldView world =
    let
        ( posX, posY ) =
            world.position

        ( w, h ) =
            world.size
    in
        rect
            [ x <| toString posX
            , y <| toString posY
            , width <| toString w
            , height <| toString h
            , fill "#05668D"
            , stroke "#056600"
            ]
            []


view : Model -> Html Msg
view model =
    svg
        [ width "500", height "500", viewBox "0 0 100 100" ]
        ([ worldView model.world ] ++ (List.map bacterriorView model.bacterriors))

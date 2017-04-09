module Main exposing (..)

import Html exposing (Html)
import Time exposing (Time)
import AnimationFrame
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Window
import Keyboard
import Mouse
import Debug


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
    { windowSize : Window.Size
    , player : Bacterrior
    , world : World
    , bacterriors : List Bacterrior
    , food : List Food
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


type alias Food =
    { position : Position }


init : ( Model, Cmd Msg )
init =
    ( model, Task.perform WindowResize Window.size )


model : Model
model =
    { windowSize = { width = 0, height = 0 }
    , player =
        { id = "A"
        , speed = 1
        , position = ( 0, 0 )
        }
    , bacterriors =
        [ { id = "A"
          , speed = 1
          , position = ( 30, 30 )
          }
        ]
    , world =
        { size = ( 500, 500 )
        , position = ( 0, 0 )
        }
    , food =
        [ { position = ( 15, 15 )
          }
        ]
    , moveTo = ( 0, 0 )
    , frame = 1
    }



-- UPDATE


type Msg
    = Noop
    | Tick Time
    | KeyPress Key
    | MouseMoves Mouse.Position
    | WindowResize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        WindowResize size ->
            { model | windowSize = size } ! []

        Tick time ->
            updateGame model ! []

        MouseMoves { x, y } ->
            let
                cX =
                    model.windowSize.width // 2

                cY =
                    model.windowSize.height // 2

                x_ =
                    if x - cX > 0 then
                        1
                    else
                        -1

                y_ =
                    if y - cY > 0 then
                        1
                    else
                        -1
            in
                { model | moveTo = ( x_, y_ ) } ! []

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



-- , bacterriors = List.map updateBacterrior model.bacterriors


updateGame : Model -> Model
updateGame model =
    model
        |> updatePlayer
        |> updateBacterriors
        |> updateFood
        |> updateWorld
        |> updateFrame



--
-- { model
--     | player = updatePlayer model
--     , world = updateWorld model
--     , moveTo = ( 0, 0 )
--     , frame = updateFrame model.frame
-- }


updateFrame : Model -> Model
updateFrame model =
    { model | frame = (model.frame + 1) % 60 }



-- helper


shouldUpdatePosition : Model -> Bool
shouldUpdatePosition model =
    let
        ( moveX, moveY ) =
            model.moveTo

        ( sX, sY ) =
            model.world.size

        ( wX, wY ) =
            model.world.position

        overLeft =
            wX - moveX > 0

        overBottom =
            wY - moveY < -1 * sY + 10

        overRight =
            wX - moveX < -1 * sX + 10

        overTop =
            wY - moveY > 0
    in
        not (overLeft || overTop || overRight || overBottom)



-- overLeft || overRight || overTop || overBottom
-- not (overLeft || overTop)
-- not ()


updateWorld : Model -> Model
updateWorld model =
    let
        ( moveX, moveY ) =
            model.moveTo

        ( sX, sY ) =
            model.world.size

        ( posX, posY ) =
            model.world.position

        updatePosition world =
            if (shouldUpdatePosition model) == True then
                { world | position = ( posX - moveX, posY - moveY ) }
            else
                world
    in
        { model | world = model.world |> updatePosition }


updatePlayer : Model -> Model
updatePlayer model =
    let
        ( posX, posY ) =
            model.player.position

        ( moveX, moveY ) =
            model.moveTo

        updatePosition player =
            { player | position = ( posX + moveX, posY + moveY ) }
    in
        { model | player = model.player |> updatePosition }


updateBacterriors : Model -> Model
updateBacterriors model =
    let
        ( moveX, moveY ) =
            model.moveTo

        updatePosition bacterrior =
            let
                ( posX, posY ) =
                    bacterrior.position
            in
                { bacterrior | position = ( posX - moveX, posY - moveY ) }
    in
        { model | bacterriors = List.map updatePosition model.bacterriors }


updateFood : Model -> Model
updateFood model =
    let
        ( moveX, moveY ) =
            model.moveTo

        updatePosition food =
            let
                ( posX, posY ) =
                    food.position
            in
                { food | position = ( posX - moveX, posY - moveY ) }
    in
        { model | food = List.map updatePosition model.food }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.times Tick
        , Keyboard.downs keyPressed
        , Mouse.moves MouseMoves
        , Window.resizes WindowResize
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


foodView : Food -> Html Msg
foodView food =
    let
        ( posX, posY ) =
            food.position

        transformValue =
            "translate(" ++ (posX + 45 |> toString) ++ "," ++ (posY + 45 |> toString) ++ ")"
    in
        g [ transform transformValue ]
            [ rect
                [ fill "#F0F3BD"
                , width "1"
                , height "1"
                , x "0"
                , y "-2"
                ]
                []
            ]


bacterriorView : Bacterrior -> Html Msg
bacterriorView bacterrior =
    let
        ( posX, posY ) =
            bacterrior.position

        transformValue =
            "translate(" ++ (posX + 45 |> toString) ++ "," ++ (posY + 45 |> toString) ++ ")"
    in
        g [ transform transformValue ]
            [ rect
                [ fill "#028090"
                , width "10"
                , height "10"
                ]
                []
            , rect
                [ fill "#00A896"
                , width "8"
                , height "8"
                , x "1"
                , y "1"
                ]
                []
            , rect
                [ fill "#F0F3BD"
                , width "2"
                , height "2"
                , x "5"
                , y "3"
                ]
                []
            , rect
                [ fill "#FF0000"
                , width "10"
                , height "1"
                , x "0"
                , y "-3"
                ]
                []
            , rect
                [ fill "#F0F3BD"
                , width "1"
                , height "1"
                , x "0"
                , y "-2"
                ]
                []
            ]


playerView : Bacterrior -> Html Msg
playerView bacterrior =
    g [ transform "translate(45, 45)" ]
        [ rect
            [ fill "#028090"
            , width "10"
            , height "10"
            ]
            []
        , rect
            [ fill "#00A896"
            , width "8"
            , height "8"
            , x "1"
            , y "1"
            ]
            []
        , rect
            [ fill "#F0F3BD"
            , width "2"
            , height "2"
            , x "5"
            , y "3"
            ]
            []
        , rect
            [ fill "#00FF00"
            , width "10"
            , height "1"
            , x "0"
            , y "-3"
            ]
            []
        , rect
            [ fill "#F0F3BD"
            , width "1"
            , height "1"
            , x "0"
            , y "-2"
            ]
            []
        ]


worldView : World -> List (Html Msg)
worldView world =
    let
        ( posX, posY ) =
            world.position

        ( w, h ) =
            world.size
    in
        [ rect
            [ width "100%"
            , height "100%"
            , fill "#063F56"
            ]
            []
        , rect
            [ x <| toString (posX + 45)
            , y <| toString (posY + 45)
            , width <| toString w
            , height <| toString h
            , fill "#05668D"
            ]
            []
        ]


view : Model -> Html Msg
view model =
    svg
        [ width "100%", height "100%", viewBox "0 0 100 100" ]
        (worldView model.world
            ++ [ playerView model.player ]
            ++ (List.map bacterriorView model.bacterriors)
            ++ (List.map foodView model.food)
        )

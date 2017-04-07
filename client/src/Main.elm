module Main exposing (..)

import Html exposing (Html)
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
    { player : Bacterrior
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
    { player =
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



-- , bacterriors = List.map updateBacterrior model.bacterriors


updateGame : Model -> Model
updateGame model =
    model
        |> updatePlayer
        |> updateBacterriors
        |> updateWorld
        |> updateFrame
        |> updateMoveTo



--
-- { model
--     | player = updatePlayer model
--     , world = updateWorld model
--     , moveTo = ( 0, 0 )
--     , frame = updateFrame model.frame
-- }


updateMoveTo model =
    { model | moveTo = ( 0, 0 ) }


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
            wX - moveX >= 0

        overBottom =
            wY - moveY > sY

        overRight =
            wX - moveX > sX

        overTop =
            wY - moveY >= 0
    in
        overLeft || overRight || overTop || overBottom



-- not (overLeft || overTop)
-- not ()


updateWorld : Model -> Model
updateWorld model =
    let
        ( posX, posY ) =
            model.world.position

        ( moveX, moveY ) =
            model.moveTo

        updatePosition world =
            { world | position = ( posX - moveX, posY - moveY ) }
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
        (worldView model.world ++ [ playerView model.player ] ++ (List.map bacterriorView model.bacterriors))

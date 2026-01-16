module Docs.InputSlider exposing (Model, Msg, update, init, view)

import Attr
import Book
import Docs.UI
import W.InputSlider
import W.Playground
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as D


--


type alias Model =
    { playground : W.Playground.PlaygroundState
    , value : Float
    }


type Msg
    = UpdatePlayground W.Playground.PlaygroundState
    | UpdateValue Float


init : Model
init =
    { playground = W.Playground.init playground
    , value = 100.0
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePlayground v ->
            ( { model | playground = v }, Cmd.none )

        UpdateValue v ->
            ( { model | value = v }, Cmd.none )



--

playground : W.Playground.Playground (Model -> Book.Html Msg)
playground =
    W.Playground.succeed
        (\disabled small vertical min max step colorAttr { value } ->
            H.div
                []
                [ W.InputSlider.view
                    [ colorAttr
                    , Attr.if_ disabled W.InputSlider.disabled
                    , Attr.if_ small W.InputSlider.small
                    , Attr.if_ vertical W.InputSlider.vertical
                    ]
                    { min = min
                    , max = max
                    , step = step
                    , value = value
                    , onInput = Book.sendMsg << UpdateValue
                    }
                -- , H.div
                --     [ HA.class "w__knob" ]
                --     [ H.input
                --         [ HA.type_ "range"
                --         , HA.class "w__knob__input"
                --         , HA.value <| String.fromFloat value
                --         , HA.min <| String.fromFloat min
                --         , HA.max <| String.fromFloat max
                --         , HA.step <| String.fromFloat step
                --         , HE.on "input"
                --             (D.at [ "target", "value" ] D.string
                --                 |> D.andThen
                --                     (\v ->
                --                         case String.toFloat v of
                --                             Just v_ ->
                --                                 D.succeed v_

                --                             Nothing ->
                --                                 D.fail "Invalid value."
                --                     )
                --                 -- |> D.map props.onInput
                --                 |> D.map (Book.sendMsg << UpdateValue)
                --             )
                --         ]
                --         []
                    -- ]
                ]
        )
        |> W.Playground.bool
            { name = "Disabled"
            , description = "a"
            , default = False
            }
        |> W.Playground.bool
            { name = "Small"
            , description = "a"
            , default = False
            }
        |> W.Playground.bool
            { name = "Vertical"
            , description = "a"
            , default = False
            }
        |> W.Playground.float
            { name = "Min"
            , description = "a"
            , default = 0.0
            }
        |> W.Playground.float
            { name = "Max"
            , description = "a"
            , default = 250.0
            }
        |> W.Playground.float
            { name = "Step"
            , description = "a"
            , default = 50.0
            }
        |> W.Playground.attr
            { name = "Custom Color"
            , description = "e"
            , defaultOption = ( "Default", Attr.none )
            , otherOptions = [ ( "Red", W.InputSlider.color "red" ), ( "Violet", W.InputSlider.color "violet" ) ]
            }


view : Book.Page Model Msg
view =
    Book.pageStateful "Input Slider"
        (\model ->
            [ W.Playground.view
                { playground = playground
                , toHtml = \fn -> fn model
                , onUpdate = Book.sendMsg << UpdatePlayground
                }
                model.playground
            ]
        )

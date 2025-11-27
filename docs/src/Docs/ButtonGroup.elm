module Docs.ButtonGroup exposing (Model, Msg, init, update, view)

import Attr
import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Button
import W.ButtonGroup
import W.Playground



--


type alias Model =
    { single : String
    , optional : Maybe String
    , multiple : List String
    , playground : W.Playground.PlaygroundState
    , playgroundValue : String
    }


type Msg
    = Single_Selected String
    | Optional_Selected (Maybe String)
    | Multiple_Selected (List String)
    | Playground_Update W.Playground.PlaygroundState
    | Playground_UpdateValue String


init : Model
init =
    { single = "Second"
    , optional = Just "Third"
    , multiple = [ "First", "Third" ]
    , playgroundValue = "Third"
    , playground = W.Playground.init (W.Playground.succeed ())
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Single_Selected v ->
            ( { model | single = v }, Cmd.none )

        Optional_Selected v ->
            ( { model | optional = v }, Cmd.none )

        Multiple_Selected v ->
            ( { model | multiple = v }, Cmd.none )

        Playground_Update v ->
            ( { model | playground = v }, Cmd.none )

        Playground_UpdateValue v ->
            ( { model | playgroundValue = v }, Cmd.none )



--


view : Book.Page Model Msg
view =
    let
        items : List String
        items =
            [ "First", "Second", "Third", "Fourth" ]
    in
    Book.pageStateful "ButtonGroup"
        (\model ->
            Docs.UI.viewPlayground
                { value = model.playground
                , onUpdate = Playground_Update
                , playground =
                    W.Playground.succeed
                        (\fullAttr prefixAttr suffixAttr styleAttr sizeAttr roundedAttr ->
                            W.ButtonGroup.view
                                [ fullAttr
                                , sizeAttr
                                , roundedAttr
                                , prefixAttr
                                , suffixAttr
                                , styleAttr
                                ]
                                { value = model.playgroundValue
                                , options = items
                                , toLabel = \x -> [ H.text x ]
                                , onInput = Book.sendMsg << Playground_UpdateValue
                                }
                        )
                        |> W.Playground.boolAttr
                            { name = "Full"
                            , description = ""
                            , default = False
                            , attr = W.ButtonGroup.full
                            }
                        |> W.Playground.boolAttr
                            { name = "Prefix"
                            , description = ""
                            , default = False
                            , attr = W.ButtonGroup.prefix [ H.span [ HA.class "w--px-sm w--text-subtle" ] [ H.text "Label" ] ]
                            }
                        |> W.Playground.boolAttr
                            { name = "Suffix"
                            , description = ""
                            , default = False
                            , attr = W.ButtonGroup.suffix [ H.span [] [ H.text "Extra" ] ]
                            }
                        |> W.Playground.boolAttr
                            { name = "Subtle"
                            , description = ""
                            , default = False
                            , attr = W.ButtonGroup.subtle
                            }
                        |> W.Playground.attr
                            { name = "Size"
                            , description = ""
                            , defaultOption = ( "Default", Attr.none )
                            , otherOptions =
                                [ ( "Small", W.ButtonGroup.small )
                                , ( "Large", W.ButtonGroup.large )
                                ]
                            }
                        |> W.Playground.attr
                            { name = "Rounded"
                            , description = ""
                            , defaultOption = ( "Default", Attr.none )
                            , otherOptions =
                                [ ( "Rounded", W.ButtonGroup.rounded )
                                , ( "Custom", W.ButtonGroup.radius 0.2 )
                                ]
                            }
                }
                :: List.map Docs.UI.viewExample
                    [ ( "Default"
                      , [ W.ButtonGroup.view
                            []
                            { value = model.single
                            , options = items
                            , toLabel = \x -> [ H.text x ]
                            , onInput = Book.sendMsg << Single_Selected
                            }
                        ]
                      )
                    , ( "Optional"
                      , [ W.ButtonGroup.viewOptional
                            []
                            { value = model.optional
                            , options = items
                            , toLabel = \x -> [ H.text x ]
                            , onInput = Book.sendMsg << Optional_Selected
                            }
                        ]
                      )
                    , ( "Multiple"
                      , [ W.ButtonGroup.viewMultiple
                            []
                            { value = model.multiple
                            , options = items
                            , toLabel = \x -> [ H.text x ]
                            , onInput = Book.sendMsg << Multiple_Selected
                            }
                        ]
                      )
                    , ( "Buttons"
                      , [ W.ButtonGroup.viewButtons []
                            (items
                                |> List.map
                                    (\item ->
                                        { label = [ H.text item ]
                                        , onClick = Book.logActionWithString "Clicked" item
                                        , attrs = [ W.Button.invisible ]
                                        }
                                    )
                            )
                        ]
                      )
                    , ( "Links"
                      , [ W.ButtonGroup.viewLinks []
                            (items
                                |> List.map
                                    (\item ->
                                        { label = [ H.text item ]
                                        , href = "/logAction/" ++ item
                                        , attrs = [ W.Button.invisible ]
                                        }
                                    )
                            )
                        ]
                      )
                    ]
        )

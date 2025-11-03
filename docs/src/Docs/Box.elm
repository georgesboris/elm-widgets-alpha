module Docs.Box exposing (Model, Msg, init, update, view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Playground
import W.Theme.Color
import W.Theme.Radius
import W.Theme.Spacing



--


type alias Model =
    { playground : W.Playground.PlaygroundState
    }


type Msg
    = UpdatePlayground W.Playground.PlaygroundState


init : Model
init =
    { playground = W.Playground.init playground
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePlayground v ->
            ( { model | playground = v }, Cmd.none )



-- Playground


playground : W.Playground.Playground (H.Html msg)
playground =
    W.Playground.succeed
        (\xFlex yFlex ->
            W.Box.view
                [ W.Box.gap W.Theme.Spacing.xs
                , W.Box.padding W.Theme.Spacing.lg
                , W.Box.card
                ]
                [ W.Box.view
                    [ W.Box.gap W.Theme.Spacing.xs
                    , W.Box.size 8
                    , W.Box.flex [ xFlex, yFlex ]
                    ]
                    [ square
                    , square
                    , square
                    , square
                    ]
                ]
        )
        |> W.Playground.attr
            { name = "Horizontal Alignment"
            , description = "b"
            , defaultOption = ( "Start", W.Box.xLeft )
            , otherOptions =
                [ ( "Space Between", W.Box.xSpaceBetween )
                , ( "Space Around", W.Box.xSpaceAround )
                , ( "Space Evenly", W.Box.xSpaceEvenly )
                , ( "Stretch", W.Box.xStretch )
                , ( "Center", W.Box.xCenter )
                , ( "End", W.Box.xRight )
                ]
            }
        |> W.Playground.attr
            { name = "Vertical Alignment"
            , description = "b"
            , defaultOption = ( "Start", W.Box.yTop )
            , otherOptions =
                [ ( "Space Between", W.Box.ySpaceBetween )
                , ( "Space Around", W.Box.ySpaceAround )
                , ( "Space Evenly", W.Box.ySpaceEvenly )
                , ( "Stretch", W.Box.yStretch )
                , ( "Center", W.Box.yCenter )
                , ( "End", W.Box.yBottom )
                ]
            }



-- Box


view : Book.Page Model Msg
view =
    Book.pageStateful "Box"
        (\model ->
            W.Playground.view
                { playground = playground
                , toHtml = identity
                , onUpdate = Book.sendMsg << UpdatePlayground
                }
                model.playground
                :: List.map Docs.UI.viewExample
                    [ ( "Flex"
                      , [ W.Box.view
                            [ W.Box.gap W.Theme.Spacing.xs
                            , W.Box.padding W.Theme.Spacing.lg
                            , W.Box.background W.Theme.Color.tintSubtle
                            , W.Box.radius W.Theme.Radius.md
                            ]
                            [ W.Box.view
                                [ W.Box.gap W.Theme.Spacing.xs
                                , W.Box.flex [ W.Box.xSpaceBetween ]
                                ]
                                [ square
                                , square
                                , square
                                , square
                                ]
                            , W.Box.view
                                [ W.Box.gap W.Theme.Spacing.xs
                                , W.Box.flex [ W.Box.xSpaceEvenly ]
                                ]
                                [ square
                                , square
                                , square
                                , square
                                ]
                            , W.Box.view
                                [ W.Box.gap W.Theme.Spacing.xs
                                , W.Box.flex [ W.Box.xCenter ]
                                ]
                                [ square
                                , square
                                , square
                                , square
                                ]
                            , W.Box.view
                                [ W.Box.gap W.Theme.Spacing.xs
                                , W.Box.flex [ W.Box.xCenter ]
                                ]
                                [ square
                                , square
                                , square
                                , square
                                ]
                            ]
                        ]
                      )
                    , ( "Grid"
                      , let
                            gridColumn : List (W.Box.Attribute msg) -> H.Html msg
                            gridColumn attrs =
                                W.Box.view
                                    (attrs
                                        ++ [ W.Box.height 2
                                           , W.Box.tint
                                           ]
                                    )
                                    []
                        in
                        [ W.Box.view
                            [ W.Box.gap W.Theme.Spacing.sm
                            , W.Box.grid []
                            ]
                            [ gridColumn [ W.Box.columnSpan 3 ]
                            , gridColumn [ W.Box.columnSpan 2 ]
                            , gridColumn [ W.Box.columnSpan 5 ]
                            , gridColumn [ W.Box.columnSpan 3, W.Box.columnStart 2 ]
                            ]
                        ]
                      )
                    , ( "Box"
                      , [ W.Box.view
                            [ W.Box.padding W.Theme.Spacing.md
                            , W.Box.tint
                            , W.Box.radius W.Theme.Radius.md
                            , W.Box.flex [ W.Box.wrap, W.Box.yStretch ]
                            , W.Box.gap W.Theme.Spacing.md
                            ]
                            ([ W.Box.viewLink
                                [ W.Box.flex []
                                , W.Box.cardSmall
                                , W.Box.width 6
                                , W.Box.squareRatio
                                , W.Box.gap W.Theme.Spacing.xs
                                , W.Box.shadowLarge
                                , W.Box.padding W.Theme.Spacing.md
                                , W.Box.primary
                                ]
                                { href = "#"
                                , content = [ square, square ]
                                }
                             , W.Box.viewLink
                                [ W.Box.card
                                , W.Box.width 6
                                , W.Box.squareRatio
                                , W.Box.solid
                                ]
                                { href = "#"
                                , content = []
                                }
                             , W.Box.viewLink
                                [ W.Box.card
                                , W.Box.width 6
                                , W.Box.squareRatio
                                , W.Box.bg
                                ]
                                { href = "#"
                                , content = []
                                }
                             , W.Box.viewLink
                                [ W.Box.card
                                , W.Box.width 6
                                , W.Box.squareRatio
                                , W.Box.subtle
                                ]
                                { href = "#"
                                , content = []
                                }
                             , W.Box.viewLink
                                [ W.Box.cardLarge
                                , W.Box.width 6
                                , W.Box.squareRatio
                                , W.Box.solid
                                , W.Box.danger
                                , W.Box.padding W.Theme.Spacing.md
                                ]
                                { href = "#"
                                , content = [ H.text "Click moi" ]
                                }
                             ]
                                |> List.repeat 3
                                |> List.concat
                            )
                        ]
                      )
                    ]
        )


square : H.Html msg
square =
    W.Box.view
        [ W.Box.height 1
        , W.Box.width 1
        , W.Box.background W.Theme.Color.text
        , W.Box.radius W.Theme.Radius.md
        ]
        []

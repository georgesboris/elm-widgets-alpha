module Docs.Box exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Theme.Color
import W.Theme.Spacing
import W.Theme.Radius
import W.Theme


view : Book.Page model msg
view =
    Book.page "Box"
        (List.map Docs.UI.viewExample
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
                    [ W.Box.gap W.Theme.Spacing.xs
                    , W.Box.padding W.Theme.Spacing.md
                    , W.Box.tint
                    , W.Box.radius W.Theme.Radius.md
                    , W.Box.flex [ W.Box.wrap, W.Box.yStretch ]
                    , W.Box.gap W.Theme.Spacing.md
                    ]
                    ([ W.Box.view
                        [ W.Box.flex []
                        , W.Box.square
                        , W.Box.gap W.Theme.Spacing.xs
                        , W.Box.radius W.Theme.Radius.md
                        , W.Box.shadowLarge
                        , W.Box.padding W.Theme.Spacing.md
                        , W.Box.primary
                        , W.Box.solid
                        ]
                        [ square, square ]
                    , W.Box.view
                        [ W.Box.shadowSmall
                        , W.Box.square
                        , W.Box.solid
                        , W.Box.radius W.Theme.Radius.md
                        ]
                        []
                    , W.Box.viewLink
                        [ W.Box.shadowLarge
                        , W.Box.square
                        , W.Box.radius W.Theme.Radius.md
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

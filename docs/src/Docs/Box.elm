module Docs.Box exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Spacing
import W.Theme


view : Book.Page model msg
view =
    Book.page "Box"
        (List.map Docs.UI.viewExample
            [ ( "Flex"
              , [ W.Box.view
                    [ W.Box.gap W.Spacing.xs
                    , W.Box.padding W.Spacing.lg
                    , W.Box.background W.Theme.color.tintSubtle
                    , W.Box.rounded
                    ]
                    [ W.Box.view
                        [ W.Box.gap W.Spacing.xs
                        , W.Box.flex [ W.Box.xSpaceBetween ]
                        ]
                        [ square
                        , square
                        , square
                        , square
                        ]
                    , W.Box.view
                        [ W.Box.gap W.Spacing.xs
                        , W.Box.flex [ W.Box.xSpaceEvenly ]
                        ]
                        [ square
                        , square
                        , square
                        , square
                        ]
                    , W.Box.view
                        [ W.Box.gap W.Spacing.xs
                        , W.Box.flex [ W.Box.xCenter ]
                        ]
                        [ square
                        , square
                        , square
                        , square
                        ]
                    , W.Box.view
                        [ W.Box.gap W.Spacing.xs
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
                    [ W.Box.gap W.Spacing.sm
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
                    [ W.Box.gap W.Spacing.xs
                    , W.Box.height 6
                    , W.Box.padding W.Spacing.md
                    , W.Box.tint
                    , W.Box.rounded
                    , W.Box.grid []
                    ]
                    [ W.Box.view
                        [ W.Box.flex []
                        , W.Box.gap W.Spacing.xs
                        , W.Box.rounded
                        , W.Box.shadowLarge
                        , W.Box.padding W.Spacing.md
                        , W.Box.primary
                        , W.Box.solid
                        ]
                        [ square, square ]
                    , W.Box.view
                        [ W.Box.shadowSmall
                        , W.Box.tint
                        , W.Box.rounded
                        ]
                        []
                    , W.Box.viewLink
                        [ W.Box.shadowLarge
                        , W.Box.rounded
                        , W.Box.solid
                        , W.Box.danger
                        ]
                        { href = "#"
                        , content = [ H.text "Click moi" ]
                        }
                    ]
                ]
              )
            ]
        )


square : H.Html msg
square =
    W.Box.view
        [ W.Box.height 1
        , W.Box.width 1
        , W.Box.background W.Theme.color.text
        , W.Box.rounded
        ]
        []

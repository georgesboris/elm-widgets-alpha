module Docs.Typography exposing (view)

import Attr
import Book
import Docs.UI
import Html as H
import W.Box
import W.Divider
import W.Heading
import W.Sizing
import W.Spacing
import W.Text
import W.TextInline


view : Book.Page model msg
view =
    Book.page "Typography"
        (List.map Docs.UI.viewExample
            [ ( ""
              , [ ( W.Spacing.xl, W.Heading.extraLarge, W.Text.extraLarge )
                , ( W.Spacing.lg, W.Heading.large, W.Text.large )
                , ( W.Spacing.md, Attr.none, Attr.none )
                , ( W.Spacing.sm, W.Heading.small, W.Text.small )
                , ( W.Spacing.xs, W.Heading.extraSmall, W.Text.extraSmall )
                ]
                    |> List.map
                        (\( spacing, headingSize, textSize ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.xRight ] ]
                                [ W.Box.view
                                    [ W.Box.maxWidth W.Sizing.xl
                                    , W.Box.gap spacing
                                    , W.Box.padding W.Spacing.md
                                    ]
                                    [ W.Heading.view
                                        [ headingSize ]
                                        [ H.text "The quick brown fox jumps over the lazy dog" ]
                                    , W.Text.view
                                        [ textSize ]
                                        [ H.text "Lorem ipsum dolor sit amet, "
                                        , W.TextInline.view
                                            [ W.TextInline.bold, W.TextInline.underline ]
                                            [ H.text "consectetur adipiscing elit" ]
                                        , H.text ", sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                                        , W.TextInline.view
                                            [ W.TextInline.subtle ]
                                            [ H.text "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex"
                                            , W.TextInline.view [ W.TextInline.subscript ] [ H.text "ea" ]
                                            , H.text " commodo consequat."
                                            ]
                                        ]
                                    ]
                                ]
                        )
                    |> List.intersperse
                        (W.Divider.view
                            [ W.Divider.subtle, W.Divider.thin ]
                            []
                        )
              )
            ]
        )

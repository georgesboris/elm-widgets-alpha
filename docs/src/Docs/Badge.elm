module Docs.Badge exposing (view)

import Book
import Docs.UI
import Html as H
import W.Badge
import W.Box
import W.Button
import W.Spacing


view : Book.Page model msg
view =
    Book.page "Badge"
        [ W.Box.view
            [ W.Box.gap W.Spacing.xl2
            , W.Box.flex [ W.Box.yTop ]
            ]
            [ Docs.UI.viewVertical
                [ W.Button.viewDummy [] [ H.text "Updates", W.Badge.view [] [ H.text "48" ] ]
                , W.Button.viewDummy [ W.Button.small ] [ H.text "Updates", W.Badge.view [ W.Badge.small ] [ H.text "120" ] ]
                ]
            , W.Box.view
                [ W.Box.gap W.Spacing.xl ]
                [ W.Box.view [ W.Box.flex [], W.Box.gap W.Spacing.sm ]
                    [ W.Badge.view [ W.Badge.inline ] [ H.text "123" ]
                    , W.Badge.view [ W.Badge.inline, W.Badge.primary ] [ H.text "123" ]
                    , W.Badge.view [ W.Badge.inline, W.Badge.secondary ] [ H.text "123" ]
                    ]
                , W.Box.view [ W.Box.flex [], W.Box.gap W.Spacing.sm ]
                    [ W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.base ] [ H.text "123" ]
                    , W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.success ] [ H.text "123" ]
                    , W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.customColor { color = "#dadada", background = "#000000" } ] [ H.text "123" ]
                    ]
                ]
            ]
        ]

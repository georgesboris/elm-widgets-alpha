module Docs.Feedback exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Badge
import W.Button
import W.Loading
import W.Skeleton
import W.Theme


view : Book.Page model msg
view =
    Book.pageWithExamples "Feedback"
        [ ( "Badge"
          , [ Docs.UI.viewHorizontal
                [ W.Badge.view [ W.Badge.inline ] [ H.text "123" ]
                , W.Badge.view [ W.Badge.inline, W.Badge.primary ] [ H.text "123" ]
                , W.Badge.view [ W.Badge.inline, W.Badge.secondary ] [ H.text "123" ]
                ]
            , Docs.UI.viewHorizontal
                [ W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.base ] [ H.text "123" ]
                , W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.success ] [ H.text "123" ]
                , W.Badge.view [ W.Badge.inline, W.Badge.small, W.Badge.customColor { color = "#dadada", background = "#000000" } ] [ H.text "123" ]
                ]
            , H.div
                [ HA.class "w--inline-block w--relative" ]
                [ W.Button.viewDummy [] [ H.text "Updates" ]
                , W.Badge.view [ W.Badge.small ] [ H.text "48" ]
                ]
            ]
          )
        , ( "Skeleton"
          , [ Docs.UI.viewVertical
                [ W.Skeleton.view [ W.Skeleton.noAnimation, W.Skeleton.circle 4 ]
                , W.Skeleton.view [ W.Skeleton.radius 0.5, W.Skeleton.height 8 ]
                , W.Skeleton.view [ W.Skeleton.relativeWidth 0.8 ]
                , W.Skeleton.view [ W.Skeleton.relativeWidth 0.3 ]
                ]
            ]
          )
        ]

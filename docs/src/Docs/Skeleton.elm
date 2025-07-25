module Docs.Skeleton exposing (view)

import Book
import Html as H
import W.Box
import W.Skeleton
import W.Theme.Spacing


view : Book.Page model msg
view =
    Book.page "Skeleton"
        [ W.Box.view
            [ W.Box.gap W.Theme.Spacing.xl ]
            [ example [] [ W.Skeleton.subtle, W.Skeleton.noAnimation ]
            , example [ W.Box.bg ] []
            , example [ W.Box.tint ] [ W.Skeleton.strong ]
            ]
        ]


example : List (W.Box.Attribute msg) -> List W.Skeleton.Attribute -> H.Html msg
example boxAttrs skeletonAttrs =
    W.Box.view
        ([ W.Box.rounded
         , W.Box.padding W.Theme.Spacing.md
         , W.Box.gap W.Theme.Spacing.md
         ]
            ++ boxAttrs
        )
        [ W.Skeleton.view (W.Skeleton.circle 4 :: skeletonAttrs)
        , W.Skeleton.view ([ W.Skeleton.radius 0.5, W.Skeleton.height 8 ] ++ skeletonAttrs)
        , W.Skeleton.view (W.Skeleton.relativeWidth 0.8 :: skeletonAttrs)
        , W.Skeleton.view (W.Skeleton.relativeWidth 0.3 :: skeletonAttrs)
        ]

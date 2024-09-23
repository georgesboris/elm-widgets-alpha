module Docs.Skeleton exposing (view)

import Book
import Docs.UI
import W.Skeleton


view : Book.Page model msg
view =
    Book.page "Skeleton"
        [ Docs.UI.viewVertical
            [ W.Skeleton.view [ W.Skeleton.noAnimation, W.Skeleton.circle 4 ]
            , W.Skeleton.view [ W.Skeleton.radius 0.5, W.Skeleton.height 8 ]
            , W.Skeleton.view [ W.Skeleton.relativeWidth 0.8 ]
            , W.Skeleton.view [ W.Skeleton.relativeWidth 0.3 ]
            ]
        ]

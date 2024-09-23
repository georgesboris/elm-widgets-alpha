module Docs.Loading exposing (view)

import Book
import Docs.UI
import W.Loading
import W.Theme


view : Book.Page model msg
view =
    Book.page "Loading"
        [ Docs.UI.viewHorizontal
            [ W.Loading.view
                [ W.Loading.size 40
                , W.Loading.color W.Theme.primaryScale.accent
                ]
            , W.Loading.view
                [ W.Loading.circles
                , W.Loading.size 40
                , W.Loading.color W.Theme.primaryScale.accentStrong
                ]
            , W.Loading.view
                [ W.Loading.ripples
                , W.Loading.size 40
                , W.Loading.color W.Theme.secondaryScale.accentStrong
                ]
            , W.Loading.view [ W.Loading.circles ]
            ]
        ]

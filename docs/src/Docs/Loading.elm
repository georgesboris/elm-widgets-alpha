module Docs.Loading exposing (view)

import Book
import Docs.UI
import W.Loading
import W.Theme
import W.Theme.Color


view : Book.Page model msg
view =
    Book.page "Loading"
        [ Docs.UI.viewHorizontal
            [ W.Loading.view
                [ W.Loading.size 40
                , W.Loading.color W.Theme.Color.primaryAccent
                ]
            , W.Loading.view
                [ W.Loading.circles
                , W.Loading.size 40
                , W.Loading.color W.Theme.Color.primaryAccentStrong
                ]
            , W.Loading.view
                [ W.Loading.ripples
                , W.Loading.size 40
                , W.Loading.color W.Theme.Color.secondaryAccentStrong
                ]
            , W.Loading.view [ W.Loading.circles ]
            ]
        ]

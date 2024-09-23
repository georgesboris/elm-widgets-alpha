module Docs.Avatar exposing (view)

import Book
import Docs.UI
import W.Avatar
import W.Box


view : Book.Page model msg
view =
    Book.page "Avatar"
        [ Docs.UI.viewHorizontal
            [ W.Avatar.view [ W.Avatar.large ]
            , W.Avatar.view []
            , W.Avatar.view [ W.Avatar.small ]
            ]
        , Docs.UI.viewHorizontal
            [ W.Avatar.view [ W.Avatar.name "User" ]
            , W.Avatar.view [ W.Avatar.names "User" "Name" ]
            , W.Avatar.view [ W.Avatar.name "User", W.Avatar.theme { color = "white", background = "black" } ]
            , W.Avatar.view [ W.Avatar.custom (W.Box.view [ W.Box.solid, W.Box.square, W.Box.width 1 ] []) ]
            , W.Avatar.view [ W.Avatar.image "https://picsum.photos/200/200" ]
            ]
        ]

module Docs.DataRow exposing (view)

import Book
import Html as H
import W.Avatar
import W.DataRow
import W.Spacing


view : Book.Page model msg
view =
    Book.page "DataRow"
        [ W.DataRow.viewExtra
            [ W.DataRow.padding W.Spacing.md
            ]
            { header = [ H.text "Header" ]
            , main = [ H.text "Main" ]
            , footer = [ H.text "footer" ]
            , left =
                [ W.Avatar.view
                    [ W.Avatar.large
                    , W.Avatar.names "Georges" "Boris"
                    ]
                ]
            , right =
                [ W.Avatar.view
                    [ W.Avatar.large
                    , W.Avatar.names "Georges" "Boris"
                    ]
                ]
            }
        ]

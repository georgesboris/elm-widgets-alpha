module Docs.Divider exposing (view)

import Book
import Html as H
import Html.Attributes as HA
import W.Divider
import W.Theme


view : Book.Page model Book.Msg
view =
    Book.page "Divider"
        [ H.div
            [ HA.class "w--grid w--grid-cols-2" ]
            [ H.div []
                [ W.Divider.view [ W.Divider.margins 1 ] []
                , W.Divider.view [ W.Divider.margins 1, W.Divider.subtle ] [ H.text "Content" ]
                , W.Divider.view [ W.Divider.margins 1, W.Divider.color W.Theme.color.tint ] []
                ]
            , H.div
                [ HA.class "w--flex w--justify-around"
                , HA.style "height" "68px"
                , HA.style "padding" "16px 0"
                ]
                [ W.Divider.view [ W.Divider.vertical ] []
                , W.Divider.view [ W.Divider.vertical, W.Divider.subtle ] [ H.text "Content" ]
                , W.Divider.view [ W.Divider.vertical, W.Divider.color W.Theme.color.tint ] []
                ]
            ]
        ]

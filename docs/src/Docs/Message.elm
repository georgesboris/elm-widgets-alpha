module Docs.Message exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Message
import W.Theme.Color
import W.Theme.Spacing
import W.Theme


view : Book.Page model Book.Msg
view =
    Book.page "Message"
        ([ ( [], "Neutral" )
         , ( [ W.Message.variant W.Theme.Color.Primary ], "Primary" )
         , ( [ W.Message.variant W.Theme.Color.Secondary ], "Secondary" )
         , ( [ W.Message.variant W.Theme.Color.Success ], "Success" )
         , ( [ W.Message.variant W.Theme.Color.Warning ], "Warning" )
         , ( [ W.Message.variant W.Theme.Color.Danger ], "Danger" )
         ]
            |> List.map
                (\( attrs, label ) ->
                    Docs.UI.viewExample
                        ( label
                        , [ Docs.UI.viewVertical
                                [ W.Message.view attrs [ H.text label ]
                                , W.Message.view (W.Message.onClick (Book.logAction "onClick") :: attrs) [ H.text label ]
                                , W.Message.view (W.Message.href "/logAction/#" :: attrs) [ H.text label ]
                                , W.Message.view
                                    (attrs
                                        ++ [ W.Message.icon [ H.text "i" ]
                                           , W.Message.footer [ H.text "Footer" ]
                                           ]
                                    )
                                    [ H.text label ]
                                ]
                          ]
                        )
                )
        )

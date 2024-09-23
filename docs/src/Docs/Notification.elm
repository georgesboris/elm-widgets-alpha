module Docs.Notification exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Notification
import W.Spacing
import W.Theme


view : Book.Page model Book.Msg
view =
    Book.page "Notification"
        ([ ( [], "Neutral" )
         , ( [ W.Notification.primary ], "Primary" )
         , ( [ W.Notification.secondary ], "Secondary" )
         , ( [ W.Notification.success ], "Success" )
         , ( [ W.Notification.warning ], "Warning" )
         , ( [ W.Notification.danger ], "Danger" )
         ]
            |> List.map
                (\( attrs, label ) ->
                    Docs.UI.viewExample
                        ( label
                        , [ Docs.UI.viewVertical
                                [ W.Notification.view attrs [ H.text label ]
                                , W.Notification.view (W.Notification.onClick (Book.logAction "onClick") :: attrs) [ H.text label ]
                                , W.Notification.view (W.Notification.onClose (Book.logAction "onClose") :: attrs) [ H.text label ]
                                , W.Notification.view (W.Notification.href "/logAction/#" :: attrs) [ H.text label ]
                                , W.Notification.view
                                    (attrs
                                        ++ [ W.Notification.icon [ H.text "i" ]
                                           , W.Notification.footer [ H.text "Footer" ]
                                           ]
                                    )
                                    [ H.text label ]
                                ]
                          ]
                        )
                )
        )

module Docs.Tag exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Tag
import W.Theme.Spacing


view : Book.Page model Book.Msg
view =
    Book.page "Tag"
        ([ ( [], "Neutral" )
         , ( [ W.Tag.primary ], "Primary" )
         , ( [ W.Tag.secondary ], "Secondary" )
         , ( [ W.Tag.success ], "Success" )
         , ( [ W.Tag.warning ], "Warning" )
         , ( [ W.Tag.danger ], "Danger" )
         , ( [ W.Tag.color
                { text = "black"
                , background = "white"
                }
             ]
           , "Custom Color"
           )
         ]
            |> List.map
                (\( attrs, label ) ->
                    Docs.UI.viewExample
                        ( label
                        , [ W.Box.view
                                [ W.Box.gap W.Theme.Spacing.md
                                , W.Box.flex []
                                ]
                                [ W.Tag.view (W.Tag.large :: attrs) [ H.text label ]
                                , W.Tag.view attrs [ H.text label ]
                                , W.Tag.viewButton attrs { onClick = Book.logAction "onClick", label = [ H.text label ] }
                                , W.Tag.viewLink attrs { href = "/logAction/#", label = [ H.text label ] }
                                , W.Tag.view (W.Tag.small :: attrs) [ H.text label ]
                                ]
                          ]
                        )
                )
        )

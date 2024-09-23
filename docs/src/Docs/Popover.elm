module Docs.Popover exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Button
import W.Divider
import W.Popover


view : Book.Page model Book.Msg
view =
    Book.page "Popover"
        (List.map Docs.UI.viewExample
            ([ ( "Bottom (Persistent)", [ W.Popover.persistent ] )
             , ( "Bottom Right", [ W.Popover.bottomRight ] )
             , ( "Top", [ W.Popover.top ] )
             , ( "Top Right", [ W.Popover.topRight ] )
             , ( "Left", [ W.Popover.left ] )
             , ( "Left Bottom", [ W.Popover.leftBottom ] )
             , ( "Right", [ W.Popover.right ] )
             , ( "Right Bottom", [ W.Popover.rightBottom ] )
             ]
                |> List.map
                    (\( label, attrs ) ->
                        ( label
                        , [ Docs.UI.viewHorizontal
                                [ W.Popover.view attrs (popoverChildren "Default")
                                , W.Popover.view (W.Popover.width 180 :: W.Popover.over :: attrs) (popoverChildren "Over")
                                , W.Popover.view (W.Popover.width 180 :: W.Popover.offset 4 :: attrs) (popoverChildren "Offset")
                                , W.Popover.view (W.Popover.width 180 :: W.Popover.full True :: attrs) (popoverChildren "Full")
                                , W.Popover.view (W.Popover.width 180 :: W.Popover.showOnHover :: W.Popover.offset 4 :: attrs) (popoverChildren "Hover")
                                ]
                          ]
                        )
                    )
            )
        )


popoverChildren :
    String
    ->
        { content : List (H.Html msg)
        , trigger : List (H.Html msg)
        }
popoverChildren label =
    { content =
        [ W.Box.view
            [ W.Box.solid ]
            [ W.Button.viewDummy [ W.Button.full ] [ H.text "[[ Item ]]" ]
            , W.Button.viewDummy [ W.Button.full ] [ H.text "[[ Item ]]" ]
            , W.Divider.view [] []
            , W.Popover.view
                [ W.Popover.showOnHover
                , W.Popover.right
                , W.Popover.width 120
                , W.Popover.offset 4
                ]
                { trigger =
                    [ W.Button.viewDummy [ W.Button.full ] [ H.text "[[ Item ]]" ] ]
                , content =
                    [ W.Box.view
                        [ W.Box.solid ]
                        [ W.Button.viewDummy [ W.Button.full ] [ H.text "[[ Item ]]" ]
                        , W.Button.viewDummy [ W.Button.full ] [ H.text "[[ Item ]]" ]
                        ]
                    ]
                }
            ]
        ]
    , trigger =
        [ W.Button.viewDummy [] [ H.text label ]
        ]
    }

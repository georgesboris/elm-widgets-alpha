module Docs.Menu exposing (view)

import Book
import Docs.UI
import Html as H
import W.Button
import W.Menu
import W.Skeleton
import W.Theme.Spacing


view : Book.Page model Book.Msg
view =
    let
        items : List (H.Html Book.Msg)
        items =
            [ W.Menu.viewButton
                [ W.Menu.left [ viewIcon ] ]
                { label = [ H.text "Button item" ]
                , onClick = Book.logAction "onClick"
                }
            , W.Menu.viewLink
                [ W.Menu.left [ viewIcon ] ]
                { label = [ H.text "Anchor item" ]
                , href = "/Book.logAction/#"
                }
            , W.Menu.viewHeading
                [ W.Menu.left [ viewIcon ]
                , W.Menu.right [ viewActionButton ]
                ]
                [ H.text "Title" ]
            , W.Menu.viewButton
                [ W.Menu.selected
                ]
                { label = [ H.text "Click me" ]
                , onClick = Book.logAction "onClick"
                }
            , W.Menu.viewLink []
                { label = [ H.text "Link to" ]
                , href = "/Book.logAction/#"
                }
            ]
    in
    Book.page "Menu"
        (List.map Docs.UI.viewExampleNoPadding
            [ ( "Default", [ W.Menu.view [] items ] )
            , ( "Small", [ W.Menu.view [ W.Menu.small ] items ] )
            , ( "Flat Style", [ W.Menu.view [ W.Menu.flat ] items ] )
            , ( "Flat + Small", [ W.Menu.view [ W.Menu.flat, W.Menu.small ] items ] )
            , ( "Custom Padding", [ W.Menu.view [ W.Menu.paddingX W.Theme.Spacing.xl ] items ] )
            ]
        )

viewIcon : H.Html msg
viewIcon =
    W.Skeleton.view [ W.Skeleton.circle 1, W.Skeleton.noAnimation ]

viewActionButton : H.Html msg
viewActionButton =
    W.Button.viewDummy [ W.Button.extraSmall, W.Button.invisible ] [ H.text "Edit" ]

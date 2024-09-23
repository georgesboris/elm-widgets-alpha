module Docs.Modal exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Button
import W.Modal
import W.Popover
import W.Spacing
import W.Text


view : Book.Page model Book.Msg
view =
    Book.page "Modal"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , viewModalWrapper
                    [ W.Modal.view
                        [ W.Modal.absolute, W.Modal.noBlur ]
                        { isOpen = True
                        , onClose = Nothing
                        , content = [ viewModalContent ]
                        }
                    ]
              )
            , ( "with onClose"
              , viewModalWrapper
                    [ W.Modal.view
                        [ W.Modal.absolute, W.Modal.noBlur ]
                        { isOpen = True
                        , onClose = Just (Book.logAction "onClose")
                        , content = [ viewModalContent ]
                        }
                    ]
              )
            , ( "with toggle"
              , viewModalWrapper
                    [ W.Modal.viewTogglable
                        [ W.Modal.absolute, W.Modal.noBlur ]
                        { id = "my-modal"
                        , content = [ viewModalContent ]
                        }
                    , W.Modal.viewToggle "my-modal"
                        [ W.Button.viewDummy [] [ H.text "Toggle Modal" ] ]
                    ]
              )
            ]
        )


viewModalWrapper : List (H.Html msg) -> List (H.Html msg)
viewModalWrapper children =
    [ W.Box.view
        [ W.Box.relative
        , W.Box.tint
        , W.Box.flex [ W.Box.xyCenter ]
        , W.Box.height 24
        ]
        children
    ]


viewModalContent : H.Html msg
viewModalContent =
    W.Box.view
        [ W.Box.widthFull
        , W.Box.padding W.Spacing.sm
        , W.Box.height 12
        ]
        [ W.Popover.view
            [ W.Popover.right, W.Popover.offset 4, W.Popover.width 100 ]
            { trigger =
                [ W.Button.viewDummy
                    []
                    [ H.text "Popovers should be usable inside modals" ]
                ]
            , content = [ W.Text.view [] [ H.text "This should be visible" ] ]
            }
        ]

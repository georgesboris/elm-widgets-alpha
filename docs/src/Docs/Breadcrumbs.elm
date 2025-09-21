module Docs.Breadcrumbs exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Breadcrumbs


view : Book.Page model msg
view =
    let
        previous : List String
        previous =
            [ "Book", "Act", "Chapter", "Section", "Page" ]

        current : String
        current =
            "Paragraph"
    in
    Book.page "Breadcrumbs"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.Breadcrumbs.view
                    []
                    { current = current
                    , previous = previous
                    , toLabel = \x -> [ H.text x ]
                    , toHref = Book.logActionHref
                    }
                ]
              )
            , ( "Custom Separators"
              , [ W.Breadcrumbs.view
                    [ W.Breadcrumbs.separator (H.span [ HA.class "w--font-code w--text-subtle" ] [ H.text "┆" ]) ]
                    { current = current
                    , previous = previous
                    , toLabel = \x -> [ H.text x ]
                    , toHref = Book.logActionHref
                    }
                ]
              )
            , ( "Max Items"
              , [ W.Breadcrumbs.view
                    [ W.Breadcrumbs.maxItems 4 ]
                    { current = current
                    , previous = previous
                    , toLabel = \x -> [ H.text x ]
                    , toHref = Book.logActionHref
                    }
                ]
              )
            , ( "Buttons instead of links"
              , [ W.Breadcrumbs.viewButtons
                    []
                    { current = current
                    , previous = previous
                    , toLabel = \x -> [ H.text x ]
                    , onClick = Book.logActionWithString "Clicked"
                    }
                ]
              )
            , ( "Small"
              , [ W.Breadcrumbs.view
                    [ W.Breadcrumbs.small, W.Breadcrumbs.maxItems 4 ]
                    { current = current
                    , previous = previous
                    , toLabel = \x -> [ H.text x ]
                    , toHref = Book.logActionHref
                    }
                ]
              )
            ]
        )

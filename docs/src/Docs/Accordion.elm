module Docs.Accordion exposing (view)

import Book
import Docs.UI
import Html as H
import W.Accordion
import W.Theme.Spacing


view : Book.Page model msg
view =
    Book.page "Accordion"
        ([ ( "Default", [] )
         , ( "Subtle", [ W.Accordion.subtle ] )
         , ( "Linked", [ W.Accordion.link "id" ] )
         , ( "Custom Padding", [ W.Accordion.padding W.Theme.Spacing.xl ] )
         ]
            |> List.map
                (\( label, attrs ) ->
                    Docs.UI.viewExample
                        ( label
                        , [ W.Accordion.view attrs
                                { toHeader = .header
                                , toContent = .content
                                , items =
                                    [ { header = [ H.text "Header" ]
                                      , content = [ H.text "Content" ]
                                      }
                                    , { header = [ H.text "Header" ]
                                      , content = [ H.text "Content" ]
                                      }
                                    , { header = [ H.text "Header" ]
                                      , content = [ H.text "Content" ]
                                      }
                                    ]
                                }
                          ]
                        )
                )
        )

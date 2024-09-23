module Docs.Heading exposing (view)

import Attr
import Book
import Docs.UI
import Html as H
import W.Box
import W.Heading
import W.Spacing


view : Book.Page model Book.Msg
view =
    Book.page "Heading"
        [ W.Box.view
            [ W.Box.flex [ W.Box.vertical, W.Box.xStretch ]
            , W.Box.gap W.Spacing.lg
            ]
            ([ ( "Extra Large", W.Heading.extraLarge )
             , ( "Large", W.Heading.large )
             , ( "Default", Attr.none )
             , ( "Small", W.Heading.small )
             , ( "Extra Small", W.Heading.extraSmall )
             ]
                |> List.map
                    (\( label, attr ) ->
                        Docs.UI.viewDetailedExample
                            { label = label
                            , description = Nothing
                            , code = Nothing
                            , content =
                                [ W.Heading.view
                                    [ attr ]
                                    [ H.text "The quick brown fox jumps over the lazy dog" ]
                                ]
                            }
                    )
            )
        ]

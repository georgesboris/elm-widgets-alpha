module Docs.Button exposing (view)

import Attr
import Book
import Docs.UI
import Html as H
import W.Box
import W.Button
import W.Heading
import W.Spacing
import W.Text


view : Book.Page model msg
view =
    Book.page "Buttons"
        [ W.Text.view
            []
            [ H.text """
The description of the Button component.
"""
            ]
        , Docs.UI.viewTwoColumnsSection
            { title = "Variants"
            , left = []
            , right =
                [ W.Box.view
                    [ W.Box.gap W.Spacing.lg ]
                    (List.concat
                        [ [ ( "Default", Attr.none )
                          , ( "Outline", W.Button.outline )
                          , ( "Tint", W.Button.tint )
                          , ( "Invisible", W.Button.invisible )
                          ]
                            |> List.map
                                (\( label, attr ) ->
                                    Docs.UI.viewDetailedExample
                                        { label = label
                                        , description = Just ("This is the " ++ String.toLower label ++ " variant for the Button component")
                                        , content =
                                            [ Docs.UI.viewHorizontal
                                                [ W.Button.viewDummy [ attr, W.Button.large, W.Button.radius 0.5 ] [ H.text "Button" ]
                                                , W.Button.viewDummy [ attr, W.Button.primary ] [ H.text "Button" ]
                                                , W.Button.viewDummy [ attr, W.Button.warning, W.Button.disabled ] [ H.text "Button" ]
                                                , W.Button.viewDummy [ attr, W.Button.success, W.Button.small ] [ H.text "Button" ]
                                                , W.Button.viewDummy [ attr, W.Button.icon, W.Button.small, W.Button.rounded ] [ H.text "λ" ]
                                                , W.Button.viewDummy [ attr, W.Button.danger, W.Button.extraSmall ] [ H.text "Button" ]
                                                ]
                                            ]
                                        , code = Nothing
                                        }
                                )
                        , [ Docs.UI.viewDetailedExample
                                { label = "Full width"
                                , description = Nothing
                                , content =
                                    [ Docs.UI.viewVertical
                                        [ W.Button.viewDummy [ W.Button.primary, W.Button.rounded, W.Button.full ] [ H.text "Button" ]
                                        , W.Button.viewDummy [ W.Button.primary, W.Button.full, W.Button.disabled ] [ H.text "Button" ]
                                        ]
                                    ]
                                , code = Nothing
                                }
                          ]
                        ]
                    )
                ]
            }
        ]

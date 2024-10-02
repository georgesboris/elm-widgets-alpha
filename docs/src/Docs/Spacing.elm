module Docs.Spacing exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Theme.Radius
import W.Theme.Sizing
import W.Spacing
import W.Text


view : Book.Page model msg
view =
    Book.page "Radius, Spacing & Sizing"
        (List.map Docs.UI.viewExample
            [ ( "Radius"
              , [ ( "xs", W.Spacing.xs, W.Theme.Radius.xs )
                , ( "sm", W.Spacing.sm, W.Theme.Radius.sm )
                , ( "md", W.Spacing.md, W.Theme.Radius.md )
                , ( "lg", W.Spacing.lg, W.Theme.Radius.lg )
                , ( "xl", W.Spacing.xl, W.Theme.Radius.xl )
                , ( "xl2", W.Spacing.xl2, W.Theme.Radius.xl2 )
                , ( "xl3", W.Spacing.xl3, W.Theme.Radius.xl3 )
                ]
                    |> List.map
                        (\( name, spacing, radius ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.yCenter ]
                                , W.Box.gap W.Spacing.xs
                                ]
                                [ W.Box.view
                                    [ W.Box.width 2 ]
                                    [ W.Text.view
                                        [ W.Text.subtle ]
                                        [ H.text name ]
                                    ]
                                , W.Box.view
                                    [ W.Box.padding spacing
                                    , W.Box.tint
                                    , W.Box.radius radius
                                    ]
                                    []
                                ]
                        )
              )
            , ( "Spacing"
              , [ ( "xs", W.Spacing.xs )
                , ( "sm", W.Spacing.sm )
                , ( "md", W.Spacing.md )
                , ( "lg", W.Spacing.lg )
                , ( "xl", W.Spacing.xl )
                , ( "xl2", W.Spacing.xl2 )
                , ( "xl3", W.Spacing.xl3 )
                ]
                    |> List.map
                        (\( name, spacing ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.yCenter ]
                                , W.Box.gap W.Spacing.xs
                                ]
                                [ W.Box.view
                                    [ W.Box.width 2 ]
                                    [ W.Text.view
                                        [ W.Text.subtle ]
                                        [ H.text name ]
                                    ]
                                , W.Box.view
                                    [ W.Box.widthCustom (W.Spacing.toCSS spacing)
                                    , W.Box.height 2
                                    , W.Box.tint
                                    , W.Box.rounded
                                    ]
                                    []
                                ]
                        )
              )
            , ( "Sizing"
              , [ ( "xs", W.Theme.Sizing.xs )
                , ( "sm", W.Theme.Sizing.sm )
                , ( "md", W.Theme.Sizing.md )
                , ( "lg", W.Theme.Sizing.lg )
                , ( "xl", W.Theme.Sizing.xl )
                , ( "xl2", W.Theme.Sizing.xl2 )
                , ( "xl3", W.Theme.Sizing.xl3 )
                ]
                    |> List.map
                        (\( name, sizing ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.yCenter ]
                                , W.Box.gap W.Spacing.xs
                                ]
                                [ W.Box.view
                                    [ W.Box.width 2 ]
                                    [ W.Text.view
                                        [ W.Text.subtle ]
                                        [ H.text name ]
                                    ]
                                , W.Box.view
                                    [ W.Box.widthCustom (W.Theme.Sizing.toCSS sizing)
                                    , W.Box.height 2
                                    , W.Box.tint
                                    , W.Box.rounded
                                    ]
                                    []
                                ]
                        )
              )
            ]
        )

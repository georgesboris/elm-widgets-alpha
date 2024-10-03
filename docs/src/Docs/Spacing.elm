module Docs.Spacing exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Theme.Radius
import W.Theme.Sizing
import W.Theme.Spacing
import W.Text


view : Book.Page model msg
view =
    Book.page "Radius, Spacing & Sizing"
        (List.map Docs.UI.viewExample
            [ ( "Radius"
              , [ ( "xs", W.Theme.Spacing.xs, W.Theme.Radius.xs )
                , ( "sm", W.Theme.Spacing.sm, W.Theme.Radius.sm )
                , ( "md", W.Theme.Spacing.md, W.Theme.Radius.md )
                , ( "lg", W.Theme.Spacing.lg, W.Theme.Radius.lg )
                , ( "xl", W.Theme.Spacing.xl, W.Theme.Radius.xl )
                , ( "xl2", W.Theme.Spacing.xl2, W.Theme.Radius.xl2 )
                , ( "xl3", W.Theme.Spacing.xl3, W.Theme.Radius.xl3 )
                ]
                    |> List.map
                        (\( name, spacing, radius ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.yCenter ]
                                , W.Box.gap W.Theme.Spacing.xs
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
              , [ ( "xs", W.Theme.Spacing.xs )
                , ( "sm", W.Theme.Spacing.sm )
                , ( "md", W.Theme.Spacing.md )
                , ( "lg", W.Theme.Spacing.lg )
                , ( "xl", W.Theme.Spacing.xl )
                , ( "xl2", W.Theme.Spacing.xl2 )
                , ( "xl3", W.Theme.Spacing.xl3 )
                ]
                    |> List.map
                        (\( name, spacing ) ->
                            W.Box.view
                                [ W.Box.flex [ W.Box.yCenter ]
                                , W.Box.gap W.Theme.Spacing.xs
                                ]
                                [ W.Box.view
                                    [ W.Box.width 2 ]
                                    [ W.Text.view
                                        [ W.Text.subtle ]
                                        [ H.text name ]
                                    ]
                                , W.Box.view
                                    [ W.Box.widthCustom (W.Theme.Spacing.toCSS spacing)
                                    , W.Box.height 2
                                    , W.Box.tint
                                    , W.Box.radius W.Theme.Radius.md
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
                                , W.Box.gap W.Theme.Spacing.xs
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
                                    , W.Box.radius W.Theme.Radius.md
                                    ]
                                    []
                                ]
                        )
              )
            ]
        )

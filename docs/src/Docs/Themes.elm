module Docs.Themes exposing (demo, view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Theme


view : Book.Page model msg
view =
    Book.page "Themes"
        (List.map Docs.UI.viewExample
            [ ( "Light Theme", [ H.div [ HA.class "light" ] [ demo ] ] )
            , ( "Dark Theme", [ H.div [ HA.class "dark" ] [ demo ] ] )
            ]
        )


demo : H.Html msg
demo =
    H.article
        [ W.Theme.styleList
            [ ( "border-radius", W.Theme.radius.sm )
            , ( "padding", W.Theme.spacing.xl3 ++ " 0" )
            , ( "background", W.Theme.color.bgSubtle )
            , ( "display", "flex" )
            , ( "justify-content", "center" )
            ]
        ]
        [ H.div
            [ W.Theme.styleList
                [ ( "padding", W.Theme.spacing.xl )
                , ( "background", W.Theme.color.bg )
                , ( "box-shadow", "0 2px 8px " ++ W.Theme.alpha 0.2 W.Theme.color.shadow )
                , ( "border-radius", W.Theme.radius.xl2 )
                , ( "border", "1px solid " ++ W.Theme.color.accentSubtle )
                , ( "width", "100%" )
                , ( "max-width", "640px" )
                , ( "min-width", "560px" )
                , ( "display", "flex" )
                , ( "flex-direction", "column" )
                ]
            ]
            [ H.header
                [ HA.class "pb-xl" ]
                [ H.h1
                    [ W.Theme.styleList
                        [ ( "font-weight", "bold" )
                        , ( "font-size", "1.4rem" )
                        , ( "line-height", "1" )
                        , ( "margin", "0" )
                        ]
                    ]
                    [ H.text "w theme"
                    ]
                , H.p
                    [ W.Theme.styleList
                        [ ( "color", W.Theme.color.textSubtle )
                        , ( "font-size", "1rem" )
                        ]
                    ]
                    [ H.text "A theme schema designed for consistency and flexibility."
                    ]
                ]
            , [ ( "base", "w/base" )
              , ( "primary", "w/primary" )
              , ( "secondary", "w/secondary" )
              , ( "success", "w/success" )
              , ( "warning", "w/warning" )
              , ( "danger", "w/danger" )
              ]
                |> List.map
                    (\( name, className ) ->
                        H.article
                            [ HA.class className
                            , W.Theme.styleList
                                [ ( "color", W.Theme.color.textSubtle )
                                , ( "font-size", "1rem" )
                                , ( "display", "flex" )
                                , ( "flex-direction", "column" )
                                , ( "background", W.Theme.color.bg )
                                , ( "border", "1px solid " ++ W.Theme.color.accent )
                                , ( "border-radius", W.Theme.radius.md )
                                , ( "box-shadow", "0 0 4px " ++ W.Theme.alpha 0.25 W.Theme.color.shadow )
                                ]
                            ]
                            [ H.header
                                [ W.Theme.styleList
                                    [ ( "display", "flex" )
                                    , ( "align-items", "center" )
                                    , ( "gap", W.Theme.spacing.lg )
                                    , ( "padding", W.Theme.spacing.md )
                                    ]
                                ]
                                [ H.div
                                    [ HA.class "flex-grow" ]
                                    [ H.h1
                                        [ W.Theme.styleList
                                            [ ( "font-size", "0.8rem" )
                                            , ( "font-weight", "500" )
                                            , ( "line-height", "1" )
                                            , ( "letter-spacing", "0.05rem" )
                                            , ( "text-transform", "uppercase" )
                                            , ( "color", W.Theme.color.text )
                                            ]
                                        ]
                                        [ H.text name ]
                                    , H.p
                                        [ W.Theme.styleList
                                            [ ( "font-family", W.Theme.font.code )
                                            , ( "font-size", "0.8rem" )
                                            , ( "letter-spacing", "0.025rem" )
                                            , ( "color", W.Theme.color.textSubtle )
                                            ]
                                        ]
                                        [ H.text name ]
                                    ]
                                , H.div
                                    [ W.Theme.styleList
                                        [ ( "width", "120px" )
                                        , ( "display", "grid" )
                                        , ( "grid-template-columns", "repeat(2, minmax(0, 1fr))" )
                                        , ( "gap", W.Theme.spacing.sm )
                                        ]
                                    ]
                                    [ H.button
                                        [ HA.class "w/tint"
                                        , W.Theme.styleList
                                            [ ( "appearance", "none" )
                                            , ( "padding", W.Theme.spacing.sm )
                                            , ( "border-radius", W.Theme.radius.sm )
                                            , ( "border-width", "0" )
                                            , ( "line-height", "0.9rem" )
                                            , ( "font-size", "0.9rem" )
                                            , ( "font-weight", "400" )
                                            ]
                                        ]
                                        [ H.text "A" ]
                                    , H.button
                                        [ HA.class "w/solid"
                                        , W.Theme.styleList
                                            [ ( "appearance", "none" )
                                            , ( "padding", W.Theme.spacing.sm )
                                            , ( "box-shadow", "0 1px 8px " ++ W.Theme.alpha 0.2 W.Theme.color.shadow )
                                            , ( "border-radius", W.Theme.radius.sm )
                                            , ( "border-width", "0" )
                                            , ( "line-height", "0.9rem" )
                                            , ( "font-size", "0.9rem" )
                                            , ( "font-weight", "400" )
                                            ]
                                        ]
                                        [ H.text "B" ]
                                    ]
                                ]
                            , H.div
                                []
                                ([ W.Theme.color.accentSubtle, W.Theme.color.accent, W.Theme.color.accentStrong ]
                                    |> List.map
                                        (\accentColor ->
                                            H.div
                                                [ HA.class "pt-xs border-t-2 border-solid"
                                                , W.Theme.styleList [ ( "border-color", accentColor ) ]
                                                ]
                                                []
                                        )
                                )
                            , H.div
                                [ W.Theme.styleList
                                    [ ( "display", "flex" )
                                    , ( "justify-content", "space-between" )
                                    , ( "padding", W.Theme.spacing.md )
                                    ]
                                ]
                                ([ .shadow, .bg, .bgSubtle, .tintSubtle, .tint, .tintStrong, .accentSubtle, .accent, .accentStrong, .solidSubtle, .solid, .solidStrong, .solidText, .textSubtle, .text ]
                                    |> List.map
                                        (\toColor ->
                                            H.div
                                                [ W.Theme.styleList
                                                    [ ( "border", "2px solid " ++ W.Theme.color.tint )
                                                    , ( "border-radius", "9999px" )
                                                    , ( "width", W.Theme.spacing.md )
                                                    , ( "height", W.Theme.spacing.md )
                                                    , ( "background", toColor W.Theme.color )
                                                    ]
                                                ]
                                                []
                                        )
                                )
                            ]
                    )
                |> H.div
                    [ W.Theme.styleList
                        [ ( "display", "grid" )
                        , ( "grid-template-columns", "repeat(2, minmax(0, 1fr))" )
                        , ( "gap", W.Theme.spacing.lg )
                        ]
                    ]
            ]
        ]

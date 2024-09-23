module Docs.Colors exposing (view)

import Book
import Color
import Docs.UI
import Html as H
import SolidColor
import W.Box
import W.Heading
import W.Skeleton
import W.Spacing
import W.Theme


view : W.Theme.Theme -> Book.Page model msg
view theme =
    let
        themeColors : W.Theme.ColorPalette
        themeColors =
            W.Theme.toColorPalette theme
    in
    Book.page "Colors & Themes"
        (List.map Docs.UI.viewExample
            [ ( "Brand Colors"
              , [ W.Box.view
                    [ W.Box.gap W.Spacing.xs ]
                    [ viewColorScale "Base" W.Box.base themeColors.base
                    , viewColorScale "Primary" W.Box.primary themeColors.primary

                    -- , viewColorScale "Secondary" W.Box.secondary themeColors.secondary
                    ]
                ]
              )
            , ( "Semantic Colors"
              , [ W.Box.view
                    [ W.Box.gap W.Spacing.xs ]
                    [ viewColorScale "Success" W.Box.success themeColors.success
                    , viewColorScale "Warning" W.Box.warning themeColors.warning
                    , viewColorScale "Danger" W.Box.danger themeColors.danger
                    ]
                ]
              )
            , ( "Data Visualization Colors"
              , [ W.Skeleton.view [ W.Skeleton.height 8 ] ]
              )
            ]
        )


viewColorScale : String -> W.Box.Attribute msg -> W.Theme.ColorScale -> H.Html msg
viewColorScale name colorScaleAttr colorScale =
    W.Box.view
        [ colorScaleAttr
        , W.Box.roundedSmall
        , W.Box.padding W.Spacing.sm
        , W.Box.rounded
        , W.Box.grid []
        ]
        [ W.Box.view
            [ W.Box.columnSpan 2 ]
            [ W.Heading.view
                [ W.Heading.extraSmall ]
                [ H.text name ]
            ]
        , W.Box.view
            [ W.Box.columnSpan 10 ]
            [ W.Box.view
                [ W.Box.grid [ W.Box.columns 15 ]
                , W.Box.gap W.Spacing.xs
                ]
                [ viewColorWithBorder "Bg" colorScale.bg
                , viewColorWithBorder "Bg Subtle" colorScale.bgSubtle
                , viewColorWithBorder "Tint Subtle" colorScale.tintSubtle
                , viewColor "Tint" colorScale.tint
                , viewColor "Tint Strong" colorScale.tintStrong
                , viewColor "Accent Subtle" colorScale.accentSubtle
                , viewColor "Accent" colorScale.accent
                , viewColor "Accent Strong" colorScale.accentStrong
                , viewColor "Solid Subtle" colorScale.solidSubtle
                , viewColor "Solid" colorScale.solid
                , viewColor "Solid Strong" colorScale.solidStrong
                , viewColorWithBorder "Solid Text" colorScale.solidText
                , viewColor "Text Subtle" colorScale.textSubtle
                , viewColor "Text" colorScale.text
                , viewColor "Shadow" colorScale.shadow
                ]
            ]
        ]


viewColorWithBorder : String -> Color.Color -> H.Html msg
viewColorWithBorder _ color =
    W.Box.view []
        [ W.Box.view
            [ W.Box.background (Color.toCssString color)
            , W.Box.widthFull
            , W.Box.square
            , W.Box.rounded
            , W.Box.borderLarge
            , W.Box.borderColor W.Theme.color.tint
            ]
            []
        ]


viewColor : String -> Color.Color -> H.Html msg
viewColor _ color =
    W.Box.view
        []
        [ W.Box.view
            [ W.Box.background (Color.toCssString color)
            , W.Box.square
            , W.Box.widthFull
            , W.Box.rounded
            ]
            []

        -- , W.Text.view [ W.Text.small ] [ H.text name ]
        -- , W.Text.view [ W.Text.small ] [ H.text (toHex color) ]
        -- , W.Text.view [ W.Text.small ] [ H.text (colorToRgbText color) ]
        ]


colorToRgbText : Color.Color -> String
colorToRgbText color =
    let
        c : { red : Float, green : Float, blue : Float, alpha : Float }
        c =
            Color.toRgba color
    in
    "RGB " ++ String.fromInt (to255 c.red) ++ " " ++ String.fromInt (to255 c.green) ++ " " ++ String.fromInt (to255 c.blue)


to255 : Float -> Int
to255 v =
    Basics.round (v * 255)


toHex : Color.Color -> String
toHex color =
    color
        |> Color.toRgba
        |> (\c ->
                SolidColor.fromRGB
                    ( Basics.toFloat (to255 c.red)
                    , Basics.toFloat (to255 c.green)
                    , Basics.toFloat (to255 c.blue)
                    )
           )
        |> SolidColor.toHex

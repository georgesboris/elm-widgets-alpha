module W.Theme exposing
    ( lightTheme, darkTheme
    , globalTheme, classTheme
    , noDarkMode, darkModeFromClass, darkModeFromSystemPreferences, DarkMode
    , Theme, ColorScale, FontFamilies, RadiusScale, SpacingScale
    , withId
    , withHeadingFont, withTextFont, withCodeFont
    , withSpacing, withRadius
    , withColorPalette, withBaseColor, withPrimaryColor, withSecondaryColor, withSuccessColor, withWarningColor, withDangerColor
    , toId, toFontFamilies, toSpacingScale, toRadiusScale, toColorPalette, toExtraVariables
    , styleList
    , font, spacing, radius
    , ColorPalette, ColorVariant
    , color, alpha, ColorScaleValues
    , variant, base, primary, secondary, success, warning, danger
    , baseScale, primaryScale, secondaryScale, successScale, warningScale, dangerScale
    , themeComponents
    )

{-|


## Setting Themes

@docs lightTheme, darkTheme
@docs globalTheme, classTheme
@docs noDarkMode, darkModeFromClass, darkModeFromSystemPreferences, DarkMode


## Creating Custom Themes

@docs Theme, ColorScale, FontFamilies, RadiusScale, SpacingScale
@docs withId
@docs withHeadingFont, withTextFont, withCodeFont
@docs withSpacing, withRadius
@docs withColorPalette, withBaseColor, withPrimaryColor, withSecondaryColor, withSuccessColor, withWarningColor, withDangerColor
@docs toId, toFontFamilies, toSpacingScale, toRadiusScale, toColorPalette, toExtraVariables


## Using Theme Values

@docs styleList
@docs font, spacing, radius


### Colors

@docs ColorPalette, ColorVariant
@docs color, alpha, ColorScaleValues
@docs variant, base, primary, secondary, success, warning, danger
@docs baseScale, primaryScale, secondaryScale, successScale, warningScale, dangerScale


## Theme Components

@docs themeComponents

-}

import Color exposing (Color)
import Html as H
import Html.Attributes as HA
import W.Theme.Colors



-- Theme Types


{-| -}
type Theme
    = Theme ThemeData


type alias ThemeData =
    { id : String
    , font : FontFamilies
    , radius : RadiusScale
    , spacing : SpacingScale
    , colorPalette : ColorPalette
    , extraCSSVariables : List ( String, String )
    }


{-| -}
type alias ColorPalette =
    { base : ColorScale
    , primary : ColorScale
    , secondary : ColorScale
    , success : ColorScale
    , warning : ColorScale
    , danger : ColorScale
    }


{-| -}
type alias ColorScale =
    { bg : Color
    , bgSubtle : Color
    , tint : Color
    , tintSubtle : Color
    , tintStrong : Color
    , accent : Color
    , accentSubtle : Color
    , accentStrong : Color
    , solid : Color
    , solidSubtle : Color
    , solidStrong : Color
    , solidText : Color
    , textSubtle : Color
    , text : Color
    , shadow : Color
    }


{-| -}
type alias ColorScaleValues =
    { bg : String
    , bgSubtle : String
    , tint : String
    , tintSubtle : String
    , tintStrong : String
    , accent : String
    , accentSubtle : String
    , accentStrong : String
    , solid : String
    , solidSubtle : String
    , solidStrong : String
    , solidText : String
    , textSubtle : String
    , text : String
    , shadow : String
    }


{-| -}
type alias FontFamilies =
    { heading : String
    , text : String
    , code : String
    }


{-| -}
type alias SpacingScale =
    { xs : Float -- small ui elements
    , sm : Float -- regular ui elements and small cards
    , md : Float -- large ui elements and regular cards
    , lg : Float -- large cards
    , xl : Float -- mostly unused
    , xl2 : Float -- mostly unused
    , xl3 : Float -- mostly unused
    }


{-| -}
type alias RadiusScale =
    { xs : Float -- small ui elements
    , sm : Float -- regular ui elements and small cards
    , md : Float -- large ui elements and regular cards
    , lg : Float -- large cards
    , xl : Float -- mostly unused
    , xl2 : Float -- mostly unused
    , xl3 : Float -- mostly unused
    }


colorPaletteColors : List String
colorPaletteColors =
    [ "base"
    , "primary"
    , "secondary"
    , "success"
    , "warning"
    , "danger"
    ]


colorScaleColors : List String
colorScaleColors =
    [ "shadow"
    , "bg"
    , "bg-subtle"
    , "base"
    , "base-subtle"
    , "base-strong"
    , "tint"
    , "tint-subtle"
    , "tint-strong"
    , "accent"
    , "accent-subtle"
    , "accent-strong"
    , "solid"
    , "solid-subtle"
    , "solid-strong"
    , "solid-text"
    , "text"
    , "text-subtle"
    ]



-- Color Variants


{-| -}
type ColorVariant
    = Base
    | Primary
    | Secondary
    | Success
    | Warning
    | Danger


{-| -}
base : ColorVariant
base =
    Base


{-| -}
primary : ColorVariant
primary =
    Primary


{-| -}
secondary : ColorVariant
secondary =
    Secondary


{-| -}
success : ColorVariant
success =
    Success


{-| -}
warning : ColorVariant
warning =
    Warning


{-| -}
danger : ColorVariant
danger =
    Danger


{-| -}
variant : ColorVariant -> H.Attribute msg
variant v =
    case v of
        Base ->
            HA.class "w/base"

        Primary ->
            HA.class "w/primary"

        Secondary ->
            HA.class "w/secondary"

        Success ->
            HA.class "w/success"

        Warning ->
            HA.class "w/warning"

        Danger ->
            HA.class "w/danger"



-- Retrieving theme values


{-| -}
toId : Theme -> String
toId (Theme theme) =
    theme.id


{-| -}
toFontFamilies : Theme -> FontFamilies
toFontFamilies (Theme theme) =
    theme.font


{-| -}
toSpacingScale : Theme -> SpacingScale
toSpacingScale (Theme theme) =
    theme.spacing


{-| -}
toRadiusScale : Theme -> RadiusScale
toRadiusScale (Theme theme) =
    theme.radius


{-| -}
toColorPalette : Theme -> ColorPalette
toColorPalette (Theme theme) =
    theme.colorPalette


{-| -}
toExtraVariables : Theme -> List ( String, String )
toExtraVariables (Theme theme) =
    theme.extraCSSVariables



-- Default Themes


{-| -}
lightTheme : Theme
lightTheme =
    Theme
        { id = "light"
        , font = defaultFonts
        , radius = defaultRadiusScale
        , spacing = defaultSpacingScale
        , colorPalette =
            { base = W.Theme.Colors.slate
            , primary = W.Theme.Colors.blue
            , secondary = W.Theme.Colors.crimson
            , success = W.Theme.Colors.lime
            , warning = W.Theme.Colors.amber
            , danger = W.Theme.Colors.red
            }
        , extraCSSVariables = []
        }


{-| -}
darkTheme : Theme
darkTheme =
    Theme
        { id = "dark"
        , font = defaultFonts
        , radius = defaultRadiusScale
        , spacing = defaultSpacingScale
        , colorPalette =
            { base = W.Theme.Colors.slateDark
            , primary = W.Theme.Colors.blueDark
            , secondary = W.Theme.Colors.crimsonDark
            , success = W.Theme.Colors.limeDark
            , warning = W.Theme.Colors.amberDark
            , danger = W.Theme.Colors.redDark
            }
        , extraCSSVariables = []
        }


defaultSans : String
defaultSans =
    "ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\""


defaultCode : String
defaultCode =
    "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", \"Courier New\", monospace"


defaultFonts : FontFamilies
defaultFonts =
    { heading = defaultSans
    , text = defaultSans
    , code = defaultCode
    }


defaultSpacingScale : SpacingScale
defaultSpacingScale =
    { xs = 0.25
    , sm = 0.5
    , md = 0.75
    , lg = 1.0
    , xl = 1.5
    , xl2 = 2.5
    , xl3 = 4.0
    }


defaultRadiusScale : RadiusScale
defaultRadiusScale =
    { xs = 0.125
    , sm = 0.25
    , md = 0.375
    , lg = 0.5
    , xl = 0.75
    , xl2 = 1.0
    , xl3 = 1.5
    }



-- Dark Themes


{-| -}
type DarkMode
    = DarkModeFromSystemPreferences Theme
    | DarkModeFromClass String Theme
    | DarkModeDisabled


{-| -}
noDarkMode : DarkMode
noDarkMode =
    DarkModeDisabled


{-| -}
darkModeFromSystemPreferences : Theme -> DarkMode
darkModeFromSystemPreferences =
    DarkModeFromSystemPreferences


{-| -}
darkModeFromClass : String -> Theme -> DarkMode
darkModeFromClass =
    DarkModeFromClass



-- Theme Values


{-| -}
font : FontFamilies
font =
    { heading = cssValue "font-heading"
    , text = cssValue "font-text"
    , code = cssValue "font-code"
    }


{-| -}
spacing :
    { xs : String
    , sm : String
    , md : String
    , lg : String
    , xl : String
    , xl2 : String
    , xl3 : String
    }
spacing =
    { xs = cssValue "spacing-xs"
    , sm = cssValue "spacing-sm"
    , md = cssValue "spacing-md"
    , lg = cssValue "spacing-lg"
    , xl = cssValue "spacing-xl"
    , xl2 = cssValue "spacing-2xl"
    , xl3 = cssValue "spacing-3xl"
    }


{-| -}
radius :
    { xs : String
    , sm : String
    , md : String
    , lg : String
    , xl : String
    , xl2 : String
    , xl3 : String
    }
radius =
    { xs = cssValue "radius-xs"
    , sm = cssValue "radius-sm"
    , md = cssValue "radius-md"
    , lg = cssValue "radius-lg"
    , xl = cssValue "radius-xl"
    , xl2 = cssValue "radius-2xl"
    , xl3 = cssValue "radius-3xl"
    }


{-| -}
color : ColorScaleValues
color =
    { bg = cssColorValue "bg"
    , bgSubtle = cssColorValue "bg-subtle"
    , tint = cssColorValue "tint"
    , tintSubtle = cssColorValue "tint-subtle"
    , tintStrong = cssColorValue "tint-strong"
    , accent = cssColorValue "accent"
    , accentSubtle = cssColorValue "accent-subtle"
    , accentStrong = cssColorValue "accent-strong"
    , solid = cssColorValue "solid"
    , solidSubtle = cssColorValue "solid-subtle"
    , solidStrong = cssColorValue "solid-strong"
    , solidText = cssColorValue "solid-text"
    , textSubtle = cssColorValue "text-subtle"
    , text = cssColorValue "text"
    , shadow = cssColorValue "shadow"
    }


{-| -}
baseScale : ColorScaleValues
baseScale =
    toColorValues "base"


{-| -}
primaryScale : ColorScaleValues
primaryScale =
    toColorValues "primary"


{-| -}
secondaryScale : ColorScaleValues
secondaryScale =
    toColorValues "secondary"


{-| -}
successScale : ColorScaleValues
successScale =
    toColorValues "success"


{-| -}
warningScale : ColorScaleValues
warningScale =
    toColorValues "warning"


{-| -}
dangerScale : ColorScaleValues
dangerScale =
    toColorValues "danger"


{-| -}
alpha : Float -> String -> String
alpha a c =
    "color(from " ++ c ++ "  srgb r g b / " ++ String.fromFloat a ++ ")"


toColorValues : String -> ColorScaleValues
toColorValues name =
    { bg = cssColorValue (name ++ "-bg")
    , bgSubtle = cssColorValue (name ++ "-bg-subtle")
    , tint = cssColorValue (name ++ "-tint")
    , tintSubtle = cssColorValue (name ++ "-tint-subtle")
    , tintStrong = cssColorValue (name ++ "-tint-strong")
    , accent = cssColorValue (name ++ "-accent")
    , accentSubtle = cssColorValue (name ++ "-accent-subtle")
    , accentStrong = cssColorValue (name ++ "-accent-strong")
    , solid = cssColorValue (name ++ "-solid")
    , solidSubtle = cssColorValue (name ++ "-solid-subtle")
    , solidStrong = cssColorValue (name ++ "-solid-strong")
    , solidText = cssColorValue (name ++ "-solid-text")
    , textSubtle = cssColorValue (name ++ "-text-subtle")
    , text = cssColorValue (name ++ "-text")
    , shadow = cssColorValue (name ++ "-shadow")
    }



-- Customizing Themes


{-| -}
withId : String -> Theme -> Theme
withId value (Theme theme) =
    Theme { theme | id = value }


{-| -}
withHeadingFont : String -> Theme -> Theme
withHeadingFont value (Theme theme) =
    let
        themeFonts : FontFamilies
        themeFonts =
            theme.font
    in
    Theme { theme | font = { themeFonts | heading = value } }


{-| -}
withTextFont : String -> Theme -> Theme
withTextFont value (Theme theme) =
    let
        themeFonts : FontFamilies
        themeFonts =
            theme.font
    in
    Theme { theme | font = { themeFonts | text = value } }


{-| -}
withCodeFont : String -> Theme -> Theme
withCodeFont value (Theme theme) =
    let
        themeFonts : FontFamilies
        themeFonts =
            theme.font
    in
    Theme { theme | font = { themeFonts | code = value } }


{-| -}
withRadius : RadiusScale -> Theme -> Theme
withRadius value (Theme theme) =
    Theme { theme | radius = value }


{-| -}
withSpacing : SpacingScale -> Theme -> Theme
withSpacing value (Theme theme) =
    Theme { theme | spacing = value }


{-| -}
withColorPalette : ColorPalette -> Theme -> Theme
withColorPalette value (Theme theme) =
    Theme { theme | colorPalette = value }


{-| -}
withBaseColor : ColorScale -> Theme -> Theme
withBaseColor value =
    updateColorPalette (\p -> { p | base = value })


{-| -}
withPrimaryColor : ColorScale -> Theme -> Theme
withPrimaryColor value =
    updateColorPalette (\p -> { p | primary = value })


{-| -}
withSecondaryColor : ColorScale -> Theme -> Theme
withSecondaryColor value =
    updateColorPalette (\p -> { p | secondary = value })


{-| -}
withSuccessColor : ColorScale -> Theme -> Theme
withSuccessColor value =
    updateColorPalette (\p -> { p | success = value })


{-| -}
withWarningColor : ColorScale -> Theme -> Theme
withWarningColor value =
    updateColorPalette (\p -> { p | warning = value })


{-| -}
withDangerColor : ColorScale -> Theme -> Theme
withDangerColor value =
    updateColorPalette (\p -> { p | danger = value })


updateColorPalette : (ColorPalette -> ColorPalette) -> Theme -> Theme
updateColorPalette fn (Theme theme) =
    Theme { theme | colorPalette = fn theme.colorPalette }



-- Themes to Html elements


{-| -}
themeComponents : H.Html msg
themeComponents =
    H.node "style"
        [ HA.attribute "data-w-theme" "" ]
        [ H.text variantComponents
        , H.text styleComponents
        ]


variantComponents : String
variantComponents =
    colorPaletteColors
        |> List.map
            (\variant_ ->
                let
                    variantColors : String
                    variantColors =
                        colorScaleColors
                            |> List.map
                                (\c ->
                                    cssVar c (cssValue (variant_ ++ "-" ++ c))
                                )
                            |> String.join "; "
                in
                wClass variant_ ++ """ {
  """ ++ cssVar "color" variant_ ++ """;
  """ ++ variantColors ++ """
  color: """ ++ cssValue "text" ++ """;
}"""
            )
        |> String.join " "


styleComponents : String
styleComponents =
    wClass "tint" ++ """ {
  background-color: """ ++ cssColorValue "tint" ++ """;
}
""" ++ wClass "tint:is(a,button):is(:hover)" ++ """ {
  background-color: """ ++ cssColorValue "tint-strong" ++ """;
}
""" ++ wClass "tint:is(a,button):is(:active)" ++ """ {
  background-color: """ ++ cssColorValue "tint-subtle" ++ """;
}
""" ++ wClass "solid" ++ """ {
  background-color: """ ++ cssColorValue "solid" ++ """;
  color: """ ++ cssColorValue "solid-text" ++ """;
}
""" ++ wClass "solid:is(a,button):is(:hover)" ++ """ {
  background-color: """ ++ cssColorValue "solid-strong" ++ """;
}
""" ++ wClass "solid:is(a,button):is(:active)" ++ """ {
  background-color: """ ++ cssColorValue "solid-subtle" ++ """;
}
""" ++ wClass "tint:is(a,button):is(:focus-visible)" ++ """,
""" ++ wClass "solid:is(a,button):is(:focus-visible)" ++ """,
""" ++ wClass "focus:is(:focus-visible)" ++ """ {
  outline: 2px solid transparent;
  outline-offset: 2px;
  box-shadow: 0 0 0 1px """ ++ cssColorValue "bg" ++ """, 0 0 0 4px """ ++ cssColorValue "accent-subtle" ++ """;
}
"""


{-| -}
globalTheme :
    { theme : Theme
    , darkMode : DarkMode
    }
    -> H.Html msg
globalTheme config =
    let
        (Theme theme) =
            config.theme

        lightStyles : String
        lightStyles =
            "body { " ++ themeBaseStyles config.theme ++ "; " ++ themeColorStyles theme ++ " }"

        darkStyles : String
        darkStyles =
            case config.darkMode of
                DarkModeDisabled ->
                    ""

                DarkModeFromSystemPreferences (Theme darkTheme_) ->
                    "@media (prefers-color-scheme: dark) { body { " ++ themeColorStyles darkTheme_ ++ " } }"

                DarkModeFromClass class (Theme darkTheme_) ->
                    "body." ++ class ++ ", ." ++ class ++ " { " ++ themeColorStyles darkTheme_ ++ " }"
    in
    H.node "style"
        [ HA.attribute "data-w-theme" "" ]
        [ H.text (lightStyles ++ " " ++ darkStyles ++ " " ++ themeRootStyles Nothing) ]


{-| -}
classTheme :
    { theme : Theme
    , class : String
    , darkMode : DarkMode
    }
    -> H.Html msg
classTheme config =
    let
        (Theme theme) =
            config.theme

        lightStyles : String
        lightStyles =
            "." ++ config.class ++ " { " ++ themeBaseStyles config.theme ++ "; " ++ themeColorStyles theme ++ " }"

        darkStyles : String
        darkStyles =
            case config.darkMode of
                DarkModeDisabled ->
                    ""

                DarkModeFromSystemPreferences (Theme darkTheme_) ->
                    "@media (prefers-color-scheme: dark) { ." ++ config.class ++ " { " ++ themeColorStyles darkTheme_ ++ " }"

                DarkModeFromClass darkClass (Theme darkTheme_) ->
                    "." ++ config.class ++ "." ++ darkClass ++ " , ." ++ darkClass ++ " ." ++ config.class ++ " { " ++ themeColorStyles darkTheme_ ++ " }"
    in
    H.node "style"
        [ HA.attribute "data-w-theme" "" ]
        [ H.text (lightStyles ++ " " ++ darkStyles ++ " " ++ themeRootStyles (Just config.class)) ]



-- Themes to Stylesheets


themeRootStyles : Maybe String -> String
themeRootStyles themeClass =
    let
        prefix : String
        prefix =
            themeClass
                |> Maybe.map (\c -> "." ++ c)
                |> Maybe.withDefault "body"
    in
    prefix ++ """ {
  background-color: """ ++ color.bg ++ """;
  color: """ ++ color.text ++ """;
  font-family: """ ++ font.text ++ """;
}
""" ++ prefix ++ """ h1,
""" ++ prefix ++ """ h2,
""" ++ prefix ++ """ h3,
""" ++ prefix ++ """ h4,
""" ++ prefix ++ """ h5,
""" ++ prefix ++ """ h6 {
  font-family: """ ++ font.heading ++ """;
}
""" ++ prefix ++ """ code,
""" ++ prefix ++ """ kbd,
""" ++ prefix ++ """ samp,
""" ++ prefix ++ """ pre {
  font-family: """ ++ font.code ++ """;
}
""" ++ prefix ++ """ ::selection {
  background-color: """ ++ color.text ++ """;
  color: """ ++ color.bg ++ """;
}
"""


themeBaseStyles : Theme -> String
themeBaseStyles (Theme theme) =
    [ cssVar "id" theme.id
    , cssVar "font-heading" theme.font.heading
    , cssVar "font-text" theme.font.text
    , cssVar "font-code" theme.font.code
    , cssVar "spacing-xs" (rem theme.spacing.xs)
    , cssVar "spacing-sm" (rem theme.spacing.sm)
    , cssVar "spacing-md" (rem theme.spacing.md)
    , cssVar "spacing-lg" (rem theme.spacing.lg)
    , cssVar "spacing-xl" (rem theme.spacing.xl)
    , cssVar "spacing-2xl" (rem theme.spacing.xl2)
    , cssVar "spacing-3xl" (rem theme.spacing.xl3)
    , cssVar "radius-xs" (rem theme.radius.xs)
    , cssVar "radius-sm" (rem theme.radius.sm)
    , cssVar "radius-md" (rem theme.radius.md)
    , cssVar "radius-lg" (rem theme.radius.lg)
    , cssVar "radius-xl" (rem theme.radius.xl)
    , cssVar "radius-2xl" (rem theme.radius.xl2)
    , cssVar "radius-3xl" (rem theme.radius.xl3)
    ]
        |> String.join ";"


themeColorStyles : ThemeData -> String
themeColorStyles theme =
    [ [ "color-scheme:" ++ toColorScheme theme ]
    , toColorScaleVariables "base" theme.colorPalette.base
    , toColorScaleVariables "primary" theme.colorPalette.primary
    , toColorScaleVariables "secondary" theme.colorPalette.secondary
    , toColorScaleVariables "success" theme.colorPalette.success
    , toColorScaleVariables "warning" theme.colorPalette.warning
    , toColorScaleVariables "danger" theme.colorPalette.danger
    , baseVariantStyles
    ]
        |> List.concat
        |> String.join ";"


toColorScheme : ThemeData -> String
toColorScheme theme =
    let
        bgLightness : Float
        bgLightness =
            theme.colorPalette.base.bg
                |> Color.toHsla
                |> .lightness
    in
    if bgLightness > 0.5 then
        "light"

    else
        "dark"


toColorScaleVariables : String -> ColorScale -> List String
toColorScaleVariables name colorScale =
    [ cssVar (name ++ "-bg") (rgbSegments colorScale.bg)
    , cssVar (name ++ "-bg-subtle") (rgbSegments colorScale.bgSubtle)
    , cssVar (name ++ "-tint") (rgbSegments colorScale.tint)
    , cssVar (name ++ "-tint-subtle") (rgbSegments colorScale.tintSubtle)
    , cssVar (name ++ "-tint-strong") (rgbSegments colorScale.tintStrong)
    , cssVar (name ++ "-accent") (rgbSegments colorScale.accent)
    , cssVar (name ++ "-accent-subtle") (rgbSegments colorScale.accentSubtle)
    , cssVar (name ++ "-accent-strong") (rgbSegments colorScale.accentStrong)
    , cssVar (name ++ "-solid") (rgbSegments colorScale.solid)
    , cssVar (name ++ "-solid-subtle") (rgbSegments colorScale.solidSubtle)
    , cssVar (name ++ "-solid-strong") (rgbSegments colorScale.solidStrong)
    , cssVar (name ++ "-solid-text") (rgbSegments colorScale.solidText)
    , cssVar (name ++ "-text") (rgbSegments colorScale.text)
    , cssVar (name ++ "-text-subtle") (rgbSegments colorScale.textSubtle)
    , cssVar (name ++ "-shadow") (rgbSegments colorScale.shadow)
    ]


baseVariantStyles : List String
baseVariantStyles =
    [ cssVar "color" "base"
    , cssVar "bg" (cssValue "base-bg")
    , cssVar "bg-subtle" (cssValue "base-bg-subtle")
    , cssVar "tint" (cssValue "base-tint")
    , cssVar "tint-subtle" (cssValue "base-tint-subtle")
    , cssVar "tint-strong" (cssValue "base-tint-strong")
    , cssVar "accent" (cssValue "base-accent")
    , cssVar "accent-subtle" (cssValue "base-accent-subtle")
    , cssVar "accent-strong" (cssValue "base-accent-strong")
    , cssVar "solid" (cssValue "base-solid")
    , cssVar "solid-subtle" (cssValue "base-solid-subtle")
    , cssVar "solid-strong" (cssValue "base-solid-strong")
    , cssVar "solid-text" (cssValue "base-solid-text")
    , cssVar "text" (cssValue "base-text")
    , cssVar "text-subtle" (cssValue "base-text-subtle")
    , cssVar "shadow" (cssValue "base-shadow")
    ]



-- CSS Helpers


{-| Set styles using CSS variables.
This is used to bypass a current limitation of Elm's `Html.Attribute.style` function, which ignores CSS variables.

**You can't compose this function with other functions that also set the element's style! Unlike `Html.Attribute.class` this function does not compose with other similar functions.**

    div
        [ Theme.styleList
            [ ( "background", Theme.base.bg )
            , ( "color", Theme.base.text )
            ]
        ]
        [ text "Hello!" ]

-}
styleList : List ( String, String ) -> H.Attribute msg
styleList styles =
    styles
        |> List.map (\( k, v ) -> k ++ ":" ++ v)
        |> String.join ";"
        |> HA.attribute "style"


namespace : String
namespace =
    "w"


rem : Float -> String
rem x =
    String.fromFloat x ++ "rem"


wClass : String -> String
wClass class =
    ".w\\/" ++ class


cssVar : String -> String -> String
cssVar key value =
    "--" ++ namespace ++ "-" ++ key ++ ":" ++ value


cssValue : String -> String
cssValue key =
    "var(--" ++ namespace ++ "-" ++ key ++ ")"


cssColorValue : String -> String
cssColorValue value =
    "rgb(" ++ cssValue value ++ ")"


toRgb255 : Float -> String
toRgb255 c =
    String.fromInt (Basics.round (c * 255))


rgbSegments : Color -> String
rgbSegments c =
    let
        rgb : { red : Float, green : Float, blue : Float, alpha : Float }
        rgb =
            Color.toRgba c
    in
    toRgb255 rgb.red ++ " " ++ toRgb255 rgb.green ++ " " ++ toRgb255 rgb.blue

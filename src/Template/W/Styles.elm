module Template.W.Styles exposing
    ( view
    , lightTheme, darkTheme, lightAndDarkTheme, customTheme
    , borderWidth, clickArea, clickAreaSmall
    )

{-|

@docs view
@docs lightTheme, darkTheme, lightAndDarkTheme, customTheme
@docs borderWidth, clickArea, clickAreaSmall

-}

import Attr
import Html as H
import W.Internal.Helpers as WH
import W.Theme



-- Attrs


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { borderWidth : Int
    , clickArea : Float
    , clickAreaSmall : Float
    , theme : Maybe (H.Html msg)
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { borderWidth = 2
    , clickArea = 1.75
    , clickAreaSmall = 1.25
    , theme = Nothing
    }



-- View


{-| Default border width in pixels.
This value is used for things like input, select boxes and other elements.
-}
borderWidth : Int -> Attribute msg
borderWidth v =
    Attr.attr (\attrs -> { attrs | borderWidth = v })


{-| Default size for clickable inputs such as checkboxes and radio buttons.
-}
clickArea : Float -> Attribute msg
clickArea v =
    Attr.attr (\attrs -> { attrs | clickArea = v })


{-| Default size for the small variation of clickable inputs such as checkboxes and radio buttons.
-}
clickAreaSmall : Float -> Attribute msg
clickAreaSmall v =
    Attr.attr (\attrs -> { attrs | clickAreaSmall = v })


{-| Use a basic light theme. This is the default behavior.
-}
lightTheme : Attribute msg
lightTheme =
    Attr.attr
        (\attrs ->
            { attrs
                | theme =
                    Just
                        (W.Theme.globalTheme
                            { theme = W.Theme.lightTheme
                            , darkMode = W.Theme.noDarkMode
                            }
                        )
            }
        )


{-| Use a basic dark theme.
-}
darkTheme : Attribute msg
darkTheme =
    Attr.attr
        (\attrs ->
            { attrs
                | theme =
                    Just
                        (W.Theme.globalTheme
                            { theme = W.Theme.darkTheme
                            , darkMode = W.Theme.noDarkMode
                            }
                        )
            }
        )


{-| Use a basic theme with light or dark modes set based on user preferences.
-}
lightAndDarkTheme : Attribute msg
lightAndDarkTheme =
    Attr.attr
        (\attrs ->
            { attrs
                | theme =
                    Just
                        (W.Theme.globalTheme
                            { theme = W.Theme.lightTheme
                            , darkMode = W.Theme.darkModeFromSystemPreferences W.Theme.darkTheme
                            }
                        )
            }
        )


{-| Use a custom theme. Please refer to georgesboris/elm-theme package for a complete documentation.
-}
customTheme : { theme : W.Theme.Theme, darkMode : W.Theme.DarkMode } -> Attribute msg
customTheme v =
    Attr.attr
        (\attrs ->
            { attrs
                | theme =
                    Just
                        (W.Theme.globalTheme
                            { theme = v.theme
                            , darkMode = v.darkMode
                            }
                        )
            }
        )


{-| -}
view : List (Attribute msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs ->
            H.div
                []
                [ case attrs.theme of
                    Just theme ->
                        theme

                    Nothing ->
                        W.Theme.globalTheme
                            { theme = W.Theme.lightTheme
                            , darkMode = W.Theme.noDarkMode
                            }
                , H.node "style"
                    []
                    [ H.text ("""
:root {
    --w-cfg-border: """ ++ WH.px attrs.borderWidth ++ """;
    --w-cfg-click: """ ++ WH.rem attrs.clickArea ++ """;
    --w-cfg-click-sm: """ ++ WH.rem attrs.clickAreaSmall ++ """;
}      
""")
                    , H.text <| Debug.todo "STYLES"
                    ]
                ]
        )

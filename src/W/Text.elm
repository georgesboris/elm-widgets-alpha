module W.Text exposing
    ( view, viewInline
    , extraLarge, large, small, extraSmall, fontSize
    , default, subtle, color
    , light, regular, semibold, bold
    , italic, lineThrough, underline, uppercase, lowercase, subscript, superscript
    , lineHeight, letterSpacing
    , alignCenter, alignRight
    , Attribute
    )

{-|

@docs view, viewInline


## Sizes

@docs extraLarge, large, small, extraSmall, fontSize


## Colors

@docs default, subtle, color


## Font Weight

@docs light, regular, semibold, bold


## Font Style & Transformations

@docs italic, lineThrough, underline, uppercase, lowercase, subscript, superscript


## Typography Settings

@docs lineHeight, letterSpacing


## Alignment

@docs alignCenter, alignRight

@docs Attribute

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Internal.Helpers as WH


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { styles : String
    , casing : String
    , subsuper : String
    , fontSize : FontSize
    , fontWeight : String
    , lineHeight : Maybe Float
    , letterSpacing : Maybe Float
    , textAlignment : String
    , color : Color
    }


type FontSize
    = FontSizeClass String
    | FontSizeRem Float
    | FontSizeEm Float


type Color
    = ColorClass String
    | ColorCustom String


defaultAttrs : Attributes
defaultAttrs =
    { styles = ""
    , casing = ""
    , subsuper = ""
    , fontSize = FontSizeClass ""
    , fontWeight = ""
    , lineHeight = Nothing
    , letterSpacing = Nothing
    , textAlignment = ""
    , color = ColorClass ""
    }



-- Attrs : Colors


{-| -}
default : Attribute
default =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text-text" })


{-| -}
subtle : Attribute
subtle =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text-subtle" })


{-| -}
color : String -> Attribute
color v =
    Attr.attr (\attrs -> { attrs | color = ColorCustom v })



-- Attrs : Sizes


{-| -}
extraSmall : Attribute
extraSmall =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-xs" })


{-| -}
small : Attribute
small =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-sm" })


{-| -}
large : Attribute
large =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-lg" })


{-| -}
extraLarge : Attribute
extraLarge =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-xl" })


{-| Customize the font size using "rem" as unit. This way the font size is always related to the base font size of the html element.
-}
fontSize : Float -> Attribute
fontSize v =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeRem v })



-- Attrs : Font Weight


{-| -}
light : Attribute
light =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-light" })


{-| -}
regular : Attribute
regular =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-normal" })


{-| -}
semibold : Attribute
semibold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-semibold" })


{-| -}
bold : Attribute
bold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-bold" })



-- Attrs : Typography Settings


{-| Customize the line height using "em" as unit. This way the line height is always related to the current font size.
-}
lineHeight : Float -> Attribute
lineHeight v =
    Attr.attr (\attrs -> { attrs | lineHeight = Just v })


{-| Customize the letter spacing using "em" as unit. This way the letter spacing is always related to the current font size.
-}
letterSpacing : Float -> Attribute
letterSpacing v =
    Attr.attr (\attrs -> { attrs | letterSpacing = Just v })



-- Attrs : Alignment


{-| -}
alignCenter : Attribute
alignCenter =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-center" })


{-| -}
alignRight : Attribute
alignRight =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-right" })



-- Attrs : Styles


{-| -}
italic : Attribute
italic =
    Attr.attr (\attrs -> { attrs | styles = attrs.styles ++ " w--italic" })


{-| -}
lineThrough : Attribute
lineThrough =
    Attr.attr (\attrs -> { attrs | styles = attrs.styles ++ " w--line-through" })


{-| -}
underline : Attribute
underline =
    Attr.attr (\attrs -> { attrs | styles = attrs.styles ++ " w--underline" })


{-| -}
lowercase : Attribute
lowercase =
    Attr.attr (\attrs -> { attrs | casing = "w--lowercase" })


{-| -}
uppercase : Attribute
uppercase =
    Attr.attr (\attrs -> { attrs | casing = "w--uppercase" })


{-| -}
superscript : Attribute
superscript =
    Attr.attr (\attrs -> { attrs | subsuper = "w--align-super", fontSize = FontSizeEm 0.8 })


{-| -}
subscript : Attribute
subscript =
    Attr.attr (\attrs -> { attrs | subsuper = "w--align-sub", fontSize = FontSizeEm 0.8 })



-- View


{-| -}
view : List Attribute -> List (H.Html msg) -> H.Html msg
view =
    view_ H.p


{-| -}
viewInline : List Attribute -> List (H.Html msg) -> H.Html msg
viewInline =
    view_ H.span


view_ : (List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg) -> List Attribute -> List (H.Html msg) -> H.Html msg
view_ node =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            node
                [ HA.class "w--m-0"
                , HA.class attrs.styles
                , HA.class attrs.casing
                , HA.class attrs.subsuper
                , HA.class attrs.textAlignment
                , HA.class attrs.fontWeight
                , case attrs.lineHeight of
                    Just value ->
                        HA.style "line-height" (WH.em value)

                    Nothing ->
                        HA.class ""
                , case attrs.letterSpacing of
                    Just value ->
                        HA.style "letter-spacing" (WH.em value)

                    Nothing ->
                        HA.class ""
                , case attrs.color of
                    ColorCustom value ->
                        HA.style "color" value

                    ColorClass value ->
                        HA.class value
                , case attrs.fontSize of
                    FontSizeRem value ->
                        HA.style "font-size" (WH.rem value)

                    FontSizeEm value ->
                        HA.style "font-size" (WH.em value)

                    FontSizeClass value ->
                        HA.class value
                ]
                children
        )

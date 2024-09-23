module W.Text exposing
    ( view
    , extraLarge, large, small, extraSmall, fontSize
    , subtle, color
    , light, semibold, bold
    , lineHeight
    , alignCenter, alignRight
    , Attribute
    )

{-|

@docs view


## Sizes

@docs extraLarge, large, small, extraSmall, fontSize


## Colors

@docs subtle, color


## Font Weight

@docs light, semibold, bold


## Line Height

@docs lineHeight


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
    { fontSize : FontSize
    , fontWeight : String
    , lineHeight : Maybe Float
    , textAlignment : String
    , color : Color
    }


type FontSize
    = FontSizeClass String
    | FontSizeRem Float


type Color
    = ColorClass String
    | ColorCustom String


defaultAttrs : Attributes
defaultAttrs =
    { fontSize = FontSizeClass ""
    , fontWeight = ""
    , lineHeight = Nothing
    , textAlignment = ""
    , color = ColorClass ""
    }



-- Attrs : Colors


{-| -}
subtle : Attribute
subtle =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text-subtle" })


{-| -}
color : String -> Attribute
color v =
    Attr.attr (\attrs -> { attrs | color = ColorClass v })



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
semibold : Attribute
semibold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-semibold" })


{-| -}
bold : Attribute
bold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-bold" })



-- Attrs : Line Height


{-| Customize the line height using "em" as unit. This way the line height is always related to the current font size.
-}
lineHeight : Float -> Attribute
lineHeight v =
    Attr.attr (\attrs -> { attrs | lineHeight = Just v })



-- Attrs : Alignment


{-| -}
alignCenter : Attribute
alignCenter =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-center" })


{-| -}
alignRight : Attribute
alignRight =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-right" })



-- View


{-| -}
view : List Attribute -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            H.p
                [ HA.class "w--m-0"
                , HA.class attrs.textAlignment
                , HA.class attrs.fontWeight
                , case attrs.lineHeight of
                    Just value ->
                        HA.style "line-height" (WH.em value)

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

                    FontSizeClass value ->
                        HA.class value
                ]
                children
        )

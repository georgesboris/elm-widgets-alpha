module W.Heading exposing
    ( view
    , h2, h3, h4, h5, h6
    , extraLarge, large, small, extraSmall, fontSize
    , subtle, color
    , light, semibold, bold
    , lineHeight
    , alignCenter, alignRight
    , Attribute
    )

{-|

@docs view


## Heading Levels

@docs h2, h3, h4, h5, h6


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
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { element : List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
    , fontSize : FontSize
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


defaultAttrs : Attributes msg
defaultAttrs =
    { element = H.h1
    , fontSize = FontSizeClass "w--text-2xl"
    , fontWeight = ""
    , lineHeight = Nothing
    , textAlignment = ""
    , color = ColorClass ""
    }



-- Attrs : Heading Levels


{-| -}
h2 : Attribute msg
h2 =
    Attr.attr (\attrs -> { attrs | element = H.h2 })


{-| -}
h3 : Attribute msg
h3 =
    Attr.attr (\attrs -> { attrs | element = H.h3 })


{-| -}
h4 : Attribute msg
h4 =
    Attr.attr (\attrs -> { attrs | element = H.h4 })


{-| -}
h5 : Attribute msg
h5 =
    Attr.attr (\attrs -> { attrs | element = H.h5 })


{-| -}
h6 : Attribute msg
h6 =
    Attr.attr (\attrs -> { attrs | element = H.h6 })



-- Attrs : Colors


{-| -}
subtle : Attribute msg
subtle =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text-subtle" })


{-| -}
color : String -> Attribute msg
color v =
    Attr.attr (\attrs -> { attrs | color = ColorCustom v })



-- Attrs : Sizes


{-| -}
extraSmall : Attribute msg
extraSmall =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-lg" })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-xl" })


{-| -}
large : Attribute msg
large =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-4xl" })


{-| -}
extraLarge : Attribute msg
extraLarge =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeClass "w--text-5xl" })


{-| Customize the font size using "rem" as unit. This way the font size is always related to the base font size of the html element.
-}
fontSize : Float -> Attribute msg
fontSize v =
    Attr.attr (\attrs -> { attrs | fontSize = FontSizeRem v })



-- Attrs : Font Weight


{-| -}
light : Attribute msg
light =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-light" })


{-| -}
semibold : Attribute msg
semibold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-semibold" })


{-| -}
bold : Attribute msg
bold =
    Attr.attr (\attrs -> { attrs | fontWeight = "w--font-bold" })



-- Attrs : Line Height


{-| Customize the line height using "em" as unit. This way the line height is always related to the current font size.
-}
lineHeight : Float -> Attribute msg
lineHeight v =
    Attr.attr (\attrs -> { attrs | lineHeight = Just v })



-- Attrs : Alignment


{-| -}
alignCenter : Attribute msg
alignCenter =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-center" })


{-| -}
alignRight : Attribute msg
alignRight =
    Attr.attr (\attrs -> { attrs | textAlignment = "w--text-right" })



-- View


{-| -}
view : List (Attribute msg) -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            attrs.element
                [ HA.class "w--m-0 w--font-heading"
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

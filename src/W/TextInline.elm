module W.TextInline exposing
    ( view
    , notSubtle, subtle, color
    , light, semibold, bold
    , italic, lineThrough, underline, uppercase, lowercase, subscript, superscript
    , Attribute
    )

{-|

@docs view


## Colors

@docs notSubtle, subtle, color


## Font Weight

@docs light, semibold, bold


## Font Style & Decorations

@docs italic, lineThrough, underline, uppercase, lowercase, subscript, superscript


## HTML

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
    { class : String
    , fontSize : Maybe Float
    , fontWeight : String
    , color : Color
    }


type Color
    = ColorClass String
    | ColorCustom String


defaultAttrs : Attributes
defaultAttrs =
    { class = ""
    , fontSize = Nothing
    , fontWeight = ""
    , color = ColorClass ""
    }



-- Attrs : Colors


{-| -}
notSubtle : Attribute
notSubtle =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text" })


{-| -}
subtle : Attribute
subtle =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w--text-subtle" })


{-| -}
color : String -> Attribute
color v =
    Attr.attr (\attrs -> { attrs | color = ColorCustom v })



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



-- Attrs : Styles


{-| -}
italic : Attribute
italic =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--italic" })


{-| -}
lineThrough : Attribute
lineThrough =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--line-through" })


{-| -}
underline : Attribute
underline =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--underline" })


{-| -}
lowercase : Attribute
lowercase =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--lowercase" })


{-| -}
uppercase : Attribute
uppercase =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--uppercase" })


{-| -}
superscript : Attribute
superscript =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--align-super", fontSize = Just 0.8 })


{-| -}
subscript : Attribute
subscript =
    Attr.attr (\attrs -> { attrs | class = attrs.class ++ " w--align-sub", fontSize = Just 0.8 })



-- View


{-| -}
view : List Attribute -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            H.span
                [ HA.class attrs.class
                , HA.class attrs.fontWeight
                , case attrs.fontSize of
                    Just value ->
                        HA.style "font-size" (WH.em value)

                    Nothing ->
                        HA.class ""
                , case attrs.color of
                    ColorCustom value ->
                        HA.style "color" value

                    ColorClass value ->
                        HA.class value
                ]
                children
        )

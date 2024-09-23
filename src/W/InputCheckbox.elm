module W.InputCheckbox exposing
    ( view, viewReadOnly, Attribute
    , color, colorful, small, toggle
    , disabled, readOnly
    )

{-|

@docs view, viewReadOnly, Attribute


# Styles

@docs color, colorful, small, toggle


# States

@docs disabled, readOnly

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Theme



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { color : String
    , small : Bool
    , colorful : Bool
    , disabled : Bool
    , readOnly : Bool
    , style : Style
    , msg : Maybe msg
    }


type Style
    = Checkbox
    | Toggle


defaultAttrs : Attributes msg
defaultAttrs =
    { color = W.Theme.primaryScale.solid
    , small = False
    , colorful = False
    , disabled = False
    , readOnly = False
    , style = Checkbox
    , msg = Nothing
    }



-- Attributes : Setters


{-| -}
color : String -> Attribute msg
color v =
    Attr.attr (\attrs -> { attrs | color = v })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
colorful : Attribute msg
colorful =
    Attr.attr (\attrs -> { attrs | colorful = True })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | readOnly = True })


{-| -}
readOnly : Attribute msg
readOnly =
    Attr.attr (\attrs -> { attrs | readOnly = True })


{-| -}
toggle : Attribute msg
toggle =
    Attr.attr (\attrs -> { attrs | style = Toggle })



-- Main


baseAttrs : List (Attribute msg) -> Bool -> List (H.Attribute msg)
baseAttrs attrs_ value =
    let
        attrs : Attributes msg
        attrs =
            Attr.toAttrs defaultAttrs attrs_
    in
    [ HA.class "w/focus"
    , HA.classList
        [ ( "w--toggle", attrs.style == Toggle )
        , ( "w--checkbox w--rounded before:w--rounded", attrs.style == Checkbox )
        , ( "w--small", attrs.small )
        , ( "w--colorful", attrs.colorful )
        , ( "w--pointer-events-none", attrs.readOnly )
        ]
    , W.Theme.styleList
        [ ( "--bg", W.Theme.color.bg )
        , ( "--fg"
          , if attrs.disabled then
                W.Theme.color.textSubtle

            else
                attrs.color
          )
        ]
    , HA.type_ "checkbox"
    , HA.checked value

    -- We also disable the checkbox plugin when it is readonly
    -- Since this property is not currently respected for checkboxes
    , HA.disabled (attrs.disabled || attrs.readOnly)
    , HA.readonly attrs.readOnly
    ]


{-| -}
view :
    List (Attribute msg)
    -> { value : Bool, onInput : Bool -> msg }
    -> H.Html msg
view attrs_ props =
    H.input
        (HE.onCheck props.onInput :: baseAttrs attrs_ props.value)
        []


{-| -}
viewReadOnly :
    List (Attribute msg)
    -> Bool
    -> H.Html msg
viewReadOnly attrs_ value =
    H.input
        (baseAttrs (readOnly :: attrs_) value)
        []

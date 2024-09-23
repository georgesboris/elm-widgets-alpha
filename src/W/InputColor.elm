module W.InputColor exposing
    ( view, viewReadOnly, Attribute
    , disabled, readOnly
    , small, rounded
    , id
    )

{-|

@docs view, viewReadOnly, Attribute


# States

@docs disabled, readOnly


# Styles

@docs small, rounded


# Html

@docs id

-}

import Attr
import Color
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Color
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , small : Bool
    , rounded : Bool
    , disabled : Bool
    , readOnly : Bool
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , small = False
    , rounded = False
    , disabled = False
    , readOnly = False
    , msg = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })


{-| -}
readOnly : Attribute msg
readOnly =
    Attr.attr (\attrs -> { attrs | readOnly = True })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
rounded : Attribute msg
rounded =
    Attr.attr (\attrs -> { attrs | rounded = True })



-- Main


{-| -}
view :
    List (Attribute msg)
    -> { value : Color.Color, onInput : Color.Color -> msg }
    -> H.Html msg
view attrs props =
    view_ [ HE.onInput (props.onInput << W.Internal.Color.fromHex) ]
        attrs
        props.value


{-| -}
viewReadOnly :
    List (Attribute msg)
    -> Color.Color
    -> H.Html msg
viewReadOnly attrs value =
    view_ [] (readOnly :: attrs) value


view_ : List (H.Attribute msg) -> List (Attribute msg) -> Color.Color -> H.Html msg
view_ htmlAttrs =
    Attr.withAttrs defaultAttrs
        (\attrs value ->
            let
                hexColor : String
                hexColor =
                    W.Internal.Color.toHex value
            in
            H.div
                [ HA.class "w--inline-flex w--input-color"
                , HA.classList
                    [ ( "w--is-small", attrs.small )
                    , ( "w--is-rounded", attrs.rounded )
                    ]
                , HA.style "color" hexColor
                ]
                [ H.input
                    (htmlAttrs
                        ++ [ WH.maybeAttr HA.id attrs.id
                           , HA.class "w/focus w--input"
                           , HA.type_ "color"
                           , HA.value hexColor
                           , HA.disabled (attrs.disabled || attrs.readOnly)
                           , HA.readonly attrs.readOnly
                           ]
                    )
                    []
                ]
        )

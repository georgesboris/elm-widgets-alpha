module W.InputRadio exposing
    ( view, Attribute
    , color, small
    , disabled, readOnly, vertical
    )

{-|

@docs view, Attribute


# Styles

@docs color, small


# States

@docs disabled, readOnly, vertical

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
    , disabled : Bool
    , readOnly : Bool
    , vertical : Bool
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { color = W.Theme.primaryScale.solid
    , small = False
    , disabled = False
    , readOnly = False
    , vertical = False
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
disabled : Bool -> Attribute msg
disabled v =
    Attr.attr (\attrs -> { attrs | disabled = v })


{-| -}
readOnly : Bool -> Attribute msg
readOnly v =
    Attr.attr (\attrs -> { attrs | readOnly = v })


{-| -}
vertical : Bool -> Attribute msg
vertical v =
    Attr.attr (\attrs -> { attrs | vertical = v })



-- Main


{-| -}
view :
    List (Attribute msg)
    ->
        { id : String
        , value : a
        , options : List a
        , toValue : a -> String
        , toLabel : a -> String
        , onInput : a -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.div
                [ HA.id props.id
                , HA.class "w--flex"
                , HA.classList
                    [ ( "w--flex-col", attrs.vertical )
                    , ( "w--gap-lg", not attrs.small || not attrs.vertical )
                    , ( "w--gap-md", attrs.small && attrs.vertical )
                    ]
                ]
                (props.options
                    |> List.map
                        (\a ->
                            H.label
                                [ HA.name props.id
                                , HA.class "w--inline-flex w--items-center w--p-0"
                                ]
                                [ H.input
                                    [ HA.class "w/focus"
                                    , HA.class "w--radio w--rounded-full before:w--rounded-full"
                                    , HA.type_ "radio"
                                    , HA.name props.id
                                    , HA.value (props.toValue a)
                                    , HA.checked (a == props.value)
                                    , HA.classList [ ( "w--small", attrs.small ) ]
                                    , W.Theme.styleList
                                        [ if attrs.disabled then
                                            ( "color", W.Theme.color.textSubtle )

                                          else
                                            ( "color", attrs.color )
                                        ]

                                    -- Fallback since read only is not respected for radio inputs
                                    , HA.disabled (attrs.disabled || attrs.readOnly)
                                    , HA.readonly attrs.readOnly

                                    --
                                    , HE.onCheck (\_ -> props.onInput a)
                                    ]
                                    []
                                , H.span
                                    [ HA.class "w--font-base w--text-default w--pl-lg"
                                    ]
                                    [ H.text (props.toLabel a) ]
                                ]
                        )
                )
        )

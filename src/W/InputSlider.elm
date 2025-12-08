module W.InputSlider exposing
    ( view, Attribute
    , disabled, readOnly
    , color
    , small
    , vertical
    )

{-|

@docs view, Attribute


# States

@docs disabled, readOnly


# Styles

@docs color
@docs small

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as D
import W.Internal.Helpers as WH
import W.Theme.Color



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { disabled : Bool
    , readOnly : Bool
    , small : Bool
    , vertical : Bool
    , color : String
    , format : Float -> String
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { disabled = False
    , readOnly = False
    , small = False
    , vertical = False
    , color = W.Theme.Color.primarySolid
    , format = String.fromFloat
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
vertical : Attribute msg
vertical =
    Attr.attr (\attrs -> { attrs | vertical = True })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })


{-| -}
readOnly : Attribute msg
readOnly =
    Attr.attr (\attrs -> { attrs | readOnly = True })



-- Main


{-| -}
view :
    List (Attribute msg)
    ->
        { min : Float
        , max : Float
        , step : Float
        , value : Float
        , onInput : Float -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                valueString : String
                valueString =
                    (props.value - props.min)
                        / (props.max - props.min)
                        |> WH.pct

                colorAttr : H.Attribute msg
                colorAttr =
                    if attrs.disabled then
                        HA.class "w--text-subtle"

                    else
                        HA.style "color" attrs.color
            in
            H.div
                [ HA.class "w__slider"
                , HA.class "w--group w--relative w--full"
                , HA.classList
                    [ ( "w__m-small", attrs.small )
                    , ( "w__m-vertical", attrs.vertical )
                    ]
                , colorAttr
                ]
                [ H.div [ HA.class "w--absolute w--inset-y-0 w--inset-x-[12px]" ]
                    [ -- Track
                      H.div
                        [ HA.class "w__slider__track"
                        , HA.class "w--absolute w--rounded"
                        , HA.class "w--inset-x-0 w--top-1/2"
                        , HA.class "w--bg-tint"
                        ]
                        []
                    , -- Value Track Background
                      H.div
                        [ HA.class "w__slider__value-track-bg"
                        , HA.class "w--absolute w--z-1 w--rounded"
                        , HA.class "w--left-0 w--top-1/2"
                        , HA.class "w--bg"
                        , HA.style "width" valueString
                        ]
                        []
                    , -- Value Track
                      H.div
                        [ HA.class "w__slider__value-track"
                        , HA.class "w--absolute w--z-0 w--rounded"
                        , HA.class "w--left-0 w--top-1/2"
                        , HA.class "w--bg-current"
                        , HA.class "w--opacity-[0.60]"
                        , HA.style "width" valueString
                        ]
                        []
                    ]
                , -- Thumb
                  H.input
                    [ HA.class "w__slider__input"
                    , HA.class "w--relative"
                    , HA.class "w--slider w--appearance-none"
                    , HA.class "w--bg-transparent"
                    , HA.class "w--m-0"
                    , HA.class "focus-visible:w--outline-0"
                    , HA.type_ "range"
                    , colorAttr

                    -- This is a fallback since range elements will not respect read only attributes
                    , HA.disabled (attrs.disabled || attrs.readOnly)
                    , HA.readonly attrs.readOnly

                    --
                    , HA.value <| String.fromFloat props.value
                    , HA.min <| String.fromFloat props.min
                    , HA.max <| String.fromFloat props.max
                    , HA.step <| String.fromFloat props.step
                    , HE.on "input"
                        (D.at [ "target", "value" ] D.string
                            |> D.andThen
                                (\v ->
                                    case String.toFloat v of
                                        Just v_ ->
                                            D.succeed v_

                                        Nothing ->
                                            D.fail "Invalid value."
                                )
                            |> D.map props.onInput
                        )
                    ]
                    []
                ]
        )

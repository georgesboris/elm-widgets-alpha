module W.InputFloat exposing
    ( view, Attribute
    , init, toFloat, toString, Value
    , small, placeholder, mask, prefix, suffix
    , autofocus, disabled, readOnly
    , required, min, max, step, validation
    , viewWithValidation, errorToString, Error(..)
    , onEnter, onFocus, onBlur
    , id
    )

{-|

@docs view, Attribute


# Value

@docs init, toFloat, toString, Value


# Styles

@docs small, placeholder, mask, prefix, suffix


# States

@docs autofocus, disabled, readOnly


# Validation Attributes

@docs required, min, max, step, validation


# View With Validation

@docs viewWithValidation, errorToString, Error


# Actions

@docs onEnter, onFocus, onBlur


# Html

@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as D
import W.Internal.Helpers as WH
import W.Internal.Input



-- Value


{-| -}
type Value
    = Value String (Maybe Float)


{-| -}
init : Maybe Float -> Value
init value =
    Value
        (value
            |> Maybe.map String.fromFloat
            |> Maybe.withDefault ""
        )
        value


{-| -}
toFloat : Value -> Maybe Float
toFloat (Value _ v) =
    v


{-| -}
toString : Value -> String
toString (Value v _) =
    v



-- Errors


{-| -}
type Error
    = TooLow Float String
    | TooHigh Float String
    | TooLong Int String
    | TooShort Int String
    | StepMismatch Float String
    | ValueMissing String
    | Custom String


{-| -}
errorToString : Error -> String
errorToString error =
    case error of
        TooLow _ message ->
            message

        TooHigh _ message ->
            message

        TooLong _ message ->
            message

        TooShort _ message ->
            message

        StepMismatch _ message ->
            message

        ValueMissing message ->
            message

        Custom message ->
            message



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , disabled : Bool
    , readOnly : Bool
    , required : Bool
    , autofocus : Bool
    , small : Bool
    , min : Maybe Float
    , max : Maybe Float
    , validation : Maybe (Maybe Float -> String -> Maybe String)
    , step : Float
    , placeholder : Maybe String
    , mask : Maybe (String -> String)
    , prefix : Maybe (List (H.Html msg))
    , suffix : Maybe (List (H.Html msg))
    , onFocus : Maybe msg
    , onBlur : Maybe msg
    , onEnter : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , disabled = False
    , readOnly = False
    , required = False
    , autofocus = False
    , small = False
    , min = Nothing
    , max = Nothing
    , validation = Nothing
    , step = 0.01
    , placeholder = Nothing
    , mask = Nothing
    , prefix = Nothing
    , suffix = Nothing
    , onFocus = Nothing
    , onBlur = Nothing
    , onEnter = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
placeholder : String -> Attribute msg
placeholder v =
    Attr.attr (\attrs -> { attrs | placeholder = Just v })


{-| -}
mask : (String -> String) -> Attribute msg
mask v =
    Attr.attr (\attrs -> { attrs | mask = Just v })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })


{-| -}
readOnly : Attribute msg
readOnly =
    Attr.attr (\attrs -> { attrs | readOnly = True })


{-| -}
required : Attribute msg
required =
    Attr.attr (\attrs -> { attrs | required = True })


{-| -}
autofocus : Attribute msg
autofocus =
    Attr.attr (\attrs -> { attrs | autofocus = True })


{-| -}
min : Float -> Attribute msg
min v =
    Attr.attr (\attrs -> { attrs | min = Just v })


{-| -}
max : Float -> Attribute msg
max v =
    Attr.attr (\attrs -> { attrs | max = Just v })


{-| -}
validation : (Maybe Float -> String -> Maybe String) -> Attribute msg
validation v =
    Attr.attr (\attrs -> { attrs | validation = Just v })


{-| -}
step : Float -> Attribute msg
step v =
    Attr.attr (\attrs -> { attrs | step = v })


{-| -}
prefix : List (H.Html msg) -> Attribute msg
prefix v =
    Attr.attr (\attrs -> { attrs | prefix = Just v })


{-| -}
suffix : List (H.Html msg) -> Attribute msg
suffix v =
    Attr.attr (\attrs -> { attrs | suffix = Just v })


{-| -}
onBlur : msg -> Attribute msg
onBlur v =
    Attr.attr (\attrs -> { attrs | onBlur = Just v })


{-| -}
onFocus : msg -> Attribute msg
onFocus v =
    Attr.attr (\attrs -> { attrs | onFocus = Just v })


{-| -}
onEnter : msg -> Attribute msg
onEnter v =
    Attr.attr (\attrs -> { attrs | onEnter = Just v })



-- Main


{-| -}
baseAttrs : Attributes msg -> List (H.Attribute msg)
baseAttrs attrs =
    [ WH.maybeAttr HA.id attrs.id
    , HA.type_ "number"
    , HA.class (W.Internal.Input.baseClass attrs.small)
    , HA.required attrs.required
    , HA.disabled attrs.disabled
    , HA.readonly attrs.readOnly
    , HA.autofocus attrs.autofocus
    , WH.attrIf attrs.readOnly (HA.attribute "aria-readonly") "true"
    , WH.attrIf attrs.disabled (HA.attribute "aria-disabled") "true"
    , WH.maybeAttr HA.min (Maybe.map String.fromFloat attrs.min)
    , WH.maybeAttr HA.max (Maybe.map String.fromFloat attrs.max)
    , HA.step (String.fromFloat attrs.step)
    , WH.maybeAttr HA.placeholder attrs.placeholder
    , WH.maybeAttr HE.onFocus attrs.onFocus
    , WH.maybeAttr HE.onBlur attrs.onBlur
    , WH.maybeAttr WH.onEnter attrs.onEnter
    ]


{-| -}
view :
    List (Attribute msg)
    ->
        { value : Value
        , onInput : Value -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                value : String
                value =
                    toString props.value
            in
            W.Internal.Input.view
                { small = attrs.small
                , disabled = attrs.disabled
                , readOnly = attrs.readOnly
                , prefix = attrs.prefix
                , suffix = attrs.suffix
                , mask = attrs.mask
                , maskInput = value
                }
                (H.input
                    (baseAttrs attrs
                        ++ [ HA.value value
                           , HE.on "input"
                                (D.at [ "target", "value" ] D.string
                                    |> D.map (props.onInput << toValue props.value)
                                )
                           ]
                    )
                    []
                )
        )


{-| -}
viewWithValidation :
    List (Attribute msg)
    ->
        { value : Value
        , onInput : Result (List Error) (Maybe Float) -> Value -> msg
        }
    -> H.Html msg
viewWithValidation =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                value : String
                value =
                    toString props.value
            in
            W.Internal.Input.view
                { small = attrs.small
                , disabled = attrs.disabled
                , readOnly = attrs.readOnly
                , prefix = attrs.prefix
                , suffix = attrs.suffix
                , mask = attrs.mask
                , maskInput = value
                }
                (H.input
                    (baseAttrs attrs
                        ++ [ HA.value value
                           , HE.on "input"
                                (D.map5
                                    (\( value_, valid ) rangeOverflow rangeUnderflow stepMismatch valueMissing ->
                                        let
                                            value__ : Value
                                            value__ =
                                                toValue props.value value_

                                            customError : Maybe Error
                                            customError =
                                                attrs.validation
                                                    |> Maybe.andThen (\fn -> fn (toFloat value__) value_)
                                                    |> Maybe.map Custom

                                            result : Result (List Error) (Maybe Float)
                                            result =
                                                if valid && customError == Nothing then
                                                    Ok (toFloat value__)

                                                else
                                                    [ Just (ValueMissing "Please fill out this field.")
                                                        |> WH.keepIf valueMissing
                                                    , attrs.min
                                                        |> WH.keepIf rangeOverflow
                                                        |> Maybe.map
                                                            (\min_ ->
                                                                TooLow min_ ("Value must be greater than or equal to " ++ String.fromFloat min_)
                                                            )
                                                    , attrs.max
                                                        |> WH.keepIf rangeUnderflow
                                                        |> Maybe.map
                                                            (\max_ ->
                                                                TooHigh max_ ("Value must be less than or equal to " ++ String.fromFloat max_)
                                                            )
                                                    , Just attrs.step
                                                        |> WH.keepIf stepMismatch
                                                        |> Maybe.map2
                                                            (\value___ step_ ->
                                                                let
                                                                    ( f, c ) =
                                                                        WH.nearestFloats value___ attrs.step
                                                                            |> Tuple.mapBoth (WH.formatFloat attrs.step) (WH.formatFloat attrs.step)
                                                                in
                                                                StepMismatch step_
                                                                    ("Please enter a valid value. The two nearest valid values are " ++ f ++ " and " ++ c)
                                                            )
                                                            (toFloat value__)
                                                    , customError
                                                    ]
                                                        |> List.filterMap identity
                                                        |> Err
                                        in
                                        props.onInput result value__
                                    )
                                    (D.map2 Tuple.pair
                                        (D.at [ "target", "value" ] D.string)
                                        (D.at [ "target", "validity", "valid" ] D.bool)
                                    )
                                    (D.at [ "target", "validity", "rangeOverflow" ] D.bool)
                                    (D.at [ "target", "validity", "rangeUnderflow" ] D.bool)
                                    (D.at [ "target", "validity", "stepMismatch" ] D.bool)
                                    (D.at [ "target", "validity", "valueMissing" ] D.bool)
                                )
                           ]
                    )
                    []
                )
        )


toValue : Value -> String -> Value
toValue previous value =
    case String.toFloat value of
        Just v ->
            Value value (Just v)

        Nothing ->
            if value == "" then
                Value value Nothing

            else
                -- This is a fallback so the user doesn't get a wrong value while the user is typing.
                -- For instance, if the user wants to write "2.3" we will still mark 2 as the value when the user typed "2.".
                case String.toFloat (toString previous) of
                    Just v_ ->
                        Value value (Just v_)

                    Nothing ->
                        Value value Nothing

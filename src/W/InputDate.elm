module W.InputDate exposing
    ( view, Attribute
    , init, toDate, toTimeZone, toString, Value
    , autofocus, disabled, readOnly
    , small, prefix, suffix
    , min, max, required
    , viewWithValidation, errorToString, Error(..)
    , onEnter, onFocus, onBlur
    , id
    )

{-|

@docs view, Attribute


# Value

@docs init, toDate, toTimeZone, toString, Value


# States

@docs autofocus, disabled, readOnly


# Styles

@docs small, prefix, suffix


# Validation Attributes

@docs min, max, required


# View & Validation

@docs viewWithValidation, errorToString, Error


# Actions

@docs onEnter, onFocus, onBlur


# Html

@docs id

-}

import Attr
import Date
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as D
import Time
import Time.Extra
import W.Internal.Helpers as WH
import W.Internal.Icons
import W.Internal.Input



-- Value


{-| -}
type Value
    = Value String Time.Zone (Maybe Time.Posix)


{-| -}
init : Time.Zone -> Maybe Time.Posix -> Value
init timeZone value =
    case value of
        Just v ->
            Value (valueFromDate timeZone v) timeZone (Just v)

        Nothing ->
            Value "" timeZone Nothing


{-| -}
toTimeZone : Value -> Time.Zone
toTimeZone (Value _ v _) =
    v


{-| -}
toDate : Value -> Maybe Time.Posix
toDate (Value _ _ v) =
    v


{-| -}
toString : Value -> String
toString (Value v _ _) =
    v



-- Error
-- Why is 'StepMismatch' missing? The actual browser behavior seems a bit odd.
-- It behaves differently based on the `min` property
-- and if `min` is not specified it steps from the the unix 0 timestamp?


{-| -}
type Error
    = TooLow Time.Posix String
    | TooHigh Time.Posix String
    | ValueMissing String
    | BadInput String


{-| -}
errorToString : Error -> String
errorToString error =
    case error of
        TooLow _ message ->
            message

        TooHigh _ message ->
            message

        ValueMissing message ->
            message

        BadInput message ->
            message



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , class : String
    , disabled : Bool
    , readOnly : Bool
    , required : Bool
    , autofocus : Bool
    , small : Bool
    , min : Maybe Time.Posix
    , max : Maybe Time.Posix
    , prefix : Maybe (List (H.Html msg))
    , suffix : Maybe (List (H.Html msg))
    , onFocus : Maybe msg
    , onBlur : Maybe msg
    , onEnter : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , class = ""
    , disabled = False
    , readOnly = False
    , required = False
    , autofocus = False
    , small = False
    , min = Nothing
    , max = Nothing
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
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
min : Time.Posix -> Attribute msg
min v =
    Attr.attr (\attrs -> { attrs | min = Just v })


{-| -}
max : Time.Posix -> Attribute msg
max v =
    Attr.attr (\attrs -> { attrs | max = Just v })


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


baseAttrs : Attributes msg -> Value -> List (H.Attribute msg)
baseAttrs attrs (Value valueString timeZone value) =
    [ WH.maybeAttr HA.id attrs.id
    , HA.type_ "date"
    , HA.class (W.Internal.Input.baseClassNoColor attrs.small)
    , HA.classList
        [ ( "ew-text-subtle", value == Nothing )
        , ( "ew-text-inherit", value /= Nothing )
        ]
    , HA.required attrs.required
    , HA.disabled attrs.disabled
    , HA.readonly attrs.readOnly
    , HA.autofocus attrs.autofocus
    , WH.attrIf attrs.readOnly (HA.attribute "aria-readonly") "true"
    , WH.attrIf attrs.disabled (HA.attribute "aria-disabled") "true"
    , WH.maybeAttr HA.min (Maybe.map (valueFromDate timeZone) attrs.min)
    , WH.maybeAttr HA.max (Maybe.map (valueFromDate timeZone) attrs.max)
    , WH.maybeAttr HE.onFocus attrs.onFocus
    , WH.maybeAttr HE.onBlur attrs.onBlur
    , WH.maybeAttr WH.onEnter attrs.onEnter
    , HA.value valueString
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
            H.input
                (HE.on "input"
                    (D.map2
                        (\vs vn -> props.onInput <| dateFromValue props.value vs vn)
                        (D.at [ "target", "value" ] D.string)
                        (D.at [ "target", "valueAsNumber" ] D.float)
                    )
                    :: baseAttrs attrs props.value
                )
                []
                |> W.Internal.Input.viewWithIcon
                    { small = attrs.small
                    , prefix = attrs.prefix
                    , suffix = attrs.suffix
                    , disabled = attrs.disabled
                    , readOnly = attrs.readOnly
                    , mask = Nothing
                    , maskInput = toString props.value
                    }
                    (W.Internal.Icons.calendar { size = 24 })
        )


{-| -}
viewWithValidation :
    List (Attribute msg)
    ->
        { value : Value
        , onInput : Result (List Error) (Maybe Time.Posix) -> Value -> msg
        }
    -> H.Html msg
viewWithValidation =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.input
                (HE.on "input"
                    (D.map6
                        (\valueString valueAsNumber valid rangeOverflow rangeUnderflow valueMissing ->
                            let
                                newValue : Value
                                newValue =
                                    dateFromValue props.value valueString valueAsNumber
                            in
                            if valid then
                                props.onInput (Ok (toDate newValue)) newValue

                            else
                                [ Just (ValueMissing "Please fill out this field.")
                                    |> WH.keepIf valueMissing
                                , attrs.min
                                    |> WH.keepIf rangeUnderflow
                                    |> Maybe.map
                                        (\min_ ->
                                            let
                                                timeString : String
                                                timeString =
                                                    valueFromDate (toTimeZone props.value) min_
                                            in
                                            TooLow min_ ("Value must be " ++ timeString ++ " or later.")
                                        )
                                , attrs.max
                                    |> WH.keepIf rangeOverflow
                                    |> Maybe.map
                                        (\max_ ->
                                            let
                                                timeString : String
                                                timeString =
                                                    valueFromDate (toTimeZone props.value) max_
                                            in
                                            TooHigh max_ ("Value must be " ++ timeString ++ " or earlier.")
                                        )
                                ]
                                    |> List.filterMap identity
                                    |> (\xs -> props.onInput (Err xs) newValue)
                        )
                        (D.at [ "target", "value" ] D.string)
                        (D.at [ "target", "valueAsNumber" ] D.float)
                        (D.at [ "target", "validity", "valid" ] D.bool)
                        (D.at [ "target", "validity", "rangeOverflow" ] D.bool)
                        (D.at [ "target", "validity", "rangeUnderflow" ] D.bool)
                        (D.at [ "target", "validity", "valueMissing" ] D.bool)
                    )
                    :: baseAttrs attrs props.value
                )
                []
                |> W.Internal.Input.viewWithIcon
                    { small = attrs.small
                    , prefix = attrs.prefix
                    , suffix = attrs.suffix
                    , disabled = attrs.disabled
                    , readOnly = attrs.readOnly
                    , mask = Nothing
                    , maskInput = toString props.value
                    }
                    (W.Internal.Icons.calendar { size = 24 })
        )



-- Helpers


valueFromDate : Time.Zone -> Time.Posix -> String
valueFromDate timeZone timestamp =
    timestamp
        |> Date.fromPosix timeZone
        |> Date.format "yyyy-MM-dd"


dateFromValue : Value -> String -> Float -> Value
dateFromValue (Value _ timeZone currentValue) valueString valueAsNumber =
    if isNaN valueAsNumber then
        Value valueString timeZone Nothing

    else
        let
            notAdjusted : Time.Posix
            notAdjusted =
                Time.millisToPosix (floor valueAsNumber)

            timezoneAdjusted : Int
            timezoneAdjusted =
                floor valueAsNumber - (Time.Extra.toOffset timeZone notAdjusted * 60 * 1000)

            timeOfDayOffset : Int
            timeOfDayOffset =
                currentValue
                    |> Maybe.map
                        (\userValue ->
                            Time.Extra.diff Time.Extra.Millisecond
                                timeZone
                                (Time.Extra.floor Time.Extra.Day timeZone userValue)
                                userValue
                        )
                    |> Maybe.withDefault 0

            dateValue : Maybe Time.Posix
            dateValue =
                Just (Time.millisToPosix (timezoneAdjusted + timeOfDayOffset))
        in
        Value valueString timeZone dateValue

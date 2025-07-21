module W.InputSelect exposing
    ( view, viewGroups, viewOptional, viewGroupsOptional, Attribute
    , autofocus, disabled, readOnly
    , small, prefix, suffix
    , id
    )

{-|

@docs view, viewGroups, viewOptional, viewGroupsOptional, Attribute


# States

@docs autofocus, disabled, readOnly


# Styles

@docs small, prefix, suffix


# Html

@docs id

-}

import Attr
import Dict exposing (Dict)
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Internal.Input



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , disabled : Bool
    , readOnly : Bool
    , small : Bool
    , autofocus : Bool
    , prefix : Maybe (List (H.Html msg))
    , suffix : Maybe (List (H.Html msg))
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , disabled = False
    , readOnly = False
    , autofocus = False
    , small = False
    , prefix = Nothing
    , suffix = Nothing
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
autofocus : Attribute msg
autofocus =
    Attr.attr (\attrs -> { attrs | autofocus = True })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
prefix : List (H.Html msg) -> Attribute msg
prefix v =
    Attr.attr (\attrs -> { attrs | prefix = Just v })


{-| -}
suffix : List (H.Html msg) -> Attribute msg
suffix v =
    Attr.attr (\attrs -> { attrs | suffix = Just v })



-- View


{-| -}
viewGroups :
    List (Attribute msg)
    ->
        { value : a
        , options : List a
        , optionGroups : List ( String, List a )
        , toLabel : a -> String
        , onInput : a -> msg
        }
    -> H.Html msg
viewGroups =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                values : Dict String a
                values =
                    props.optionGroups
                        |> List.concatMap Tuple.second
                        |> List.append props.options
                        |> List.map (\a -> ( props.toLabel a, a ))
                        |> Dict.fromList
            in
            W.Internal.Input.view
                { small = attrs.small
                , prefix = attrs.prefix
                , suffix = attrs.suffix
                , disabled = attrs.disabled
                , readOnly = attrs.readOnly
                , mask = Nothing
                , maskInput = ""
                }
                (H.select
                    [ WH.maybeAttr HA.id attrs.id
                    , HA.class (W.Internal.Input.baseClass attrs.small)
                    , HA.class "w--pr-[2.5em]"
                    , HA.disabled attrs.disabled
                    , HA.readonly attrs.readOnly
                    , HA.autofocus attrs.autofocus
                    , WH.attrIf attrs.readOnly (HA.attribute "aria-readonly") "true"
                    , WH.attrIf attrs.disabled (HA.attribute "aria-disabled") "true"
                    , HA.placeholder "Select"
                    , HE.onInput
                        (\s ->
                            Dict.get s values
                                |> Maybe.withDefault props.value
                                |> props.onInput
                        )
                    ]
                    (List.concat
                        [ props.options
                            |> List.map
                                (\a ->
                                    H.option
                                        [ HA.selected (a == props.value)
                                        , HA.value (props.toLabel a)
                                        ]
                                        [ H.text (props.toLabel a) ]
                                )
                        , props.optionGroups
                            |> List.map
                                (\( l, options_ ) ->
                                    H.optgroup [ HA.attribute "label" l ]
                                        (options_
                                            |> List.map
                                                (\a ->
                                                    H.option
                                                        [ HA.selected (a == props.value)
                                                        , HA.value (props.toLabel a)
                                                        ]
                                                        [ H.text (props.toLabel a) ]
                                                )
                                        )
                                )
                        ]
                    )
                )
        )


{-| -}
view :
    List (Attribute msg)
    ->
        { value : a
        , options : List a
        , toLabel : a -> String
        , onInput : a -> msg
        }
    -> H.Html msg
view attrs_ props =
    viewGroups attrs_
        { value = props.value
        , options = props.options
        , optionGroups = []
        , toLabel = props.toLabel
        , onInput = props.onInput
        }


{-| -}
viewOptional :
    List (Attribute msg)
    ->
        { value : Maybe a
        , options : List a
        , toLabel : a -> String
        , placeholder : String
        , onInput : Maybe a -> msg
        }
    -> H.Html msg
viewOptional attrs_ props =
    viewGroupsOptional attrs_
        { value = props.value
        , options = props.options
        , optionGroups = []
        , placeholder = props.placeholder
        , toLabel = props.toLabel
        , onInput = props.onInput
        }


{-| -}
viewGroupsOptional :
    List (Attribute msg)
    ->
        { value : Maybe a
        , options : List a
        , optionGroups : List ( String, List a )
        , toLabel : a -> String
        , placeholder : String
        , onInput : Maybe a -> msg
        }
    -> H.Html msg
viewGroupsOptional attrs_ props =
    viewGroups attrs_
        { value = props.value
        , options = Nothing :: List.map Just props.options
        , optionGroups = []
        , toLabel = Maybe.map props.toLabel >> Maybe.withDefault props.placeholder
        , onInput = props.onInput
        }

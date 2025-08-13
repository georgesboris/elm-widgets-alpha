module W.Playground exposing
    ( Playground, PlaygroundState
    , succeed, bool, string, int, float
    , options, boolOption
    , attr, boolAttr
    , init, view, toModel
    )

{-|

@docs Playground, PlaygroundState


## Basic Values

@docs succeed, bool, string, int, float


## Custom Options

@docs options, boolOption


## Attribute Helpers

@docs attr, boolAttr


## Using the Playground

@docs init, view, toModel

-}

import Attr
import Dict
import Html as H
import Html.Attributes as HA
import W.InputCheckbox
import W.InputFloat
import W.InputInt
import W.InputSelect
import W.InputText



-- Model


{-| -}
type PlaygroundState
    = PlaygroundState PlaygroundStateData


type alias PlaygroundStateData =
    Dict.Dict String PlaygroundFieldValue


{-| -}
init : Playground a -> PlaygroundState
init (Playground playground) =
    playground.fields
        |> List.map (\f -> ( f.name, f.initialValue ))
        |> Dict.fromList
        |> PlaygroundState


{-| -}
toModel : PlaygroundState -> Playground a -> a
toModel (PlaygroundState model) (Playground playground) =
    playground.model model


{-| -}
getFieldValue : PlaygroundField -> PlaygroundState -> PlaygroundFieldValue
getFieldValue field (PlaygroundState state) =
    Dict.get field.name state
        |> Maybe.withDefault field.initialValue


{-| -}
updateField : String -> PlaygroundFieldValue -> PlaygroundState -> PlaygroundState
updateField key value (PlaygroundState dict) =
    PlaygroundState (Dict.insert key value dict)



-- Types


type PlaygroundFieldValue
    = FString String
    | FFloat W.InputFloat.Value
    | FInt W.InputInt.Value
    | FBool Bool
    | FCustom String (List String)


type alias PlaygroundField =
    { name : String
    , description : String
    , initialValue : PlaygroundFieldValue
    }


{-| -}
type Playground a
    = Playground
        { model : PlaygroundStateData -> a
        , fields : List PlaygroundField
        }



-- Setup


{-| -}
succeed : model -> Playground model
succeed fields =
    Playground
        { model = \_ -> fields
        , fields = []
        }



-- Fields : String


{-| -}
string :
    { name : String
    , description : String
    , default : String
    }
    -> Playground (String -> model)
    -> Playground model
string field =
    withField
        { name = field.name
        , description = field.description
        , initialValue = field.default
        , initialFieldValue = FString
        , decode =
            \value ->
                case value of
                    FString v ->
                        Just v

                    _ ->
                        Nothing
        }



-- Fields : Float


{-| -}
float :
    { name : String
    , description : String
    , default : Float
    }
    -> Playground (Float -> model)
    -> Playground model
float field =
    withField
        { name = field.name
        , description = field.description
        , initialValue = field.default
        , initialFieldValue =
            \v ->
                FFloat
                    (W.InputFloat.init (Just v))
        , decode =
            \value ->
                case value of
                    FFloat v ->
                        W.InputFloat.toFloat v

                    _ ->
                        Nothing
        }



-- Fields : Int


{-| -}
int :
    { name : String
    , description : String
    , default : Int
    }
    -> Playground (Int -> model)
    -> Playground model
int field =
    withField
        { name = field.name
        , description = field.description
        , initialValue = field.default
        , initialFieldValue =
            \v ->
                FInt
                    (W.InputInt.init (Just v))
        , decode =
            \value ->
                case value of
                    FInt v ->
                        W.InputInt.toInt v

                    _ ->
                        Nothing
        }



-- Fields : Bool


{-| -}
bool :
    { name : String
    , description : String
    , default : Bool
    }
    -> Playground (Bool -> model)
    -> Playground model
bool field =
    withField
        { name = field.name
        , description = field.description
        , initialValue = field.default
        , initialFieldValue = FBool
        , decode =
            \value ->
                case value of
                    FBool v ->
                        Just v

                    _ ->
                        Nothing
        }


{-| -}
boolOption :
    { name : String
    , description : String
    , default : Bool
    , trueOption : a
    , falseOption : a
    }
    -> Playground (a -> model)
    -> Playground model
boolOption field =
    let
        toOption : Bool -> a
        toOption v =
            if v then
                field.trueOption

            else
                field.falseOption
    in
    withField
        { name = field.name
        , description = field.description
        , initialValue = toOption field.default
        , initialFieldValue = \_ -> FBool field.default
        , decode =
            \value ->
                case value of
                    FBool v ->
                        Just (toOption v)

                    _ ->
                        Nothing
        }


{-| -}
boolAttr :
    { name : String
    , description : String
    , default : Bool
    , attr : Attr.Attr a
    }
    -> Playground (Attr.Attr a -> model)
    -> Playground model
boolAttr field =
    boolOption
        { name = field.name
        , description = field.description
        , default = field.default
        , trueOption = field.attr
        , falseOption = Attr.none
        }



-- Fields : Attrs


{-| -}
attr :
    { name : String
    , description : String
    , defaultOption : ( String, Attr.Attr a )
    , otherOptions : List ( String, Attr.Attr a )
    }
    -> Playground (Attr.Attr a -> model)
    -> Playground model
attr field =
    let
        allOptions : List ( String, Attr.Attr a )
        allOptions =
            field.defaultOption :: field.otherOptions

        valuesDict : Dict.Dict String (Attr.Attr a)
        valuesDict =
            Dict.fromList allOptions

        values : List String
        values =
            List.map Tuple.first allOptions
    in
    withField
        { name = field.name
        , description = field.description
        , initialValue = Tuple.second field.defaultOption
        , initialFieldValue = \_ -> FCustom (Tuple.first field.defaultOption) values
        , decode =
            \value ->
                case value of
                    FCustom v _ ->
                        Dict.get v valuesDict

                    _ ->
                        Nothing
        }



-- Fields : Options


{-| -}
options :
    { name : String
    , description : String
    , defaultOption : option
    , otherOptions : List option
    , toLabel : option -> String
    }
    -> Playground (option -> model)
    -> Playground model
options field =
    let
        allOptions : List option
        allOptions =
            field.defaultOption :: field.otherOptions

        valuesDict : Dict.Dict String option
        valuesDict =
            allOptions
                |> List.map
                    (\v ->
                        ( field.toLabel v, v )
                    )
                |> Dict.fromList

        values : List String
        values =
            List.map field.toLabel allOptions
    in
    withField
        { name = field.name
        , description = field.description
        , initialValue = field.defaultOption
        , initialFieldValue = \v -> FCustom (field.toLabel v) values
        , decode =
            \value ->
                case value of
                    FCustom v _ ->
                        Dict.get v valuesDict

                    _ ->
                        Nothing
        }



-- Fields : Custom


withField :
    { name : String
    , description : String
    , initialValue : a
    , initialFieldValue : a -> PlaygroundFieldValue
    , decode : PlaygroundFieldValue -> Maybe a
    }
    -> Playground (a -> model)
    -> Playground model
withField field (Playground playground) =
    Playground
        { model =
            \dict ->
                Dict.get field.name dict
                    |> Maybe.andThen field.decode
                    |> Maybe.withDefault field.initialValue
                    |> playground.model dict
        , fields =
            { name = field.name
            , description = field.description
            , initialValue = field.initialFieldValue field.initialValue
            }
                :: playground.fields
        }



-- View


{-| -}
view :
    { toHtml : model -> H.Html msg
    , playground : Playground model
    , onUpdate : PlaygroundState -> msg
    }
    -> PlaygroundState
    -> H.Html msg
view props values =
    H.div
        [ HA.class "w--space-y-4" ]
        [ viewPlayground props values
        , if False then
            viewTable props.playground

          else
            H.text ""
        ]


viewTable : Playground model -> H.Html msg
viewTable (Playground playground) =
    H.ul
        [ HA.class "w--border w--border-tint w--divide-y w--divide-bg" ]
        (playground.fields
            |> List.reverse
            |> List.map
                (\field ->
                    H.li
                        [ HA.class "w--p-4" ]
                        [ H.p [] [ H.text field.name ]
                        , H.p [ HA.class "w--text-subtle" ] [ H.text field.description ]
                        ]
                )
        )


viewPlayground :
    { toHtml : model -> H.Html msg
    , playground : Playground model
    , onUpdate : PlaygroundState -> msg
    }
    -> PlaygroundState
    -> H.Html msg
viewPlayground props state =
    let
        (Playground playground) =
            props.playground

        model : model
        model =
            toModel state props.playground
    in
    H.div
        [ HA.class "w--flex"
        , HA.class "w--border w--border-tint w--rounded"
        ]
        [ H.div
            [ HA.class "w--grow"
            , HA.class "w--bg w--border-r w--border-tint w--rounded-l w--p-lg"
            , HA.class "w--flex w--items-center w--justify-center"
            ]
            [ props.toHtml model
            ]
        , H.section
            [ HA.class "w--w-full w--max-w-xs" ]
            [ H.h1
                [ HA.class "w--uppercase w--text-xs w--tracking-widest w--text-subtle"
                , HA.class "w--border-b w--border-tint"
                , HA.class "w--px-lg w--py-sm"
                ]
                [ H.text "Playground" ]
            , H.ul
                [ HA.class "w--p-0" ]
                (playground.fields
                    |> List.reverse
                    |> List.map
                        (\field ->
                            let
                                fieldValue : PlaygroundFieldValue
                                fieldValue =
                                    getFieldValue field state
                            in
                            H.li
                                [ HA.class "w--flex w--items-center w--gap-lg"
                                , HA.class "w--grid w--grid-cols-5"
                                , HA.class "w--px-lg w--py-xs"
                                ]
                                [ H.div
                                    [ HA.class "w--col-span-2" ]
                                    [ H.p [ HA.class "w--text-sm" ] [ H.text field.name ]
                                    ]
                                , H.div
                                    [ HA.class "w--col-span-3" ]
                                    [ case fieldValue of
                                        FString value ->
                                            W.InputText.view [ W.InputText.small ]
                                                { value = value
                                                , onInput =
                                                    \v ->
                                                        updateField field.name (FString v) state
                                                }

                                        FFloat value ->
                                            W.InputFloat.view
                                                [ W.InputFloat.small ]
                                                { value = value
                                                , onInput =
                                                    \v ->
                                                        updateField field.name (FFloat v) state
                                                }

                                        FInt value ->
                                            W.InputInt.view
                                                [ W.InputInt.small ]
                                                { value = value
                                                , onInput =
                                                    \v ->
                                                        updateField field.name (FInt v) state
                                                }

                                        FBool value ->
                                            H.div
                                                [ HA.class "w--flex w--justify-end" ]
                                                [ W.InputCheckbox.view []
                                                    { value = value
                                                    , onInput =
                                                        \v ->
                                                            updateField field.name (FBool v) state
                                                    }
                                                ]

                                        FCustom value valuesList ->
                                            W.InputSelect.view [ W.InputSelect.small ]
                                                { value = value
                                                , options = valuesList
                                                , toLabel = identity
                                                , onInput =
                                                    \v ->
                                                        updateField field.name (FCustom v valuesList) state
                                                }
                                    ]
                                ]
                        )
                )
            ]
            |> H.map props.onUpdate
        ]

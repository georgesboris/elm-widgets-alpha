module W.InputCode exposing
    ( view, Attribute
    , hiddenCharacters, uppercase
    , id
    )

{-|

@docs view, Attribute


# Styles

@docs hiddenCharacters, uppercase


# Html

@docs id

-}

import Array exposing (Array)
import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , uppercase : Bool
    , hiddenCharacters : Bool
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , uppercase = False
    , hiddenCharacters = False
    , msg = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
uppercase : Attribute msg
uppercase =
    Attr.attr (\attrs -> { attrs | uppercase = True })


{-| -}
hiddenCharacters : Attribute msg
hiddenCharacters =
    Attr.attr (\attrs -> { attrs | hiddenCharacters = True })



-- Main


{-| -}
view :
    List (Attribute msg)
    ->
        { length : Int
        , value : String
        , onInput : String -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            if props.length <= 0 then
                H.div [] []

            else
                let
                    valueLetters : Array String
                    valueLetters =
                        props.value
                            |> String.split ""
                            |> List.take props.length
                            |> Array.fromList

                    activeIndex : Int
                    activeIndex =
                        Array.length valueLetters
                in
                H.label
                    [ HA.class "w--flex w--group/w" ]
                    [ H.input
                        [ HA.class "w--h-0 w--w-0 w--p-0 w--m-0 w--border-0 w--opacity-0 w--overflow-hidden"
                        , HA.value props.value
                        , HE.onFocus (props.onInput "")
                        , HE.onInput
                            (\v ->
                                let
                                    value : String
                                    value =
                                        String.left props.length v
                                in
                                if attrs.uppercase then
                                    value
                                        |> String.toUpper
                                        |> props.onInput

                                else
                                    value
                                        |> props.onInput
                            )
                        ]
                        []
                    , H.div
                        [ HA.class "w--flex w--gap-md" ]
                        ((props.length - 1)
                            |> List.range 0
                            |> List.map
                                (\index ->
                                    H.div
                                        [ HA.class "w--cfg-border"
                                        , HA.class "w--w-[2.5rem] w--h-[3.5rem] w--rounded-md"
                                        , HA.class "w--flex w--items-center w--justify-center"
                                        , HA.class "w--font-heading w--text-3xl w--text-default"
                                        , HA.classList
                                            [ ( "group-focus-within/w:w--border-accent-strong"
                                              , index == activeIndex
                                              )
                                            ]
                                        ]
                                        [ Array.get index valueLetters
                                            |> Maybe.map
                                                (\c ->
                                                    if attrs.hiddenCharacters then
                                                        "*"

                                                    else
                                                        c
                                                )
                                            |> Maybe.withDefault ""
                                            |> H.text
                                        ]
                                )
                        )
                    ]
        )

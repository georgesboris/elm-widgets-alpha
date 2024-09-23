module W.Tooltip exposing
    ( view, Attribute
    , bottom, left, right
    , fast, slow, alwaysVisible
    )

{-|

@docs view, Attribute


# Position

@docs bottom, left, right


# Styles

@docs fast, slow, alwaysVisible

-}

import Attr
import Html as H
import Html.Attributes as HA



-- Attributes


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { position : Position
    , speed : Speed
    , alwaysVisible : Bool
    }


type Position
    = Top
    | Left
    | Bottom
    | Right


type Speed
    = Slow
    | Default
    | Fast


defaultAttrs : Attributes
defaultAttrs =
    { position = Top
    , speed = Default
    , alwaysVisible = False
    }



-- Attributes : Setters


{-| -}
bottom : Attribute
bottom =
    Attr.attr (\attrs -> { attrs | position = Bottom })


{-| -}
left : Attribute
left =
    Attr.attr (\attrs -> { attrs | position = Left })


{-| -}
right : Attribute
right =
    Attr.attr (\attrs -> { attrs | position = Right })


{-| -}
slow : Attribute
slow =
    Attr.attr (\attrs -> { attrs | speed = Slow })


{-| -}
fast : Attribute
fast =
    Attr.attr (\attrs -> { attrs | speed = Fast })


{-| -}
alwaysVisible : Attribute
alwaysVisible =
    Attr.attr (\attrs -> { attrs | alwaysVisible = True })



-- Main


{-| -}
view :
    List Attribute
    ->
        { tooltip : List (H.Html msg)
        , children : List (H.Html msg)
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                posAttrs : List (H.Attribute msg)
                posAttrs =
                    case attrs.position of
                        Top ->
                            [ HA.class "w--tooltip-top w--bottom-full w--mb-1"
                            , HA.class "group-hover:w--translate-y-0"
                            , HA.classList [ ( "w--translate-y-0.5", not attrs.alwaysVisible ) ]
                            ]

                        Bottom ->
                            [ HA.class "w--tooltip-bottom w--top-full w--mt-1"
                            , HA.class "group-hover:w--translate-y-0"
                            , HA.classList [ ( "-w--translate-y-0.5", not attrs.alwaysVisible ) ]
                            ]

                        Left ->
                            [ HA.class "w--tooltip-left w--top-1/2 w--right-full w--mr-1"
                            , HA.class "-w--translate-y-1/2 group-hover:w--translate-x-0"
                            , HA.classList [ ( "w--translate-x-0.5", not attrs.alwaysVisible ) ]
                            ]

                        Right ->
                            [ HA.class "w--tooltip-right w--top-1/2 w--left-full w--ml-1"
                            , HA.class "-w--translate-y-1/2 group-hover:w--translate-x-0"
                            , HA.classList [ ( "-w--translate-x-0.5", not attrs.alwaysVisible ) ]
                            ]

                tooltip : H.Html msg
                tooltip =
                    H.span
                        (posAttrs
                            ++ [ HA.class "w/solid w--tooltip w--inline-block w--pointer-events-none"
                               , HA.class "w--font-base w--text-sm"

                               -- TODO: Control z-index through CSS vars
                               , HA.class "w--z-[9999] w--absolute w--px-sm w--py-xs"
                               , HA.class "w--w-max w--rounded"
                               , HA.class "w--transition"
                               , HA.class "group-hover:w--opacity-100"
                               , HA.classList [ ( "w--opacity-0", not attrs.alwaysVisible ) ]
                               , case attrs.speed of
                                    Fast ->
                                        HA.class "group-hover:w--delay-100"

                                    Default ->
                                        HA.class "group-hover:w--delay-500"

                                    Slow ->
                                        HA.class "group-hover:w--delay-1000"
                               ]
                        )
                        props.tooltip
            in
            H.span []
                [ H.span
                    [ HA.class "w--group w--relative w--inline-flex w--flex-col w--items-center" ]
                    (tooltip :: props.children)
                ]
        )

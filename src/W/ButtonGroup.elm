module W.ButtonGroup exposing
    ( view, viewOptional, viewMultiple, Attribute
    , viewLinks, viewButtons
    , full, small, large
    , subtle
    , rounded, radius
    , prefix, suffix
    )

{-|

@docs view, viewOptional, viewMultiple, Attribute
@docs viewLinks, viewButtons
@docs full, small, large
@docs subtle
@docs rounded, radius
@docs prefix, suffix

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Button
import W.Theme
import W.Theme.Radius



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , buttonAttrs : List (W.Button.Attribute msg)
    , buttonStyleAttr : W.Button.Attribute msg
    , radius : W.Theme.Radius.Radius
    , full : Bool
    , size : Size
    , style : Style
    , prefix : List (H.Html msg)
    , suffix : List (H.Html msg)
    }


type Size
    = Small
    | Medium
    | Large


type Style
    = Default
    | Subtle


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , size = Medium
    , style = Default
    , buttonAttrs = []
    , buttonStyleAttr = W.Button.invisible
    , radius = W.Theme.Radius.xl
    , full = False
    , prefix = []
    , suffix = []
    }


{-| -}
large : Attribute msg
large =
    Attr.attr (\a -> { a | size = Large })


{-| -}
small : Attribute msg
small =
    Attr.attr (\a -> { a | size = Small })


{-| -}
subtle : Attribute msg
subtle =
    Attr.attr (\a -> { a | style = Subtle, buttonStyleAttr = W.Button.subtle })


{-| -}
prefix : List (H.Html msg) -> Attribute msg
prefix v =
    Attr.attr (\a -> { a | prefix = v })


{-| -}
suffix : List (H.Html msg) -> Attribute msg
suffix v =
    Attr.attr (\a -> { a | suffix = v })


{-| -}
full : Attribute msg
full =
    Attr.attr
        (\a ->
            { a
                | full = True
                , buttonAttrs = W.Button.full :: a.buttonAttrs
            }
        )


{-| -}
rounded : Attribute msg
rounded =
    Attr.attr
        (\a ->
            { a
                | radius = W.Theme.Radius.full
                , buttonAttrs = W.Button.rounded :: a.buttonAttrs
            }
        )


{-| -}
radius : Float -> Attribute msg
radius v =
    Attr.attr
        (\a ->
            { a
                | radius = W.Theme.Radius.custom v
                , buttonAttrs = W.Button.radius v :: a.buttonAttrs
            }
        )



--


{-| -}
view :
    List (Attribute msg)
    ->
        { value : a
        , options : List a
        , toLabel : a -> List (H.Html msg)
        , onInput : a -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            props.options
                |> List.map
                    (\option ->
                        let
                            isActive : Bool
                            isActive =
                                props.value == option
                        in
                        { onClick = props.onInput option
                        , label = props.toLabel option
                        , attrs =
                            if isActive && attrs.style == Subtle then
                                [ W.Button.tint ]

                            else if isActive then
                                [ W.Button.default ]

                            else
                                []
                        }
                    )
                |> viewButtons_ attrs
        )


{-| -}
viewOptional :
    List (Attribute msg)
    ->
        { value : Maybe a
        , options : List a
        , toLabel : a -> List (H.Html msg)
        , onInput : Maybe a -> msg
        }
    -> H.Html msg
viewOptional =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            props.options
                |> List.map
                    (\option ->
                        let
                            isActive : Bool
                            isActive =
                                Just option == props.value
                        in
                        { onClick =
                            props.onInput
                                (if isActive then
                                    Nothing

                                 else
                                    Just option
                                )
                        , label = props.toLabel option
                        , attrs =
                            if isActive && attrs.style == Subtle then
                                [ W.Button.tint ]

                            else if isActive then
                                [ W.Button.default ]

                            else
                                []
                        }
                    )
                |> viewButtons_ attrs
        )


{-| -}
viewMultiple :
    List (Attribute msg)
    ->
        { value : List a
        , options : List a
        , toLabel : a -> List (H.Html msg)
        , onInput : List a -> msg
        }
    -> H.Html msg
viewMultiple =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            props.options
                |> List.map
                    (\option ->
                        let
                            isActive : Bool
                            isActive =
                                List.member option props.value
                        in
                        { onClick =
                            props.onInput
                                (if isActive then
                                    List.filter ((/=) option) props.value

                                 else
                                    option :: props.value
                                )
                        , label = props.toLabel option
                        , attrs =
                            if isActive && attrs.style == Subtle then
                                [ W.Button.tint ]

                            else if isActive then
                                [ W.Button.default ]

                            else
                                []
                        }
                    )
                |> viewButtons_ attrs
        )


{-| -}
viewLinks :
    List (Attribute msg)
    ->
        List
            { href : String
            , label : List (H.Html msg)
            , attrs : List (W.Button.Attribute msg)
            }
    -> H.Html msg
viewLinks =
    Attr.withAttrs defaultAttrs
        (\attrs items ->
            view_ attrs
                (items
                    |> List.map
                        (\item ->
                            W.Button.viewLink (buttonSizeAttr attrs.size :: attrs.buttonStyleAttr :: attrs.buttonAttrs ++ item.attrs)
                                { href = item.href
                                , label = item.label
                                }
                        )
                )
        )


{-| -}
viewButtons :
    List (Attribute msg)
    ->
        List
            { onClick : msg
            , label : List (H.Html msg)
            , attrs : List (W.Button.Attribute msg)
            }
    -> H.Html msg
viewButtons =
    Attr.withAttrs defaultAttrs viewButtons_


{-| -}
viewButtons_ :
    Attributes msg
    ->
        List
            { onClick : msg
            , label : List (H.Html msg)
            , attrs : List (W.Button.Attribute msg)
            }
    -> H.Html msg
viewButtons_ attrs items =
    view_ attrs
        (items
            |> List.map
                (\item ->
                    W.Button.view (buttonSizeAttr attrs.size :: attrs.buttonStyleAttr :: attrs.buttonAttrs ++ item.attrs)
                        { onClick = item.onClick
                        , label = item.label
                        }
                )
        )


buttonSizeAttr : Size -> W.Button.Attribute msg
buttonSizeAttr v =
    case v of
        Large ->
            Attr.none

        Medium ->
            W.Button.small

        Small ->
            W.Button.extraSmall


view_ :
    Attributes msg
    -> List (H.Html msg)
    -> H.Html msg
view_ attrs children =
    if List.isEmpty children then
        H.div [ HA.class "w__button-group w__m-empty" ] []

    else
        H.div
            [ HA.class "w__button-group"
            , HA.classList
                [ ( "w--w-full", attrs.full )
                , ( "w__m-small", attrs.size == Small )
                , ( "w__m-large", attrs.size == Large )
                , ( "w__m-subtle", attrs.style == Subtle )
                ]
            , W.Theme.styleList
                [ ( "border-radius", W.Theme.Radius.toCSS attrs.radius )
                ]
            ]
            [ if List.isEmpty attrs.prefix then
                H.text ""

              else
                H.div [ HA.class "w__button-group__aside" ] attrs.prefix
            , H.div [ HA.class "w__button-group__main" ] children
            , if List.isEmpty attrs.suffix then
                H.text ""

              else
                H.div [ HA.class "w__button-group__aside" ] attrs.suffix
            ]

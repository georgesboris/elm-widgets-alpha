module W.Modal exposing
    ( view, Attribute
    , viewToggle, viewTogglable
    , maxWidth, zIndex
    , background, backgroundOpacity, noBlur
    , absolute
    )

{-|

@docs view, Attribute


# Togglable

If you don't want to manage your modal open state at all, use the togglable version.

    W.Modal.viewTogglable []
        { id = "togglable-modal"
        , content = [ text "Hello!" ]
        }

    W.Modal.viewToggle "togglable-modal"
        [ W.Button.viewDummy []
            [ text "Click here to toggle modal" ]
        ]

@docs viewToggle, viewTogglable


# Styles

@docs maxWidth, zIndex
@docs background, backgroundOpacity, noBlur
@docs absolute

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Theme



-- Attributes


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { absolute : Bool
    , zIndex : Int
    , blur : Bool
    , background : String
    , backgroundOpacity : Float
    , maxWidth : Int
    }


defaultAttrs : Attributes
defaultAttrs =
    { absolute = False
    , zIndex = 1000
    , blur = True
    , background = "black"
    , backgroundOpacity = 0.3
    , maxWidth = 480
    }


{-| -}
absolute : Attribute
absolute =
    Attr.attr (\attrs -> { attrs | absolute = True })


{-| -}
background : String -> Attribute
background v =
    Attr.attr (\attrs -> { attrs | background = v })


{-| -}
backgroundOpacity : Float -> Attribute
backgroundOpacity v =
    Attr.attr (\attrs -> { attrs | backgroundOpacity = v })


{-| -}
noBlur : Attribute
noBlur =
    Attr.attr (\attrs -> { attrs | blur = False })


{-| -}
maxWidth : Int -> Attribute
maxWidth v =
    Attr.attr (\attrs -> { attrs | maxWidth = v })


{-| -}
zIndex : Int -> Attribute
zIndex v =
    Attr.attr (\attrs -> { attrs | zIndex = v })



-- Main


type Modal msg
    = Stateless
        { id : String
        , content : List (H.Html msg)
        }
    | Stateful
        { isOpen : Bool
        , onClose : Maybe msg
        , content : List (H.Html msg)
        }


toContent : Modal msg -> List (H.Html msg)
toContent modal =
    case modal of
        Stateless { content } ->
            content

        Stateful { content } ->
            content


toClosable : Modal msg -> Bool
toClosable modal =
    case modal of
        Stateless _ ->
            True

        Stateful { onClose } ->
            onClose /= Nothing


{-| -}
viewToggle : String -> List (H.Html msg) -> H.Html msg
viewToggle id_ content =
    H.label [ HA.for id_ ] content


{-| -}
viewTogglable :
    List Attribute
    ->
        { id : String
        , content : List (H.Html msg)
        }
    -> H.Html msg
viewTogglable attrs props =
    view_ attrs
        (Stateless
            { id = props.id
            , content = props.content
            }
        )


{-| -}
view :
    List Attribute
    ->
        { isOpen : Bool
        , onClose : Maybe msg
        , content : List (H.Html msg)
        }
    -> H.Html msg
view attrs props =
    view_ attrs (Stateful props)


{-| -}
view_ : List Attribute -> Modal msg -> H.Html msg
view_ =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                viewCloseTrigger : H.Html msg
                viewCloseTrigger =
                    case props of
                        Stateless { id } ->
                            H.label
                                [ HA.for id
                                , HA.class "w--block"
                                , HA.class "w--absolute w--inset-0"
                                ]
                                []

                        Stateful { onClose } ->
                            case onClose of
                                Just onClose_ ->
                                    H.label
                                        [ HE.onClick onClose_
                                        , HA.class "w--absolute w--inset-0"
                                        ]
                                        []

                                Nothing ->
                                    H.text ""

                wrapper : H.Html msg
                wrapper =
                    H.div
                        [ HA.attribute "role" "dialog"
                        , HA.class "w--modal w--hidden w--opacity-0 w--inset-0 w--border-0"
                        , HA.classList
                            [ ( "w__m-blur", attrs.blur )
                            , ( "w--absolute", attrs.absolute )
                            , ( "w--fixed", not attrs.absolute )
                            , ( "w--modal--is-open"
                              , case props of
                                    Stateful { isOpen } ->
                                        isOpen

                                    _ ->
                                        False
                              )
                            ]
                        , W.Theme.styleList
                            [ ( "--w_bg", attrs.background )
                            , ( "--w_bg-opacity", WH.pct attrs.backgroundOpacity )
                            , ( "z-index", String.fromInt attrs.zIndex )
                            ]
                        ]
                        [ viewCloseTrigger
                        , H.div
                            [ -- Visibility and animations are handled by this class
                              HA.class "w--modal-content"
                            , HA.class "w--flex w--absolute w--inset-0"
                            , HA.classList [ ( "w--pointer-events-none", toClosable props ) ]
                            , HA.style "overflow-y" "auto"
                            ]
                            [ H.div
                                [ HA.class "w--relative w--overflow-visible"
                                , HA.class "w--m-auto w--max-w-full w--p-4"
                                , HA.style "width" (String.fromInt attrs.maxWidth ++ "px")
                                ]
                                [ H.div
                                    [ HA.class "w/base w--bg"
                                    , HA.class "w--relative w--overflow-visible w--pointer-events-auto"
                                    , HA.class "w--w-full w--shadow-lg w--rounded-lg"
                                    ]
                                    (toContent props)
                                ]
                            ]
                        ]
            in
            case props of
                Stateless { id } ->
                    H.div []
                        [ H.node
                            "input"
                            [ HA.id id
                            , HA.type_ "checkbox"
                            , HA.class "w--hidden w--modal-toggle"
                            ]
                            []
                        , wrapper
                        ]

                _ ->
                    wrapper
        )

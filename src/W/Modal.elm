module W.Modal exposing
    ( view, Attribute
    , viewToggle, viewTogglable
    , absolute, maxWidth, noBlur, zIndex
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

@docs absolute, maxWidth, noBlur, zIndex

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Theme



-- Attributes


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { absolute : Bool
    , zIndex : Int
    , blur : Bool
    , maxWidth : Int
    }


defaultAttrs : Attributes
defaultAttrs =
    { absolute = False
    , zIndex = 1000
    , blur = True
    , maxWidth = 480
    }


{-| -}
absolute : Attribute
absolute =
    Attr.attr (\attrs -> { attrs | absolute = True })


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
                        , HA.class "w--modal w--hidden w--opacity-0 w--inset-0 w--border-0 w--bg-black/30"
                        , HA.style "z-index" (String.fromInt attrs.zIndex)
                        , HA.classList
                            [ ( "w--absolute", attrs.absolute )
                            , ( "w--fixed", not attrs.absolute )
                            , ( "w--modal--is-open"
                              , case props of
                                    Stateful { isOpen } ->
                                        isOpen

                                    _ ->
                                        False
                              )
                            ]
                        , if attrs.blur then
                            HA.style "backdrop-filter" "blur(1px)"

                          else
                            HA.class ""
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
                                    [ HA.class "w/base"
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

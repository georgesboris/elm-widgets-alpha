module W.Popover exposing
    ( view, viewControlled, Attribute
    , showOnHover, persistent
    , top, topRight, bottomRight, left, leftBottom, right, rightBottom
    , over, offset, full, width, minWidth
    )

{-|

@docs view, viewControlled, Attribute


# Behavior

@docs showOnHover, persistent


# Position

@docs top, topRight, bottomRight, left, leftBottom, right, rightBottom


# Styles

@docs over, offset, full, width, minWidth

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Theme



-- Placement


{-| -}
type Position
    = TopLeft
    | TopRight
    | LeftTop
    | LeftBottom
    | RightTop
    | RightBottom
    | BottomLeft
    | BottomRight



-- Attributes


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { position : Position
    , offset : Float
    , full : Bool
    , over : Bool
    , persistent : Bool
    , isOpen : Maybe Bool
    , widthAttr : ( String, String )
    , showOnHover : Bool
    }


defaultAttrs : Attributes
defaultAttrs =
    { position = BottomLeft
    , offset = 0
    , full = False
    , over = False
    , persistent = False
    , isOpen = Nothing
    , widthAttr = ( "width", "auto" )
    , showOnHover = False
    }



-- Attributes : Setters


{-| -}
offset : Float -> Attribute
offset v =
    Attr.attr (\attrs -> { attrs | offset = v })


{-| -}
bottomRight : Attribute
bottomRight =
    Attr.attr (\attrs -> { attrs | position = BottomRight })


{-| -}
top : Attribute
top =
    Attr.attr (\attrs -> { attrs | position = TopLeft })


{-| -}
topRight : Attribute
topRight =
    Attr.attr (\attrs -> { attrs | position = TopRight })


{-| -}
left : Attribute
left =
    Attr.attr (\attrs -> { attrs | position = LeftTop })


{-| -}
leftBottom : Attribute
leftBottom =
    Attr.attr (\attrs -> { attrs | position = LeftBottom })


{-| -}
right : Attribute
right =
    Attr.attr (\attrs -> { attrs | position = RightTop })


{-| -}
rightBottom : Attribute
rightBottom =
    Attr.attr (\attrs -> { attrs | position = RightBottom })


{-| -}
over : Attribute
over =
    Attr.attr (\attrs -> { attrs | over = True })


{-| -}
persistent : Attribute
persistent =
    Attr.attr (\attrs -> { attrs | persistent = True })


isOpen : Bool -> Attribute
isOpen v =
    Attr.attr (\attrs -> { attrs | isOpen = Just v })


{-| -}
full : Bool -> Attribute
full v =
    Attr.attr (\attrs -> { attrs | full = v })


{-| -}
width : Int -> Attribute
width v =
    Attr.attr (\attrs -> { attrs | widthAttr = ( "width", String.fromInt v ++ "px" ) })


{-| -}
minWidth : Int -> Attribute
minWidth v =
    Attr.attr (\attrs -> { attrs | widthAttr = ( "min-width", String.fromInt v ++ "px" ) })


{-| -}
showOnHover : Attribute
showOnHover =
    Attr.attr (\attrs -> { attrs | showOnHover = True })



-- Main


{-| -}
view :
    List Attribute
    ->
        { content : List (H.Html msg)
        , trigger : List (H.Html msg)
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            view_ attrs
                { content = props.content
                , children = props.trigger
                }
        )


{-| -}
viewControlled :
    List Attribute
    ->
        { isOpen : Bool
        , content : List (H.Html msg)
        , trigger : List (H.Html msg)
        }
    -> H.Html msg
viewControlled =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            view_ { attrs | isOpen = Just props.isOpen }
                { content = props.content
                , children = props.trigger
                }
        )


view_ :
    Attributes
    ->
        { content : List (H.Html msg)
        , children : List (H.Html msg)
        }
    -> H.Html msg
view_ attrs props =
    let
        offsetPx : String
        offsetPx =
            if attrs.over then
                "0"

            else
                String.fromFloat attrs.offset ++ "px"

        offsetValue : String
        offsetValue =
            "100%"

        offsetIfOver : String
        offsetIfOver =
            if attrs.over then
                "0"

            else
                offsetValue

        crossAnchor : String -> H.Attribute msg
        crossAnchor x =
            if attrs.full then
                HA.style x "0"

            else
                HA.style x "auto"

        positionAttrs : List (H.Attribute msg)
        positionAttrs =
            case attrs.position of
                TopLeft ->
                    [ HA.style "left" "0"
                    , HA.style "bottom" offsetIfOver
                    , HA.style "padding-bottom" offsetPx
                    , crossAnchor "right"
                    ]

                TopRight ->
                    [ HA.style "right" "0"
                    , HA.style "bottom" offsetIfOver
                    , HA.style "padding-bottom" offsetPx
                    , crossAnchor "left"
                    ]

                BottomLeft ->
                    [ HA.style "left" "0"
                    , HA.style "top" offsetIfOver
                    , HA.style "padding-top" offsetPx
                    , crossAnchor "right"
                    ]

                BottomRight ->
                    [ HA.style "right" "0"
                    , HA.style "top" offsetIfOver
                    , HA.style "padding-top" offsetPx
                    , crossAnchor "left"
                    ]

                LeftTop ->
                    [ HA.style "right" offsetValue
                    , HA.style "top" "0"
                    , HA.style "padding-right" offsetPx
                    ]

                LeftBottom ->
                    [ HA.style "right" offsetValue
                    , HA.style "bottom" "0"
                    , HA.style "padding-right" offsetPx
                    ]

                RightTop ->
                    [ HA.style "left" offsetValue
                    , HA.style "top" "0"
                    , HA.style "padding-left" offsetPx
                    ]

                RightBottom ->
                    [ HA.style "left" offsetValue
                    , HA.style "bottom" "0"
                    , HA.style "padding-left" offsetPx
                    ]
    in
    H.div
        [ HA.class "w--popover w--inline-flex w--relative"
        , case attrs.isOpen of
            Just isOpen_ ->
                HA.classList
                    [ ( "w--is-open", isOpen_ )
                    , ( "w--is-closed", not isOpen_ )
                    ]

            Nothing ->
                HA.classList
                    [ ( "w--show-on-hover", attrs.showOnHover )
                    , ( "w--persistent", attrs.persistent )
                    ]
        ]
        [ H.div [ HA.class "w--popover-trigger w--w-full" ] props.children
        , H.div
            (positionAttrs
                ++ [ HA.class "w--popover-content w--absolute w--z-[9999] w--shrink-0"
                   , HA.classList [ ( "w--min-w-full", attrs.over ) ]
                   ]
            )
            [ H.div
                [ W.Theme.styleList [ attrs.widthAttr ]
                , HA.class "w--overflow-visible"
                , HA.class "w--bg-bg w--rounded-sm"
                , HA.class "w--border-solid w--border w--border-tint-subtle"
                , HA.class "w--shadow-lg"
                ]
                props.content
            ]
        ]

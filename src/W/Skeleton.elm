module W.Skeleton exposing
    ( view
    , subtle, strong, width, height, relativeWidth, relativeHeight
    , radius, circle, noAnimation
    , Attribute
    )

{-|

@docs view


# Sizing

@docs subtle, strong, width, height, relativeWidth, relativeHeight


# Styles

@docs radius, circle, noAnimation

@docs Attribute

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { colorClass : String
    , borderRadius : String
    , height : String
    , width : String
    , useAnimation : Bool
    }


defaultAttrs : Attributes
defaultAttrs =
    { colorClass = "w--bg-tint"
    , borderRadius = "4px"
    , height = "16px"
    , width = "auto"
    , useAnimation = True
    }



-- Attributes : Setters


{-| Adjusts the background color for backgrounds like `bg-subtle`.
-}
subtle : Attribute
subtle =
    Attr.attr (\attrs -> { attrs | colorClass = "w--bg-tint-subtle" })


{-| Adjusts the background color for backgrounds like `tint`.
-}
strong : Attribute
strong =
    Attr.attr (\attrs -> { attrs | colorClass = "w--bg-accent-subtle" })


{-| Sets the height of the skeleton element in "rem".
-}
height : Float -> Attribute
height v =
    Attr.attr (\attrs -> { attrs | height = WH.rem v })


{-| Sets the width of the skeleton element in "rem".
-}
width : Float -> Attribute
width v =
    Attr.attr (\attrs -> { attrs | width = WH.rem v })


{-| Sets the height of the skeleton element as a percentage of its parent element.
-}
relativeHeight : Float -> Attribute
relativeHeight v =
    Attr.attr (\attrs -> { attrs | height = WH.pct v })


{-| Sets the width of the skeleton element as a percentage of its parent element.
-}
relativeWidth : Float -> Attribute
relativeWidth v =
    Attr.attr (\attrs -> { attrs | width = WH.pct v })


{-| Sets the border radius of the skeleton element in "rem".
-}
radius : Float -> Attribute
radius v =
    Attr.attr (\attrs -> { attrs | borderRadius = WH.rem v })


{-| Makes the skeleton element a circle with the specified size in "rem".
-}
circle : Float -> Attribute
circle size =
    Attr.attr
        (\attrs ->
            { attrs
                | borderRadius = "100%"
                , width = WH.rem size
                , height = WH.rem size
            }
        )


{-| Disables the animation of the skeleton element.
-}
noAnimation : Attribute
noAnimation =
    Attr.attr (\attrs -> { attrs | useAnimation = False })



-- Main


{-|

    -- skeleton with default size
    W.Skeleton.view [] []

    -- skeleton with custom size
    W.Skeleton.view [ W.Skeleton.width 100, W.Skeleton.height 100 ] []

    -- skeleton with custom size and no animation
    W.Skeleton.view [ W.Skeleton.width 100, W.Skeleton.height 100, W.Skeleton.noAnimation ] []

-}
view : List Attribute -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs ->
            H.div
                [ HA.style "border-radius" attrs.borderRadius
                , HA.style "width" attrs.width
                , HA.style "height" attrs.height
                , HA.class attrs.colorClass
                , HA.classList [ ( "w--animate-pulse", attrs.useAnimation ) ]
                ]
                []
        )

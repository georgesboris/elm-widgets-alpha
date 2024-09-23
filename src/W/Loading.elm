module W.Loading exposing
    ( view
    , circles, ripples
    , color, size
    , Attribute
    )

{-|

@docs view


## Variations

@docs circles, ripples


## Styles

@docs color, size


## Html

@docs Attribute

-}

import Attr
import Html as H
import Html.Attributes as HA
import Svg as S
import Svg.Attributes as SA
import W.Internal.Helpers as WH
import W.Theme



-- Attrs


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { variant : Variant
    , size : Float
    , color : String
    }


type Variant
    = Dots
    | Circles
    | Ripples


defaultAttrs : Attributes
defaultAttrs =
    { variant = Dots
    , size = 25
    , color = W.Theme.color.accent
    }



-- Attrs : Setters


{-| -}
circles : Attribute
circles =
    Attr.attr (\attrs -> { attrs | variant = Circles })


{-| -}
ripples : Attribute
ripples =
    Attr.attr (\attrs -> { attrs | variant = Ripples })


{-| -}
size : Float -> Attribute
size v =
    Attr.attr (\attrs -> { attrs | size = v })


{-| -}
color : String -> Attribute
color v =
    Attr.attr (\attrs -> { attrs | color = v })



-- Main


{-| -}
view : List Attribute -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs ->
            case attrs.variant of
                Dots ->
                    viewDots attrs

                Circles ->
                    viewCircles attrs

                Ripples ->
                    viewRipples attrs
        )


{-| -}
viewCircles : Attributes -> S.Svg msg
viewCircles attrs =
    S.svg
        [ SA.style ("--color: " ++ attrs.color)
        , SA.class "w--loading-circle"
        , SA.viewBox "0 0 40 40"
        , SA.height (String.fromFloat attrs.size ++ "px")
        , SA.width (String.fromFloat attrs.size ++ "px")
        , SA.xmlSpace "preserve"
        ]
        [ S.path
            [ SA.fill "var(--color)"
            , SA.opacity "0.2"
            , SA.d "M20.201,5.169c-8.254,0-14.946,6.692-14.946,14.946c0,8.255,6.692,14.946,14.946,14.946 s14.946-6.691,14.946-14.946C35.146,11.861,28.455,5.169,20.201,5.169z M20.201,31.749c-6.425,0-11.634-5.208-11.634-11.634 c0-6.425,5.209-11.634,11.634-11.634c6.425,0,11.633,5.209,11.633,11.634C31.834,26.541,26.626,31.749,20.201,31.749z"
            ]
            []
        , S.path
            [ SA.fill "var(--color)"
            , SA.d "M26.013,10.047l1.654-2.866c-2.198-1.272-4.743-2.012-7.466-2.012h0v3.312h0 C22.32,8.481,24.301,9.057,26.013,10.047z"
            ]
            [ S.animateTransform
                [ SA.attributeType "xml"
                , SA.attributeName "transform"
                , SA.type_ "rotate"
                , SA.from "0 20 20"
                , SA.to "360 20 20"
                , SA.dur "1.2s"
                , SA.repeatCount "indefinite"
                ]
                []
            ]
        ]


{-| -}
viewDots : Attributes -> H.Html msg
viewDots attrs =
    H.div
        [ HA.class "w--loading-dots"
        , WH.styles
            [ ( "--color", attrs.color )
            , ( "--size", String.fromFloat attrs.size ++ "px" )
            ]
        ]
        [ H.div [] []
        , H.div [] []
        , H.div [] []
        , H.div [] []
        ]


{-| -}
viewRipples : Attributes -> H.Html msg
viewRipples attrs =
    H.div
        [ HA.class "w--loading-ripples"
        , WH.styles
            [ ( "--size", String.fromFloat attrs.size ++ "px" )
            , ( "--color", attrs.color )
            ]
        ]
        [ H.div [] []
        , H.div [] []
        ]

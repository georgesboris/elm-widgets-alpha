module W.Message exposing
    ( view, Attribute
    , icon, footer
    , variant, noBorder, borderWidth
    , href, onClick
    , id
    )

{-|

@docs view, Attribute


# Content

@docs icon, footer


# Styles

@docs variant, noBorder, borderWidth


# Actions

@docs href, onClick


# Html

@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Theme



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , icon : Maybe (List (H.Html msg))
    , footer : Maybe (List (H.Html msg))
    , variant : W.Theme.ColorVariant
    , background : String
    , color : String
    , href : Maybe String
    , onClick : Maybe msg
    , borderWidth : Int
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , icon = Nothing
    , footer = Nothing
    , variant = W.Theme.base
    , background = W.Theme.color.tint
    , color = W.Theme.color.text
    , href = Nothing
    , onClick = Nothing
    , borderWidth = 6
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
onClick : msg -> Attribute msg
onClick v =
    Attr.attr (\attrs -> { attrs | onClick = Just v })


{-| -}
href : String -> Attribute msg
href v =
    Attr.attr (\attrs -> { attrs | href = Just v })


{-| -}
icon : List (H.Html msg) -> Attribute msg
icon v =
    Attr.attr (\attrs -> { attrs | icon = Just v })


{-| -}
footer : List (H.Html msg) -> Attribute msg
footer v =
    Attr.attr (\attrs -> { attrs | footer = Just v })


{-| -}
variant : W.Theme.ColorVariant -> Attribute msg
variant v =
    Attr.attr (\attrs -> { attrs | variant = v })


{-| -}
borderWidth : Int -> Attribute msg
borderWidth v =
    Attr.attr (\attrs -> { attrs | borderWidth = v })


{-| -}
noBorder : Attribute msg
noBorder =
    Attr.attr (\attrs -> { attrs | borderWidth = 0 })



-- Main


{-| -}
view :
    List (Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children_ ->
            let
                baseAttrs : List (H.Attribute msg)
                baseAttrs =
                    [ WH.maybeAttr HA.id attrs.id
                    , W.Theme.variant attrs.variant
                    , HA.class "w/tint"
                    , HA.class "w--m-0 w--box-border w--relative"
                    , HA.class "w--flex w--gap-md w--w-full"
                    , HA.class "w--font-base w--text-base w--text-text w--font-medium"
                    , HA.class "w--py-sm w--px-md w--pr-6"
                    , HA.class "w--rounded"
                    , HA.class "w--border-0 w--border-solid w--border-accent"
                    , W.Theme.styleList
                        [ ( "border-left-width", WH.px attrs.borderWidth )
                        , ( "background", attrs.background )
                        , ( "color", attrs.color )
                        ]
                    ]

                children : List (H.Html msg)
                children =
                    [ WH.maybeHtml (\i -> H.div [] i) attrs.icon
                    , H.div [ HA.class "w--flex w--flex-col" ]
                        [ H.div [] children_
                        , WH.maybeHtml (H.div [ HA.class "w--text-sm w--font-normal w--text-subtle" ]) attrs.footer
                        ]
                    ]
            in
            case ( attrs.onClick, attrs.href ) of
                ( Just onClick_, _ ) ->
                    H.button
                        (baseAttrs ++ [ interactiveClass, HE.onClick onClick_ ])
                        children

                ( Nothing, Just href_ ) ->
                    H.a
                        (baseAttrs ++ [ interactiveClass, HA.href href_ ])
                        children

                _ ->
                    H.div baseAttrs children
        )


interactiveClass : H.Attribute msg
interactiveClass =
    HA.class
        ("w--appearance-none w--no-underline w--focusable-outline"
            ++ " hover:w--bg-tint-strong active:w--bg-tint-subtle"
        )

module W.Tag exposing
    ( view, viewButton, viewLink, Attribute
    , large, small
    , primary, secondary, success, warning, danger, color
    , id
    )

{-|

@docs view, viewButton, viewLink, Attribute


# Sizes

@docs large, small


# Colors

@docs primary, secondary, success, warning, danger, color


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
    , theme : String
    , customTheme : Maybe { text : String, background : String }
    , size : Size
    , href : Maybe String
    , onClick : Maybe msg
    }


type Size
    = Large
    | Medium
    | Small


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , theme = "w/base"
    , customTheme = Nothing
    , size = Medium
    , href = Nothing
    , onClick = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | size = Small })


{-| -}
large : Attribute msg
large =
    Attr.attr (\attrs -> { attrs | size = Large })


onClick : msg -> Attribute msg
onClick v =
    Attr.attr (\attrs -> { attrs | onClick = Just v })


{-| -}
href : String -> Attribute msg
href v =
    Attr.attr (\attrs -> { attrs | href = Just v })


{-| -}
color : { text : String, background : String } -> Attribute msg
color v =
    Attr.attr (\attrs -> { attrs | customTheme = Just v })


{-| -}
primary : Attribute msg
primary =
    Attr.attr (\attrs -> { attrs | theme = "w/primary" })


{-| -}
secondary : Attribute msg
secondary =
    Attr.attr (\attrs -> { attrs | theme = "w/secondary" })


{-| -}
success : Attribute msg
success =
    Attr.attr (\attrs -> { attrs | theme = "w/success" })


{-| -}
warning : Attribute msg
warning =
    Attr.attr (\attrs -> { attrs | theme = "w/warning" })


{-| -}
danger : Attribute msg
danger =
    Attr.attr (\attrs -> { attrs | theme = "w/danger" })



-- Main


{-| -}
viewButton : List (Attribute msg) -> { onClick : msg, label : List (H.Html msg) } -> H.Html msg
viewButton attrs_ props =
    view (onClick props.onClick :: attrs_) props.label


{-| -}
viewLink : List (Attribute msg) -> { href : String, label : List (H.Html msg) } -> H.Html msg
viewLink attrs_ props =
    view (href props.href :: attrs_) props.label


{-| -}
view :
    List (Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            let
                baseAttrs : List (H.Attribute msg)
                baseAttrs =
                    [ WH.maybeAttr HA.id attrs.id
                    , HA.class "w--tag"
                    , HA.class "w/tint"
                    , HA.class "w--m-0 w--box-border w--relative w--inline-flex w--items-center w--leading-none w--font-base w--font-medium w--tracking-wider"
                    , HA.class "w--rounded-full w--border-0"
                    , WH.maybeAttr
                        (\_ -> HA.class "w--tag--custom-theme")
                        attrs.customTheme
                    , case attrs.customTheme of
                        Nothing ->
                            HA.class attrs.theme

                        Just theme ->
                            W.Theme.styleList
                                [ ( "--fg", theme.text )
                                , ( "--bg", theme.background )
                                ]
                    , case attrs.size of
                        Large ->
                            HA.class "w--h-[32px] w--px-lg w--text-base"

                        Medium ->
                            HA.class "w--h-[28px] w--px-md w--text-sm"

                        Small ->
                            HA.class "w--h-[20px] w--px-sm w--text-xs"
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
                    H.span baseAttrs children
        )


interactiveClass : H.Attribute msg
interactiveClass =
    HA.class
        ("w--appearance-none w--bg-transparent w--no-underline"
            ++ " w--transition"
            ++ " w--outline-0 w--ring-offset-0 w--ring-primary-fg/50"
            ++ " focus-visible:w--bg-base-bg focus-visible:w--ring"
        )

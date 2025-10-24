module W.Tag exposing
    ( view, viewButton, viewLink, Attribute
    , large, small
    , solid, outline
    , compact
    , primary, secondary, success, warning, danger, color
    , id
    )

{-|

@docs view, viewButton, viewLink, Attribute


# Sizes

@docs large, small


# Styles

@docs solid, outline


# Shapes

@docs compact


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
    , styleClass : String
    , customTheme : Maybe { text : String, background : String }
    , compact : Bool
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
    , styleClass = "w/tint"
    , customTheme = Nothing
    , compact = False
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
compact : Attribute msg
compact =
    Attr.attr (\attrs -> { attrs | compact = True })


{-| -}
solid : Attribute msg
solid =
    Attr.attr (\attrs -> { attrs | styleClass = "w/solid" })


{-| -}
outline : Attribute msg
outline =
    Attr.attr (\attrs -> { attrs | styleClass = "w__m-outline w/tint w--border w--border-solid w--border-accent" })


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
                rootAttrs : List (H.Attribute msg)
                rootAttrs =
                    [ WH.maybeAttr HA.id attrs.id
                    , HA.class "w__tag"
                    , HA.classList
                        [ ( "w__m-compact", attrs.compact ) ]
                    , case attrs.size of
                        Large ->
                            HA.class "w__m-lg"

                        Medium ->
                            HA.class ""

                        Small ->
                            HA.class "w__m-sm"
                    ]

                themeAttrs : List (H.Attribute msg)
                themeAttrs =
                    case attrs.customTheme of
                        Nothing ->
                            [ HA.class attrs.theme
                            , HA.class attrs.styleClass
                            ]

                        Just theme ->
                            [ HA.class "w__m-custom-theme"
                            , W.Theme.styleList
                                [ ( "--fg", theme.text )
                                , ( "--bg", theme.background )
                                ]
                            ]

                baseAttrs : List (H.Attribute msg)
                baseAttrs =
                    rootAttrs ++ themeAttrs
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

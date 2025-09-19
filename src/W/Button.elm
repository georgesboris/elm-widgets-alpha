module W.Button exposing
    ( view, viewLink, viewSubmit, viewDummy, Attribute
    , base, primary, secondary, success, warning, danger
    , outline, invisible, tint, subtle
    , rounded, radius
    , full, icon
    , disabled
    , large, small, extraSmall
    , alignLeft, alignRight
    , id
    )

{-|

@docs view, viewLink, viewSubmit, viewDummy, Attribute

@docs base, primary, secondary, success, warning, danger
@docs outline, invisible, tint, subtle

@docs rounded, radius
@docs full, icon

@docs disabled
@docs large, small, extraSmall
@docs alignLeft, alignRight

@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Theme
import W.Theme.Color



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , style : ButtonStyle
    , disabled : Bool
    , radius : Maybe String
    , size : ButtonSize
    , icon : Bool
    , full : Bool
    , variant : ButtonVariant
    , alignClass : String
    , msg : Maybe msg
    }


type ButtonStyle
    = Basic
    | Outline
    | Tint
    | Invisible
    | Subtle


type ButtonSize
    = ExtraSmall
    | Small
    | Medium
    | Large


type ButtonVariant
    = Inherit
    | Base
    | Primary
    | Secondary
    | Success
    | Warning
    | Danger


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , style = Basic
    , variant = Inherit
    , disabled = False
    , radius = Nothing
    , size = Medium
    , icon = False
    , full = False
    , alignClass = "w--justify-center"
    , msg = Nothing
    }



-- Attrs : State


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })



-- Attrs : Colors


{-| -}
base : Attribute msg
base =
    Attr.attr (\attrs -> { attrs | variant = Base })


{-| -}
primary : Attribute msg
primary =
    Attr.attr (\attrs -> { attrs | variant = Primary })


{-| -}
secondary : Attribute msg
secondary =
    Attr.attr (\attrs -> { attrs | variant = Secondary })


{-| -}
success : Attribute msg
success =
    Attr.attr (\attrs -> { attrs | variant = Success })


{-| -}
warning : Attribute msg
warning =
    Attr.attr (\attrs -> { attrs | variant = Warning })


{-| -}
danger : Attribute msg
danger =
    Attr.attr (\attrs -> { attrs | variant = Danger })



-- Attrs : Styles


{-| -}
outline : Attribute msg
outline =
    Attr.attr (\attrs -> { attrs | style = Outline })


{-| -}
tint : Attribute msg
tint =
    Attr.attr (\attrs -> { attrs | style = Tint })


{-| -}
invisible : Attribute msg
invisible =
    Attr.attr (\attrs -> { attrs | style = Invisible })


{-| -}
subtle : Attribute msg
subtle =
    Attr.attr (\attrs -> { attrs | style = Subtle })



-- Attrs : Radius


{-| -}
rounded : Attribute msg
rounded =
    Attr.attr (\attrs -> { attrs | radius = Just "999px" })


{-| -}
radius : Float -> Attribute msg
radius v =
    Attr.attr (\attrs -> { attrs | radius = Just (WH.rem v) })



-- Attrs : Alignment


{-| -}
alignLeft : Attribute msg
alignLeft =
    Attr.attr (\attrs -> { attrs | alignClass = "w--justify-start w--text-left" })


{-| -}
alignRight : Attribute msg
alignRight =
    Attr.attr (\attrs -> { attrs | alignClass = "w--justify-end w--text-right" })



-- Attrs : Size


{-| -}
extraSmall : Attribute msg
extraSmall =
    Attr.attr (\attrs -> { attrs | size = ExtraSmall })


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | size = Small })


{-| -}
large : Attribute msg
large =
    Attr.attr (\attrs -> { attrs | size = Large })



-- Attrs : Size


{-| -}
full : Attribute msg
full =
    Attr.attr (\attrs -> { attrs | full = True })


{-| -}
icon : Attribute msg
icon =
    Attr.attr (\attrs -> { attrs | icon = True })



-- Views


{-| -}
view :
    List (Attribute msg)
    ->
        { label : List (H.Html msg)
        , onClick : msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.button
                (HE.onClick props.onClick :: HA.type_ "button" :: htmlAttrs attrs)
                (toLabel attrs props.label)
        )


{-| -}
viewSubmit :
    List (Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
viewSubmit =
    Attr.withAttrs defaultAttrs
        (\attrs label ->
            H.button
                (HA.type_ "submit" :: htmlAttrs attrs)
                (toLabel attrs label)
        )


{-| -}
viewDummy :
    List (Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
viewDummy =
    Attr.withAttrs defaultAttrs
        (\attrs label ->
            H.div
                (HA.attribute "role" "button" :: HA.tabindex 0 :: htmlAttrs attrs)
                (toLabel attrs label)
        )


{-| -}
viewLink :
    List (Attribute msg)
    ->
        { label : List (H.Html msg)
        , href : String
        }
    -> H.Html msg
viewLink =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.a
                (HA.href props.href :: htmlAttrs attrs)
                (toLabel attrs props.label)
        )



-- Views : Helpers


toLabel : Attributes msg -> List (H.Html msg) -> List (H.Html msg)
toLabel attrs children =
    [ H.div
        [ HA.class "w--flex w--items-center"
        , case attrs.style of
            Subtle ->
                HA.class "w--text-subtle group-hover/btn:w--text-default group-active/btn:w--text-subtle"

            _ ->
                HA.class ""
        ]
        children
    ]


htmlAttrs : Attributes msg -> List (H.Attribute msg)
htmlAttrs attrs =
    let
        styles : List ( String, String )
        styles =
            List.concat
                [ case attrs.size of
                    ExtraSmall ->
                        [ ( "min-height", "1.5rem" )
                        , ( "min-width", "1.5rem" )
                        ]

                    Small ->
                        [ ( "min-height", "2rem" )
                        , ( "min-width", "2rem" )
                        ]

                    Medium ->
                        [ ( "min-height", "2.5rem" )
                        , ( "min-width", "2.5rem" )
                        ]

                    Large ->
                        [ ( "min-height", "3rem" )
                        , ( "min-width", "3rem" )
                        ]
                , case attrs.radius of
                    Just v ->
                        [ ( "border-radius", v ) ]

                    Nothing ->
                        [ ( "border-radius", "0.5em" ) ]
                , if attrs.disabled then
                    [ ( "color", W.Theme.Color.textSubtle ) ]

                  else
                    []
                ]
    in
    [ WH.maybeAttr HA.id attrs.id
    , HA.class "w__button"
    , HA.class "w--group/btn"
    , HA.class "w--box-border w--relative"
    , HA.class "w--inline-flex w--items-center "
    , HA.class "w--no-underline"
    , HA.class "w--font-semibold"
    , HA.class "w--border-2 w--border-solid"
    , HA.class attrs.alignClass
    , HA.classList
        [ ( "w--w-full", attrs.full )
        , ( "w--cursor-pointer", not attrs.disabled )
        , ( "w--pointer-events-none w--opacity-50", attrs.disabled )
        ]
    , HA.disabled attrs.disabled
    , W.Theme.styleList styles

    -- Font Size
    , case attrs.size of
        ExtraSmall ->
            HA.class "w--text-xs w--tracking-wider w--gap-xs"

        Small ->
            HA.class "w--text-sm w--tracking-wider w--gap-sm"

        _ ->
            HA.class "w--text-base w--tracking-wide w--gap-sm"

    -- Spacing
    , if attrs.icon then
        HA.class ""

      else
        case attrs.size of
            ExtraSmall ->
                HA.class "w--py-xs w--px-sm"

            Small ->
                HA.class "w--py-xs w--px-md"

            Medium ->
                HA.class "w--py-sm w--px-lg"

            Large ->
                HA.class "w--py-sm w--px-xl"

    -- Variants
    , case attrs.variant of
        Inherit ->
            HA.class "w/inherit"

        Base ->
            HA.class "w/base"

        Primary ->
            HA.class "w/primary"

        Secondary ->
            HA.class "w/secondary"

        Success ->
            HA.class "w/success"

        Warning ->
            HA.class "w/warning"

        Danger ->
            HA.class "w/danger"

    -- Styles
    , case attrs.style of
        Basic ->
            HA.class "w/solid w--border-transparent"

        Outline ->
            HA.class
                ("w/focus "
                    ++ " w--border-accent hover:w--border-accent-strong active:w--border-accent-subtle"
                    ++ " w--bg hover:w--bg-tint-subtle active:w--bg-subtle"
                )

        Tint ->
            HA.class "w/tint w--border-transparent"

        _ ->
            HA.class
                ("w/focus w--border-transparent w--bg-transparent"
                    ++ " hover:w--bg-tint active:w--bg-tint-subtle"
                )
    ]

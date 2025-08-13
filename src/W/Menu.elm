module W.Menu exposing
    ( view, Attribute
    , viewButton, viewLink, viewDummy, viewHeading, viewSection, ItemAttribute
    , id, disabled, selected, faded, left, right
    , flat, small
    , uppercaseHeadings
    , padding, paddingX, paddingY
    , margin, marginX, marginY
    , radius
    )

{-|

@docs view, Attribute
@docs viewButton, viewLink, viewDummy, viewHeading, viewSection, ItemAttribute


# Item Attributes

@docs id, disabled, selected, faded, left, right


# Menu Attributes

@docs flat, small
@docs uppercaseHeadings
@docs padding, paddingX, paddingY
@docs margin, marginX, marginY
@docs radius

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Theme
import W.Theme.Radius
import W.Theme.Spacing



-- Menu Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { small : Bool
    , uppercaseHeadings : Bool
    , paddingX : W.Theme.Spacing.Spacing
    , paddingY : W.Theme.Spacing.Spacing
    , marginX : W.Theme.Spacing.Spacing
    , marginY : W.Theme.Spacing.Spacing
    , radius : W.Theme.Radius.Radius
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { small = False
    , uppercaseHeadings = False
    , paddingX = W.Theme.Spacing.md
    , paddingY = W.Theme.Spacing.sm
    , marginX = W.Theme.Spacing.sm
    , marginY = W.Theme.Spacing.sm
    , radius = W.Theme.Radius.md
    , msg = Nothing
    }



-- Menu Attribute functions


{-| -}
flat : Attribute msg
flat =
    Attr.attr
        (\attrs ->
            { attrs
                | marginX = W.Theme.Spacing.none
                , marginY = W.Theme.Spacing.none
                , radius = W.Theme.Radius.none
            }
        )


{-| -}
uppercaseHeadings : Attribute msg
uppercaseHeadings =
    Attr.attr (\attrs -> { attrs | uppercaseHeadings = True })


{-| -}
small : Attribute msg
small =
    Attr.attr
        (\attrs ->
            { attrs
                | small = True
                , paddingX = W.Theme.Spacing.sm
                , paddingY = W.Theme.Spacing.sm
                , marginX = W.Theme.Spacing.xs
                , marginY = W.Theme.Spacing.xs
            }
        )


{-| -}
padding : W.Theme.Spacing.Spacing -> Attribute msg
padding v =
    Attr.attr (\attrs -> { attrs | paddingX = v, paddingY = v })


{-| -}
paddingX : W.Theme.Spacing.Spacing -> Attribute msg
paddingX v =
    Attr.attr (\attrs -> { attrs | paddingX = v })


{-| -}
paddingY : W.Theme.Spacing.Spacing -> Attribute msg
paddingY v =
    Attr.attr (\attrs -> { attrs | paddingY = v })


{-| -}
margin : W.Theme.Spacing.Spacing -> Attribute msg
margin v =
    Attr.attr (\attrs -> { attrs | marginX = v, marginY = v })


{-| -}
marginX : W.Theme.Spacing.Spacing -> Attribute msg
marginX v =
    Attr.attr (\attrs -> { attrs | marginX = v })


{-| -}
marginY : W.Theme.Spacing.Spacing -> Attribute msg
marginY v =
    Attr.attr (\attrs -> { attrs | marginY = v })


{-| -}
radius : W.Theme.Radius.Radius -> Attribute msg
radius v =
    Attr.attr (\attrs -> { attrs | radius = v })



-- Attributes


{-| -}
type alias ItemAttribute msg =
    Attr.Attr (ItemAttributes msg)


type alias ItemAttributes msg =
    { id : Maybe String
    , faded : Bool
    , disabled : Bool
    , selected : Bool
    , left : Maybe (List (H.Html msg))
    , right : Maybe (List (H.Html msg))
    }


defaultItemAttrs : ItemAttributes msg
defaultItemAttrs =
    { id = Nothing
    , faded = False
    , disabled = False
    , selected = False
    , left = Nothing
    , right = Nothing
    }



-- Attribute functions


{-| -}
id : String -> ItemAttribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
disabled : ItemAttribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })


{-| -}
faded : ItemAttribute msg
faded =
    Attr.attr (\attrs -> { attrs | faded = True })


{-| -}
selected : ItemAttribute msg
selected =
    Attr.attr (\attrs -> { attrs | selected = True })


{-| -}
left : List (H.Html msg) -> ItemAttribute msg
left v =
    Attr.attr (\attrs -> { attrs | left = Just v })


{-| -}
right : List (H.Html msg) -> ItemAttribute msg
right v =
    Attr.attr (\attrs -> { attrs | right = Just v })



-- View


{-| -}
view : List (Attribute msg) -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            H.div
                [ HA.attribute "role" "menu"
                , HA.class "w__menu"
                , HA.class "w--bg w--font-base"
                , HA.classList
                    [ ( "w__m-small", attrs.small )
                    , ( "w__m-upper", attrs.uppercaseHeadings )
                    ]
                , W.Theme.styleList
                    [ ( "--w-menu-margin-x", W.Theme.Spacing.toCSS attrs.marginX )
                    , ( "--w-menu-margin-y", W.Theme.Spacing.toCSS attrs.marginY )
                    , ( "--w-menu-padding-x", W.Theme.Spacing.toCSS attrs.paddingX )
                    , ( "--w-menu-padding-y", W.Theme.Spacing.toCSS attrs.paddingY )
                    , ( "--w-menu-radius", W.Theme.Radius.toCSS attrs.radius )
                    ]
                ]
                children
        )


{-| -}
viewSection :
    List (ItemAttribute msg)
    ->
        { heading : List (H.Html msg)
        , content : List (H.Html msg)
        }
    -> H.Html msg
viewSection attrs props =
    H.section
        [ HA.class "w__menu__section" ]
        [ viewHeading attrs props.heading
        , H.div [ HA.class "w__menu" ] props.content
        ]


{-| -}
viewHeading :
    List (ItemAttribute msg)
    -> List (H.Html msg)
    -> H.Html msg
viewHeading =
    Attr.withAttrs defaultItemAttrs
        (\attrs children ->
            H.p
                [ HA.class "w__menu__heading"
                , HA.class "w--flex w--items-center w--m-0"
                , HA.class "w--font-semibold w--tracking-wide w--font-text w--text-subtle"
                ]
                (baseContent attrs children)
        )


{-| -}
viewDummy :
    List (ItemAttribute msg)
    -> List (H.Html msg)
    -> H.Html msg
viewDummy =
    Attr.withAttrs defaultItemAttrs
        (\attrs label ->
            H.div
                (baseAttrs attrs
                    ++ [ HA.tabindex 0
                       , HA.attribute "role" "button"
                       ]
                )
                (baseContent attrs label)
        )


{-| -}
viewButton :
    List (ItemAttribute msg)
    ->
        { label : List (H.Html msg)
        , onClick : msg
        }
    -> H.Html msg
viewButton =
    Attr.withAttrs defaultItemAttrs
        (\attrs props ->
            H.button
                (baseAttrs attrs
                    ++ [ HE.onClick props.onClick
                       , HA.class "w--appearance-none w--border-0"
                       ]
                )
                (baseContent attrs props.label)
        )


{-| -}
viewLink :
    List (ItemAttribute msg)
    ->
        { label : List (H.Html msg)
        , href : String
        }
    -> H.Html msg
viewLink =
    Attr.withAttrs defaultItemAttrs
        (\attrs props ->
            H.a
                ([ HA.href props.href
                 , HA.class "w--no-underline"
                 ]
                    ++ baseAttrs attrs
                )
                (baseContent attrs props.label)
        )


baseAttrs : ItemAttributes msg -> List (H.Attribute msg)
baseAttrs attrs =
    [ WH.maybeAttr HA.id attrs.id
    , HA.disabled attrs.disabled
    , HA.class "w__menu__item"
    , HA.class "w/focus w--appearance-none"
    , HA.class "w--flex w--items-center w--content-start"
    , HA.class "w--text-default"
    , HA.class "w--text-left w--text-fg"
    , HA.class "w--relative focus:w--z-10"
    , HA.classList
        [ ( "w--bg hover:w--bg-tint-subtle focus-visible:w--bg-tint-subtle active:w--bg", not attrs.selected && not attrs.disabled )
        , ( "w--text-subtle", attrs.disabled || (attrs.faded && not attrs.selected) )
        , ( "w--bg-tint-subtle w--cursor-not-allowed", attrs.disabled )
        , ( "w--bg-tint hover:w--bg-tint-strong focus-visible:w--bg-tint-strong active:w--bg-tint-subtle", attrs.selected )
        ]
    ]


baseContent : ItemAttributes msg -> List (H.Html msg) -> List (H.Html msg)
baseContent attrs label =
    [ WH.maybeHtml (H.span [ HA.class "w--shrink-0" ]) attrs.left
    , H.span [ HA.class "w--grow" ] label
    , WH.maybeHtml (H.span [ HA.class "w--shrink-0" ]) attrs.right
    ]

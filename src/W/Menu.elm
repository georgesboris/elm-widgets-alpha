module W.Menu exposing
    ( view, Attribute
    , viewButton, viewLink, viewDummy, viewHeading, viewSection, ItemAttribute
    , id, disabled, selected, faded, left, right, noPadding
    , padding, paddingX, paddingY, titlePadding, titlePaddingX, titlePaddingY
    )

{-|

@docs view, Attribute
@docs viewButton, viewLink, viewDummy, viewHeading, viewSection, ItemAttribute


# Styles

@docs id, disabled, selected, faded, left, right, noPadding


# Container Styles

@docs padding, paddingX, paddingY, titlePadding, titlePaddingX, titlePaddingY

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH
import W.Theme



-- Menu Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { titlePadding : { x : Int, y : Int }
    , padding : { x : Int, y : Int }
    , msg : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { titlePadding = { x = 12, y = 8 }
    , padding = { x = 12, y = 8 }
    , msg = Nothing
    }



-- Menu Attribute functions


{-| -}
padding : Int -> Attribute msg
padding v =
    Attr.attr (\attrs -> { attrs | padding = { x = v, y = v } })


{-| -}
paddingX : Int -> Attribute msg
paddingX v =
    Attr.attr (\attrs -> { attrs | padding = { x = v, y = attrs.padding.y } })


{-| -}
paddingY : Int -> Attribute msg
paddingY v =
    Attr.attr (\attrs -> { attrs | padding = { y = v, x = attrs.padding.x } })


{-| -}
titlePadding : Int -> Attribute msg
titlePadding v =
    Attr.attr (\attrs -> { attrs | titlePadding = { x = v, y = v } })


{-| -}
titlePaddingX : Int -> Attribute msg
titlePaddingX v =
    Attr.attr (\attrs -> { attrs | titlePadding = { x = v, y = attrs.titlePadding.y } })


{-| -}
titlePaddingY : Int -> Attribute msg
titlePaddingY v =
    Attr.attr (\attrs -> { attrs | titlePadding = { y = v, x = attrs.titlePadding.x } })



-- Attributes


{-| -}
type alias ItemAttribute msg =
    Attr.Attr (ItemAttributes msg)


type alias ItemAttributes msg =
    { id : Maybe String
    , faded : Bool
    , disabled : Bool
    , selected : Bool
    , padding : Bool
    , left : Maybe (List (H.Html msg))
    , right : Maybe (List (H.Html msg))
    }


defaultItemAttrs : ItemAttributes msg
defaultItemAttrs =
    { id = Nothing
    , faded = False
    , disabled = False
    , selected = False
    , padding = True
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


{-| -}
noPadding : ItemAttribute msg
noPadding =
    Attr.attr (\attrs -> { attrs | padding = False })



-- View


{-| -}
view : List (Attribute msg) -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            H.ul
                [ HA.class "w--list-none w--p-0"
                , HA.class "w--font-base"
                , W.Theme.styleList
                    [ ( "--w--menu-padding", paddingString attrs.padding )
                    , ( "--w--menu-title-padding", paddingString attrs.titlePadding )
                    ]
                ]
                children
        )


paddingString : { x : Int, y : Int } -> String
paddingString { x, y } =
    String.fromInt y ++ "px " ++ String.fromInt x ++ "px"


{-| -}
viewSection :
    List (ItemAttribute msg)
    ->
        { heading : List (H.Html msg)
        , content : List (H.Html msg)
        }
    -> H.Html msg
viewSection =
    Attr.withAttrs defaultItemAttrs
        (\attrs props ->
            H.section
                [ HA.class "w--menu-section" ]
                [ H.p
                    [ HA.class "w--m-0 w--flex w--items-center"
                    , HA.class "w--uppercase w--text-xs w--font-bold w--font-text w--text-subtle"
                    , if attrs.padding then
                        W.Theme.styleList [ ( "padding", "var(--w--menu-title-padding)" ) ]

                      else
                        HA.class ""
                    ]
                    (baseContent attrs props.heading)
                , H.ul [ HA.class "w--list-style-none w--p-0" ] props.content
                ]
        )


{-| -}
viewHeading :
    List (ItemAttribute msg)
    -> List (H.Html msg)
    -> H.Html msg
viewHeading =
    Attr.withAttrs defaultItemAttrs
        (\attrs children ->
            H.p
                [ HA.class "w--m-0 w--flex w--items-center"
                , HA.class "w--uppercase w--text-xs w--font-bold w--font-text w--text-subtle"
                , if attrs.padding then
                    W.Theme.styleList [ ( "padding", "var(--w--menu-title-padding)" ) ]

                  else
                    HA.class ""
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
                    ++ [ HA.class "w--border-0 w--focusable"
                       , HA.tabindex 0
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
                       , HA.class "w--border-0"
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
                (HA.href props.href :: baseAttrs attrs)
                (baseContent attrs props.label)
        )


baseAttrs : ItemAttributes msg -> List (H.Attribute msg)
baseAttrs attrs =
    [ WH.maybeAttr HA.id attrs.id
    , HA.disabled attrs.disabled
    , HA.class "w/focus"
    , HA.class "w--m-0 w--w-full w--box-border w--flex w--items-center w--content-start"
    , HA.class "w--no-underline w--text-default"
    , HA.class "w--text-left w--text-base w--text-fg"
    , HA.class "hover:w--bg-tint-strong focus-visible:w--bg-tint-subtle active:w--bg-tint-subtle"
    , HA.class "w--focusable-reset w--relative focus:w--z-10"
    , if attrs.disabled then
        HA.class "w--text-subtle w--pointer-events-none w--cursor-not-allowed"

      else if attrs.selected then
        HA.class "w--text-default w--bg-tint"

      else if attrs.faded then
        HA.class "w--text-subtle"

      else
        HA.class ""
    , if attrs.padding then
        W.Theme.styleList [ ( "padding", "var(--w--menu-padding)" ) ]

      else
        HA.class ""
    ]


baseContent : ItemAttributes msg -> List (H.Html msg) -> List (H.Html msg)
baseContent attrs label =
    [ WH.maybeHtml (H.span [ HA.class "w--shrink-0 w--pr-3" ]) attrs.left
    , H.span [ HA.class "w--grow" ] label
    , WH.maybeHtml (H.span [ HA.class "w--shrink-0 w--pr-3" ]) attrs.right
    ]

module W.Table exposing
    ( view, Attribute
    , column, string, int, float, bool, Column, ColumnAttribute
    , customLabel, labelClass, labelLeft, labelRight
    , groupLabel, footer
    , alignRight, alignCenter
    , colBorders
    , width, relativeWidth, minWidth
    , colGroupAlignTop, colGroupAlignBottom
    , colHeaderAlignTop, colHeaderAlignBottom
    , mediumContainerOnly, largeContainerOnly
    , largeScreenOnly
    , onClick, onMouseEnter, onMouseLeave
    , groupBy, groupValue, groupValueCustom
    , groupSortBy, groupSortByDesc, groupSortWith
    , groupCollapsed
    , groupAlignTop, groupAlignBottom
    , groupIndent, groupIndentCustom, groupIndentWidth
    , onGroupClick, onGroupMouseEnter, onGroupMouseLeave
    , highlight, maxHeight
    , noHeader, labelBaseClass
    , headerAlignTop, headerAlignBottom
    , subtle, card, borders, striped, noDividers, noHeaderBackground
    , extraHeader, extraHeaderNoPadding, extraHeaderNoDivider
    , rowDetails, rowDetailsNoPadding
    , xPadding, yPadding
    , yHeaderPadding, yFooterPadding
    , yGroupPadding, topGroupPadding
    )

{-|

@docs view, Attribute


# Columns

@docs column, string, int, float, bool, Column, ColumnAttribute


# Column Attributes

@docs customLabel, labelClass, labelLeft, labelRight
@docs groupLabel, footer
@docs alignRight, alignCenter
@docs colBorders
@docs width, relativeWidth, minWidth
@docs colGroupAlignTop, colGroupAlignBottom
@docs colHeaderAlignTop, colHeaderAlignBottom
@docs mediumContainerOnly, largeContainerOnly
@docs largeScreenOnly


# Actions

@docs onClick, onMouseEnter, onMouseLeave


# Groups

@docs groupBy, groupValue, groupValueCustom
@docs groupSortBy, groupSortByDesc, groupSortWith
@docs groupCollapsed
@docs groupAlignTop, groupAlignBottom
@docs groupIndent, groupIndentCustom, groupIndentWidth
@docs onGroupClick, onGroupMouseEnter, onGroupMouseLeave


# Table Attributes

@docs highlight, maxHeight
@docs noHeader, labelBaseClass
@docs headerAlignTop, headerAlignBottom
@docs subtle, card, borders, striped, noDividers, noHeaderBackground
@docs extraHeader, extraHeaderNoPadding, extraHeaderNoDivider
@docs rowDetails, rowDetailsNoPadding
@docs xPadding, yPadding
@docs yHeaderPadding, yFooterPadding
@docs yGroupPadding, topGroupPadding

-}

import Attr
import Dict
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.InputCheckbox
import W.Internal.Helpers as WH
import W.Theme
import W.Theme.Spacing



-- Table Attributes


{-| -}
type alias Attribute msg a =
    Attr.Attr (Attributes msg a)


type alias Attributes msg a =
    { card : Bool
    , showHeader : Bool
    , headerBackground : Bool
    , headerAlignClass : Maybe String
    , groupAlignClass : Maybe String
    , isStriped : Bool
    , withBorders : Bool
    , withDividers : Bool
    , maxHeight : Maybe Float
    , labelBaseClass : String
    , theme : TableTheme
    , extraHeader : Maybe (List (H.Html msg))
    , extraHeaderNoPadding : Bool
    , extraHeaderNoDivider : Bool
    , xPadding : W.Theme.Spacing.Spacing
    , yPadding : W.Theme.Spacing.Spacing
    , yHeaderPadding : Maybe W.Theme.Spacing.Spacing
    , yFooterPadding : Maybe W.Theme.Spacing.Spacing
    , yGroupPadding : Maybe W.Theme.Spacing.Spacing
    , topGroupPadding : Maybe W.Theme.Spacing.Spacing
    , groupBy : Maybe (a -> String)
    , groupSortBy : List ( String, a, List a ) -> List ( String, a, List a )
    , groupCollapsed : Maybe (a -> String -> Bool)
    , groupIndent : Maybe (a -> H.Html msg)
    , groupIndentWidth : Float
    , highlight : a -> Bool
    , rowDetails : Maybe (a -> Maybe (List (H.Html msg)))
    , rowDetailsNoPadding : Bool
    , onClick : Maybe (a -> msg)
    , onMouseEnter : Maybe (a -> msg)
    , onMouseLeave : Maybe msg
    , onGroupClick : Maybe (a -> msg)
    , onGroupMouseEnter : Maybe (a -> msg)
    , onGroupMouseLeave : Maybe msg
    }


defaultAttrs : Attributes msg a
defaultAttrs =
    { card = False
    , showHeader = True
    , headerBackground = True
    , headerAlignClass = Nothing
    , groupAlignClass = Nothing
    , isStriped = False
    , withBorders = False
    , withDividers = True
    , maxHeight = Nothing
    , labelBaseClass = ""
    , theme = Default
    , extraHeader = Nothing
    , extraHeaderNoPadding = False
    , extraHeaderNoDivider = False
    , xPadding = W.Theme.Spacing.sm
    , yPadding = W.Theme.Spacing.sm
    , yHeaderPadding = Nothing
    , yFooterPadding = Nothing
    , yGroupPadding = Nothing
    , topGroupPadding = Nothing
    , groupBy = Nothing
    , groupSortBy = identity
    , groupCollapsed = Nothing
    , groupIndent = Nothing
    , groupIndentWidth = 0.5
    , highlight = \_ -> False
    , rowDetails = Nothing
    , rowDetailsNoPadding = False
    , onClick = Nothing
    , onMouseEnter = Nothing
    , onMouseLeave = Nothing
    , onGroupClick = Nothing
    , onGroupMouseEnter = Nothing
    , onGroupMouseLeave = Nothing
    }


type TableTheme
    = Default
    | Subtle



-- Table Attributes


{-| -}
card : Attribute msg a
card =
    Attr.attr (\attrs -> { attrs | card = True })


{-| -}
noHeader : Attribute msg a
noHeader =
    Attr.attr (\attrs -> { attrs | showHeader = False })


{-| -}
noHeaderBackground : Attribute msg a
noHeaderBackground =
    Attr.attr (\attrs -> { attrs | headerBackground = False })


{-| -}
subtle : Attribute msg a
subtle =
    Attr.attr (\attrs -> { attrs | theme = Subtle })


{-| -}
noDividers : Attribute msg a
noDividers =
    Attr.attr (\attrs -> { attrs | withDividers = False })


{-| -}
labelBaseClass : String -> Attribute msg a
labelBaseClass v =
    Attr.attr (\attrs -> { attrs | labelBaseClass = v })


{-| -}
extraHeader : List (H.Html msg) -> Attribute msg a
extraHeader v =
    Attr.attr (\attrs -> { attrs | extraHeader = Just v })


{-| -}
extraHeaderNoPadding : Attribute msg a
extraHeaderNoPadding =
    Attr.attr (\attrs -> { attrs | extraHeaderNoPadding = True })


{-| -}
extraHeaderNoDivider : Attribute msg a
extraHeaderNoDivider =
    Attr.attr (\attrs -> { attrs | extraHeaderNoDivider = True })


{-| -}
rowDetails : (a -> Maybe (List (H.Html msg))) -> Attribute msg a
rowDetails v =
    Attr.attr (\attrs -> { attrs | rowDetails = Just v })


{-| -}
rowDetailsNoPadding : Attribute msg a
rowDetailsNoPadding =
    Attr.attr (\attrs -> { attrs | rowDetailsNoPadding = True })


{-| -}
striped : Attribute msg a
striped =
    Attr.attr (\attrs -> { attrs | isStriped = True })


{-| -}
borders : Attribute msg a
borders =
    Attr.attr (\attrs -> { attrs | withBorders = True })


{-| -}
headerAlignBottom : Attribute msg a
headerAlignBottom =
    Attr.attr (\attrs -> { attrs | headerAlignClass = Just "w--align-bottom" })


{-| -}
headerAlignTop : Attribute msg a
headerAlignTop =
    Attr.attr (\attrs -> { attrs | headerAlignClass = Just "w--align-top" })


{-| -}
groupAlignBottom : Attribute msg a
groupAlignBottom =
    Attr.attr (\attrs -> { attrs | groupAlignClass = Just "w--align-bottom" })


{-| -}
groupAlignTop : Attribute msg a
groupAlignTop =
    Attr.attr (\attrs -> { attrs | groupAlignClass = Just "w--align-top" })


{-| -}
footer : (List a -> H.Html msg) -> ColumnAttribute msg a
footer v =
    Attr.attr (\attrs -> { attrs | toFooter = Just v })


{-| Max height in "rem".
-}
maxHeight : Float -> Attribute msg a
maxHeight v =
    Attr.attr (\attrs -> { attrs | maxHeight = Just v })


{-| -}
xPadding : W.Theme.Spacing.Spacing -> Attribute msg a
xPadding v =
    Attr.attr (\attrs -> { attrs | xPadding = v })


{-| -}
yPadding : W.Theme.Spacing.Spacing -> Attribute msg a
yPadding v =
    Attr.attr (\attrs -> { attrs | yPadding = v })


{-| -}
yHeaderPadding : W.Theme.Spacing.Spacing -> Attribute msg a
yHeaderPadding v =
    Attr.attr (\attrs -> { attrs | yHeaderPadding = Just v })


{-| -}
yFooterPadding : W.Theme.Spacing.Spacing -> Attribute msg a
yFooterPadding v =
    Attr.attr (\attrs -> { attrs | yFooterPadding = Just v })


{-| -}
yGroupPadding : W.Theme.Spacing.Spacing -> Attribute msg a
yGroupPadding v =
    Attr.attr (\attrs -> { attrs | yGroupPadding = Just v })


{-| -}
topGroupPadding : W.Theme.Spacing.Spacing -> Attribute msg a
topGroupPadding v =
    Attr.attr (\attrs -> { attrs | topGroupPadding = Just v })


paddingStyles : Attributes msg a -> List ( String, String )
paddingStyles attrs =
    let
        yGroupPadding_ : W.Theme.Spacing.Spacing
        yGroupPadding_ =
            attrs.yGroupPadding
                |> Maybe.withDefault attrs.yPadding
    in
    [ ( "--padding-x", W.Theme.Spacing.toCSS attrs.xPadding )
    , ( "--padding-y", W.Theme.Spacing.toCSS attrs.yPadding )
    , ( "--header-padding-y"
      , attrs.yHeaderPadding
            |> Maybe.withDefault attrs.yPadding
            |> W.Theme.Spacing.toCSS
      )
    , ( "--footer-padding-y"
      , attrs.yFooterPadding
            |> Maybe.withDefault attrs.yPadding
            |> W.Theme.Spacing.toCSS
      )
    , ( "--group-padding-y"
      , W.Theme.Spacing.toCSS yGroupPadding_
      )
    , ( "--group-padding-top"
      , attrs.topGroupPadding
            |> Maybe.withDefault yGroupPadding_
            |> W.Theme.Spacing.toCSS
      )
    , ( "--group-indent-width"
      , attrs.groupIndentWidth
            |> WH.em
      )
    ]



-- Grouping


{-| -}
groupBy : (a -> String) -> Attribute msg a
groupBy v =
    Attr.attr (\attrs -> { attrs | groupBy = Just v })


{-| -}
groupSortBy : (a -> String -> comparable) -> Attribute msg a
groupSortBy fn =
    Attr.attr (\attrs -> { attrs | groupSortBy = List.sortBy (\( l, a, _ ) -> fn a l) })


{-| -}
groupSortByDesc : (a -> String -> comparable) -> Attribute msg a
groupSortByDesc fn =
    groupSortWith
        (\( labelA, a, _ ) ( labelB, b, _ ) ->
            case Basics.compare (fn a labelA) (fn b labelB) of
                LT ->
                    GT

                EQ ->
                    EQ

                GT ->
                    LT
        )


{-| -}
groupSortWith : (( String, a, List a ) -> ( String, a, List a ) -> Order) -> Attribute msg a
groupSortWith fn =
    Attr.attr (\attrs -> { attrs | groupSortBy = List.sortWith fn })


{-| -}
groupCollapsed : (a -> String -> Bool) -> Attribute msg a
groupCollapsed fn =
    Attr.attr (\attrs -> { attrs | groupCollapsed = Just fn })


{-| -}
groupIndent : Attribute msg a
groupIndent =
    Attr.attr (\attrs -> { attrs | groupIndent = Just (\_ -> H.div [ HA.class "w__table__group-indent__default" ] []) })


{-| -}
groupIndentWidth : Float -> Attribute msg a
groupIndentWidth v =
    Attr.attr (\attrs -> { attrs | groupIndentWidth = v })


{-| -}
groupIndentCustom : (a -> H.Html msg) -> Attribute msg a
groupIndentCustom fn =
    Attr.attr (\attrs -> { attrs | groupIndent = Just fn })


{-| -}
highlight : (a -> Bool) -> Attribute msg a
highlight v =
    Attr.attr (\attrs -> { attrs | highlight = v })


{-| -}
onClick : (a -> msg) -> Attribute msg a
onClick v =
    Attr.attr (\attrs -> { attrs | onClick = Just v })


{-| -}
onMouseEnter : (a -> msg) -> Attribute msg a
onMouseEnter v =
    Attr.attr (\attrs -> { attrs | onMouseEnter = Just v })


{-| -}
onMouseLeave : msg -> Attribute msg a
onMouseLeave v =
    Attr.attr (\attrs -> { attrs | onMouseLeave = Just v })


{-| -}
onGroupClick : (a -> msg) -> Attribute msg a
onGroupClick v =
    Attr.attr (\attrs -> { attrs | onGroupClick = Just v })


{-| -}
onGroupMouseEnter : (a -> msg) -> Attribute msg a
onGroupMouseEnter v =
    Attr.attr (\attrs -> { attrs | onGroupMouseEnter = Just v })


{-| -}
onGroupMouseLeave : msg -> Attribute msg a
onGroupMouseLeave v =
    Attr.attr (\attrs -> { attrs | onGroupMouseLeave = Just v })



-- Column Attributes


{-| -}
type Column msg a
    = Column (ColumnAttributes msg a)


{-| -}
type alias ColumnAttribute msg a =
    Attr.Attr (ColumnAttributes msg a)


type alias ColumnAttributes msg a =
    { label : String
    , labelClass : String
    , headerAlignClass : Maybe String
    , groupAlignClass : Maybe String
    , withBorders : Bool
    , customLabel : Maybe (List (H.Html msg))
    , customLeft : Maybe (List (H.Html msg))
    , customRight : Maybe (List (H.Html msg))
    , alignment : H.Attribute msg
    , width : H.Attribute msg
    , minWidth : Maybe Int
    , mediumContainerOnly : Bool
    , largeContainerOnly : Bool
    , largeScreenOnly : Bool
    , toHtml : a -> H.Html msg
    , toGroup : Maybe (String -> a -> List a -> H.Html msg)
    , toFooter : Maybe (List a -> H.Html msg)
    }


column_ : ColumnAttributes msg a -> List (ColumnAttribute msg a) -> Column msg a
column_ default attrs =
    Column (Attr.toAttrs default attrs)


columnAttrs : String -> (a -> H.Html msg) -> ColumnAttributes msg a
columnAttrs label toHtml =
    { label = label
    , labelClass = ""
    , headerAlignClass = Nothing
    , groupAlignClass = Nothing
    , withBorders = False
    , customLabel = Nothing
    , customLeft = Nothing
    , customRight = Nothing
    , alignment = HA.class "w--text-left"
    , width = HA.class ""
    , minWidth = Just 160
    , mediumContainerOnly = False
    , largeContainerOnly = False
    , largeScreenOnly = False
    , toHtml = toHtml
    , toGroup = Nothing
    , toFooter = Nothing
    }


columnStyles : ColumnAttributes msg a -> List (H.Attribute msg)
columnStyles attrs =
    [ attrs.alignment
    , attrs.width
    , attrs.minWidth
        |> WH.maybeAttr (\v -> HA.style "min-width" (WH.px v))
    , HA.classList
        [ ( "w--hidden lg:w--table-cell", attrs.largeScreenOnly )
        , ( "w--lg-only", attrs.largeContainerOnly )
        , ( "w--md-only", attrs.mediumContainerOnly )
        , ( "w__m-borders", attrs.withBorders )
        ]
    ]


{-| Pass in extra classes for a column label.
This can be useful for when you want to conditionally hide sorting icons unless the user is hovering a table header.

An example using tailwindcss:

    W.Table.string
        [ W.Table.labelClass "group"
        , W.Table.labelRight
            [ div
                [ class "opacity-0 group-hover:opacity-100" ]
                [ .. ]
            ]
        ]
        { .. }

-}
labelClass : String -> ColumnAttribute msg a
labelClass value =
    Attr.attr (\attrs -> { attrs | labelClass = value })


{-| -}
customLabel : List (H.Html msg) -> ColumnAttribute msg a
customLabel value =
    Attr.attr (\attrs -> { attrs | customLabel = Just value })


{-| -}
labelRight : List (H.Html msg) -> ColumnAttribute msg a
labelRight value =
    Attr.attr (\attrs -> { attrs | customRight = Just value })


{-| -}
labelLeft : List (H.Html msg) -> ColumnAttribute msg a
labelLeft value =
    Attr.attr (\attrs -> { attrs | customLeft = Just value })


{-| -}
colBorders : ColumnAttribute msg a
colBorders =
    Attr.attr (\attrs -> { attrs | withBorders = True })


{-| -}
colHeaderAlignBottom : ColumnAttribute msg a
colHeaderAlignBottom =
    Attr.attr (\attrs -> { attrs | headerAlignClass = Just "w--align-bottom" })


{-| -}
colHeaderAlignTop : ColumnAttribute msg a
colHeaderAlignTop =
    Attr.attr (\attrs -> { attrs | headerAlignClass = Just "w--align-top" })


{-| -}
colGroupAlignBottom : ColumnAttribute msg a
colGroupAlignBottom =
    Attr.attr (\attrs -> { attrs | groupAlignClass = Just "w--align-bottom" })


{-| -}
colGroupAlignTop : ColumnAttribute msg a
colGroupAlignTop =
    Attr.attr (\attrs -> { attrs | groupAlignClass = Just "w--align-top" })


{-| -}
alignRight : ColumnAttribute msg a
alignRight =
    Attr.attr (\attrs -> { attrs | alignment = HA.class "w--text-right" })


{-| -}
alignCenter : ColumnAttribute msg a
alignCenter =
    Attr.attr (\attrs -> { attrs | alignment = HA.class "w--text-center" })


{-| -}
width : Int -> ColumnAttribute msg a
width v =
    Attr.attr (\attrs -> { attrs | width = HA.style "width" (WH.px v), minWidth = Just v })


{-| -}
relativeWidth : Float -> ColumnAttribute msg a
relativeWidth v =
    Attr.attr (\attrs -> { attrs | width = HA.style "width" (WH.pct v) })


{-| -}
minWidth : Int -> ColumnAttribute msg a
minWidth v =
    if v > 0 then
        Attr.attr (\attrs -> { attrs | minWidth = Just v })

    else
        Attr.attr (\attrs -> { attrs | minWidth = Nothing })


{-| -}
largeContainerOnly : ColumnAttribute msg a
largeContainerOnly =
    Attr.attr (\attrs -> { attrs | largeContainerOnly = True })


{-| -}
mediumContainerOnly : ColumnAttribute msg a
mediumContainerOnly =
    Attr.attr (\attrs -> { attrs | mediumContainerOnly = True })


{-| @deprecated

Please use `largeContainerOnly`.

-}
largeScreenOnly : ColumnAttribute msg a
largeScreenOnly =
    Attr.attr (\attrs -> { attrs | largeScreenOnly = True })


{-| -}
groupValue : (String -> List a -> H.Html msg) -> ColumnAttribute msg a
groupValue fn =
    Attr.attr (\attrs -> { attrs | toGroup = Just (\x _ xs -> fn x xs) })


{-| -}
groupValueCustom : (a -> List a -> H.Html msg) -> ColumnAttribute msg a
groupValueCustom fn =
    Attr.attr (\attrs -> { attrs | toGroup = Just (\_ x xs -> fn x xs) })


{-| -}
groupLabel : ColumnAttribute msg a
groupLabel =
    Attr.attr (\attrs -> { attrs | toGroup = Just (\label _ _ -> H.text label) })



-- View


{-| -}
view : List (Attribute msg a) -> List (Column msg a) -> List a -> H.Html msg
view attrs_ columns data =
    let
        numCols : Int
        numCols =
            List.length columns

        tableMinWidth : Int
        tableMinWidth =
            columns
                |> List.foldl
                    (\(Column col) acc ->
                        col.minWidth
                            |> Maybe.map ((+) acc)
                            |> Maybe.withDefault acc
                    )
                    0

        hasGroups : Bool
        hasGroups =
            attrs.groupBy /= Nothing

        defaultGroupLabel : Bool
        defaultGroupLabel =
            if hasGroups then
                columns
                    |> List.any (\(Column c) -> c.toGroup /= Nothing)
                    |> not

            else
                True

        attrs : Attributes msg a
        attrs =
            Attr.toAttrs defaultAttrs attrs_

        rows : List (H.Html msg)
        rows =
            case attrs.groupBy of
                Just groupBy_ ->
                    data
                        |> toGroupedRows attrs groupBy_
                        |> List.concatMap
                            (\( groupLabel_, groupItem, groupItems ) ->
                                let
                                    groupRows : List a
                                    groupRows =
                                        attrs.groupCollapsed
                                            |> Maybe.map (\fn -> fn groupItem groupLabel_)
                                            |> Maybe.withDefault False
                                            |> WH.or [] groupItems

                                    groupIndentElement : Maybe (H.Html msg)
                                    groupIndentElement =
                                        attrs.groupIndent
                                            |> Maybe.map (\fn -> fn groupItem)
                                in
                                viewGroupHeader
                                    { attrs = attrs
                                    , columns = columns
                                    , defaultGroupLabel = defaultGroupLabel
                                    , numCols = numCols
                                    , groupLabel_ = groupLabel_
                                    , groupItem = groupItem
                                    , groupColumns = groupItems
                                    }
                                    :: (groupRows
                                            |> List.indexedMap (viewTableRow attrs columns groupIndentElement numCols)
                                            |> List.concat
                                       )
                            )

                Nothing ->
                    data
                        |> List.indexedMap (viewTableRow attrs columns Nothing numCols)
                        |> List.concat

        hasFooter : Bool
        hasFooter =
            List.any (\(Column c) -> c.toFooter /= Nothing) columns
    in
    H.div
        [ HA.class "w__table w--scrollable"
        , case attrs.theme of
            Default ->
                HA.class ""

            Subtle ->
                HA.class "w__m-subtle"
        , HA.classList
            [ ( "w__m-striped", attrs.isStriped )
            , ( "w__m-borders", attrs.withBorders )
            , ( "w__m-interactive", attrs.onClick /= Nothing )
            , ( "w__m-group", hasGroups )
            , ( "w__m-group-interactive", attrs.onGroupClick /= Nothing )
            , ( "w__m-dividers", attrs.withDividers )
            , ( "w__m-header-bg", attrs.headerBackground )
            , ( "w__m-card", attrs.card )
            ]
        , [ paddingStyles attrs
          , attrs.maxHeight
                |> Maybe.map (\v -> [ ( "max-height", WH.rem v ) ])
                |> Maybe.withDefault []
          ]
            |> List.concat
            |> W.Theme.styleList
        ]
        [ viewExtraHeader attrs
        , H.table
            [ HA.class "w--table w--table-fixed w--inset-0 w--border-collapse"
            , HA.class "w--w-full w--overflow-auto"
            , HA.class "w--font-base w--text-default"
            , HA.style "min-width" (WH.px tableMinWidth)
            ]
            [ -- Table Head
              if attrs.showHeader then
                H.thead [ HA.class "w__table__header" ] [ H.tr [] (List.map (viewTableHeaderColumn attrs) columns) ]

              else
                H.text ""
            , --  Table Body
              H.tbody
                [ WH.maybeAttr HE.onMouseLeave attrs.onMouseLeave ]
                rows
            , -- Table Footer
              if hasFooter then
                H.tfoot [ HA.class "w__table__footer" ] [ H.tr [] (List.map (viewTableFooterColumn data) columns) ]

              else
                H.text ""
            ]
        ]


viewExtraHeader : Attributes msg a -> H.Html msg
viewExtraHeader attrs =
    case attrs.extraHeader of
        Just extraHeader_ ->
            H.div
                [ HA.class "w__table__extra-header"
                , HA.classList
                    [ ( "w__m-no-padding", attrs.extraHeaderNoPadding )
                    , ( "w__m-no-divider", attrs.extraHeaderNoDivider )
                    ]
                ]
                extraHeader_

        Nothing ->
            H.text ""


toGroupedRows : Attributes msg a -> (a -> String) -> List a -> List ( String, a, List a )
toGroupedRows attrs groupBy_ data =
    data
        |> List.foldl
            (\row acc ->
                let
                    key : String
                    key =
                        groupBy_ row
                in
                Dict.update key
                    (\items ->
                        case items of
                            Just ( a, items_ ) ->
                                Just ( a, items_ ++ [ row ] )

                            Nothing ->
                                Just ( row, [ row ] )
                    )
                    acc
            )
            Dict.empty
        |> Dict.toList
        |> List.map (\( label, ( a, items ) ) -> ( label, a, items ))
        |> attrs.groupSortBy


viewGroupHeader :
    { attrs : Attributes msg a
    , columns : List (Column msg a)
    , defaultGroupLabel : Bool
    , numCols : Int
    , groupLabel_ : String
    , groupItem : a
    , groupColumns : List a
    }
    -> H.Html msg
viewGroupHeader props =
    H.tr
        [ HA.class "w__table__group"
        , HA.class "w--p-0 w--font-semibold"
        , WH.maybeAttr (\fn -> HE.onClick (fn props.groupItem)) props.attrs.onGroupClick
        , WH.maybeAttr (\fn -> HE.onMouseEnter (fn props.groupItem)) props.attrs.onGroupMouseEnter
        , WH.maybeAttr HE.onMouseEnter props.attrs.onGroupMouseLeave
        ]
        (if props.defaultGroupLabel then
            props.columns
                |> List.head
                |> Maybe.map
                    (\(Column col) ->
                        [ H.td
                            (HA.colspan props.numCols :: columnHtmlAttrs props.attrs col)
                            [ H.text props.groupLabel_ ]
                        ]
                    )
                |> Maybe.withDefault []

         else
            props.columns
                |> List.map
                    (\(Column col) ->
                        H.td
                            (columnHtmlAttrs props.attrs col)
                            [ col.toGroup
                                |> Maybe.map (\fn -> fn props.groupLabel_ props.groupItem props.groupColumns)
                                |> Maybe.withDefault (H.text "")
                            ]
                    )
        )


columnHtmlAttrs : Attributes msg a -> ColumnAttributes msg a -> List (H.Attribute msg)
columnHtmlAttrs attrs col =
    HA.class "w__table__group__column w--shrink-0 w--m-0 w--break-words"
        :: (col.groupAlignClass
                |> WH.maybeOr attrs.groupAlignClass
                |> WH.maybeAttr HA.class
           )
        :: columnStyles col


viewTableHeaderColumn : Attributes msg a -> Column msg a -> H.Html msg
viewTableHeaderColumn attrs (Column col) =
    H.th
        (columnStyles col
            ++ [ HA.class "w--sticky w--z-20 w--top-0"
               , HA.class "w__table__header__column"
               , HA.class "w--m-0 w--font-semibold w--text-sm w--text-subtle"
               , col.headerAlignClass
                    |> WH.maybeOr attrs.headerAlignClass
                    |> WH.maybeAttr HA.class
               ]
        )
        [ H.div
            [ HA.class "w--flex w--items-center gap-1"
            , HA.class attrs.labelBaseClass
            , HA.class col.labelClass
            ]
            [ col.customLeft
                |> Maybe.map (H.span [ HA.class "w--shrink-0" ])
                |> Maybe.withDefault (H.text "")
            , col.customLabel
                |> Maybe.withDefault [ H.text col.label ]
                |> H.span [ HA.class "w--grow" ]
            , col.customRight
                |> Maybe.map (H.span [ HA.class "w--shrink-0" ])
                |> Maybe.withDefault (H.text "")
            ]
        ]


viewTableFooterColumn : List a -> Column msg a -> H.Html msg
viewTableFooterColumn data (Column col) =
    H.td
        (columnStyles col
            ++ [ HA.class "w--sticky w--z-10 w--bottom-0"
               , HA.class "w__table__footer__column"
               , HA.class "w--m-0 w--font-semibold w--text-sm w--text-subtle"
               ]
        )
        [ col.toFooter
            |> Maybe.map (\fn -> fn data)
            |> Maybe.withDefault (H.text "")
        ]


viewTableRow : Attributes msg a -> List (Column msg a) -> Maybe (H.Html msg) -> Int -> Int -> a -> List (H.Html msg)
viewTableRow attrs columns groupIndentElement numCols rowIndex datum =
    let
        isHighlighted : Bool
        isHighlighted =
            attrs.highlight datum

        rowClass : H.Attribute msg
        rowClass =
            HA.classList
                [ ( "w__table__row w--p-0", True )
                , ( "w__m-striped", attrs.isStriped && modBy 2 rowIndex == 1 )
                ]
    in
    [ H.tr
        [ rowClass
        , HA.classList
            [ ( "w__m-highlight", isHighlighted )
            ]
        , WH.maybeAttr (\onClick_ -> HE.onClick (onClick_ datum)) attrs.onClick
        , WH.maybeAttr (\onMouseEnter_ -> HE.onMouseEnter (onMouseEnter_ datum)) attrs.onMouseEnter
        ]
        (columns
            |> List.indexedMap
                (\index (Column col) ->
                    H.td
                        (columnStyles col
                            ++ [ HA.class "w--shrink-0 w--m-0 w--break-words" ]
                        )
                        (case ( index, groupIndentElement ) of
                            ( 0, Just groupIndent_ ) ->
                                [ H.span
                                    [ HA.class "w__table__group-indent-cell" ]
                                    [ H.span [ HA.class "w__table__group-indent" ] [ groupIndent_ ]
                                    , H.span [] [ col.toHtml datum ]
                                    ]
                                ]

                            _ ->
                                [ col.toHtml datum ]
                        )
                )
        )
    , attrs.rowDetails
        |> Maybe.andThen (\fn -> fn datum)
        |> Maybe.map
            (\children ->
                H.tr
                    [ rowClass
                    , HA.classList [ ( "w__m-no-padding", attrs.rowDetailsNoPadding ) ]
                    ]
                    [ H.td [ HA.colspan numCols ] children
                    ]
            )
        |> Maybe.withDefault (H.text "")
    ]



-- Column Builders


{-| -}
column :
    List (ColumnAttribute msg a)
    ->
        { label : String
        , content : a -> H.Html msg
        }
    -> Column msg a
column attrs_ props =
    column_
        (columnAttrs props.label props.content)
        attrs_


{-| -}
string :
    List (ColumnAttribute msg a)
    -> { label : String, value : a -> String }
    -> Column msg a
string attrs_ props =
    column_
        (columnAttrs props.label (\a -> H.text (props.value a)))
        attrs_


{-| -}
int :
    List (ColumnAttribute msg a)
    -> { label : String, value : a -> Int }
    -> Column msg a
int attrs_ props =
    let
        default : ColumnAttributes msg a
        default =
            columnAttrs props.label (\a -> H.text (String.fromInt (props.value a)))
    in
    column_ { default | alignment = HA.class "w--text-right" } attrs_


{-| -}
float :
    List (ColumnAttribute msg a)
    -> { label : String, value : a -> Float }
    -> Column msg a
float attrs_ props =
    let
        default : ColumnAttributes msg a
        default =
            columnAttrs props.label (\a -> H.text (String.fromFloat (props.value a)))
    in
    column_ { default | alignment = HA.class "w--text-right" } attrs_


{-| -}
bool :
    List (ColumnAttribute msg a)
    -> { label : String, value : a -> Bool }
    -> Column msg a
bool attrs_ props =
    let
        default : ColumnAttributes msg a
        default =
            columnAttrs props.label (\a -> W.InputCheckbox.viewReadOnly [] (props.value a))
    in
    column_ { default | alignment = HA.class "w--text-right" } attrs_

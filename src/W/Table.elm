module W.Table exposing
    ( view, Attribute
    , column, string, int, float, bool, Column, ColumnAttribute
    , customLabel, labelClass, labelLeft, labelRight, alignRight, alignCenter, width, relativeWidth, largeScreenOnly
    , onClick, onMouseEnter, onMouseLeave
    , groupBy, groupValue, groupValueCustom, groupSortBy, groupSortByDesc, groupSortWith, groupCollapsed, groupLabel, onGroupClick, onGroupMouseEnter, onGroupMouseLeave
    , noHeader, highlight, maxHeight
    )

{-|

@docs view, Attribute


# Columns

@docs column, string, int, float, bool, Column, ColumnAttribute


# Column Attributes

@docs customLabel, labelClass, labelLeft, labelRight, alignRight, alignCenter, width, relativeWidth, largeScreenOnly


# Actions

@docs onClick, onMouseEnter, onMouseLeave


# Groups

@docs groupBy, groupValue, groupValueCustom, groupSortBy, groupSortByDesc, groupSortWith, groupCollapsed, groupLabel, onGroupClick, onGroupMouseEnter, onGroupMouseLeave


# Table Attributes

@docs noHeader, highlight, maxHeight

-}

import Attr
import Dict
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.InputCheckbox
import W.Internal.Helpers as WH
import W.Theme



-- Table Attributes


{-| -}
type alias Attribute msg a =
    Attr.Attr (Attributes msg a)


type alias Attributes msg a =
    { showHeader : Bool
    , styles : List ( String, String )
    , groupBy : Maybe (a -> String)
    , groupSortBy : List ( String, a, List a ) -> List ( String, a, List a )
    , groupCollapsed : Maybe (a -> String -> Bool)
    , highlight : a -> Bool
    , onClick : Maybe (a -> msg)
    , onMouseEnter : Maybe (a -> msg)
    , onMouseLeave : Maybe msg
    , onGroupClick : Maybe (a -> msg)
    , onGroupMouseEnter : Maybe (a -> msg)
    , onGroupMouseLeave : Maybe msg
    }


defaultAttrs : Attributes msg a
defaultAttrs =
    { showHeader = True
    , styles = []
    , groupBy = Nothing
    , groupSortBy = identity
    , groupCollapsed = Nothing
    , highlight = \_ -> False
    , onClick = Nothing
    , onMouseEnter = Nothing
    , onMouseLeave = Nothing
    , onGroupClick = Nothing
    , onGroupMouseEnter = Nothing
    , onGroupMouseLeave = Nothing
    }


{-| -}
noHeader : Attribute msg a
noHeader =
    Attr.attr (\attrs -> { attrs | showHeader = False })


{-| Max height in "rem".
-}
maxHeight : Float -> Attribute msg a
maxHeight v =
    Attr.attr (\attrs -> { attrs | styles = ( "max-height", WH.rem v ) :: attrs.styles })


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
    , customLabel : Maybe (List (H.Html msg))
    , customLeft : Maybe (List (H.Html msg))
    , customRight : Maybe (List (H.Html msg))
    , alignment : H.Attribute msg
    , width : H.Attribute msg
    , largeScreenOnly : Bool
    , toHtml : a -> H.Html msg
    , toGroup : Maybe (String -> a -> List a -> H.Html msg)
    }


column_ : ColumnAttributes msg a -> List (ColumnAttribute msg a) -> Column msg a
column_ default attrs =
    Column (Attr.toAttrs default attrs)


columnAttrs : String -> (a -> H.Html msg) -> ColumnAttributes msg a
columnAttrs label toHtml =
    { label = label
    , labelClass = ""
    , customLabel = Nothing
    , customLeft = Nothing
    , customRight = Nothing
    , alignment = HA.class "w--text-left"
    , width = HA.class ""
    , largeScreenOnly = False
    , toHtml = toHtml
    , toGroup = Nothing
    }


columnStyles : ColumnAttributes msg a -> List (H.Attribute msg)
columnStyles attrs =
    [ attrs.alignment
    , attrs.width
    , HA.classList
        [ ( "w--hidden lg:w--table-cell", attrs.largeScreenOnly ) ]
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
    Attr.attr (\attrs -> { attrs | width = HA.style "width" (WH.px v) })


{-| -}
relativeWidth : Float -> ColumnAttribute msg a
relativeWidth v =
    Attr.attr (\attrs -> { attrs | width = HA.style "width" (WH.pct v) })


{-| -}
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
                                in
                                viewGroupHeader attrs columns groupLabel_ groupItem groupItems
                                    :: List.map (viewTableRow attrs columns) groupRows
                            )

                Nothing ->
                    List.map (viewTableRow attrs columns) data
    in
    H.table
        [ HA.class "w--table w--table-fixed w--indent-0"
        , HA.class "w--w-full w--overflow-auto"
        , HA.class "w--bg-bg-color w--font-base w--text-default"
        , W.Theme.styleList attrs.styles
        ]
        [ -- Table Head
          if attrs.showHeader then
            H.thead
                [ HA.class "w--sticky w--z-20 w--top-0 w--z-10"
                , HA.class "w--bg-bg-color"
                ]
                [ H.tr [] (List.map viewTableHeaderColumn columns) ]

          else
            H.text ""
        , --  Table Body
          H.tbody
            [ WH.maybeAttr HE.onMouseLeave attrs.onMouseLeave ]
            rows
        ]


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


viewGroupHeader : Attributes msg a -> List (Column msg a) -> String -> a -> List a -> H.Html msg
viewGroupHeader attrs columns groupLabel_ groupItem groupColumns =
    H.tr
        [ HA.class "w--table-group-header"
        , HA.class "w--p-0 w--font-semibold w--bg-tint"
        , WH.maybeAttr (\fn -> HE.onClick (fn groupItem)) attrs.onGroupClick
        , WH.maybeAttr (\fn -> HE.onMouseEnter (fn groupItem)) attrs.onGroupMouseEnter
        , WH.maybeAttr HE.onMouseEnter attrs.onGroupMouseLeave
        , HA.classList
            [ ( "hover:w--bg-tint-strong active:w--bg-tint-subtle", attrs.onGroupClick /= Nothing )
            ]
        ]
        (columns
            |> List.map
                (\(Column col) ->
                    H.td
                        (columnStyles col
                            ++ [ HA.class "w--shrink-0 w--m-0 w--break-words" ]
                        )
                        [ col.toGroup
                            |> Maybe.map (\fn -> fn groupLabel_ groupItem groupColumns)
                            |> Maybe.withDefault (H.text "")
                        ]
                )
        )


viewTableHeaderColumn : Column msg a -> H.Html msg
viewTableHeaderColumn (Column col) =
    H.th
        (columnStyles col
            ++ [ HA.class "w--m-0 w--font-semibold w--text-sm w--text-subtle" ]
        )
        [ H.div
            [ HA.class "w--flex w--items-center gap-1"
            , HA.class "w--p-md"
            , HA.class "w--border-b-2 w--border-solid w--border-0 w--border-tint-subtle"
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


viewTableRow : Attributes msg a -> List (Column msg a) -> a -> H.Html msg
viewTableRow attrs columns datum =
    H.tr
        [ HA.class "w--p-0"
        , if attrs.highlight datum then
            HA.classList
                [ ( "w--bg-base-aux/10", True )
                , ( "hover:w--bg-base-aux/[0.07] active:w--bg-base-aux/10", attrs.onClick /= Nothing )
                ]

          else
            HA.classList
                [ ( "hover:w--bg-base-aux/[0.04] active:w--bg-base-aux/[0.07]", attrs.onClick /= Nothing )
                ]
        , WH.maybeAttr (\onClick_ -> HE.onClick (onClick_ datum)) attrs.onClick
        , WH.maybeAttr (\onMouseEnter_ -> HE.onMouseEnter (onMouseEnter_ datum)) attrs.onMouseEnter
        ]
        (columns
            |> List.map
                (\(Column col) ->
                    H.td
                        (columnStyles col
                            ++ [ HA.class "w--shrink-0 w--m-0 w--break-words" ]
                        )
                        [ col.toHtml datum ]
                )
        )



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

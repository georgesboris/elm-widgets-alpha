module W.Breadcrumbs exposing
    ( view, viewButtons, Attribute
    , small, separator, maxItems
    , id
    )

{-|

@docs view, viewButtons, Attribute
@docs small, separator, maxItems
@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Button
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , small : Bool
    , maxItems : Maybe Int
    , separator : H.Html msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , small = False
    , maxItems = Nothing
    , separator = H.span [ HA.class "w__breadcrumbs__separator" ] [ H.text "/" ]
    }


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\a -> { a | id = Just v })


{-| -}
maxItems : Int -> Attribute msg
maxItems v =
    Attr.attr (\a -> { a | maxItems = Just (max 1 v) })


{-| -}
separator : H.Html msg -> Attribute msg
separator v =
    Attr.attr (\a -> { a | separator = v })


{-| -}
small : Attribute msg
small =
    Attr.attr (\a -> { a | small = True })



-- View


{-| -}
view :
    List (Attribute msg)
    ->
        { current : a
        , previous : List a
        , toLabel : a -> List (H.Html msg)
        , toHref : a -> String
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            view_ attrs
                (props.toLabel props.current)
                (props.previous
                    |> List.map
                        (\item ->
                            [ W.Button.viewLink (previousButtonAttrs attrs)
                                { href = props.toHref item
                                , label = [ H.span [ HA.class "w__breadcrumbs__item__label" ] (props.toLabel item) ]
                                }
                            ]
                        )
                )
        )


{-| -}
viewButtons :
    List (Attribute msg)
    ->
        { current : a
        , previous : List a
        , toLabel : a -> List (H.Html msg)
        , onClick : a -> msg
        }
    -> H.Html msg
viewButtons =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            view_ attrs
                (props.toLabel props.current)
                (props.previous
                    |> List.map
                        (\item ->
                            [ W.Button.view (previousButtonAttrs attrs)
                                { onClick = props.onClick item
                                , label = [ H.span [ HA.class "w__breadcrumbs__item__label" ] (props.toLabel item) ]
                                }
                            ]
                        )
                )
        )


{-| -}
view_ :
    Attributes msg
    -> List (H.Html msg)
    -> List (List (H.Html msg))
    -> H.Html msg
view_ attrs current previous =
    let
        previousWithLimit : List (List (H.Html msg))
        previousWithLimit =
            case attrs.maxItems of
                Nothing ->
                    previous

                Just maxItems_ ->
                    if List.length previous <= maxItems_ then
                        previous

                    else
                        let
                            -- We reduce `maxItems` by one here
                            -- so the final number of items, including the
                            -- placeholder ellipsis, matches the max number.
                            keepSize : Float
                            keepSize =
                                toFloat (maxItems_ - 1) / 2

                            firstItems : List (List (H.Html msg))
                            firstItems =
                                previous
                                    |> List.take (floor keepSize)

                            lastItems : List (List (H.Html msg))
                            lastItems =
                                previous
                                    |> List.reverse
                                    |> List.take (ceiling keepSize)
                                    |> List.reverse
                        in
                        firstItems
                            ++ ([ W.Button.viewDummy
                                    [ W.Button.readOnly
                                    , W.Button.invisible
                                    , buttonAttrs attrs
                                    ]
                                    [ H.text "…" ]
                                ]
                                    :: lastItems
                               )
    in
    H.ul
        [ WH.maybeAttr HA.id attrs.id
        , HA.class "w__breadcrumbs"
        ]
        ((previousWithLimit
            ++ [ [ W.Button.viewDummy [ W.Button.readOnly, W.Button.invisible, buttonAttrs attrs ]
                    current
                 ]
               ]
         )
            |> List.indexedMap
                (\index item ->
                    H.li
                        [ HA.class "w__breadcrumbs__item" ]
                        (if index > 0 then
                            attrs.separator :: item

                         else
                            item
                        )
                )
        )



-- Helpers


previousButtonAttrs : Attributes msg -> List (W.Button.Attribute msg)
previousButtonAttrs attrs =
    [ W.Button.subtle, buttonAttrs attrs ]


buttonAttrs : Attributes msg -> W.Button.Attribute msg
buttonAttrs attrs =
    Attr.batch
        [ W.Button.icon
        , if attrs.small then
            W.Button.extraSmall

          else
            W.Button.small
        ]

module W.Pagination exposing
    ( view, viewLinks, Attribute
    , separator
    )

{-|

@docs view, viewLinks, Attribute


# Styles

@docs separator

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Button
import W.Internal.Pagination



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { separator : List (H.Html msg)
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { separator = [ H.span [ HA.class "w--relative -w--top-px" ] [ H.text "—" ] ]
    }



-- Attributes : Setters


{-| -}
separator : List (H.Html msg) -> Attribute msg
separator v =
    Attr.attr (\attrs -> { attrs | separator = v })



-- Main


viewWrapper : List (H.Html msg) -> H.Html msg
viewWrapper =
    H.div [ HA.class "w--flex w--items-center w--font-primary w--space-x-md w--text-subtle" ]


{-| -}
viewLinks :
    List (Attribute msg)
    ->
        { total : Int
        , active : Int
        , href : Int -> String
        }
    -> H.Html msg
viewLinks =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            case W.Internal.Pagination.toPages props.active props.total of
                Ok pages ->
                    viewWrapper
                        (pages
                            |> List.map
                                (\page ->
                                    if page /= -1 then
                                        W.Button.viewLink
                                            [ W.Button.small
                                            , W.Button.invisible
                                            , W.Button.icon
                                            , if page == props.active then
                                                W.Button.primary

                                              else
                                                Attr.none
                                            ]
                                            { href = props.href page
                                            , label = [ H.text (String.fromInt page) ]
                                            }

                                    else
                                        H.span
                                            [ HA.class "w--inline-flex w--items-center w--leading-none" ]
                                            attrs.separator
                                )
                        )

                Err errorMessage ->
                    H.text errorMessage
        )


{-| -}
view :
    List (Attribute msg)
    ->
        { total : Int
        , active : Int
        , onClick : Int -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            case W.Internal.Pagination.toPages props.active props.total of
                Ok pages ->
                    viewWrapper
                        (pages
                            |> List.map
                                (\page ->
                                    if page /= -1 then
                                        W.Button.view
                                            [ W.Button.small
                                            , W.Button.icon
                                            , if page == props.active then
                                                W.Button.primary

                                              else
                                                W.Button.invisible
                                            ]
                                            { onClick = props.onClick page
                                            , label = [ H.text (String.fromInt page) ]
                                            }

                                    else
                                        H.span
                                            [ HA.class "w--inline-flex w--items-center w--leading-none" ]
                                            attrs.separator
                                )
                        )

                Err errorMessage ->
                    H.text errorMessage
        )

module W.Accordion exposing
    ( view, Attribute
    , link, subtle, padding
    )

{-|

@docs view, Attribute
@docs link, subtle, padding

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Internal.Icons
import W.Theme
import W.Theme.Spacing


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { linkId : Maybe String
    , style : Style
    , padding : W.Theme.Spacing.Spacing
    , msg : Maybe msg
    }


type Style
    = Card
    | Subtle


defaultAttrs : Attributes msg
defaultAttrs =
    { linkId = Nothing
    , style = Card
    , padding = W.Theme.Spacing.md
    , msg = Nothing
    }


{-| -}
link : String -> Attribute msg
link v =
    Attr.attr (\attrs -> { attrs | linkId = Just v })


{-| -}
subtle : Attribute msg
subtle =
    Attr.attr (\attrs -> { attrs | style = Subtle })


{-| -}
padding : W.Theme.Spacing.Spacing -> Attribute msg
padding v =
    Attr.attr (\attrs -> { attrs | padding = v })


{-| -}
view :
    List (Attribute msg)
    ->
        { items : List a
        , toHeader : a -> List (H.Html msg)
        , toContent : a -> List (H.Html msg)
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.div
                [ W.Theme.styleList
                    [ ( "--padding", W.Theme.Spacing.toCSS attrs.padding ) ]
                ]
                (props.items
                    |> List.indexedMap
                        (\index item ->
                            let
                                wrapperAttrs : List (H.Attribute msg)
                                wrapperAttrs =
                                    [ HA.class "w--accordion"
                                    , HA.classList
                                        [ ( "w--m-card", attrs.style == Card )
                                        , ( "w--m-subtle", attrs.style == Subtle )
                                        ]
                                    ]

                                headerChildren : List (H.Html msg)
                                headerChildren =
                                    [ H.div [] (props.toHeader item)
                                    , W.Internal.Icons.chevronDown
                                        { class = "w--accordion-icon"
                                        , size = 16
                                        }
                                    ]

                                content : H.Html msg
                                content =
                                    H.div
                                        [ HA.class "w--accordion-content" ]
                                        (props.toContent item)
                            in
                            case attrs.linkId of
                                Just linkId ->
                                    let
                                        radioId : String
                                        radioId =
                                            "w-accordion-" ++ linkId

                                        inputId : String
                                        inputId =
                                            "w-accordion-" ++ linkId ++ String.fromInt index
                                    in
                                    H.div wrapperAttrs
                                        [ H.input
                                            [ HA.class "w--accordion-control"
                                            , HA.type_ "radio"
                                            , HA.name radioId
                                            , HA.id inputId
                                            ]
                                            []
                                        , H.label
                                            [ HA.class "w--accordion-summary"
                                            , HA.for inputId
                                            ]
                                            headerChildren
                                        , content
                                        ]

                                Nothing ->
                                    H.details wrapperAttrs
                                        [ H.summary [ HA.class "w--accordion-summary" ] headerChildren
                                        , content
                                        ]
                        )
                )
        )

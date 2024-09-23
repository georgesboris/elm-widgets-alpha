module W.FormField exposing
    ( view, hint, Attribute
    , alignRight
    , padding, paddingX, paddingY, noPadding
    )

{-|

@docs view, hint, Attribute


# Styles

@docs alignRight


# Padding

@docs padding, paddingX, paddingY, noPadding

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { alignRight : Bool
    , hint : Maybe (List (H.Html msg))
    , padding : Maybe { x : Int, y : Int }
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { alignRight = False
    , hint = Nothing
    , padding = Just { x = 16, y = 16 }
    }



-- Attributes : Setters


{-| -}
alignRight : Bool -> Attribute msg
alignRight v =
    Attr.attr (\attrs -> { attrs | alignRight = v })


{-| Appears underneath the label.
-}
hint : List (H.Html msg) -> Attribute msg
hint v =
    Attr.attr (\attrs -> { attrs | hint = Just v })


{-| -}
noPadding : Attribute msg
noPadding =
    Attr.attr (\attrs -> { attrs | padding = Nothing })


{-| -}
padding : Int -> Attribute msg
padding v =
    Attr.attr (\attrs -> { attrs | padding = Just { x = v, y = v } })


{-| -}
paddingX : Int -> Attribute msg
paddingX v =
    Attr.attr (\attrs -> { attrs | padding = Maybe.map (\p -> { p | x = v }) attrs.padding })


{-| -}
paddingY : Int -> Attribute msg
paddingY v =
    Attr.attr (\attrs -> { attrs | padding = Maybe.map (\p -> { p | y = v }) attrs.padding })



-- View


{-| -}
view :
    List (Attribute msg)
    ->
        { label : List (H.Html msg)
        , input : List (H.Html msg)
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            H.section
                [ HA.class "w--bg-base-bg w--font-base"
                , WH.maybeAttr (HA.style "padding" << WH.paddingXY) attrs.padding
                ]
                (if attrs.alignRight then
                    [ H.div
                        [ HA.class "w--flex w--items-start" ]
                        [ H.div
                            [ HA.class "w--flex w--flex-col w--justify-center"
                            , HA.class "w--w-[40%]"
                            , HA.class "w--box-border w--pr-md w--min-h-[50px]"
                            ]
                            [ H.h1 [ HA.class "w--m-0 w--font-normal w--text-base w--font-base w--text-default" ]
                                props.label
                            , attrs.hint
                                |> Maybe.map (\f -> H.p [ HA.class "w--m-0 w--text-sm w--font-base w--text-subtle" ] f)
                                |> Maybe.withDefault (H.text "")
                            ]
                        , H.div
                            [ HA.class "w--w-[60%]" ]
                            props.input
                        ]
                    ]

                 else
                    [ H.div
                        [ HA.class "w--pb-ms" ]
                        [ H.h1 [ HA.class "w--m-0 w--font-normal w--text-sm w--font-base w--text-default" ]
                            props.label
                        , attrs.hint
                            |> Maybe.map (\f -> H.p [ HA.class "w--m-0 w--text-xs w--font-base w--text-subtle" ] f)
                            |> Maybe.withDefault (H.text "")
                        ]
                    , H.div []
                        props.input
                    ]
                )
        )

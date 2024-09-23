module W.Divider exposing
    ( view, Attribute
    , subtle, thin, vertical
    , color, margins
    )

{-|

@docs view, Attribute

@docs subtle, thin, vertical
@docs color, margins

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Internal.Helpers as WH
import W.Theme


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { color : String
    , vertical : Bool
    , thin : Bool
    , margins : Float
    }


defaultAttrs : Attributes
defaultAttrs =
    { color = W.Theme.color.accent
    , vertical = False
    , thin = False
    , margins = 0
    }



-- Attrs : Setters


{-| -}
thin : Attribute
thin =
    Attr.attr (\attrs -> { attrs | thin = True })


{-| -}
subtle : Attribute
subtle =
    Attr.attr (\attrs -> { attrs | color = W.Theme.color.accentSubtle })


{-| -}
color : String -> Attribute
color v =
    Attr.attr (\attrs -> { attrs | color = v })


{-| -}
vertical : Attribute
vertical =
    Attr.attr (\attrs -> { attrs | vertical = True })


{-| -}
margins : Float -> Attribute
margins v =
    Attr.attr (\attrs -> { attrs | margins = v })



-- View


{-| -}
view : List Attribute -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            if List.isEmpty children then
                H.hr
                    [ HA.class "w--self-stretch w--border-solid w--border-0"
                    , if attrs.thin then
                        HA.classList
                            [ ( "w--border-t", not attrs.vertical )
                            , ( "w--border-l", attrs.vertical )
                            ]

                      else
                        HA.classList
                            [ ( "w--border-t-2", not attrs.vertical )
                            , ( "w--border-l-2", attrs.vertical )
                            ]
                    , if attrs.vertical then
                        W.Theme.styleList
                            [ ( "color", attrs.color )
                            , ( "margin", "0 " ++ WH.rem attrs.margins )
                            ]

                      else
                        W.Theme.styleList
                            [ ( "color", attrs.color )
                            , ( "margin", WH.rem attrs.margins ++ " 0" )
                            ]
                    ]
                    []

            else
                H.div
                    [ HA.class "w--self-stretch"
                    , HA.class "w--flex w--items-center w--justify-center w--gap-sm w--leading-none"
                    , HA.class "w--text-sm"
                    , HA.class "before:w--content-[''] before:w--block before:w--grow"
                    , HA.class "after:w--content-[''] after:w--block after:w--grow"
                    , HA.class "before:w--bg-current after:w--bg-current"
                    , if attrs.thin then
                        HA.classList
                            [ ( "before:w--h-[1px] after:w--h-[1px]", not attrs.vertical )
                            , ( "w--flex-col before:w--w-[1px] after:w--w-[1px]", attrs.vertical )
                            ]

                      else
                        HA.classList
                            [ ( "before:w--h-[2px] after:w--h-[2px]", not attrs.vertical )
                            , ( "w--flex-col before:w--w-[2px] after:w--w-[2px]", attrs.vertical )
                            ]
                    , if attrs.vertical then
                        W.Theme.styleList
                            [ ( "color", attrs.color )
                            , ( "width", WH.rem (attrs.margins * 2) )
                            ]

                      else
                        W.Theme.styleList
                            [ ( "color", attrs.color )
                            , ( "height", WH.rem (attrs.margins * 2) )
                            ]
                    ]
                    [ H.span
                        [ HA.class "w--text-default" ]
                        children
                    ]
        )

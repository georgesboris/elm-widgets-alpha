module W.Notification exposing
    ( view, Attribute
    , icon, footer
    , primary, secondary, success, warning, danger
    , href, onClick, onClose
    , id
    )

{-|

@docs view, Attribute


# Content

@docs icon, footer


# Styles

@docs primary, secondary, success, warning, danger


# Actions

@docs href, onClick, onClose


# Html

@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Button
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , icon : Maybe (List (H.Html msg))
    , footer : Maybe (List (H.Html msg))
    , theme : String
    , href : Maybe String
    , onClick : Maybe msg
    , onClose : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , icon = Nothing
    , footer = Nothing
    , theme = "w/base"
    , href = Nothing
    , onClick = Nothing
    , onClose = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
onClick : msg -> Attribute msg
onClick v =
    Attr.attr (\attrs -> { attrs | onClick = Just v })


{-| -}
onClose : msg -> Attribute msg
onClose v =
    Attr.attr (\attrs -> { attrs | onClose = Just v })


{-| -}
href : String -> Attribute msg
href v =
    Attr.attr (\attrs -> { attrs | href = Just v })


{-| -}
icon : List (H.Html msg) -> Attribute msg
icon v =
    Attr.attr (\attrs -> { attrs | icon = Just v })


{-| -}
footer : List (H.Html msg) -> Attribute msg
footer v =
    Attr.attr (\attrs -> { attrs | footer = Just v })


{-| -}
primary : Attribute msg
primary =
    Attr.attr (\attrs -> { attrs | theme = "w/primary" })


{-| -}
secondary : Attribute msg
secondary =
    Attr.attr (\attrs -> { attrs | theme = "w/secondary" })


{-| -}
success : Attribute msg
success =
    Attr.attr (\attrs -> { attrs | theme = "w/success" })


{-| -}
warning : Attribute msg
warning =
    Attr.attr (\attrs -> { attrs | theme = "w/warning" })


{-| -}
danger : Attribute msg
danger =
    Attr.attr (\attrs -> { attrs | theme = "w/danger" })



-- Main


{-| -}
view :
    List (Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children_ ->
            let
                baseAttrs : List (H.Attribute msg)
                baseAttrs =
                    [ WH.maybeAttr HA.id attrs.id
                    , HA.class attrs.theme
                    , HA.class "w--m-0 w--box-border w--relative w--text-left"
                    , HA.class "w--flex w--w-full w--items-center"
                    , HA.class "w--font-base w--text-base w--font-medium"
                    , HA.class "w--py-sm w--px-md"
                    , HA.class "w--min-h-[60px]"
                    , HA.class "w--bg w--rounded-md w--shadow-lg"
                    , HA.class "w--border-solid w--border-tint w--border"
                    , HA.class "w--border-t-8 w--border-t-accent"
                    ]

                children : H.Html msg
                children =
                    H.div
                        [ HA.class "w--flex w--gap-md w--items-center w--w-full w--relative w--z-10"
                        ]
                        [ WH.maybeHtml (H.div [ HA.class "w--shrink-0 w--flex w--items-center" ]) attrs.icon
                        , H.div
                            [ HA.class "w--grow w--flex w--flex-col" ]
                            [ H.div [] children_
                            , WH.maybeHtml (H.div [ HA.class "w--text-sm w--font-normal w--text-subtle" ]) attrs.footer
                            ]
                        , WH.maybeHtml
                            (\onClose_ ->
                                H.div
                                    [ HA.class "w--shrink-0 w--flex w--items-center" ]
                                    [ W.Button.view [ W.Button.invisible, W.Button.icon, W.Button.small ]
                                        { label = [ H.text "x" ]
                                        , onClick = onClose_
                                        }
                                    ]
                            )
                            attrs.onClose
                        ]
            in
            case ( attrs.onClick, attrs.href ) of
                ( Just onClick_, _ ) ->
                    H.button
                        (baseAttrs ++ [ interactiveClass, HE.onClick onClick_ ])
                        [ children ]

                ( Nothing, Just href_ ) ->
                    H.a
                        (baseAttrs ++ [ interactiveClass, HA.href href_ ])
                        [ children ]

                _ ->
                    H.div baseAttrs [ children ]
        )


interactiveClass : H.Attribute msg
interactiveClass =
    HA.class
        "w--appearance-none w--bg-transparent w--no-underline w--focusable hover:before:w--opacity-[0.05] active:before:w--opacity-10"

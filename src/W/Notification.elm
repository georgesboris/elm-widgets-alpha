module W.Notification exposing
    ( view, Attribute
    , icon, footer
    , primary, secondary, success, warning, danger
    , href, onClick, onClose
    , id
    , header
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
import W.DataRow
import W.Internal.Helpers as WH



-- Attributes


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , icon : List (H.Html msg)
    , header : List (H.Html msg)
    , footer : List (H.Html msg)
    , theme : String
    , href : Maybe String
    , onClick : Maybe msg
    , onClose : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , icon = []
    , header = []
    , footer = []
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
    Attr.attr (\attrs -> { attrs | icon = v })


{-| -}
header : List (H.Html msg) -> Attribute msg
header v =
    Attr.attr (\attrs -> { attrs | header = v })


{-| -}
footer : List (H.Html msg) -> Attribute msg
footer v =
    Attr.attr (\attrs -> { attrs | footer = v })


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
                    , HA.class "w__notification"
                    , HA.class "w--m-0 w--box-border w--relative w--text-left"
                    , HA.class "w--flex w--w-full w--items-center"
                    , HA.class "w--text-base"
                    , HA.class "w--min-h-[60px]"
                    , HA.class "w--bg w--rounded-md w--shadow-lg"
                    ]

                children : H.Html msg
                children =
                    W.DataRow.viewExtra []
                        { left = attrs.icon
                        , header = attrs.header
                        , main = children_
                        , footer = attrs.footer
                        , right =
                            case attrs.onClose of
                                Just onClose_ ->
                                    [ W.Button.view [ W.Button.invisible, W.Button.icon, W.Button.small ]
                                        { label = [ H.text "x" ]
                                        , onClick = onClose_
                                        }
                                    ]

                                Nothing ->
                                    []
                        }
            in
            case ( attrs.onClick, attrs.href ) of
                ( Just onClick_, _ ) ->
                    H.button
                        (baseAttrs ++ [ HA.class "w/focus", HE.onClick onClick_ ])
                        [ children ]

                ( Nothing, Just href_ ) ->
                    H.a
                        (baseAttrs ++ [ HA.class "w/focus w--no-underline", HA.href href_ ])
                        [ children ]

                _ ->
                    H.div baseAttrs [ children ]
        )

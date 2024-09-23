module W.Badge exposing
    ( view
    , inline
    , small
    , base, primary, secondary, success, warning, customColor
    , Attribute
    )

{-|

@docs view


## Display

@docs inline


## Size

@docs small


## Colors

@docs base, primary, secondary, success, warning, customColor

@docs Attribute

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Theme


{-| -}
type alias Attribute =
    Attr.Attr Attributes


type alias Attributes =
    { inline : Bool
    , small : Bool
    , color : Color
    }


type Color
    = ColorClass String
    | ColorCustom { color : String, background : String }


defaultAttrs : Attributes
defaultAttrs =
    { inline = False
    , small = False
    , color = ColorClass "w/danger"
    }



-- Attrs : Setters


{-| -}
inline : Attribute
inline =
    Attr.attr (\attrs -> { attrs | inline = True })


{-| -}
small : Attribute
small =
    Attr.attr (\attrs -> { attrs | small = True })


{-| -}
base : Attribute
base =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w/base" })


{-| -}
primary : Attribute
primary =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w/primary" })


{-| -}
secondary : Attribute
secondary =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w/secondary" })


{-| -}
success : Attribute
success =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w/success" })


{-| -}
warning : Attribute
warning =
    Attr.attr (\attrs -> { attrs | color = ColorClass "w/warning" })


{-| -}
customColor : { color : String, background : String } -> Attribute
customColor v =
    Attr.attr (\attrs -> { attrs | color = ColorCustom v })



-- View


{-| -}
view : List Attribute -> List (H.Html msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs children ->
            let
                styles : List ( String, String )
                styles =
                    List.concat
                        [ [ ( "height", "1.5em" ) ]
                        , if attrs.small then
                            [ ( "padding", "0 0.375rem" ) ]

                          else
                            [ ( "padding", "0 0.625rem" ) ]
                        , case attrs.color of
                            ColorCustom value ->
                                [ ( "color", value.color )
                                , ( "background", value.background )
                                ]

                            ColorClass _ ->
                                []
                        , if attrs.inline then
                            []

                          else
                            [ ( "position", "absolute" )
                            , ( "bottom", "100%" )
                            , ( "left", "100%" )
                            , ( "translate", "-50% 50%" )
                            ]
                        ]
            in
            H.span
                [ HA.attribute "role" "status"
                , HA.class "w--inline-flex w--items-center w--justify-center"
                , HA.class "w--rounded-full w--leading-none w--font-semibold"
                , HA.class "w--shadow"
                , W.Theme.styleList styles
                , if attrs.inline then
                    HA.class ""

                  else
                    HA.class "w--animate-fade-slide"
                , if attrs.small then
                    HA.class "w--text-xs"

                  else
                    HA.class "w--text-sm"
                , case attrs.color of
                    ColorCustom _ ->
                        HA.class ""

                    ColorClass value ->
                        HA.class (value ++ " w/solid")
                ]
                children
        )

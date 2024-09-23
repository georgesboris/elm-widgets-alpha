module W.InputTextArea exposing
    ( view, Attribute
    , placeholder, resizable, rows, autogrow
    , autofocus, disabled, readOnly
    , required
    , onBlur, onEnter, onFocus
    , id
    )

{-|

@docs view, Attribute


# Styles

@docs placeholder, resizable, rows, autogrow


# States

@docs autofocus, disabled, readOnly


# Validation Attributes

@docs required


# Actions

@docs onBlur, onEnter, onFocus


# Html

@docs id

-}

import Attr
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import W.Internal.Helpers as WH


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { id : Maybe String
    , disabled : Bool
    , readOnly : Bool
    , required : Bool
    , autofocus : Bool
    , resizable : Bool
    , autogrow : Bool
    , rows : Int
    , placeholder : Maybe String
    , onFocus : Maybe msg
    , onBlur : Maybe msg
    , onEnter : Maybe msg
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { id = Nothing
    , disabled = False
    , readOnly = False
    , required = False
    , autofocus = False
    , placeholder = Nothing
    , resizable = False
    , autogrow = False
    , rows = 4
    , onFocus = Nothing
    , onBlur = Nothing
    , onEnter = Nothing
    }



-- Attributes : Setters


{-| -}
id : String -> Attribute msg
id v =
    Attr.attr (\attrs -> { attrs | id = Just v })


{-| -}
placeholder : String -> Attribute msg
placeholder v =
    Attr.attr (\attrs -> { attrs | placeholder = Just v })


{-| -}
disabled : Attribute msg
disabled =
    Attr.attr (\attrs -> { attrs | disabled = True })


{-| -}
readOnly : Attribute msg
readOnly =
    Attr.attr (\attrs -> { attrs | readOnly = True })


{-| -}
autofocus : Attribute msg
autofocus =
    Attr.attr (\attrs -> { attrs | autofocus = True })


{-| -}
required : Attribute msg
required =
    Attr.attr (\attrs -> { attrs | required = True })


{-| -}
resizable : Attribute msg
resizable =
    Attr.attr (\attrs -> { attrs | resizable = True })



-- Autogrow strategy based on https://css-tricks.com/the-cleanest-trick-for-autogrowing-textareas/


{-| -}
autogrow : Attribute msg
autogrow =
    Attr.attr (\attrs -> { attrs | autogrow = True })


{-| -}
rows : Int -> Attribute msg
rows v =
    Attr.attr (\attrs -> { attrs | rows = v })


{-| -}
onBlur : msg -> Attribute msg
onBlur v =
    Attr.attr (\attrs -> { attrs | onBlur = Just v })


{-| -}
onFocus : msg -> Attribute msg
onFocus v =
    Attr.attr (\attrs -> { attrs | onFocus = Just v })


{-| -}
onEnter : msg -> Attribute msg
onEnter v =
    Attr.attr (\attrs -> { attrs | onEnter = Just v })



-- View


{-| -}
view :
    List (Attribute msg)
    ->
        { value : String
        , onInput : String -> msg
        }
    -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            let
                resizeStyle : H.Attribute msg
                resizeStyle =
                    if attrs.autogrow then
                        HA.style "resize" "none"

                    else
                        WH.stringIf attrs.resizable "vertical" "none"
                            |> HA.style "resize"

                inputAttrs : List (H.Attribute msg)
                inputAttrs =
                    [ WH.maybeAttr HA.id attrs.id
                    , HA.class baseClass
                    , HA.class "w--pt-[10px]"
                    , HA.required attrs.required
                    , HA.disabled attrs.disabled
                    , HA.readonly attrs.readOnly
                    , HA.autofocus attrs.autofocus
                    , HA.rows attrs.rows
                    , resizeStyle
                    , HA.value props.value
                    , HE.onInput props.onInput
                    , WH.maybeAttr HA.placeholder attrs.placeholder
                    , WH.maybeAttr HE.onFocus attrs.onFocus
                    , WH.maybeAttr HE.onBlur attrs.onBlur
                    , WH.maybeAttr WH.onEnter attrs.onEnter
                    ]
            in
            if not attrs.autogrow then
                H.textarea inputAttrs []

            else
                H.div
                    [ HA.class "w--grid w--relative" ]
                    [ H.div
                        [ HA.attribute "aria-hidden" "true"
                        , HA.style "grid-area" "1 / 1 / 2 / 2"
                        , HA.class "w--overflow-hidden w--whitespace-pre-wrap w--text-transparent"
                        , HA.class "w--pt-[10px]"
                        , HA.class baseClass
                        , HA.style "background" "transparent"
                        ]
                        [ H.text (props.value ++ " ") ]
                    , H.textarea
                        (inputAttrs
                            ++ [ HA.style "grid-area" "1 / 1 / 2 / 2"
                               , HA.class "w--overflow-hidden w--whitespace-pre-wrap"
                               ]
                        )
                        []
                    ]
        )


baseClass : String
baseClass =
    "w/focus w--input"
        ++ " w--appearance-none w--box-border"
        ++ " w--relative"
        ++ " w--w-full w--min-h-[48px] w--m-0 w--py-sm w--px-md"
        ++ " w--bg-tint-subtle w--rounded w--shadow-none"
        ++ " w--font-base w--text-base w--text-default w--placeholder-subtle"
        ++ " w--transition"
        ++ " disabled:w--bg-tint"
        ++ " focus:w--bg-base-bg"

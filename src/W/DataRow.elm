module W.DataRow exposing
    ( view, viewExtra, Attribute
    , gap, padding
    )

{-|

@docs view, viewExtra, Attribute
@docs gap, padding

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Box
import W.Theme.Spacing


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { padding : W.Theme.Spacing.Spacing
    , gap : W.Theme.Spacing.Spacing
    , href : Maybe String
    , onClick : Maybe msg
    , clickArea : ClickArea
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { padding = W.Theme.Spacing.md
    , gap = W.Theme.Spacing.md
    , href = Nothing
    , onClick = Nothing
    , clickArea = Main
    }


type ClickArea
    = Main
    | Center
    | Full


{-| -}
padding : W.Theme.Spacing.Spacing -> Attribute msg
padding v =
    Attr.attr (\attrs -> { attrs | padding = v })


{-| -}
gap : W.Theme.Spacing.Spacing -> Attribute msg
gap v =
    Attr.attr (\attrs -> { attrs | padding = v })



-- View


{-| -}
view :
    List (Attribute msg)
    ->
        { main : List (H.Html msg)
        , left : List (H.Html msg)
        , right : List (H.Html msg)
        }
    -> H.Html msg
view attrs props =
    viewExtra attrs
        { main = props.main
        , left = props.left
        , right = props.right
        , footer = []
        , header = []
        }


{-| -}
viewExtra :
    List (Attribute msg)
    ->
        { main : List (H.Html msg)
        , header : List (H.Html msg)
        , footer : List (H.Html msg)
        , left : List (H.Html msg)
        , right : List (H.Html msg)
        }
    -> H.Html msg
viewExtra =
    Attr.withAttrs defaultAttrs
        (\attrs props ->
            W.Box.view
                [ W.Box.flex []
                , W.Box.styles
                    [ ( "padding", W.Theme.Spacing.toCSS attrs.padding )
                    , ( "gap", W.Theme.Spacing.toCSS attrs.gap )
                    ]
                ]
                [ viewPart [ HA.class "w--shrink-0" ] props.left
                , H.div [ W.Box.growAttr ]
                    [ viewPart [ HA.class "w--text-sm w--text-subtle" ] props.header
                    , H.div [] props.main
                    , viewPart [ HA.class "w--text-sm w--text-subtle" ] props.footer
                    ]
                , viewPart [ HA.class "w--shrink-0" ] props.right
                ]
        )


viewPart : List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
viewPart attrs children =
    if List.isEmpty children then
        H.text ""

    else
        H.div attrs children

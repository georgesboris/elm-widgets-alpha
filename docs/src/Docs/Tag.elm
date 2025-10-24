module Docs.Tag exposing (view)

import Attr
import Book
import Html as H
import W.Box
import W.Tag
import W.Text
import W.Theme.Spacing


view : Book.Page model msg
view =
    Book.page "Tag"
        (viewThemes
            ([ ( [], "Neutral" )
             , ( [ W.Tag.primary ], "Primary" )
             , ( [ W.Tag.secondary ], "Secondary" )
             , ( [ W.Tag.success ], "Success" )
             , ( [ W.Tag.warning ], "Warning" )
             , ( [ W.Tag.danger ], "Danger" )
             , ( [ W.Tag.color
                    { text = "black"
                    , background = "white"
                    }
                 ]
               , "Custom"
               )
             ]
                |> List.map
                    (\( attrs_, label ) ->
                        W.Box.view
                            []
                            [ W.Text.view [ W.Text.extraSmall, W.Text.bold ] [ H.text label ]
                            , [ Attr.none, W.Tag.compact ]
                                |> List.map (\shapeAttr ->
                                    let
                                        attrs =
                                            shapeAttr :: attrs_
                                    in
                                    W.Box.view
                                        [ W.Box.gap W.Theme.Spacing.md
                                        , W.Box.yPadding W.Theme.Spacing.sm
                                        , W.Box.flex [ W.Box.yCenter ]
                                        ]
                                        [ W.Tag.view (W.Tag.large :: attrs) [ H.text label ]
                                        , W.Tag.view (W.Tag.solid :: attrs) [ H.text label ]
                                        , W.Tag.view (W.Tag.outline :: attrs) [ H.text label ]
                                        , W.Tag.view attrs [ H.text label ]
                                        , W.Tag.viewButton attrs { onClick = Book.logAction "onClick", label = [ H.text label ] }
                                        , W.Tag.viewLink attrs { href = "/logAction/#", label = [ H.text label ] }
                                        , W.Tag.view (W.Tag.small :: attrs) [ H.text label ]
                                        ]
                                )
                                |> H.div []
                            ]
                    )
            )
        )


viewThemes : List (H.Html msg) -> List (H.Html msg)
viewThemes content =
    [ viewExample "Base" Attr.none content
    , viewExample "Base" W.Box.tint content
    , viewExample "Base" W.Box.subtle content
    ]


viewExample : String -> W.Box.Attribute msg -> List (H.Html msg) -> H.Html msg
viewExample label attr content =
    W.Box.view
        [ W.Box.card
        , attr
        , W.Box.gap W.Theme.Spacing.md
        , W.Box.padding W.Theme.Spacing.md
        ]
        [ W.Text.view [ W.Text.bold ] [ H.text label ]
        , W.Box.view [ W.Box.gap W.Theme.Spacing.md ] content
        ]

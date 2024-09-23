module Docs.UI exposing
    ( viewChapter
    , viewDetailedExample
    , viewExample
    , viewHorizontal
    , viewPlaceholder
    , viewTwoColumnsSection
    , viewVertical
    )

import Book
import Html as H
import Html.Attributes as HA
import W.Box
import W.Divider
import W.Heading
import W.Spacing
import W.Text
import W.Theme


viewPlaceholder : String -> Book.Page model msg
viewPlaceholder label =
    Book.page label []
        |> Book.addTags [ "wip" ]


viewChapter : Book.Page model msg -> model -> H.Html msg
viewChapter c model =
    H.details
        [ HA.attribute "open" ""
        , HA.class "w--min-h-screen w--py-xl"
        ]
        [ H.summary [] [ H.text (Book.pageName c) ]
        , H.section
            []
            [ H.ul
                [ HA.class "w--list-none w--space-y-2xl w--p-0" ]
                (Book.pageContent c model)
            ]
        ]


viewTwoColumnsSection :
    { title : String
    , left : List (H.Html msg)
    , right : List (H.Html msg)
    }
    -> H.Html msg
viewTwoColumnsSection props =
    W.Box.view
        [ W.Box.gap W.Spacing.lg
        , W.Box.grid [ W.Box.columns 2 ]
        ]
        [ W.Box.view
            []
            (W.Heading.view
                [ W.Heading.extraSmall, W.Heading.semibold ]
                [ H.text props.title ]
                :: props.left
            )
        , W.Box.view
            []
            props.right
        ]


viewDetailedExample :
    { label : String
    , description : Maybe String
    , content : List (H.Html msg)
    , code : Maybe String
    }
    -> H.Html msg
viewDetailedExample props =
    W.Box.view
        [ W.Box.base
        , W.Box.background W.Theme.color.bg
        , W.Box.borderSmall
        , W.Box.borderSubtle
        , W.Box.rounded
        ]
        [ -- Header
          W.Box.view
            [ W.Box.padding W.Spacing.md ]
            [ W.Heading.view
                [ W.Heading.extraSmall, W.Heading.semibold ]
                [ H.text props.label ]
            , case props.description of
                Just v ->
                    W.Text.view
                        [ W.Text.subtle ]
                        [ H.text v ]

                Nothing ->
                    H.text ""
            ]
        , -- Divider
          W.Divider.view
            [ W.Divider.subtle, W.Divider.thin ]
            []

        -- Main Content
        , W.Box.view
            [ W.Box.padding W.Spacing.md ]
            props.content

        -- Code Example
        , case props.code of
            Just v ->
                H.pre [] [ H.code [] [ H.text v ] ]

            Nothing ->
                H.text ""
        ]


viewExample : ( String, List (H.Html msg) ) -> H.Html msg
viewExample ( label, content ) =
    W.Box.view []
        [ W.Heading.view
            [ W.Heading.extraSmall ]
            [ H.text label ]
        , W.Box.view
            [ W.Box.borderSmall
            , W.Box.rounded
            , W.Box.borderSubtle
            , W.Box.shadow
            , W.Box.padding W.Spacing.sm
            , W.Box.background W.Theme.color.bg
            , W.Box.gap W.Spacing.sm
            ]
            content
        ]


viewHorizontal : List (H.Html msg) -> H.Html msg
viewHorizontal =
    H.div [ HA.class "w--flex w--items-start w--gap-sm" ]


viewVertical : List (H.Html msg) -> H.Html msg
viewVertical children =
    H.div [ HA.class "w--space-y-sm" ] (List.map (\child -> H.div [] [ child ]) children)

module Docs.Showcase exposing (view)

import Book exposing (Page(..))
import Html as H
import Html.Attributes as HA


view : Book.Book model msg -> model -> H.Html msg
view book model =
    H.div
        []
        -- (chapters
        ([]
            |> List.map
                (\chapter ->
                    H.details
                        [ HA.attribute "open" ""
                        , HA.class "w--min-h-screen w--py-xl"
                        ]
                        [ H.summary [] [ H.text (Book.pageName chapter) ]
                        , H.section
                            []
                            [ H.ul
                                [ HA.class "w--list-none w--space-y-2xl w--p-0" ]
                                (Book.pageContent chapter model)
                            ]
                        ]
                )
        )

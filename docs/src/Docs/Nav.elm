module Docs.Nav exposing (view)

import Attr
import Book
import Book.Route
import Html as H
import Html.Attributes as HA
import Url
import W.Box
import W.DataRow
import W.Divider
import W.Heading
import W.Menu
import W.Tag


view :
    { url : Url.Url
    , rootBook : Book.Book model msg
    , route : Book.Route.Route model msg
    , right : List (H.Html msg)
    }
    -> H.Html msg
view props =
    let
        currentHref : String
        currentHref =
            props.url.path

        parentBook : Maybe (Book.Book model msg)
        parentBook =
            Book.Route.parentBook props.route

        bookName : String
        bookName =
            case parentBook of
                Just parentBook_ ->
                    Book.bookName parentBook_

                Nothing ->
                    Book.bookName props.rootBook
    in
    W.Box.view
        [ W.Box.widthFull
        , W.Box.flex
            [ W.Box.vertical
            , W.Box.xStretch
            ]
        ]
        [ W.DataRow.viewExtra
            []
            { left = []
            , right = []
            , header =
                case parentBook of
                    Just parentBook_ ->
                        [ H.a
                            [ HA.href (Book.Route.parentBookHref props.route) ]
                            [ H.text (Book.bookName parentBook_) ]
                        ]

                    Nothing ->
                        []
            , footer = []
            , main =
                [ W.Heading.view
                    [ W.Heading.semibold
                    , W.Heading.small
                    ]
                    [ H.text bookName ]
                ]
            }
        , W.Divider.view [ W.Divider.thin, W.Divider.subtle ] []
        , W.Box.view
            [ W.Box.grow
            , W.Box.yScroll
            ]
            [ W.Menu.view []
                (Book.Route.book props.route
                    |> Book.bookItems
                    |> List.map
                        (\bookItem ->
                            case bookItem of
                                Book.BookChapter part ->
                                    W.Menu.viewSection []
                                        { heading = [ H.text (Book.chapterName part) ]
                                        , content =
                                            Book.chapterPages part
                                                |> List.map
                                                    (\chapter ->
                                                        viewLink
                                                            { currentHref = currentHref
                                                            , href = Book.Route.pageHref props.route chapter
                                                            , label = Book.pageName chapter
                                                            , right = viewWIPTag chapter
                                                            }
                                                    )
                                        }

                                Book.BookPage chapter ->
                                    viewLink
                                        { currentHref = currentHref
                                        , href = Book.Route.pageHref props.route chapter
                                        , label = Book.pageName chapter
                                        , right = viewWIPTag chapter
                                        }

                                Book.BookRef label bookRef ->
                                    viewLink
                                        { currentHref = currentHref
                                        , href = Book.Route.bookHref props.route bookRef
                                        , label = label
                                        , right = viewBookTag
                                        }

                                Book.BookRefGroup groupLabel bookRefs ->
                                    W.Menu.viewSection []
                                        { heading = [ H.text groupLabel ]
                                        , content =
                                            bookRefs
                                                |> List.map
                                                    (\( bookRefName, bookRef ) ->
                                                        viewLink
                                                            { currentHref = currentHref
                                                            , href = Book.Route.bookHref props.route bookRef
                                                            , label = bookRefName
                                                            , right = viewBookTag
                                                            }
                                                    )
                                        }

                                Book.BookLink { label, href } ->
                                    viewLink
                                        { currentHref = currentHref
                                        , href = href
                                        , label = label
                                        , right = []
                                        }
                        )
                )
            ]
        ]


viewLink :
    { currentHref : String
    , href : String
    , label : String
    , right : List (H.Html msg)
    }
    -> H.Html msg
viewLink props =
    W.Menu.viewLink
        [ if props.currentHref == props.href then
            W.Menu.selected

          else if props.currentHref /= "/" then
            W.Menu.faded

          else
            Attr.none
        , W.Menu.right props.right
        ]
        { href = props.href
        , label = [ H.text props.label ]
        }


viewWIPTag : Book.Page model msg -> List (H.Html msg)
viewWIPTag page =
    if Book.pageHasTag "wip" page then
        [ W.Tag.view
            [ W.Tag.small ]
            [ H.text "WIP" ]
        ]

    else
        []


viewBookTag : List (H.Html msg)
viewBookTag =
    [ H.span [ HA.class "w--font-code w--text-subtle w--text-xl w--leading-none w--opacity-50" ] [ H.text "↠" ] ]

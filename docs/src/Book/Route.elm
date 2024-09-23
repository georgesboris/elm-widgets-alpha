module Book.Route exposing
    ( Route
    , book
    , bookHref
    , bookPath
    , fromBook
    , fromUrl
    , isRootUrl
    , page
    , pageHref
    , parentBook
    , parentBookHref
    , parentBooks
    , title
    )

import Book
import Dict
import Url



-- Route


type Route model msg
    = Route
        { book : Book.Book model msg
        , bookPath : List String
        , parentBooks : List (Book.Book model msg)
        , page : Maybe (Book.Page model msg)
        }


book : Route model msg -> Book.Book model msg
book (Route r) =
    r.book


bookPath : Route model msg -> List String
bookPath (Route r) =
    r.bookPath


isRootUrl : Route model msg -> Url.Url -> Bool
isRootUrl (Route r) url =
    r.bookPath == toUrlPath url


parentBook : Route model msg -> Maybe (Book.Book model msg)
parentBook (Route r) =
    List.head r.parentBooks


parentBooks : Route model msg -> List (Book.Book model msg)
parentBooks (Route r) =
    r.parentBooks


parentBookHref : Route model msg -> String
parentBookHref (Route r) =
    r.bookPath
        |> List.reverse
        |> List.drop 2
        |> List.reverse
        |> String.join "/"
        |> (++) "/"


page : Route model msg -> Maybe (Book.Page model msg)
page (Route r) =
    r.page


title : Route model msg -> String
title (Route r) =
    let
        bookTitle : String
        bookTitle =
            (r.book :: r.parentBooks)
                |> List.map Book.bookName
                |> String.join " | "
    in
    case r.page of
        Just c ->
            Book.pageName c ++ " | " ++ bookTitle

        Nothing ->
            bookTitle



-- Route


bookHref : Route model msg -> Book.Book model msg -> String
bookHref (Route route) (Book.Book b) =
    case route.bookPath of
        [] ->
            "/_/" ++ b.slug

        _ ->
            "/" ++ String.join "/" route.bookPath ++ "/_/" ++ b.slug


pageHref : Route model msg -> Book.Page model msg -> String
pageHref (Route route) p =
    case route.bookPath of
        [] ->
            "/" ++ String.join "/" (pagePath p)

        _ ->
            "/" ++ String.join "/" route.bookPath ++ "/" ++ String.join "/" (pagePath p)


pagePath : Book.Page model msg -> List String
pagePath (Book.Page c) =
    case c.chapterSlug of
        Just pSlug ->
            [ pSlug, c.slug ]

        Nothing ->
            [ c.slug ]



-- Generating Routes


fromUrl : Url.Url -> Book.Book model msg -> Maybe (Route model msg)
fromUrl url b =
    fromUrlHelper [] (toUrlPath url) b
        |> Maybe.map Route


fromBook : Book.Book model msg -> Route model msg
fromBook b =
    Route
        { book = b
        , bookPath = []
        , parentBooks = []
        , page = Nothing
        }


fromUrlHelper :
    List (Book.Book model msg)
    -> List String
    -> Book.Book model msg
    ->
        Maybe
            { book : Book.Book model msg
            , bookPath : List String
            , parentBooks : List (Book.Book model msg)
            , page : Maybe (Book.Page model msg)
            }
fromUrlHelper parentBooks_ path ((Book.Book b) as book_) =
    case path of
        "_" :: bookSlug_ :: subPath ->
            Dict.get bookSlug_ b.books
                |> Maybe.andThen
                    (\subBook ->
                        fromUrlHelper (Book.Book b :: parentBooks_) subPath subBook
                    )

        chapterSlug_ :: pageSlug_ :: [] ->
            Dict.get ( chapterSlug_, pageSlug_ ) b.pages
                |> Maybe.map
                    (\page_ ->
                        { book = book_
                        , bookPath = toBookPath book_ parentBooks_
                        , parentBooks = parentBooks_
                        , page = Just page_
                        }
                    )

        pageSlug_ :: [] ->
            Dict.get ( "", pageSlug_ ) b.pages
                |> Maybe.map
                    (\page_ ->
                        { book = book_
                        , bookPath = toBookPath book_ parentBooks_
                        , parentBooks = parentBooks_
                        , page = Just page_
                        }
                    )

        [] ->
            Just
                { book = book_
                , bookPath = toBookPath book_ parentBooks_
                , parentBooks = parentBooks_
                , page = Nothing
                }

        _ ->
            Nothing


toBookPath : Book.Book model msg -> List (Book.Book model msg) -> List String
toBookPath book_ parentBooks_ =
    case parentBooks_ of
        [] ->
            []

        _ ->
            book_
                :: parentBooks_
                |> List.reverse
                |> List.drop 1
                |> List.map Book.bookSlug
                |> List.intersperse "_"
                |> (::) "_"


toUrlPath : Url.Url -> List String
toUrlPath url =
    url.path
        |> String.split "/"
        |> List.filter ((/=) "")

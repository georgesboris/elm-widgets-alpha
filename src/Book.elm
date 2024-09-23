module Book exposing
    ( Book(..), book, bookName, bookSlug, bookItems
    , chapter, chapterName, chapterPages, chapterSlug
    , page, pageContent, addTags, pageHasTag, pageName, pageSlug
    , bookPage, bookRef, bookRefGroup, bookLink, BookContent(..)
    , Chapter, Page(..)
    , application, Application, Model, Msg(..)
    , logAction, logActionWith, logActionWithBool, logActionWithString, logActionWithFloat, logActionWithInt
    , mapMsg
    , darkMode, extraHtml, header, theme
    )

{-|

@docs Book, book, bookName, bookSlug, bookItems
@docs chapter, chapterName, chapterPages, chapterSlug
@docs page, pageContent, addTags, pageHasTag, pageName, pageSlug
@docs bookPage, bookRef, bookRefGroup, bookLink, BookContent
@docs Chapter, Page
@docs application, Application, Model, Msg
@docs logAction, logActionWith, logActionWithBool, logActionWithString, logActionWithFloat, logActionWithInt
@docs mapMsg

-}

import Attr
import Browser
import Browser.Dom
import Browser.Navigation
import Dict
import Html as H
import Html.Attributes as HA
import Set
import Task
import Url
import W.Box
import W.DataRow
import W.Divider
import W.Heading
import W.Menu
import W.Sizing
import W.Spacing
import W.Tag
import W.Theme



-- Options


{-| -}
type alias Option model msg =
    Attr.Attr (Options model msg)


type alias Options model msg =
    { theme : W.Theme.Theme
    , darkMode : W.Theme.DarkMode
    , customHeader : Maybe (H.Html msg)
    , extraHtml : Maybe (List (H.Html msg))
    , model : Maybe model
    }


defaultOptions : Options model msg
defaultOptions =
    { theme = W.Theme.lightTheme
    , darkMode = W.Theme.noDarkMode
    , customHeader = Nothing
    , extraHtml = Nothing
    , model = Nothing
    }


{-| -}
theme : W.Theme.Theme -> Option model msg
theme v =
    Attr.attr (\attrs -> { attrs | theme = v })


{-| -}
darkMode : W.Theme.DarkMode -> Option model msg
darkMode v =
    Attr.attr (\attrs -> { attrs | darkMode = v })


{-| -}
header : H.Html msg -> Option model msg
header v =
    Attr.attr (\attrs -> { attrs | customHeader = Just v })


{-| -}
extraHtml : List (H.Html msg) -> Option model msg
extraHtml v =
    Attr.attr (\attrs -> { attrs | extraHtml = Just v })



-- Core


{-| -}
type alias Model =
    { navKey : Browser.Navigation.Key
    , url : Url.Url
    , actions : List String
    }


{-| -}
type Msg
    = OnUrlChange Url.Url
    | OnUrlRequest Browser.UrlRequest
    | LogAction String
    | DoNothing



-- Standalone Application


{-| -}
type alias Application flags model msg =
    Program flags (ApplicationModel model) (ApplicationMsg msg)


type ApplicationModel model
    = ApplicationModel
        { userModel : model
        , bookModel : Model
        }


type ApplicationMsg msg
    = UserMsg msg
    | BookMsg Msg


{-| -}
application :
    { book : Book model msg
    , init : flags -> Url.Url -> Browser.Navigation.Key -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , effects : msg -> model -> Maybe Msg
    , subscriptions : model -> Sub msg
    }
    -> Application flags model msg
application props =
    Browser.application
        { init = appInit { book = props.book, init = props.init }
        , update = appUpdate { book = props.book, update = props.update, effects = props.effects }
        , subscriptions = appSubscriptions { book = props.book, subscriptions = props.subscriptions }
        , view = appView { book = props.book }
        , onUrlChange = BookMsg << OnUrlChange
        , onUrlRequest = BookMsg << OnUrlRequest
        }


appInit :
    { book : Book model msg
    , init : flags -> Url.Url -> Browser.Navigation.Key -> ( model, Cmd msg )
    }
    -> flags
    -> Url.Url
    -> Browser.Navigation.Key
    -> ( ApplicationModel model, Cmd (ApplicationMsg msg) )
appInit props flags url navKey =
    props.init flags url navKey
        |> Tuple.mapFirst
            (\userModel ->
                ApplicationModel
                    { userModel = userModel
                    , bookModel =
                        { navKey = navKey
                        , url = url
                        , actions = []
                        }
                    }
            )
        |> Tuple.mapSecond (Cmd.map UserMsg)


appUpdate :
    { book : Book model msg
    , update : msg -> model -> ( model, Cmd msg )
    , effects : msg -> model -> Maybe Msg
    }
    -> ApplicationMsg msg
    -> ApplicationModel model
    -> ( ApplicationModel model, Cmd (ApplicationMsg msg) )
appUpdate props msg (ApplicationModel m) =
    case msg of
        UserMsg userMsg ->
            let
                ( bookModel, bookCmd ) =
                    case props.effects userMsg m.userModel of
                        Just bookMsg ->
                            update { book = props.book, model = m.bookModel, msg = bookMsg }

                        Nothing ->
                            ( m.bookModel, Cmd.none )

                ( userModel, userCmd ) =
                    props.update userMsg m.userModel
            in
            ( ApplicationModel { m | bookModel = bookModel, userModel = userModel }
            , Cmd.batch [ Cmd.map BookMsg bookCmd, Cmd.map UserMsg userCmd ]
            )

        BookMsg bookMsg ->
            update { book = props.book, model = m.bookModel, msg = bookMsg }
                |> Tuple.mapFirst (\bookModel -> ApplicationModel { m | bookModel = bookModel })
                |> Tuple.mapSecond (Cmd.map BookMsg)


appSubscriptions :
    { book : Book model msg
    , subscriptions : model -> Sub msg
    }
    -> ApplicationModel model
    -> Sub (ApplicationMsg msg)
appSubscriptions props (ApplicationModel m) =
    props.subscriptions m.userModel
        |> Sub.map UserMsg


appView : { book : Book model msg } -> ApplicationModel model -> Browser.Document (ApplicationMsg msg)
appView props (ApplicationModel m) =
    let
        route_ : Route model msg
        route_ =
            route m.bookModel.url props.book
    in
    { title = routeTitle route_
    , body =
        let
            options : Options model msg
            options =
                bookOptions props.book

            bookHtml : List (H.Html msg)
            bookHtml =
                view
                    { route = route_
                    , book = props.book
                    , bookModel = m.bookModel
                    , model = m.userModel
                    }

            body : List (H.Html msg)
            body =
                case options.extraHtml of
                    Just html ->
                        html ++ bookHtml

                    Nothing ->
                        bookHtml

            globalStyles : H.Html (ApplicationMsg msg)
            globalStyles =
                H.node "style"
                    []
                    [ H.text "body { background: rgb(var(--w-bg-subtle) / 1.0) !important; }" ]
        in
        globalStyles :: List.map (H.map UserMsg) body
    }



--


{-| -}
update :
    { book : Book model msg
    , msg : Msg
    , model : Model
    }
    -> ( Model, Cmd Msg )
update props =
    let
        model : Model
        model =
            props.model
    in
    case props.msg of
        DoNothing ->
            ( props.model, Cmd.none )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.External url ->
                    ( props.model, Browser.Navigation.load url )

                Browser.Internal url ->
                    let
                        urlString : String
                        urlString =
                            Url.toString url
                    in
                    if String.contains "logAction" urlString then
                        ( { model | actions = ("Navigate to: " ++ urlString) :: model.actions }
                        , Cmd.none
                        )

                    else
                        ( model
                        , Browser.Navigation.pushUrl model.navKey urlString
                        )

        OnUrlChange url ->
            case routeFromUrl url props.book of
                Just _ ->
                    ( { model | url = url }
                    , case url.fragment of
                        Just target ->
                            scrollTo target
                                |> Task.attempt (\_ -> DoNothing)

                        Nothing ->
                            Cmd.none
                    )

                Nothing ->
                    ( model
                    , Browser.Navigation.replaceUrl model.navKey "/"
                    )

        LogAction message ->
            ( { model | actions = message :: model.actions }
            , Cmd.none
            )


scrollTo : String -> Task.Task Browser.Dom.Error ()
scrollTo id =
    Browser.Dom.getElement id
        |> Task.andThen
            (\data ->
                Browser.Dom.setViewport data.element.x data.element.y
            )


{-| -}
view :
    { route : Route model msg
    , book : Book model msg
    , bookModel : Model
    , model : model
    }
    -> List (H.Html msg)
view props =
    let
        options : Options model msg
        options =
            bookOptions props.book
    in
    [ -- Styles
      H.node "style"
        []
        [ H.text "body { margin: 0; }"
        ]

    -- Global Themes
    , W.Theme.globalTheme
        { theme = options.theme
        , darkMode = options.darkMode
        }

    -- Main Layout
    , W.Box.view
        [ W.Box.flex [ W.Box.yTop ]
        ]
        [ W.Box.view
            [ W.Box.sticky
            , W.Box.heightScreen
            , W.Box.widthCustom (W.Sizing.toCSS W.Sizing.full)
            , W.Box.maxWidth W.Sizing.sm
            , W.Box.background W.Theme.color.bg
            ]
            [ H.nav
                [ HA.class "w--absolute w--inset-0 w--overflow-x-hidden w--overflow-y-auto w--border-0 w--border-solid w--border-r w--border-accent"
                , HA.class "w--flex w--items-stretch w--justify-stretch"
                ]
                [ viewNavigation
                    { url = props.bookModel.url
                    , rootBook = props.book
                    , route = props.route
                    , right = []
                    }
                ]
            ]
        , W.Box.view
            [ W.Box.grow
            , W.Box.relative
            , W.Box.flex [ W.Box.xCenter ]
            ]
            [ W.Box.view
                [ W.Box.widthFull
                , W.Box.maxWidth W.Sizing.xl2
                , W.Box.padding W.Spacing.md
                ]
                [ case routePage props.route of
                    Just p ->
                        H.div
                            []
                            [ W.Box.view
                                [ W.Box.padding W.Spacing.md ]
                                [ W.Heading.view [] [ H.text (pageName p) ] ]
                            , W.Box.view
                                [ W.Box.padding W.Spacing.md
                                , W.Box.gap W.Spacing.xl
                                ]
                                (pageContent p props.model)
                            ]

                    Nothing ->
                        viewShowcase props.book props.model
                ]
            ]
        ]
    ]



-- Router


type Route model msg
    = Route
        { book : Book model msg
        , bookPath : List String
        , parentBooks : List (Book model msg)
        , page : Maybe (Page model msg)
        }


route : Url.Url -> Book model msg -> Route model msg
route url b =
    case fromUrlHelper [] (toUrlPath url) b of
        Just r ->
            Route r

        Nothing ->
            Route
                { book = b
                , bookPath = []
                , parentBooks = []
                , page = Nothing
                }


routeFromUrl : Url.Url -> Book model msg -> Maybe (Route model msg)
routeFromUrl url b =
    fromUrlHelper [] (toUrlPath url) b
        |> Maybe.map Route


fromUrlHelper :
    List (Book model msg)
    -> List String
    -> Book model msg
    ->
        Maybe
            { book : Book model msg
            , bookPath : List String
            , parentBooks : List (Book model msg)
            , page : Maybe (Page model msg)
            }
fromUrlHelper parentBooks_ path ((Book b) as book_) =
    case path of
        "_" :: bookSlug_ :: subPath ->
            Dict.get bookSlug_ b.books
                |> Maybe.andThen
                    (\subBook ->
                        fromUrlHelper (Book b :: parentBooks_) subPath subBook
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


toBookPath : Book model msg -> List (Book model msg) -> List String
toBookPath book_ parentBooks_ =
    case parentBooks_ of
        [] ->
            []

        _ ->
            book_
                :: parentBooks_
                |> List.reverse
                |> List.drop 1
                |> List.map bookSlug
                |> List.intersperse "_"
                |> (::) "_"


toUrlPath : Url.Url -> List String
toUrlPath url =
    url.path
        |> String.split "/"
        |> List.filter ((/=) "")


routeTitle : Route model msg -> String
routeTitle (Route r) =
    let
        bookTitle : String
        bookTitle =
            (r.book :: r.parentBooks)
                |> List.map bookName
                |> String.join " | "
    in
    case r.page of
        Just p ->
            pageName p ++ " | " ++ bookTitle

        Nothing ->
            bookTitle


routeBook : Route model msg -> Book model msg
routeBook (Route r) =
    r.book


routeBookPath : Route model msg -> List String
routeBookPath (Route r) =
    r.bookPath


isRootUrl : Route model msg -> Url.Url -> Bool
isRootUrl (Route r) url =
    r.bookPath == toUrlPath url


routePage : Route model msg -> Maybe (Page model msg)
routePage (Route r) =
    r.page


routeParentBook : Route model msg -> Maybe (Book model msg)
routeParentBook (Route r) =
    List.head r.parentBooks


routeParentBooks : Route model msg -> List (Book model msg)
routeParentBooks (Route r) =
    r.parentBooks


routeParentBookHref : Route model msg -> String
routeParentBookHref (Route r) =
    r.bookPath
        |> List.reverse
        |> List.drop 2
        |> List.reverse
        |> String.join "/"
        |> (++) "/"


routeBookHref : Route model msg -> Book model msg -> String
routeBookHref (Route r) (Book b) =
    case r.bookPath of
        [] ->
            "/_/" ++ b.slug

        _ ->
            "/" ++ String.join "/" r.bookPath ++ "/_/" ++ b.slug


routePageHref : Route model msg -> Page model msg -> String
routePageHref (Route r) p =
    case r.bookPath of
        [] ->
            "/" ++ String.join "/" (routePagePath p)

        _ ->
            "/" ++ String.join "/" r.bookPath ++ "/" ++ String.join "/" (routePagePath p)


routePagePath : Page model msg -> List String
routePagePath (Page c) =
    case c.chapterSlug of
        Just pSlug ->
            [ pSlug, c.slug ]

        Nothing ->
            [ c.slug ]



-- Actions


{-| -}
logAction : String -> Msg
logAction =
    LogAction


{-| -}
logActionWith : (a -> String) -> String -> a -> Msg
logActionWith fn label v =
    LogAction (label ++ ": " ++ fn v)


{-| -}
logActionWithBool : String -> Bool -> Msg
logActionWithBool label v =
    if v then
        LogAction (label ++ ": True")

    else
        LogAction (label ++ ": False")


{-| -}
logActionWithString : String -> String -> Msg
logActionWithString label v =
    LogAction (label ++ ": \"" ++ v ++ "\"")


{-| -}
logActionWithFloat : String -> Float -> Msg
logActionWithFloat label v =
    LogAction (label ++ ": \"" ++ String.fromFloat v ++ "\"")


{-| -}
logActionWithInt : String -> Int -> Msg
logActionWithInt label v =
    LogAction (label ++ ": \"" ++ String.fromInt v ++ "\"")



-- Book


{-| -}
type Book model msg
    = Book (BookData model msg)


type alias BookData model msg =
    { name : String
    , slug : String
    , items : List (BookContent model msg)
    , books : Dict.Dict String (Book model msg)
    , pages : Dict.Dict ( String, String ) (Page model msg)
    , options : Options model msg
    }


{-| -}
type BookContent model msg
    = BookChapter (Chapter model msg)
    | BookPage (Page model msg)
    | BookRef String (Book model msg)
    | BookRefGroup String (List ( String, Book model msg ))
    | BookLink { label : String, href : String }


{-| -}
mapMsg : (a -> b) -> Book model a -> Book model b
mapMsg fn (Book b) =
    Book
        { name = b.name
        , slug = b.slug
        , items = List.map (mapContentMsg fn) b.items
        , books = Dict.map (\_ -> mapMsg fn) b.books
        , pages = Dict.map (\_ -> mapPageMsg fn) b.pages
        , options = mapOptionsMsg fn b.options
        }


mapOptionsMsg : (a -> b) -> Options model a -> Options model b
mapOptionsMsg fn options =
    { theme = options.theme
    , darkMode = options.darkMode
    , customHeader = Maybe.map (H.map fn) options.customHeader
    , extraHtml = Maybe.map (List.map (H.map fn)) options.extraHtml
    , model = options.model
    }


mapContentMsg : (a -> b) -> BookContent model a -> BookContent model b
mapContentMsg fn content =
    case content of
        BookChapter c ->
            BookChapter (mapChapterMsg fn c)

        BookPage p ->
            BookPage (mapPageMsg fn p)

        BookRef l ref ->
            BookRef l (mapMsg fn ref)

        BookRefGroup l refs ->
            BookRefGroup l (List.map (Tuple.mapSecond (mapMsg fn)) refs)

        BookLink l ->
            BookLink l


{-| -}
type Chapter model msg
    = Chapter
        { name : String
        , slug : String
        , pages : List (Page model msg)
        }


mapChapterMsg : (a -> b) -> Chapter model a -> Chapter model b
mapChapterMsg fn (Chapter c) =
    Chapter
        { name = c.name
        , slug = c.slug
        , pages = List.map (mapPageMsg fn) c.pages
        }


{-| -}
type Page model msg
    = Page
        { name : String
        , slug : String
        , chapterSlug : Maybe String
        , anchors : List { id : String, label : String }
        , content : model -> List (H.Html msg)
        , excerpt : model -> List (H.Html msg)
        , tags : Set.Set String
        , meta : Dict.Dict String String
        }


mapPageMsg : (a -> b) -> Page model a -> Page model b
mapPageMsg fn (Page p) =
    Page
        { name = p.name
        , slug = p.slug
        , chapterSlug = p.chapterSlug
        , anchors = p.anchors
        , content = \m -> List.map (H.map fn) (p.content m)
        , excerpt = \m -> List.map (H.map fn) (p.excerpt m)
        , tags = p.tags
        , meta = p.meta
        }



-- Book


{-| -}
book :
    List (Option model msg)
    ->
        { name : String
        , content : List (BookContent model msg)
        }
    -> Book model msg
book =
    Attr.withAttrs defaultOptions
        (\options props ->
            let
                slug : String
                slug =
                    slugify props.name
            in
            Book
                { name = props.name
                , slug = slug
                , items = props.content
                , books = toBooks props.content
                , pages = toChapters props.content
                , options = options
                }
        )


toBooks : List (BookContent model msg) -> Dict.Dict String (Book model msg)
toBooks items =
    items
        |> List.concatMap
            (\item ->
                case item of
                    BookRef _ ref ->
                        [ ( bookSlug ref, ref ) ]

                    BookRefGroup _ refs ->
                        List.map (\( _, ref ) -> ( bookSlug ref, ref )) refs

                    _ ->
                        []
            )
        |> Dict.fromList


toChapters : List (BookContent model msg) -> Dict.Dict ( String, String ) (Page model msg)
toChapters items =
    items
        |> List.concatMap
            (\item ->
                case item of
                    BookChapter (Chapter p) ->
                        p.pages
                            |> List.map
                                (\(Page c) ->
                                    ( ( p.slug, c.slug )
                                    , Page c
                                    )
                                )

                    BookPage (Page c) ->
                        [ ( ( "", c.slug )
                          , Page c
                          )
                        ]

                    _ ->
                        []
            )
        |> Dict.fromList


{-| -}
bookRef : String -> Book model msg -> BookContent model msg
bookRef =
    BookRef


{-| -}
bookRefGroup : String -> List ( String, Book model msg ) -> BookContent model msg
bookRefGroup =
    BookRefGroup


{-| -}
bookLink : { href : String, label : String } -> BookContent model msg
bookLink =
    BookLink


{-| -}
bookPage : Page model msg -> BookContent model msg
bookPage =
    BookPage


{-| -}
bookName : Book model msg -> String
bookName (Book b) =
    b.name


{-| -}
bookSlug : Book model msg -> String
bookSlug (Book b) =
    b.slug


{-| -}
bookItems : Book model msg -> List (BookContent model msg)
bookItems (Book b) =
    b.items


{-| -}
bookOptions : Book model msg -> Options model msg
bookOptions (Book b) =
    b.options



-- Chapter


{-| -}
chapter : String -> List (Page model msg) -> BookContent model msg
chapter name pages =
    let
        slug : String
        slug =
            slugify name
    in
    BookChapter
        (Chapter
            { name = name
            , slug = slug
            , pages = List.map (\(Page c) -> Page { c | chapterSlug = Just slug }) pages
            }
        )


{-| -}
chapterName : Chapter model msg -> String
chapterName (Chapter p) =
    p.name


{-| -}
chapterSlug : Chapter model msg -> String
chapterSlug (Chapter p) =
    p.slug


{-| -}
chapterPages : Chapter model msg -> List (Page model msg)
chapterPages (Chapter p) =
    p.pages



-- Page


{-| -}
page : String -> List (H.Html msg) -> Page model msg
page name content =
    Page
        { name = name
        , slug = slugify name
        , anchors = []
        , excerpt = \_ -> []
        , chapterSlug = Nothing
        , content = \_ -> content
        , tags = Set.empty
        , meta = Dict.empty
        }


{-| -}
addTags : List String -> Page model msg -> Page model msg
addTags tags (Page p) =
    Page { p | tags = Set.union (Set.fromList tags) p.tags }


{-| -}
pageName : Page model msg -> String
pageName (Page c) =
    c.name


{-| -}
pageSlug : Page model msg -> String
pageSlug (Page c) =
    c.slug


{-| -}
pageContent : Page model msg -> model -> List (H.Html msg)
pageContent (Page c) =
    c.content


{-| -}
pageHasTag : String -> Page model msg -> Bool
pageHasTag tag (Page c) =
    Set.member tag c.tags


slugify : String -> String
slugify n =
    n
        |> String.trim
        |> String.toLower
        |> String.replace " " "-"
        |> Url.percentEncode



--- Book.UI.Navigation


viewNavigation :
    { url : Url.Url
    , rootBook : Book model msg
    , route : Route model msg
    , right : List (H.Html msg)
    }
    -> H.Html msg
viewNavigation props =
    let
        currentHref : String
        currentHref =
            props.url.path

        parentBook : Maybe (Book model msg)
        parentBook =
            routeParentBook props.route

        bookName_ : String
        bookName_ =
            case parentBook of
                Just parentBook_ ->
                    bookName parentBook_

                Nothing ->
                    bookName props.rootBook
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
                            [ HA.href (routeParentBookHref props.route) ]
                            [ H.text (bookName parentBook_) ]
                        ]

                    Nothing ->
                        []
            , footer = []
            , main =
                [ W.Heading.view
                    [ W.Heading.semibold
                    , W.Heading.small
                    ]
                    [ H.text bookName_ ]
                ]
            }
        , W.Divider.view [ W.Divider.thin, W.Divider.subtle ] []
        , W.Box.view
            [ W.Box.grow
            , W.Box.yScroll
            ]
            [ W.Menu.view []
                (routeBook props.route
                    |> bookItems
                    |> List.map
                        (\bookItem ->
                            case bookItem of
                                BookChapter part ->
                                    W.Menu.viewSection []
                                        { heading = [ H.text (chapterName part) ]
                                        , content =
                                            chapterPages part
                                                |> List.map
                                                    (\page_ ->
                                                        viewLink
                                                            { currentHref = currentHref
                                                            , href = routePageHref props.route page_
                                                            , label = pageName page_
                                                            , right = viewWIPTag page_
                                                            }
                                                    )
                                        }

                                BookPage page_ ->
                                    viewLink
                                        { currentHref = currentHref
                                        , href = routePageHref props.route page_
                                        , label = pageName page_
                                        , right = viewWIPTag page_
                                        }

                                BookRef label bookRef_ ->
                                    viewLink
                                        { currentHref = currentHref
                                        , href = routeBookHref props.route bookRef_
                                        , label = label
                                        , right = viewBookTag
                                        }

                                BookRefGroup groupLabel bookRefs ->
                                    W.Menu.viewSection []
                                        { heading = [ H.text groupLabel ]
                                        , content =
                                            bookRefs
                                                |> List.map
                                                    (\( bookRefName, bookRef_ ) ->
                                                        viewLink
                                                            { currentHref = currentHref
                                                            , href = routeBookHref props.route bookRef_
                                                            , label = bookRefName
                                                            , right = viewBookTag
                                                            }
                                                    )
                                        }

                                BookLink { label, href } ->
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


viewWIPTag : Page model msg -> List (H.Html msg)
viewWIPTag page_ =
    if pageHasTag "wip" page_ then
        [ W.Tag.view
            [ W.Tag.small ]
            [ H.text "WIP" ]
        ]

    else
        []


viewBookTag : List (H.Html msg)
viewBookTag =
    [ H.span [ HA.class "w--font-code w--text-subtle w--text-xl w--leading-none w--opacity-50" ] [ H.text "↠" ] ]


viewShowcase : Book model msg -> model -> H.Html msg
viewShowcase book_ model =
    H.div
        []
        ([]
            |> List.map
                (\page_ ->
                    H.details
                        [ HA.attribute "open" ""
                        , HA.class "w--min-h-screen w--py-xl"
                        ]
                        [ H.summary [] [ H.text (pageName page_) ]
                        , H.section
                            []
                            [ H.ul
                                [ HA.class "w--list-none w--space-y-2xl w--p-0" ]
                                (pageContent page_ model)
                            ]
                        ]
                )
        )

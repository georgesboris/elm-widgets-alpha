module Docs exposing
    ( Model
    , Msg(..)
    , effects
    , init
    , logAction
    , logActionWith
    , logActionWithBool
    , logActionWithFloat
    , logActionWithInt
    , logActionWithString
    , subscriptions
    , update
    )

import Book


type alias Model =
    { slider : Float
    }


type Msg
    = BookMsg Book.Msg
    | Slider_OnInput Float


init : flags -> url -> navKey -> ( Model, Cmd Msg )
init _ _ _ =
    ( { slider = 0.0 }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Slider_OnInput v ->
            ( { model | slider = v }
            , Cmd.none
            )

        BookMsg _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Book Effects


effects : Msg -> Model -> Maybe Book.Msg
effects msg _ =
    case msg of
        BookMsg bookMsg ->
            Just bookMsg

        _ ->
            Nothing


logAction : String -> Msg
logAction label =
    BookMsg (Book.logAction label)


logActionWith : (a -> String) -> String -> a -> Msg
logActionWith fn label v =
    BookMsg (Book.logAction (label ++ ": " ++ fn v))


logActionWithBool : String -> Bool -> Msg
logActionWithBool label v =
    if v then
        BookMsg (Book.logAction (label ++ ": True"))

    else
        BookMsg (Book.logAction (label ++ ": False"))


logActionWithString : String -> String -> Msg
logActionWithString label v =
    BookMsg (Book.logAction (label ++ ": \"" ++ v ++ "\""))


logActionWithFloat : String -> Float -> Msg
logActionWithFloat label v =
    BookMsg (Book.logAction (label ++ ": \"" ++ String.fromFloat v ++ "\""))


logActionWithInt : String -> Int -> Msg
logActionWithInt label v =
    BookMsg (Book.logAction (label ++ ": \"" ++ String.fromInt v ++ "\""))

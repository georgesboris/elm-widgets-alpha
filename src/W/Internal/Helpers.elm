module W.Internal.Helpers exposing
    ( asVariant
    , attrIf
    , em
    , formatFloat
    , keepIf
    , limitString
    , maybeAttr
    , maybeFilter
    , maybeHtml
    , nearestFloats
    , nearestInts
    , onClickStopPropagation
    , onEnter
    , or
    , paddingXY
    , pct
    , px
    , rem
    , stringIf
    , styles
    )

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as D
import W.Theme.Color



-- Theme Helpers


asVariant : W.Theme.Color.ColorVariant -> H.Attribute msg
asVariant variant =
    case variant of
        W.Theme.Color.Base ->
            W.Theme.Color.asBase

        W.Theme.Color.Primary ->
            W.Theme.Color.asPrimary

        W.Theme.Color.Secondary ->
            W.Theme.Color.asSecondary

        W.Theme.Color.Success ->
            W.Theme.Color.asSuccess

        W.Theme.Color.Warning ->
            W.Theme.Color.asWarning

        W.Theme.Color.Danger ->
            W.Theme.Color.asDanger



-- Styles


styles : List ( String, String ) -> H.Attribute msg
styles xs =
    xs
        |> List.map (\( k, v ) -> k ++ ":" ++ v)
        |> String.join ";"
        |> HA.attribute "style"



-- Html.Attributes


attrIf : Bool -> (a -> H.Attribute msg) -> a -> H.Attribute msg
attrIf b fn a =
    if b then
        fn a

    else
        HA.class ""


maybeAttr : (a -> H.Attribute msg) -> Maybe a -> H.Attribute msg
maybeAttr fn a =
    a
        |> Maybe.map fn
        |> Maybe.withDefault (HA.class "")



-- Html


maybeHtml : (a -> H.Html msg) -> Maybe a -> H.Html msg
maybeHtml fn a =
    a
        |> Maybe.map fn
        |> Maybe.withDefault (H.text "")


maybeFilter : (a -> Bool) -> Maybe a -> Maybe a
maybeFilter fn ma =
    ma
        |> Maybe.andThen
            (\a ->
                if fn a then
                    Just a

                else
                    Nothing
            )



-- Html.Events


enterDecoder : a -> D.Decoder a
enterDecoder a =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed a

                else
                    D.fail "Invalid key."
            )


onEnter : msg -> H.Attribute msg
onEnter msg =
    HE.on "keyup" (enterDecoder msg)


onClickStopPropagation : msg -> H.Attribute msg
onClickStopPropagation msg =
    HE.stopPropagationOn "click" (D.succeed ( msg, True ))



-- Basics


or : a -> a -> Bool -> a
or a b cond =
    if cond then
        a

    else
        b


keepIf : Bool -> Maybe a -> Maybe a
keepIf a m =
    if a then
        m

    else
        Nothing


stringIf : Bool -> String -> String -> String
stringIf v a b =
    if v then
        a

    else
        b


limitString : Maybe Int -> String -> String
limitString limit str =
    limit
        |> Maybe.map (\l -> String.left l str)
        |> Maybe.withDefault str


nearestFloats : Float -> Float -> ( Float, Float )
nearestFloats v step =
    let
        lower : Float
        lower =
            toFloat (floor (v / step)) * step
    in
    ( lower, lower + step )


nearestInts : Int -> Int -> ( Int, Int )
nearestInts v step =
    let
        lower : Int
        lower =
            (v // step) * step
    in
    ( lower, lower + step )


formatFloat : Float -> Float -> String
formatFloat step value =
    value
        |> String.fromFloat
        |> String.split "."
        |> (\parts ->
                case parts of
                    [ h, t ] ->
                        let
                            decimals : Int
                            decimals =
                                step
                                    |> String.fromFloat
                                    |> String.split "."
                                    |> List.drop 1
                                    |> List.head
                                    |> Maybe.map String.length
                                    |> Maybe.withDefault 0
                        in
                        h
                            ++ "."
                            ++ String.left decimals t

                    [ h ] ->
                        h

                    _ ->
                        ""
           )


paddingXY : { x : Int, y : Int } -> String
paddingXY { x, y } =
    px y ++ " " ++ px x



-- Formatters


pct : Float -> String
pct v =
    String.fromFloat (v * 100) ++ "%"


px : Int -> String
px value =
    String.fromInt value ++ "px"


em : Float -> String
em value =
    String.fromFloat value ++ "em"


rem : Float -> String
rem value =
    String.fromFloat value ++ "rem"

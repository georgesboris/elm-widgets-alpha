module W.Avatar exposing
    ( view, Attribute
    , name, names, image, custom
    , large, small, theme
    )

{-|

@docs view, Attribute
@docs name, names, image, custom
@docs large, small, theme

-}

import Attr
import Html as H
import Html.Attributes as HA
import W.Theme


{-| -}
type alias Attribute msg =
    Attr.Attr (Attributes msg)


type alias Attributes msg =
    { size : Size
    , icon : Maybe String
    , name : String
    , image : Maybe String
    , color : String
    , background : String
    , custom : Maybe (H.Html msg)
    }


defaultAttrs : Attributes msg
defaultAttrs =
    { size = Medium
    , icon = Nothing
    , name = ""
    , image = Nothing
    , color = W.Theme.color.textSubtle
    , background = W.Theme.color.tint
    , custom = Nothing
    }


type Size
    = Small
    | Medium
    | Large


{-| -}
small : Attribute msg
small =
    Attr.attr (\attrs -> { attrs | size = Small })


{-| -}
large : Attribute msg
large =
    Attr.attr (\attrs -> { attrs | size = Large })


{-| -}
name : String -> Attribute msg
name v =
    Attr.attr (\attrs -> { attrs | name = String.left 2 v })


{-| -}
names : String -> String -> Attribute msg
names n ln =
    Attr.attr
        (\attrs ->
            { attrs
                | name =
                    String.left 1 n ++ String.left 1 ln
            }
        )


{-| -}
theme : { color : String, background : String } -> Attribute msg
theme v =
    Attr.attr (\attrs -> { attrs | color = v.color, background = v.background })


{-| -}
image : String -> Attribute msg
image v =
    Attr.attr (\attrs -> { attrs | image = Just v })


{-| -}
custom : H.Html msg -> Attribute msg
custom v =
    Attr.attr (\attrs -> { attrs | custom = Just v })



--


{-| -}
view : List (Attribute msg) -> H.Html msg
view =
    Attr.withAttrs defaultAttrs
        (\attrs ->
            H.div
                [ HA.class "w--rounded-full w--aspect-square"
                , HA.class "w--flex w--items-center w--justify-center"
                , HA.class "w--leading-none w--uppercase w--tracking-wide"
                , case attrs.size of
                    Small ->
                        HA.class "w--text-sm"

                    Medium ->
                        HA.class "w--text-md"

                    Large ->
                        HA.class "w--text-lg"
                , [ case attrs.image of
                        Nothing ->
                            []

                        Just "" ->
                            []

                        Just url ->
                            [ ( "background-image", "url(" ++ url ++ ")" ) ]
                  , case attrs.size of
                        Small ->
                            [ ( "width", "2rem" ) ]

                        Medium ->
                            [ ( "width", "2.5rem" ) ]

                        Large ->
                            [ ( "width", "3rem" ) ]
                  , [ ( "color", attrs.color )
                    , ( "background-color", attrs.background )
                    ]
                  ]
                    |> List.concat
                    |> W.Theme.styleList
                ]
                [ case attrs.custom of
                    Just content ->
                        content

                    Nothing ->
                        H.text attrs.name
                ]
        )

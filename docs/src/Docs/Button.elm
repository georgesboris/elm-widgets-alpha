module Docs.Button exposing (Model, Msg, init, update, view)

import Attr
import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Box
import W.Button
import W.Internal.Icons
import W.Playground
import W.Text
import W.Theme.Spacing



--


type alias Model =
    { playground : W.Playground.PlaygroundState
    }


type Msg
    = UpdatePlayground W.Playground.PlaygroundState


init : Model
init =
    { playground = W.Playground.init playground
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePlayground v ->
            ( { model | playground = v }, Cmd.none )



--


playground : W.Playground.Playground (Book.Html msg)
playground =
    W.Playground.succeed
        (\content contentType size style color alignment fullWidth disabled rounded ->
            let
                ( sizeAttr, iconSize ) =
                    case size of
                        Medium ->
                            ( Attr.none, 18 )

                        Small ->
                            ( W.Button.small, 18 )

                        ExtraSmall ->
                            ( W.Button.extraSmall, 12 )
            in
            W.Button.view
                [ sizeAttr
                , style
                , color
                , alignment
                , Attr.if_ fullWidth W.Button.full
                , Attr.if_ disabled W.Button.disabled
                , Attr.if_ rounded W.Button.rounded
                , Attr.if_ (contentType == Icon) W.Button.icon
                ]
                { onClick = Book.logAction "On Click"
                , label = 
                    (case contentType of
                        Text ->
                            [ H.text content ]

                        Icon ->
                            [ W.Internal.Icons.check { size = iconSize }
                            ]

                        IconAndText ->
                            [ H.span
                                [ HA.class "w--flex w--items-center w--gap-md" ]
                                [ W.Internal.Icons.check { size = iconSize }
                                , H.span [] [ H.text content ]
                                ]
                            ]
                    )
                }
        )
        |> W.Playground.string
            { name = "Label"
            , description = "a"
            , default = "Button"
            }
        |> W.Playground.options
            { name = "Content Type"
            , description = "e"
            , defaultOption = Text
            , otherOptions = [ Icon, IconAndText ]
            , toLabel = contentTypeToLabel
            }
        |> W.Playground.options
            { name = "Size"
            , description = "a"
            , defaultOption = Medium
            , otherOptions = [ Small, ExtraSmall ]
            , toLabel = sizeToLabel
            }
        |> W.Playground.attr
            { name = "Style"
            , description = "b"
            , defaultOption = ( "Solid", Attr.none )
            , otherOptions =
                [ ( "Outline", W.Button.outline )
                , ( "Tint", W.Button.tint )
                , ( "Invisible", W.Button.invisible )
                , ( "Subtle", W.Button.subtle )
                ]
            }
        |> W.Playground.attr
            { name = "Color"
            , description = "b"
            , defaultOption = ( "Base", Attr.none )
            , otherOptions =
                [ ( "Success", W.Button.success )
                , ( "Warning", W.Button.warning )
                , ( "Danger", W.Button.danger )
                ]
            }
        |> W.Playground.attr
            { name = "Alignment"
            , description = "b"
            , defaultOption = ( "Center", Attr.none )
            , otherOptions =
                [ ( "Left", W.Button.alignLeft )
                , ( "Right", W.Button.alignRight )
                ]
            }
        |> W.Playground.bool
            { name = "Full width"
            , description = "d"
            , default = False
            }
        |> W.Playground.bool
            { name = "Disabled"
            , description = "e"
            , default = False
            }
        |> W.Playground.bool
            { name = "Rounded"
            , description = "e"
            , default = False
            }


view : Book.Page Model Msg
view =
    Book.pageStateful "Button"
        (\model ->
            [ W.Text.view
                []
                [ H.text """
The description of the Button component.
"""
                ]
            , W.Playground.view
                { playground = playground
                , toHtml = identity
                , onUpdate = Book.sendMsg << UpdatePlayground
                }
                model.playground
            , W.Box.view
                [ W.Box.gap W.Theme.Spacing.lg ]
                (List.concat
                    [ [ ( "Default", Attr.none )
                      , ( "Outline", W.Button.outline )
                      , ( "Tint", W.Button.tint )
                      , ( "Invisible", W.Button.invisible )
                      , ( "Subtle", W.Button.subtle )
                      ]
                        |> List.map
                            (\( label, attr ) ->
                                Docs.UI.viewDetailedExample
                                    { label = label
                                    , description = Just ("This is the " ++ String.toLower label ++ " variant for the Button component")
                                    , content =
                                        [ Docs.UI.viewHorizontal
                                            [ W.Button.viewDummy [ attr, W.Button.large, W.Button.radius 0.5 ] [ H.text "Button" ]
                                            , W.Button.viewDummy [ attr, W.Button.primary ] [ H.text "Button" ]
                                            , W.Button.viewDummy [ attr, W.Button.warning, W.Button.disabled ] [ H.text "Button" ]
                                            , W.Button.viewDummy [ attr, W.Button.success, W.Button.small ] [ H.text "Button" ]
                                            , W.Button.viewDummy [ attr, W.Button.icon, W.Button.small, W.Button.rounded ] [ H.text "λ" ]
                                            , W.Button.viewDummy [ attr, W.Button.danger, W.Button.extraSmall ] [ H.text "Button" ]
                                            ]
                                        ]
                                    , code = Nothing
                                    }
                            )
                    , [ Docs.UI.viewDetailedExample
                            { label = "Full width"
                            , description = Nothing
                            , content =
                                [ Docs.UI.viewVertical
                                    [ W.Button.viewDummy [ W.Button.primary, W.Button.rounded, W.Button.full ] [ H.text "Button" ]
                                    , W.Button.viewDummy [ W.Button.primary, W.Button.full, W.Button.disabled ] [ H.text "Button" ]
                                    ]
                                ]
                            , code = Nothing
                            }
                      ]
                    , [ Docs.UI.viewDetailedExample
                            { label = "Multiline & Different Alignments"
                            , description = Nothing
                            , content =
                                [ Docs.UI.viewVertical
                                    [ W.Button.viewDummy
                                        [ W.Button.alignLeft
                                        , W.Button.primary
                                        , W.Button.full
                                        ]
                                        [ H.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." ]
                                    , W.Button.viewDummy
                                        [ W.Button.alignRight
                                        , W.Button.primary
                                        , W.Button.full
                                        ]
                                        [ H.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." ]
                                    ]
                                ]
                            , code = Nothing
                            }
                      ]
                    ]
                )
            ]
        )



-- Helper Types


type Size
    = Medium
    | Small
    | ExtraSmall


sizeToLabel : Size -> String
sizeToLabel size =
    case size of
        Medium ->
            "Medium"

        Small ->
            "Small"

        ExtraSmall ->
            "Extra Small"


type ContentType
    = Text
    | Icon
    | IconAndText


contentTypeToLabel : ContentType -> String
contentTypeToLabel value =
    case value of
        Text ->
            "Text"

        Icon ->
            "Icon"

        IconAndText ->
            "Icon and text"

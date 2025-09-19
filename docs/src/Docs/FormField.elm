module Docs.FormField exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Divider
import W.FormField
import W.InputRadio
import W.InputSlider
import W.InputText


view : Book.Page model msg
view =
    let
        props :
            { label : List (Book.Html msg)
            , input : List (Book.Html msg)
            }
        props =
            { label =
                [ H.text "Label" ]
            , input =
                [ H.div [ HA.style "display" "flex", HA.style "flex-direction" "column", HA.style "gap" "20px" ]
                    [ W.InputText.view
                        [ W.InputText.placeholder "..."
                        ]
                        { value = ""
                        , onInput = Book.logActionWithString "onInput"
                        }
                    , W.InputRadio.view
                        []
                        { id = "default"
                        , value = 1
                        , toLabel = String.fromInt
                        , toValue = String.fromInt
                        , options = [ 1, 2, 3 ]
                        , onInput = Book.logActionWith String.fromInt "onInput"
                        }
                    , W.InputSlider.view
                        [ W.InputSlider.readOnly ]
                        { min = 0
                        , max = 10
                        , step = 1
                        , value = 5
                        , onInput = Book.logActionWith String.fromFloat "onInput"
                        }
                    ]
                ]
            }

        singleInput :
            { label : List (Book.Html msg)
            , input : List (Book.Html msg)
            }
        singleInput =
            { label =
                [ H.text "Label" ]
            , input =
                [ W.InputText.view
                    [ W.InputText.placeholder "..."
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
            }
    in
    Book.page "Form Field"
        (List.map Docs.UI.viewExample
            [ ( "Single"
              , [ W.FormField.view [] props ]
              )
            , ( "Single without Padding"
              , [ W.FormField.view [ W.FormField.padding 0 ] props ]
              )
            , ( "Group + Status"
              , [ W.FormField.view [] props
                , W.FormField.view [ W.FormField.hint [ H.text "Try writing some text here." ] ] props
                , W.FormField.view [ W.FormField.hint [ H.text "Try writing some text here." ] ]
                    props
                ]
              )
            , ( "Right aligned"
              , [ W.FormField.view
                    [ W.FormField.alignRight
                    ]
                    singleInput
                , W.FormField.view
                    [ W.FormField.alignRight
                    , W.FormField.hint [ H.text "Try writing some text here." ]
                    ]
                    singleInput
                , W.Divider.view [] []
                , W.FormField.view
                    [ W.FormField.alignRight
                    ]
                    props
                , W.FormField.view
                    [ W.FormField.alignRight
                    ]
                    props
                ]
              )
            ]
        )

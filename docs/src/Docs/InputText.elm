module Docs.InputText exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Button
import W.InputText


view : Book.Page model Book.Msg
view =
    Book.page "Input Text"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputText.view
                    [ W.InputText.placeholder "Type something…"
                    , W.InputText.small
                    , W.InputText.mask (\s -> "R$ " ++ s)
                    , W.InputText.prefix [ H.text "$" ]
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Disabled"
              , [ W.InputText.view
                    [ W.InputText.placeholder "Type something…"
                    , W.InputText.suffix [ H.div [ HA.style "height" "60px" ] [ H.text "Email" ] ]
                    , W.InputText.disabled True
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Read Only"
              , [ W.InputText.view
                    [ W.InputText.placeholder "Type something…"
                    , W.InputText.readOnly True
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Password"
              , [ W.InputText.view
                    [ W.InputText.password
                    , W.InputText.placeholder "Type your password…"
                    , W.InputText.suffix
                        [ W.Button.view
                            [ W.Button.small, W.Button.invisible ]
                            { label = [ H.text "Show" ]
                            , onClick = Book.logAction "onClick"
                            }
                        ]
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Search"
              , [ W.InputText.view
                    [ W.InputText.search
                    , W.InputText.placeholder "Search…"
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Email"
              , [ W.InputText.view
                    [ W.InputText.email
                    , W.InputText.placeholder "user@email.com"
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Url"
              , [ W.InputText.view
                    [ W.InputText.url
                    , W.InputText.placeholder "https://app.site.com"
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )

            -- , ( "Validation"
            --   , [ H.div []
            --         [ W.InputText.viewWithValidation
            --             [ W.InputText.url
            --             , W.InputText.minLength 5
            --             , W.InputText.maxLength 15
            --             , W.InputText.pattern "http://[a-z|\\.]+"
            --             , W.InputText.placeholder "https://app.site.com"
            --             ]
            --             { value = inputText.validated
            --             , onInput =
            --                 \result v ->
            --                     updateState
            --                         (\model ->
            --                             let
            --                                 inputText_ =
            --                                     model.inputText
            --                             in
            --                             { model
            --                                 | inputText =
            --                                     { inputText_
            --                                         | validated = v
            --                                         , validationMessage =
            --                                             case result of
            --                                                 Ok v_ ->
            --                                                     []
            --                                                 Err errors ->
            --                                                     List.map W.InputText.errorToString errors
            --                                     }
            --                             }
            --                         )
            --             }
            --         , if List.isEmpty inputText.validationMessage then
            --             H.text ""
            --           else
            --             W.Box.view
            --                 [ W.Box.pad_2
            --                 , W.Box.gap_2
            --                 ]
            --                 (inputText.validationMessage
            --                     |> List.map (\error -> W.Text.view [] [ H.text error ])
            --                 )
            --         ]
            --     ]
            --   )
            ]
        )

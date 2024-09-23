module Docs.InputTextArea exposing (view)

import Book
import Docs.UI
import W.InputTextArea


view : Book.Page model Book.Msg
view =
    Book.page "Input TextArea"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputTextArea.view
                    [ W.InputTextArea.placeholder "Type something…"
                    , W.InputTextArea.rows 4
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Resizable"
              , [ W.InputTextArea.view
                    [ W.InputTextArea.placeholder "Type something…"
                    , W.InputTextArea.rows 4
                    , W.InputTextArea.resizable
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Autogrow"
              , [ W.InputTextArea.view
                    [ W.InputTextArea.placeholder "Type something…"
                    , W.InputTextArea.rows 1
                    , W.InputTextArea.autogrow
                    ]
                    { value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            ]
        )

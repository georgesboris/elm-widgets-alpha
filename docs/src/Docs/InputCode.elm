module Docs.InputCode exposing (view)

import Book
import Docs.UI
import W.InputCode


view : Book.Page model Book.Msg
view =
    Book.page "Input Code"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputCode.view []
                    { length = 6
                    , value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Hidden Characters"
              , [ W.InputCode.view [ W.InputCode.hiddenCharacters ]
                    { length = 6
                    , value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            , ( "Uppercase"
              , [ W.InputCode.view [ W.InputCode.uppercase ]
                    { length = 6
                    , value = ""
                    , onInput = Book.logActionWithString "onInput"
                    }
                ]
              )
            ]
        )

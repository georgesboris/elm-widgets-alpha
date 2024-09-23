module Docs.InputRadio exposing (view)

import Book
import Docs.UI
import W.InputRadio


view : Book.Page model Book.Msg
view =
    Book.page "Input Radio"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputRadio.view
                    []
                    { id = "default"
                    , value = 1
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Small"
              , [ W.InputRadio.view
                    [ W.InputRadio.small ]
                    { id = "default"
                    , value = 1
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Disabled"
              , [ W.InputRadio.view
                    [ W.InputRadio.disabled True ]
                    { id = "disabled"
                    , value = 2
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Read Only"
              , [ W.InputRadio.view
                    [ W.InputRadio.readOnly True ]
                    { id = "read-only"
                    , value = 2
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Starting with hidden value"
              , [ W.InputRadio.view []
                    { id = "r"
                    , value = -1
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Custom Colors"
              , [ W.InputRadio.view
                    [ W.InputRadio.color "red" ]
                    { id = "custom-colors"
                    , value = 3
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Vertical"
              , [ W.InputRadio.view
                    [ W.InputRadio.vertical True ]
                    { id = "vertical"
                    , value = 2
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            , ( "Vertical + Small"
              , [ W.InputRadio.view
                    [ W.InputRadio.small
                    , W.InputRadio.vertical True
                    ]
                    { id = "default"
                    , value = 1
                    , toLabel = String.fromInt
                    , toValue = String.fromInt
                    , options = [ 1, 2, 3 ]
                    , onInput = Book.logActionWithInt "onInput"
                    }
                ]
              )
            ]
        )

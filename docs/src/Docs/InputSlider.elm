module Docs.InputSlider exposing (view)

import Book
import Docs.UI
import W.InputSlider


view : Book.Page model Book.Msg
view =
    Book.page "Input Slider"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputSlider.view []
                    { min = 0
                    , max = 10
                    , step = 1
                    , value = 5
                    , onInput = Book.logActionWithFloat "onInput"
                    }
                ]
              )
            , ( "Disabled"
              , [ W.InputSlider.view
                    [ W.InputSlider.disabled ]
                    { min = 0
                    , max = 10
                    , step = 1
                    , value = 5
                    , onInput = Book.logActionWithFloat "onInput"
                    }
                ]
              )
            , ( "Read Only"
              , [ W.InputSlider.view
                    [ W.InputSlider.readOnly ]
                    { min = 0
                    , max = 10
                    , step = 1
                    , value = 5
                    , onInput = Book.logActionWithFloat "onInput"
                    }
                ]
              )
            , ( "Custom Color"
              , [ W.InputSlider.view
                    [ W.InputSlider.color "red"
                    ]
                    { min = 0
                    , max = 10
                    , step = 1
                    , value = 5
                    , onInput = Book.logActionWithFloat "onInput"
                    }
                ]
              )
            ]
        )

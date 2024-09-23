module Docs.InputCheckbox exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.InputCheckbox


view : Book.Page model Book.Msg
view =
    Book.page "Input Checkbox"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputCheckbox.view
                    []
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Disabled (Checked)"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.disabled ]
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Disabled (Unchecked)"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.disabled ]
                    { value = False
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Read Only"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.readOnly ]
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Custom Color"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.color "red" ]
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Different Sizes"
              , [ W.InputCheckbox.view
                    []
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                , H.div [ HA.style "display" "inline-block", HA.style "width" "8px" ] []
                , W.InputCheckbox.view
                    [ W.InputCheckbox.small ]
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Colorful"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.colorful ]
                    { value = False
                    , onInput = Book.logActionWithBool "onInput"
                    }
                , H.div [ HA.style "display" "inline-block", HA.style "width" "8px" ] []
                , W.InputCheckbox.view
                    [ W.InputCheckbox.small, W.InputCheckbox.colorful ]
                    { value = False
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Toggle"
              , [ Docs.UI.viewHorizontal
                    [ W.InputCheckbox.view
                        [ W.InputCheckbox.toggle ]
                        { value = False
                        , onInput = Book.logActionWithBool "onInput"
                        }
                    , W.InputCheckbox.view
                        [ W.InputCheckbox.toggle ]
                        { value = True
                        , onInput = Book.logActionWithBool "onInput"
                        }
                    ]
                ]
              )
            , ( "Toggle - Small"
              , [ W.InputCheckbox.view
                    [ W.InputCheckbox.toggle, W.InputCheckbox.small ]
                    { value = True
                    , onInput = Book.logActionWithBool "onInput"
                    }
                ]
              )
            , ( "Toggle - Custom Colors"
              , [ Docs.UI.viewHorizontal
                    [ W.InputCheckbox.view
                        [ W.InputCheckbox.toggle
                        , W.InputCheckbox.color "red"
                        ]
                        { value = True
                        , onInput = Book.logActionWithBool "onInput"
                        }
                    , W.InputCheckbox.view
                        [ W.InputCheckbox.toggle
                        , W.InputCheckbox.colorful
                        , W.InputCheckbox.color "red"
                        ]
                        { value = True
                        , onInput = Book.logActionWithBool "onInput"
                        }
                    ]
                ]
              )
            ]
        )

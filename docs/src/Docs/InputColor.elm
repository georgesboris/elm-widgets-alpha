module Docs.InputColor exposing (view)

import Book
import Color
import Docs.UI
import W.InputColor
import W.Internal.Color


view : Book.Page model Book.Msg
view =
    Book.page "Input Color"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ Docs.UI.viewHorizontal
                    [ W.InputColor.view
                        []
                        { value = Color.blue
                        , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                        }
                    , W.InputColor.view
                        [ W.InputColor.small ]
                        { value = Color.blue
                        , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                        }
                    ]
                ]
              )
            , ( "Rounded"
              , [ Docs.UI.viewHorizontal
                    [ W.InputColor.view
                        [ W.InputColor.rounded ]
                        { value = Color.blue
                        , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                        }
                    , W.InputColor.view
                        [ W.InputColor.rounded, W.InputColor.small ]
                        { value = Color.blue
                        , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                        }
                    ]
                ]
              )
            , ( "Disabled"
              , [ W.InputColor.view
                    [ W.InputColor.disabled ]
                    { value = Color.yellow
                    , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                    }
                ]
              )
            , ( "Read Only"
              , [ W.InputColor.view
                    [ W.InputColor.readOnly ]
                    { value = Color.red
                    , onInput = Book.logActionWith W.Internal.Color.toHex "onInput"
                    }
                ]
              )
            ]
        )

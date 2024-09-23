module Docs.InputInt exposing (view)

import Book
import Docs.UI
import W.InputInt


view : Book.Page model Book.Msg
view =
    Book.page "Input Int"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputInt.view
                    [ W.InputInt.placeholder "Type something…"
                    , W.InputInt.mask (\s -> s ++ s)
                    ]
                    { value = W.InputInt.init (Just 0)
                    , onInput =
                        \v ->
                            W.InputInt.toInt v
                                |> Maybe.map String.fromInt
                                |> Maybe.map ((++) "Just ")
                                |> Maybe.withDefault "Nothing"
                                |> Book.logActionWithString "onInput"
                    }
                ]
              )
            ]
        )

module Docs.InputFloat exposing (view)

import Book
import Docs.UI
import W.InputFloat


logAction : W.InputFloat.Value -> Book.Msg
logAction v =
    W.InputFloat.toFloat v
        |> Maybe.map String.fromFloat
        |> Maybe.map ((++) "Just ")
        |> Maybe.withDefault "Nothing"
        |> Book.logActionWithString "onInput"


view : Book.Page model Book.Msg
view =
    Book.page "Input Float"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputFloat.view
                    [ W.InputFloat.placeholder "Type something…"
                    ]
                    { value = W.InputFloat.init (Just 1.0)
                    , onInput = logAction
                    }
                ]
              )

            -- , ( "With Validation"
            --   ,
            --             [ W.InputFloat.viewWithValidation
            --                 [ W.InputFloat.placeholder "Type something…"
            --                 ]
            --                 { value = inputFloat.value2
            --                 , onInput =
            --                     \result v ->
            --                         updateState
            --                             (\model ->
            --                                 let
            --                                     inputFloat_ : Model
            --                                     inputFloat_ =
            --                                         model.inputFloat
            --                                 in
            --                                 { model
            --                                     | inputFloat =
            --                                         { inputFloat_ | value2 = v, validation = Just result }
            --                                 }
            --                             )
            --                 }
            --             , inputFloat.validation
            --                 |> Maybe.map
            --                     (\validation ->
            --                         case validation of
            --                             Ok f ->
            --                                 f
            --                                     |> Maybe.map String.fromFloat
            --                                     |> Maybe.withDefault "Nothing"
            --                                     |> H.text
            --                             Err errors ->
            --                                 H.div
            --                                     []
            --                                     (errors
            --                                         |> List.map
            --                                             (\error -> H.p [] [ H.text (W.InputFloat.errorToString error) ])
            --                                     )
            --                     )
            --                 |> Maybe.withDefault (H.text "")
            --             ]
            --   )
            ]
        )

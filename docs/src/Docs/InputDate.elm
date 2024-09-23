module Docs.InputDate exposing (view)

import Book
import Date
import Docs.UI
import Time
import W.InputDate


logAction : W.InputDate.Value -> Book.Msg
logAction value =
    case W.InputDate.toDate value of
        Just v_ ->
            Book.logAction
                ("Just "
                    ++ Date.toIsoString (Date.fromPosix Time.utc v_)
                    ++ " "
                    ++ String.fromInt (Time.toHour Time.utc v_)
                    ++ ":"
                    ++ String.fromInt (Time.toMinute Time.utc v_)
                )

        Nothing ->
            Book.logAction "Nothing"


view : Book.Page model Book.Msg
view =
    Book.page "Input Date"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputDate.view
                    []
                    { value = W.InputDate.init Time.utc Nothing
                    , onInput = logAction
                    }
                ]
              )
            , ( "Custom Timezone (GMT-3)"
              , let
                    timeZone : Time.Zone
                    timeZone =
                        Time.customZone (-3 * 60) []
                in
                [ W.InputDate.view []
                    { value = W.InputDate.init timeZone (Just <| Time.millisToPosix 1651693959717)
                    , onInput = logAction
                    }
                ]
              )
            , ( "Validation"
              , [ W.InputDate.viewWithValidation
                    [ W.InputDate.min (Time.millisToPosix 1651693959717)
                    , W.InputDate.max (Time.millisToPosix 1671484833575)
                    ]
                    { value = W.InputDate.init Time.utc (Just (Time.millisToPosix 1651693959717))
                    , onInput = \_ -> logAction
                    }
                ]
              )
            ]
        )

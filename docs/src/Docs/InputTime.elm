module Docs.InputTime exposing (view)

import Book
import Docs.UI
import Time
import W.InputTime


logAction : W.InputTime.Value -> Book.Msg
logAction value =
    case W.InputTime.toTime value of
        Just v_ ->
            Book.logAction ("Just " ++ String.fromInt (Time.toHour (W.InputTime.toTimeZone value) v_) ++ ":" ++ String.fromInt (Time.toMinute (W.InputTime.toTimeZone value) v_) ++ ":" ++ String.fromInt (Time.toSecond (W.InputTime.toTimeZone value) v_))

        Nothing ->
            Book.logAction "Nothing"


view : Book.Page model Book.Msg
view =
    Book.page "Input Time"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.InputTime.view
                    []
                    { value = W.InputTime.init Time.utc Nothing
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
                [ W.InputTime.view []
                    { value = W.InputTime.init timeZone (Just (Time.millisToPosix 1651693959717))
                    , onInput = logAction
                    }
                ]
              )
            , ( "Validation"
              , [ W.InputTime.viewWithValidation
                    [ W.InputTime.step 15
                    , W.InputTime.min (Time.millisToPosix 1651693959717)
                    , W.InputTime.max (Time.millisToPosix 1671484833575)
                    ]
                    { value = W.InputTime.init Time.utc (Just (Time.millisToPosix 1651693959717))
                    , onInput = \_ -> logAction
                    }
                ]
              )
            ]
        )

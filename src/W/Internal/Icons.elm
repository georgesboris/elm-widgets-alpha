module W.Internal.Icons exposing (calendar, check, chevronDown, clock, close)

import Html as H
import Html.Attributes as HA
import Svg as S
import Svg.Attributes as SA
import W.Internal.Helpers as WH


close : { size : Int } -> H.Html msg
close props =
    S.svg
        [ SA.width (WH.px props.size)
        , SA.height (WH.px props.size)
        , SA.viewBox "0 0 60.963 60.842"
        ]
        [ S.path
            [ SA.d "M59.595 52.861 37.094 30.359 59.473 7.98a4.676 4.676 0 0 0-6.611-6.611L30.483 23.748 8.105 1.369A4.676 4.676 0 0 0 1.494 7.98l22.378 22.379L1.369 52.861a4.674 4.674 0 0 0 3.306 7.98 4.66 4.66 0 0 0 3.306-1.369L30.483 36.97l22.501 22.502c.913.913 2.109 1.369 3.306 1.369s2.393-.456 3.306-1.369a4.677 4.677 0 0 0-.001-6.611z"
            , SA.fill "currentColor"
            ]
            []
        ]


chevronDown : H.Html msg
chevronDown =
    H.div
        [ HA.class "ew-block ew-h-1.5 ew-w-1.5 ew-border-2 ew-border-current ew-border-solid ew-rotate-[45deg]"
        , HA.style "border-left" "none"
        , HA.style "border-top" "none"
        ]
        []


check : { size : Int } -> S.Svg msg
check props =
    S.svg
        [ SA.width (WH.px props.size)
        , SA.height (WH.px props.size)
        , SA.viewBox "0 0 256 256"
        ]
        [ S.path
            [ SA.d "M243.31,90.91l-128.4,128.4a16,16,0,0,1-22.62,0l-71.62-72a16,16,0,0,1,0-22.61l20-20a16,16,0,0,1,22.58,0L104,144.22l96.76-95.57a16,16,0,0,1,22.59,0l19.95,19.54A16,16,0,0,1,243.31,90.91Z"
            , SA.fill "currentColor"
            ]
            []
        ]


calendar : { size : Int } -> S.Svg msg
calendar props =
    S.svg
        [ SA.width (WH.px props.size)
        , SA.height (WH.px props.size)
        , SA.viewBox "0 0 24 24"
        ]
        [ S.path
            [ SA.fill "none"
            , SA.d "M0 0h24v24H0z"
            ]
            []
        , S.path
            [ SA.d "M17 3h4a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h4V1h2v2h6V1h2v2zm-2 2H9v2H7V5H4v4h16V5h-3v2h-2V5zm5 6H4v8h16v-8z"
            , SA.fill "currentColor"
            ]
            []
        ]


clock : { size : Int } -> S.Svg msg
clock props =
    S.svg
        [ SA.width (WH.px props.size)
        , SA.height (WH.px props.size)
        , SA.viewBox "0 0 24 24"
        ]
        [ S.path
            [ SA.fill "none"
            , SA.d "M0 0h24v24H0z"
            ]
            []
        , S.path
            [ SA.d "M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm1-8h4v2h-6V7h2v5z"
            , SA.fill "currentColor"
            ]
            []
        ]

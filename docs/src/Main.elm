module Main exposing (main)

import Book
import Docs
import Docs.Accordion
import Docs.Avatar
import Docs.Badge
import Docs.Box
import Docs.Button
import Docs.Colors
import Docs.DataRow
import Docs.Divider
import Docs.FormField
import Docs.InputCheckbox
import Docs.InputCode
import Docs.InputColor
import Docs.InputDate
import Docs.InputFloat
import Docs.InputInt
import Docs.InputRadio
import Docs.InputSelect
import Docs.InputSlider
import Docs.InputText
import Docs.InputTextArea
import Docs.InputTime
import Docs.Loading
import Docs.Menu
import Docs.Message
import Docs.Modal
import Docs.Notification
import Docs.Pagination
import Docs.Popover
import Docs.Skeleton
import Docs.Spacing
import Docs.Table
import Docs.Tag
import Docs.Tooltip
import Docs.Typography
import Docs.UI
import W.Styles
import W.Theme
import Color
import W.Theme.Color


theme : W.Theme.Theme
theme =
    W.Theme.darkTheme


book : Book.Book Docs.Model Docs.Msg
book =
    Book.book
        [ Book.theme theme
        , Book.extraHtml
            [ W.Styles.view []
            ]
        ]
        { name = "elm-widgets"
        , content =
            [ Book.chapter "Core"
                [ Docs.Typography.view
                , Docs.Colors.view theme
                , Docs.Spacing.view
                , Docs.Button.view
                ]
            , Book.chapter "Layout"
                [ Docs.Accordion.view
                , Docs.Box.view
                , Docs.DataRow.view
                , Docs.Menu.view
                , Docs.Divider.view
                ]
            , Book.chapter "Tables & Lists"
                [ Docs.UI.viewPlaceholder "Breadcrumbs"
                , Docs.UI.viewPlaceholder "DataList"
                , Docs.Table.view
                , Docs.Pagination.view
                ]
                |> Book.mapMsg Docs.BookMsg
            , Book.chapter "Info & Feedback"
                [ Docs.Avatar.view
                , Docs.Badge.view
                , Docs.Loading.view
                , Docs.Skeleton.view
                , Docs.Message.view
                , Docs.Notification.view
                , Docs.Tag.view
                ]
                |> Book.mapMsg Docs.BookMsg
            , Book.chapter "Overlays"
                [ Docs.Modal.view
                , Docs.Popover.view
                , Docs.Tooltip.view
                ]
                |> Book.mapMsg Docs.BookMsg
            , Book.chapter "Forms & Inputs"
                [ Docs.UI.viewPlaceholder "Form"
                , Docs.FormField.view
                , Docs.InputText.view
                , Docs.InputTextArea.view
                , Docs.InputInt.view
                , Docs.InputFloat.view
                , Docs.InputDate.view
                , Docs.InputTime.view
                , Docs.InputCheckbox.view
                , Docs.InputRadio.view
                , Docs.InputSelect.view
                , Docs.InputSlider.view
                , Docs.InputCode.view
                , Docs.InputColor.view
                ]
                |> Book.mapMsg Docs.BookMsg
            ]
        }


main : Book.Application () Docs.Model Docs.Msg
main =
    Book.application
        { book = book
        , init = Docs.init
        , update = Docs.update
        , subscriptions = Docs.subscriptions
        , effects = Docs.effects
        }


baseColorScale : W.Theme.Color.ColorScale
baseColorScale =
    { bg = primary800
    , bgSubtle = primary850

    -- Tint
    , tint = Color.rgb255 45 50 58
    , tintSubtle = Color.rgb255 41 46 54
    , tintStrong = Color.rgb255 48 54 62

    -- Accent
    , accent = Color.rgb255 85 93 105
    , accentSubtle = Color.rgb255 70 76 87
    , accentStrong = Color.rgb255 101 110 124

    -- Solid
    , solid = Color.rgb255 78 86 100
    , solidSubtle = Color.rgb255 60 67 81
    , solidStrong = Color.rgb255 84 92 106
    , solidText = Color.rgb255 255 255 255

    -- Text
    , text = Color.rgb255 214 222 237
    , textSubtle = Color.rgb255 140 146 158

    -- Text
    , shadow = Color.rgb255 6 11 22
    }

primaryColorScale : W.Theme.Color.ColorScale
primaryColorScale =
    { bg = Color.rgb255 36 41 48
    , bgSubtle = Color.rgb255 30 35 41
    , tint = Color.rgb255 45 50 56
    , tintSubtle = Color.rgb255 42 46 53
    , tintStrong = Color.rgb255 49 54 60
    , accent = Color.rgb255 90 93 98
    , accentSubtle = Color.rgb255 72 76 81
    , accentStrong = Color.rgb255 107 109 114
    , solid = Color.rgb255 223 225 230
    , solidSubtle = Color.rgb255 179 181 186
    , solidStrong = Color.rgb255 238 240 245
    , solidText = Color.rgb255 0 0 0
    , text = Color.rgb255 220 222 226
    , textSubtle = Color.rgb255 143 146 151
    , shadow = Color.rgb255 10 11 14
    }

lightDisabledColorScale : W.Theme.Color.ColorScale
lightDisabledColorScale =
    { bg = primary100
    , bgSubtle = primary100

    -- Tint
    , tint = primary100
    , tintSubtle = primary100
    , tintStrong = primary100

    -- Accent
    , accent = primary100
    , accentSubtle = primary100
    , accentStrong = primary100

    -- Solid
    , solid = primary100
    , solidSubtle = primary100
    , solidStrong = primary100
    , solidText = primary100

    -- Text
    , text = primary100
    , textSubtle = primary100

    -- Text
    , shadow = primary100
    }

darkTheme : W.Theme.Theme
darkTheme =
    W.Theme.darkTheme
        |> W.Theme.withHeadingFont "Inter, system-ui, sans-serif"
        |> W.Theme.withTextFont "Inter, system-ui, sans-serif"
        |> W.Theme.withBaseColor baseColorScale
        |> W.Theme.withPrimaryColor primaryColorScale
        |> W.Theme.withSuccessColor
            { bg = Color.rgb255 36 41 48
            , bgSubtle = Color.rgb255 30 35 41
            , tint = Color.rgb255 40 53 45
            , tintSubtle = Color.rgb255 38 48 47
            , tintStrong = Color.rgb255 41 58 44
            , accent = Color.rgb255 26 111 13
            , accentSubtle = Color.rgb255 33 89 26
            , accentStrong = Color.rgb255 20 134 0
            , solid = Color.rgb255 119 223 59
            , solidSubtle = Color.rgb255 79 183 0
            , solidStrong = Color.rgb255 132 237 76
            , solidText = Color.rgb255 0 0 0
            , text = Color.rgb255 157 251 105
            , textSubtle = Color.rgb255 105 164 78
            , shadow = Color.rgb255 0 22 0
            }
        |> W.Theme.withWarningColor
            { bg = Color.rgb255 36 41 48
            , bgSubtle = Color.rgb255 30 35 41
            , tint = Color.rgb255 50 50 44
            , tintSubtle = Color.rgb255 44 46 46
            , tintStrong = Color.rgb255 56 53 43
            , accent = Color.rgb255 123 84 13
            , accentSubtle = Color.rgb255 94 71 26
            , accentStrong = Color.rgb255 151 97 0
            , solid = Color.rgb255 255 197 61
            , solidSubtle = Color.rgb255 212 156 0
            , solidStrong = Color.rgb255 255 211 79
            , solidText = Color.rgb255 0 0 0
            , text = Color.rgb255 255 214 93
            , textSubtle = Color.rgb255 166 142 70
            , shadow = Color.rgb255 38 0 0
            }
        |> W.Theme.withDangerColor
            { bg = Color.rgb255 36 41 48
            , bgSubtle = Color.rgb255 30 35 41
            , tint = Color.rgb255 57 46 52
            , tintSubtle = Color.rgb255 48 44 50
            , tintStrong = Color.rgb255 65 47 54
            , accent = Color.rgb255 157 43 38
            , accentSubtle = Color.rgb255 118 45 45
            , accentStrong = Color.rgb255 197 41 31
            , solid = Color.rgb255 174 0 2
            , solidSubtle = Color.rgb255 149 0 0
            , solidStrong = Color.rgb255 182 0 13
            , solidText = Color.rgb255 255 255 255
            , text = Color.rgb255 255 167 151
            , textSubtle = Color.rgb255 170 113 107
            , shadow = Color.rgb255 66 0 0
            }


lightTheme : W.Theme.Theme
lightTheme =
    W.Theme.lightTheme
        |> W.Theme.withHeadingFont "Inter, system-ui, sans-serif"
        |> W.Theme.withTextFont "Inter, system-ui, sans-serif"
        |> W.Theme.withBaseColor
            { bg = primary100
            , bgSubtle = primary175

            -- Tint
            , tintSubtle = primary225
            , tint = primary250
            , tintStrong = primary300

            -- Accent
            , accentSubtle = primary250
            , accent = primary300
            , accentStrong = primary350

            -- Solid
            , solidSubtle = primary375
            , solid = primary400
            , solidStrong = primary425
            , solidText = Color.white

            -- Text
            , text = primary750
            , textSubtle = primary450

            -- Shadow
            , shadow = primary750
            }
        |> W.Theme.withPrimaryColor
            { bg = Color.white
            , bgSubtle = primary100

            -- Tint
            , tintSubtle = primary150
            , tint = primary175
            , tintStrong = primary200

            -- Accent
            , accentSubtle = primary250
            , accent = primary300
            , accentStrong = primary350

            -- Solid
            , solidSubtle = primary625
            , solid = primary700
            , solidStrong = primary800
            , solidText = Color.white

            -- Text
            , text = primary750
            , textSubtle = primary450

            -- Shadow
            , shadow = primary750
            }
        |> W.Theme.withSecondaryColor lightDisabledColorScale
        |> W.Theme.withSuccessColor
            { grass
                | bg = Color.rgb255 239 242 239
                , bgSubtle = Color.rgb255 232 238 233

                -- Tint
                , tintSubtle = Color.rgb255 219 233 220
                , tint = Color.rgb255 203 226 205
                , tintStrong = Color.rgb255 185 217 188

                -- Accent
                , accentSubtle = Color.rgb255 185 217 188
                , accent = Color.rgb255 162 206 166
                , accentStrong = Color.rgb255 132 190 138
            }
        |> W.Theme.withWarningColor
            { bg = Color.rgb255 242 241 239
            , bgSubtle = Color.rgb255 245 237 221
            , tintSubtle = Color.rgb255 253 229 181
            , tint = Color.rgb255 254 218 146
            , tintStrong = Color.rgb255 253 212 128
            , accentSubtle = Color.rgb255 252 206 111
            , accent = Color.rgb255 236 194 107
            , accentStrong = Color.rgb255 216 177 93
            , solidSubtle = Color.rgb255 255 208 97
            , solid = Color.rgb255 255 197 61
            , solidStrong = Color.rgb255 255 186 24
            , solidText = Color.rgb255 79 52 34
            , textSubtle = Color.rgb255 171 100 0
            , text = Color.rgb255 79 52 34
            , shadow = Color.rgb255 171 100 0
            }
        |> W.Theme.withDangerColor
            { bg = Color.rgb255 243 240 240
            , bgSubtle = Color.rgb255 242 235 234
            , tintSubtle = Color.rgb255 241 222 220
            , tint = Color.rgb255 247 205 202
            , tintStrong = Color.rgb255 244 190 187
            , accentSubtle = Color.rgb255 244 190 187
            , accent = Color.rgb255 237 174 170
            , accentStrong = Color.rgb255 227 153 149
            , solidSubtle = Color.rgb255 236 83 88
            , solid = Color.rgb255 229 72 77
            , solidStrong = Color.rgb255 220 62 66
            , solidText = Color.rgb255 255 255 255
            , textSubtle = Color.rgb255 206 44 49
            , text = Color.rgb255 100 23 35
            , shadow = Color.rgb255 206 44 49
            }

primary100 : Color.Color
primary100 =
    Color.rgb255 243 244 246


primary150 : Color.Color
primary150 =
    Color.rgb255 235 237 240


primary175 : Color.Color
primary175 =
    Color.rgb255 229 231 235


primary200 : Color.Color
primary200 =
    Color.rgb255 223 225 230


primary225 : Color.Color
primary225 =
    Color.rgb255 220 222 227


primary250 : Color.Color
primary250 =
    Color.rgb255 216 219 225


primary300 : Color.Color
primary300 =
    Color.rgb255 206 210 217


primary350 : Color.Color
primary350 =
    Color.rgb255 180 184 192


primary375 : Color.Color
primary375 =
    Color.rgb255 169 174 183


primary400 : Color.Color
primary400 =
    Color.rgb255 157 163 174


primary425 : Color.Color
primary425 =
    Color.rgb255 144 151 162


primary450 : Color.Color
primary450 =
    Color.rgb255 132 138 150


primary625 : Color.Color
primary625 =
    Color.rgb255 75 82 93


primary700 : Color.Color
primary700 =
    Color.rgb255 48 54 62


primary725 : Color.Color
primary725 =
    Color.rgb255 45 50 58


primary750 : Color.Color
primary750 =
    Color.rgb255 41 46 54


primary800 : Color.Color
primary800 =
    Color.rgb255 36 41 48


primary850 : Color.Color
primary850 =
    Color.rgb255 30 35 41

{-| -}
grass : W.Theme.Color.ColorScale
grass =
    { bg = Color.rgb255 251 254 251
    , bgSubtle = Color.rgb255 245 251 245
    , tintSubtle = Color.rgb255 233 246 233
    , tint = Color.rgb255 218 241 219
    , tintStrong = Color.rgb255 201 232 202
    , accentSubtle = Color.rgb255 178 221 181
    , accent = Color.rgb255 148 206 154
    , accentStrong = Color.rgb255 101 186 116
    , solidSubtle = Color.rgb255 79 177 97
    , solid = Color.rgb255 70 167 88
    , solidStrong = Color.rgb255 62 155 79
    , solidText = Color.rgb255 255 255 255
    , textSubtle = Color.rgb255 42 126 59
    , text = Color.rgb255 32 60 37
    , shadow = Color.rgb255 42 126 59
    }

module Main exposing (main)

import Book
import Docs
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


theme : W.Theme.Theme
theme =
    W.Theme.darkTheme


book : Book.Book Docs.Model Docs.Msg
book =
    Book.book
        [ Book.theme theme
        , Book.extraHtml
            [ W.Styles.view [ W.Styles.borderWidth 1 ]
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
                [ Docs.Box.view
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
            , Book.chapter "Info & Feedback"
                [ Docs.Avatar.view
                , Docs.Badge.view
                , Docs.Loading.view
                , Docs.Skeleton.view
                , Docs.Message.view
                , Docs.Notification.view
                , Docs.Tag.view
                ]
            , Book.chapter "Overlays"
                [ Docs.Modal.view
                , Docs.Popover.view
                , Docs.Tooltip.view
                ]
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
            ]
        }
        |> Book.mapMsg Docs.BookMsg


main : Book.Application () Docs.Model Docs.Msg
main =
    Book.application
        { book = book
        , init = Docs.init
        , update = Docs.update
        , subscriptions = Docs.subscriptions
        , effects = Docs.effects
        }

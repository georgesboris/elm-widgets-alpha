module Docs.Table exposing (view)

import Book
import Docs.UI
import Html as H
import Html.Attributes as HA
import W.Table
import W.Tooltip


data :
    List
        { age : Int
        , score : Float
        , ready : Bool
        , picture : String
        , name : String
        }
data =
    [ { name = "Georges Boris"
      , age = 33
      , score = 85
      , ready = False
      , picture = "https://picsum.photos/100"
      }
    , { name = "Janine Bonfadini"
      , age = 35
      , score = 904.6
      , ready = True
      , picture = "https://picsum.photos/120"
      }
    ]
        |> List.repeat 10
        |> List.concat


view : Book.Page model Book.Msg
view =
    Book.page "Table"
        (List.map Docs.UI.viewExample
            [ ( "Default"
              , [ W.Table.view
                    [ W.Table.onClick (\x -> Book.logAction ("onClick" ++ x.name))
                    , W.Table.onMouseEnter (\x -> Book.logAction ("onMouseEnter" ++ x.name))
                    , W.Table.onMouseLeave (Book.logAction "onMouseLeave")
                    , W.Table.highlight (.age >> (==) 35)
                    ]
                    [ W.Table.column
                        [ W.Table.width 60, W.Table.largeScreenOnly ]
                        { label = "Image"
                        , content =
                            \{ picture } -> H.img [ HA.src picture, HA.height 60 ] []
                        }
                    , W.Table.string
                        [ W.Table.labelLeft [ H.text "L" ]
                        , W.Table.labelRight [ H.text "R" ]
                        ]
                        { label = "Name"
                        , value = .name
                        }
                    , W.Table.int [ W.Table.width 40 ]
                        { label = "Age"
                        , value = .age
                        }
                    , W.Table.float [ W.Table.width 80 ]
                        { label = "Score"
                        , value = .score
                        }
                    , W.Table.bool [ W.Table.width 80 ]
                        { label = "Ready?"
                        , value = .ready
                        }
                    ]
                    data
                ]
              )
            , ( "Groups"
              , [ W.Table.view
                    [ W.Table.groupBy .name
                    , W.Table.groupCollapsed (\_ n -> n == "Janine Bonfadini")
                    , W.Table.onGroupClick (\x -> Book.logAction ("onGroupClick: " ++ x.name))
                    , W.Table.onGroupMouseEnter (\x -> Book.logAction ("onGroupMouseEnter: " ++ x.name))
                    , W.Table.onGroupMouseLeave (Book.logAction "onGroupMouseLeave")
                    , W.Table.maxHeight 32
                    ]
                    [ W.Table.column
                        [ W.Table.width 60, W.Table.largeScreenOnly ]
                        { label = "Image"
                        , content =
                            \{ picture } -> H.img [ HA.src picture, HA.height 60 ] []
                        }
                    , W.Table.string [ W.Table.groupLabel ]
                        { label = "Name"
                        , value = .name
                        }
                    , W.Table.int
                        [ W.Table.width 80
                        , W.Table.groupValue
                            (\_ xs ->
                                xs
                                    |> List.foldl (\x acc -> x.age + acc) 0
                                    |> String.fromInt
                                    |> H.text
                            )
                        ]
                        { label = "Age"
                        , value = .age
                        }
                    , W.Table.float [ W.Table.width 80 ]
                        { label = "Score"
                        , value = .score
                        }
                    , W.Table.bool [ W.Table.width 80 ]
                        { label = "Ready?"
                        , value = .ready
                        }
                    ]
                    data
                ]
              )
            , ( "Custom Column Label"
              , [ W.Table.view
                    [ W.Table.maxHeight 32 ]
                    [ W.Table.string
                        [ W.Table.customLabel
                            [ W.Tooltip.view []
                                { tooltip = [ H.text "Person name" ]
                                , children = [ H.text "Name" ]
                                }
                            ]
                        ]
                        { label = "Name"
                        , value = .name
                        }
                    , W.Table.int
                        [ W.Table.width 80
                        , W.Table.customLabel
                            [ W.Tooltip.view []
                                { tooltip = [ H.text "Person age" ]
                                , children = [ H.text "Age" ]
                                }
                            ]
                        ]
                        { label = "Age"
                        , value = .age
                        }
                    ]
                    [ { name = "João", age = 28 }
                    , { name = "Maria", age = 29 }
                    ]
                ]
              )
            ]
        )

module Docs.Pagination exposing (view)

import Book
import Docs.UI
import Html as H
import W.Pagination


view : Book.Page model Book.Msg
view =
    Book.page "Pagination"
        (List.map Docs.UI.viewExample
            [ ( "Small amount of pages"
              , [ W.Pagination.view []
                    { total = 3
                    , active = 1
                    , onClick = \i -> Book.logAction ("Clicked " ++ String.fromInt i)
                    }
                ]
              )
            , ( "medium amount of pages"
              , [ W.Pagination.view []
                    { total = 8
                    , active = 5
                    , onClick = \i -> Book.logAction ("Clicked " ++ String.fromInt i)
                    }
                ]
              )
            , ( "big number of pages"
              , [ W.Pagination.view [ W.Pagination.separator [ H.text "..." ] ]
                    { total = 9999
                    , active = 10
                    , onClick = \i -> Book.logAction ("Clicked " ++ String.fromInt i)
                    }
                ]
              )
            ]
        )

module Docs.InputSelect exposing (view)

import Book
import Docs.UI
import W.InputSelect


view : Book.Page model Book.Msg
view =
    Book.page "Input Select"
        (List.map Docs.UI.viewExample
            [ ( "Simple"
              , [ W.InputSelect.view
                    []
                    { value = 1
                    , toLabel = String.fromInt
                    , onInput = Book.logActionWith String.fromInt "onInput"
                    , options = [ 1, 2 ]
                    }
                ]
              )
            , ( "Disabled"
              , [ W.InputSelect.view
                    [ W.InputSelect.disabled ]
                    { value = 1
                    , toLabel = String.fromInt
                    , onInput = Book.logActionWith String.fromInt "onInput"
                    , options = [ 1, 2 ]
                    }
                ]
              )
            , ( "With Placeholder"
              , [ W.InputSelect.view
                    []
                    { value = 2
                    , toLabel = String.fromInt
                    , onInput = Book.logActionWith String.fromInt "onInput"
                    , options = [ 1, 2 ]
                    }
                ]
              )
            , ( "With Option Groups"
              , [ W.InputSelect.viewGroups
                    []
                    { value = 2000
                    , toLabel = String.fromInt
                    , onInput = Book.logActionWith String.fromInt "onInput"
                    , options = [ 1900, 2000 ]
                    , optionGroups =
                        [ ( "70's", [ 1978, 1979 ] )
                        , ( "80's", [ 1988, 1989 ] )
                        ]
                    }
                ]
              )
            , ( "With Option Groups (Optional)"
              , [ W.InputSelect.viewGroupsOptional
                    []
                    { value = Nothing
                    , placeholder = "Select a year..."
                    , toLabel = String.fromInt
                    , onInput =
                        \value ->
                            case value of
                                Just value_ ->
                                    Book.logAction ("onInput: Just " ++ String.fromInt value_)

                                Nothing ->
                                    Book.logAction "onInput: Nothing"
                    , options = [ 1900, 2000 ]
                    , optionGroups =
                        [ ( "70's", [ 1978, 1979 ] )
                        , ( "80's", [ 1988, 1989 ] )
                        ]
                    }
                ]
              )
            ]
        )

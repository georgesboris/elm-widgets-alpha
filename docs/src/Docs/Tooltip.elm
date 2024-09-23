module Docs.Tooltip exposing (view)

import Book
import Docs.UI
import Html as H
import W.Box
import W.Spacing
import W.Tooltip


view : Book.Page model Book.Msg
view =
    Book.page "Tooltip"
        (List.map Docs.UI.viewExample
            [ ( "Different Positions"
              , [ Docs.UI.viewHorizontal
                    [ W.Tooltip.view []
                        { tooltip = [ H.text "This is a top tooltip!" ]
                        , children = [ H.text "Top!" ]
                        }
                    , W.Tooltip.view [ W.Tooltip.bottom ]
                        { tooltip = [ H.text "A bottom one!" ]
                        , children = [ H.text "Bottom?" ]
                        }
                    , W.Tooltip.view [ W.Tooltip.right ]
                        { tooltip = [ H.text "A right one!" ]
                        , children = [ H.text "Right!" ]
                        }
                    , W.Tooltip.view [ W.Tooltip.left ]
                        { tooltip = [ H.text "A left one!" ]
                        , children = [ H.text "Left??" ]
                        }
                    ]
                ]
              )
            , ( "Bottom"
              , [ W.Tooltip.view [ W.Tooltip.bottom ]
                    { tooltip = [ H.text "This is a tooltip!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            , ( "Left"
              , [ W.Tooltip.view [ W.Tooltip.left ]
                    { tooltip = [ H.text "This is a tooltip!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            , ( "Right"
              , [ W.Tooltip.view [ W.Tooltip.right ]
                    { tooltip = [ H.text "This is a tooltip!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            , ( "Always Visible"
              , [ W.Tooltip.view [ W.Tooltip.alwaysVisible ]
                    { tooltip = [ H.text "Helloo!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            , ( "Fast"
              , [ W.Tooltip.view [ W.Tooltip.fast ]
                    { tooltip = [ H.text "This is a blazingly fast tooltip!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            , ( "Slow"
              , [ W.Tooltip.view [ W.Tooltip.slow ]
                    { tooltip = [ H.text "This is a sloow tooltip!" ]
                    , children = [ H.text "Hello!" ]
                    }
                ]
              )
            ]
        )

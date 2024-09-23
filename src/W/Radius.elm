module W.Radius exposing
    ( Radius
    , xs, sm, md, lg, xl, xl2, xl3
    , none, custom
    , toCSS
    )

{-|

@docs Radius
@docs xs, sm, md, lg, xl, xl2, xl3
@docs none, custom
@docs toCSS

-}

import W.Internal.Helpers as WH
import W.Theme


{-| -}
type Radius
    = Radius String


{-| -}
none : Radius
none =
    Radius "0px"


{-| -}
xs : Radius
xs =
    Radius W.Theme.radius.xs


{-| -}
sm : Radius
sm =
    Radius W.Theme.radius.sm


{-| -}
md : Radius
md =
    Radius W.Theme.radius.md


{-| -}
lg : Radius
lg =
    Radius W.Theme.radius.lg


{-| -}
xl : Radius
xl =
    Radius W.Theme.radius.xl


{-| -}
xl2 : Radius
xl2 =
    Radius W.Theme.radius.xl2


{-| -}
xl3 : Radius
xl3 =
    Radius W.Theme.radius.xl3


{-| -}
custom : Float -> Radius
custom v =
    Radius (WH.rem v)


{-| -}
toCSS : Radius -> String
toCSS (Radius v) =
    v

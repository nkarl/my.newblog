module Page.Home where

import Prelude

import Component.Footer as Footer
import Component.Header as Header
import Component.PostList as PostList
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Type.Proxy (Proxy(..))

type ChildSlots = (postList :: H.Slot PostList.Query PostList.Output Unit)

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }

render :: forall s a m. MonadAff m => s -> H.ComponentHTML a ChildSlots m
render _ =
  HH.div_
    [ HH.div_ [ Header.component ]
    , HH.slot_ (Proxy :: _ "postList") unit PostList.component unit
    , HH.div_ [ Footer.component ]
    ]

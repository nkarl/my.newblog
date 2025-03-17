module MyUtils where

import Prelude -- ((<<<))

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import Debug (class DebugWarning)
import Debug as Debug
import Effect.Class (class MonadEffect)

className :: forall r i. String -> HH.IProp (class :: String | r) i
className = HP.class_ <<< HH.ClassName

myLog :: forall m a. MonadEffect m => DebugWarning => String -> a -> m a
myLog msg a = do
  --_ <- pure $ Debug.spy msg a
  --pure a
  pure $ Debug.spy msg a

module Capability.Navigate where

import Prelude

import Control.Monad.Trans.Class (lift)
import Data.Route (Route)
import Halogen (HalogenM)

-- | This Capability represents the ability to move around the application.
-- | `navigate` should change the browser location, which will then notify our routing component.
class Monad m <= Navigate m where
  navigate :: Route -> m Unit

instance navigateHalogenM :: Navigate m => Navigate (HalogenM state action slots msg m) where
  navigate = lift <<< navigate

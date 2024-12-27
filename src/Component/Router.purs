module Component.Router where

import Prelude

import Capability.Navigate (class Navigate, navigate)
import Control.Monad.Trans.Class (lift)
import Data.Either (hush)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Route (Route(..), routeCodec)
import Data.Route as Route
import Effect.Aff (Aff, effectCanceler, makeAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Page.Contact as Contact
import Page.Home as Home
import Page.Resume as Resume
import Routing.Duplex (parse, print)
import Routing.Hash (getHash, setHash)
import Type.Proxy (Proxy(..))

data Query a = Navigate Route a

type OpaqueSlot slot = forall q. H.Slot q Void slot

type State =
  { route :: Maybe Route
  }

data Action = Initialize

type PageSlots =
  ( home :: OpaqueSlot Unit
  , resume :: OpaqueSlot Unit
  , contact :: OpaqueSlot Unit
  )

component :: forall m. MonadAff m => H.Component Query Unit Void m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleQuery = handleQuery
        , handleAction = handleAction
        , initialize = Just Initialize
        }
    }

  where
  initialState _ = { route: Nothing }

  handleAction :: Action -> H.HalogenM State Action PageSlots Void m Unit
  handleAction = case _ of
    Initialize -> do
      -- first we'll get the route the user landed on
      initialRoute <- hush <<< (parse routeCodec) <$> liftEffect getHash
      -- then we'll navigate to the new route (also setting the hash)
      _ <- navigate $ fromMaybe Home initialRoute
      pure unit

  handleQuery :: forall a. Query a -> H.HalogenM State Action PageSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate dest a -> do
      --{ route } <- H.get
      H.modify_ _ { route = Just dest }
      pure (Just a)

  render :: forall a. State -> H.ComponentHTML a PageSlots m
  render { route } = case route of
    Just r -> case r of
      Home ->
        HH.slot_ (Proxy :: _ "home") unit Home.component unit
      Resume ->
        HH.slot_ (Proxy :: _ "resume") unit Resume.component unit
      Contact ->
        HH.slot_ (Proxy :: _ "contact") unit Contact.component unit
    Nothing ->
      HH.div_ [ HH.text "Oh no! That page wasn't found." ]

  navigate = liftEffect <<< setHash <<< print Route.routeCodec

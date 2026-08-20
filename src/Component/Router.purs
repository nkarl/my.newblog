module Component.Router where

import Prelude

import Component.Footer as Footer
import Component.Header as Header
import Component.PostDetail as PostDetail
import Data.Either (hush)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Route (Route(..), routeCodec)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Utils (className)
import Routing.Duplex as RouteDuplex
import Routing.Hash (getHash, setHash)
import Type.Proxy (Proxy(..))

import Page.Contact as Contact
import Page.Design as Design
import Page.Home as Home
import Page.Resume as Resume

data Query a = Navigate Route a

type OpaqueSlot slot = forall q. H.Slot q Void slot

type State =
  { route :: Maybe Route
  }

data Action
  = Initialize

type PageSlots =
  ( home :: OpaqueSlot Unit
  , postDetail :: OpaqueSlot String
  , resume :: OpaqueSlot Unit
  , contact :: OpaqueSlot Unit
  , design :: OpaqueSlot Unit
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
      initialRoute <- hush <<< (RouteDuplex.parse routeCodec) <$> liftEffect getHash
      setHashAndGo $ fromMaybe Home initialRoute

  handleQuery :: forall a. Query a -> H.HalogenM State Action PageSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate destination a -> do
      H.modify_ _ { route = Just destination }
      pure (Just a)

  -- render a route with a matching Halogen component
  render :: State -> H.ComponentHTML Action PageSlots m
  render { route } =
    HH.div
      [ className "d-flex min-vh-100 flex-column" ]
      [ Header.component
      , HH.main
          [ className "container-lg py-4 flex-grow-1" ]
          [ case route of
              Just Home -> HH.slot_ (Proxy :: _ "home") unit Home.component unit
              Just Posts -> HH.slot_ (Proxy :: _ "home") unit Home.component unit
              Just (Post id) -> HH.slot_ (Proxy :: _ "postDetail") id PostDetail.component id
              Just Resume -> HH.slot_ (Proxy :: _ "resume") unit Resume.component unit
              Just Contact -> HH.slot_ (Proxy :: _ "contact") unit Contact.component unit
              Just Design -> HH.slot_ (Proxy :: _ "design") unit Design.component unit
              Nothing -> HH.div_ [ HH.text "Oh no! That page wasn't found." ]
          ]
      , Footer.component
      ]

-- | set the route hash and navigate to the destination
setHashAndGo :: forall m. MonadAff m => Route -> H.HalogenM State Action PageSlots Void m Unit
setHashAndGo route = do
  H.modify_ _ { route = Just route }
  H.liftEffect $ setHash $ RouteDuplex.print routeCodec route

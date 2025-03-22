module Component.Router where

import Prelude

import Component.PostList as PostList
import Component.PostDetail as PostDetail
import Data.Either (hush)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Route (Route(..), routeCodec)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Page.Contact as Contact
import Page.Home as Home
import Page.Resume as Resume
import Routing.Duplex as RouteDuplex
import Routing.Hash (getHash, setHash)
import Type.Proxy (Proxy(..))

data Query a = Navigate Route a

type OpaqueSlot slot = forall q. H.Slot q Void slot

type State =
  { route :: Maybe Route
  }

data Action
  = Initialize
  | HandlePostListOutput PostList.Output

type PageSlots =
  ( home :: OpaqueSlot Unit
  , postList :: H.Slot PostList.Query PostList.Output Unit
  , postDetail :: OpaqueSlot String
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
      initialRoute <- hush <<< (RouteDuplex.parse routeCodec) <$> liftEffect getHash
      navigate $ fromMaybe Home initialRoute

    HandlePostListOutput output -> case output of
      PostList.None -> pure unit
      PostList.Navigate route -> navigate route

  handleQuery :: forall a. Query a -> H.HalogenM State Action PageSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate destination a -> do
      H.modify_ _ { route = Just destination }
      pure (Just a)

  -- multiplex a route to various matching Halogen components
  render :: State -> H.ComponentHTML Action PageSlots m
  render { route } = case route of
    Just r -> case r of
      Home ->
        HH.slot_ (Proxy :: _ "home") unit Home.component unit
      Articles ->
        HH.slot (Proxy :: _ "postList") unit PostList.component unit HandlePostListOutput
      Article id ->
        HH.slot_ (Proxy :: _ "postDetail") id PostDetail.component id
      Resume ->
        HH.slot_ (Proxy :: _ "resume") unit Resume.component unit
      Contact ->
        HH.slot_ (Proxy :: _ "contact") unit Contact.component unit
    Nothing ->
      HH.div_ [ HH.text "Oh no! That page wasn't found." ]

-- | navigate to the destination by setting the route hash 
navigate :: forall m. MonadAff m => Route -> H.HalogenM State Action PageSlots Void m Unit
navigate route = do
  H.modify_ _ { route = Just route }
  H.liftEffect $ setHash $ RouteDuplex.print routeCodec route

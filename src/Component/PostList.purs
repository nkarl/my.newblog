module Component.PostList where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Post (Post(..))
import Effect.Aff.Class (class MonadAff)
import Firebase (fetchPosts)
import Foreign.Object as FO
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type State =
  { posts :: Maybe (FO.Object Post)
  , error :: Maybe String
  }

data Action = Initialize

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

initialState :: forall i. i -> State
initialState _ =
  { posts: Nothing
  , error: Nothing
  }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ (H.ClassName "post-list") ]
    [ case state.error, state.posts of
        Just err, _ -> HH.div_ [ HH.text $ "Error: " <> err ]
        _, Nothing -> HH.div_ [ HH.text "Loading posts..." ]
        _, Just posts ->
          HH.ul_ $
            map renderPost (FO.values posts)
    ]

renderPost :: forall m. Post -> H.ComponentHTML Action () m
renderPost (Post post) =
  HH.li_
    [ HH.h3_ [ HH.text post.title ]
    , HH.p_ [ HH.text $ "ID: " <> post.id ]
    , HH.pre_ [ HH.text post.content ] -- Raw content for quick test
    , HH.p_ [ HH.text $ "Type: " <> postType ]
    , HH.p_ [ HH.text $ "Created: " <> show post.createdAt ]
    ]
  where
  postType = case post.type of
    Nothing -> ""
    Just a -> show a

handleAction :: forall o m. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction Initialize = do
  result <- H.liftAff fetchPosts
  case result of
    Left err -> H.modify_ \st -> st { error = Just err }
    Right posts -> H.modify_ \st -> st { posts = Just posts }

module Component.PostDetail where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Firebase (fetchPost)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Data.Post (Post(..))

type State =
  { post :: Maybe Post
  , error :: Maybe String
  , postId :: String
  }

data Action = Initialize

component :: forall q m. MonadAff m => H.Component q String Void m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

initialState :: String -> State
initialState postId =
  { post: Nothing
  , error: Nothing
  , postId
  }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ (H.ClassName "post-detail") ]
    [ case state.error, state.post of
        Just err, _ -> HH.div_ [ HH.text $ "Error: " <> err ]
        _, Nothing -> HH.div_ [ HH.text $ "Loading post " <> state.postId <> "..." ]
        _, Just (Post post) -> -- Destructure Post here
          let
            postType = case post.type of -- Now post is in scope
              Nothing -> ""
              Just a -> a
          in
            HH.div_
              [ HH.h1_ [ HH.text post.title ]
              , HH.p_ [ HH.text $ "ID: " <> post.id ]
              , HH.pre_ [ HH.text post.content ]
              , HH.p_ [ HH.text $ "Type: " <> postType ]
              , HH.p_ [ HH.text $ "Created: " <> show post.createdAt ]
              ]
    ]

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Void m Unit
handleAction Initialize = do
  state <- H.get
  result <- H.liftAff $ fetchPost state.postId
  case result of
    Left err -> H.modify_ \st -> st { error = Just err }
    Right post -> H.modify_ \st -> st { post = Just post }

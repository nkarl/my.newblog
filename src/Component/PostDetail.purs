module Component.PostDetail where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Firebase (fetchPostById)
import Halogen as H
import Halogen.HTML as HH
import Data.PostData (PostData(..))
import Effect.Class.Console (log) -- Add this
import MyUtils (className)

type State =
  { post :: Maybe PostData
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

  where
  initialState :: String -> State
  initialState postId =
    { post: Nothing
    , error: Nothing
    , postId
    }

  handleAction :: MonadAff m => Action -> H.HalogenM State Action () Void m Unit
  handleAction Initialize = do
    H.liftEffect $ log "Initializing PostDetail" -- Add this
    state <- H.get
    result <- H.liftAff $ fetchPostById state.postId
    case result of
      Left err -> H.modify_ \st -> st { error = Just err }
      Right post -> H.modify_ \st -> st { post = Just post }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ className "post-detail container" ]
    [ HH.div_ $ case state.error, state.post of
        Just err, _ ->
          [ HH.text $ "Error: " <> err ]

        _, Nothing ->
          [ HH.text $ "Loading post " <> state.postId <> "..." ]

        _, Just (PostData post) ->
          [ HH.h1
              [ className "my-4" ]
              [ HH.text post.title ]
          , HH.p
              [ className "text-muted" ]
              [ HH.text $ "Published: " <> fromMaybe "Unknown" post.pubDate ]
          , HH.p
              [ className "lead" ]
              [ HH.text $ "Description: " <> post.description ]
          , HH.p
              [ className "text-muted" ]
              [ HH.text $ "ID: " <> post.id ]
          , HH.p
              [ className "text-muted" ]
              [ HH.text $ "Type: " <> fromMaybe "None" post.type ]
          , HH.p
              [ className "text-muted" ]
              [ HH.text $ "Created: " <> show post.createdAt ]
          -- NOTE: Change style later to display HTML instead of MD in pre / code
          , HH.pre
              [ className "content" ]
              [ HH.text post.content ]
          ]
    ]

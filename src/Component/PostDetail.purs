module Component.PostDetail where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Firebase (fetchPostById)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Data.Post (Post(..))
import Effect.Class.Console (log) -- Add this

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
  HH.div [ HP.class_ (H.ClassName "post-detail container") ]
    [ HH.text "Rendering PostDetail" -- Add this
    , case state.error, state.post of
        Just err, _ -> HH.div_ [ HH.text $ "Error: " <> err ]
        _, Nothing -> HH.div_ [ HH.text $ "Loading post " <> state.postId <> "..." ]
        _, Just (Post post) ->
          HH.div_
            [ HH.h1 [ HP.class_ (H.ClassName "my-4") ] [ HH.text post.title ]
            , HH.p [ HP.class_ (H.ClassName "text-muted") ]
                [ HH.text $ "Published: " <> fromMaybe "Unknown" post.pubDate ]
            , HH.p [ HP.class_ (H.ClassName "lead") ] [ HH.text post.description ]
            , HH.pre [ HP.class_ (H.ClassName "content") ] [ HH.text post.content ]
            , HH.p [ HP.class_ (H.ClassName "text-muted") ]
                [ HH.text $ "ID: " <> post.id ]
            , HH.p [ HP.class_ (H.ClassName "text-muted") ]
                [ HH.text $ "Type: " <> fromMaybe "None" post.type ]
            , HH.p [ HP.class_ (H.ClassName "text-muted") ]
                [ HH.text $ "Created: " <> show post.createdAt ]
            ]
    ]

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Void m Unit
handleAction Initialize = do
  H.liftEffect $ log "Initializing PostDetail" -- Add this
  state <- H.get
  result <- H.liftAff $ fetchPostById state.postId
  case result of
    Left err -> H.modify_ \st -> st { error = Just err }
    Right post -> H.modify_ \st -> st { post = Just post }

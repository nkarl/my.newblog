module Component.PostDetail where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Data.Posts (fetchPostById)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Data.PostData (PostData(..))
import Utils (className)

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
    state <- H.get
    result <- H.liftAff $ fetchPostById state.postId
    case result of
      Left err -> H.modify_ \st -> st { error = Just err }
      Right post -> H.modify_ \st -> st { post = Just post }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.article [ className "col-lg-8 mx-auto" ]
    [ HH.div_ $ case state.error, state.post of
        Just err, _ ->
          [ HH.div [ className "alert alert-danger" ] [ HH.text $ "Error: " <> err ] ]

        _, Nothing ->
          [ HH.div
              [ className "d-flex align-items-center gap-2 text-body-secondary" ]
              [ HH.div
                  [ className "spinner-border spinner-border-sm"
                  , HP.attr (H.AttrName "role") "status"
                  , HP.attr (H.AttrName "aria-hidden") "true"
                  ]
                  []
              , HH.text $ "Loading post " <> state.postId <> "…"
              ]
          ]

        _, Just (PostData post) ->
          [ HH.h1
              [ className "my-4" ]
              [ HH.text post.title ]
          , HH.p
              [ className "text-body-secondary mb-1" ]
              [ HH.text $ "Published: " <> fromMaybe "Unknown" post.pubDate ]
          , HH.p
              [ className "lead" ]
              [ HH.text $ "Description: " <> post.description ]
          , HH.div
              [ className "post-content mt-4"
              , HP.prop (H.PropName "innerHTML") post.content
              ]
              []
          ]
    ]

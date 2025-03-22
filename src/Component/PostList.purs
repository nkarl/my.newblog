module Component.PostList where

import Prelude

import Data.Array (reverse)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.PostData (PostData(..))
import Data.Route (Route(..))
import Effect.Aff.Class (class MonadAff)
import Firebase (fetchPosts)
import Foreign.Object as FO
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

import MyUtils (className)

type State =
  { posts :: Maybe (FO.Object PostData)
  , error :: Maybe String
  }

data Query a = NoOp a
data Action
  = Initialize
  | NavigateToArticle String

data Output
  = None
  | Navigate Route

component :: forall i m. MonadAff m => H.Component Query i Output m
component =
  H.mkComponent
    { initialState: \_ -> { posts: Nothing, error: Nothing }
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        , initialize = Just Initialize
        }
    }

  where
  handleAction :: MonadAff m => Action -> H.HalogenM State Action () Output m Unit
  handleAction = case _ of
    Initialize -> do
      result <- H.liftAff fetchPosts
      case result of
        Left err -> H.modify_ \st -> st { error = Just err }
        Right posts -> H.modify_ \st -> st { posts = Just posts }

    NavigateToArticle postId -> do
      H.raise $ Navigate (Article postId)

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ className "post-list container" ]
    [ case state.error, state.posts of
        Just err, _ ->
          HH.div_ [ HH.text $ "Error: " <> err ]
        _, Nothing ->
          HH.div_ [ HH.text "Loading posts..." ]
        _, Just posts ->
          HH.div_
            [ HH.div
                [ className "row fw-bold border-bottom py-2" ]
                [ HH.div
                    [ className "col-8" ]
                    [ HH.text "Title" ]
                , HH.div
                    [ className "col-4 text-end" ]
                    [ HH.text "Published" ]
                ]
            -- renders the post records as rows
            , HH.div_ $
                renderPost <$> reverse (FO.values posts)
            ]
    ]

-- | render a single post as a row with 2 columns, `title` and and `pubDate`
renderPost :: forall m. PostData -> H.ComponentHTML Action () m
renderPost (PostData post) =
  HH.div [ className "row py-2 border-bottom" ]
    [ HH.div
        [ className "col-8" ]
        [ HH.h4_
            [ HH.a
                [ HP.href "#"
                , HE.onClick \_ -> NavigateToArticle post.id
                ]
                [ HH.text post.title ]
            ]
        ]
    , HH.div
        [ className "col-4 text-end" ]
        [ HH.text $ fromMaybe "Unknown" post.pubDate ]
    ]

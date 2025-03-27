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
  | NavigateToPost String

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
  -- TODO: add pagination
  handleAction :: MonadAff m => Action -> H.HalogenM State Action () Output m Unit
  handleAction = case _ of
    Initialize -> do
      result <- H.liftAff fetchPosts
      case result of
        Left err -> H.modify_ \st -> st { error = Just err }
        Right posts -> H.modify_ \st -> st { posts = Just posts }

    NavigateToPost postId -> do
      H.raise $ Navigate (Posts (Just postId))

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
            , HH.div_ $
                -- NOTE: iterate and render posts as rows
                renderPost <$> reverse (FO.values posts)
            ]
    ]

-- | render a single post as a row with 2 columns, `title` and and `pubDate`
renderPost :: forall m. PostData -> H.ComponentHTML Action () m
renderPost (PostData post) =
  HH.div [ className "row py-2 border-bottom" ]
    -- first column, span 8
    [ HH.div
        [ className "col-8" ]
        [ HH.h4_
            [ HH.a
                [ HP.href "#"
                , HE.onClick \_ -> NavigateToPost post.id
                ]
                [ HH.text post.title ]
            ]
        ]
    -- second column, span 4
    , HH.div
        [ className "col-4 text-end" ]
        [ HH.pre_
            [ HH.text $ fromMaybe "Unknown" post.pubDate ]
        ]
    ]

module Component.PostList where

import Prelude

import Data.Array (sortBy)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.PostData (PostData(..))
import Data.Route (Route(..), routeCodec)
import Effect.Aff.Class (class MonadAff)
import Data.Posts (fetchPosts)
import Foreign.Object as FO
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Routing.Duplex as RouteDuplex

import Utils (className)

type State =
  { posts :: Maybe (FO.Object PostData)
  , error :: Maybe String
  }

data Action = Initialize

component :: forall q i m. MonadAff m => H.Component q i Void m
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
  handleAction :: MonadAff m => Action -> H.HalogenM State Action () Void m Unit
  handleAction = case _ of
    Initialize -> do
      result <- H.liftAff fetchPosts
      case result of
        Left err -> H.modify_ \st -> st { error = Just err }
        Right posts -> H.modify_ \st -> st { posts = Just posts }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.section [ className "col-lg-10 mx-auto" ]
    [ case state.error, state.posts of
        Just err, _ ->
          HH.div [ className "alert alert-danger" ] [ HH.text $ "Error: " <> err ]
        _, Nothing ->
          HH.div
            [ className "d-flex align-items-center gap-2 text-body-secondary" ]
            [ HH.div
                [ className "spinner-border spinner-border-sm"
                , HP.attr (H.AttrName "role") "status"
                , HP.attr (H.AttrName "aria-hidden") "true"
                ]
                []
            , HH.text "Loading posts…"
            ]
        _, Just posts ->
          if FO.isEmpty posts then
            HH.div [ className "alert alert-secondary" ] [ HH.text "No posts have been published yet." ]
          else HH.div_
            [ HH.div
                [ className "row d-none d-sm-flex fw-bold text-body-secondary text-uppercase small border-bottom py-2" ]
                [ HH.div
                    [ className "col-sm-8" ]
                    [ HH.text "Title" ]
                , HH.div
                    [ className "col-sm-4 text-sm-end" ]
                    [ HH.text "Published" ]
                ]
            , HH.div_ $
                -- NOTE: iterate and render posts as rows
                renderPost <$> sortBy newestFirst (FO.values posts)
            ]
    ]

-- | render a single post as a row with 2 columns, `title` and and `pubDate`
renderPost :: forall m. PostData -> H.ComponentHTML Action () m
renderPost (PostData post) =
  HH.article [ className "row align-items-baseline border-bottom py-3" ]
    [ HH.div
        [ className "col-12 col-sm-8" ]
        [ HH.h3
            [ className "h5 mb-1" ]
            [ HH.a
                [ HP.href $ "#" <> RouteDuplex.print routeCodec (Post post.id) ]
                [ HH.text post.title ]
            ]
        ]
    , HH.div
        [ className "col-12 col-sm-4 text-body-secondary text-sm-end small" ]
        [ HH.text $ fromMaybe "Unknown" post.pubDate ]
    ]

newestFirst :: PostData -> PostData -> Ordering
newestFirst (PostData left) (PostData right) =
  compare right.createdAt left.createdAt

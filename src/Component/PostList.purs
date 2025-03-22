module Component.PostList where

import Prelude

import Data.Array (reverse)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
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

data Query a = NoOp a -- placeholder for now
data Action = Initialize
data Output = None -- placeholder for now

component :: forall i m. MonadAff m => H.Component Query i Output m
component =
  H.mkComponent
    { initialState: \_ -> { posts: Nothing, error: Nothing }
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ (H.ClassName "post-list container") ]
    [ case state.error, state.posts of
        Just err, _ -> HH.div_ [ HH.text $ "Error: " <> err ]
        _, Nothing -> HH.div_ [ HH.text "Loading posts..." ]
        _, Just posts ->
          HH.div_
            [ HH.div [ HP.class_ (H.ClassName "row fw-bold border-bottom py-2") ] -- Header row
                [ HH.div [ HP.class_ (H.ClassName "col-10") ] [ HH.text "Title" ]
                --, HH.div [ HP.class_ (H.ClassName "col") ] [ HH.text "ID" ]
                --, HH.div [ HP.class_ (H.ClassName "col") ] [ HH.text "Type" ]
                , HH.div [ HP.class_ (H.ClassName "col-2") ] [ HH.text "Published" ]
                ]
            , HH.div_ $ renderPost <$> reverse (FO.values posts) -- Post rows
            ]
    ]

renderPost :: forall m. Post -> H.ComponentHTML Action () m
renderPost (Post post) =
  HH.div [ HP.class_ (H.ClassName "row py-2 border-bottom") ]
    [ HH.div [ HP.class_ (H.ClassName "col-10") ] [ HH.h3_ [ HH.text post.title ] ]
    --, HH.div [ HP.class_ (H.ClassName "col") ] [ HH.text post.id ]
    --, HH.div [ HP.class_ (H.ClassName "col") ] [ HH.text postType ]
    , HH.div [ HP.class_ (H.ClassName "col-2") ] [ HH.text $ fromMaybe "Unknown" post.pubDate ]
    ]

--where
--postType = case post.type of
--Nothing -> ""
--Just a -> show a

handleAction :: forall o m. MonadAff m => Action -> H.HalogenM State Action () o m Unit
handleAction Initialize = do
  result <- H.liftAff fetchPosts
  case result of
    Left err -> H.modify_ \st -> st { error = Just err }
    Right posts -> H.modify_ \st -> st { posts = Just posts }

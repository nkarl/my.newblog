module Page.Contact where

import Prelude

import Component.PlaceholderPage as PlaceholderPage
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
    }
  where
  render _ =
    placeholder

placeholder :: forall i p. HH.HTML i p
placeholder = PlaceholderPage.view
  "This is the Contact page."
  "It should display a list of contact details."

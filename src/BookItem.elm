module BookItem where

import Html exposing (Html, span, li, button, text)
import Html.Events exposing (..)

-- Model

type alias Model =
  { id: ID
  , title: String
  }
type alias ID = Int

-- Update

type Action
  = AddToCart

update action model =
  case action of
    AddToCart -> model

-- View

type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }

-- view : Context -> Model -> Html
view context model =
  let bookText = model.title ++ " (" ++ toString model.id ++ ") "
  in
    li []
      [ span [] [ text bookText ]
      , button [ onClick context.actions AddToCart ] [ text "Add to cart" ]
      , button [ onClick context.remove () ] [ text "x" ]
      ]

module BookItem where

import Html exposing (Html, span, li, button, text)
import Html.Events exposing (..)

-- Model

type alias Model =
  { id: Int
  , title: String
  }

-- View

type alias Context =
  { remove : Signal.Address () }

view : Context -> Model -> Html
view context model =
  let bookText = model.title ++ " (" ++ toString model.id ++ ") "
  in
    li []
      [ span [] [ text bookText ]
      , button [ onClick context.remove () ] [ text "x" ]
      ]

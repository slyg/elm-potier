module BookList where

import Html exposing (div, ul, li, button, text)
import Html.Events exposing (..)
import List exposing (append)

-- Model

type alias Model = {
  books: List (String)
}

init = { books = ["coucou", "haha"] }

-- View

view address model =
  let books = List.map bookItem model.books
  in
    div []
      [ ul [] books
      , button [ onClick address AddRandomBook ] [text "Add book"]
      ]


bookItem book = li [] [ text book ]

-- Update

type Action = AddRandomBook | Noop

update : Action -> Model -> Model
update action model =
  case action of
    Noop ->
      model
    AddRandomBook ->
      { model |
          books = append model.books ["random book"]
      }

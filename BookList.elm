module BookList where

import Html exposing (div, span, ul, li, button, text)
import Html.Events exposing (..)
import List exposing (append)

-- Model

type alias Model =
  { books: List (Book)
  , nextId: ID
  }

type alias Book =
  { id: Int
  , title: String
  }
type alias ID = Int

init =
  { books =
    [ {id = 0, title = "Henri"}
    , {id = 1, title = "Henri 2 le retour"}
    ]
  , nextId = 2
  }

-- Update

type Action = AddRandomBook
            | RemoveBook
            | Noop

update : Action -> Model -> Model
update action model =
  case action of
    Noop ->
      model
    AddRandomBook ->
      let newBook =
        { id = model.nextId
        , title = "random"
        }
      in { model |
          books = append model.books [newBook],
          nextId = model.nextId + 1
      }
    RemoveBook ->
      model


-- View

view address model =
  let books = List.map bookItem model.books
  in
    div []
      [ ul [] books
      , button [ onClick address AddRandomBook ] [text "Add book"]
      ]


bookItem book =
  let bookText = book.title ++ " (" ++ toString book.id ++ ")"
  in
    li []
      [ span [] [ text bookText ]
      -- , button [ onClick address RemoveBook ] [ text "x" ]
      ]

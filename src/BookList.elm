module BookList where

import Html exposing (Html, div, span, ul, button, text)
import Html.Events exposing (..)

import BookItem

-- Model

type alias Model =
  { books: List (BookItem.Model)
  , nextId: ID
  }

type alias ID = Int

init : Model
init =
  { books =
    [ {id = 0, title = "Henri 1er de la classe"}
    , {id = 1, title = "Henri 2 le retour"}
    ]
  , nextId = 2
  }

-- Update

type Action = AddRandomBook
            | RemoveBook ID
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
          books = model.books ++ [newBook],
          nextId = model.nextId + 1
      }
    RemoveBook id ->
      { model |
        books = List.filter (\book -> book.id /= id) model.books
      }

-- View

view : Signal.Address Action -> Model -> Html
view address model =
  let books = List.map (viewBookItem address) model.books
  in
    div []
      [ button [ onClick address AddRandomBook ] [text "Add book"]
      , ul [] books
      ]

viewBookItem : Signal.Address Action -> BookItem.Model -> Html
viewBookItem address model =
  let context =
    BookItem.Context (Signal.forwardTo address (always (RemoveBook model.id)))
  in
    BookItem.view context model

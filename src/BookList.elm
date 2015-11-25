module BookList where

import Html exposing (Html, div, span, ul, button, text)
import Html.Events exposing (..)

import BookItem

-- Model

type alias Model =
  { books: List (BookItem.Model)
  , nextId: BookItem.ID
  }

-- Update

type Action
  = AddRandomBook
  | RemoveBook BookItem.ID
  | AddToCart BookItem.ID BookItem.Action
  | NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
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

    AddToCart id bookItemAction ->
      model

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
  let context = BookItem.Context
        (Signal.forwardTo address (AddToCart model.id))
        (Signal.forwardTo address (always (RemoveBook model.id)))
  in
    BookItem.view context model

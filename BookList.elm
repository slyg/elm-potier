module BookList where

import Html exposing (ul, li, text)

-- Model

type alias Model = {
  books: List (String)
}

init = { books = ["coucou", "haha"] }

-- View

view address model =
  let books = List.map bookItem model.books
  in
    ul [] books


bookItem book = li [] [ text book ]

-- Update

update action model = model

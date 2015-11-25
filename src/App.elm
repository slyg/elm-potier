module App where

import Html exposing (..)
import Html.Events exposing (..)
import List

-- Model

type alias Model =
  { books: List (BookItem)
  , cart: List (CartItem)
  , nextId: ID
  }

type alias BookItem =
  { id: ID
  , title: String
  }
type alias CartItem =
  { id: ID
  , bookId: ID
  , title: String
  , amount: Int
  }

type alias ID = Int

init : Model
init =
  { books = []
  , cart = []
  , nextId = 0
  }

newBookItem id title =
  { id = id
  , title = title
  }

newCartItem id bookId title =
  { id = id
  , title = title
  , bookId = bookId
  , amount = 1
  }

-- Update

type Action
  = NoOp
  | AddRandomBook
  | RemoveBook ID
  | AddToCart BookItem

update action model =
  case action of

    NoOp -> model

    AddRandomBook ->
      { model |
        books = model.books ++ [newBookItem model.nextId "Any book title"],
        nextId = model.nextId + 1
      }

    RemoveBook id ->
      { model |
        books = List.filter (\book -> book.id /= id) model.books
      }

    AddToCart book ->
      let matchInCart = (\cartItem -> cartItem.bookId == book.id)
          updateCartItem cartItem =
            if cartItem.bookId == book.id
              then { cartItem | amount = cartItem.amount + 1 }
              else cartItem
          newCart =
            if List.any matchInCart model.cart
              then List.map updateCartItem model.cart
              else model.cart ++ [newCartItem model.nextId book.id book.title]
      in
        { model |
          cart = newCart,
          nextId = model.nextId + 1
        }

-- View

view address model =
  div []
    [ viewBookList address model
    , viewCart address model.cart
    ]

viewBookList : Signal.Address Action -> Model -> Html
viewBookList address model =
  let books = List.map (viewBookItem address) model.books
  in
    div []
      [ button [ onClick address AddRandomBook ] [text "Add book"]
      , ul [] books
      ]

viewBookItem : Signal.Address Action -> BookItem -> Html
viewBookItem address model =
  li []
    [ span [] [ text (model.title ++ " - with id " ++ toString model.id ++ " ") ]
    , button [ onClick address (AddToCart model) ] [ text "Add to cart" ]
    , button [ onClick address (RemoveBook model.id) ] [ text "x" ]
    ]

viewCart : Signal.Address Action -> List(CartItem) -> Html
viewCart address model =
  let books = List.map (viewCartItem address) model
  in
    ul [] books

viewCartItem : Signal.Address Action -> CartItem -> Html
viewCartItem address model =
  li []
  [ span [] [text model.title]
  , span [] [text (" (x" ++ (toString model.amount) ++ ")")]
  ]

module App where

import Html exposing (..)
import Html.Events exposing (..)
import List exposing (map, any, filter)

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
  , book: BookItem
  , amount: Int
  }

type alias ID = Int

init : Model
init =
  { books = []
  , cart = []
  , nextId = 0
  }

-- Common Factories

newBookItem : ID -> String -> BookItem
newBookItem id title =
  { id = id
  , title = title
  }

-- Update

type Action
  = AddRandomBooks
  | AddToCart BookItem
  | RemoveFromCart BookItem

update action model =
  case action of

    AddRandomBooks ->
      let
        numberOfItems = 5
      in
        { model |
          books =
            model.books
              ++ map (\id -> newBookItem id "Any book title") [model.nextId..model.nextId + numberOfItems - 1],
            nextId = model.nextId + numberOfItems
        }

    AddToCart book ->
      let
        matchInCart = (\cartItem -> cartItem.book.id == book.id)
        newCartItem id bookId title =
          { id = id
          , book = newBookItem bookId title
          , amount = 1
          }
        updateCartItem cartItem =
          if cartItem.book.id == book.id
            then { cartItem | amount = cartItem.amount + 1 }
            else cartItem
        newCart =
          if any matchInCart model.cart
            then map updateCartItem model.cart
            else model.cart ++ [newCartItem model.nextId book.id book.title]
      in
        { model |
          cart = newCart,
          nextId = model.nextId + 1
        }

    RemoveFromCart book ->
      { model |
        cart = filter (\cartItem -> cartItem.book.id /= book.id) model.cart
      }

-- View

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ viewBookList address model
    , viewCart address model.cart
    ]

viewBookList : Signal.Address Action -> Model -> Html
viewBookList address model =
  let
    books = map (viewBookItem address) model.books
  in
    div []
      [ button [ onClick address AddRandomBooks ] [text "Add books"]
      , ul [] books
      ]

viewBookItem : Signal.Address Action -> BookItem -> Html
viewBookItem address model =
  li []
    [ span [] [ text (model.title ++ " - with id " ++ toString model.id ++ " ") ]
    , button [ onClick address (AddToCart model) ] [ text "Add to cart" ]
    ]

viewCart : Signal.Address Action -> List(CartItem) -> Html
viewCart address model =
  let
    books = map (viewCartItem address) model
  in
    ul [] books

viewCartItem : Signal.Address Action -> CartItem -> Html
viewCartItem address model =
  li []
  [ span [] [text model.book.title]
  , span [] [text (" " ++ (toString model.book.id))]
  , span [] [text (" (x" ++ (toString model.amount) ++ ")")]
  , button [ onClick address (RemoveFromCart model.book) ] [ text "x" ]
  ]

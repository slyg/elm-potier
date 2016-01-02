module App where

import Html exposing (Html, div, button, ul, li, span, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import List exposing (map, any, filter)

-- Models

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

newCartItem : ID -> ID -> String -> CartItem
newCartItem id bookId title =
  { id = id
  , book = newBookItem bookId title
  , amount = 1
  }

-- Updates

type Action
  = AddRandomBooks
  | AddToCart BookItem
  | RemoveFromCart BookItem

update action model =
  case action of

    AddRandomBooks ->
      let
        numberOfItems = 5
        newBook index = newBookItem (model.nextId + index) "Any book title"

      in
        { model |
            books = model.books ++ map newBook [1..numberOfItems],
            nextId = model.nextId + numberOfItems
        }

    AddToCart book ->
      let
        matchInCart = (\cartItem -> cartItem.book.id == book.id)

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
      let
        withoutBook = (\cartItem -> cartItem.book.id /= book.id)
      in
        { model | cart = filter withoutBook model.cart }

-- Views

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
      [ button [ onClick address AddRandomBooks ] [ text "Add books" ]
      , ul [] books
      ]

viewBookItem : Signal.Address Action -> BookItem -> Html
viewBookItem address model =
  li
    [ onClick address (AddToCart model)
    , style [ ("cursor", "pointer") ]
    ]
    [ text (model.title ++ " - with id " ++ toString model.id ++ " ") ]

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

module App where
import Html exposing (Html, div)
import BookList
import Cart

-- Model

type alias Model =
  { bookList: BookList.Model
  , cart: Cart.Model
  }

init : Model
init =
  { bookList =
    { books =
      [ {id = 0, title = "Henri 1er de la classe"}
      , {id = 1, title = "Henri 2 le retour"}
      ]
    , nextId = 2
    }
  , cart = ["Henri 1er de la classe"]
  }

-- Update

type Action
  = BookListChange BookList.Action
  | Noop

update action model =
  case action of
    Noop ->
      model
    BookListChange act ->
      { model |
        bookList = BookList.update act model.bookList
      }

-- View

view address model =
  div []
    [ BookList.view (Signal.forwardTo address BookListChange) model.bookList
    , Cart.view address model.cart
    ]

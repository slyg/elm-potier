module Cart where

import Html exposing (Html, div, ul, li, text)

-- Model

type alias Model = List (CartItem)

type alias CartItem = String

init : Model
init = ["Coucou"]

-- View

view address model = 
  let books = List.map (viewBookItem address) model
  in
    ul [] books

viewBookItem address model = li [] [ text model ]

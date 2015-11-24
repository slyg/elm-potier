import StartApp.Simple as StartApp
import BookList exposing (update, view, init)

main =
  StartApp.start
    { view = view
    , update = update
    , model = init
    }

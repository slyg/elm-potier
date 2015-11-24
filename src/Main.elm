import StartApp.Simple as StartApp
import App exposing (update, view, init)

main =
  StartApp.start
    { view = view
    , update = update
    , model = init
    }

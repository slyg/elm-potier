import StartApp.Simple as StartApp
import App exposing (update, view, init, Model)

model = init

main =
  StartApp.start
    { view = view
    , update = update
    , model = model
    }

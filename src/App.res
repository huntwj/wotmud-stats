%%raw(`import './App.css';`)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)

  let url = RescriptReactRouter.useUrl()

  let body = switch url.path {
  | list{"homelands"} => <div> {`Homelands`->React.string} </div>
  | list{"homelands", homeland} => <div> {`View Homeland Data for ${homeland}`->React.string} </div>
  | list{"classes"} => <div> <AllClasses classes={state.classes} /> </div>
  | list{"classes", class} => <div> {`Class Data for ${class}`->React.string} </div>
  | list{} => <div> {"Home page"->React.string} </div>
  | _ => <div> {"Page not found"->React.string} </div>
  }

  <div> <NavBar /> {body} </div>
}

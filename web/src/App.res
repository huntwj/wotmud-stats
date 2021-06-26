%%raw(`import './App.css';`)

open Belt

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)

  let url = RescriptReactRouter.useUrl()

  let allStattedChars =
    state.stattedChars
    ->Map.String.valuesToArray
    ->Js.Array2.filter(stattedChar => stattedChar.homelandId == "1" && stattedChar.classId == "1")

  let body = switch url.path {
  | list{"stats"} => <StatsTable stattedChars={allStattedChars} />
  | list{"homelands"} => <AllHomelands homelands={state.homelands} />
  | list{"homelands", homeland} => <div> {`View Homeland Data for ${homeland}`->React.string} </div>
  | list{"classes"} => <div> <AllClasses classes={state.classes} /> </div>
  | list{"classes", class} => <div> {`Class Data for ${class}`->React.string} </div>
  | list{} => <div> {"Home page"->React.string} </div>
  | _ => <div> {"Page not found"->React.string} </div>
  }

  <React.Fragment> <MaterialUi_CssBaseline /> <NavBar /> {body} </React.Fragment>
}

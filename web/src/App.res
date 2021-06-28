%%raw(`import './App.css';`)

open Belt

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)

  let allStattedChars =
    state.stattedChars
    ->Map.String.valuesToArray
    ->Js.Array2.filter(stattedChar =>
      switch state.classFilter {
      | Some(class) if class.id != stattedChar.classId => false
      | _ => true
      }
    )
    ->Js.Array2.filter(stattedChar =>
      switch state.homelandFilter {
      | Some(homeland) if homeland.id != stattedChar.homelandId => false
      | _ => true
      }
    )

  let body =
    <StatsTable
      stattedChars={allStattedChars}
      homelandFilter={state.homelandFilter}
      classFilter={state.classFilter}
    />

  <React.Fragment>
    <MaterialUi_CssBaseline />
    <NavBar
      classes={state.classes->Map.String.valuesToArray}
      classFilter={state.classFilter}
      homelands={state.homelands->Map.String.valuesToArray}
      homelandFilter={state.homelandFilter}
      dispatch={dispatch}
    />
    {body}
  </React.Fragment>
}

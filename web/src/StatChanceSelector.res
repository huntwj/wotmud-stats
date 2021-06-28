type state = {
  str: int,
  _int: int,
  wil: int,
  dex: int,
  con: int,
}

let initialState = {
  str: 15,
  _int: 15,
  wil: 15,
  dex: 15,
  con: 15,
}

type action = Change(Types.Stat.t)

let reducer = (state: state, action: action): state => {
  switch action {
  | _ => state
  }
}

@react.component
let make = (~analysis: StatsAnalysis.t) => {
  open MaterialUi

  let handleStrChange = (a: ReactEvent.Form.t, _) => {
    let value = (a->ReactEvent.Form.target)["value"]

    // setCalc(_ => {...calc, str: value})
  }

  let (state, dispatch) = React.useReducer(reducer, initialState)
  <React.Fragment>
    {"Stat Change Selector"->React.string}
    <Typography>
      {"
    The following calculator uses the naive model for now.
    "->React.string}
    </Typography>
    <Table>
      <TableBody>
        <TableRow>
          {Types.Stat.allStats
          ->Js.Array2.map(stat =>
            <TableCell> {stat->Types.Stat.toString->React.string} </TableCell>
          )
          ->React.array}
        </TableRow>
      </TableBody>
    </Table>
  </React.Fragment>
}

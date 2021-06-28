open Belt

module State = {
  type t = {stats: Types.CharStats.t}

  let get = (self, stat) => self.stats->Types.CharStats.get(stat)
  let initialState: t = {
    stats: {
      str: 18,
      _int: 10,
      wil: 10,
      dex: 18,
      con: 18,
    },
  }

  let setStat = (self, stat, value) => {
    stats: self.stats->Types.CharStats.set(stat, value),
  }
}

type action = ChangeStat(Types.Stat.t, int)

let reducer = (state: State.t, action: action): State.t => {
  switch action {
  | ChangeStat(stat, newVal) => state->State.setStat(stat, newVal)
  }
}

@react.component
let make = (~analysis: StatsAnalysis.t) => {
  open MaterialUi

  let (state, dispatch) = React.useReducer(reducer, State.initialState)

  let handleStatChange = (stat: Types.Stat.t, a: ReactEvent.Form.t, _) => {
    ChangeStat(stat, (a->ReactEvent.Form.target)["value"])->dispatch
  }

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
            <TableCell key={stat->Types.Stat.toString}>
              {stat->Types.Stat.toString->React.string}
            </TableCell>
          )
          ->React.array}
          <TableCell> {"Probability of all at once"->React.string} </TableCell>
        </TableRow>
        <TableRow>
          {Types.Stat.allStats
          ->Js.Array2.map(stat => {
            let value = state->State.get(stat)

            <TableCell key={stat->Types.Stat.toString}>
              <Select value={Select.Value.int(value)} onChange={handleStatChange(stat)}>
                {Array.range(10, 19)->Js.Array2.map(val =>
                  <MenuItem key={val->Int.toString} value={MenuItem.Value.int(val)}>
                    {val}
                  </MenuItem>
                )}
              </Select>
            </TableCell>
          })
          ->React.array}
          <TableCell />
        </TableRow>
        {
          let counts =
            Types.Stat.allStats->Js.Array2.map(stat => (
              stat->Types.Stat.toString,
              analysis
              ->StatsAnalysis.getStatAnalysis(stat)
              ->StatsAnalysis.HistogramData.getGte(state->State.get(stat)),
            ))

          let probabilities = counts->Js.Array2.map(((stat, count)) => {
            (stat, count->Js.Int.toFloat /. analysis.count->Js.Int.toFloat)
          })

          let probabilityDisplays = probabilities->Js.Array2.map(((stat, probability)) => {
            (stat, (probability *. 10000.0)->Js.Math.floor_float /. 100.0)
          })

          <React.Fragment>
            <TableRow>
              {counts
              ->Js.Array2.map(((stat, count)) => <TableCell key={stat}> {count} </TableCell>)
              ->React.array}
              <TableCell />
            </TableRow>
            <TableRow>
              {probabilityDisplays
              ->Js.Array2.map(((stat, probability)) =>
                <TableCell key={stat}> {probability->React.float} {"%"->React.string} </TableCell>
              )
              ->React.array}
              {
                let p = probabilities->Js.Array2.reduce((acc, (_, e)) => {acc *. e}, 1.0)
                let pDisplay = (p *. 100.0)->Js.Float.toPrecisionWithPrecision(~digits={4})
                let oneIn = (1.0 /. p)->Js.Math.floor_int
                let text = `${pDisplay}% (1 in ${oneIn->Js.Int.toString})`

                <TableCell> {text->React.string} </TableCell>
              }
            </TableRow>
          </React.Fragment>
        }
      </TableBody>
    </Table>
  </React.Fragment>
}

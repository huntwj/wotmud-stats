open Belt

type calcState = {
  str: int,
  _int: int,
  wil: int,
  dex: int,
  con: int,
}

@react.component
let make = (
  ~stattedChars: array<Types.StattedChar.t>,
  ~homelandFilter: option<Types.homeland>,
  ~classFilter: option<Types.class>,
) => {
  open MaterialUi

  let analysis = React.useMemo1(() => stattedChars->StatsAnalysis.analyzeChars, [stattedChars])

  <React.Fragment>
    <Typography variant={#H3}> {"WoTMUD Stats"->React.string} </Typography>
    <Typography variant={#H4}>
      {("Filter: " ++
      Store.homelandFilterLabel(homelandFilter) ++
      " | " ++
      Store.classFilterLabel(classFilter))->React.string}
    </Typography>
    <Typography>
      {stattedChars->Js.Array2.length->React.int} {" records matching criteria."->React.string}
    </Typography>
    <Table>
      <TableHead>
        <TableRow>
          <TableCell> {"Value"->React.string} </TableCell>
          {Types.Stat.allStats
          ->Js.Array2.map(Types.Stat.toString)
          ->Js.Array2.map(stat => <TableCell key={stat}> {stat->React.string} </TableCell>)
          ->React.array}
        </TableRow>
      </TableHead>
      <TableBody>
        {analysis
        ->StatsAnalysis.observedStatRange
        ->Option.map(range =>
          range->Js.Array2.map(statVal =>
            <TableRow key={statVal->Int.toString}>
              <TableCell> {statVal->React.int} </TableCell>
              {Types.Stat.allStats
              ->Js.Array2.map(stat => (
                stat,
                analysis
                ->StatsAnalysis.getStatAnalysis(stat)
                ->StatsAnalysis.HistogramData.get(statVal),
              ))
              ->Js.Array2.map(((stat, count)) =>
                <TableCell key={stat->Types.Stat.toString}> {count->React.int} </TableCell>
              )
              ->React.array}
            </TableRow>
          )
        )
        ->Option.map(React.array)
        ->Option.getWithDefault(
          <TableRow>
            <TableCell> {"No records matching criteria."->React.string} </TableCell>
          </TableRow>,
        )}
      </TableBody>
    </Table>
    <Table>
      <TableHead>
        <TableRow>
          <TableCell> {"Stat Sum"->React.string} </TableCell>
          <TableCell> {"Count"->React.string} </TableCell>
        </TableRow>
      </TableHead>
      <TableBody>
        {analysis
        ->StatsAnalysis.observedStatSumRange
        ->Option.map(range =>
          range->Js.Array2.map(statSumVal =>
            <TableRow key={statSumVal->Int.toString}>
              <TableCell> {statSumVal->React.int} </TableCell>
              <TableCell>
                {analysis.sumAnalysis.counts->Map.Int.getWithDefault(statSumVal, 0)->React.int}
              </TableCell>
            </TableRow>
          )
        )
        ->Option.map(React.array)
        ->Option.getWithDefault(
          <TableRow>
            <TableCell> {"No records matching criteria."->React.string} </TableCell>
          </TableRow>,
        )}
      </TableBody>
    </Table>
    <Box
      m={Box.Value.array({
        open Box.Value
        [int(2), int(5)]
      })}>
      <Typography variant={#Body1}>
        {"
      A naive model would have these numbers be directly representative of their actual probablity. 
      In reality, the model is probably more complicated as, for example, there are no stat sums 
      < 70 for Light Side players. As a result, the effective probablity for high stats is probably
      higher than the actual probablity, and vice versa for lower stats.
      "->React.string}
      </Typography>
      <StatChanceSelector analysis={analysis} />
    </Box>
  </React.Fragment>
}

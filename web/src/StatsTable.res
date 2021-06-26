open Belt

@react.component
let make = (~stattedChars: array<Types.stattedChar>) => {
  open MaterialUi

  let r = Array.range(1, 22)

  let matchingStats = statVal =>
    stattedChars->Js.Array2.reduce(((_, str, int_, wil, dex, con), stattedChar) => {
      (
        statVal,
        str + (statVal == stattedChar.str ? 1 : 0),
        int_ + (statVal == stattedChar.int_ ? 1 : 0),
        wil + (statVal == stattedChar.wil ? 1 : 0),
        dex + (statVal == stattedChar.dex ? 1 : 0),
        con + (statVal == stattedChar.con ? 1 : 0),
      )
    }, (statVal, 0, 0, 0, 0, 0))

  let matchRows =
    r
    ->Js.Array2.map(statVal => matchingStats(statVal))
    ->Js.Array2.filter(((_, str, int_, wil, dex, con)) => {
      str + int_ + wil + dex + con > 0
    })

  let total = stattedChars->Js.Array2.length

  <React.Fragment>
    <Typography variant={#H2}> {"Stats"->React.string} </Typography>
    <Typography> {total->React.int} {" records matching criteria."->React.string} </Typography>
    <Table>
      <TableHead>
        <TableRow>
          <TableCell> {"Value"->React.string} </TableCell>
          <TableCell> {"Str"->React.string} </TableCell>
          <TableCell> {"Int"->React.string} </TableCell>
          <TableCell> {"Wil"->React.string} </TableCell>
          <TableCell> {"Dex"->React.string} </TableCell>
          <TableCell> {"Con"->React.string} </TableCell>
        </TableRow>
      </TableHead>
      <TableBody>
        {if total == 0 {
          <TableRow>
            <TableCell> {"No records matching criteria."->React.string} </TableCell>
          </TableRow>
        } else {
          matchRows
          ->Array.map(((statVal, str, int_, wil, dex, con)) => {
            <TableRow key={statVal->Int.toString}>
              <TableCell> {statVal->React.int} </TableCell>
              <TableCell> {str->React.int} </TableCell>
              <TableCell> {int_->React.int} </TableCell>
              <TableCell> {wil->React.int} </TableCell>
              <TableCell> {dex->React.int} </TableCell>
              <TableCell> {con->React.int} </TableCell>
            </TableRow>
          })
          ->React.array
        }}
      </TableBody>
    </Table>
  </React.Fragment>
}

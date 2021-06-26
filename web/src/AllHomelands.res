open Belt

@react.component
let make = (~homelands: Map.String.t<Types.homeland>) => {
  open MaterialUi

  <React.Fragment>
    <Typography variant={#H2}> {"Homelands"->React.string} </Typography>
    {if homelands->Map.String.size > 0 {
      <Table>
        <TableHead>
          <TableRow>
            <TableCell> {"Data is available for the following homelands"->React.string} </TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {homelands
          ->Map.String.toArray
          ->Array.map(((key, homeland)) =>
            <TableRow key={key}>
              <TableCell> {homeland.name->String.capitalize_ascii->React.string} </TableCell>
            </TableRow>
          )
          ->React.array}
        </TableBody>
      </Table>
    } else {
      <div> {"No homelands in database."->React.string} </div>
    }}
  </React.Fragment>
}

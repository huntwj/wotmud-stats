open Belt

@react.component
let make = (~classes: Map.String.t<Types.class>) => {
  open MaterialUi

  <React.Fragment>
    <Typography variant={#H2}> {"Classes"->React.string} </Typography>
    {if classes->Map.String.size > 0 {
      <Table>
        <TableHead>
          <TableRow>
            <TableCell> {"Data is available for the following classes"->React.string} </TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {classes
          ->Map.String.toArray
          ->Array.map(((key, class)) =>
            <TableRow key={key}>
              <TableCell> {class.name->String.capitalize_ascii->React.string} </TableCell>
            </TableRow>
          )
          ->React.array}
        </TableBody>
      </Table>
    } else {
      <div> {"No classes in database."->React.string} </div>
    }}
  </React.Fragment>
}

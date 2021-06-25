open Belt

@react.component
let make = (~classes: Map.String.t<Types.class>) => {
  let classElements =
    classes
    ->Map.String.toArray
    ->Array.map(((classId, class)) => {
      <div key={classId}> {class.name->React.string} </div>
    })

  if classElements->Array.length > 0 {
    <div> {classElements->React.array} </div>
  } else {
    <div> {"No classes in database."->React.string} </div>
  }
}

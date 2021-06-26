open Belt

module NavButton = {
  @react.component
  let make = (~name: string, ~linkTo: string) => {
    open MaterialUi

    <Button color={#Default} onClick={_ => RescriptReactRouter.push(linkTo)}>
      {name->React.string}
    </Button>
  }
}

@react.component
let make = (
  ~classes: array<Types.class>,
  ~classFilter: option<Types.class>,
  ~homelands: array<Types.homeland>,
  ~homelandFilter: option<Types.homeland>,
  ~dispatch: Store.dispatch,
) => {
  open MaterialUi

  let (homelandsAnchorEl, setHomelandsAnchorEl) = React.useState(_ => None)
  let handleHomelandsClick = (event: ReactEvent.Mouse.t) => {
    let target = event->ReactEvent.Mouse.currentTarget

    setHomelandsAnchorEl(_ => Some(target))
  }
  let handleHomelandsClose = (homelandFilter: option<Types.homeland>, _) => {
    setHomelandsAnchorEl(_ => None)
    homelandFilter->Store.UpdateFilterHomeland->dispatch
  }

  let (classesAnchorEl, setClassAnchorEl) = React.useState(_ => None)
  let handleClassesClick = (event: ReactEvent.Mouse.t) => {
    let target = event->ReactEvent.Mouse.currentTarget

    setClassAnchorEl(_ => Some(target))
  }
  let handleClassesClose = (classFilter: option<Types.class>, _) => {
    setClassAnchorEl(_ => None)
    classFilter->Store.UpdateFilterClass->dispatch
  }

  let classButtonName = switch classFilter {
  | None => "Classes: All"
  | Some(class) => `Class: ${class.name}`
  }->React.string

  let homelandButtonName = switch homelandFilter {
  | None => "Homelands: All"
  | Some(homeland) => `Homeland: ${homeland.name}`
  }->React.string

  <AppBar position={#Static}>
    <Toolbar>
      <Button onClick={handleHomelandsClick}> {homelandButtonName} </Button>
      <Menu
        id="homelands-menu"
        anchorEl={Any(homelandsAnchorEl)}
        keepMounted={true}
        _open={homelandsAnchorEl->Option.isSome}>
        <MenuItem onClick={handleHomelandsClose(None)}>
          {"All Homelands"->React.string}
          {homelandFilter->Option.isNone ? " (active)"->React.string : React.null}
        </MenuItem>
        {homelands
        ->Array.map(homeland => {
          <MenuItem key={homeland.id} onClick={handleHomelandsClose(Some(homeland))}>
            {homeland.name->React.string}
            {homelandFilter == Some(homeland) ? " (active)"->React.string : React.null}
          </MenuItem>
        })
        ->React.array}
      </Menu>
      <Button onClick={handleClassesClick}> {classButtonName} </Button>
      <Menu
        id="classes-menu"
        anchorEl={Any(classesAnchorEl)}
        keepMounted={true}
        _open={classesAnchorEl->Option.isSome}>
        <MenuItem onClick={handleClassesClose(None)}>
          {"All Classes"->React.string}
          {classFilter->Option.isNone ? " (active)"->React.string : React.null}
        </MenuItem>
        {classes
        ->Array.map(class => {
          <MenuItem key={class.id} onClick={handleClassesClose(Some(class))}>
            {class.name->String.capitalize_ascii->React.string}
            {classFilter == Some(class) ? " (active)"->React.string : React.null}
          </MenuItem>
        })
        ->React.array}
      </Menu>
    </Toolbar>
  </AppBar>
}

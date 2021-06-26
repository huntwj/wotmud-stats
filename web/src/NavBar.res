module NavButton = {
  @react.component
  let make = (~name: string, ~selected: string, ~linkTo: string) => {
    open MaterialUi

    <Button color={#Default} onClick={_ => RescriptReactRouter.push(linkTo)}>
      {name->React.string}
    </Button>
  }
}

@react.component
let make = () => {
  open MaterialUi

  let url = RescriptReactRouter.useUrl()

  let selected = switch url.path {
  | list{"stats", ..._} => "Stats Table"
  | list{"homelands", homeland} => `Homeland (${homeland})`
  | list{"homelands", ..._} => "Homelands"
  | list{"classes", class} => `Class (${class})`
  | list{"classes", ..._} => "Classes"
  | list{} => "Home"
  | _ => "404"
  }

  <AppBar position={#Static}>
    <Toolbar>
      <NavButton name="Home" selected={selected} linkTo="/" />
      <NavButton name="Stats" selected={selected} linkTo="/stats" />
      <NavButton name="Homelands" selected={selected} linkTo="/homelands" />
      <NavButton name="Classes" selected={selected} linkTo="/classes" />
    </Toolbar>
  </AppBar>
}

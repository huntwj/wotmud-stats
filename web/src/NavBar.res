module NavButton = {
  @react.component
  let make = (~name: string, ~selected: string, ~linkTo: string) => {
    let style = if selected == name {
      ReactDOM.Style.make(~backgroundColor="#656565", ~padding="1ex", ~cursor="pointer", ())
    } else {
      ReactDOM.Style.make(~backgroundColor="#efefef", ~padding="1ex", ~cursor="pointer", ())
    }

    <div style={style} onClick={_ => RescriptReactRouter.push(linkTo)}> {name->React.string} </div>
  }
}

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  let selected = switch url.path {
  | list{"homelands", homeland} => `Homeland (${homeland})`
  | list{"homelands", ..._} => "Homelands"
  | list{"classes", class} => `Class (${class})`
  | list{"classes", ..._} => "Classes"
  | list{} => "Home"
  | _ => "404"
  }

  let style = ReactDOM.Style.make(~display="flex", ~justifyContent="center", ())
  <div style={style}>
    <NavButton name="Home" selected={selected} linkTo="/" />
    <NavButton name="Homelands" selected={selected} linkTo="/homelands" />
    <NavButton name="Classes" selected={selected} linkTo="/classes" />
  </div>
}

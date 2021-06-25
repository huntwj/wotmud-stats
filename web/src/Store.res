%%private(@module("./data2.json") external data: 'json = "default")

open Belt
open Types

type state = {
  homelands: Map.String.t<homeland>,
  classes: Map.String.t<class>,
  stattedChars: Map.String.t<stattedChar>,
}

let mapFromArray = arrData => arrData->Array.map(e => (e.id, e))->Map.String.fromArray

let initialState = {
  switch data->Parser.parseDataFile {
  | Ok(dataFile) => {
      let homelands =
        dataFile.homelands->Array.map(homeland => (homeland.id, homeland))->Map.String.fromArray
      let classes = dataFile.classes->Array.map(class => (class.id, class))->Map.String.fromArray
      let stattedChars =
        dataFile.stattedChars
        ->Array.map(stattedChar => (stattedChar.id, stattedChar))
        ->Map.String.fromArray

      {
        classes: classes,
        homelands: homelands,
        stattedChars: stattedChars,
      }
    }
  | Error(reason) => {
      Js.Console.error2("Error parsing JSON file:", reason)
      {
        homelands: Map.String.empty,
        classes: Map.String.empty,
        stattedChars: Map.String.empty,
      }
    }
  }
}

type action =
  | AddHomeland({id: string, name: string})
  | AddClass({id: string, name: string})
  | UpdateFilterHomeland(option<string>)
  | UpdateFilterClass(option<string>)

let reducer = (state: state, action: action) => {
  switch action {
  | AddHomeland({id, name}) => {
      homelands: Map.String.set(state.homelands, id, {id: id, name: name}),
      classes: state.classes,
      stattedChars: state.stattedChars,
    }
  | AddClass({id, name}) => {
      homelands: state.homelands,
      classes: Map.String.set(state.classes, id, {id: id, name: name}),
      stattedChars: state.stattedChars,
    }
  | UpdateFilterClass(_) => state
  | UpdateFilterHomeland(_) => state
  }
}

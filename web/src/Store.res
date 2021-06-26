%%private(@module("./data.json") external data: 'json = "default")

open Belt
open Types

type state = {
  homelands: Map.String.t<homeland>,
  classes: Map.String.t<class>,
  stattedChars: Map.String.t<stattedChar>,
  homelandFilter: option<homeland>,
  classFilter: option<class>,
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
        homelandFilter: None,
        classFilter: None,
      }
    }
  | Error(reason) => {
      Js.Console.error2("Error parsing JSON file:", reason)
      {
        homelands: Map.String.empty,
        classes: Map.String.empty,
        stattedChars: Map.String.empty,
        homelandFilter: None,
        classFilter: None,
      }
    }
  }
}

type action =
  | UpdateFilterHomeland(option<homeland>)
  | UpdateFilterClass(option<class>)

let reducer = (state: state, action: action) => {
  switch action {
  | UpdateFilterClass(classFilter) => {
      ...state,
      classFilter: classFilter,
    }
  | UpdateFilterHomeland(homelandFilter) => {
      ...state,
      homelandFilter: homelandFilter,
    }
  }
}

type dispatch = action => unit

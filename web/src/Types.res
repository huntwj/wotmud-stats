type homeland = {
  id: string,
  name: string,
}

type class = {
  id: string,
  name: string,
}

module Stat = {
  type t =
    | Str
    | Int
    | Wil
    | Dex
    | Con

  module Cmp = Belt.Id.MakeComparable({
    type t = t
    let cmp = (a, b) => Pervasives.compare(a, b)
  })

  let allStats = [Str, Int, Wil, Dex, Con]

  let toString = stat =>
    switch stat {
    | Str => "Strength"
    | Int => "Intelligence"
    | Wil => "Willpower"
    | Dex => "Dexterity"
    | Con => "Constitution"
    }
}

module CharStats = {
  type t = {
    str: int,
    _int: int,
    wil: int,
    dex: int,
    con: int,
  }

  let get = (cs, stat: Stat.t) =>
    switch stat {
    | Str => cs.str
    | Int => cs._int
    | Wil => cs.wil
    | Dex => cs.dex
    | Con => cs.con
    }

  let set = (self, stat: Stat.t, newVal) =>
    switch stat {
    | Str => {
        ...self,
        str: newVal,
      }
    | Int => {
        ...self,
        _int: newVal,
      }
    | Wil => {
        ...self,
        wil: newVal,
      }
    | Dex => {
        ...self,
        dex: newVal,
      }
    | Con => {
        ...self,
        con: newVal,
      }
    }
}

module StattedChar = {
  type t = {
    id: string,
    homelandId: string,
    classId: string,
    stats: CharStats.t,
  }

  let get = (record, stat) => record->CharStats.get(stat)

  let statSum = stat =>
    Stat.allStats->Js.Array2.map(get(stat))->Js.Array2.reduce((acc, val) => acc + val, 0)
}

type dataFile = {
  homelands: array<homeland>,
  classes: array<class>,
  stattedChars: array<StattedChar.t>,
}

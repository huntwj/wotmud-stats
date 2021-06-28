open Belt

module HistogramData = {
  type t = {counts: Map.Int.t<int>}

  let empty = {
    counts: Map.Int.empty,
  }

  let withData = (from: t, observedValue: int): t => {
    counts: from.counts->Map.Int.update(observedValue, existing => Some(
      existing->Option.mapWithDefault(1, val => val + 1),
    )),
  }

  let minObseration = self => self.counts->Map.Int.minKey
  let maxObservation = self => self.counts->Map.Int.maxKey

  let get = (self, val) => self.counts->Map.Int.get(val)->Option.getWithDefault(0)

  let getGte = (self, val) => self.counts->Map.Int.toArray->Js.Array2.reduce((acc, (key, value)) =>
      if key >= val {
        acc + value
      } else {
        acc
      }
    , 0)
}

type t = {
  strAnalysis: HistogramData.t,
  intAnalysis: HistogramData.t,
  wilAnalysis: HistogramData.t,
  dexAnalysis: HistogramData.t,
  conAnalysis: HistogramData.t,
  sumAnalysis: HistogramData.t,
  count: int,
}

let analyzeChar = (self: t, stattedChar: Types.StattedChar.t): t => {
  {
    strAnalysis: self.strAnalysis->HistogramData.withData(stattedChar.stats.str),
    intAnalysis: self.intAnalysis->HistogramData.withData(stattedChar.stats._int),
    wilAnalysis: self.wilAnalysis->HistogramData.withData(stattedChar.stats.wil),
    dexAnalysis: self.dexAnalysis->HistogramData.withData(stattedChar.stats.dex),
    conAnalysis: self.conAnalysis->HistogramData.withData(stattedChar.stats.con),
    sumAnalysis: self.sumAnalysis->HistogramData.withData(
      stattedChar.stats->Types.StattedChar.statSum,
    ),
    count: self.count + 1,
  }
}

let empty = {
  strAnalysis: HistogramData.empty,
  intAnalysis: HistogramData.empty,
  wilAnalysis: HistogramData.empty,
  dexAnalysis: HistogramData.empty,
  conAnalysis: HistogramData.empty,
  sumAnalysis: HistogramData.empty,
  count: 0,
}

let analyzeChars = (stattedChars: array<Types.StattedChar.t>): t => {
  stattedChars->Js.Array2.reduce(analyzeChar, empty)
}

let getStatAnalysis = (self, stat: Types.Stat.t) =>
  switch stat {
  | Str => self.strAnalysis
  | Int => self.intAnalysis
  | Wil => self.wilAnalysis
  | Dex => self.dexAnalysis
  | Con => self.conAnalysis
  }

let statHistograms = self => Types.Stat.allStats->Js.Array2.map(getStatAnalysis(self))

let minObservedStatVal = (self: t) => {
  self->statHistograms->Js.Array2.map(HistogramData.minObseration)->Js.Array2.reduce((acc, min) =>
    switch (acc, min) {
    | (Some(a), Some(b)) => Some(Js.Math.min_int(a, b))
    | (None, Some(b)) => Some(b)
    | _ => acc
    }
  , None)
}

let maxObservedStatVal = (self: t) => {
  self->statHistograms->Js.Array2.map(HistogramData.maxObservation)->Js.Array2.reduce((acc, min) =>
    switch (acc, min) {
    | (Some(a), Some(b)) => Some(Js.Math.max_int(a, b))
    | (None, Some(b)) => Some(b)
    | _ => acc
    }
  , None)
}

let observedStatRange = self =>
  minObservedStatVal(self)->Option.flatMap(min =>
    maxObservedStatVal(self)->Option.map(max => Array.range(min, max))
  )
let observedStatSumRange = self =>
  self.sumAnalysis.counts
  ->Map.Int.minKey
  ->Option.flatMap(min =>
    self.sumAnalysis.counts->Map.Int.maxKey->Option.map(max => Array.range(min, max))
  )

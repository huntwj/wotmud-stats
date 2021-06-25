open Belt

// Convert an array of results into a result of an array. The first error
// element found is returned.
let flatMapArrayI = (arrData, f) =>
  Js.Array2.reducei(
    arrData,
    (accResult, e, idx) => {
      accResult->Result.flatMap(acc => {
        switch f(e, idx) {
        | Ok(result) => Ok(acc->Array.concat([result]))
        | Error(e) => Error(e)
        }
      })
    },
    Ok([]),
  )

// Do the same as flapMapArrayI but ignore the index.
let flatMapArray = (arrData, f) => flatMapArrayI(arrData, (e, _i) => f(e))

open Js.Json
open Types

let _isInteger = val => Js.Float.isFinite(val) && Js.Math.floor_float(val) == val

let foo = arrayOfResults => arrayOfResults->Js.Array2.reduce((acc, val) => {
    switch (acc, val) {
    | (Ok(soFar), Ok(next)) => Ok(Js.Array2.concat(soFar, [next]))
    | (Error(e), _) => Error(e)
    | (_, Error(e)) => Error(e)
    }
  }, Ok([]))

let parseString = val => {
  switch val->classify {
  | JSONString(s) => Ok(s)
  | _ => Error("Expected string value")
  }
}

let parseInt = val => {
  switch val->classify {
  | JSONNumber(n) if n->_isInteger => Ok(n->Js.Math.floor_int)
  | _ => Error("Expected integer value")
  }
}

let parseField = (o, field, parser) => {
  switch o->Js.Dict.get(field) {
  | None => Error(`Record missing ${field} field`)
  | Some(val) => val->parser
  }
}

let parseId = o => {
  switch o->classify {
  | JSONString(s) => Ok(s)
  | JSONNumber(n) => Ok(n->Js.Float.toString)
  | _ => Error("Invalid type for id field. Must be string or number")
  }
}

let parseArray = (parser, data) => {
  switch data->classify {
  | JSONArray(arrayData) => arrayData->Js.Array2.map(parser)->foo
  | _ => Error("Expected array value")
  }
}

let parseNameAndId = (data, constructor, typeString) => {
  switch data->classify {
  | JSONObject(o) =>
    o
    ->parseField("id", parseId)
    ->Belt.Result.flatMap(id => {
      o->parseField("name", parseString)->Belt.Result.map(name => constructor(id, name))
    })
  | _ => Error(`${typeString} record must be an object.`)
  }
}

let parseClass = data => {
  parseNameAndId(data, (id, name): Types.class => {id: id, name: name}, "Class")
}

let parseHomeland = data => {
  parseNameAndId(data, (id, name): Types.homeland => {id: id, name: name}, "Homeland")
}

let parseStattedChar = data => {
  switch data->classify {
  | JSONObject(o) =>
    parseField(o, "id", parseId)->Belt.Result.flatMap(id =>
      parseField(o, "classId", parseId)->Belt.Result.flatMap(classId =>
        parseField(o, "homelandId", parseId)->Belt.Result.flatMap(homelandId =>
          parseField(o, "str", parseInt)->Belt.Result.flatMap(str =>
            parseField(o, "int", parseInt)->Belt.Result.flatMap(int_ =>
              parseField(o, "wil", parseInt)->Belt.Result.flatMap(wil =>
                parseField(o, "dex", parseInt)->Belt.Result.flatMap(dex =>
                  parseField(o, "con", parseInt)->Belt.Result.map((con): Types.stattedChar => {
                    {
                      id: id,
                      classId: classId,
                      homelandId: homelandId,
                      str: str,
                      int_: int_,
                      wil: wil,
                      dex: dex,
                      con: con,
                    }
                  })
                )
              )
            )
          )
        )
      )
    )
  | _ => Error("Statted character JSON must be an object.")
  }
}

let parseDataFile = data => {
  switch data->classify {
  | JSONObject(o) =>
    parseField(o, "classes", parseArray(parseClass))->Belt.Result.flatMap(classes =>
      parseField(o, "homelands", parseArray(parseHomeland))->Belt.Result.flatMap(homelands =>
        parseField(o, "stattedChars", parseArray(parseStattedChar))->Belt.Result.map((
          stattedChars
        ): Types.dataFile => {
          classes: classes,
          homelands: homelands,
          stattedChars: stattedChars,
        })
      )
    )
  | _ => Error("Data file should be an object JSON.")
  }
}

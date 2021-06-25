open Js.Json
open Types
open Belt

// General Parser stuffs. This should be moved to its own package/module.

let _isInteger = val => Js.Float.isFinite(val) && Js.Math.floor_float(val) == val

let _jtToString = ttype =>
  switch ttype {
  | JSONNumber(n) => `number (${n->Js.Float.toString})`
  | JSONObject(_) => `object`
  | JSONFalse => "boolean (false)"
  | JSONTrue => "boolean (true)"
  | JSONNull => "null"
  | JSONString(s) => `string (${s})`
  | JSONArray(_) => `array`
  }

let err = (context, expected, found) => Error(
  `${context} should be ${expected}, but found ${found->classify->_jtToString}.`,
)

let parseString = (u, context) => {
  switch u->classify {
  | JSONString(s) => Ok(s)
  | _ => err(context, "a string", u)
  }
}

let parseInt = (u, context) => {
  switch u->classify {
  | JSONNumber(n) if n->_isInteger => Ok(n->Js.Math.floor_int)
  | _ => err(context, "an integer", u)
  }
}

let parseId = (u, context) => {
  switch u->classify {
  | JSONString(s) => Ok(s)
  | JSONNumber(n) => Ok(n->Js.Float.toString)
  | _ => err(context, "a string or number", u)
  }
}

let parseOption = (parser, u, context) => {
  switch u->classify {
  | JSONNull => Ok(None)
  | _ =>
    switch parser(u, context) {
    | Ok(val) => Ok(Some(val))
    | Error(e) => Error(e)
    }
  }
}

let parseArray = (parser, u, context) => {
  switch u->classify {
  | JSONArray(arrayData) =>
    arrayData->Util.flatMapArrayI((inData, idx) =>
      parser(inData, `${context}[${idx->Js.Int.toString}]`)
    )
  | _ => err(context, "an array", u)
  }
}

let parseField = (dict, field, context, parser) => {
  let newContext = `${context}['${field}']`
  switch dict->Js.Dict.get(field) {
  | None => Error(`missing field ${newContext}`)
  | Some(val) => val->parser(newContext)
  }
}

let parseOptionalField = (dict, field, context, parser) => {
  let newContext = `${context}['${field}']`
  switch dict->Js.Dict.get(field) {
  | None => Ok(None)
  | Some(val) => val->parser(newContext)->Belt.Result.map(v => Some(v))
  }
}

let parseObject = (fieldParser, u, context) => {
  switch u->classify {
  | JSONObject(o) =>
    // let parseField = (field, parser) => {
    //   parseField_(o, field, context, parser)
    // }
    fieldParser(o)
  | _ => err(context, "an object", u)
  }
}

//
// And now for my stuff.
//
let parseNameAndId = (constructor, u, context) => {
  parseObject(f => {
    parseField(f, "id", context, parseId)->Result.flatMap(id =>
      parseField(f, "name", context, parseString)->Result.map(name => constructor(id, name))
    )
  }, u, context)
}

let parseClass = parseNameAndId((id, name): Types.class => {id: id, name: name})
let parseHomeland = parseNameAndId((id, name): Types.homeland => {id: id, name: name})

let parseStattedChar = (data, context) => {
  parseObject(o =>
    parseField(o, "id", context, parseId)->Result.flatMap(id =>
      parseField(o, "classId", context, parseId)->Result.flatMap(classId =>
        parseField(o, "homelandId", context, parseId)->Result.flatMap(homelandId =>
          parseField(o, "str", context, parseInt)->Result.flatMap(str =>
            parseField(o, "int", context, parseInt)->Result.flatMap(int_ =>
              parseField(o, "wil", context, parseInt)->Result.flatMap(wil =>
                parseField(o, "dex", context, parseInt)->Result.flatMap(dex =>
                  parseField(o, "con", context, parseInt)->Result.map((con): Types.stattedChar => {
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
  , data, context)
}

let parseDataFile = (data: 'json): result<'a, string> => {
  let parser = (u, context) => parseObject(fields => {
      parseField(
        fields,
        "homelands",
        context,
        parseArray(parseHomeland),
      )->Result.flatMap(homelands =>
        parseField(fields, "classes", context, parseArray(parseClass))->Result.flatMap(classes =>
          parseField(fields, "stattedChars", context, parseArray(parseStattedChar))->Result.map((
            stattedChars
          ): Types.dataFile => {
            classes: classes,
            homelands: homelands,
            stattedChars: stattedChars,
          })
        )
      )
    }, u, "dataFile")

  parser(data, "jsonFile")
}

type homeland = {
  id: string,
  name: string,
}

type class = {
  id: string,
  name: string,
}

type stattedChar = {
  id: string,
  homelandId: string,
  classId: string,
  str: int,
  int_: int,
  wil: int,
  dex: int,
  con: int,
}

type dataFile = {
  homelands: array<homeland>,
  classes: array<class>,
  stattedChars: array<stattedChar>,
}

open Belt

@react.component
let make = (~label: string, ~low: int, ~high: int, ~selectedVal: int, ~onChange) => {
  open MaterialUi

  <FormControl>
    <InputLabel id={`label-${label}`} htmlFor={`select-${label}`}>
      {label->React.string}
    </InputLabel>
    <Select id={`select-${label}`} value={selectedVal->Select.Value.int} onChange={onChange}>
      {Array.range(low, high)
      ->Array.map(statVal =>
        <MenuItem key={statVal->Int.toString} value={statVal->MenuItem.Value.int}>
          {statVal->Int.toString->React.string}
        </MenuItem>
      )
      ->React.array}
    </Select>
  </FormControl>
}

open Preact

type state = {
  selectedColor: int,
  colors: array<string>,
}

let stateSignal: Signal.t<state> = Signal.make({
  selectedColor: 0,
  colors: ["000000", "000000", "000000", "000000", "000000"],
})

let getSelectedColor = () => {
  let {selectedColor, colors} = stateSignal->Signal.get
  colors[selectedColor]->Option.getOr("000000")
}

let setSelectedColor = (color: string) => {
  let state = stateSignal->Signal.get
  let {selectedColor, colors} = state

  let updatedColors = colors->Array.toSpliced(~start=selectedColor, ~remove=1, ~insert=[color])

  stateSignal->Signal.set({
    ...state,
    colors: updatedColors,
  })
}

let colorsSignal = Signal.computed(() => {
  let {colors} = stateSignal->Signal.get

  colors
})

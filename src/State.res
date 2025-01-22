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

type rgb = { r: int, g: int, b: int }
type hsv = { h: int, s: int, v: int }

type colorData = {
  rgb: rgb,
  hsv: hsv,
}

let colorDataSignal: Signal.t<colorData> = Signal.computed(() => {
  let color = getSelectedColor()

  let rgb = color->Color.Hex.toRgb
  let (h, s, v) = rgb->Color.RGB.toHsl
  let (r, g, b) = rgb

  {
  rgb: { r, g, b },
  hsv: { h, s, v },
  }
})

type colorInput = 
  | Hex(string)
  | RGB(int, int, int)
  | HSV(int, int, int)
  | Red(int)
  | Green(int)
  | Blue(int)
  | Hue(int)
  | Saturation(int)
  | Value(int)

type colorOutput = 
  | Hex(string)
  | RGB(int, int, int)
  | HSV(int, int, int)

let setRgbColor = (input: colorInput) => {
  let { rgb, hsv } = colorDataSignal->Signal.get
  let { r, g, b } = rgb
  let { h, s, v} = hsv

  let color: colorOutput = switch input {
    | Hex(string) => Hex(string)
    | RGB(r, g, b) => RGB(r, g, b)
    | HSV(h, s, v) => HSV(h, s, v)

    | Red(r: int) => RGB(r, g, b)
    | Green(g: int) => RGB(r, g, b)
    | Blue(b: int) => RGB(r, g, b)

    | Hue(h: int) => HSV(h, s, v)
    | Saturation(s: int) => HSV(h, s, v)
    | Value(v: int) => HSV(h, s, v)
  }

  let copy: int
}

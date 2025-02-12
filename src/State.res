open Preact

type color =
  | Hex(string)
  | RGB(int, int, int)
  | HSV(int, int, int)

type state = {
  selectedColor: int,
  colors: array<color>,
}

let stateSignal: Signal.t<state> = Signal.make({
  selectedColor: 0,
  colors: [HSV(360, 100, 100), HSV(0, 0, 0), HSV(0, 0, 0), HSV(0, 0, 0), HSV(0, 0, 0)],
})

type rgb = {r: int, g: int, b: int}
type hsv = {h: int, s: int, v: int}
type hex = string
type colorState = {
  rgb: rgb,
  hsv: hsv,
  hex: hex,
}

let parseColorState: color => colorState = color => {
  switch color {
  | Hex(hex) => {
      let rgb = hex->Color.Hex.toRGB
      let (r, g, b) = rgb
      let (h, s, v) = rgb->Color.RGB.toHSV

      {
        hex,
        rgb: {r, g, b},
        hsv: {h, s, v},
      }
    }
  | RGB(r, g, b) => {
      let rgb = (r, g, b)
      let hex = rgb->Color.RGB.toHex
      let (h, s, v) = rgb->Color.RGB.toHSV
      {
        hex,
        rgb: {r, g, b},
        hsv: {h, s, v},
      }
    }
  | HSV(h, s, v) => {
      let hsv = (h, s, v)
      let rgb = hsv->Color.HSV.toRGB
      let hex = rgb->Color.RGB.toHex
      let (r, g, b) = rgb
      {
        hex,
        rgb: {r, g, b},
        hsv: {h, s, v},
      }
    }
  }
}

let colorsSignal = Signal.computed(() => {
  let {colors} = stateSignal->Signal.get

  colors->Array.map(parseColorState)
})

let selectedColorSignal: Signal.t<colorState> = Signal.computed(() => {
  let {selectedColor} = stateSignal->Signal.get
  let colors = colorsSignal->Signal.get
  let color = colors[selectedColor]->Option.getOr({
    hex: "000000",
    rgb: {r: 0, g: 0, b: 0},
    hsv: {h: 0, s: 0, v: 0},
  })

  color
})

let getSelectedColor = () => {
  selectedColorSignal->Signal.get
}

let peekSelectedColor = () => {
  selectedColorSignal->Signal.peek
}

module Actions = {
  type partialInput =
    | R(int)
    | G(int)
    | B(int)
    | H(int)
    | S(int)
    | V(int)
    | Hex(string)
    | HS(int, int)

  type action =
    | InitHSV(colorState)
    | RGB(colorState)
    | HSV(colorState)
    | Wheel(colorState)
    | Hex(colorState)

  let updateSelectedColor = (color: color) => {
    let state = stateSignal->Signal.peek
    let {selectedColor, colors} = state

    let updatedColors = colors->Array.toSpliced(~start=selectedColor, ~remove=1, ~insert=[color])

    stateSignal->Signal.set({
      ...state,
      colors: updatedColors,
    })
  }

  %%private(let color = getSelectedColor())

  let signal: Signal.t<action> = Signal.make(InitHSV(color))
}

let setSelectedColor = (input: Actions.partialInput) => {
  let {hsv, rgb} = peekSelectedColor()

  Actions.updateSelectedColor(
    switch input {
    | R(r: int) => RGB(r, rgb.g, rgb.b)
    | G(g: int) => RGB(rgb.r, g, rgb.b)
    | B(b: int) => RGB(rgb.r, rgb.g, b)

    | H(h: int) => HSV(h, hsv.s, hsv.v)
    | S(s: int) => HSV(hsv.h, s, hsv.v)
    | V(v: int) => HSV(hsv.h, hsv.s, v)

    | HS(h: int, s: int) => HSV(h, s, hsv.v)

    | Hex(hex: string) => Hex(hex)
    },
  )

  let color = peekSelectedColor()

  Actions.signal->Signal.set(
    switch input {
    | R(_)
    | G(_)
    | B(_) =>
      RGB(color)

    | H(_)
    | S(_)
    | V(_) =>
      HSV(color)

    | HS(_, _) => Wheel(color)

    | Hex(_) => Hex(color)
    },
  )
}

let canvasSignal: Signal.t<option<Dom.element>> = Signal.make(None)

type canvas = Dom.element

module Gradient = {
  type t

  @send
  external addColorStop: (t, ~offset: float, ~color: string) => unit = "addColorStop"
}

module Context = {
  type t

  @send
  external arc: (
    t,
    ~x: int,
    ~y: int,
    ~radius: int,
    ~startAngle: float,
    ~endAngle: float,
    ~counterClockwise: bool=?,
  ) => unit = "arc"

  @send
  external createConicGradient: (t, ~startAngle: int, ~x: int, ~y: int) => Gradient.t =
    "createConicGradient"

  @send
  external createRadialGradient: (
    t,
    ~x0: int,
    ~y0: int,
    ~r0: int,
    ~x1: int,
    ~y1: int,
    ~r1: int,
  ) => Gradient.t = "createRadialGradient"

  @send
  external beginPath: t => unit = "beginPath"

  @send
  external closePath: t => unit = "closePath"

  @send
  external fill: (t, ~fillRule: [#nonzero | #evenodd]=?) => unit = "fill"

  @get
  external getFillStyle: t => string = "fillStyle"

  @set
  external setFillStyle: (t, @unwrap [#color(string) | #gradient(Gradient.t)]) => unit = "fillStyle"

  @send
  external stroke: t => unit = "stroke"

  @get
  external getStrokeStyle: t => string = "strokeStyle"

  @set
  external setStrokeStyle: (t, @unwrap [#color(string) | #gradient(Gradient.t)]) => unit =
    "strokeStyle"

  @get
  external getLineWidth: t => int = "lineWidth"

  @set
  external setLineWidth: (t, int) => unit = "lineWidth"
}

@send
external getContext: (
  canvas,
  @string
  [
    | @as("2d") #in2d
    | #webgl
    | #webgl2
    | #webgpu
    | #bitmaprenderer
  ],
) => Context.t = "getContext"

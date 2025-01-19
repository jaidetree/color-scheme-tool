type canvas = Dom.element
type canvasContext

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
) => canvasContext = "getContext"

module Gradient = {
  type canvasGradient

  @send
  external addColorStop: (canvasGradient, ~offset: float, ~color: string) => unit = "addColorStop"
}

module Context = {
  @send
  external arc: (
    canvasContext,
    ~x: int,
    ~y: int,
    ~radius: int,
    ~startAngle: float,
    ~endAngle: float,
    ~counterClockwise: bool=?,
  ) => unit = "arc"

  @send
  external createConicGradient: (
    canvasContext,
    ~startAngle: int,
    ~x: int,
    ~y: int,
  ) => Gradient.canvasGradient = "createConicGradient"

  @send
  external createRadialGradient: (
    canvasContext,
    ~x0: int,
    ~y0: int,
    ~r0: int,
    ~x1: int,
    ~y1: int,
    ~r1: int,
  ) => Gradient.canvasGradient = "createRadialGradient"

  @send
  external beginPath: canvasContext => unit = "beginPath"

  @send
  external closePath: canvasContext => unit = "closePath"

  @send
  external fill: (canvasContext, ~fillRule: [#nonzero | #evenodd]=?) => unit = "fill"

  @get
  external getFillStyle: canvasContext => string = "fillStyle"

  @set
  external setFillStyle: (
    canvasContext,
    @unwrap [#color(string) | #gradient(Gradient.canvasGradient)],
  ) => unit = "fillStyle"
}

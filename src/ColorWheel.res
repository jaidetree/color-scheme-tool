open Preact

let colors = ["red", "orange", "yellow", "green", "cyan", "blue", "magenta", "red"]

let circle = (ctx: Canvas.Context.t, fill: Canvas.Gradient.t) => {
  ctx->Canvas.Context.beginPath
  ctx->Canvas.Context.arc(
    ~x=300,
    ~y=300,
    ~radius=300,
    ~startAngle=0.0,
    ~endAngle=2.0 *. Math.Constants.pi,
  )
  ctx->Canvas.Context.setFillStyle(#gradient(fill))
  ctx->Canvas.Context.fill
  ctx->Canvas.Context.closePath
}

let drawColorWheel = (canvas: Canvas.canvas) => {
  let ctx = canvas->Canvas.getContext(#in2d)
  let conicGradient = ctx->Canvas.Context.createConicGradient(~startAngle=0, ~x=300, ~y=300)
  let totalColors = colors->Array.length
  let interval = 1.0 /. Int.toFloat(totalColors - 1)

  colors->Array.forEachWithIndex((color, index) => {
    let i = index->Int.toFloat
    let offset = i *. interval
    conicGradient->Canvas.Gradient.addColorStop(~offset, ~color)
  })

  ctx->circle(conicGradient)

  let radialGradient =
    ctx->Canvas.Context.createRadialGradient(~x0=300, ~y0=300, ~r0=5, ~x1=300, ~y1=300, ~r1=300)

  radialGradient->Canvas.Gradient.addColorStop(~offset=0.0, ~color="white")
  radialGradient->Canvas.Gradient.addColorStop(~offset=1.0, ~color="rgba(255, 255, 255, 0")

  ctx->circle(radialGradient)
}

@jsx.component
let make = () => {
  let canvasRef = useRef(Nullable.null)

  let logRef = _ => {
    switch canvasRef.current {
    | Value(canvas) => canvas->drawColorWheel
    | Null | Undefined => Js.Console.log("canvas is not set yet")
    }
  }

  useEffect0(() => {
    logRef()

    None
  })

  <>
    <canvas ref={Ref.domRef(canvasRef)} width="600" height="600" />
  </>
}

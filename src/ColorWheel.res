open Preact

let colors = ["red", "magenta", "blue", "cyan", "green", "yellow", "orange", "red"]

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

  <div className="relative">
    <canvas ref={Ref.domRef(canvasRef)} width="600" height="600" className="relative z-20" />
    <svg
      viewBox="0 0 640 640"
      className="absolute left-0 top-0 z-10 transform -translate-x-5 -translate-y-5"
      width="640"
      height="640">
      <circle cx="320" cy="320" r="320" strokeWidth="20" fill="rgba(0, 0, 0, 0.25)" />
    </svg>
  </div>
}

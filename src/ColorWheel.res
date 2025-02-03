open Preact
open State

let colors: array<int> = [360, 300, 240, 180, 120, 60, 0]

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

let drawColorWheel = (canvas: Canvas.canvas, hsv: State.hsv) => {
  let ctx = canvas->Canvas.getContext(#in2d)
  ctx->Canvas.Context.reset
  let conicGradient = ctx->Canvas.Context.createConicGradient(~startAngle=0, ~x=300, ~y=300)
  let totalColors = colors->Array.length
  let interval = 1.0 /. Int.toFloat(totalColors - 1)

  colors->Array.forEachWithIndex((hue, index) => {
    let i = index->Int.toFloat
    let offset = i *. interval
    let (h, s, l) = (hue, 100, hsv.v)->Color.HSV.toHSL
    let h' = h->Int.toString
    let s' = s->Int.toString
    let l' = l->Int.toString
    let color = `hsl(${h'} ${s'}% ${l'}%)`
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
  let {hsv} = getSelectedColor()

  let logRef = (hsv: State.hsv) => {
    switch canvasRef.current {
    | Value(canvas) => canvas->drawColorWheel(hsv)
    | Null | Undefined => Js.Console.log("canvas is not set yet")
    }
  }

  useEffect3(() => {
    logRef(hsv)

    None
  }, (hsv.h, hsv.s, hsv.v))

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

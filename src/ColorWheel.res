open Preact

let colors = ["red", "orange", "yellow", "green", "cyan", "blue", "magenta", "red"]

let drawColorWheel = (canvas: Canvas.canvas) => {
  let ctx = canvas->Canvas.getContext(#in2d)
  let gradient = ctx->Canvas.Context.createConicGradient(~startAngle=0, ~x=300, ~y=300)
  let totalColors = colors->Array.length
  let interval = 1.0 /. totalColors->Int.toFloat

  colors->Array.forEachWithIndex((color, index) => {
    let i = index->Int.toFloat
    let offset = i *. interval
    gradient->Canvas.Gradient.addColorStop(~offset, ~color)
  })

  ctx->Canvas.Context.beginPath
  ctx->Canvas.Context.arc(
    ~x=300,
    ~y=300,
    ~radius=300,
    ~startAngle=0.0,
    ~endAngle=2.0 *. Math.Constants.pi,
  )
  ctx->Canvas.Context.closePath
  ctx->Canvas.Context.setFillStyle(#gradient(gradient))
  ctx->Canvas.Context.fill
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

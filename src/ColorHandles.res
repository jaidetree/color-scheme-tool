open Preact

type handleState = {
  x: int,
  y: int,
}

let handleSignal: Signal.t<handleState> = Signal.make({
  x: 300,
  y: 300,
})

@jsx.component
let make = (~children: Preact.element) => {
  let onClick = (e: JsxEvent.Mouse.t) => {
    let container = e->JsxEvent.Mouse.currentTarget->DomUtils.target
    let element =
      container
      ->DomUtils.querySelector("canvas")
      ->Option.getExn(~message="Canvas element not found")
    let rect = element->DomUtils.getBoundingClientRect
    let scrollX = DomUtils.Window.scrollX
    let scrollY = DomUtils.Window.scrollY

    let pageX = e->JsxEvent.Mouse.pageX
    let pageY = e->JsxEvent.Mouse.pageY

    let x = pageX - rect.left - scrollX
    let y = pageY - rect.top - scrollY

    let relativeX = x - 300
    let relativeY = y - 300

    let hyp = Math.hypot(relativeX->Int.toFloat, relativeY->Int.toFloat)

    let paddingX = 32
    let paddingY = 32

    let coords: handleState = if hyp > 300.0 {
      let w = relativeY->Int.toFloat *. 300.0 /. hyp
      let z = relativeX->Int.toFloat *. 300.0 /. hyp

      {
        x: z->Math.round->Float.toInt + 300,
        y: w->Math.round->Float.toInt + 300,
      }
    } else {
      {
        x,
        y,
      }
    }

    handleSignal->Signal.set({
      x: coords.x + paddingX,
      y: coords.y + paddingY,
    })

    let angle =
      Math.atan2(~y=relativeY->Int.toFloat, ~x=relativeX->Int.toFloat) *. 180.0 /. Math.Constants.pi

    Js.Console.log({
      "x": relativeX,
      "y": relativeY,
      "hyp": hyp,
      "saturation": hyp->Float.clamp(~min=0.0, ~max=300.0) /. 300.0 *. 100.0,
      "hue": angle,
    })
  }

  let {x, y} = handleSignal->Signal.get

  <div className="handles-ui relative p-8" onClick>
    <div
      className="handle absolute bg-black/50 border border-white/70 size-5
      rounded-full transform translate-x-[-10px] translate-y-[-10px]"
      style={{left: `${x->Int.toString}px`, top: `${y->Int.toString}px`}}
    />
    children
  </div>
}

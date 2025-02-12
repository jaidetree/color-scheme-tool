open Preact
open State

type dragAction =
  | MouseDown(JsxEvent.Mouse.t)
  | MouseMove(Dom.mouseEvent)
  | MouseUp(Dom.mouseEvent)

type disposable = unit => unit
type dispatch = dragAction => unit
type effect = dispatch => option<disposable>

type dragState =
  | Init
  | Idle(int, int)
  | Dragging(int, int)

type machineState = {
  state: dragState,
  effect: option<effect>,
}

type transition = {
  prev: machineState,
  next: machineState,
}

let dragFsmSignal: Signal.t<transition> = Signal.make({
  prev: {state: Init, effect: None},
  next: {state: Init, effect: None},
})

let dispatch: dragAction => unit = action => {
  let {next: prev} = dragFsmSignal->Signal.get

  let next: machineState = switch (prev.state, action) {
  | (Init, MouseDown(e))
  | (Idle(_, _), MouseDown(e)) => {
      let x = e->JsxEvent.Mouse.pageX
      let y = e->JsxEvent.Mouse.pageY
      let createListeners = dispatch => {
        let onMouseMove = (event: Dom.mouseEvent) => {
          dispatch(MouseMove(event))
        }
        let onMouseUp = (event: Dom.mouseEvent) => {
          dispatch(MouseUp(event))
        }
        DomUtils.window->DomUtils.Event.addEventListener("mousemove", onMouseMove)
        DomUtils.window->DomUtils.Event.addEventListener(
          "mouseup",
          onMouseUp,
          ~opts={
            once: true,
          },
        )
        Some(
          () => {
            DomUtils.window->DomUtils.Event.removeEventListener("mousemove", onMouseMove)
            DomUtils.window->DomUtils.Event.removeEventListener("mouseup", onMouseUp)
          },
        )
      }
      {state: Dragging(x, y), effect: Some(createListeners)}
    }
  | (Idle(_, _), MouseMove(_))
  | (Idle(_, _), MouseUp(_)) => prev

  | (Dragging(_, _), MouseMove(e)) => {
      let x = e->DomUtils.MouseEvent.pageX
      let y = e->DomUtils.MouseEvent.pageY
      {state: Dragging(x, y), effect: prev.effect}
    }
  | (Dragging(_, _), MouseUp(e)) => {
      let x = e->DomUtils.MouseEvent.pageX
      let y = e->DomUtils.MouseEvent.pageY
      {state: Idle(x, y), effect: None}
    }
  | (Dragging(_, _), MouseDown(_)) => prev

  | (Init, _) => prev
  }

  dragFsmSignal->Signal.set({
    prev,
    next,
  })
}

let cleanupEffectRef: ref<option<disposable>> = ref(None)

Signal.effect(() => {
  let {prev, next} = dragFsmSignal->Signal.get
  let prevCleanup = cleanupEffectRef.contents

  let cleanup = switch (prev.effect, next.effect) {
  | (None, Some(effect)) => effect(dispatch)
  // Effect has not changed since last transition, keep the effect going
  | (Some(prevEffect), Some(nextEffect)) if prevEffect === nextEffect => prevCleanup
  // Effect has changed since the last transition, which also had an effect
  | (Some(_prevEffect), Some(nextEffect)) => {
      prevCleanup->Option.forEach(cleanup => cleanup())
      nextEffect(dispatch)
    }
  | (Some(_prevEffect), None) => {
      prevCleanup->Option.forEach(cleanup => cleanup())
      None
    }
  | (None, None) => None
  }

  cleanupEffectRef.contents = cleanup

  None
})

module Triangle = {
  type t = {
    angle: float,
    x: float,
    y: float,
    hyp: float,
  }

  let fromPos = (~pageX: int, ~pageY: int) => {
    let element = DomUtils.Document.getElementById("color-wheel")
    switch element {
    | Some(element) => {
        let rect = element->DomUtils.getBoundingClientRect
        let scrollX = DomUtils.Window.scrollX
        let scrollY = DomUtils.Window.scrollY

        let x = pageX - rect.left - scrollX
        let y = pageY - rect.top - scrollY

        let relativeX = x->Int.toFloat -. 300.0
        let relativeY = y->Int.toFloat -. 300.0

        let hyp = Math.hypot(relativeX, relativeY)

        let angle = Math.atan2(~x=relativeX, ~y=relativeY) *. 180.0 /. Math.Constants.pi
        let angle = if angle < 0.0 {
          360.0 +. angle
        } else {
          angle
        }

        if hyp > 300.0 {
          let w = relativeY *. 300.0 /. hyp
          let z = relativeX *. 300.0 /. hyp
          {
            angle,
            x: z->Math.round +. 300.0,
            y: w->Math.round +. 300.0,
            hyp: 300.0,
          }
        } else {
          {
            angle,
            x: x->Int.toFloat,
            y: y->Int.toFloat,
            hyp,
          }
        }
      }
    | None => {x: 332.0, y: 332.0, hyp: 300.0, angle: 0.0}
    }
  }

  let toColor = ({hyp, angle}: t) => {
    let h = Float.toInt(360.0 -. angle)
    let s = Float.toInt(hyp->Float.clamp(~min=0.0, ~max=300.0) /. 300.0 *. 100.0)

    (h, s)
  }

  let fromHS = (~h: int, ~s: int): t => {
    let h' = h->Int.toFloat
    let theta = Math.Constants.pi *. (h' -. 360.0) /. 180.0
    let hyp = s->Int.toFloat /. 100.0 *. 300.0
    let x = hyp *. Math.cos(theta)
    let y = hyp *. Math.sin(theta)

    {
      angle: h' +. 360.0,
      x,
      y,
      hyp,
    }
  }

  let translateToWheel = ({angle, hyp, x, y}: t): option<t> => {
    canvasSignal
    ->Signal.get
    ->Option.map(canvas => {
      let rect = canvas->DomUtils.getBoundingClientRect
      let offsetX = rect.width->Int.toFloat /. 2.0
      let offsetY = rect.height->Int.toFloat /. 2.0

      let x = x +. offsetX
      let y = offsetY -. y

      {angle, hyp, x, y}
    })
  }
}

type handleState = {
  x: int,
  y: int,
}

let handleSignal: Signal.t<handleState> = Signal.make({x: 0, y: 0})

let moveCursor = ({x, y}: Triangle.t) => {
  let paddingX = 32
  let paddingY = 32

  handleSignal->Signal.set({
    x: x->Float.toInt + paddingX,
    y: y->Float.toInt + paddingY,
  })
}

Signal.effect(() => {
  let {next: {state}} = dragFsmSignal->Signal.get

  switch state {
  | Init => ()
  | Idle(x, y)
  | Dragging(x, y) => {
      let triangle = Triangle.fromPos(~pageX=x, ~pageY=y)

      moveCursor(triangle)

      let (h, s) = triangle->Triangle.toColor

      setSelectedColor(HS(h, s))
    }
  }

  None
})

Signal.effect(() => {
  let action = Actions.signal->Signal.get

  switch action {
  | InitHSV({hsv})
  | RGB({hsv})
  | HSV({hsv})
  | Hex({hsv}) => {
      let {h, s} = hsv
      Triangle.fromHS(~h, ~s)
      ->Triangle.translateToWheel
      ->Option.forEach(moveCursor)
    }
  | Wheel(_) => ()
  }

  None
})

@jsx.component
let make = (~children: Preact.element) => {
  let onMouseDown = useCallback0((e: JsxEvent.Mouse.t) => {
    dispatch(MouseDown(e))
  })

  let {x, y} = handleSignal->Signal.get
  let {rgb} = State.getSelectedColor()

  <div className="handles-ui relative p-8">
    <button
      className="handle absolute bg-black border border-black size-5 rounded-full transform translate-x-[-10px] translate-y-[-10px] z-40"
      style={{
        left: `${x->Int.toString}px`,
        top: `${y->Int.toString}px`,
        backgroundColor: `rgb(${rgb.r->Int.toString}, ${rgb.g->Int.toString}, ${rgb.b->Int.toString})`,
      }}
      type_="button"
      onMouseDown={onMouseDown}
    />
    <div className="handle-bars absolute left-0 top-0 right-0 bottom-0 p-8 z-30">
      <svg viewBox="0 0 600 600" width="600" height="600">
        <line
          x1="300"
          y1="300"
          x2={Int.toString(x - 32)}
          y2={Int.toString(y - 32)}
          stroke="rgba(0, 0, 0, 0.5)"
          style={{
            strokeWidth: "2",
            strokeLinecap: "round",
          }}
        />
      </svg>
    </div>
    children
  </div>
}

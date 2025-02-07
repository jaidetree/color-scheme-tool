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
  next: {state: Idle(632, 332), effect: None},
})

let dispatch: dragAction => unit = action => {
  let {next: prev} = dragFsmSignal->Signal.get

  let next: machineState = switch (prev.state, action) {
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

let cleanupEffectRef = ref(None)

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

  () => {
    ()
  }
})

type triangle = {
  angle: float,
  x: float,
  y: float,
  hyp: float,
}

let calcTriangle = (~pageX: int, ~pageY: int) => {
  let element = DomUtils.Document.getElementById("color-wheel")
  switch element {
  | Some(element) => {
      Js.Console.log2("canvas", element)
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

let triangleSignal: Signal.t<triangle> = Signal.computed(() => {
  let {next: {state}} = dragFsmSignal->Signal.get

  let (pageX, pageY) = switch state {
  | Init => (332, 332)
  | Idle(x, y) => (x, y)
  | Dragging(x, y) => (x, y)
  }

  calcTriangle(~pageX, ~pageY)
})

type handleState = {
  x: int,
  y: int,
}

let constrainCursor = ({x, y}: triangle) => {
  let paddingX = 32
  let paddingY = 32

  {
    x: x->Float.toInt + paddingX,
    y: y->Float.toInt + paddingY,
  }
}

let handleSignal: Signal.t<handleState> = Signal.computed(() => {
  let triangle = triangleSignal->Signal.get

  constrainCursor(triangle)
})

let triangleToColor = ({hyp, angle}: triangle) => {
  let h = Float.toInt(360.0 -. angle)
  let s = Float.toInt(hyp->Float.clamp(~min=0.0, ~max=300.0) /. 300.0 *. 100.0)

  let {hsv} = peekSelectedColor()
  let {v} = hsv

  (h, s, v)
}

Signal.effect(() => {
  let triangle = triangleSignal->Signal.get
  let (h, s, v) = triangleToColor(triangle)

  setSelectedColor(HSV(h, s, v))->ignore

  () => {
    ()
  }
})

@jsx.component
let make = (~children: Preact.element) => {
  let onMouseDown = useCallback0((e: JsxEvent.Mouse.t) => {
    dispatch(MouseDown(e))
  })

  let {x, y} = handleSignal->Signal.get

  <div className="handles-ui relative p-8">
    <button
      className="handle absolute bg-black border border-white/70 size-5 rounded-full transform translate-x-[-10px] translate-y-[-10px] z-40"
      style={{left: `${x->Int.toString}px`, top: `${y->Int.toString}px`}}
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

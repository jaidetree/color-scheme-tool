open Preact
open State

@jsx.component
let make = () => {
  let {hsv} = colorDataSignal->Signal.get

  <input
    type_="range"
    name="brightness"
    className="w-full h-[32rem]"
    min="0"
    max="100.00"
    step={Obj.magic("any")}
    orient="vertical"
    value={hsv.v->Int.toString}
    onInput={e => {
      e
      ->JsxEvent.Form.currentTarget
      ->DomUtils.Event.getValue
      ->Option.flatMap(Int.fromString(_, ~radix=10))
      ->Option.getOr(0)
      ->setBrightness
    }}
    style={{appearance: "slider-vertical"}}
  />
}

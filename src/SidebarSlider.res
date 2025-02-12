open Preact
open State

type setter = int => Actions.partialInput
type getter = colorState => int

@jsx.component
let make = (
  ~label: string,
  ~id: string,
  ~set: setter,
  ~get: getter,
  ~className: string="",
  ~min: string="0",
  ~max: string="100",
) => {
  let id = `id_props_${id}`
  let valueSignal = Signal.useComputed(() => {
    let color = getSelectedColor()
    get(color)->Int.toString
  })
  let value = valueSignal->Signal.get
  let onInput = useCallback0((event: JsxEvent.Form.t) => {
    let value =
      event
      ->JsxEvent.Form.currentTarget
      ->DomUtils.Event.getValue
      ->Option.flatMap(str => Int.fromString(str))

    switch value {
    | Some(value) => value->set->setSelectedColor
    | None => ()
    }
  })
  <div className={`flex flex-row gap-2 ${className->String.length > 0 ? " " ++ className : ""}`}>
    <label className="w-20" htmlFor={id}> {Preact.string(label)} </label>
    <input
      type_="text" id={id} className="w-10 bg-gray-800 text-right px-1" value={value} onInput
    />
    <input type_="range" min={min} max={max} className="w-full" value={value} onInput />
  </div>
}

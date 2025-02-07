module AbortController = {
  module Signal = {
    type t = {
      aborted: bool,
      reason: option<string>,
    }

    @send
    external throwIfAborted: t => unit = "throwIfAborted"

    @scope("AbortSignal") @val
    external abort: unit => t = "abort"

    @scope("AbortSignal") @val
    external any: array<t> => t = "any"

    @scope("AbortSignal") @val
    external timeout: int => t = "timeout"
  }

  type t = {signal: Signal.t}

  @new @module
  external make: unit => t = "AbortController"

  @send
  external abort: t => unit = "abort"

  @get
  external signal: t => Signal.t = "signal"
}

module Event = {
  type addListenerOptions = {
    capture?: bool,
    once?: bool,
    passive?: bool,
    signal?: AbortController.Signal.t,
  }
  type removeListenerOptions = {capture?: bool}

  type listener<'a> = Dom.event_like<'a> => unit

  @send
  external addEventListener: (
    Dom.element,
    string,
    listener<'a>,
    ~opts: addListenerOptions=?,
  ) => unit = "addEventListener"

  @send
  external removeEventListener: (
    Dom.element,
    string,
    listener<'a>,
    ~opts: removeListenerOptions=?,
  ) => unit = "removeEventListener"

  @get @return(nullable)
  external getValue: {..} => option<string> = "value"
}

module MouseEvent = {
  type t = Dom.mouseEvent
  @get external pageX: t => int = "pageX"
  @get external pageY: t => int = "pageY"

  @get
  external target: t => Dom.eventTarget = "target"

  @get
  external currentTarget: t => Dom.eventTarget = "currentTarget"
}

type domRect = {
  x: int,
  y: int,
  width: int,
  height: int,
  top: int,
  right: int,
  bottom: int,
  left: int,
}

@send external getBoundingClientRect: Dom.element => domRect = "getBoundingClientRect"
external target: {..} => Dom.element = "%identity"

@send @return(nullable)
external querySelector: (Dom.element, string) => option<Dom.element> = "querySelector"

module Document = {
  @val @scope("document") @return(nullable)
  external getElementById: string => option<Dom.element> = "getElementById"
}

@val external document: Dom.document = "document"

module Window = {
  type t = Dom.element
  @val @scope("window") external scrollX: int = "scrollX"
  @val @scope("window") external scrollY: int = "scrollY"
}

@val external window: Window.t = "window"

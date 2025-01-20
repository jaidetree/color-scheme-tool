module Event = {
  @get @return(nullable) external getValue: {..} => option<string> = "value"
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

module Window = {
  @val @scope("window") external scrollX: int = "scrollX"
  @val @scope("window") external scrollY: int = "scrollY"
}

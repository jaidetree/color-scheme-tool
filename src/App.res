open Preact
open State

@jsx.component
let make = () => {
  <div className="bg-gray-900 min-h-screen text-white flex flex-row items-stretch">
    <main className="flex flex-col flex-grow">
      <div className="color-list bg-gray-950/40 p-8">
        <ul className="h-full grid grid-cols-5 gap-4">
          {colorsSignal
          ->Signal.get
          ->Array.mapWithIndex((color, i) => {
            <li key={i->Int.toString} className="flex flex-col items-center justify-stretch gap-2">
              {Preact.string("#" ++ color.hex)}
              <div
                className="flex flex-col items-center justify-end rounded-lg border border-white w-full h-[16rem]"
                style={{backgroundColor: "#" ++ color.hex}}
              />
            </li>
          })
          ->Preact.array}
        </ul>
      </div>
      <div className="color-wheel p-16 flex flex-row justify-center items-center gap-8">
        <ColorHandles>
          <ColorWheel />
        </ColorHandles>
        <BrightnessSlider />
      </div>
      <div className="flex flex-row justify-center gap-2">
        <button> {Preact.string("Custom")} </button>
        <button> {Preact.string("Monochromatic")} </button>
        <button> {Preact.string("Analogous")} </button>
        <button> {Preact.string("Complementary")} </button>
        <button> {Preact.string("Split Complementary")} </button>
        <button> {Preact.string("Triad")} </button>
        <button> {Preact.string("Quads")} </button>
      </div>
    </main>
    <aside className="sidebar bg-gray-950 w-96 flex flex-col gap-4">
      <nav className="p-8 flex flex-row items-start gap-2">
        <button value="properties"> {Preact.string("inspector")} </button>
        <button value="palettes"> {Preact.string("palettes")} </button>
      </nav>
      <section>
        <form className="p-8 flex flex-col gap-2">
          <SidebarSlider
            label="Red" id="red" get={({rgb}) => rgb.r} set={v => State.Actions.R(v)} max="255"
          />
          <SidebarSlider
            label="Green" id="green" get={({rgb}) => rgb.g} set={v => State.Actions.G(v)} max="255"
          />
          <SidebarSlider
            label="Blue"
            id="blue"
            get={({rgb}) => rgb.b}
            set={v => State.Actions.B(v)}
            max="255"
            className="mb-4"
          />
          <SidebarSlider
            label="Hue" id="hue" get={({hsv}) => hsv.h} set={v => State.Actions.H(v)} max="360"
          />
          <SidebarSlider
            label="Sat" id="sat" get={({hsv}) => hsv.s} set={v => State.Actions.S(v)}
          />
          <SidebarSlider
            label="Value"
            id="val"
            get={({hsv}) => hsv.v}
            set={v => State.Actions.V(v)}
            className="mb-4"
          />
          <div className="flex flex-row justify-between gap-2 mb-4">
            <label className="w-20" htmlFor="id_props_hex"> {Preact.string("Hex")} </label>
            <input
              type_="text"
              id="id_props_hex"
              value={getSelectedColor().hex}
              className="w-24 bg-gray-800 text-right px-2 font-mono"
              onInput={e => {
                e
                ->JsxEvent.Form.currentTarget
                ->DomUtils.Event.getValue
                ->Option.getOr("0e0e0e")
                ->Hex
                ->setSelectedColor
              }}
            />
          </div>
        </form>
      </section>
      <section className="flex flex-col gap-2 justify-center">
        <button> {Preact.string("Insert Swatch Before")} </button>
        <button> {Preact.string("Insert Swatch After")} </button>
        <button> {Preact.string("Delete Swatch")} </button>
      </section>
    </aside>
  </div>
}

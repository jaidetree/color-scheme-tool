open Preact

let count = Signal.make(0)

@jsx.component
let make = () => {
  <div className="bg-gray-900 min-h-screen text-white flex flex-row items-stretch">
    <main className="flex flex-col flex-grow">
      <div className="color-list bg-gray-950/40 h-72 p-8">
        <ul className="h-full grid grid-cols-5 gap-4">
          <li className="flex flex-col items-center justify-end p-4 rounded-lg border border-white">
            {Preact.string("#ffffff")}
          </li>
          <li className="flex flex-col items-center justify-end p-4 rounded-lg border border-white">
            {Preact.string("#ffffff")}
          </li>
          <li className="flex flex-col items-center justify-end p-4 rounded-lg border border-white">
            {Preact.string("#ffffff")}
          </li>
          <li className="flex flex-col items-center justify-end p-4 rounded-lg border border-white">
            {Preact.string("#ffffff")}
          </li>
          <li className="flex flex-col items-center justify-end p-4 rounded-lg border border-white">
            {Preact.string("#ffffff")}
          </li>
        </ul>
      </div>
      <div className="color-wheel p-16">
        <svg viewBox="0 0 600 600">
          <circle r="300" cx="300" cy="300" fill="white" />
        </svg>
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
    <aside className="sidebar flex bg-gray-950 w-80 flex flex-col gap-4">
      <nav className="p-4 flex flex-row items-start gap-2">
        <button value="properties"> {Preact.string("inspector")} </button>
        <button value="palettes"> {Preact.string("palettes")} </button>
      </nav>
      <section>
        <form className="p-4 flex flex-col gap-2">
          <div className="flex flex-row gap-2">
            <label className="w-20" htmlFor="id_props_red"> {Preact.string("Red")} </label>
            <input
              type_="text" id="id_props_red" className="w-10 bg-gray-800 text-right px-2" value="50"
            />
            <input type_="range" min="0" max="255" className="w-full" value="50" />
          </div>
          <div className="flex flex-row gap-2">
            <label className="w-20" htmlFor="id_props_green"> {Preact.string("Green")} </label>
            <input
              type_="text"
              id="id_props_green"
              className="w-10 bg-gray-800 text-right px-2"
              value="50"
            />
            <input type_="range" min="0" max="255" className="w-full" value="50" />
          </div>
          <div className="flex flex-row gap-2 mb-4">
            <label className="w-20" htmlFor="id_props_blue"> {Preact.string("Blue")} </label>
            <input
              type_="text"
              id="id_props_blue"
              className="w-10 bg-gray-800 text-right px-2"
              value="50"
            />
            <input type_="range" min="0" max="255" className="w-full" value="50" />
          </div>
          <div className="flex flex-row gap-2">
            <label className="w-20" htmlFor="id_props_hue"> {Preact.string("Hue")} </label>
            <input
              type_="text" id="id_props_hue" className="w-10 bg-gray-800 text-right px-2" value="50"
            />
            <input type_="range" min="0" max="360" className="w-full" value="50" />
          </div>
          <div className="flex flex-row gap-2">
            <label className="w-20" htmlFor="id_props_saturation"> {Preact.string("Sat")} </label>
            <input
              type_="text"
              id="id_props_saturation"
              className="w-10 bg-gray-800 text-right px-2"
              value="50"
            />
            <input type_="range" min="0" max="100" className="w-full" value="50" />
          </div>
          <div className="flex flex-row gap-2 mb-4">
            <label className="w-20" htmlFor="id_props_brightness"> {Preact.string("Light")} </label>
            <input
              type_="text"
              id="id_props_brightness"
              className="w-10 bg-gray-800 text-right px-2"
              value="50"
            />
            <input type_="range" min="0" max="100" className="w-full" value="50" />
          </div>
          <div className="flex flex-row justify-between gap-2 mb-4">
            <label className="w-20" htmlFor="id_props_hex"> {Preact.string("Hex")} </label>
            <input
              type_="text" id="id_props_hex" value="#ffffff" className="w-16 bg-gray-800 px-2"
            />
          </div>
        </form>
      </section>
    </aside>
  </div>
}

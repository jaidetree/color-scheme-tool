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
    <aside className="sidebar flex bg-gray-950 w-80">
      <nav className="p-4 flex flex-row items-start gap-2">
        <button value="properties"> {Preact.string("inspector")} </button>
        <button value="palettes"> {Preact.string("palettes")} </button>
      </nav>
    </aside>
  </div>
}

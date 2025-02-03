// Generated by ReScript, PLEASE EDIT WITH CARE

import * as State from "./State.res.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Float from "@rescript/core/src/Core__Float.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Signals from "@preact/signals";
import * as JsxRuntime from "preact/jsx-runtime";

var handleSignal = Signals.signal({
      x: 300,
      y: 300
    });

function ColorHandles(props) {
  var onClick = function (e) {
    var container = e.currentTarget;
    var element = Core__Option.getExn(Caml_option.nullable_to_opt(container.querySelector("canvas")), "Canvas element not found");
    var rect = element.getBoundingClientRect();
    var scrollX = window.scrollX;
    var scrollY = window.scrollY;
    var pageX = e.pageX;
    var pageY = e.pageY;
    var x = (pageX - rect.left | 0) - scrollX | 0;
    var y = (pageY - rect.top | 0) - scrollY | 0;
    var relativeX = x - 300.0;
    var relativeY = y - 300.0;
    var hyp = Math.hypot(relativeX, relativeY);
    var coords;
    if (hyp > 300.0) {
      var w = relativeY * 300.0 / hyp;
      var z = relativeX * 300.0 / hyp;
      coords = {
        x: (Math.round(z) | 0) + 300 | 0,
        y: (Math.round(w) | 0) + 300 | 0
      };
    } else {
      coords = {
        x: x,
        y: y
      };
    }
    handleSignal.value = {
      x: coords.x + 32 | 0,
      y: coords.y + 32 | 0
    };
    var angle = Math.atan2(relativeY, relativeX) * 180.0 / Math.PI;
    var angle$1 = angle < 0.0 ? 360.0 + angle : angle;
    var h = 360.0 - angle$1 | 0;
    var s = Core__Float.clamp(0.0, 300.0, hyp) / 300.0 * 100.0 | 0;
    var match = State.getSelectedColor();
    State.setSelectedColor({
          TAG: "HSV",
          _0: h,
          _1: s,
          _2: match.hsv.v
        });
  };
  var match = handleSignal.value;
  var y = match.y;
  var x = match.x;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      className: "handle absolute bg-black border border-white/70 size-5 rounded-full transform translate-x-[-10px] translate-y-[-10px] z-40",
                      style: {
                        left: x.toString() + "px",
                        top: y.toString() + "px"
                      }
                    }),
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("svg", {
                            children: JsxRuntime.jsx("line", {
                                  style: {
                                    strokeLinecap: "round",
                                    strokeWidth: "2"
                                  },
                                  stroke: "rgba(0, 0, 0, 0.5)",
                                  x1: "300",
                                  x2: (x - 32 | 0).toString(),
                                  y1: "300",
                                  y2: (y - 32 | 0).toString()
                                }),
                            height: "600",
                            width: "600",
                            viewBox: "0 0 600 600"
                          }),
                      className: "handle-bars absolute left-0 top-0 right-0 bottom-0 p-8 z-30"
                    }),
                props.children
              ],
              className: "handles-ui relative p-8",
              onClick: onClick
            });
}

var make = ColorHandles;

export {
  handleSignal ,
  make ,
}
/* handleSignal Not a pure module */

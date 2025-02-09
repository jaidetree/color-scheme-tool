// Generated by ReScript, PLEASE EDIT WITH CARE

import * as State from "./State.res.mjs";
import * as Core__Float from "@rescript/core/src/Core__Float.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Hooks from "preact/hooks";
import * as Signals from "@preact/signals";
import * as JsxRuntime from "preact/jsx-runtime";

var dragFsmSignal = Signals.signal({
      prev: {
        state: "Init",
        effect: undefined
      },
      next: {
        state: {
          TAG: "Idle",
          _0: 632,
          _1: 332
        },
        effect: undefined
      }
    });

function dispatch(action) {
  var match = dragFsmSignal.value;
  var prev = match.next;
  var match$1 = prev.state;
  var next;
  if (typeof match$1 !== "object") {
    next = prev;
  } else if (match$1.TAG === "Idle") {
    switch (action.TAG) {
      case "MouseDown" :
          var e = action._0;
          var x = e.pageX;
          var y = e.pageY;
          var createListeners = function (dispatch) {
            var onMouseMove = function ($$event) {
              dispatch({
                    TAG: "MouseMove",
                    _0: $$event
                  });
            };
            var onMouseUp = function ($$event) {
              dispatch({
                    TAG: "MouseUp",
                    _0: $$event
                  });
            };
            window.addEventListener("mousemove", onMouseMove);
            window.addEventListener("mouseup", onMouseUp, {
                  once: true
                });
            return (function () {
                      window.removeEventListener("mousemove", onMouseMove);
                      window.removeEventListener("mouseup", onMouseUp);
                    });
          };
          next = {
            state: {
              TAG: "Dragging",
              _0: x,
              _1: y
            },
            effect: createListeners
          };
          break;
      case "MouseMove" :
      case "MouseUp" :
          next = prev;
          break;
      
    }
  } else {
    switch (action.TAG) {
      case "MouseDown" :
          next = prev;
          break;
      case "MouseMove" :
          var e$1 = action._0;
          var x$1 = e$1.pageX;
          var y$1 = e$1.pageY;
          next = {
            state: {
              TAG: "Dragging",
              _0: x$1,
              _1: y$1
            },
            effect: prev.effect
          };
          break;
      case "MouseUp" :
          var e$2 = action._0;
          var x$2 = e$2.pageX;
          var y$2 = e$2.pageY;
          next = {
            state: {
              TAG: "Idle",
              _0: x$2,
              _1: y$2
            },
            effect: undefined
          };
          break;
      
    }
  }
  dragFsmSignal.value = {
    prev: prev,
    next: next
  };
}

var cleanupEffectRef = {
  contents: undefined
};

Signals.effect(function () {
      var match = dragFsmSignal.value;
      var prevCleanup = cleanupEffectRef.contents;
      var match$1 = match.prev.effect;
      var match$2 = match.next.effect;
      var cleanup = match$1 !== undefined ? (
          match$2 !== undefined ? (
              match$1 === match$2 ? prevCleanup : (Core__Option.forEach(prevCleanup, (function (cleanup) {
                          cleanup();
                        })), match$2(dispatch))
            ) : (Core__Option.forEach(prevCleanup, (function (cleanup) {
                      cleanup();
                    })), undefined)
        ) : (
          match$2 !== undefined ? match$2(dispatch) : undefined
        );
      cleanupEffectRef.contents = cleanup;
      return function () {
        
      };
    });

function calcTriangle(pageX, pageY) {
  var element = document.getElementById("color-wheel");
  if (element == null) {
    return {
            angle: 0.0,
            x: 332.0,
            y: 332.0,
            hyp: 300.0
          };
  }
  console.log("canvas", element);
  var rect = element.getBoundingClientRect();
  var scrollX = window.scrollX;
  var scrollY = window.scrollY;
  var x = (pageX - rect.left | 0) - scrollX | 0;
  var y = (pageY - rect.top | 0) - scrollY | 0;
  var relativeX = x - 300.0;
  var relativeY = y - 300.0;
  var hyp = Math.hypot(relativeX, relativeY);
  var angle = Math.atan2(relativeY, relativeX) * 180.0 / Math.PI;
  var angle$1 = angle < 0.0 ? 360.0 + angle : angle;
  if (hyp <= 300.0) {
    return {
            angle: angle$1,
            x: x,
            y: y,
            hyp: hyp
          };
  }
  var w = relativeY * 300.0 / hyp;
  var z = relativeX * 300.0 / hyp;
  return {
          angle: angle$1,
          x: Math.round(z) + 300.0,
          y: Math.round(w) + 300.0,
          hyp: 300.0
        };
}

var triangleSignal = Signals.computed(function () {
      var match = dragFsmSignal.value;
      var state = match.next.state;
      var match$1;
      match$1 = typeof state !== "object" ? [
          332,
          332
        ] : [
          state._0,
          state._1
        ];
      return calcTriangle(match$1[0], match$1[1]);
    });

function constrainCursor(param) {
  return {
          x: (param.x | 0) + 32 | 0,
          y: (param.y | 0) + 32 | 0
        };
}

var handleSignal = Signals.computed(function () {
      var triangle = triangleSignal.value;
      return constrainCursor(triangle);
    });

function triangleToColor(param) {
  var h = 360.0 - param.angle | 0;
  var s = Core__Float.clamp(0.0, 300.0, param.hyp) / 300.0 * 100.0 | 0;
  var match = State.peekSelectedColor();
  return [
          h,
          s,
          match.hsv.v
        ];
}

Signals.effect(function () {
      var triangle = triangleSignal.value;
      var match = triangleToColor(triangle);
      State.setSelectedColor({
            TAG: "HSV",
            _0: match[0],
            _1: match[1],
            _2: match[2]
          });
      return function () {
        
      };
    });

function ColorHandles(props) {
  var onMouseDown = Hooks.useCallback((function (e) {
          dispatch({
                TAG: "MouseDown",
                _0: e
              });
        }), []);
  var match = handleSignal.value;
  var y = match.y;
  var x = match.x;
  var match$1 = State.getSelectedColor();
  var rgb = match$1.rgb;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("button", {
                      className: "handle absolute bg-black border border-black size-5 rounded-full transform translate-x-[-10px] translate-y-[-10px] z-40",
                      style: {
                        backgroundColor: "rgb(" + rgb.r.toString() + ", " + rgb.g.toString() + ", " + rgb.b.toString() + ")",
                        left: x.toString() + "px",
                        top: y.toString() + "px"
                      },
                      type: "button",
                      onMouseDown: onMouseDown
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
              className: "handles-ui relative p-8"
            });
}

var make = ColorHandles;

export {
  dragFsmSignal ,
  dispatch ,
  cleanupEffectRef ,
  calcTriangle ,
  triangleSignal ,
  constrainCursor ,
  handleSignal ,
  triangleToColor ,
  make ,
}
/* dragFsmSignal Not a pure module */

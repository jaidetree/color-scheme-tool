module HSL = {
  type t = (int, int, int)

  let toRgb = ((h, s, l): t) => {
    let h = h->Int.toFloat
    let s = s->Int.toFloat
    let l = l->Int.toFloat

    let s = s /. 100.0
    let l = l /. 100.0

    let c = (1.0 -. (2.0 *. l -. 1.0)->Math.abs) *. s
    let h' = h /. 60.0
    let x = c *. (1.0 -. Math.abs(Float.mod(h', 2.0) -. 1.0))
    let m = l -. c /. 2.0

    let (r', g', b') = if 0.0 <= h && h <= 60.0 {
      (c, x, 0.0)
    } else if h <= 120.0 {
      (x, c, 0.0)
    } else if h <= 180.0 {
      (0.0, c, x)
    } else if h <= 240.0 {
      (0.0, x, c)
    } else if h <= 300.0 {
      (x, 0.0, c)
    } else {
      (c, 0.0, x)
    }

    let normalize = (v: float) => {
      ((v +. m) *. 255.0)->Math.round->Float.toInt
    }
    (r'->normalize, g'->normalize, b'->normalize)
  }
}

module RGB = {
  type t = (int, int, int)

  let toHex = ((r, g, b): t, ~prefix: bool=false) => {
    let prefix = prefix ? "#" : ""
    let hexStr =
      lsl(1, 24)
      ->lor(lsl(r, 16))
      ->lor(lsl(g, 8))
      ->lor(b)
      ->Int.toString(~radix=16)
      ->String.sliceToEnd(~start=1)

    prefix ++ hexStr
  }

  let toHsl = ((r, g, b): t) => {
    let r = r->Int.toFloat /. 255.0
    let g = g->Int.toFloat /. 255.0
    let b = b->Int.toFloat /. 255.0

    let floats = [r, g, b]

    let max = Math.maxMany(floats)
    let min = Math.minMany(floats)

    let delta = max -. min

    let lightness = (max +. min) /. 2.0

    let saturation = if max == min {
      0.0
    } else if lightness > 0.5 {
      delta /. (2.0 -. max -. min)
    } else {
      delta /. (max +. min)
    }

    let hue' = if max === min {
      0.0
    } else if max == r {
      Float.mod((g -. b) /. delta, 6.0)
    } else if max == g {
      (b -. r) /. delta +. 2.0
    } else {
      // It must be equal to b
      (r -. g) /. delta +. 4.0
    }
    // No catch-all needed as there should be no situation where the max is not
    // equal to r, g, or b,

    let hue = (hue' *. 60.0)->Math.round->Float.toInt
    let hue = if hue < 0 {
      hue + 360
    } else {
      hue
    }

    let saturation = (saturation *. 100.0)->Math.round->Float.toInt
    let lightness = (lightness *. 100.0)->Math.round->Float.toInt

    (hue, saturation, lightness)
  }
}

module Hex = {
  let toRgb = (fullHexStr: string) => {
    let hexStr = fullHexStr->String.replace("#", "")
    let int = hexStr->Int.fromString(~radix=16)->Option.getOr(0)

    let r = int->asr(16)->land(255)
    let g = int->asr(8)->land(255)
    let b = int->land(255)

    (r, g, b)
  }
}

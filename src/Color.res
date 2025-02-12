module HSV = {
  type t = (int, int, int)

  let toRGB = ((h, s, v)) => {
    let h' = h->Int.toFloat
    let s' = s->Int.toFloat /. 100.0
    let v' = v->Int.toFloat /. 100.0

    let c = v' *. s'
    let x = c *. (1.0 -. Math.abs(Float.mod(h' /. 60.0, 2.0) -. 1.0))
    let m = v' -. c

    let (r', g', b') = if 0 <= h && h < 60 {
      (c, x, 0.0)
    } else if h <= 120 {
      (x, c, 0.0)
    } else if h <= 180 {
      (0.0, c, x)
    } else if h <= 240 {
      (0.0, x, c)
    } else if h <= 300 {
      (x, 0.0, c)
    } else if h <= 360 {
      (c, 0.0, x)
    } else {
      (0.0, 0.0, 0.0)
    }

    let r = ((r' +. m) *. 255.0)->Math.round->Float.toInt
    let g = ((g' +. m) *. 255.0)->Math.round->Float.toInt
    let b = ((b' +. m) *. 255.0)->Math.round->Float.toInt

    (r, g, b)
  }

  let toHSL = ((h: int, sv: int, v: int)) => {
    let v = v->Int.toFloat /. 100.0
    let sv = sv->Int.toFloat /. 100.0

    let l = v *. (1.0 -. sv /. 2.0)
    let s = if l == 0.0 || l == 1.0 {
      0.0
    } else {
      (v -. l) /. Math.min(l, 1.0 -. l)
    }
    let s = (s *. 100.0)->Math.round->Float.toInt
    let l = (l *. 100.0)->Math.round->Float.toInt

    (h, s, l)
  }
}

module HSL = {
  type t = (int, int, int)

  let toRGB = ((h, s, l): t) => {
    let h' = h->Int.toFloat
    let s = s->Int.toFloat /. 100.0
    let l = l->Int.toFloat /. 100.0

    let c = (1.0 -. Math.abs(2.0 *. l -. 1.0)) *. s
    let x = c *. (1.0 -. Math.abs(Float.mod(h' /. 60.0, 2.0) -. 1.0))
    let m = l -. c /. 2.0

    let (r', g', b') = if 0 <= h && h < 60 {
      (c, x, 0.0)
    } else if h <= 120 {
      (x, c, 0.0)
    } else if h <= 180 {
      (0.0, c, x)
    } else if h <= 240 {
      (0.0, x, c)
    } else if h <= 300 {
      (x, 0.0, c)
    } else if h <= 360 {
      (c, 0.0, x)
    } else {
      (0.0, 0.0, 0.0)
    }

    let r = ((r' +. m) *. 255.0)->Math.round->Float.toInt
    let g = ((g' +. m) *. 255.0)->Math.round->Float.toInt
    let b = ((b' +. m) *. 255.0)->Math.round->Float.toInt

    (r, g, b)
  }

  let toHSV = ((h, sl, l)) => {
    let sl = sl->Int.toFloat /. 100.0
    let l = l->Int.toFloat /. 100.0
    let v = l +. sl *. Math.min(l, 1.0 -. l)

    let s = if v == 0.0 {
      0.0
    } else {
      2.0 *. (1.0 -. l /. v)
    }

    let s = (s *. 100.0)->Math.round->Float.toInt
    let v = (v *. 100.0)->Math.round->Float.toInt

    (h, s, v)
  }
}

module RGB = {
  type t = (int, int, int)

  let toHex = ((r, g, b), ~prefix=false) => {
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

  let toHSL = ((r, g, b): t) => {
    let r' = r->Int.toFloat /. 255.0
    let g' = g->Int.toFloat /. 255.0
    let b' = b->Int.toFloat /. 255.0

    let cmax = Math.maxMany([r', g', b'])
    let cmin = Math.minMany([r', g', b'])

    let delta = cmax -. cmin

    let h =
      if cmax == r' {
        Float.mod((g' -. b') /. delta, 6.0) *. 60.0
      } else if cmax == g' {
        ((b' -. r') /. delta +. 2.0) *. 60.0
      } else if cmax == b' {
        ((r' -. g') /. delta +. 4.0) *. 60.0
      } else {
        0.0
      }
      ->Math.round
      ->Float.toInt

    let l = (cmax +. cmin) /. 2.0

    let s =
      (if delta != 0.0 {
        delta /. (1.0 -. Math.abs(2.0 *. l -. 1.0))
      } else {
        0.0
      } *. 100.0)
      ->Math.round
      ->Float.toInt

    let l = (l *. 100.0)->Math.round->Float.toInt

    (h, s, l)
  }

  let toHSV = ((r, g, b)) => {
    let r' = r->Int.toFloat /. 255.0
    let g' = g->Int.toFloat /. 255.0
    let b' = b->Int.toFloat /. 255.0

    let cmax = Math.maxMany([r', g', b'])
    let cmin = Math.minMany([r', g', b'])

    let delta = cmax -. cmin

    let h =
      if cmax == r' {
        Float.mod((g' -. b') /. delta, 6.0) *. 60.0
      } else if cmax == g' {
        ((b' -. r') /. delta +. 2.0) *. 60.0
      } else if cmax == b' {
        ((r' -. g') /. delta +. 4.0) *. 60.0
      } else {
        0.0
      }
      ->Math.round
      ->Float.toInt

    let h = if h < 0 {
      h + 360
    } else {
      h
    }

    let s =
      if cmax == 0.0 {
        0.0
      } else {
        delta /. cmax *. 100.0
      }
      ->Math.round
      ->Float.toInt

    let v = (cmax *. 100.0)->Math.round->Float.toInt

    (h, s, v)
  }
}

module Hex = {
  type t = string

  let toRGB = fullHexStr => {
    let hexStr = fullHexStr->String.replace("#", "")
    let int = hexStr->Int.fromString(~radix=16)->Option.getOr(0)

    let r = int->asr(16)->land(255)
    let g = int->asr(8)->land(255)
    let b = int->land(255)

    (r, g, b)
  }
}

module rec RGB: {
  type t = (int, int, int)
  let toHSV: t => HSV.t
  let toHSL: t => HSL.t
  let toHex: (t, ~prefix: bool=?) => Hex.t
}
and HSV: {
  type t = (int, int, int)

  let toRGB: t => RGB.t
  let toHSL: t => HSL.t
}

and HSL: {
  type t = (int, int, int)

  let toRGB: t => RGB.t
  let toHSV: t => HSV.t
}
and Hex: {
  type t = string

  let toRGB: t => RGB.t
}


import sequtils
type
  State = enum
    NORMAL, OO, FF

proc zeropack*(src: seq[byte]): seq[byte] =
  var
    dst: seq[byte] = newSeq[byte](len(src) + 1)
    ffcnt: byte = 0
    ffpos: int = 0
    oocnt: byte = 0
    oopos: int = 0
    dptr: int = 1 # reversed for esimated size
    bytes: array[8, byte]
    bptr: int = 0
    bitmap: byte = 0
    blen: int = len(src) + (if (len(src) mod 8) != 0: (8 - len(src) mod 8) else: 0)
    buf: seq[byte] = newSeq[byte](blen)
    state: State = NORMAL
  for i in 0..(len(src) - 1):
    buf[i] = src[i]
  for i in 0..((blen div 8) - 1):
    bptr = 0
    bitmap = 0
    for j in 0..7:
      if buf[i * 8 + j] != 0:
        bitmap = bitmap or cast[byte]((1 shl (8 - j - 1)))
        bytes[bptr] = buf[i * 8 + j]
        bptr += 1
    case bitmap:
      of 0x00:
        case state:
          of OO:
            if oocnt == 0xFF:
              dst[oopos] = 0xFF
              dst[dptr] = 0x00
              dptr += 1
              oopos = dptr
              dptr += 1
              oocnt = 1
            else:
              oocnt += 1
          of FF:
            dst[ffpos] = ffcnt
            state = OO
          else:
            dst[dptr] = 0x00
            dptr += 1
            oopos = dptr
            dptr += 1
            oocnt = 1
            state = OO
      of 0xFF:
        case state:
          of OO:
            dst[oopos] = oocnt
            state = FF
          of FF:
            if ffcnt == 0xFF:
              dst[ffpos] = 0xFF
              dst[dptr] = 0xFF
              dptr += 1
              ffpos = dptr
              dptr += 1
              ffcnt = 1
            else:
              ffcnt += 1
          else:
            dst[dptr] = 0xFF
            dptr += 1
            ffpos = dptr
            dptr += 1
            ffcnt = 1
            state = FF
        for k in 0..(bptr - 1):
          dst[dptr] = bytes[k]
          dptr += 1
      else:
        case state:
          of OO:
            dst[oopos] = oocnt
            state = NORMAL
          of FF:
            dst[ffpos] = ffcnt
            state = NORMAL
          else:
            discard
        dst[dptr] = bitmap
        dptr += 1
        for k in 0..(bptr - 1):
          dst[dptr] = bytes[k]
          dptr += 1
  if cast[int](oocnt) > 0:
    dst[oopos] = oocnt
  elif cast[int](ffcnt) > 0:
    dst[ffpos] = ffcnt
  dst[0] = cast[byte](blen div dptr + (if (blen mod dptr != 0): 1 else: 0))
  delete(dst, dptr + 1, len(dst))
  return dst

proc unzeropack*(src: seq[byte], start: int, slen: int): seq[byte] =
  var
    dst: seq[byte] = newSeq[byte](slen * cast[int](src[start]))
    sptr: int = start + 1
    dptr: int = 0
    cnt: int = 0
    stop: int = start + slen
  while sptr < stop:
    case src[sptr]:
      of 0:
        cnt = cast[int](src[sptr + 1])
        for i in 0..(cnt * 8 - 1):
          dst[i] = 0
        dptr += cnt * 8
        sptr += 2
      of 0xFF:
        cnt = cast[int](src[sptr + 1])
        for i in 0..(cnt * 8 - 1):
          dst[dptr + i] = src[sptr + 2 + i]
        dptr += cnt * 8
        sptr += 2 + cnt * 8
      else:
        cnt = 0
        var bitmap = src[sptr]
        for i in 0..7:
          if (bitmap and cast[byte](1 shl (8 - i - 1))) != 0:
            cnt += 1
            dst[dptr] = src[sptr + cnt]
            dptr += 1
          else:
            dst[dptr] = 0
            dptr += 1
        sptr += cnt + 1
  if dptr + 1 < len(dst):
    delete(dst, dptr + 1, len(dst))
  return dst

proc unzeropack*(src: seq[byte]): seq[byte] = unzeropack(src, 0, len(src))

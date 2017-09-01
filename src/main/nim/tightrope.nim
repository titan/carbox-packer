
template SHORT*(buf: seq[byte], bptr: int): int16 = cast[int16](((cast[int16](buf[bptr]) shl 8) and 0xFF00) or (cast[int16](buf[bptr + 1]) and 0xFF))
template SHORT0*(value: int16): byte = cast[byte]((value shr 8) and 0xFF)
template SHORT1*(value: int16): byte = cast[byte](value and 0xFF)

template assign_short*(buf: seq[byte], bptr: int, value: int16): untyped =
  buf[bptr] = SHORT0(value)
  bptr += 1
  buf[bptr] = SHORT1(value)
  bptr += 1

template assign_short_0*(buf: seq[byte], bptr: int): untyped =
  buf[bptr] = 0
  bptr += 1
  buf[bptr] = 0
  bptr += 1

template INT*(buf: seq[byte], bptr: int): int32 = cast[int32](((cast[int32](buf[bptr]) shl 24) and 0xFF000000) or ((cast[int32](buf[bptr + 1]) shl 16) and 0xFF0000) or ((cast[int32](buf[bptr + 2]) shl 8) and 0xFF00) or (cast[int32](buf[bptr + 3]) and 0xFF))
template INT0(value: int32): byte = cast[byte]((value shr 24) and 0xFF)
template INT1(value: int32): byte = cast[byte]((value shr 16) and 0xFF)
template INT2(value: int32): byte = cast[byte]((value shr 8) and 0xFF)
template INT3(value: int32): byte = cast[byte](value and 0xFF)

template assign_int*(buf: seq[byte], bptr: int, value: int32): untyped =
  buf[bptr] = INT0(value)
  bptr += 1
  buf[bptr] = INT1(value)
  bptr += 1
  buf[bptr] = INT2(value)
  bptr += 1
  buf[bptr] = INT3(value)
  bptr += 1

template LONG*(buf: seq[byte], bptr: int): int64 = cast[int64](((cast[int64](buf[bptr]) shl 56) and 0xFF00000000000000) or ((cast[int64](buf[bptr + 1]) shl 48) and 0xFF000000000000) or ((cast[int64](buf[bptr + 2]) shl 40) and 0xFF0000000000) or ((cast[int64](buf[bptr + 3]) shl 32) and 0xFF00000000) or ((cast[int64](buf[bptr + 4]) shl 24) and 0xFF000000) or ((cast[int64](buf[bptr + 5]) shl 16) and 0xFF0000) or ((cast[int64](buf[bptr + 6]) shl 8) and 0xFF00) or (cast[int64](buf[bptr + 7]) and 0xFF))
template LONG0(value: int64): byte = cast[byte]((value shr 56) and 0xFF)
template LONG1(value: int64): byte = cast[byte]((value shr 48) and 0xFF)
template LONG2(value: int64): byte = cast[byte]((value shr 40) and 0xFF)
template LONG3(value: int64): byte = cast[byte]((value shr 32) and 0xFF)
template LONG4(value: int64): byte = cast[byte]((value shr 24) and 0xFF)
template LONG5(value: int64): byte = cast[byte]((value shr 16) and 0xFF)
template LONG6(value: int64): byte = cast[byte]((value shr 08) and 0xFF)
template LONG7(value: int64): byte = cast[byte](value and 0xFF)

template assign_long*(buf: seq[byte], bptr: int, value: int64): untyped =
  buf[bptr] = LONG0(value)
  bptr += 1
  buf[bptr] = LONG1(value)
  bptr += 1
  buf[bptr] = LONG2(value)
  bptr += 1
  buf[bptr] = LONG3(value)
  bptr += 1
  buf[bptr] = LONG4(value)
  bptr += 1
  buf[bptr] = LONG5(value)
  bptr += 1
  buf[bptr] = LONG6(value)
  bptr += 1
  buf[bptr] = LONG7(value)
  bptr += 1


proc padding*(tag: int16, nexttag: int16, buf: var seq[byte], start: int, count: var int16): int =
  if tag == nexttag:
    result = 0
  else:
    let t: int16 = (nexttag - tag) * 2 + 1
    buf[start] = SHORT0(t)
    buf[start + 1] = SHORT1(t)
    count += 1
    result = 2

import tightrope
import zeropack
type
  Register* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    pin*: int32
proc calculate_size*(register: ref Register): int =
  var
    size: int = 2
    tags: array[0..3, int]
    len: int = 0
  if register.sn != 0:
    tags[len] = 1
    len += 1
    if register.sn > 0 and register.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if register.version != 0:
    tags[len] = 2
    len += 1
    if register.version > 0 and register.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if register.timestamp != 0:
    tags[len] = 3
    len += 1
    if register.timestamp > 0 and register.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if register.pin != 0:
    tags[len] = 4
    len += 1
    if register.pin > 0 and register.pin < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if len > 0:
    if tags[0] != 0:
      size += 2
    for i in 1..(len - 1):
      if tags[i - 1] + 1 != tags[i]:
        size += 2
  return size
proc set_fields(register: ref Register, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 5:
    case nexttag:
      of 1:
        if register.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if register.sn > 0 and register.sn < 16383:
            let t: int16 = cast[int16]((register.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if register.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if register.version > 0 and register.version < 16383:
            let t: int16 = cast[int16]((register.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if register.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if register.timestamp > 0 and register.timestamp < 16383:
            let t: int16 = cast[int16]((register.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if register.pin != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if register.pin > 0 and register.pin < 16383:
            let t: int16 = cast[int16]((register.pin + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 4
            dlen += 1
      else:
        discard
    nexttag += 1
  buf[start] = SHORT0(count)
  buf[start + 1] = SHORT1(count)
  return bptr
proc set_data(register: ref Register, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
  var bptr: int = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, register.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, register.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, register.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, register.pin)
    else:
      discard
  return bptr
proc encode_into*(register: ref Register, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..3, int]
    dlen: int = 0
    ptr0 = set_fields(register, buf, start, dtags, dlen)
    ptr1 = set_data(register, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, register: var ref Register, dtags: var array[0..3, int], dlen: var int): int =
  var
    bptr: int = start + 2
    tag: int = 0
    count: int16 = SHORT(buf, start)
  if count == 0:
    return 0
  for i in 0..(count - 1):
    var value: int16 = SHORT(buf, bptr)
    bptr += 2
    if (value and 0x01) == 1:
      tag += (value - 1) shr 1
    elif value == 0:
      dtags[dlen] = tag
      dlen += 1
      tag += 1
    elif tag == 1:
      tag += 1
      register.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      register.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      register.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      register.pin = cast[int32]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, register: var ref Register, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      register.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      register.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      register.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      register.pin = INT(buf, bptr)
      bptr += sizeof(int32)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref Register =
  var
    register: ref Register = new(Register)
    dtags: array[0..3, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, register, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, register, dtags, dlen)
  return register

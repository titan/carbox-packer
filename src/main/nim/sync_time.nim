import tightrope
import zeropack
type
  SyncTime* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    zone*: int32
proc calculate_size*(sync_time: ref SyncTime): int =
  var
    size: int = 2
    tags: array[0..3, int]
    len: int = 0
  if sync_time.sn != 0:
    tags[len] = 1
    len += 1
    if sync_time.sn > 0 and sync_time.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if sync_time.version != 0:
    tags[len] = 2
    len += 1
    if sync_time.version > 0 and sync_time.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if sync_time.timestamp != 0:
    tags[len] = 3
    len += 1
    if sync_time.timestamp > 0 and sync_time.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if sync_time.zone != 0:
    tags[len] = 4
    len += 1
    if sync_time.zone > 0 and sync_time.zone < 16383:
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
proc set_fields(sync_time: ref SyncTime, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 5:
    case nexttag:
      of 1:
        if sync_time.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if sync_time.sn > 0 and sync_time.sn < 16383:
            let t: int16 = cast[int16]((sync_time.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if sync_time.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if sync_time.version > 0 and sync_time.version < 16383:
            let t: int16 = cast[int16]((sync_time.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if sync_time.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if sync_time.timestamp > 0 and sync_time.timestamp < 16383:
            let t: int16 = cast[int16]((sync_time.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if sync_time.zone != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if sync_time.zone > 0 and sync_time.zone < 16383:
            let t: int16 = cast[int16]((sync_time.zone + 1) * 2)
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
proc set_data(sync_time: ref SyncTime, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
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
      assign_int(buf, bptr, sync_time.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, sync_time.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, sync_time.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, sync_time.zone)
    else:
      discard
  return bptr
proc encode_into*(sync_time: ref SyncTime, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..3, int]
    dlen: int = 0
    ptr0 = set_fields(sync_time, buf, start, dtags, dlen)
    ptr1 = set_data(sync_time, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, sync_time: var ref SyncTime, dtags: var array[0..3, int], dlen: var int): int =
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
      sync_time.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      sync_time.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      sync_time.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      sync_time.zone = cast[int32]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, sync_time: var ref SyncTime, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      sync_time.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      sync_time.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      sync_time.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      sync_time.zone = INT(buf, bptr)
      bptr += sizeof(int32)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref SyncTime =
  var
    sync_time: ref SyncTime = new(SyncTime)
    dtags: array[0..3, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, sync_time, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, sync_time, dtags, dlen)
  return sync_time

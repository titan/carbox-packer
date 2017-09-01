import tightrope
import zeropack
type
  Data* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    system_board*: int32
    lock_board*: int32
    boxos_version*: int32
    supervisor_version*: int32
    cpu*: int32
    memory*: int32
    storage*: int32
    battery*: int32
    mobile*: int32
    wifi*: int32
proc calculate_size*(data: ref Data): int =
  var
    size: int = 2
    tags: array[0..12, int]
    len: int = 0
  if data.sn != 0:
    tags[len] = 1
    len += 1
    if data.sn > 0 and data.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.version != 0:
    tags[len] = 2
    len += 1
    if data.version > 0 and data.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.timestamp != 0:
    tags[len] = 3
    len += 1
    if data.timestamp > 0 and data.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if data.system_board != 0:
    tags[len] = 4
    len += 1
    if data.system_board > 0 and data.system_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.lock_board != 0:
    tags[len] = 5
    len += 1
    if data.lock_board > 0 and data.lock_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.boxos_version != 0:
    tags[len] = 6
    len += 1
    if data.boxos_version > 0 and data.boxos_version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.supervisor_version != 0:
    tags[len] = 7
    len += 1
    if data.supervisor_version > 0 and data.supervisor_version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.cpu != 0:
    tags[len] = 8
    len += 1
    if data.cpu > 0 and data.cpu < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.memory != 0:
    tags[len] = 9
    len += 1
    if data.memory > 0 and data.memory < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.storage != 0:
    tags[len] = 10
    len += 1
    if data.storage > 0 and data.storage < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.battery != 0:
    tags[len] = 11
    len += 1
    if data.battery > 0 and data.battery < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.mobile != 0:
    tags[len] = 12
    len += 1
    if data.mobile > 0 and data.mobile < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if data.wifi != 0:
    tags[len] = 13
    len += 1
    if data.wifi > 0 and data.wifi < 16383:
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
proc set_fields(data: ref Data, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 14:
    case nexttag:
      of 1:
        if data.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.sn > 0 and data.sn < 16383:
            let t: int16 = cast[int16]((data.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if data.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.version > 0 and data.version < 16383:
            let t: int16 = cast[int16]((data.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if data.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.timestamp > 0 and data.timestamp < 16383:
            let t: int16 = cast[int16]((data.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if data.system_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.system_board > 0 and data.system_board < 16383:
            let t: int16 = cast[int16]((data.system_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 4
            dlen += 1
      of 5:
        if data.lock_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.lock_board > 0 and data.lock_board < 16383:
            let t: int16 = cast[int16]((data.lock_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 5
            dlen += 1
      of 6:
        if data.boxos_version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.boxos_version > 0 and data.boxos_version < 16383:
            let t: int16 = cast[int16]((data.boxos_version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 6
            dlen += 1
      of 7:
        if data.supervisor_version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.supervisor_version > 0 and data.supervisor_version < 16383:
            let t: int16 = cast[int16]((data.supervisor_version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 7
            dlen += 1
      of 8:
        if data.cpu != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.cpu > 0 and data.cpu < 16383:
            let t: int16 = cast[int16]((data.cpu + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 8
            dlen += 1
      of 9:
        if data.memory != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.memory > 0 and data.memory < 16383:
            let t: int16 = cast[int16]((data.memory + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 9
            dlen += 1
      of 10:
        if data.storage != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.storage > 0 and data.storage < 16383:
            let t: int16 = cast[int16]((data.storage + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 10
            dlen += 1
      of 11:
        if data.battery != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.battery > 0 and data.battery < 16383:
            let t: int16 = cast[int16]((data.battery + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 11
            dlen += 1
      of 12:
        if data.mobile != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.mobile > 0 and data.mobile < 16383:
            let t: int16 = cast[int16]((data.mobile + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 12
            dlen += 1
      of 13:
        if data.wifi != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if data.wifi > 0 and data.wifi < 16383:
            let t: int16 = cast[int16]((data.wifi + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 13
            dlen += 1
      else:
        discard
    nexttag += 1
  buf[start] = SHORT0(count)
  buf[start + 1] = SHORT1(count)
  return bptr
proc set_data(data: ref Data, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
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
      assign_int(buf, bptr, data.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, data.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.system_board)
    of 5:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.lock_board)
    of 6:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.boxos_version)
    of 7:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.supervisor_version)
    of 8:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.cpu)
    of 9:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.memory)
    of 10:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.storage)
    of 11:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.battery)
    of 12:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.mobile)
    of 13:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, data.wifi)
    else:
      discard
  return bptr
proc encode_into*(data: ref Data, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..12, int]
    dlen: int = 0
    ptr0 = set_fields(data, buf, start, dtags, dlen)
    ptr1 = set_data(data, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, data: var ref Data, dtags: var array[0..12, int], dlen: var int): int =
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
      data.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      data.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      data.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      data.system_board = cast[int32]((value shr 1) - 1)
    elif tag == 5:
      tag += 1
      data.lock_board = cast[int32]((value shr 1) - 1)
    elif tag == 6:
      tag += 1
      data.boxos_version = cast[int32]((value shr 1) - 1)
    elif tag == 7:
      tag += 1
      data.supervisor_version = cast[int32]((value shr 1) - 1)
    elif tag == 8:
      tag += 1
      data.cpu = cast[int32]((value shr 1) - 1)
    elif tag == 9:
      tag += 1
      data.memory = cast[int32]((value shr 1) - 1)
    elif tag == 10:
      tag += 1
      data.storage = cast[int32]((value shr 1) - 1)
    elif tag == 11:
      tag += 1
      data.battery = cast[int32]((value shr 1) - 1)
    elif tag == 12:
      tag += 1
      data.mobile = cast[int32]((value shr 1) - 1)
    elif tag == 13:
      tag += 1
      data.wifi = cast[int32]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, data: var ref Data, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      data.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      data.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      data.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      data.system_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 5:
      bptr += 4
      data.lock_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 6:
      bptr += 4
      data.boxos_version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 7:
      bptr += 4
      data.supervisor_version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 8:
      bptr += 4
      data.cpu = INT(buf, bptr)
      bptr += sizeof(int32)
    of 9:
      bptr += 4
      data.memory = INT(buf, bptr)
      bptr += sizeof(int32)
    of 10:
      bptr += 4
      data.storage = INT(buf, bptr)
      bptr += sizeof(int32)
    of 11:
      bptr += 4
      data.battery = INT(buf, bptr)
      bptr += sizeof(int32)
    of 12:
      bptr += 4
      data.mobile = INT(buf, bptr)
      bptr += sizeof(int32)
    of 13:
      bptr += 4
      data.wifi = INT(buf, bptr)
      bptr += sizeof(int32)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref Data =
  var
    data: ref Data = new(Data)
    dtags: array[0..12, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, data, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, data, dtags, dlen)
  return data

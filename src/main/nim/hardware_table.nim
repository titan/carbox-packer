import tightrope
import zeropack
type
  HardwareTable* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    system_board*: int32
    lock_board*: int32
    lock_amount*: int32
    wireless*: int32
    antenna*: int32
    card_reader*: int32
    speaker*: int32
    router_board*: int32
    sim_no*: int32
proc calculate_size*(hardware_table: ref HardwareTable): int =
  var
    size: int = 2
    tags: array[0..11, int]
    len: int = 0
  if hardware_table.sn != 0:
    tags[len] = 1
    len += 1
    if hardware_table.sn > 0 and hardware_table.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.version != 0:
    tags[len] = 2
    len += 1
    if hardware_table.version > 0 and hardware_table.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.timestamp != 0:
    tags[len] = 3
    len += 1
    if hardware_table.timestamp > 0 and hardware_table.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if hardware_table.system_board != 0:
    tags[len] = 4
    len += 1
    if hardware_table.system_board > 0 and hardware_table.system_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.lock_board != 0:
    tags[len] = 5
    len += 1
    if hardware_table.lock_board > 0 and hardware_table.lock_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.lock_amount != 0:
    tags[len] = 6
    len += 1
    if hardware_table.lock_amount > 0 and hardware_table.lock_amount < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.wireless != 0:
    tags[len] = 7
    len += 1
    if hardware_table.wireless > 0 and hardware_table.wireless < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.antenna != 0:
    tags[len] = 8
    len += 1
    if hardware_table.antenna > 0 and hardware_table.antenna < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.card_reader != 0:
    tags[len] = 9
    len += 1
    if hardware_table.card_reader > 0 and hardware_table.card_reader < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.speaker != 0:
    tags[len] = 10
    len += 1
    if hardware_table.speaker > 0 and hardware_table.speaker < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.router_board != 0:
    tags[len] = 11
    len += 1
    if hardware_table.router_board > 0 and hardware_table.router_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if hardware_table.sim_no != 0:
    tags[len] = 12
    len += 1
    if hardware_table.sim_no > 0 and hardware_table.sim_no < 16383:
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
proc set_fields(hardware_table: ref HardwareTable, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 13:
    case nexttag:
      of 1:
        if hardware_table.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.sn > 0 and hardware_table.sn < 16383:
            let t: int16 = cast[int16]((hardware_table.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if hardware_table.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.version > 0 and hardware_table.version < 16383:
            let t: int16 = cast[int16]((hardware_table.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if hardware_table.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.timestamp > 0 and hardware_table.timestamp < 16383:
            let t: int16 = cast[int16]((hardware_table.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if hardware_table.system_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.system_board > 0 and hardware_table.system_board < 16383:
            let t: int16 = cast[int16]((hardware_table.system_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 4
            dlen += 1
      of 5:
        if hardware_table.lock_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.lock_board > 0 and hardware_table.lock_board < 16383:
            let t: int16 = cast[int16]((hardware_table.lock_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 5
            dlen += 1
      of 6:
        if hardware_table.lock_amount != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.lock_amount > 0 and hardware_table.lock_amount < 16383:
            let t: int16 = cast[int16]((hardware_table.lock_amount + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 6
            dlen += 1
      of 7:
        if hardware_table.wireless != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.wireless > 0 and hardware_table.wireless < 16383:
            let t: int16 = cast[int16]((hardware_table.wireless + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 7
            dlen += 1
      of 8:
        if hardware_table.antenna != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.antenna > 0 and hardware_table.antenna < 16383:
            let t: int16 = cast[int16]((hardware_table.antenna + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 8
            dlen += 1
      of 9:
        if hardware_table.card_reader != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.card_reader > 0 and hardware_table.card_reader < 16383:
            let t: int16 = cast[int16]((hardware_table.card_reader + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 9
            dlen += 1
      of 10:
        if hardware_table.speaker != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.speaker > 0 and hardware_table.speaker < 16383:
            let t: int16 = cast[int16]((hardware_table.speaker + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 10
            dlen += 1
      of 11:
        if hardware_table.router_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.router_board > 0 and hardware_table.router_board < 16383:
            let t: int16 = cast[int16]((hardware_table.router_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 11
            dlen += 1
      of 12:
        if hardware_table.sim_no != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if hardware_table.sim_no > 0 and hardware_table.sim_no < 16383:
            let t: int16 = cast[int16]((hardware_table.sim_no + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 12
            dlen += 1
      else:
        discard
    nexttag += 1
  buf[start] = SHORT0(count)
  buf[start + 1] = SHORT1(count)
  return bptr
proc set_data(hardware_table: ref HardwareTable, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
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
      assign_int(buf, bptr, hardware_table.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, hardware_table.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.system_board)
    of 5:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.lock_board)
    of 6:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.lock_amount)
    of 7:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.wireless)
    of 8:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.antenna)
    of 9:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.card_reader)
    of 10:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.speaker)
    of 11:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.router_board)
    of 12:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, hardware_table.sim_no)
    else:
      discard
  return bptr
proc encode_into*(hardware_table: ref HardwareTable, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..11, int]
    dlen: int = 0
    ptr0 = set_fields(hardware_table, buf, start, dtags, dlen)
    ptr1 = set_data(hardware_table, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, hardware_table: var ref HardwareTable, dtags: var array[0..11, int], dlen: var int): int =
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
      hardware_table.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      hardware_table.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      hardware_table.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      hardware_table.system_board = cast[int32]((value shr 1) - 1)
    elif tag == 5:
      tag += 1
      hardware_table.lock_board = cast[int32]((value shr 1) - 1)
    elif tag == 6:
      tag += 1
      hardware_table.lock_amount = cast[int32]((value shr 1) - 1)
    elif tag == 7:
      tag += 1
      hardware_table.wireless = cast[int32]((value shr 1) - 1)
    elif tag == 8:
      tag += 1
      hardware_table.antenna = cast[int32]((value shr 1) - 1)
    elif tag == 9:
      tag += 1
      hardware_table.card_reader = cast[int32]((value shr 1) - 1)
    elif tag == 10:
      tag += 1
      hardware_table.speaker = cast[int32]((value shr 1) - 1)
    elif tag == 11:
      tag += 1
      hardware_table.router_board = cast[int32]((value shr 1) - 1)
    elif tag == 12:
      tag += 1
      hardware_table.sim_no = cast[int32]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, hardware_table: var ref HardwareTable, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      hardware_table.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      hardware_table.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      hardware_table.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      hardware_table.system_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 5:
      bptr += 4
      hardware_table.lock_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 6:
      bptr += 4
      hardware_table.lock_amount = INT(buf, bptr)
      bptr += sizeof(int32)
    of 7:
      bptr += 4
      hardware_table.wireless = INT(buf, bptr)
      bptr += sizeof(int32)
    of 8:
      bptr += 4
      hardware_table.antenna = INT(buf, bptr)
      bptr += sizeof(int32)
    of 9:
      bptr += 4
      hardware_table.card_reader = INT(buf, bptr)
      bptr += sizeof(int32)
    of 10:
      bptr += 4
      hardware_table.speaker = INT(buf, bptr)
      bptr += sizeof(int32)
    of 11:
      bptr += 4
      hardware_table.router_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 12:
      bptr += 4
      hardware_table.sim_no = INT(buf, bptr)
      bptr += sizeof(int32)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref HardwareTable =
  var
    hardware_table: ref HardwareTable = new(HardwareTable)
    dtags: array[0..11, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, hardware_table, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, hardware_table, dtags, dlen)
  return hardware_table

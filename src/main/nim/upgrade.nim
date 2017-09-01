import tightrope
import zeropack
type
  Upgrade* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    system_board*: int32
    lock_board*: int32
    boxos_url*: string
    boxos_version*: int32
    boxos_checksum*: int64
    supervisor_url*: string
    supervisor_version*: int32
    supervisor_checksum*: int64
proc calculate_size*(upgrade: ref Upgrade): int =
  var
    size: int = 2
    tags: array[0..10, int]
    len: int = 0
  if upgrade.sn != 0:
    tags[len] = 1
    len += 1
    if upgrade.sn > 0 and upgrade.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.version != 0:
    tags[len] = 2
    len += 1
    if upgrade.version > 0 and upgrade.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.timestamp != 0:
    tags[len] = 3
    len += 1
    if upgrade.timestamp > 0 and upgrade.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if upgrade.system_board != 0:
    tags[len] = 4
    len += 1
    if upgrade.system_board > 0 and upgrade.system_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.lock_board != 0:
    tags[len] = 5
    len += 1
    if upgrade.lock_board > 0 and upgrade.lock_board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.boxos_url != nil:
    tags[len] = 6
    len += 1
    size += 2 + 4 + len(upgrade.boxos_url)
  if upgrade.boxos_version != 0:
    tags[len] = 7
    len += 1
    if upgrade.boxos_version > 0 and upgrade.boxos_version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.boxos_checksum != 0:
    tags[len] = 8
    len += 1
    if upgrade.boxos_checksum > 0 and upgrade.boxos_checksum < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if upgrade.supervisor_url != nil:
    tags[len] = 9
    len += 1
    size += 2 + 4 + len(upgrade.supervisor_url)
  if upgrade.supervisor_version != 0:
    tags[len] = 10
    len += 1
    if upgrade.supervisor_version > 0 and upgrade.supervisor_version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if upgrade.supervisor_checksum != 0:
    tags[len] = 11
    len += 1
    if upgrade.supervisor_checksum > 0 and upgrade.supervisor_checksum < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if len > 0:
    if tags[0] != 0:
      size += 2
    for i in 1..(len - 1):
      if tags[i - 1] + 1 != tags[i]:
        size += 2
  return size
proc set_fields(upgrade: ref Upgrade, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 12:
    case nexttag:
      of 1:
        if upgrade.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.sn > 0 and upgrade.sn < 16383:
            let t: int16 = cast[int16]((upgrade.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if upgrade.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.version > 0 and upgrade.version < 16383:
            let t: int16 = cast[int16]((upgrade.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if upgrade.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.timestamp > 0 and upgrade.timestamp < 16383:
            let t: int16 = cast[int16]((upgrade.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if upgrade.system_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.system_board > 0 and upgrade.system_board < 16383:
            let t: int16 = cast[int16]((upgrade.system_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 4
            dlen += 1
      of 5:
        if upgrade.lock_board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.lock_board > 0 and upgrade.lock_board < 16383:
            let t: int16 = cast[int16]((upgrade.lock_board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 5
            dlen += 1
      of 6:
        if upgrade.boxos_url != nil:
          dtags[dlen] = 6
          dlen += 1
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          assign_short_0(buf, bptr)
      of 7:
        if upgrade.boxos_version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.boxos_version > 0 and upgrade.boxos_version < 16383:
            let t: int16 = cast[int16]((upgrade.boxos_version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 7
            dlen += 1
      of 8:
        if upgrade.boxos_checksum != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.boxos_checksum > 0 and upgrade.boxos_checksum < 16383:
            let t: int16 = cast[int16]((upgrade.boxos_checksum + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 8
            dlen += 1
      of 9:
        if upgrade.supervisor_url != nil:
          dtags[dlen] = 9
          dlen += 1
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          assign_short_0(buf, bptr)
      of 10:
        if upgrade.supervisor_version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.supervisor_version > 0 and upgrade.supervisor_version < 16383:
            let t: int16 = cast[int16]((upgrade.supervisor_version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 10
            dlen += 1
      of 11:
        if upgrade.supervisor_checksum != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if upgrade.supervisor_checksum > 0 and upgrade.supervisor_checksum < 16383:
            let t: int16 = cast[int16]((upgrade.supervisor_checksum + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 11
            dlen += 1
      else:
        discard
    nexttag += 1
  buf[start] = SHORT0(count)
  buf[start + 1] = SHORT1(count)
  return bptr
proc set_data(upgrade: ref Upgrade, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
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
      assign_int(buf, bptr, upgrade.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, upgrade.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, upgrade.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, upgrade.system_board)
    of 5:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, upgrade.lock_board)
    of 6:
      var
        slen: int = len(upgrade.boxos_url)
        slen32: int32 = cast[int32](slen)
        boxos_url: cstring = upgrade.boxos_url
      assign_int(buf, bptr, slen32)
      copyMem(addr(buf[bptr]), boxos_url, slen32)
      bptr += slen
    of 7:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, upgrade.boxos_version)
    of 8:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, upgrade.boxos_checksum)
    of 9:
      var
        slen: int = len(upgrade.supervisor_url)
        slen32: int32 = cast[int32](slen)
        supervisor_url: cstring = upgrade.supervisor_url
      assign_int(buf, bptr, slen32)
      copyMem(addr(buf[bptr]), supervisor_url, slen32)
      bptr += slen
    of 10:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, upgrade.supervisor_version)
    of 11:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, upgrade.supervisor_checksum)
    else:
      discard
  return bptr
proc encode_into*(upgrade: ref Upgrade, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..10, int]
    dlen: int = 0
    ptr0 = set_fields(upgrade, buf, start, dtags, dlen)
    ptr1 = set_data(upgrade, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, upgrade: var ref Upgrade, dtags: var array[0..10, int], dlen: var int): int =
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
      upgrade.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      upgrade.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      upgrade.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      upgrade.system_board = cast[int32]((value shr 1) - 1)
    elif tag == 5:
      tag += 1
      upgrade.lock_board = cast[int32]((value shr 1) - 1)
    elif tag == 7:
      tag += 1
      upgrade.boxos_version = cast[int32]((value shr 1) - 1)
    elif tag == 8:
      tag += 1
      upgrade.boxos_checksum = cast[int64]((value shr 1) - 1)
    elif tag == 10:
      tag += 1
      upgrade.supervisor_version = cast[int32]((value shr 1) - 1)
    elif tag == 11:
      tag += 1
      upgrade.supervisor_checksum = cast[int64]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, upgrade: var ref Upgrade, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      upgrade.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      upgrade.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      upgrade.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      upgrade.system_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 5:
      bptr += 4
      upgrade.lock_board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 6:
      var strlen = INT(buf, bptr)
      bptr += 4
      upgrade.boxos_url = newString(strlen)
      for j in 0..(strlen - 1):
        upgrade.boxos_url[i] = cast[char](buf[bptr + j])
      bptr += strlen
    of 7:
      bptr += 4
      upgrade.boxos_version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 8:
      bptr += 4
      upgrade.boxos_checksum = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 9:
      var strlen = INT(buf, bptr)
      bptr += 4
      upgrade.supervisor_url = newString(strlen)
      for j in 0..(strlen - 1):
        upgrade.supervisor_url[i] = cast[char](buf[bptr + j])
      bptr += strlen
    of 10:
      bptr += 4
      upgrade.supervisor_version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 11:
      bptr += 4
      upgrade.supervisor_checksum = LONG(buf, bptr)
      bptr += sizeof(int64)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref Upgrade =
  var
    upgrade: ref Upgrade = new(Upgrade)
    dtags: array[0..10, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, upgrade, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, upgrade, dtags, dlen)
  return upgrade

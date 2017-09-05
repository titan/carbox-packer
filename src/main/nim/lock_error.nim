import tightrope
import zeropack
type
  LockError* = object of RootObj
    sn*: int32
    version*: int32
    timestamp*: int64
    board*: int32
    lock*: int32
    error_type*: int32
proc calculate_size*(lock_error: ref LockError): int =
  var
    size: int = 2
    tags: array[0..5, int]
    len: int = 0
  if lock_error.sn != 0:
    tags[len] = 1
    len += 1
    if lock_error.sn > 0 and lock_error.sn < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if lock_error.version != 0:
    tags[len] = 2
    len += 1
    if lock_error.version > 0 and lock_error.version < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if lock_error.timestamp != 0:
    tags[len] = 3
    len += 1
    if lock_error.timestamp > 0 and lock_error.timestamp < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int64)
  if lock_error.board != 0:
    tags[len] = 4
    len += 1
    if lock_error.board > 0 and lock_error.board < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if lock_error.lock != 0:
    tags[len] = 5
    len += 1
    if lock_error.lock > 0 and lock_error.lock < 16383:
      size += 2
    else:
      size += 2 + 4 + sizeof(int32)
  if lock_error.error_type != 0:
    tags[len] = 6
    len += 1
    if lock_error.error_type > 0 and lock_error.error_type < 16383:
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
proc set_fields(lock_error: ref LockError, buf: var seq[byte], start: int, dtags: var openArray[int], dlen: var int): int =
  var
    bptr: int = start + 2
    count: int16 = 0
    tag: int16 = 0
    nexttag: int16 = 0
  while nexttag < 7:
    case nexttag:
      of 1:
        if lock_error.sn != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.sn > 0 and lock_error.sn < 16383:
            let t: int16 = cast[int16]((lock_error.sn + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 1
            dlen += 1
      of 2:
        if lock_error.version != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.version > 0 and lock_error.version < 16383:
            let t: int16 = cast[int16]((lock_error.version + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 2
            dlen += 1
      of 3:
        if lock_error.timestamp != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.timestamp > 0 and lock_error.timestamp < 16383:
            let t: int16 = cast[int16]((lock_error.timestamp + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 3
            dlen += 1
      of 4:
        if lock_error.board != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.board > 0 and lock_error.board < 16383:
            let t: int16 = cast[int16]((lock_error.board + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 4
            dlen += 1
      of 5:
        if lock_error.lock != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.lock > 0 and lock_error.lock < 16383:
            let t: int16 = cast[int16]((lock_error.lock + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 5
            dlen += 1
      of 6:
        if lock_error.error_type != 0:
          count += 1
          bptr += tightrope.padding(tag, nexttag, buf, bptr, count)
          tag = nexttag + 1
          if lock_error.error_type > 0 and lock_error.error_type < 16383:
            let t: int16 = cast[int16]((lock_error.error_type + 1) * 2)
            assign_short(buf, bptr, t)
          else:
            assign_short_0(buf, bptr)
            dtags[dlen] = 6
            dlen += 1
      else:
        discard
    nexttag += 1
  buf[start] = SHORT0(count)
  buf[start + 1] = SHORT1(count)
  return bptr
proc set_data(lock_error: ref LockError, buf: var seq[byte], start: int, dtags: openArray[int], dlen: int): int =
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
      assign_int(buf, bptr, lock_error.sn)
    of 2:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, lock_error.version)
    of 3:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 8
      bptr += 1
      assign_long(buf, bptr, lock_error.timestamp)
    of 4:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, lock_error.board)
    of 5:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, lock_error.lock)
    of 6:
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 0
      bptr += 1
      buf[bptr] = 4
      bptr += 1
      assign_int(buf, bptr, lock_error.error_type)
    else:
      discard
  return bptr
proc encode_into*(lock_error: ref LockError, buf:var seq[byte], start: int): int = 
  var
    dtags: array[0..5, int]
    dlen: int = 0
    ptr0 = set_fields(lock_error, buf, start, dtags, dlen)
    ptr1 = set_data(lock_error, buf, ptr0, dtags, dlen)
  return ptr0 + ptr1
proc parse_fields(buf: seq[byte], start: int, lock_error: var ref LockError, dtags: var array[0..5, int], dlen: var int): int =
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
      lock_error.sn = cast[int32]((value shr 1) - 1)
    elif tag == 2:
      tag += 1
      lock_error.version = cast[int32]((value shr 1) - 1)
    elif tag == 3:
      tag += 1
      lock_error.timestamp = cast[int64]((value shr 1) - 1)
    elif tag == 4:
      tag += 1
      lock_error.board = cast[int32]((value shr 1) - 1)
    elif tag == 5:
      tag += 1
      lock_error.lock = cast[int32]((value shr 1) - 1)
    elif tag == 6:
      tag += 1
      lock_error.error_type = cast[int32]((value shr 1) - 1)
    else:
      tag += 1
  return bptr
proc parse_data(buf: seq[byte], start: int, lock_error: var ref LockError, dtags: openArray[int], dlen: int): int =
  var bptr = start
  for i in 0..(dlen - 1):
    case dtags[i]:
    of 1:
      bptr += 4
      lock_error.sn = INT(buf, bptr)
      bptr += sizeof(int32)
    of 2:
      bptr += 4
      lock_error.version = INT(buf, bptr)
      bptr += sizeof(int32)
    of 3:
      bptr += 4
      lock_error.timestamp = LONG(buf, bptr)
      bptr += sizeof(int64)
    of 4:
      bptr += 4
      lock_error.board = INT(buf, bptr)
      bptr += sizeof(int32)
    of 5:
      bptr += 4
      lock_error.lock = INT(buf, bptr)
      bptr += sizeof(int32)
    of 6:
      bptr += 4
      lock_error.error_type = INT(buf, bptr)
      bptr += sizeof(int32)
    else:
      var size = INT(buf, bptr)
      bptr += 4
      bptr += size
  return bptr
proc decode_from*(buf: seq[byte], start: int): ref LockError =
  var
    lock_error: ref LockError = new(LockError)
    dtags: array[0..5, int]
    dlen: int = 0
  var ptr0: int = parse_fields(buf, start, lock_error, dtags, dlen)
  if ptr0 > 0:
    discard parse_data(buf,  ptr0, lock_error, dtags, dlen)
  return lock_error

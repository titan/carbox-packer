import data, sync_time, upgrade, register, hardware_table, lock_error, zeropack
import sequtils, strutils
type
  CommandType* {.pure.} = enum
    UNKNOWN = 0, DATA = 1, SYNC_TIME = 2, UPGRADE = 3, REGISTER = 4, HARDWARE_TABLE = 5, LOCK_ERROR = 6
  MAC* = array[0..5, byte]
  PackResultObject* = object of RootObj
    mac*: MAC
    version*: int
    case cmd_type*: CommandType
    of CommandType.UNKNOWN: discard
    of CommandType.DATA: data*: ref Data
    of CommandType.SYNC_TIME: sync_time*: ref SyncTime
    of CommandType.UPGRADE: upgrade*: ref Upgrade
    of CommandType.REGISTER: register*: ref Register
    of CommandType.HARDWARE_TABLE: hardware_table*: ref HardwareTable
    of CommandType.LOCK_ERROR: lock_error*: ref LockError
  PackResult* = ref PackResultObject

const version: int = 0

proc `$`*(mac: MAC): string =
  return mac.mapIt(toHex(cast[BiggestInt](it), 2)).join("-")

proc hexdump(buf: seq[byte], size: int): string =
  var output = ""
  for i in 0..(size - 1):
    output.add("$1 " % (toHex(buf[i])))
    if i mod 8 == 7:
      output.add("\n")
  return output

proc adler32(buf: seq[byte], offset: int, len: int): int32 =
  var
    A: int = 1
    B: int = 0
  for i in offset..(offset + len - 1):
    let D = cast[int](buf[i])
    A = (A + D) mod 65521
    B = (A + B) mod 65521
  return cast[int32]((B shl 16) + A)

proc encode(payload: seq[byte], cmd_type: CommandType, mac: MAC): seq[byte] =
  let
    payload_size = len(payload)
    rest_size = 4 + 1 + 6 + payload_size
  var
    buf: seq[byte]
    size: int = 0
    offset: int = 0
  if rest_size > 128:
    size = rest_size + 2
    buf = newSeq[byte](size)
    buf[0] = cast[byte](rest_size and 0x7F + 0x80)
    buf[1] = cast[byte]((rest_size shr 7) and 0xFF)
    offset = 2
  else:
    size = rest_size + 1
    buf = newSeq[byte](size)
    buf[0] = cast[byte](rest_size and 0xFF)
    offset = 1
  buf[offset + 4] = cast[byte](((ord(cmd_type) and 0x0F) shl 4) or (version and  0x0F))
  var mac_start = offset + 4 + 1
  for i in 0..5:
    buf[mac_start + i] = mac[i]
  var payload_start = offset + 4 + 1 + 6
  for i in 0..(payload_size - 1):
    buf[payload_start + i] = payload[i]
  var checksum = adler32(buf, offset + 4, rest_size - 4)
  for i in 0..3:
    buf[offset + i] = cast[byte]((checksum shr (i * 8)) and 0xFF)
  return buf

proc encode_with_mac*(data: ref Data, mac: MAC): seq[byte] =
  let size: int = data.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard data.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.DATA, mac)

proc encode_with_mac*(sync_time: ref SyncTime, mac: MAC): seq[byte] =
  let size: int = sync_time.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard sync_time.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.SYNC_TIME, mac)

proc encode_with_mac*(upgrade: ref UPGRADE, mac: MAC): seq[byte] =
  let size: int = upgrade.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard upgrade.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.UPGRADE, mac)

proc encode_with_mac*(register: ref Register, mac: MAC): seq[byte] =
  let size: int = register.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard register.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.REGISTER, mac)

proc encode_with_mac*(hardware_table: ref HardwareTable, mac: MAC): seq[byte] =
  let size: int = hardware_table.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard hardware_table.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.HARDWARE_TABLE, mac)

proc encode_with_mac*(lock_error: ref LockError, mac: MAC): seq[byte] =
  let size: int = lock_error.calculate_size()
  var buf: seq[byte] = newSeq[byte](size)
  discard lock_error.encode_into(buf, 0)
  let zipped_buf = zeropack(buf)
  return encode(zipped_buf, CommandType.LOCK_ERROR, mac)

proc decode*(buf: seq[byte], offset: int, length: int): PackResult =
  var
    packed_size = 0
    start = 0
  if (buf[offset] and 0x80) == 0x80:
    packed_size = cast[int](buf[offset + 1] shl 7) + cast[int](buf[offset] and 0x7F)
    start = 2 + offset
  else:
    packed_size = cast[int](buf[offset])
    start = 1 + offset

  if length != packed_size + start:
     return nil
  let checksum = adler32(buf, start + 4, packed_size - 4)
  for i in 0..3:
    if buf[start + i] != cast[byte]((checksum shr (i * 8)) and 0xFF):
      return nil
  var mac: MAC
  for i in 0..5:
    mac[i] = buf[start + 4 + 1 + i]
  let
    ver = buf[start + 4] and 0x0F
    unzipped: seq[byte] = unzeropack(buf, start + 4 + 1 + 6, length - start - 4 - 1 - 6)
  case (buf[start + 4] shr 4) and 0xFF:
    of 1:
      result = PackResult(cmd_type: CommandType.DATA, mac: mac, version: ver, data: data.decode_from(unzipped, 0))
    of 2:
      result = PackResult(cmd_type: CommandType.SYNC_TIME, mac: mac, version: ver, sync_time: sync_time.decode_from(unzipped, 0))
    of 3:
      result = PackResult(cmd_type: CommandType.UPGRADE, mac: mac, version: ver, upgrade: upgrade.decode_from(unzipped, 0))
    of 4:
      result = PackResult(cmd_type: CommandType.REGISTER, mac: mac, version: ver, register: register.decode_from(unzipped, 0))
    of 5:
      result = PackResult(cmd_type: CommandType.HARDWARE_TABLE, mac: mac, version: ver, hardware_table: hardware_table.decode_from(unzipped, 0))
    of 6:
      result = PackResult(cmd_type: CommandType.LOCK_ERROR, mac: mac, version: ver, lock_error: lock_error.decode_from(unzipped, 0))
    else:
      return nil

when(isMainModule):
  var mac = [0x03'u8, 0x04'u8, 0x05'u8, 0x06'u8, 0x07'u8, 0x08'u8]
  var table: ref HardwareTable = new(HardwareTable)
  table.antenna = cast[int32](0)
  table.card_reader = cast[int32](0)
  table.lock_amount = cast[int32](0)
  table.lock_board = cast[int32](0)
  table.router_board = cast[int32](0)
  table.sim_no = cast[int32](0)
  table.system_board = cast[int32](0)
  table.wireless = cast[int32](0)
  var pkt = table.encode_with_mac(mac)

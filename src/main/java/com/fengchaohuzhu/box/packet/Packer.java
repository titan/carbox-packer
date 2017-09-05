package com.fengchaohuzhu.box.packet;

import java.util.Arrays;
import java.util.zip.Adler32;


/**
 * 命令封包和解包程序
 *
 * @version 1.0
 */

public class Packer {

  private static byte [] encode (byte [] mac, CommandType type, byte [] payload) {
    /*
     * 1 or 2 bytes for length
     * 4 bytes for checksum
     * 4 bits for command
     * 4 bits for version
     * 6 bytes for MAC
     * payload
     */
    int version = 0;
    if (mac != null && mac.length == 6 && payload != null) {
      int restLength = 4 + 1 + 6 + payload.length;
      byte [] buf = null;
      int ptr = 1;
      if (restLength > 128) {
        buf = new byte[2 + restLength];
        ptr = 2;
        buf[0] = (byte) ((restLength & 0x7F) + 0x80);
        buf[1] = (byte) ((restLength >> 7) & 0xFF);
      } else {
        buf = new byte[1 + restLength];
        ptr = 1;
        buf[0] = (byte) (restLength & 0xFF);
      }

      buf[ptr + 4] = (byte) (((type.code & 0x0F) << 4) | (version & 0x0F));
      // copy mac to buf
      for (int i = 0; i < 6; i ++) {
        buf[ptr + 4 + 1 + i] = mac[i];
      }
      // copy payload to buf
      for (int i = 0, len = payload.length; i < len; i ++) {
        buf[ptr + 4 + 1 + 6 + i] = payload[i];
      }
      // calculate checkshum
      Adler32 adler32 = new Adler32();
      adler32.update (buf, ptr + 4, restLength - 4);
      long checksum = adler32.getValue();
      // copy checksum to buf
      for (int i = 0; i < 4; i ++) {
        buf[ptr + i] = (byte) (((byte) (checksum >> i * 8)) & (byte)0xFF);
      }

      return buf;
    } else {
      return null;
    }
  }

  /**
   * 编码 Data 命令
   *
   * @param mac 发出 Data 命令的设备 mac 地址
   * @param data Data 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, Data data) {
    byte [] payload = DataSerializer.encode0Pack (data);
    return encode (mac, CommandType.DATA, payload);
  }

  /**
   * 编码 SyncTime 命令
   *
   * @param mac 接收 SyncTime 命令的设备 mac 地址
   * @param data SyncTime 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, SyncTime data) {
    byte [] payload = SyncTimeSerializer.encode0Pack (data);
    return encode (mac, CommandType.SYNC_TIME, payload);
  }

  /**
   * 编码 Upgrade 命令
   *
   * @param mac 接收 Upgrade 命令的设备 mac 地址
   * @param data Upgrade 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, Upgrade data) {
    try {
      byte [] payload = UpgradeSerializer.encode0Pack (data);
      return encode (mac, CommandType.UPGRADE, payload);
    } catch (Exception e) {
      return null;
    }
  }

  /**
   * 编码 Register 命令
   *
   * @param mac 接收 Register 命令的设备 mac 地址
   * @param data Register 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, Register data) {
    try {
      byte [] payload = RegisterSerializer.encode0Pack (data);
      return encode (mac, CommandType.REGISTER, payload);
    } catch (Exception e) {
      return null;
    }
  }

  /**
   * 编码 HardwareTable 命令
   *
   * @param mac 接收 HardwareTable 命令的设备 mac 地址
   * @param data HardwareTable 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, HardwareTable data) {
    try {
      byte [] payload = HardwareTableSerializer.encode0Pack (data);
      return encode (mac, CommandType.HARDWARE_TABLE, payload);
    } catch (Exception e) {
      return null;
    }
  }

  /**
   * 编码 LockError 命令
   *
   * @param mac 接收 LockError 命令的设备 mac 地址
   * @param data LockError 命令对象
   * @return 编码完成的 byte 数组或 null
   */
  public static byte[] encode (byte[] mac, LockError data) {
    try {
      byte [] payload = LockErrorSerializer.encode0Pack (data);
      return encode (mac, CommandType.LOCK_ERROR, payload);
    } catch (Exception e) {
      return null;
    }
  }

  /**
   * 从 byte 数组解码得到对应的命令。用 Result 封装解码后的命令对象。
   *
   * @param buf 要解码的 byte 数组
   * @return Result 对象或 null
   */
  public static Result decode (byte[] buf) {
    return decode (buf, 0, buf.length);
  }

  /**
   * 从 byte 数组解码得到对应的命令。用 Result 封装解码后的命令对象。
   *
   * @param buf 要解码的 byte 数组
   * @param offset 数据在 buf 中的起始地址
   * @param length 数据在 buf 中的长度
   * @return Result 对象或 null
   */
  public static Result decode (byte[] buf, int offset, int length) {
    int len = 0;
    int ptr = 0;

    if ((buf[offset] & 0x80) == 0x80) {
      len = (((int)buf[offset + 1]) << 7) + (((int)buf[offset]) & 0x7F);
      ptr = 2 + offset;
    } else {
      len = buf[offset];
      ptr = 1 + offset;
    }
    if (length != len + ptr) {
      return null;
    }

    // calculate checkshum
    Adler32 adler32 = new Adler32();
    adler32.update (buf, ptr + 4, len - 4);
    long checksum = adler32.getValue();

    for (int i = 0; i < 4; i ++) {
      if (buf[ptr + i] != (byte) ((checksum >> (i * 8)) & 0xFF)) {
        return null;
      }
    }
    int type = (buf[ptr + 4] >> 4) & 0xFF;
    Result result = new Result();
    result.version = buf[ptr + 4] & 0x0F;
    result.mac = Arrays.copyOfRange (buf, ptr + 4 + 1, ptr + 4 + 1 + 6);
    byte [] payload = Arrays.copyOfRange (buf, ptr + 4 + 1 + 6, len + ptr);
    switch (type) {
    case 1: {
      result.type = CommandType.DATA;
      result.data = DataSerializer.decode0Pack (payload);
      break;
    }
    case 2: {
      result.type = CommandType.SYNC_TIME;
      result.syncTime = SyncTimeSerializer.decode0Pack (payload);
      break;
    }
    case 3: {
      result.type = CommandType.UPGRADE;
      try {
        result.upgrade = UpgradeSerializer.decode0Pack (payload);
      } catch (Exception e) {
        return null;
      }
      break;
    }
    case 4: {
      result.type = CommandType.REGISTER;
      result.register = RegisterSerializer.decode0Pack (payload);
      break;
    }
    case 5: {
      result.type = CommandType.HARDWARE_TABLE;
      result.hardwareTable = HardwareTableSerializer.decode0Pack (payload);
      break;
    }
    case 6: {
      result.type = CommandType.LOCK_ERROR;
      result.lockError = LockErrorSerializer.decode0Pack (payload);
      break;
    }
    default:
      return null;
    }
    return result;
  }

  /*
  public static void outputHex (byte [] buf) {
  for (int i = 0; i < buf.length; i ++) {
    System.out.print (String.format ("%02x ", buf[i]));
    if (i % 8 == 7) {
      System.out.println();
    }
  }
  System.out.println();
  }

  public static void main (String[] args) {
  byte[] mac = { (byte) 0x03, (byte) 0x04, (byte) 0x05, (byte) 0x06, (byte) 0x07, (byte) 0x08 };

  Data data = new Data();
  data.sn = 0;
  data.version = 0;
  byte[] byteArray = Packer.encode (mac, data);
  Result pu = Packer.decode (byteArray);
  System.out.println ("data.sn: " + pu.data.sn + " data.version: " + pu.data.version);


  SyncTime syncTime = new SyncTime();
  syncTime.sn = 1;
  syncTime.version = 0;
  byte[] byteArray1 = Packer.encode (mac, syncTime);
  Result pu1 = Packer.decode (byteArray1);
  System.out.println ("syncTime.sn: " + pu1.syncTime.sn + " syncTime.version: " + pu1.syncTime.version);

  Upgrade upgrade = new Upgrade();
  upgrade.sn = 2;
  upgrade.version = 0;
  upgrade.boxosUrl = "hdskjflajfdsklfj;fkjsdfjsldfjksfjsafl;kjdlajfksdljfdlfdjskfjakfjdsklfjkdfjsklfjaslkj;fdkjfalfjlsajfljfkslajfksljfsklajfsldafjsfjlajfskldfjsa;lfdkkdfjklafdfjslkfjklsfjksalfjasklfjakljfdk";
  byte[] byteArray2 = Packer.encode (mac, upgrade);
  Result pu2 = Packer.decode (byteArray2);
  System.out.println ("upgrade.sn: " + pu2.upgrade.sn + " upgrade.version: " + pu2.upgrade.version + " url: " + pu2.upgrade.boxosUrl);
  }
  */
}

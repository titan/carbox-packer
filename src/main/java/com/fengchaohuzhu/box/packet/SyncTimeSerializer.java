package com.fengchaohuzhu.box.packet;
import java.nio.ByteBuffer;
public class SyncTimeSerializer {
  public static byte [] encode (SyncTime syncTime) {
    short count = 0;
    int len = 2;
    short [] tags = new short [4];
    short tlen = 0;
    short [] dtags = new short [4];
    short dlen = 0;
    if (syncTime.sn != 0) {
      tags[tlen] = 1;
      tlen ++;
      if (0 < syncTime.sn && syncTime.sn < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 1;
        dlen ++;
      }
      count ++;
    }
    if (syncTime.version != 0) {
      tags[tlen] = 2;
      tlen ++;
      if (0 < syncTime.version && syncTime.version < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 2;
        dlen ++;
      }
      count ++;
    }
    if (syncTime.timestamp != 0) {
      tags[tlen] = 3;
      tlen ++;
      if (0 < syncTime.timestamp && syncTime.timestamp < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 3;
        dlen ++;
      }
      count ++;
    }
    if (syncTime.zone != 0) {
      tags[tlen] = 4;
      tlen ++;
      if (0 < syncTime.zone && syncTime.zone < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 4;
        dlen ++;
      }
      count ++;
    }
    if (count != 0) {
      if (tags[0] != 0) {
        len += 2;
        count ++;
      }
    }
    if (tlen > 1) {
      for (short i = 1; i < tlen; i ++) {
        if (tags[i - 1] + 1 != tags[i]) {
          len += 2;
          count ++;
        }
      }
    }
    ByteBuffer buf = ByteBuffer.allocate (len);
    buf.putShort (count);
    for (short i = 0; i < tlen; i ++) {
      if (i == 0) {
        if (tags[0] != 0) {
          buf.putShort ((short) ((tags[0]) * 2 + 1));
        }
      } else {
        if (tags[i - 1] + 1 != tags[i]) {
          buf.putShort ((short) ((tags[i] - tags[i - 1] - 1) * 2 + 1));
        }
      }
      switch (tags[i]) {
      case 1:
        if (0 < syncTime.sn && syncTime.sn < 16383) {
          buf.putShort ((short) ((syncTime.sn + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 2:
        if (0 < syncTime.version && syncTime.version < 16383) {
          buf.putShort ((short) ((syncTime.version + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 3:
        if (0 < syncTime.timestamp && syncTime.timestamp < 16383) {
          buf.putShort ((short) ((syncTime.timestamp + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 4:
        if (0 < syncTime.zone && syncTime.zone < 16383) {
          buf.putShort ((short) ((syncTime.zone + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      }
    }
    for (short i = 0; i < dlen; i ++) {
      switch (dtags[i]) {
      case 1:
        buf.putInt (4);
        buf.putInt (syncTime.sn);
        break;
      case 2:
        buf.putInt (4);
        buf.putInt (syncTime.version);
        break;
      case 3:
        buf.putInt (8);
        buf.putLong (syncTime.timestamp);
        break;
      case 4:
        buf.putInt (4);
        buf.putInt (syncTime.zone);
        break;
      }
    }
    return buf.array();
  }
  public static byte [] encode0Pack (SyncTime syncTime) {
    return ZeroPack.pack (encode (syncTime));
  }
  public static SyncTime decode (byte [] bytes) {
    ByteBuffer buf = ByteBuffer.wrap (bytes);
    short count = buf.getShort();
    SyncTime syncTime = new SyncTime();
    if (count > 0) {
      short [] dtags = new short[4];
      int dlen = 0;
      short tag = 0;
      for (short i = 0; i < count; i ++) {
        short v = buf.getShort();
        if ((v & (short)0x01) == 1) {
          tag += (v - 1) / 2;
        } else if (v == 0) {
          dtags[dlen] = tag;
          dlen ++;
          tag ++;
        } else {
          switch (tag) {
          case 1:
            syncTime.sn = v / 2 - 1;
            break;
          case 2:
            syncTime.version = v / 2 - 1;
            break;
          case 3:
            syncTime.timestamp = v / 2 - 1;
            break;
          case 4:
            syncTime.zone = v / 2 - 1;
            break;
          default:
            break;
          }
          tag ++;
        }
      }
      for (short i = 0; i < dlen; i ++) {
        switch (dtags[i]) {
        case 1:
          buf.getInt();
          syncTime.sn = buf.getInt();
          break;
        case 2:
          buf.getInt();
          syncTime.version = buf.getInt();
          break;
        case 3:
          buf.getInt();
          syncTime.timestamp = buf.getLong();
          break;
        case 4:
          buf.getInt();
          syncTime.zone = buf.getInt();
          break;
        default:
          break;
        }
      }
    }
    return syncTime;
  }

  public static SyncTime decode0Pack (byte [] bytes) {
    return decode (ZeroPack.unpack (bytes));
  }
}
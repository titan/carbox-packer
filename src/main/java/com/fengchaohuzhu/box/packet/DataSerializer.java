package com.fengchaohuzhu.box.packet;
import java.nio.ByteBuffer;
public class DataSerializer {
  public static byte [] encode (Data data) {
    short count = 0;
    int len = 2;
    short [] tags = new short [13];
    short tlen = 0;
    short [] dtags = new short [13];
    short dlen = 0;
    if (data.sn != 0) {
      tags[tlen] = 1;
      tlen ++;
      if (0 < data.sn && data.sn < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 1;
        dlen ++;
      }
      count ++;
    }
    if (data.version != 0) {
      tags[tlen] = 2;
      tlen ++;
      if (0 < data.version && data.version < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 2;
        dlen ++;
      }
      count ++;
    }
    if (data.timestamp != 0) {
      tags[tlen] = 3;
      tlen ++;
      if (0 < data.timestamp && data.timestamp < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 3;
        dlen ++;
      }
      count ++;
    }
    if (data.systemBoard != 0) {
      tags[tlen] = 4;
      tlen ++;
      if (0 < data.systemBoard && data.systemBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 4;
        dlen ++;
      }
      count ++;
    }
    if (data.lockBoard != 0) {
      tags[tlen] = 5;
      tlen ++;
      if (0 < data.lockBoard && data.lockBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 5;
        dlen ++;
      }
      count ++;
    }
    if (data.boxosVersion != 0) {
      tags[tlen] = 6;
      tlen ++;
      if (0 < data.boxosVersion && data.boxosVersion < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 6;
        dlen ++;
      }
      count ++;
    }
    if (data.supervisorVersion != 0) {
      tags[tlen] = 7;
      tlen ++;
      if (0 < data.supervisorVersion && data.supervisorVersion < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 7;
        dlen ++;
      }
      count ++;
    }
    if (data.cpu != 0) {
      tags[tlen] = 8;
      tlen ++;
      if (0 < data.cpu && data.cpu < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 8;
        dlen ++;
      }
      count ++;
    }
    if (data.memory != 0) {
      tags[tlen] = 9;
      tlen ++;
      if (0 < data.memory && data.memory < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 9;
        dlen ++;
      }
      count ++;
    }
    if (data.storage != 0) {
      tags[tlen] = 10;
      tlen ++;
      if (0 < data.storage && data.storage < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 10;
        dlen ++;
      }
      count ++;
    }
    if (data.battery != 0) {
      tags[tlen] = 11;
      tlen ++;
      if (0 < data.battery && data.battery < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 11;
        dlen ++;
      }
      count ++;
    }
    if (data.mobile != 0) {
      tags[tlen] = 12;
      tlen ++;
      if (0 < data.mobile && data.mobile < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 12;
        dlen ++;
      }
      count ++;
    }
    if (data.wifi != 0) {
      tags[tlen] = 13;
      tlen ++;
      if (0 < data.wifi && data.wifi < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 13;
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
        if (0 < data.sn && data.sn < 16383) {
          buf.putShort ((short) ((data.sn + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 2:
        if (0 < data.version && data.version < 16383) {
          buf.putShort ((short) ((data.version + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 3:
        if (0 < data.timestamp && data.timestamp < 16383) {
          buf.putShort ((short) ((data.timestamp + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 4:
        if (0 < data.systemBoard && data.systemBoard < 16383) {
          buf.putShort ((short) ((data.systemBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 5:
        if (0 < data.lockBoard && data.lockBoard < 16383) {
          buf.putShort ((short) ((data.lockBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 6:
        if (0 < data.boxosVersion && data.boxosVersion < 16383) {
          buf.putShort ((short) ((data.boxosVersion + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 7:
        if (0 < data.supervisorVersion && data.supervisorVersion < 16383) {
          buf.putShort ((short) ((data.supervisorVersion + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 8:
        if (0 < data.cpu && data.cpu < 16383) {
          buf.putShort ((short) ((data.cpu + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 9:
        if (0 < data.memory && data.memory < 16383) {
          buf.putShort ((short) ((data.memory + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 10:
        if (0 < data.storage && data.storage < 16383) {
          buf.putShort ((short) ((data.storage + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 11:
        if (0 < data.battery && data.battery < 16383) {
          buf.putShort ((short) ((data.battery + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 12:
        if (0 < data.mobile && data.mobile < 16383) {
          buf.putShort ((short) ((data.mobile + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 13:
        if (0 < data.wifi && data.wifi < 16383) {
          buf.putShort ((short) ((data.wifi + 1) * 2));
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
        buf.putInt (data.sn);
        break;
      case 2:
        buf.putInt (4);
        buf.putInt (data.version);
        break;
      case 3:
        buf.putInt (8);
        buf.putLong (data.timestamp);
        break;
      case 4:
        buf.putInt (4);
        buf.putInt (data.systemBoard);
        break;
      case 5:
        buf.putInt (4);
        buf.putInt (data.lockBoard);
        break;
      case 6:
        buf.putInt (4);
        buf.putInt (data.boxosVersion);
        break;
      case 7:
        buf.putInt (4);
        buf.putInt (data.supervisorVersion);
        break;
      case 8:
        buf.putInt (4);
        buf.putInt (data.cpu);
        break;
      case 9:
        buf.putInt (4);
        buf.putInt (data.memory);
        break;
      case 10:
        buf.putInt (4);
        buf.putInt (data.storage);
        break;
      case 11:
        buf.putInt (4);
        buf.putInt (data.battery);
        break;
      case 12:
        buf.putInt (4);
        buf.putInt (data.mobile);
        break;
      case 13:
        buf.putInt (4);
        buf.putInt (data.wifi);
        break;
      }
    }
    return buf.array();
  }
  public static byte [] encode0Pack (Data data) {
    return ZeroPack.pack (encode (data));
  }
  public static Data decode (byte [] bytes) {
    ByteBuffer buf = ByteBuffer.wrap (bytes);
    short count = buf.getShort();
    Data data = new Data();
    if (count > 0) {
      short [] dtags = new short[13];
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
            data.sn = v / 2 - 1;
            break;
          case 2:
            data.version = v / 2 - 1;
            break;
          case 3:
            data.timestamp = v / 2 - 1;
            break;
          case 4:
            data.systemBoard = v / 2 - 1;
            break;
          case 5:
            data.lockBoard = v / 2 - 1;
            break;
          case 6:
            data.boxosVersion = v / 2 - 1;
            break;
          case 7:
            data.supervisorVersion = v / 2 - 1;
            break;
          case 8:
            data.cpu = v / 2 - 1;
            break;
          case 9:
            data.memory = v / 2 - 1;
            break;
          case 10:
            data.storage = v / 2 - 1;
            break;
          case 11:
            data.battery = v / 2 - 1;
            break;
          case 12:
            data.mobile = v / 2 - 1;
            break;
          case 13:
            data.wifi = v / 2 - 1;
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
          data.sn = buf.getInt();
          break;
        case 2:
          buf.getInt();
          data.version = buf.getInt();
          break;
        case 3:
          buf.getInt();
          data.timestamp = buf.getLong();
          break;
        case 4:
          buf.getInt();
          data.systemBoard = buf.getInt();
          break;
        case 5:
          buf.getInt();
          data.lockBoard = buf.getInt();
          break;
        case 6:
          buf.getInt();
          data.boxosVersion = buf.getInt();
          break;
        case 7:
          buf.getInt();
          data.supervisorVersion = buf.getInt();
          break;
        case 8:
          buf.getInt();
          data.cpu = buf.getInt();
          break;
        case 9:
          buf.getInt();
          data.memory = buf.getInt();
          break;
        case 10:
          buf.getInt();
          data.storage = buf.getInt();
          break;
        case 11:
          buf.getInt();
          data.battery = buf.getInt();
          break;
        case 12:
          buf.getInt();
          data.mobile = buf.getInt();
          break;
        case 13:
          buf.getInt();
          data.wifi = buf.getInt();
          break;
        default:
          break;
        }
      }
    }
    return data;
  }

  public static Data decode0Pack (byte [] bytes) {
    return decode (ZeroPack.unpack (bytes));
  }
}
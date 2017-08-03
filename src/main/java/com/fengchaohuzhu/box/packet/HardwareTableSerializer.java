package com.fengchaohuzhu.box.packet;
import java.nio.ByteBuffer;
public class HardwareTableSerializer {
  public static byte [] encode (HardwareTable hardwareTable) {
    short count = 0;
    int len = 2;
    short [] tags = new short [12];
    short tlen = 0;
    short [] dtags = new short [12];
    short dlen = 0;
    if (hardwareTable.sn != 0) {
      tags[tlen] = 1;
      tlen ++;
      if (0 < hardwareTable.sn && hardwareTable.sn < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 1;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.version != 0) {
      tags[tlen] = 2;
      tlen ++;
      if (0 < hardwareTable.version && hardwareTable.version < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 2;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.timestamp != 0) {
      tags[tlen] = 3;
      tlen ++;
      if (0 < hardwareTable.timestamp && hardwareTable.timestamp < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 3;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.androidBoard != 0) {
      tags[tlen] = 4;
      tlen ++;
      if (0 < hardwareTable.androidBoard && hardwareTable.androidBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 4;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.lockBoard != 0) {
      tags[tlen] = 5;
      tlen ++;
      if (0 < hardwareTable.lockBoard && hardwareTable.lockBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 5;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.lockAmount != 0) {
      tags[tlen] = 6;
      tlen ++;
      if (0 < hardwareTable.lockAmount && hardwareTable.lockAmount < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 6;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.wireless != 0) {
      tags[tlen] = 7;
      tlen ++;
      if (0 < hardwareTable.wireless && hardwareTable.wireless < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 7;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.antenna != 0) {
      tags[tlen] = 8;
      tlen ++;
      if (0 < hardwareTable.antenna && hardwareTable.antenna < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 8;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.cardReader != 0) {
      tags[tlen] = 9;
      tlen ++;
      if (0 < hardwareTable.cardReader && hardwareTable.cardReader < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 9;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.speaker != 0) {
      tags[tlen] = 10;
      tlen ++;
      if (0 < hardwareTable.speaker && hardwareTable.speaker < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 10;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.routerBoard != 0) {
      tags[tlen] = 11;
      tlen ++;
      if (0 < hardwareTable.routerBoard && hardwareTable.routerBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 11;
        dlen ++;
      }
      count ++;
    }
    if (hardwareTable.simNo != 0) {
      tags[tlen] = 12;
      tlen ++;
      if (0 < hardwareTable.simNo && hardwareTable.simNo < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 12;
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
        if (0 < hardwareTable.sn && hardwareTable.sn < 16383) {
          buf.putShort ((short) ((hardwareTable.sn + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 2:
        if (0 < hardwareTable.version && hardwareTable.version < 16383) {
          buf.putShort ((short) ((hardwareTable.version + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 3:
        if (0 < hardwareTable.timestamp && hardwareTable.timestamp < 16383) {
          buf.putShort ((short) ((hardwareTable.timestamp + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 4:
        if (0 < hardwareTable.androidBoard && hardwareTable.androidBoard < 16383) {
          buf.putShort ((short) ((hardwareTable.androidBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 5:
        if (0 < hardwareTable.lockBoard && hardwareTable.lockBoard < 16383) {
          buf.putShort ((short) ((hardwareTable.lockBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 6:
        if (0 < hardwareTable.lockAmount && hardwareTable.lockAmount < 16383) {
          buf.putShort ((short) ((hardwareTable.lockAmount + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 7:
        if (0 < hardwareTable.wireless && hardwareTable.wireless < 16383) {
          buf.putShort ((short) ((hardwareTable.wireless + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 8:
        if (0 < hardwareTable.antenna && hardwareTable.antenna < 16383) {
          buf.putShort ((short) ((hardwareTable.antenna + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 9:
        if (0 < hardwareTable.cardReader && hardwareTable.cardReader < 16383) {
          buf.putShort ((short) ((hardwareTable.cardReader + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 10:
        if (0 < hardwareTable.speaker && hardwareTable.speaker < 16383) {
          buf.putShort ((short) ((hardwareTable.speaker + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 11:
        if (0 < hardwareTable.routerBoard && hardwareTable.routerBoard < 16383) {
          buf.putShort ((short) ((hardwareTable.routerBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 12:
        if (0 < hardwareTable.simNo && hardwareTable.simNo < 16383) {
          buf.putShort ((short) ((hardwareTable.simNo + 1) * 2));
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
        buf.putInt (hardwareTable.sn);
        break;
      case 2:
        buf.putInt (4);
        buf.putInt (hardwareTable.version);
        break;
      case 3:
        buf.putInt (8);
        buf.putLong (hardwareTable.timestamp);
        break;
      case 4:
        buf.putInt (4);
        buf.putInt (hardwareTable.androidBoard);
        break;
      case 5:
        buf.putInt (4);
        buf.putInt (hardwareTable.lockBoard);
        break;
      case 6:
        buf.putInt (4);
        buf.putInt (hardwareTable.lockAmount);
        break;
      case 7:
        buf.putInt (4);
        buf.putInt (hardwareTable.wireless);
        break;
      case 8:
        buf.putInt (4);
        buf.putInt (hardwareTable.antenna);
        break;
      case 9:
        buf.putInt (4);
        buf.putInt (hardwareTable.cardReader);
        break;
      case 10:
        buf.putInt (4);
        buf.putInt (hardwareTable.speaker);
        break;
      case 11:
        buf.putInt (4);
        buf.putInt (hardwareTable.routerBoard);
        break;
      case 12:
        buf.putInt (4);
        buf.putInt (hardwareTable.simNo);
        break;
      }
    }
    return buf.array();
  }
  public static byte [] encode0Pack (HardwareTable hardwareTable) {
    return ZeroPack.pack (encode (hardwareTable));
  }
  public static HardwareTable decode (byte [] bytes) {
    ByteBuffer buf = ByteBuffer.wrap (bytes);
    short count = buf.getShort();
    HardwareTable hardwareTable = new HardwareTable();
    if (count > 0) {
      short [] dtags = new short[12];
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
            hardwareTable.sn = v / 2 - 1;
            break;
          case 2:
            hardwareTable.version = v / 2 - 1;
            break;
          case 3:
            hardwareTable.timestamp = v / 2 - 1;
            break;
          case 4:
            hardwareTable.androidBoard = v / 2 - 1;
            break;
          case 5:
            hardwareTable.lockBoard = v / 2 - 1;
            break;
          case 6:
            hardwareTable.lockAmount = v / 2 - 1;
            break;
          case 7:
            hardwareTable.wireless = v / 2 - 1;
            break;
          case 8:
            hardwareTable.antenna = v / 2 - 1;
            break;
          case 9:
            hardwareTable.cardReader = v / 2 - 1;
            break;
          case 10:
            hardwareTable.speaker = v / 2 - 1;
            break;
          case 11:
            hardwareTable.routerBoard = v / 2 - 1;
            break;
          case 12:
            hardwareTable.simNo = v / 2 - 1;
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
          hardwareTable.sn = buf.getInt();
          break;
        case 2:
          buf.getInt();
          hardwareTable.version = buf.getInt();
          break;
        case 3:
          buf.getInt();
          hardwareTable.timestamp = buf.getLong();
          break;
        case 4:
          buf.getInt();
          hardwareTable.androidBoard = buf.getInt();
          break;
        case 5:
          buf.getInt();
          hardwareTable.lockBoard = buf.getInt();
          break;
        case 6:
          buf.getInt();
          hardwareTable.lockAmount = buf.getInt();
          break;
        case 7:
          buf.getInt();
          hardwareTable.wireless = buf.getInt();
          break;
        case 8:
          buf.getInt();
          hardwareTable.antenna = buf.getInt();
          break;
        case 9:
          buf.getInt();
          hardwareTable.cardReader = buf.getInt();
          break;
        case 10:
          buf.getInt();
          hardwareTable.speaker = buf.getInt();
          break;
        case 11:
          buf.getInt();
          hardwareTable.routerBoard = buf.getInt();
          break;
        case 12:
          buf.getInt();
          hardwareTable.simNo = buf.getInt();
          break;
        default:
          break;
        }
      }
    }
    return hardwareTable;
  }

  public static HardwareTable decode0Pack (byte [] bytes) {
    return decode (ZeroPack.unpack (bytes));
  }
}
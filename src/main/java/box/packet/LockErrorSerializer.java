package box.packet;
import java.nio.ByteBuffer;
public class LockErrorSerializer {
  public static byte [] encode (LockError lockError) {
    short count = 0;
    int len = 2;
    short [] tags = new short [6];
    short tlen = 0;
    short [] dtags = new short [6];
    short dlen = 0;
    if (lockError.sn != 0) {
      tags[tlen] = 1;
      tlen ++;
      if (0 < lockError.sn && lockError.sn < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 1;
        dlen ++;
      }
      count ++;
    }
    if (lockError.version != 0) {
      tags[tlen] = 2;
      tlen ++;
      if (0 < lockError.version && lockError.version < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 2;
        dlen ++;
      }
      count ++;
    }
    if (lockError.timestamp != 0) {
      tags[tlen] = 3;
      tlen ++;
      if (0 < lockError.timestamp && lockError.timestamp < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 3;
        dlen ++;
      }
      count ++;
    }
    if (lockError.board != 0) {
      tags[tlen] = 4;
      tlen ++;
      if (0 < lockError.board && lockError.board < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 4;
        dlen ++;
      }
      count ++;
    }
    if (lockError.lock != 0) {
      tags[tlen] = 5;
      tlen ++;
      if (0 < lockError.lock && lockError.lock < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 5;
        dlen ++;
      }
      count ++;
    }
    if (lockError.errorType != 0) {
      tags[tlen] = 6;
      tlen ++;
      if (0 < lockError.errorType && lockError.errorType < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 6;
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
        if (0 < lockError.sn && lockError.sn < 16383) {
          buf.putShort ((short) ((lockError.sn + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 2:
        if (0 < lockError.version && lockError.version < 16383) {
          buf.putShort ((short) ((lockError.version + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 3:
        if (0 < lockError.timestamp && lockError.timestamp < 16383) {
          buf.putShort ((short) ((lockError.timestamp + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 4:
        if (0 < lockError.board && lockError.board < 16383) {
          buf.putShort ((short) ((lockError.board + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 5:
        if (0 < lockError.lock && lockError.lock < 16383) {
          buf.putShort ((short) ((lockError.lock + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 6:
        if (0 < lockError.errorType && lockError.errorType < 16383) {
          buf.putShort ((short) ((lockError.errorType + 1) * 2));
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
        buf.putInt (lockError.sn);
        break;
      case 2:
        buf.putInt (4);
        buf.putInt (lockError.version);
        break;
      case 3:
        buf.putInt (8);
        buf.putLong (lockError.timestamp);
        break;
      case 4:
        buf.putInt (4);
        buf.putInt (lockError.board);
        break;
      case 5:
        buf.putInt (4);
        buf.putInt (lockError.lock);
        break;
      case 6:
        buf.putInt (4);
        buf.putInt (lockError.errorType);
        break;
      }
    }
    return buf.array();
  }
  public static byte [] encode0Pack (LockError lockError) {
    return ZeroPack.pack (encode (lockError));
  }
  public static LockError decode (byte [] bytes) {
    ByteBuffer buf = ByteBuffer.wrap (bytes);
    short count = buf.getShort();
    LockError lockError = new LockError();
    if (count > 0) {
      short [] dtags = new short[6];
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
            lockError.sn = v / 2 - 1;
            break;
          case 2:
            lockError.version = v / 2 - 1;
            break;
          case 3:
            lockError.timestamp = v / 2 - 1;
            break;
          case 4:
            lockError.board = v / 2 - 1;
            break;
          case 5:
            lockError.lock = v / 2 - 1;
            break;
          case 6:
            lockError.errorType = v / 2 - 1;
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
          lockError.sn = buf.getInt();
          break;
        case 2:
          buf.getInt();
          lockError.version = buf.getInt();
          break;
        case 3:
          buf.getInt();
          lockError.timestamp = buf.getLong();
          break;
        case 4:
          buf.getInt();
          lockError.board = buf.getInt();
          break;
        case 5:
          buf.getInt();
          lockError.lock = buf.getInt();
          break;
        case 6:
          buf.getInt();
          lockError.errorType = buf.getInt();
          break;
        default:
          break;
        }
      }
    }
    return lockError;
  }

  public static LockError decode0Pack (byte [] bytes) {
    return decode (ZeroPack.unpack (bytes));
  }
}
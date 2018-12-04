package box.packet;
import java.nio.ByteBuffer;
public class UpgradeSerializer {
  public static byte [] encode (Upgrade upgrade) throws java.io.UnsupportedEncodingException {
    short count = 0;
    int len = 2;
    short [] tags = new short [11];
    short tlen = 0;
    short [] dtags = new short [11];
    short dlen = 0;
    byte [][] strbytes = new byte[2][];
    if (upgrade.sn != 0) {
      tags[tlen] = 1;
      tlen ++;
      if (0 < upgrade.sn && upgrade.sn < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 1;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.version != 0) {
      tags[tlen] = 2;
      tlen ++;
      if (0 < upgrade.version && upgrade.version < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 2;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.timestamp != 0) {
      tags[tlen] = 3;
      tlen ++;
      if (0 < upgrade.timestamp && upgrade.timestamp < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 3;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.systemBoard != 0) {
      tags[tlen] = 4;
      tlen ++;
      if (0 < upgrade.systemBoard && upgrade.systemBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 4;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.lockBoard != 0) {
      tags[tlen] = 5;
      tlen ++;
      if (0 < upgrade.lockBoard && upgrade.lockBoard < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 5;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.boxosUrl != null) {
      tags[tlen] = 6;
      tlen ++;
      dtags[dlen] = 6;
      dlen ++;
      strbytes[0] = upgrade.boxosUrl.getBytes ("utf-8");
      len += 2 + 4 + strbytes[0].length;
      count ++;
    }
    if (upgrade.boxosVersion != 0) {
      tags[tlen] = 7;
      tlen ++;
      if (0 < upgrade.boxosVersion && upgrade.boxosVersion < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 7;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.boxosChecksum != 0) {
      tags[tlen] = 8;
      tlen ++;
      if (0 < upgrade.boxosChecksum && upgrade.boxosChecksum < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 8;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.supervisorUrl != null) {
      tags[tlen] = 9;
      tlen ++;
      dtags[dlen] = 9;
      dlen ++;
      strbytes[1] = upgrade.supervisorUrl.getBytes ("utf-8");
      len += 2 + 4 + strbytes[1].length;
      count ++;
    }
    if (upgrade.supervisorVersion != 0) {
      tags[tlen] = 10;
      tlen ++;
      if (0 < upgrade.supervisorVersion && upgrade.supervisorVersion < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 4;
        dtags[dlen] = 10;
        dlen ++;
      }
      count ++;
    }
    if (upgrade.supervisorChecksum != 0) {
      tags[tlen] = 11;
      tlen ++;
      if (0 < upgrade.supervisorChecksum && upgrade.supervisorChecksum < 16383) {
        len += 2;
      } else {
        len += 2 + 4 + 8;
        dtags[dlen] = 11;
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
        if (0 < upgrade.sn && upgrade.sn < 16383) {
          buf.putShort ((short) ((upgrade.sn + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 2:
        if (0 < upgrade.version && upgrade.version < 16383) {
          buf.putShort ((short) ((upgrade.version + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 3:
        if (0 < upgrade.timestamp && upgrade.timestamp < 16383) {
          buf.putShort ((short) ((upgrade.timestamp + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 4:
        if (0 < upgrade.systemBoard && upgrade.systemBoard < 16383) {
          buf.putShort ((short) ((upgrade.systemBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 5:
        if (0 < upgrade.lockBoard && upgrade.lockBoard < 16383) {
          buf.putShort ((short) ((upgrade.lockBoard + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 6:
        buf.putShort ((short) 0);
        break;
      case 7:
        if (0 < upgrade.boxosVersion && upgrade.boxosVersion < 16383) {
          buf.putShort ((short) ((upgrade.boxosVersion + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 8:
        if (0 < upgrade.boxosChecksum && upgrade.boxosChecksum < 16383) {
          buf.putShort ((short) ((upgrade.boxosChecksum + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 9:
        buf.putShort ((short) 0);
        break;
      case 10:
        if (0 < upgrade.supervisorVersion && upgrade.supervisorVersion < 16383) {
          buf.putShort ((short) ((upgrade.supervisorVersion + 1) * 2));
        } else {
          buf.putShort ((short) 0);
        }
        break;
      case 11:
        if (0 < upgrade.supervisorChecksum && upgrade.supervisorChecksum < 16383) {
          buf.putShort ((short) ((upgrade.supervisorChecksum + 1) * 2));
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
        buf.putInt (upgrade.sn);
        break;
      case 2:
        buf.putInt (4);
        buf.putInt (upgrade.version);
        break;
      case 3:
        buf.putInt (8);
        buf.putLong (upgrade.timestamp);
        break;
      case 4:
        buf.putInt (4);
        buf.putInt (upgrade.systemBoard);
        break;
      case 5:
        buf.putInt (4);
        buf.putInt (upgrade.lockBoard);
        break;
      case 6:
        buf.putInt (strbytes[0].length);
        buf.put (strbytes[0]);
        break;
      case 7:
        buf.putInt (4);
        buf.putInt (upgrade.boxosVersion);
        break;
      case 8:
        buf.putInt (8);
        buf.putLong (upgrade.boxosChecksum);
        break;
      case 9:
        buf.putInt (strbytes[1].length);
        buf.put (strbytes[1]);
        break;
      case 10:
        buf.putInt (4);
        buf.putInt (upgrade.supervisorVersion);
        break;
      case 11:
        buf.putInt (8);
        buf.putLong (upgrade.supervisorChecksum);
        break;
      }
    }
    return buf.array();
  }
  public static byte [] encode0Pack (Upgrade upgrade) throws java.io.UnsupportedEncodingException {
    return ZeroPack.pack (encode (upgrade));
  }
  public static Upgrade decode (byte [] bytes)  throws java.io.UnsupportedEncodingException {
    ByteBuffer buf = ByteBuffer.wrap (bytes);
    short count = buf.getShort();
    Upgrade upgrade = new Upgrade();
    if (count > 0) {
      short [] dtags = new short[11];
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
            upgrade.sn = v / 2 - 1;
            break;
          case 2:
            upgrade.version = v / 2 - 1;
            break;
          case 3:
            upgrade.timestamp = v / 2 - 1;
            break;
          case 4:
            upgrade.systemBoard = v / 2 - 1;
            break;
          case 5:
            upgrade.lockBoard = v / 2 - 1;
            break;
          case 7:
            upgrade.boxosVersion = v / 2 - 1;
            break;
          case 8:
            upgrade.boxosChecksum = v / 2 - 1;
            break;
          case 10:
            upgrade.supervisorVersion = v / 2 - 1;
            break;
          case 11:
            upgrade.supervisorChecksum = v / 2 - 1;
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
          upgrade.sn = buf.getInt();
          break;
        case 2:
          buf.getInt();
          upgrade.version = buf.getInt();
          break;
        case 3:
          buf.getInt();
          upgrade.timestamp = buf.getLong();
          break;
        case 4:
          buf.getInt();
          upgrade.systemBoard = buf.getInt();
          break;
        case 5:
          buf.getInt();
          upgrade.lockBoard = buf.getInt();
          break;
        case 6: {
          int len = buf.getInt();
          byte tmp [] = new byte[len];
          buf.get (tmp);
          upgrade.boxosUrl = new String (tmp, "utf-8");
        }
        break;
        case 7:
          buf.getInt();
          upgrade.boxosVersion = buf.getInt();
          break;
        case 8:
          buf.getInt();
          upgrade.boxosChecksum = buf.getLong();
          break;
        case 9: {
          int len = buf.getInt();
          byte tmp [] = new byte[len];
          buf.get (tmp);
          upgrade.supervisorUrl = new String (tmp, "utf-8");
        }
        break;
        case 10:
          buf.getInt();
          upgrade.supervisorVersion = buf.getInt();
          break;
        case 11:
          buf.getInt();
          upgrade.supervisorChecksum = buf.getLong();
          break;
        default:
          break;
        }
      }
    }
    return upgrade;
  }

  public static Upgrade decode0Pack (byte [] bytes) throws java.io.UnsupportedEncodingException {
    return decode (ZeroPack.unpack (bytes));
  }
}
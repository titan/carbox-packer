package box.packet;
import java.nio.ByteBuffer;

public class ZeroPack {
  public static byte [] pack (byte [] inp) {
    ByteBuffer buf = ByteBuffer.allocate (inp.length + inp.length % 8 + 1);
    byte [] bytes = new byte[8];
    int ffpos = 0;
    int ffcnt = 0;
    int oopos = 0;
    int oocnt = 0;
    buf.put ((byte)2); // default factor
    for (int i = 0, len = inp.length % 8 == 0 ? inp.length / 8 : inp.length / 8 + 1; i < len; i ++) {
      byte bitmap = 0;
      int k = 0;
      for (int j = 0, jlen = i == inp.length / 8 ? inp.length % 8 : 8; j < jlen; j ++) {
        byte b = inp[i * 8 + j];
        if (b != (byte)0) {
          bitmap = (byte) (bitmap | (1 << (8 - j - 1)));
          bytes[k] = b;
          k ++;
        }
      }
      if (bitmap == (byte)0xFF) {
        if (oocnt > 0) {
          int tmp = buf.position();
          buf.position (oopos);
          buf.put ((byte)oocnt);
          buf.position (tmp);
          oocnt = 0;
        }
        if (ffcnt == 0) {
          buf.put ((byte) 0xFF);
          ffpos = buf.position();
          buf.position (ffpos + 1);
          ffcnt ++;
        } else if (ffcnt == 0xFF) {
          int tmp = buf.position();
          buf.position (ffpos);
          buf.put ((byte) 0xFF);
          buf.position (tmp);
          ffcnt = 0;
        } else {
          ffcnt ++;
        }
        for (int l = 0; l < k; l ++) {
          buf.put (bytes[l]);
        }
      } else if (bitmap == (byte)0x00) {
        if (ffcnt > 0) {
          int tmp = buf.position();
          buf.position (ffpos);
          buf.put ((byte)ffcnt);
          buf.position (tmp);
          ffcnt = 0;
        }
        if (oocnt == 0) {
          buf.put ((byte) 0x00);
          oopos = buf.position();
          buf.position (oopos + 1);
          oocnt ++;
        } else if (oocnt == 0xFF) {
          int tmp = buf.position();
          buf.position (oopos);
          buf.put ((byte) 0xFF);
          buf.position (tmp);
          oocnt = 0;
        } else {
          oocnt ++;
        }
      } else {
        buf.put (bitmap);
        if (ffcnt > 0) {
          int tmp = buf.position();
          buf.position (ffpos);
          buf.put ((byte)ffcnt);
          buf.position (tmp);
          ffcnt = 0;
        } else if (oocnt > 0) {
          int tmp = buf.position();
          buf.position (oopos);
          buf.put ((byte)oocnt);
          buf.position (tmp);
          oocnt = 0;
        }
        for (int l = 0; l < k; l ++) {
          buf.put (bytes[l]);
        }
      }
    }
    if (ffcnt > 0) {
      int tmp = buf.position();
      buf.position (ffpos);
      buf.put ((byte)ffcnt);
      buf.position (tmp);
      ffcnt = 0;
    } else if (oocnt > 0) {
      int tmp = buf.position();
      buf.position (oopos);
      buf.put ((byte)oocnt);
      buf.position (tmp);
      oocnt = 0;
    }
    byte [] out = new byte[buf.capacity() - buf.remaining()];
    buf.position (0);
    int buflen = inp.length + inp.length % 8 + 1;
    buf.put ((byte) (buflen / out.length + (buflen % out.length != 0 ? 1 : 0)));
    buf.rewind();
    buf.get (out);
    return out;
  }
  public static byte [] zeros = {0, 0, 0, 0, 0, 0, 0, 0};
  public static byte [] unpack (byte [] inp) {
    ByteBuffer buf = ByteBuffer.allocate (inp.length * inp[0] < 8 ? 8 : inp.length * inp[0]);
    int ptr = 1;
    int cnt = 0;
    while (ptr < inp.length) {
      byte b = inp[ptr];
      switch (b) {
      case 0:
        cnt = inp[ptr + 1];
        for (int i = 0; i < cnt; i ++) {
          buf.put (zeros);
        }
        ptr += 2;
        break;
      case (byte)0xFF:
        cnt = inp[ptr + 1];
        buf.put (inp, ptr + 2, cnt * 8);
        ptr += 2 + cnt * 8;
        break;
      default:
        cnt = 0;
        for (int i = 0; i < 8; i ++) {
          if ((b & (1 << (8 - i - 1))) > 0) {
            cnt ++;
            byte data = inp[ptr + cnt];
            buf.put (data);
          } else {
            buf.put ((byte)0);
          }
        }
        ptr += cnt + 1;
        break;
      }
    }
    byte [] out = new byte[buf.capacity() - buf.remaining()];
    buf.rewind();
    buf.get (out);
    return out;
  }
}

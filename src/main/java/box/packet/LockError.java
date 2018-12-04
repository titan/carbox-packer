package box.packet;
public class LockError {
  public int sn;
  public int version;
  public long timestamp;
  public int board;
  public int lock;
  public int errorType;
}
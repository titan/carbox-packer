package box.packet;

public enum CommandType {
  DATA (1), SYNC_TIME (2), UPGRADE (3), REGISTER (4), HARDWARE_TABLE (5), LOCK_ERROR(6);

  public int code;

  private CommandType (int code) {
    this.code = code;
  }
}

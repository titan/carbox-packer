package com.fengchaohuzhu.box.packet;

/**
 * 解码结果
 *
 * @version 1.0
 */
public class Result {
  /**
   * 命令类型
   */
  public CommandType type;
  /**
   * 盒子设备的 MAC 地址
   */
  public byte [] mac;
  /**
   * 基础通讯协议的版本号
   */
  public int version;
  /**
   * 数据上报命令对象
   */
  public Data data = null;
  /**
   * 同步时间命令对象
   */
  public SyncTime syncTime = null;
  /**
   * 升级 App 命令对象
   */
  public Upgrade upgrade = null;
  /**
   * 注册命令对象
   */
  public Register register = null;
  /**
   * 硬件配置表
   */
  public HardwareTable hardwareTable = null;
  /**
   * 锁错误命令
   */
  public LockError lockError = null;
}

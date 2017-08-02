(package com.fengchaohuzhu.box.packet)

(struct data
  (int 1 sn)
  (int 2 version)
  (long 3 timestamp)
  (int 4 android-board)
  (int 5 lock-board)
  (int 6 boxos-version)
  (int 7 supervisor-version)
  (int 8 cpu)
  (int 9 memory)
  (int 10 storage)
  (int 11 battery)
  (int 12 mobile)
  (int 13 wifi))

(struct sync-time
  (int 1 sn)
  (int 2 version)
  (long 3 timestamp)
  (int 4 zone))

(struct upgrade
  (int 1 sn)
  (int 2 version)
  (long 3 timestamp)
  (int 4 android-board)
  (int 5 lock-board)
  (string 6 boxos-url)
  (int 7 boxos-version)
  (string 8 supervisor-url)
  (int 9 supervisor-version)
  (byte 10 notest))

(struct hardware-table
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 android-board) ;; Android 板类型编号
  (int 5 lock-board) ;; 锁控板类型编号
  (int 6 lock-amount) ;; 锁的数量
  (int 7 wireless) ;; 无线通讯方式编号
  (int 8 antenna) ;; 天线类型编号
  (int 9 card-reader) ;; 读卡器类型
  (int 10 speaker) ;; 扬声器类型
  )

(struct register
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 pin) ;; 设备 PIN 码
  ) ;; 设备第一次注册用

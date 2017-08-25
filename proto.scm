(package com.fengchaohuzhu.box.packet)

(struct data
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 system-board) ;; 主板类型编号
  (int 5 lock-board) ;; 锁控板类型编号
  (int 6 boxos-version) ;; 寄存柜操作系统版本号
  (int 7 supervisor-version) ;; 监管程序版本号
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
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 system-board) ;; 主板类型编号
  (int 5 lock-board) ;; 锁控板类型编号
  (string 6 boxos-url) ;; 寄存柜操作系统下载链接
  (int 7 boxos-version) ;; 寄存柜操作系统版本号
  (long 8 boxos-checksum) ;; 寄存柜操作系统摘要
  (string 9 supervisor-url) ;; 监管程序下载地址
  (int 10 supervisor-version) ;; 监管程序版本号
  (long 11 supervisor-checksum) ;; 监管程序摘要
  )

(struct hardware-table
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 system-board) ;; 主板型号
  (int 5 lock-board) ;; 锁控板型号
  (int 6 lock-amount) ;; 锁的数量
  (int 7 wireless) ;; 无线通讯方式编号
  (int 8 antenna) ;; 天线类型编号
  (int 9 card-reader) ;; 读卡器类型
  (int 10 speaker) ;; 扬声器类型
  (int 11 router-board) ;; 路由板型号
  (int 12 sim-no) ;; SIM 卡号
  )

(struct register
  (int 1 sn) ;; 当前请求序列号
  (int 2 version) ;; 当前命令协议号
  (long 3 timestamp) ;; 当前服务器的时间戳
  (int 4 pin) ;; 设备 PIN 码
  ) ;; 设备第一次注册用

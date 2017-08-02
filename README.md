# box-packer

Supervisor 与 Service 之间的封包协议

## 协议编码

协议用 tightrope 来描述，保存在 proto.scm 中。执行如下命令生成协议代码:

    tightrope -entity -serial -java -d src/main/java proto.scm
    find -name "*.java" -exec javastyle "{}" \;

## 编译

    gradle jar

生成的 java jar 文件在 build/libs/packer.jar

## 生成文档

    gradle javadoc

文档在 build/docs/javadoc 下，用浏览器可打开。

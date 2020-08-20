# oracle-collector-plugin

## 使用方法

1. 下载该项目的压缩包。
2. 解压到 EasyOps 平台服务器上的任意目录，例如 "/tmp/host-collector-plugin"。
3. 使用 EasyOps 平台内置的插件包导入工具导入该压缩包，具体命令如下（请替换其中的`8888`、`easyops`为当前 EasyOps 平台具体的`org`和`user`）。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 easyops /tmp/oracle-collector-plugin
```

4. 导入成功后访问 EasyOps 平台的「采集插件」小产品页面 (http://your-easyops-server/next/collector-plugin)，就能看到导入的 "oracle-collector-plugin" 采集插件。
5. 接下来可使用该采集插件为具体的主机实例创建采集任务。

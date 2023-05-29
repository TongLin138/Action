### 使用规范

- 1. 只有 `main.sh` 脚本是调用命令或模块的主入口，其它除 `utils` 以外的目录下的脚本均为模块，根目录下的脚本为项目指令（软链接）

- 2. 模块脚本不可单独执行，代码中只允许存在函数，函数名不可使用 `main` 并且需要唯一，`main` 函数仅作为指令的主入口使用

- 3. 所有函数名称需使用小写字母，用于判断的变量尽量定义在函数内部，跨脚本使用的变量名称需使用大写字母组合，如果变量是参数则全部使用大写字母命名

- 4. 终端打印消息默认分为 `success`、`complete`、`warn`、`error`、`fail`、`tip`、`working` 八种类型，为了美观需要在起止处空行

  - `success` 成功
  - `complete` 完成
  - `warn` 警告
  - `error` 错误
  - `fail` 失败
  - `tip` 提示
  - `working` 工作中

### 导入模块的方法

例：导入 `task/run/main.sh`

```bash
import task/run
```

例：导入 `utils/request.sh`

```bash
import utils/request
```

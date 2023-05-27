### 使用规范

- 1. 只有 `main.sh` 是调用命令或模块的主入口，其它除 `utils` 以外的目录下的脚本均为模块

- 2. 模块脚本不可单独执行，代码中只允许存在函数，不可使用 `main` 作为函数名并且需要唯一

- 3. 所有函数名称需使用小写字母，变量尽量定义在函数内部，跨脚本使用的环境变量名称需全部使用大写字母

- 4. 终端打印消息默认分为 `success`、`complete`、`warn`、`warn`、`error`、`fail`、`tips`、`working` 八种类型

  - `success`：成功
  - `complete`：完成
  - `warn`：警告
  - `warn`：警告
  - `error`：错误
  - `fail`：失败
  - `tips`：提示
  - `working`：工作中

### 导入模块的方法

例：导入 `task/run/main.sh`

```bash
import task/run
```

例：导入 `utils/request.sh`

```bash
import utils/request
```

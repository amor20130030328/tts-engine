# TtsHelloWorld 工程结构

## 完整的文件结构

```
TtsHelloWorld/
├── AppScope/                                        # 应用级配置
│   ├── app.json5                                   # 应用配置
│   └── resources/base/element/
│       └── string.json                             # 应用字符串资源
│
├── entry/                                          # 主模块
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ets               # 入口 Ability
│   │   │   └── pages/
│   │   │       └── Index.ets                       # 主页面 ⭐核心代码
│   │   └── resources/base/
│   │       ├── element/
│   │       │   ├── string.json                    # 模块字符串资源
│   │       │   └── color.json                     # 颜色资源
│   │       └── profile/
│   │           └── main_pages.json                # 页面路由配置
│   ├── module.json5                               # 模块配置
│   ├── build-profile.json5                        # 模块构建配置
│   ├── oh-package.json5                           # 模块依赖配置 ⭐
│   └── hvigorfile.ts                              # 模块构建脚本
│
├── hvigor/
│   └── hvigor-config.json5                        # hvigor 配置
│
├── tts_engine_china/                              # TTS 引擎库 ⭐需要复制
│   └── index.d.ts
│
├── build-profile.json5                            # 工程构建配置
├── hvigorfile.ts                                  # 工程构建脚本
├── oh-package.json5                               # 工程依赖配置
├── README.md                                      # 完整文档
└── QUICKSTART.md                                  # 快速启动指南
```

## DevEco Studio 识别工程的关键文件

DevEco Studio 需要以下文件才能正确识别工程：

### ✅ 必需文件（已创建）

1. **build-profile.json5** (根目录) - 工程构建配置
2. **hvigorfile.ts** (根目录) - 工程构建脚本
3. **hvigor/hvigor-config.json5** - hvigor 配置
4. **oh-package.json5** (根目录) - 工程依赖
5. **AppScope/app.json5** - 应用级配置
6. **entry/build-profile.json5** - 模块构建配置
7. **entry/hvigorfile.ts** - 模块构建脚本
8. **entry/module.json5** - 模块配置
9. **entry/oh-package.json5** - 模块依赖（引用 tts_engine_china）

### ⚠️ 需要手动添加的文件

**tts_engine_china 库** - 从 TTSDemo 复制：
```bash
cp -r "D:\projects\TTS\TTSDemo\tts_engine_china" "D:\projects\TTS\TtsHelloWorld\"
```

## 在 DevEco Studio 中打开工程

### 方法1：直接打开
```
File -> Open -> 选择 D:\projects\TTS\TtsHelloWorld
```

### 方法2：导入工程
```
File -> Import Project -> 选择 D:\projects\TTS\TtsHelloWorld
```

### 打开后的操作

1. **等待索引完成**
   - 右下角显示 "Indexing..." 
   - 等待完成（可能需要几分钟）

2. **同步依赖**
   ```
   Tools -> Sync Project with oh-package Files
   ```
   或点击顶部提示的 "Sync Now"

3. **检查 SDK 配置**
   ```
   File -> Project Structure
   ```
   - 确认 HarmonyOS SDK 路径正确
   - 确认 API Version（建议 API 10+）

4. **验证工程结构**
   - 左侧项目树应该显示 "entry" 模块
   - "entry/src/main/ets/pages/Index.ets" 应该可以打开
   - 没有红色波浪线错误

## 如果 DevEco Studio 仍无法识别

### 问题1：提示 "Not a valid HarmonyOS project"

**解决方法：**
1. 确认所有配置文件都已创建（参考上面的清单）
2. 检查文件格式是否正确（JSON5 格式）
3. 重启 DevEco Studio

### 问题2：Cannot find module 'tts_engine_china'

**解决方法：**
1. 确认 `tts_engine_china` 目录存在于根目录
2. 检查 `entry/oh-package.json5` 中的路径：
   ```json
   "dependencies": {
     "tts_engine_china": "file:../tts_engine_china"
   }
   ```
3. 执行同步：`Tools -> Sync Project with oh-package Files`

### 问题3：hvigor 版本不匹配

**解决方法：**
修改 `hvigor/hvigor-config.json5`，将版本号改为你的 DevEco Studio 支持的版本：
```json
{
  "hvigorVersion": "4.0.5",  // 根据你的 DevEco Studio 版本调整
  "dependencies": {
    "@ohos/hvigor-ohos-plugin": "4.0.5"
  }
}
```

常见版本对应关系：
- DevEco Studio 4.0: hvigor 4.0.x
- DevEco Studio 4.1: hvigor 4.1.x
- DevEco Studio 5.0: hvigor 5.0.x

### 问题4：API Version 不匹配

**解决方法：**
修改 `entry/build-profile.json5`，添加：
```json
{
  "apiType": "stageMode",
  "buildOption": {
    "arkOptions": {
      "runtimeOnly": {
        "sources": []
      }
    }
  },
  "targets": [
    {
      "name": "default",
      "runtimeOS": "HarmonyOS",
      "compatibleSdkVersion": "4.0.0"  // 根据你的 SDK 版本
    }
  ]
}
```

## 验证工程是否正确识别

打开工程后，检查以下几点：

✅ **项目结构正常**
- 左侧 Project 树显示完整结构
- entry 模块图标正常

✅ **代码无错误**
- 打开 `Index.ets`
- 没有红色波浪线（引用错误）
- import 语句正常

✅ **可以构建**
- 工具栏有 ▶️ 运行按钮
- Build -> Make Module 'entry' 成功

✅ **依赖已解析**
- `tts_engine_china` 的类型定义可以跳转
- 按住 Ctrl 点击 `HyVoiceSynthesizer` 可以跳转到定义

## 现在的完整文件列表

所有必需文件都已创建：

```
✅ TtsHelloWorld/build-profile.json5
✅ TtsHelloWorld/hvigorfile.ts
✅ TtsHelloWorld/oh-package.json5
✅ TtsHelloWorld/hvigor/hvigor-config.json5
✅ TtsHelloWorld/AppScope/app.json5
✅ TtsHelloWorld/AppScope/resources/base/element/string.json
✅ TtsHelloWorld/entry/build-profile.json5
✅ TtsHelloWorld/entry/hvigorfile.ts
✅ TtsHelloWorld/entry/module.json5
✅ TtsHelloWorld/entry/oh-package.json5
✅ TtsHelloWorld/entry/src/main/ets/entryability/EntryAbility.ets
✅ TtsHelloWorld/entry/src/main/ets/pages/Index.ets
✅ TtsHelloWorld/entry/src/main/resources/base/profile/main_pages.json
✅ TtsHelloWorld/entry/src/main/resources/base/element/string.json
✅ TtsHelloWorld/entry/src/main/resources/base/element/color.json
✅ TtsHelloWorld/README.md
✅ TtsHelloWorld/QUICKSTART.md
⚠️ TtsHelloWorld/tts_engine_china/  (需要手动复制)
```

**下一步：**
1. 复制 tts_engine_china 库
2. 用 DevEco Studio 打开工程
3. 同步依赖
4. 运行测试

现在工程应该可以被 DevEco Studio 正确识别了！

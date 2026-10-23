# TTS HelloWorld 快速启动指南

## 一、准备工作（5分钟）

### 步骤1：复制 tts_engine_china 库

**从 TTSDemo 工程复制：**

```bash
# 在命令行执行
cp -r "D:\projects\TTS\TTSDemo\tts_engine_china" "D:\projects\TTS\TtsHelloWorld\"
```

或者手动复制：
1. 找到 `D:\projects\TTS\TTSDemo\tts_engine_china` 目录
2. 复制整个目录到 `D:\projects\TTS\TtsHelloWorld\` 下

**最终目录结构：**
```
TtsHelloWorld/
├── tts_engine_china/          ← 确保这个目录存在
│   ├── index.d.ts
│   └── ...
└── entry/
    └── oh-package.json5
```

### 步骤2：验证文件结构

确保这些文件都存在：
- ✅ `TtsHelloWorld/build-profile.json5`
- ✅ `TtsHelloWorld/entry/build-profile.json5`
- ✅ `TtsHelloWorld/entry/oh-package.json5`
- ✅ `TtsHelloWorld/entry/src/main/module.json5`
- ✅ `TtsHelloWorld/entry/src/main/ets/pages/Index.ets`
- ✅ `TtsHelloWorld/entry/src/main/ets/entryability/EntryAbility.ets`
- ✅ `TtsHelloWorld/tts_engine_china/` 目录

## 二、打开工程（2分钟）

### 1. 启动 DevEco Studio

### 2. 打开工程
```
File -> Open -> 选择 D:\projects\TTS\TtsHelloWorld
```

### 3. 等待索引完成
右下角会显示 "Indexing..." 等待完成

### 4. 同步依赖
```
Tools -> Sync Project with oh-package Files
```

或点击顶部提示栏的 "Sync Now"

## 三、运行测试（3分钟）

### 1. 连接设备

**真机：**
- USB 连接手机
- 开启开发者模式和 USB 调试
- 在 DevEco Studio 中选择设备

**模拟器：**
```
Tools -> Device Manager -> 创建/启动模拟器
```

### 2. 运行应用

点击工具栏的 ▶️ 运行按钮，或：
```
Run -> Run 'entry'
```

### 3. 测试功能

应用启动后，依次点击：

1. **1️⃣ 初始化引擎** 
   - 等待 2-5 秒
   - 看到 "✅ 就绪" 表示成功

2. **2️⃣ 开始合成**
   - 会看到音频数据回调
   - 最后显示 "✅ 合成完成"

3. **3️⃣ 停止合成**
   - 可以在合成过程中停止

4. **4️⃣ 销毁引擎**
   - 释放资源

**查看日志：**
- 界面下方有日志显示区域
- 或在 DevEco Studio 中查看：`View -> Tool Windows -> Log`

## 四、常见问题快速解决

### ❌ 编译错误：Cannot find module 'tts_engine_china'

**原因：** tts_engine_china 库未正确放置

**解决：**
1. 确认 `D:\projects\TTS\TtsHelloWorld\tts_engine_china\` 目录存在
2. 检查 `entry/oh-package.json5` 中路径：`"tts_engine_china": "file:../tts_engine_china"`
3. 执行：`Tools -> Sync Project with oh-package Files`

### ❌ 初始化失败

**原因：** 设备上没有对应的 TTS 模型

**解决：**
修改 `Index.ets` 第 67 行：
```typescript
// 将这行
[HyConstant.KEY_STYLE]: 'gpt-oral-npu',

// 改为
[HyConstant.KEY_STYLE]: 'interaction-broadcast',
```

### ❌ 没有听到声音

**说明：** 
本示例只演示合成，不包含播放功能。音频数据在日志中显示：
```
[音频] 收到数据: 4096 bytes
```

如需播放，需要集成 AudioRenderer。

### ❌ 模拟器运行失败

**解决：**
1. 使用真机测试（推荐）
2. 或确保模拟器支持 TTS 功能

## 五、修改测试文本

编辑 `entry/src/main/ets/pages/Index.ets` 第 102 行：

```typescript
const text = '你好世界，这是语音合成测试。欢迎使用华为寰语语音引擎。';
```

改成你想要合成的文本，重新运行即可。

## 六、更换发音人

编辑 `Index.ets` 第 66 行：

```typescript
// 小艺女声（默认）
[HyConstant.KEY_PERSON]: 0,

// 或改为聆小珊女声
[HyConstant.KEY_PERSON]: 13,

// 或改为凌飞哲男声
[HyConstant.KEY_PERSON]: 21,
```

## 七、下一步

✅ **成功运行后，你已经掌握了：**
1. HyVoiceSynthesizer 的基本使用
2. 引擎初始化流程
3. 文本合成流程
4. 回调接口的实现

📚 **继续学习：**
- 查看 `README.md` 了解完整 API
- 参考 `D:\projects\TTS\tts\` 了解完整服务实现
- 参考 `D:\projects\TTS\TTSDemo\` 了解音频播放等高级功能

## 技术支持

如有问题，请检查：
1. DevEco Studio 日志：`View -> Tool Windows -> Log`
2. 应用内日志区域
3. README.md 常见问题章节

---

**祝你使用愉快！🎉**

# TTS HelloWorld

这是一个独立的 HarmonyOS 工程，演示如何直接调用 HyVoiceSynthesizer 进行语音合成。

## 工程结构

```
TtsHelloWorld/
├── entry/
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ets          # 入口 Ability
│   │   │   └── pages/
│   │   │       └── Index.ets                  # 主页面（TTS 测试代码）
│   │   ├── resources/
│   │   │   └── base/profile/
│   │   │       └── main_pages.json           # 页面路由配置
│   │   └── module.json5                      # 模块配置
│   ├── build-profile.json5                   # 构建配置
│   └── oh-package.json5                      # 依赖配置
├── build-profile.json5                       # 工程配置
└── README.md                                 # 本文档
```

## 前置条件

### 1. 准备 tts_engine_china 库

**方式一：从现有工程复制**
```bash
# 假设你已有 TTSDemo 工程
cp -r "D:\projects\TTS\TTSDemo\tts_engine_china" "D:\projects\TTS\TtsHelloWorld\"
```

**方式二：从 SDK 或 HAR 包获取**
- 从华为开发者联盟下载 TTS SDK
- 解压后将 `tts_engine_china` 目录放到工程根目录

### 2. 目录结构确认

确保目录结构如下：
```
D:\projects\TTS\TtsHelloWorld\
├── tts_engine_china/              ← tts_engine_china 库
│   ├── index.d.ts
│   └── ...
└── entry/
    └── oh-package.json5           ← 依赖配置指向 tts_engine_china
```

## 快速开始

### 1. 用 DevEco Studio 打开工程
```
File -> Open -> 选择 TtsHelloWorld 目录
```

### 2. 同步依赖
```
Tools -> Sync Project with oh-package Files
```

### 3. 连接设备或启动模拟器

### 4. 运行工程
```
Run -> Run 'entry'
```

### 5. 测试步骤

在应用界面中按顺序点击：

1. **1️⃣ 初始化引擎** - 加载 TTS 模型（需要几秒）
2. **2️⃣ 开始合成** - 合成测试文本
3. **3️⃣ 停止合成** - 停止当前合成
4. **4️⃣ 销毁引擎** - 释放资源

日志区域会显示每一步的执行情况。

## 核心代码说明

### Index.ets - 主要流程

```typescript
// 1. 实现回调接口
private outputStream: OutputAudioStream = {
  onData: (type, audioData, ...) => { /* 音频数据 */ },
  onTextEnd: (stat) => { /* 合成完成 */ },
  onError: (error) => { /* 错误处理 */ }
};

// 2. 初始化引擎
async initEngine() {
  this.synthesizer = new HyVoiceSynthesizer();
  await this.synthesizer.init(context, params);
  this.instWrap = this.synthesizer.getInstWrap();
}

// 3. 执行合成
synthesizeText() {
  HyVoiceSynthesizer.setOutputAudioStream(this.outputStream);
  HyVoiceSynthesizer.synthesize(instWrap, text, params, lang);
}

// 4. 停止合成
stopSynth() {
  this.synthesizer.stop();
}

// 5. 销毁引擎
destroyEngine() {
  this.synthesizer.shutdown();
}
```

## HyVoiceSynthesizer API 速查

### 实例方法

| 方法 | 说明 |
|------|------|
| `init(context, params)` | 初始化引擎，加载模型 |
| `getInstWrap()` | 获取实例句柄 |
| `getCreateParam()` | 获取创建参数 |
| `stop()` | 停止合成 |
| `shutdown()` | 销毁引擎 |

### 静态方法

| 方法 | 说明 |
|------|------|
| `setOutputAudioStream(stream)` | 设置音频输出流 |
| `synthesize(wrap, text, params, lang)` | 执行文本合成 |

### 初始化参数

```typescript
const params = {
  [HyConstant.KEY_PERSON]: 0,                          // 发音人
  [HyConstant.KEY_LANG_TYPE]: HyLanguageType.ZH_CN,   // 语言
  [HyConstant.KEY_STYLE]: 'gpt-oral-npu',             // 风格
  [HyConstant.KEY_FILE_MGR]: HyConstant.FILE_MGR_ASSET // 资源类型
};
```

### 合成参数

```typescript
const params = {
  [HyConstant.KEY_VOLUME]: 50,  // 音量 (0-100)
  [HyConstant.KEY_SPEED]: 50,   // 语速 (0-100)
  [HyConstant.KEY_PITCH]: 50    // 音调 (0-100)
};
```

## 常见问题

### Q1: 编译错误 "Cannot find module 'tts_engine_china'"

**解决方案：**
1. 检查 `tts_engine_china` 目录是否在工程根目录
2. 检查 `entry/oh-package.json5` 中的路径是否正确
3. 在 DevEco Studio 中执行 `Tools -> Sync Project with oh-package Files`

### Q2: 初始化失败

**可能原因：**
1. 设备上没有对应的 TTS 模型
2. `gpt-oral-npu` 风格不可用

**解决方案：**
尝试修改风格为 `interaction-broadcast`：
```typescript
[HyConstant.KEY_STYLE]: 'interaction-broadcast'
```

### Q3: 没有声音播放

**说明：**
本示例只演示了合成，不包含音频播放功能。音频数据在 `onData` 回调中返回，需要使用 `AudioRenderer` 等播放器进行播放。

### Q4: 如何更换发音人？

修改 `KEY_PERSON` 参数：
- `0` = 小艺女声
- `13` = 聆小珊女声  
- `21` = 凌飞哲男声

```typescript
[HyConstant.KEY_PERSON]: 21  // 凌飞哲男声
```

### Q5: 如何使用下载的音色？

```typescript
const params = {
  [HyConstant.KEY_PERSON]: 21,
  [HyConstant.KEY_LANG_TYPE]: HyLanguageType.ZH_CN,
  [HyConstant.KEY_STYLE]: 'interaction-broadcast',
  [HyConstant.KEY_FILE_MGR]: HyConstant.FILE_MGR_EXTERNAL_STORAGE,  // 外部存储
  [HyConstant.KEY_MODEL_PATH]: '/path/to/downloaded/model'         // 模型路径
};
```

## 调试技巧

### 查看完整日志

在 DevEco Studio 中：
```
View -> Tool Windows -> Log
```

过滤日志：
```
[TtsHello]
```

### 查看初始化耗时

日志中会输出：
```
[xx:xx:xx] ✅ 初始化成功！耗时: 1234ms
```

### 查看音频数据大小

每次 `onData` 回调都会输出：
```
[xx:xx:xx] [音频] 收到数据: 4096 bytes
```

## 扩展功能

如果需要添加音频播放功能，可以参考 TTSDemo 工程中的：
- `TTSDemo/entry/src/main/ets/player/PcmPlayer.ets` - PCM 播放器

如果需要添加下载音色功能，可以参考：
- `tts/src/main/ets/TtsModelManager.ts` - 模型管理器
- `tts/src/main/ets/download/TtsDownloadCallback.ts` - 下载回调

## 参考资料

- 完整 TTS 服务实现：`D:\projects\TTS\tts\`
- TTS Demo 应用：`D:\projects\TTS\TTSDemo\`
- HyVoiceSynthesizer 使用示例：`entry/src/main/ets/pages/Index.ets`

## 许可证

本示例代码仅供学习参考。

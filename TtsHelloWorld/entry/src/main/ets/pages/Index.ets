/*
 * TTS HelloWorld - 极简 HyVoiceSynthesizer 调用示例
 *
 * 这是一个独立的 HelloWorld 工程，演示如何直接调用 HyVoiceSynthesizer
 */

import { HyVoiceSynthesizer, HyConstant, HyLanguageType, TtsException } from 'tts_engine_china/index';
import type { OutputAudioStream, SynthesisEnd } from 'tts_engine_china/index';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State statusText: string = '未初始化';
  @State logText: string = '';

  private synthesizer: HyVoiceSynthesizer | null = null;
  private instWrap: string | null = null;

  // ==================== 回调接口 ====================
  private outputStream: OutputAudioStream = {
    // 音频数据回调
    onData: (type: number, audioData: ArrayBuffer, begin: number, end: number, duration: string) => {
      if (type === HyConstant.ON_DATA_AUDIO_DATA) {
        this.log(`[音频] 收到数据: ${audioData.byteLength} bytes`);
      } else if (type === HyConstant.ON_DATA_WORDS_DURATION) {
        this.log(`[字级时长] ${duration}`);
      }
    },

    // 合成完成回调
    onTextEnd: (stat: SynthesisEnd) => {
      this.log('[完成] 合成结束');
      this.statusText = '✅ 合成完成';
    },

    // 错误回调
    onError: (error: TtsException) => {
      this.log(`[错误] ${error.getTip()}`);
      this.statusText = '❌ 合成失败';
    }
  };

  private log(msg: string) {
    const time = new Date().toLocaleTimeString();
    console.log(`[TtsHello] ${msg}`);
    this.logText = `[${time}] ${msg}\n${this.logText}`;
  }

  // ==================== 1. 初始化引擎 ====================
  async initEngine() {
    try {
      this.log('========== 开始初始化 ==========');
      this.statusText = '⏳ 初始化中...';

      // 创建合成器实例
      this.synthesizer = new HyVoiceSynthesizer();

      // 初始化参数
      const params = {
        [HyConstant.KEY_PERSON]: 0,                          // 发音人: 0=小艺女声
        [HyConstant.KEY_LANG_TYPE]: HyLanguageType.ZH_CN,   // 语言: 中文
        [HyConstant.KEY_STYLE]: 'gpt-oral-npu',             // 风格: 大模型
        [HyConstant.KEY_FILE_MGR]: HyConstant.FILE_MGR_ASSET // 资源: 预置
      };

      this.log(`参数: person=${params[HyConstant.KEY_PERSON]}, lang=${params[HyConstant.KEY_LANG_TYPE]}, style=${params[HyConstant.KEY_STYLE]}`);

      // 调用 init 加载模型
      const context = getContext(this) as common.UIAbilityContext;
      const startTime = Date.now();
      await this.synthesizer.init(context, params);
      const costTime = Date.now() - startTime;

      // 获取实例句柄
      this.instWrap = this.synthesizer.getInstWrap();

      this.log(`✅ 初始化成功！耗时: ${costTime}ms`);
      this.log(`实例句柄: ${this.instWrap}`);
      this.statusText = '✅ 就绪';
    } catch (e) {
      this.log(`❌ 初始化失败: ${e}`);
      this.statusText = '❌ 初始化失败';
    }
  }

  // ==================== 2. 执行文本合成 ====================
  synthesizeText() {
    if (!this.synthesizer || !this.instWrap) {
      this.log('⚠️ 请先初始化引擎');
      return;
    }

    try {
      this.log('========== 开始合成 ==========');
      this.statusText = '⏳ 合成中...';

      const text = '你好世界，这是语音合成测试。欢迎使用华为寰语语音引擎。';

      // 合成参数
      const params = {
        [HyConstant.KEY_VOLUME]: 50,  // 音量: 50
        [HyConstant.KEY_SPEED]: 50,   // 语速: 50
        [HyConstant.KEY_PITCH]: 50    // 音调: 50
      };

      this.log(`合成文本: "${text}"`);
      this.log(`合成参数: volume=50, speed=50, pitch=50`);

      // 设置输出流
      HyVoiceSynthesizer.setOutputAudioStream(this.outputStream);

      // 调用静态方法进行合成
      HyVoiceSynthesizer.synthesize(
        this.instWrap,
        text,
        params,
        HyLanguageType.ZH_CN
      );

      this.log('✅ 合成请求已发送');
    } catch (e) {
      this.log(`❌ 合成失败: ${e}`);
      this.statusText = '❌ 合成失败';
    }
  }

  // ==================== 3. 停止合成 ====================
  stopSynth() {
    if (this.synthesizer) {
      this.synthesizer.stop();
      this.log('⏹️ 已停止合成');
      this.statusText = '⏹️ 已停止';
    } else {
      this.log('⚠️ 引擎未初始化');
    }
  }

  // ==================== 4. 销毁引擎 ====================
  destroyEngine() {
    if (this.synthesizer) {
      this.synthesizer.shutdown();
      this.synthesizer = null;
      this.instWrap = null;
      this.log('🗑️ 引擎已销毁');
      this.statusText = '🗑️ 已销毁';
    } else {
      this.log('⚠️ 引擎未初始化');
    }
  }

  aboutToDisappear() {
    this.destroyEngine();
  }

  // ==================== UI 界面 ====================
  build() {
    Column({ space: 15 }) {
      // 标题
      Text('TTS HelloWorld')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 10 })

      Text('HyVoiceSynthesizer 极简调用示例')
        .fontSize(14)
        .fontColor('#888888')

      // 状态显示
      Text(this.statusText)
        .fontSize(18)
        .fontColor('#409EFF')
        .margin({ top: 10, bottom: 10 })

      Divider().width('85%').strokeWidth(2)

      // 操作步骤
      Text('操作步骤：')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 30, top: 10 })

      // 按钮组
      Button('1️⃣ 初始化引擎')
        .width('85%')
        .height(50)
        .fontSize(16)
        .backgroundColor('#409EFF')
        .onClick(() => this.initEngine())

      Button('2️⃣ 开始合成')
        .width('85%')
        .height(50)
        .fontSize(16)
        .backgroundColor('#67C23A')
        .onClick(() => this.synthesizeText())

      Button('3️⃣ 停止合成')
        .width('85%')
        .height(50)
        .fontSize(16)
        .backgroundColor('#E6A23C')
        .onClick(() => this.stopSynth())

      Button('4️⃣ 销毁引擎')
        .width('85%')
        .height(50)
        .fontSize(16)
        .backgroundColor('#F56C6C')
        .onClick(() => this.destroyEngine())

      Divider().width('85%').strokeWidth(2).margin({ top: 10 })

      // 日志区域
      Text('运行日志：')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 30, top: 10 })

      TextArea({ text: this.logText })
        .width('90%')
        .height(280)
        .fontSize(12)
        .backgroundColor('#F5F5F5')
        .border({ width: 1, color: '#DDDDDD', radius: 5 })

      Button('清空日志')
        .width('85%')
        .height(40)
        .fontSize(14)
        .backgroundColor('#909399')
        .onClick(() => { this.logText = '' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}

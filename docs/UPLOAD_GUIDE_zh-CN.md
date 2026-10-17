# Nexus Mods 发布说明

发布文件：`SinkingStarSketchPad-3.3.zip`。这是提供给玩家的完整包。作者材料目录无需一起上传，也不要上传本机安装后生成的 `installation.json`、存档、日志、诊断 DLL、游戏资源或开发用压缩包。

建议标题：**SinkingStarSketchPad - In-Game Drawing and Cell Paths**

简短英文介绍：**An in-game scratchpad with a themed cursor, drawing tools, saved pages and cell-snapped route marks. English and Simplified Chinese.**

版本：**3.3**；发布状态建议选择 **Beta**。在对应游戏分类下发布，未找到游戏分类时先按 Nexus 的游戏收录流程处理，不要放到无关游戏。作者署名为 ouyangzhixuan；项目源码和文档已选择 MIT 开源，请在 Nexus 页面保持与 MIT 一致的修改、转载和资源使用权限，第三方组件另按各自许可处理。

正文可使用同目录的 `NEXUS_DESCRIPTION_EN.md` / `.txt`，完整英文使用文档已在玩家包中。建议展示真实关卡里的路径与相机移动前后效果；附带的 UI 预览来自 DX12 测试程序，不是实际关卡截图，若上传请保留这一说明。

## AI 标记和说明

本项目的代码、界面和翻译主要由生成式 AI 生成，按当前 Nexus 规则应使用 **AI-Generated Content**；附带的 AI 生成封面和页面文字还对应 **AI Media**。不要仅用 AI Assisted 代替。英文介绍已包含如实说明。

依据：[Nexus File Submission Guidelines — Generative AI Tagging & Categorisation](https://help.nexusmods.com/article/28-file-submission-guidelines)。规则会更新，请在提交时再次查看。

## 已准备的组件和验证说明

- 主包包含经过校验的插件、ReShade 6.8.0 完整插件运行库、配置、Noto 字体及第三方许可。
- 安装脚本不包含你的 Steam 库路径，会在玩家本机检测；脚本不执行下载。
- 中英文 UI、语言持久化、升级、保留配置/草稿、冲突拒绝和卸载均有本地测试。
- 实际游戏只完成相机/上传数据研究；完整关卡视觉对齐未全面实测。页面不要宣称兼容所有关卡、自动寻路、提升帧数或修复游戏性能。
- ZIP 不加密，不包含内嵌压缩包。[Nexus 扫描说明](https://help.nexusmods.com/article/117-why-has-my-mod-been-quarantined)指出内嵌压缩包会影响扫描。

Nexus Mods 的文件和文案已经准备，尚未自动上传到 Nexus。GitHub 开源仓库另见下文。

## 开源仓库

项目源码和文档采用 **MIT** 许可证：[https://github.com/ouyangzhixuan/SinkingStarSketchPad](https://github.com/ouyangzhixuan/SinkingStarSketchPad)。第三方组件仍按各自许可分发。

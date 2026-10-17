#pragma once
#include <array>
#include <string_view>

namespace sketch::i18n {
enum class Language { System, English, Chinese };
inline constexpr const char *language_code(Language l){return l==Language::English?"en":l==Language::Chinese?"zh-CN":"auto";}
inline Language parse_language(std::string_view s){return s=="en"?Language::English:s=="zh-CN"?Language::Chinese:Language::System;}
inline bool use_chinese(Language l,bool system_chinese){return l==Language::Chinese||(l==Language::System&&system_chinese);}

#define SKETCH_TEXTS(X) \
 X(Title,"SinkingStarSketchPad###SinkingStarSketch","SinkingStarSketchPad###SinkingStarSketch") \
 X(Pen,"Pen P","画笔 P") X(Line,"Line L","直线 L") X(Arrow,"Arrow A","箭头 A") \
 X(Rectangle,"Rectangle R","矩形 R") X(Ellipse,"Ellipse O","椭圆 O") X(Text,"Text T","文字 T") \
 X(Eraser,"Eraser K","橡皮 K") X(Path,"Path H","路径 H") X(Color,"Color","颜色") X(Width,"Width","笔宽") \
 X(Undo,"Undo","撤销") X(Redo,"Redo","重做") X(Clear,"Clear page","清空本页") X(Page,"Page ","草稿 ") \
 X(Save,"Save","保存") X(Saved,"Saved","已保存") X(Saving,"Saving...","正在保存") X(Export,"Export SVG","导出 SVG") \
 X(Return,"Return to game E","返回游戏 E") \
 X(Help,"E / Esc: return | Shift: snap | Right click / Ctrl+Z: undo | Ctrl+Y: redo","E / Esc 返回游戏 · Shift 吸附 · 右键 / Ctrl+Z 撤销 · Ctrl+Y 重做") \
 X(Stats,"Page %u/3 | %zu marks | %s","草稿 %u/3 · %zu 条笔迹 · %s") \
 X(NewPath,"Finish / New path","结束路径 / 新路径") X(GridPreview,"Cell-center preview","格心预览") \
 X(GridStats,"Auto grid: %.3g cell size | %u detected centers","自动格子：间距 %.3g · %u 个格心") \
 X(PathHelp,"Click centers in a row or column. Add a point at each turn.","点击格心加点，转弯处加点。") \
 X(GridWait,"Detecting the grid from game instances. No calibration needed.","正在从游戏实例自动识别格子，无需手动校准。") \
 X(CameraReady,"Game camera connected","游戏主相机已连接") \
 X(CameraWait,"Waiting for the game camera. Enter a level to show paths.","等待游戏主相机；请先进入关卡。路径暂不显示。") \
 X(Anchoring,"Pen/text: screen space. Path H: anchored to world cells.","画笔和文字固定在画面；路径 H 固定在游戏格子上。") \
 X(TextTitle,"Text annotation###SketchText","文字标注###SketchText") X(Done,"Done Ctrl+Enter","完成 Ctrl+Enter") X(Cancel,"Cancel Esc","取消 Esc") \
 X(Hud,"SinkingStarSketchPad  E Draw | G Cursor | B Show/Hide","SinkingStarSketchPad  E绘图 G指针 B显隐") \
 X(SaveFailed,"Save failed: ","保存失败：") X(SettingsFailed,"Could not save the language setting.","无法保存语言设置。") \
 X(Recovered,"Draft recovered from backup.","已从备份恢复草稿。") X(Unreadable,"Could not read the old draft; the original was preserved.","旧草稿无法读取；原文件已保留。") \
 X(Full,"Page or point limit reached. Switch pages or remove marks.","本页或点数已满，请换页或清理笔迹。") \
 X(Cleared,"Page cleared. Ctrl+Z restores it.","本页已清空，Ctrl+Z 可恢复。") \
 X(NoCamera,"Game camera unavailable. Enter a level and try again.","尚未读取到游戏主相机，请回到关卡后重试。") \
 X(Detecting,"Detecting the grid. Please wait before placing points.","正在自动识别关卡格子，稍候再点击。") \
 X(NoPlane,"Could not project this position onto the cell plane.","此处无法投影到格子平面。") \
 X(NeedCorner,"Add a point at the corner first: paths follow rows or columns.","请先点击转弯格：路径沿格子横向或纵向连接。") \
 X(TooFar,"Points are too far apart. Add intermediate points.","两点距离过远，请分段添加。") \
 X(PathFull,"Path point limit reached.","路径点数已满。") \
 X(Exported,"Exported to SinkingStarSketch-data/exports.","已导出到 SinkingStarSketch-data/exports。") X(ExportFailed,"Export failed: ","导出失败：")

enum class Text {
#define ITEM(id,en,zh) id,
SKETCH_TEXTS(ITEM)
#undef ITEM
Count
};
struct Entry {const char *en,*zh;};
inline constexpr std::array<Entry,static_cast<size_t>(Text::Count)> catalog={{
#define ITEM(id,en,zh) {en,zh},
SKETCH_TEXTS(ITEM)
#undef ITEM
}};
inline const char *get(Text text,bool chinese){auto &entry=catalog[static_cast<size_t>(text)];return chinese?entry.zh:entry.en;}
#undef SKETCH_TEXTS
}

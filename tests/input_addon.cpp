// Private test add-on: exercise the production overlay with deterministic
// focus transitions. No desktop focus changes or system input are generated.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
static HWND fixture_foreground;
static HWND WINAPI fixture_GetForegroundWindow(){return fixture_foreground;}
#define GetForegroundWindow fixture_GetForegroundWindow
#define AddonInit ProductionAddonInit
#include "../src/addon.cpp"
#undef AddonInit
#undef GetForegroundWindow
namespace {
unsigned fixture_frame=0;
size_t marks_before=0;
void require(bool ok,const char*message){
    if(!ok){std::ofstream("input-integration-failure.txt",std::ios::app)<<message<<'\n';}
}
void fixture_overlay(effect_runtime *rt){
    ++fixture_frame;
    fixture_foreground=static_cast<HWND>(rt->get_hwnd());
    if(fixture_frame==2)editing=true;
    if(fixture_frame==10){
        marks_before=page().size();pending=Stroke();pending.tool=Tool::Pen;
        pending.points={{.3f,.3f},{.6f,.6f}};dragging=true;
        fixture_foreground=nullptr;
    }
    if(fixture_frame>=11&&fixture_frame<=14)fixture_foreground=nullptr;
    if(fixture_frame==30){text_open=true;text_buffer[0]='x';text_buffer[1]=0;}
    if(fixture_frame>=35&&fixture_frame<=39)fixture_foreground=nullptr;
    if(fixture_frame==114){text_open=true;text_buffer[0]='y';text_buffer[1]=0;}
    overlay(rt);
    auto &io=ImGui::GetIO();
    if(fixture_frame>=2)require(editing,"Drawing intent lost (including runtime resize)");
    if(fixture_frame>=2&&fixture_frame<30){
        require(editing,"Drawing intent was lost on focus transition");
        require(!io.WantCaptureKeyboard,"Keyboard movement captured outside text entry");
        require(io.WantCaptureMouse==(fixture_foreground!=nullptr),"Incorrect mouse capture");
    }
    if(fixture_frame==10){require(!dragging,"Stroke left dragging after blur");require(page().size()==marks_before+1,"Interrupted stroke was not committed");require(!dirty,"Interrupted stroke not saved");}
    if(fixture_frame>=30&&fixture_frame<=40){
        require(editing&&text_open&&text_buffer[0]=='x',"Text entry lost during focus transition");
        require(io.WantCaptureKeyboard==(fixture_foreground!=nullptr),"Text capture did not follow focus");
    }
    if(fixture_frame==41){text_open=false;text_buffer[0]=0;}
    if(fixture_frame==42)require(!io.WantCaptureKeyboard,"Keyboard capture remained after text closed");
    if(fixture_frame==60)std::ofstream("input-integration-complete.txt")<<"60 production overlay frames; focus, stroke save, text preservation and capture assertions completed\n";
    if(fixture_frame==90){require(selected==Tool::Pen,"Game movement key A changed drawing tool");selected=Tool::Path;}
    if(fixture_frame==135){require(text_open&&text_buffer[0]=='y',"Text entry lost during runtime resize");text_open=false;text_buffer[0]=0;}
}
}
extern "C" __declspec(dllexport) bool AddonInit(HMODULE addon,HMODULE runtime){
    if(!ProductionAddonInit(addon,runtime))return false;
    reshade::unregister_event<reshade::addon_event::reshade_overlay>(overlay);
    reshade::register_event<reshade::addon_event::reshade_overlay>(fixture_overlay);
    return true;
}

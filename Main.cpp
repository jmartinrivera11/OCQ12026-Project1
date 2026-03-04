#include "easm.h"
#include "MipsDisplay.hpp"

static std::unique_ptr<MipsDisplay> display;

extern "C" ErrorCode handleSyscall(uint32_t *regs, void *mem, MemoryMap *mem_map)
{
    unsigned v0 = regs[Register::v0];

    switch (v0)
    {
        case 100: // start engine
            if(!display) {
                display = std::make_unique<MipsDisplay>();
                display->RunEngine();
                display->Sleep(500);
            }
            return ErrorCode::Ok;

        case 101: // set pixel
            if(display) {
                int x = regs[Register::a0];
                int y = regs[Register::a1];
                uint32_t color = regs[Register::a2];
                display->SetPixel(x, y, color);
            }   
            return ErrorCode::Ok;

        case 102: //refresh
            if(display) {
                display->RefreshWindow();
                display->Sleep(16);
            }
            return ErrorCode::Ok;

        case 103: // clear
            if(display) {
                uint32_t color = regs[Register::a0];
                display->Clear(color);
            }
            return ErrorCode::Ok;

        case 104: // get key
            if(display) {
                regs[Register::v0] = display->GetLastKey();
            }
            return ErrorCode::Ok;

        case 105: //exit graphics
            if(display) {
                display->StopEngine();
                display.reset();
            }
            return ErrorCode::Stop;

        default:
            return ErrorCode::SyscallNotImplemented;
    }
}

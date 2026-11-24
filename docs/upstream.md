# Proposed upstream contribution (not submitted)

Target: https://github.com/mdqinc/SDL_GameControllerDB and https://github.com/ValveSoftware/steam-for-linux

Title: Add independent paddles to 8BitDo Ultimate 3mode Xbox Bluetooth mapping on Linux

Device: Bluetooth VID 2dc8, PID 901b; GUID 0500beb8c82d00001b90000001000000.

The default mapping omits b2 and b5. evtest identifies P1 as BTN_C and P2 as BTN_Z. Adding `paddle1:b2,paddle2:b5,` to the existing mapping using SDL_GAMECONTROLLERCONFIG causes Steam to expose L5 and R5 in its input test and Extended Buttons in Core Keeper. In-game assignment was confirmed. Please see controller-mapping.txt for the complete exported mapping and docs/protocol.md for observations. This change is Bluetooth-specific; the 2.4 GHz Xbox protocol mode is not fixed by it.

Before submitting, check current upstream mappings and contribution instructions; avoid duplicate entries and preserve upstream ordering/metadata conventions.

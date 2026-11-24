# Research notes

## Bluetooth (confirmed)

Linux evtest observed A as BTN_SOUTH (304, HID scan 90001), P1 as BTN_C (306, 90003), P2 as BTN_Z (309, 90006). Both paddles can be held simultaneously and release independently. Axis ranges reported by evtest were 0–255. Steam exported GUID `0500beb8c82d00001b90000001000000`; its default mapping omitted b2 and b5. Adding the paddle bindings via SDL_GAMECONTROLLERCONFIG exposed L5 and R5, verified in Core Keeper. No controller emulation was required.

## USB / 2.4 GHz (observed, not solved)

USB VID:PID 2dc8:200f, bcdDevice 2.00, vendor class ff/subclass 47/protocol d0. Interface 0 uses interrupt IN 0x81 and OUT 0x01 (64-byte maximum, 4 ms interval). Interface 1 has an inactive alternate setting and isochronous endpoints on alternate 1, plausibly audio. No HID interface was observed. Kernel 7.0.0-43-generic bound xpad to interface 0.

Individual P1 and P2 tests with unassigned paddles each produced six bursts of five 36-byte input reports. Excluding the sequence counter at byte offset 2, their payloads were identical and reported no buttons. The timing is consistent with three presses/releases for each paddle. After mapping P1 to X using hardware controls, both physical X and P1 produced the same input reports (byte offset 4 = 0x40 when pressed). The default reporting mode therefore cannot distinguish those inputs. This does not prove an extended mode is impossible.

A direct cable test showed the same USB descriptors, including the same serial (not published). Independent wired operation was not separately verified. Further work: investigate official configuration protocol, compare supported Xbox initialization/reporting modes, determine whether extended reports can be enabled without firmware changes. Do not send undocumented write commands blindly.

## Capture format

Text captures contain relative timestamps and hex USB payloads from endpoint 0x81 only. No raw enumeration capture, serial numbers, Bluetooth addresses, hostnames, or unrelated USB traffic are included. P1/P2 captures also contain one short status report each. Reproduce with usbmon and tshark; filter to the controller's USB address and endpoint before sharing.

%macro import 1
extern _%1
%1:
    call _%1
    ret
%endmacro

; COLORS, in a, b, g, r format 
BLACK equ 0X00_00_00_00
WHITE equ 0XFF_FF_FF_FF

; KEYS
KEY_SPACE equ 32
KEY_RIGHT equ 262
KEY_LEFT equ 263
KEY_DOWN equ 264
KEY_UP equ 265
; LOG LEVELS
LOG_NONE equ 7
; -> void
import InitWindow
; -> bool
import WindowShouldClose
; -> void
import BeginDrawing
; r8    : int color
; ecx   : int height
; edx   : int width
; esi   : int posY
; edi   : int posX
; -> void
import DrawRectangle
; -> void
import EndDrawing
; -> void
import ClearBackground
; -> void
import CloseWindow
; edi   : int fps
; -> void
import SetTargetFPS
; edi   : int logLevel
; -> void
import SetTraceLogLevel
; edi   : int key
; -> bool
import IsKeyDown
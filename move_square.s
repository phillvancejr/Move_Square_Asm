segment .text
global _main

%include "pal.s"
%include "raylib.s"

width   equ 500
height  equ 500
sz      equ 50
speed   equ 10
fps     equ 60

_main:
    mov edi, LOG_NONE
    call SetTraceLogLevel

    lea rdx, [ rel title ]
    mov esi, height
    mov edi, width
    call InitWindow

    mov edi, fps
    call SetTargetFPS

main_loop:
    call update

    call BeginDrawing
    call render
    call EndDrawing

    call WindowShouldClose
    cmp rax, false
    je main_loop
quit:
    call CloseWindow
    pal.exit 0

update:
    enter 0, 0
    xor rax, rax
    mov edi, KEY_RIGHT
    call  IsKeyDown
    when al
        add [rel sx], dword speed
    end

    xor rax, rax
    mov edi, KEY_LEFT
    call  IsKeyDown
    when al
        sub [rel sx], dword speed
    end

    xor rax, rax
    mov edi, KEY_UP
    call  IsKeyDown
    when al
        sub [rel sy], dword speed
    end

    xor rax, rax
    mov edi, KEY_DOWN
    call  IsKeyDown
    when al
        add [rel sy], dword speed
    end

    ; check collision

    mov eax, false ; start off false
    mov ebx, true ; true in ebx
    cmp [rel sx], dword 0 ; compare square x
    cmovl eax, ebx ; if sx is less than 0 then move true into eax

    when eax ; clamp to left side
        mov [rel sx], dword 0
    end

    mov eax, false ; start off false
    mov ebx, true ; true in ebx
    cmp [rel sx], dword (width - sz) ; compare square x
    cmovg eax, ebx 

    when eax ; clamp to left side
        mov [rel sx], dword (width - sz)
    end

    mov eax, false ; start off false
    mov ebx, true ; true in ebx
    cmp [rel sy], dword 0 ; compare square y
    cmovl eax, ebx ; if sy is less than 0 then move true into eax

    when eax ; clamp to top
        mov [rel sy], dword 0
    end

    mov eax, false ; start off false
    mov ebx, true ; true in ebx
    cmp [rel sy], dword (height - sz) ; compare square y
    cmovg eax, ebx 

    when eax ; clamp to bottom
        mov [rel sy], dword (height - sz)
    end

    leave
    ret

render:
    enter 0, 0
    ; draw background
    mov edi, BLACK
    call ClearBackground

    ; draw square
    mov r8d, WHITE
    mov ecx, sz
    mov edx, sz
    mov esi, [rel sy]
    mov edi, [rel sx]
    call DrawRectangle

    leave
    ret

segment .data
sx dd (width / 2) - (sz / 2)
sy dd (height / 2) - (sz / 2)
title db `Move Square Nasm\0`

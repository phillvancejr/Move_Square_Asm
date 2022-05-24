; Phill's Assembly Library
;==================== GENERAL CONSTANTS ==================== 
true equ 1
false equ 0

;==================== GENERAL CONSTANTS ==================== 
;==================== VARS ==================== 
;==================== VARS ==================== 

;==================== CONTROL FLOW ==================== 
; LOOPS
; repeat until  and repeat until

; Example
; increment rcx in loop
; mov rcx, 0
; repeat 
;   inc rcx
; until rcx, e, 2 ; do it 3 times

%macro repeat 0
    %push repeat
    %$do_body:
%endmacro

; repeat
;   body
; until a, cond, b
; cond is a condition like e, l, le etc.
%macro until 3
        cmp %1, %3
        j%-2 %$do_body
    %pop
%endmacro

; repeat 
;   body 
; while cond
; cond is any numeric value where 0 is false and anything is true
; it could be a register, memory location, constant etc.
%macro while 1
        cmp %1, false
        jne %$do_body
    %pop
%endmacro

; CONDITIONALS
; Conditionals have two forms, when and if/else chains
; Conditionals must be pared with an end statement

; when runs its body when the condition is true
; Example 1:
; mov rcx, true
; when rcx
;   inc rcx ; if rcx is true then increment it
; end
; Example 2 - while loop:
; xor rax, rax
; mov rcx, true
; loop:
; when rcx
;   inc rax
;   ; condition
;   cmp rax, 10
;   cmovge rcx, false ; conditionally move false into rcx if rax is >= 10
;   jmp loop ; jump back to loop
; end

%macro when 1
    %push when
    cmp %1, false
    je %$end
    %$when_body:
%endmacro


; if is like when, but it must contain an else block
; Example
; xor rax, rax
; mov rcx, false
; if rcx
;   mov rax, 10 ; if rcx is true mov 10 to rax
; else
;   mov rax, 3 ; else move 3 into rax
; end


%macro if 1
    %push if
    cmp %1, 0
    je %$else_body
    %$if_body:
%endmacro

%macro else 0
    jmp %$end
    %$else_body:
%endmacro

%macro end 0
        %$end:
    %pop
%endmacro


;==================== SYS CALLS ==================== 

;The __OUTPUT_FORMAT__ standard macro holds the current Output Format, as given by the -f option or NASM's default. Type nasm -hf for a list.
;
;%ifidn __OUTPUT_FORMAT__, win32 
;  %define NEWLINE 13, 10 
;%elifidn __OUTPUT_FORMAT__, elf32 
; %define NEWLINE 10 
;%endif

%ifidn __OUTPUT_FORMAT__, macho64
sys_exit equ 0x2000001
sys_write equ 0x2000004
%endif
;==================== SYS CALLS ==================== 

;==================== CONTROL FLOW ==================== 

;==================== STD LIBRARY ==================== 
%macro pal.exit 1
%ifidn __OUTPUT_FORMAT__, macho64
    mov rdi, %1
    mov rax, sys_exit
    syscall
%endif
%endmacro 

;==================== STD LIBRARY ==================== 

;==================== C FFI ==================== 
; TODO
; C call block that checks the current stack alignment, then aligns it once at the beginning
; all calls to C functions in this block are guaranteed to be aligned unless the stack is modified
;==================== C FFI ==================== 
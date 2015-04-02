extern kernel
global _idt
global _idtr

[BITS 16]
  jmp 0x0:beginning

beginning:
  cli
  lgdt [_gdtr]
  
  ; Переход в защищенный режим
  mov eax, cr0
  or  eax, 1
  mov cr0, eax

  jmp 0x8:protected
  [BITS 32]
protected:
  mov ax, 8 * 2
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov esp, 0x800000
  mov dword [0x10004], _process_states

  ; Вызов модуля protected
  mov eax, 0x100000
  push eax
  sub esp,1412
  push ebp
  mov ebp,esp
  call kernel

section .data
align 8
_gdt:
  dq 0
  dd 0x0000ffff, 0x00df9f00
  dd 0x0000ffff, 0x00df9300
_gdtr:
  dw _gdtr - _gdt - 1
  dd _gdt
_idtr:
  dw 256 * 8
  dd _idt

section .bss
align 8
_idt:
  resq 256
_process_states:
  dd _stack_pointers
  resb 20
_stack_pointers:
  resd 16

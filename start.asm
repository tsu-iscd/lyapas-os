extern _protected
global _idt
global _idtr

[BITS 16]
  jmp 0x0:beginning

beginning:
  cli
  ; загрузка GDTR
  lgdt [_gdtr]
  
  ; переход в защищенный режим
  mov eax, cr0
  or  eax, 1
  mov cr0, eax

  jmp 0x8:protected
  [BITS 32]
protected:
  ; установка сегментных регистров
  mov ax, 8 * 2
  mov ds, ax
  mov es, ax
  ; вызов модуля protected
  mov eax, 0x100000
  push eax
  sub esp,1412
  push ebp
  mov ebp,esp
  call _protected
  pop ebp
  add esp,1412

  sti
  int 0x3
  int 0x23
  int 0x30
  jmp $

section .data
align 8
_gdt:
  dq 0
  ; code segment desc.
  dd 0x0000ffff, 0x00df9f00
  ; data segment desc.
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

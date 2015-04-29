extern kernel
global _idt
global _idtr

[BITS 16]
  jmp 0x0:beginning

beginning:
  cli
  lgdt [_gdtr]
  
  ; turn to protected mode
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

  ; create page tables
  mov ebx, 0x0
  mov edx, 0x12000
  xor eax, eax
  .fill_page_table:
    mov ecx, ebx
    or ecx, 3
    mov [edx + eax * 4], ecx
    add ebx, 0x1000
    inc eax
    cmp eax, 0x2000
    jl .fill_page_table

  ; create page_directory
  or edx, 3
  mov ebx, _page_directory
  mov ecx, 8
  .fill_page_directory:
    mov [ebx], edx
    add edx, 0x1000
    add ebx, 4
    loop .fill_page_directory

  ; turn to paging
  mov eax, _page_directory
  add eax, 4
  mov cr3, eax

  mov eax, cr0
  or eax, 0x80000000
  mov cr0, eax

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
_page_directory equ 0x11000

section .bss
align 8
_idt:
  resq 256
_process_states:
  dd _stack_pointers
  resb 20
_stack_pointers:
  resd 16

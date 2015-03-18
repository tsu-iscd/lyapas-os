[BITS 16]
[ORG 0x7c00]
    
  jmp 0x0:beginning
beginning:

  ; очистка экрана
  mov ax, 0xb800
  mov es, ax
  xor bx, bx
  mov ecx, 80 * 25 * 2
  clearing:
    mov byte [es:bx], 0
    inc bx
  loop clearing

  ; загрузка ядра с диска
  mov ax, 0x800
  mov es, ax
  xor bx, bx
  mov ah, 2
  mov al, 8
  mov dl, 0x80
  mov cx, 2
  xor dh, dh
  int 0x13
  %assign i 1
  %rep 4
  mov ax, 0x800 + 0x100 * i
  mov es, ax
  xor bx, bx
  mov ah, 2
  mov al, 8
  mov dl, 0x80
  mov cx, 2
  mov dh, i
  int 0x13
  %assign i i + 1
  %endrep
  
  ; переход на ядро
  jmp 0x8000    

  ; отсчитывание неиспользуемого пространства
  times 510 - ($ - $$) db 0x90

  ; объявление диска загрузочным
  db 0x55
  db 0xaa

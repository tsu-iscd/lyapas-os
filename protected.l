_protected(/)
    {extern _idtr}
    OK10000h
    OK10001h
    OK10002h
    OK10003h
    @+F1(32)
    @'Welcome!'>F1
    10@>F1
    *print(F1/)
    *construct_idt(/)
    {lidt [_idtr]}
    *init_pic(/)
**

*** print string on screen
*** F1 - string
print(F1/)
    K10000h = y 
    K10001h = x
    y * 160 + x = k
    _j
P1  Dj#Q1 ?-3
    F1j = s
    ?(s >= 32)2
    F1j#10?+1
    k ; 160 = x
    k + 160 - x = k ?=1
P2  k + 0xb8000 = i
    F1j = Ki Di Dk
    7 = Ki Di Dk
    ?(k < 4000)1
    0xb8000 = p + 160 = r
    _q 3840 = k
    P4 Dq#3840?-1
    Kr = Kp Dp Dr ?=4
P3  k / 160 = K10000h
    k ; 160 = K10001h
**

*** initialization PICs
init_pic(/)
    *** Master PIC
    {mov al, 0x11}  ***ICW1
    {out 0x20, al}
    {mov al, 0x20}  ***ICW2
    {out 0x21, al}
    {mov al, 0x04}  ***ICW3
    {out 0x21, al}
    {mov al, 0x01}  ***ICW4
    {out 0x21, al}
    {mov al, 0xfe}  ***OCW1
    {out 0x21, al}
    *** Slave PIC
    {mov al, 0x11}  ***ICW1
    {out 0xa0, al}
    {mov al, 0x28}  ***ICW2
    {out 0xa1, al}
    {mov al, 0x02}  ***ICW3
    {out 0xa1, al}
    {mov al, 0x01}  ***ICW4
    {out 0xa1, al}
    {mov al, 0xff}  ***OCW1
    {out 0xa1, al}
    *** PIT
    {mov al, 0x34}
    {out 0x43, al}
    {mov al, 0xff}
    {out 0x40, al}
    {mov al, 0xff}
    {out 0x40, al}
**

*** constructing IDT
construct_idt(/)
    {extern _idt}
    _j
    {mov eax, _idt}
    = i
    @+L1(49)
    *create_int_list(L1/)
P1  Dj#0x31?-2
    L1j & 0x0000ffff | 0x00080000 = g
    g = Ki Di
    g > 8 = Ki Di
    g > 16 = Ki Di
    g > 24 = Ki Di
    L1j & 0xffff0000 | 0x00008f00 = g
    g = Ki Di
    g > 8 = Ki Di
    g > 16 = Ki Di
    g > 24 = Ki Di
    ?=1
P2  i - 3 = i
    Ki & 0xfe = Ki
**

print_number(n/)
    @+F1(16)
P1  n ; 10 + '0' @>F1
    n / 10 = n ?+1
    _i Q1 = j > 1 = k
P2  Di#k ?-3 Yj
    F1i = a
    F1j = F1i
    a = F1j ?=2
P3
    *print(F1/)
**

_protected(/)
    {extern _idtr}
    OK[10000h]
    @+F1(16)
    @'Welcome!'>F1
    10@>F1
    *print(F1/)
    *construct_idt(/)
    {lidt [_idtr]}
    *init_pic(/)
    @+L1(3) _i
    0x7c0000 = p
    P1  Di#3 ?-2
        p = L1i
        p - 0x40000 = p ?=1
    P2
    *load_procs(L1/)
    *scheduler(L1/)
**

*** print string on screen
*** F1 - string
print(F1/)
     K[10000h] = k
     _j
    P1  Dj#Q1 ?-4
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
        _q 3842 = k
    P3  Dq#3840?-1
        Kr = Kp Dp Dr ?=3
    P4  k = K[10000h]
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
        L1j & 0x0000ffff | 0x00080000 = K[i]
        i + 4 = i
        L1j & 0xffff0000 | 0x00008f00 = K[i]
        i + 4 = i ?=1
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
    P3  *print(F1/)
**

load_procs(L1/)
    @+L2(3)
    [proc_0] = L2.0
    [proc_1] = L2.1
    [proc_2] = L2.2
    _i
    P1  Di#3 ?-2
        L1i - 4 = s
        0x606 = K[s]
        s - 4 = s
        8 = K[s]
        s - 4 = s
        L2i = K[s]
        s - 24 = s
        L1i - 0x20000 = K[s] + 1416 = c
        L1i - 0x40000 = K[c]
        s - 8 = L1i ?=1
    P2
    @-L2
**

scheduler(L1/)
    @+F2(3)
    0x11 = F2.0
    1 = F2.1 = F2.2
    2 = a
    {sti}
    P1  _i
    P2  Di#3 ?-1 a?-3
        F2i > 4 ?+2
    P3  F2i & 1 ?-2
        {push ebp}
        {pushf}
        {push dword 0x8}
        {push dword .P4}
        {mov [0x10004], esp}
        L1i
        {mov esp, eax}
        {popa}
        {iret}
    P4  {pop ebp}
        K[10008h] = L1i ?=2
**


proc_0(/)
    P1 ?=1
**

proc_1(/)
    @+F1(16)
    @'Proc 1'>F1
    10@>F1
    P1 *print(F1/) ?=1
**

proc_2(/)
    @+F1(16)
    @'Proc 2'>F1
    10@>F1
    P1 *print(F1/) ?=1
**

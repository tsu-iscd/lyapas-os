kernel(/)
    {extern _idtr}
    OK[10000h]
    31 = K10010h
    @+F1(16)
    @'Welcome to OS LYAPAS!'>F1
    10@>F1
    *print(F1/)
    *construct_idt(/)
    {lidt [_idtr]}
    *init_controllers(/)
    *load_procs(/)
    {mov [0x10024], esp}
    {mov esp, [0x10058]}
    {mov word [0x10028], 0x10}
    {mov word [0x10070], 0x23}
    {mov ax, 0x2b}
    {ltr ax}
    {mov ax, 0x23}
    {mov ds, ax}
    {mov es, ax} 
    {mov fs, ax} 
    {mov gs, ax}
    {popa}
    {iret}
**

print(F1/)
     K[10000h] = k
     _j
    P1  Dj#Q1 ?-4
        F1j = s
        ?(s >= 32)2
        F1j#10?+1
        k ; 160 = x
        ?(k >= 3840)11
        k + 160 - x = k ?=5
        P11 Dk Dx#160?-5
            k + 0xb8000 = i
            OKi  ?=11
    P2  k + 0xb8000 = i
        F1j = Ki Di Dk
        7 = Ki Di Dk
    P5  ?(k < 4000)1
        0xb8000 = p + 160 = r
        _q 3840 = k
    P3  Dq#3840?-1
        Kr = Kp Dp Dr ?=3
    P4  k = K[10000h]
**

init_controllers(/)
    *** Master PIC
    {mov al, 0x11}
    {out 0x20, al}
    {mov al, 0x20}
    {out 0x21, al}
    {mov al, 0x04}
    {out 0x21, al}
    {mov al, 0x01}
    {out 0x21, al}
    {mov al, 0xfc}
    {out 0x21, al}

    *** Slave PIC
    {mov al, 0x11}
    {out 0xa0, al}
    {mov al, 0x28}
    {out 0xa1, al}
    {mov al, 0x02}
    {out 0xa1, al}
    {mov al, 0x01}
    {out 0xa1, al}
    {mov al, 0xff}
    {out 0xa1, al}

    *** Keyboard
    {mov al, 0xae}
    {out 0x64, al}
    {mov al, 0xf3}
    {out 0x60, al}
    {mov al, 0x7f}
    {out 0x60, al}

    *** Timer
    {mov al, 0x34}
    {out 0x43, al}
    {mov al, 0xff}
    {out 0x40, al}
    {out 0x40, al}
    {mov al, 0xf4}
    {out 0x60, al}
**

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

create_int_list(L1/)
    _i
    P1  Di#49 ?-2
        [empty_interrupt] = L1i ?=1
    P2  [timer_interrupt] = L1.32
        [keyboard_interrupt] = L1.33
**

empty_interrupt(/)
    {iret}
**

timer_interrupt(/)
    {cli}
    {pusha}
    DK10010h # 32 ?+1
    OK10010h
    *scheduler(/)
    {mov esp, [0x10058]}
    P1
    {mov al, 0x60}
    {out 0x20, al}
    {popa}
    {iret}
**

keyboard_interrupt(/)
    {cli}
    {pusha}
    {mov al, 0xad}
    {out 0x64, al}
    *handle_scancode(/)
    {mov al, 0x61}
    {out 0x20, al}
    {mov al, 0xae}
    {out 0x64, al}
    {popa}
    {iret}
**

handle_scancode(/)
    {xor eax, eax}
    {in al, 0x60}
    = k # 0xe0 ?-1
    k # 0xf0 ?-2
    ?=3
    P1
    {xor eax, eax}
    {in al, 0x60}
    # 0xf0 ?+3
    P2
    {xor eax, eax}
    {in al, 0x60}
    P3  ?(k < 2)4 ?(k > 4)4
        K[10004h] + 6 = a + k = s
        Yk  Ks = c & 1 ?-31
        YKa  c & 0xfe = Ks ?=4
        P31 DKa  c | 1 = Ks
    P4
**

load_procs(/)
    4 = n
    K[10004h] = s
    K[s] = q s + 4 = s
    n = Ks Ds
    0 = Ks Ds
    n - 1 = Ks Ds
    0x11 = Ks Ds
    1 = Ks Ds
    1 = Ks Ds
    1 = Ks 
    0x7c0000 = p _i
    P1  Di#n ?-2
        p = K[q]
        p - 0x10000 = p
        q + 4 = q ?=1
    P2
    @+L2(n)
    [proc_0] = L2.0
    [proc_1] = L2.1
    [proc_2] = L2.2
    [proc_3] = L2.3
    _i
    K[10004h] = q
    K[q] = q
    0x7c0000 = w
    P3  Di#n ?-4
        K[q] - 4 = s
        0x23 = K[s]
        s - 4 = s
        w = K[s]
        s - 4 = s
        w - 0x10000 = w
        0x7606 = K[s]
        s - 4 = s
        0x1b = K[s]
        s - 4 = s
        L2i = K[s]
        s - 24 = s
        K[q] - 0x8000 = K[s] + 1416 = c
        K[q] - 0x10000 = K[c]
        s - 8 = K[q]
        q + 4 = q ?=3
    P4  K[10004h] = p K[p] = p
    K[p] = K[10058h]
    @-L2
**

scheduler(/)
    K[10004h] = s
    K[s] = p
    s + 4 = n + 1 = i + 1 = a + 1 = c
    Ki = j * 4 + p = q
    K[10058h] = K[q]
    P1  Dj#Kn ?+2 Oj 
    P2  c + j = s
        Ka?-3
        Ks > 4 ?+1
    P3  Ks & 1 ?-1
    j * 4 + p = p
    K[p] = K[10058h]
    j = Ki
**

proc_0(/)
    P1 31 = K10010h ?=1
**

proc_1(/)
    @+F1(24)
    @'Proc 1'>F1
    10@>F1
    P1 *print(F1/) _i
        P2 Di#300000?+2
    ?=1
**

proc_2(/)
    @+F1(24)
    @'       Proc 2'>F1
    10@>F1
    P1 *print(F1/) _i
        P2 Di#300000?+2
    ?=1
**

proc_3(/)
    @+F1(24)
    @'              Proc 3'>F1
    10@>F1
    P1 *print(F1/) _i
        P2 Di#300000?+2
    ?=1
**
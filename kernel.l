kernel(/)
    {extern _idtr}
    OK[10000h]  *** cursor
    @+F1(16)
    @'Welcome to OS LYAPAS!'>F1
    10@>F1
    *print(F1/)

    *construct_idt(/)
    {lidt [_idtr]}

    *init_controllers(/)
    *load_procs(/)
    *fill_paging_tables(/)

    *** init TSS
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

    *** enable paging
    {mov eax, 0x13000}
    {mov [0x10010], eax}
    {mov cr3, eax}
    {mov eax, cr0}
    {or eax, 0x80000000}
    {mov cr0, eax}

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
    P3  Dq#3840?-31
        Kr = Kp Dp Dr ?=3
        P31 _q
            0xb8f00 = w
        P32 Dq#40?-1
            OK[w]
            w + 4 = w ?=32
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
        L1j & 0xffff0000 | 0x0000ef00 = K[i]
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
        [system_call] = L1.48
**

fill_paging_tables(/)
    *** kernel
    0x12000 = a
    0x100000 = b
    0x17f = c
    _i
    P1 Di#2?-12
        b | 0x3f = K[a]
        a + 4 = a
        _j
        P11 Dj#1024?-1
            c = K[b] + 0x1000 = c
            b + 4 = b ?=11
    P12

    *** processes
    0x110000 = b
    0x13000 = a
    0x17f = c
    _k
    P3  Dk#4 ?-31
        b | 0x3f = K[a]
        _i
        P4  Di#20?-41
            c = K[b] + 0x1000 = c
            b + 4 = b ?=4
            P41

        3 - k * 0x10000 + 0x78017f = c

        _i
        P6  Di#16?-61
            c = K[b] + 0x1000 = c
            b + 4 = b ?=6
            P61

        _i
        P7  Di#988?-71
            OK[b]
            b + 4 = b ?=7
        P71

        a + 0x1000 = a
        0x17f = c
        ?=3
    P31
**

system_call(/)
    {cli}
    {pusha}

    *** change page directory
    {push esp}
    {mov ebx, cr3}
    {mov eax, 0x12000}
    {mov cr3, eax}

    *** convert esp
    {mov ebx, [ebx]}
    {and ebx, 0xfffff000}
    {mov eax, esp}
    {and eax, 0xfffff000}
    {shr eax, 10}
    {add eax, ebx}
    {mov eax, [eax]}
    {and eax, 0xfffff000}
    {and esp, 0xfff}
    {add esp, eax}

    *** convert edx
    {mov eax, edx}
    {and eax, 0xfffff000}
    {shr eax, 10}
    {add eax, ebx}
    {mov eax, [eax]}
    {and eax, 0xfffff000}
    {and edx, 0xfff}
    {add edx, eax}

    *** create complex F1
    {mov ebp, 0x20000}
    {mov byte [ebp + 121], 1}
    {mov [ebp + 620], ecx}
    {mov [ebp + 1020], ecx}
    {mov [ebp + 220], edx}

    *print(F1/)

    *** change page directory
    {pop esp}
    {mov ebx, [0x10010]}
    {mov cr3, ebx}

    {popa}
    {iret}
**

empty_interrupt(/)
    {iret}
**

timer_interrupt(/)
    {cli}
    {pusha}

    *** change page directory
    {mov ebx, cr3}
    {mov eax, 0x12000}
    {mov cr3, eax}

    *** convert esp
    {mov [0x10058], esp}
    {mov ebx, [ebx]}
    {and ebx, 0xfffff000}
    {mov eax, esp}
    {and eax, 0xfffff000}
    {shr eax, 10}
    {add eax, ebx}
    {mov eax, [eax]}
    {and eax, 0xfffff000}
    {and esp, 0xfff}
    {add esp, eax}

    *scheduler(/)
    {mov al, 0x60}
    {out 0x20, al}

    *** change page directory
    {mov esp, [0x10058]}
    {mov ebx, [0x10010]}
    {mov cr3, ebx}

    {popa}
    {iret}
**

keyboard_interrupt(/)
    {cli}
    {pusha}

    *** change page directory
    {push esp}
    {mov ebx, cr3}
    {mov eax, 0x12000}
    {mov cr3, eax}

    *** convert esp
    {mov ebx, [ebx]}
    {and ebx, 0xfffff000}
    {mov eax, esp}
    {and eax, 0xfffff000}
    {shr eax, 10}
    {add ebx, eax}
    {mov eax, [ebx]}
    {and eax, 0xfffff000}
    {and esp, 0xfff}
    {add esp, eax}

    {mov ebp, 0x20000}

    {mov al, 0xad}
    {out 0x64, al}
    *handle_scancode(/)
    {mov al, 0x61}
    {out 0x20, al}
    {mov al, 0xae}
    {out 0x64, al}

    *** change page directory
    {pop esp}
    {mov ebx, [0x10010]}
    {mov cr3, ebx}

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
    ?=4
    P3  ?(k < 2)4 ?(k > 4)4
        k - 1 * 16 + 0x10200 = s
        K[s] # 1 = K[s]
    P4
**

load_procs(/)
    13000h = K[10208h]
    14000h = K[10218h]
    15000h = K[10228h]
    16000h = K[10238h]

    1020Ch = k
    10210h = K[k]
    1021Ch = k
    10220h = K[k]
    1022Ch = k
    10230h = K[k]
    1023Ch = k
    10200h = K[k] = K[10004h] = K[10008h] = s

    0x10001 = K[10200h]
    1 = K[10210h] = K[10220h] = K[10230h]

    @+L2(n)
    [proc_0] = L2.0
    [proc_1] = L2.1
    [proc_2] = L2.2
    [proc_3] = L2.3

    0x7bfffc = p
    0x23ffc = r - 0x100 = w
    10204h = q 4 = n _i
    P3  Di#n ?-4
        p - 4 = s
        0x23 = K[s]
        s - 4 = s
        w = K[s]
        s - 4 = s
        0x7606 = K[s]
        s - 4 = s
        0x1b = K[s]
        s - 4 = s
        L2i = K[s]
        s - 24 = s
        r - 0x8000 = K[s]
        p - 0x8000 + 1416 = c
        r - 0xfffc = K[c]
        r - 52 = K[q]
        q + 16 = q
        p - 0x10000 = p
        ?=3
    P4  K[10004h] + 4 = p
    K[p] = K[10058h] + 52 = K[10024h]
    @-L2
**

scheduler(/)
    K[10008h] + 4 = s + 8 = n
    K[10058h] = K[s]
    K[n] = n

    Ol
    P1  K[n] & 1 ?-11
        K[n] > 16 & 0xf = k ?-12  *** check priority
        ?(l >= k)12 Dl
        P11 n + 12 = n
            K[n] = n ?=1
        P12

    n = K[10008h] + 4 = n
    K[n] = K[10058h] + 52 = K[10024h]
    n + 4 = n
    K[n] = K[10010h]
**

proc_0(/)
    P1 ?=1
**

proc_1(/)
    @+F1(8)
    @'Proc 1'>F1
    10@>F1
    P1  
        {pusha}
        {mov edx, [ebp + 220]}
        {mov ecx, [ebp + 1020]}
        {int 0x30} 
        {popa}
        _i
        P2 Di#300000?+2
    ?=1
**

proc_2(/)
    @+F2(16)
    @'       Proc 2'>F2
    10@>F2
    P1  
        {pusha}
        {mov edx, [ebp + 224]}
        {mov ecx, [ebp + 1024]}
        {int 0x30} 
        {popa}
        _i
        P2 Di#300000?+2
    ?=1
**

proc_3(/)
    @+F3(24)
    @'              Proc 3'>F3
    10@>F3
    P1  
        {pusha}
        {mov edx, [ebp + 228]}
        {mov ecx, [ebp + 1028]}
        {int 0x30} 
        {popa}
        _i
        P2 Di#300000?+2
    ?=1
**

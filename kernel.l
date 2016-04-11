*** 0x10000 cursor
*** 0x10004 pointer to head of process state list
*** 0x10008 pointer to current process state

kernel(/)
    {extern _idtr}
    OK[10000h]  *** reset cursor

    *construct_idt(/)
    {lidt [_idtr]}

    *init_controllers(/)
    *load_procs(/)
    *fill_paging_tables(/)

    *** init TSS
    {mov word [0xbf08], 0x10}
    {mov ax, 0x2b}
    {ltr ax}

    *** set segment registers
    {mov ax, 0x23}
    {mov ds, ax}
    {mov es, ax} 
    {mov fs, ax} 
    {mov gs, ax}

    {mov esp, [0xbf38]}

    *** enable paging
    {mov eax, 0x12000}
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
    {mov ax, 0x11}
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
    {mov eax, _idt} = i
    _j
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
    0x20000 = b
    0x12000 = a
    0x17c = c
    _k
    P1  Dk#4 ?-11
        b | 0x3f = K[a]
        _i
        P2  Di#8?-21
            c = K[b] + 0x1000 = c
            b + 4 = b ?=2
            P21

        _i c | 1 = c
        P3  Di#4?-31
            c = K[b] + 0x1000 = c
            b + 4 = b ?=3
            P31

        c | 3 = c

        k * 0x10000 + 0x10017f = c

        _i
        P6  Di#16?-61
            c = K[b] + 0x1000 = c
            b + 4 = b ?=6
            P61

        _i
        P7  Di#996?-71
            OK[b]
            b + 4 = b ?=7
        P71

        a + 0x1000 = a
        0x17c = c
        ?=1
    P11
**

system_call(/)
    {cli}
    {pusha}

    {push esp}
    {push eax}
    {push ebx}
    {push ecx}

    *** disable paging
    {mov eax, cr0}
    {and eax, 0x7fffffff}
    {mov cr0, eax}

    {mov ebx, cr3}

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

    {mov ebp, 0x40000}
    {pop ecx}
    *** create complex F1
    {mov byte [ebp + 121], 1}
    {mov [ebp + 620], ecx}
    {mov [ebp + 1020], ecx}
    {mov [ebp + 220], edx}
    {pop ebx}
    {mov [ebp + 8], ebx}
    {pop eax}
    {mov [ebp + 4], eax}

    a # 3 ?+0
    P3 
        *print(F1/)
        ?=0

    P0
    {pop esp}

    *** enable paging
    {mov eax, cr0}
    {or eax, 0x80000000}
    {mov cr0, eax}

    {popa}
    {iret}
**

empty_interrupt(/)
    {iret}
**

timer_interrupt(/)
    {cli}
    {pusha}

    *** disable paging
    {mov eax, cr0}
    {and eax, 0x7fffffff}
    {mov cr0, eax}

    {mov ebx, cr3}

    *** convert esp
    {mov [0xbf38], esp}
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
    {mov esp, [0xbf38]}
    {mov ebx, [0x10008]}
    {add ebx, 8}
    {mov ebx, [ebx]}
    {mov cr3, ebx}

    *** enable paging
    {mov eax, cr0}
    {or eax, 0x80000000}
    {mov cr0, eax}

    {popa}
    {iret}
**

keyboard_interrupt(/)
    {cli}
    {pusha}

    {push esp}

    *** disable paging
    {mov eax, cr0}
    {and eax, 0x7fffffff}
    {mov cr0, eax}

    {mov ebx, cr3}

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

    {pop esp}

    *** enable paging
    {mov eax, cr0}
    {or eax, 0x80000000}
    {mov cr0, eax}

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
    12000h = K[10208h]
    13000h = K[10218h]
    14000h = K[10228h]
    15000h = K[10238h]

    10210h = K[1020Ch]
    10220h = K[1021Ch]
    10230h = K[1022Ch]
    10200h = K[1023Ch] = K[10004h] = K[10008h] = s

    0x10001 = K[10200h]
    1 = K[10210h] = K[10220h] = K[10230h]

    @+L2(n)
    [proc_0] = L2.0
    [proc_1] = L2.1
    [proc_2] = L2.2
    [proc_3] = L2.3

    0x10fffc = p
    0x1bffc = r - 0x100 = w
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
        p + 0x10000 = p
        ?=3
    P4  K[10004h] + 4 = p
    K[p] = K[0BF38h] + 52 = K[0BF04h]
    @-L2
**

scheduler(/)
    K[10008h] + 4 = s + 8 = n
    0xbf38 = e
    K[e] = K[s]
    K[n] = n

    Ol
    P1  K[n] & 1 ?-11
        K[n] > 16 & 0xf = k ?-12  *** check priority
        ?(l >= k)12 Dl
        P11 n + 12 = n
            K[n] = n ?=1
        P12

    n = K[10008h] + 4 = n
    K[n] = K[0BF38h] + 52 = K[0BF04h]
    n + 4 = n
    K[n]
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
        {mov eax, 3}
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
        {mov eax, 3}
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
        {mov eax, 3}
        {mov edx, [ebp + 228]}
        {mov ecx, [ebp + 1028]}
        {int 0x30} 
        {popa}
        _i
        P2 Di#300000?+2
    ?=1
**

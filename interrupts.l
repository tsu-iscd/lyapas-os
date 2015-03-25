
create_int_list(L1/)
    _i
P1  Di#49 ?-2
    [interrupt]=L1i ?=1
P2  [timer_handler]=L1.32
**

interrupt(/)
    iret
**

timer_handler(/)
    @+F1(16)
    @'Timer '>F1
    *print(F1/)
    K[10004h] = i Di
    *print_number(i/)
    i = K[10004h]
    10 = F1.0
    1 = Q1
    *print(F1/)
    {mov al, 0x60}
    {out 0x20, al}
    iret
**

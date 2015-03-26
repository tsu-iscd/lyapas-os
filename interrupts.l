
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
    {pusha}
    {mov [0x10008], esp}
    {mov esp, [0x10004]}
    {mov al, 0x60}
    {out 0x20, al}
    {iret}
**

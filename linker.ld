SECTIONS
{
    . = 0x8000;

    .text : {
_TEXT_START_ = .;
        *(.text)
_TEXT_END_ = .;
    }

    .data : {
_DATA_START_ = .;
        *(.data)
        *(.rodata)
_DATA_END_ = .;
    }

    .bss : {
_BSS_START_ = .;
        *(.bss)
_BSS_END_ = .;
    }

    /DISCARD/ : {
        *(.comment)
        *(.eh_frame)
    }
}

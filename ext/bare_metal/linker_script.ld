MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
  .text :
  {
    *(.text)
    *(.rodata)
    *(.text*)
    *(.rodata*)
  } > FLASH

  .data :
  {
    *(.data)
    *(.data*)
  } > RAM AT > FLASH

  .bss :
  {
    *(.bss)
    *(.bss*)
  } > RAM

  _heap_start = ORIGIN(RAM) + LENGTH(RAM);
  _stack_start = ORIGIN(RAM);
}


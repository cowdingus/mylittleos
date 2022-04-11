global loader                  ; the entry symbol for ELF
MAGIC_NUMBER equ 0x1BADB002    ; define the magic number constant
FLAGS        equ 0x0           ; multiboot flags
CHECKSUM     equ -MAGIC_NUMBER ; calculate the checksum2
                               ; (magic number + checksum + flags should equal 0)
KERNEL_STACK_SIZE equ 4096

extern sum_of_three
extern fb_write_cell
extern kmain

section .bss
align 4
kernel_stack:
  resb KERNEL_STACK_SIZE

section .text                  ; start of the text (code) section
align 4                        ; the code must be 4 byte aligned
  dd MAGIC_NUMBER              ; write the magic number to the machine code
  dd FLAGS                     ; the flags,
  dd CHECKSUM                  ; and the checksum

loader:                        ; the loader label (defined as entry point in linker script)
  mov esp, kernel_stack + KERNEL_STACK_SIZE
  mov eax, 0xCAFEBABE

  ; Runs kmain
  call kmain

  ; Adds 3, 2, 1. Return value in EAX
  push dword 3
  push dword 2
  push dword 1
  call sum_of_three

  ; Prints the value returned
  add ax, word 48
  mov bx, word 0x0F00
  or ax, bx
  mov word [0x000B8000], word ax

.loop:
  jmp .loop                    ; loop forever

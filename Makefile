CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -Iinc -c
LDFLAGS = -T link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf

BUILD_DIR = build/
SRC_DIR = src/
INC_DIR = inc/

_OBJS = loader.o kmain.o io.o
OBJS = $(patsubst %,$(BUILD_DIR)/%,$(_OBJS))

all: $(BUILD_DIR)/kernel.elf

$(BUILD_DIR)/kernel.elf: $(OBJS)
	ld $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/os.iso: $(BUILD_DIR)/kernel.elf
	cp $< iso/boot/kernel.elf
	grub-mkrescue -o $@ iso

run: $(BUILD_DIR)/os.iso
	bochs -f bochsrc -q

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS)  $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf build/*

#include "fb_color_table.h"

#include "io.h"

/* The I/O ports */
#define FB_COMMAND_PORT         0x3D4
#define FB_DATA_PORT            0x3D5

/* The I/O port commands */
#define FB_HIGH_BYTE_COMMAND    14
#define FB_LOW_BYTE_COMMAND     15

char *fb = (char *) 0x000B8000;

int sum_of_three(int arg1, int arg2, int arg3) {
	return arg1 + arg2 + arg3;
}

void fb_write_cell(unsigned int i, char c, unsigned char fg, unsigned char bg) {
	fb[i] = c;
	fb[i+1] = ((bg & 0x0F) << 4) | (fg & 0x0F);
}

void fb_move_cursor(unsigned short pos) {
	outb(FB_COMMAND_PORT , FB_HIGH_BYTE_COMMAND);
	outb(FB_DATA_PORT    , ((pos >> 8) & 0x00FF));
	outb(FB_COMMAND_PORT , FB_LOW_BYTE_COMMAND);
	outb(FB_DATA_PORT    , pos >> 8 & 0x00FF);
}

int write(char* buf, unsigned int len) {
	for (unsigned int i = 0; i < len; ++i) {
		if (buf[i] == '\0') return i + 1;
		fb_write_cell(i*2, buf[i], FB_WHITE, FB_BLACK);
	}

	return len;
}

void kmain() {
	write("Hello World!", 13);
	return;
}

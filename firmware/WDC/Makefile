Z80ASM ?= z80asm

.PHONY: all clean

all: firmware.rebuilt.bin
	cmp firmware.bin $<

firmware.rebuilt.bin: firmware.asm
	$(Z80ASM) -o $@ $<

clean:
	rm -f firmware.rebuilt.bin

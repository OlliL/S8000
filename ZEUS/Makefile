
# Install https://github.com/tgtakaoka/libasm

ASM ?= asm
AWK ?= awk
ASMFLAGS ?= -C Z8001 --no-short-direct

.PHONY: all verify clean

all: verify

md.hex: md.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

md.dump: md.hex intel_hex_to_hd.awk
	$(AWK) -f intel_hex_to_hd.awk md.hex > $@.tmp && mv $@.tmp $@

verify: md.dump md.hd
	diff -u md.hd md.dump

clean:
	rm -f md.hex md.dump md.dump.tmp

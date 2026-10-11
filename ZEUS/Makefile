
# Install https://github.com/tgtakaoka/libasm

ASM ?= asm
AWK ?= awk
ASMFLAGS ?= -C Z8001 --no-short-direct

.PHONY: all verify verify-md verify-zd clean

all: verify

md.hex: md.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

zd.hex: zd.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

md.dump: md.hex intel_hex_to_hd.awk
	$(AWK) -f intel_hex_to_hd.awk md.hex > $@.tmp && mv $@.tmp $@

zd.dump: zd.hex intel_hex_to_hd.awk
	$(AWK) -f intel_hex_to_hd.awk zd.hex > $@.tmp && mv $@.tmp $@

verify-md: md.dump md.hd
	diff -u md.hd md.dump

verify-zd: zd.dump zd.hd
	diff -u zd.hd zd.dump

verify: verify-md verify-zd

clean:
	rm -f md.hex md.dump md.dump.tmp zd.hex zd.dump zd.dump.tmp

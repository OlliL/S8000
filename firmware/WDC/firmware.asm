; Reconciled WDC 8 KiB Z80 firmware listing.
; Byte authority: firmware.bin; ROM file offset equals CPU address 0000h-1FFFh.
; The image is exactly u27.bin at 0000h-0FFFh followed by u28.bin at 1000h-1FFFh.
; Instruction bytes are preserved in trailing comments. Data blocks below are emitted
; as bytes/words where control flow or direct transfer proves they are not instructions.
; Symbolic routine names are descriptive navigation aids, not recovered original names.
; Board map: 0000h-1FFFh EPROM, 4000h-7FFFh SRAM, C000h-FFFFh I/O space.
; The separate 512-byte PROMs are not part of firmware.bin.

        org     0000h
reset_vector:
        jp      002ah                                ; 0000: C3 2A 00

; 0003h-0004h are not executed after the reset JP; retain them without a semantic claim.
        org     0003h
unclassified_boot_bytes:
        db      061h, 011h                 ; 0003: 61 11
        org     0005h
copyright_text:
        db      "Copyright Zilog, Inc. 1981", 0FFh ; 0005-001F: ASCII plus terminator

; IM 2 vectors: the vector-byte offsets 20h,22h,24h,26h,28h select these words.
interrupt_vector_table:
        dw      interrupt_handler_1       ; 0020-0021: 4B 15 -> 154Bh
        dw      interrupt_handler_2       ; 0022-0023: 6B 15 -> 156Bh
        dw      interrupt_handler_3       ; 0024-0025: 8A 15 -> 158Ah
        dw      interrupt_handler_4       ; 0026-0027: 93 15 -> 1593h
        dw      interrupt_handler_5       ; 0028-0029: 23 16 -> 1623h
rom_entry:
        ld      hl,0028h                             ; 002A: 21 28 00
        ld      de,0033h                             ; 002D: 11 33 00
        jp      1603h                                ; 0030: C3 03 16
startup_stage_2:
        ld      a,04h                                ; 0033: 3E 04
        out     (20h),a                              ; 0035: D3 20
        ld      hl,003dh                             ; 0037: 21 3D 00
        jp      069dh                                ; 003A: C3 9D 06
application_entry:
        ld      sp,41ffh                             ; 003D: 31 FF 41
        call    00c9h                                ; 0040: CD C9 00
main_loop_entry:
        ld      sp,41ffh                             ; 0043: 31 FF 41
input_wait_loop:
        in      a,(21h)                              ; 0046: DB 21
        cpl                                          ; 0048: 2F
        and     10h                                  ; 0049: E6 10
        jr      nz,0055h                             ; 004B: 20 08
        ld      a,(733dh)                            ; 004D: 3A 3D 73
        or      a                                    ; 0050: B7
        jr      nz,005bh                             ; 0051: 20 08
        jr      0046h                                ; 0053: 18 F1
process_input_event:
        call    0061h                                ; 0055: CD 61 00
        call    nz,00c4h                             ; 0058: C4 C4 00
        call    0160h                                ; 005B: CD 60 01
        jp      0043h                                ; 005E: C3 43 00
scan_input_event:
        ld      hl,75c4h                             ; 0061: 21 C4 75
        in      a,(60h)                              ; 0064: DB 60
        and     1fh                                  ; 0066: E6 1F
        cp      00h                                  ; 0068: FE 00
        jr      z,00a5h                              ; 006A: 28 39
        cp      0ch                                  ; 006C: FE 0C
        jr      z,00a5h                              ; 006E: 28 35
        cp      15h                                  ; 0070: FE 15
        jr      z,00a5h                              ; 0072: 28 31
        cp      16h                                  ; 0074: FE 16
        jr      z,00a5h                              ; 0076: 28 2D
        cp      0eh                                  ; 0078: FE 0E
        jp      z,002ah                              ; 007A: CA 2A 00
        in      a,(61h)                              ; 007D: DB 61
        cp      04h                                  ; 007F: FE 04
        jp      m,0094h                              ; 0081: FA 94 00
        in      a,(60h)                              ; 0084: DB 60
        and     20h                                  ; 0086: E6 20
        call    00c4h                                ; 0088: CD C4 00
        ld      e,0fh                                ; 008B: 1E 0F
        ld      b,08h                                ; 008D: 06 08
        call    nz,042dh                             ; 008F: C4 2D 04
        xor     a                                    ; 0092: AF
        ret                                          ; 0093: C9
build_input_mask:
        ld      de,002ah                             ; 0094: 11 2A 00
        ld      b,a                                  ; 0097: 47
        ld      a,01h                                ; 0098: 3E 01
        inc     b                                    ; 009A: 04
        dec     b                                    ; 009B: 05
        jr      z,00a2h                              ; 009C: 28 04
        add     a,a                                  ; 009E: 87
        add     hl,de                                ; 009F: 19
        jr      009bh                                ; 00A0: 18 F9
        ld      b,a                                  ; 00A2: 47
        jr      00a7h                                ; 00A3: 18 02
        ld      b,01h                                ; 00A5: 06 01
        ld      a,(hl)                               ; 00A7: 7E
        cp      00h                                  ; 00A8: FE 00
        ret     nz                                   ; 00AA: C0
record_input_event:
        ld      a,(733dh)                            ; 00AB: 3A 3D 73
        or      b                                    ; 00AE: B0
        ld      (733dh),a                            ; 00AF: 32 3D 73
        ld      a,01h                                ; 00B2: 3E 01
        ld      (hl),a                               ; 00B4: 77
        inc     hl                                   ; 00B5: 23
        ld      c,5fh                                ; 00B6: 0E 5F
        ld      b,0fh                                ; 00B8: 06 0F
        inc     c                                    ; 00BA: 0C
        ini                                          ; 00BB: ED A2
        jr      nz,00bah                             ; 00BD: 20 FB
        ld      a,91h                                ; 00BF: 3E 91
        out     (70h),a                              ; 00C1: D3 70
        ret                                          ; 00C3: C9
write_control_9a:
        ld      a,9ah                                ; 00C4: 3E 9A
        out     (70h),a                              ; 00C6: D3 70
        ret                                          ; 00C8: C9
initialize_runtime:
        ld      a,01h                                ; 00C9: 3E 01
        ld      (733bh),a                            ; 00CB: 32 3B 73
        ld      hl,0020h                             ; 00CE: 21 20 00
        ld      a,h                                  ; 00D1: 7C
        ld      i,a                                  ; 00D2: ED 47
        call    1535h                                ; 00D4: CD 35 15
        call    0d0ah                                ; 00D7: CD 0A 0D
        call    134bh                                ; 00DA: CD 4B 13
        ld      a,91h                                ; 00DD: 3E 91
        out     (70h),a                              ; 00DF: D3 70
        im      2                                    ; 00E1: ED 5E
        ei                                           ; 00E3: FB
        ld      hl,003ch                             ; 00E4: 21 3C 00
        call    15ebh                                ; 00E7: CD EB 15
        ld      a,(420dh)                            ; 00EA: 3A 0D 42
        or      a                                    ; 00ED: B7
        jp      z,00eah                              ; 00EE: CA EA 00
        xor     a                                    ; 00F1: AF
        ld      (420dh),a                            ; 00F2: 32 0D 42
        dec     hl                                   ; 00F5: 2B
        ld      a,h                                  ; 00F6: 7C
        or      l                                    ; 00F7: B5
        jp      nz,00e7h                             ; 00F8: C2 E7 00
        call    15fch                                ; 00FB: CD FC 15
        ld      a,04h                                ; 00FE: 3E 04
        push    af                                   ; 0100: F5
        ld      ix,766ch                             ; 0101: DD 21 6C 76
        pop     af                                   ; 0105: F1
        dec     a                                    ; 0106: 3D
        jp      m,0156h                              ; 0107: FA 56 01
        push    af                                   ; 010A: F5
        ld      de,002ah                             ; 010B: 11 2A 00
        push    ix                                   ; 010E: DD E5
        pop     hl                                   ; 0110: E1
        xor     a                                    ; 0111: AF
        sbc     hl,de                                ; 0112: ED 52
        push    hl                                   ; 0114: E5
        pop     ix                                   ; 0115: DD E1
        pop     af                                   ; 0117: F1
        push    af                                   ; 0118: F5
        ld      (ix+02h),a                           ; 0119: DD 77 02
        ld      a,44h                                ; 011C: 3E 44
        ld      (ix+01h),a                           ; 011E: DD 77 01
        call    03c5h                                ; 0121: CD C5 03
        ld      a,c                                  ; 0124: 79
        cp      00h                                  ; 0125: FE 00
        jr      nz,013bh                             ; 0127: 20 12
        ld      a,52h                                ; 0129: 3E 52
        ld      (ix+01h),a                           ; 012B: DD 77 01
        call    070eh                                ; 012E: CD 0E 07
        ld      a,c                                  ; 0131: 79
        cp      00h                                  ; 0132: FE 00
        jr      z,0105h                              ; 0134: 28 CF
        call    11e5h                                ; 0136: CD E5 11
        jr      0105h                                ; 0139: 18 CA
        xor     a                                    ; 013B: AF
        ld      (ix+22h),a                           ; 013C: DD 77 22
        ld      (ix+23h),a                           ; 013F: DD 77 23
        ld      (ix+24h),a                           ; 0142: DD 77 24
        ld      (ix+25h),a                           ; 0145: DD 77 25
        ld      (ix+26h),a                           ; 0148: DD 77 26
        ld      (ix+27h),a                           ; 014B: DD 77 27
        ld      (ix+28h),a                           ; 014E: DD 77 28
        ld      (ix+29h),a                           ; 0151: DD 77 29
        jr      0105h                                ; 0154: 18 AF
        ld      a,01h                                ; 0156: 3E 01
        ld      (75c0h),a                            ; 0158: 32 C0 75
        xor     a                                    ; 015B: AF
        ld      (733bh),a                            ; 015C: 32 3B 73
        ret                                          ; 015F: C9
service_pending_event:
        ld      ix,(75c2h)                           ; 0160: DD 2A C2 75
        ld      de,002ah                             ; 0164: 11 2A 00
        add     ix,de                                ; 0167: DD 19
        ld      (75c2h),ix                           ; 0169: DD 22 C2 75
        ld      a,(ix+00h)                           ; 016D: DD 7E 00
        xor     0ffh                                 ; 0170: EE FF
        jr      nz,017ch                             ; 0172: 20 08
        ld      ix,75c4h                             ; 0174: DD 21 C4 75
        ld      (75c2h),ix                           ; 0178: DD 22 C2 75
        ld      a,(ix+00h)                           ; 017C: DD 7E 00
        cp      00h                                  ; 017F: FE 00
        ret     z                                    ; 0181: C8
        ld      a,0ffh                               ; 0182: 3E FF
        ld      (733eh),a                            ; 0184: 32 3E 73
        ld      a,(ix+00h)                           ; 0187: DD 7E 00
        cp      05h                                  ; 018A: FE 05
        jp      nc,019ch                             ; 018C: D2 9C 01
        ld      hl,088dh                             ; 018F: 21 8D 08
        rlca                                         ; 0192: 07
        ld      c,a                                  ; 0193: 4F
        ld      b,00h                                ; 0194: 06 00
        add     hl,bc                                ; 0196: 09
        ld      a,(hl)                               ; 0197: 7E
        inc     hl                                   ; 0198: 23
        ld      h,(hl)                               ; 0199: 66
        ld      l,a                                  ; 019A: 6F
        jp      (hl)                                 ; 019B: E9
invalid_state_fallback:
        ld      b,08h                                ; 019C: 06 08
        ld      c,00h                                ; 019E: 0E 00
        jp      03f8h                                ; 01A0: C3 F8 03
        ret                                          ; 01A3: C9
dispatch_device_state:
        ld      a,(ix+12h)                           ; 01A4: DD 7E 12
        ld      (ix+13h),a                           ; 01A7: DD 77 13
        ld      hl,0895h                             ; 01AA: 21 95 08
        ld      a,(ix+01h)                           ; 01AD: DD 7E 01
        and     1fh                                  ; 01B0: E6 1F
        cp      18h                                  ; 01B2: FE 18
        jp      nc,019ch                             ; 01B4: D2 9C 01
        rlca                                         ; 01B7: 07
        ld      c,a                                  ; 01B8: 4F
        ld      b,00h                                ; 01B9: 06 00
        add     hl,bc                                ; 01BB: 09
        ld      a,(hl)                               ; 01BC: 7E
        inc     hl                                   ; 01BD: 23
        ld      h,(hl)                               ; 01BE: 66
        ld      l,a                                  ; 01BF: 6F
        jp      (hl)                                 ; 01C0: E9
        ld      a,(ix+14h)                           ; 01C1: DD 7E 14
        dec     a                                    ; 01C4: 3D
        ld      (ix+14h),a                           ; 01C5: DD 77 14
        jp      nz,01aah                             ; 01C8: C2 AA 01
        ld      (ix+14h),06h                         ; 01CB: DD 36 14 06
        ld      a,(ix+13h)                           ; 01CF: DD 7E 13
        call    06f3h                                ; 01D2: CD F3 06
        ld      (ix+13h),a                           ; 01D5: DD 77 13
        cp      (ix+12h)                             ; 01D8: DD BE 12
        jp      z,02c6h                              ; 01DB: CA C6 02
        jp      01aah                                ; 01DE: C3 AA 01
        jp      01aah                                ; 01E1: C3 AA 01
        ld      a,(ix+02h)                           ; 01E4: DD 7E 02
        call    08ddh                                ; 01E7: CD DD 08
        jp      nc,049fh                             ; 01EA: D2 9F 04
        jr      z,01f7h                              ; 01ED: 28 08
        cp      01h                                  ; 01EF: FE 01
        jp      z,04a4h                              ; 01F1: CA A4 04
        jp      04aeh                                ; 01F4: C3 AE 04
        call    10b4h                                ; 01F7: CD B4 10
        xor     a                                    ; 01FA: AF
        or      b                                    ; 01FB: B0
        jp      z,073eh                              ; 01FC: CA 3E 07
        ld      c,03h                                ; 01FF: 0E 03
        ld      b,01h                                ; 0201: 06 01
        jp      03f8h                                ; 0203: C3 F8 03
        jp      019ch                                ; 0206: C3 9C 01
        jp      019ch                                ; 0209: C3 9C 01
        ld      a,(ix+09h)                           ; 020C: DD 7E 09
        or      (ix+0ah)                             ; 020F: DD B6 0A
        jp      z,03e1h                              ; 0212: CA E1 03
        call    0ef7h                                ; 0215: CD F7 0E
        jp      nc,019ch                             ; 0218: D2 9C 01
        ld      a,00h                                ; 021B: 3E 00
        ld      (420fh),a                            ; 021D: 32 0F 42
        ld      a,(ix+0dh)                           ; 0220: DD 7E 0D
        out     (30h),a                              ; 0223: D3 30
        call    0f2ah                                ; 0225: CD 2A 0F
        call    0542h                                ; 0228: CD 42 05
        jp      nc,049fh                             ; 022B: D2 9F 04
        ld      e,(ix+0bh)                           ; 022E: DD 5E 0B
        ld      d,(ix+0ch)                           ; 0231: DD 56 0C
        ld      c,(ix+18h)                           ; 0234: DD 4E 18
        ld      b,(ix+19h)                           ; 0237: DD 46 19
        xor     a                                    ; 023A: AF
        rr      d                                    ; 023B: CB 1A
        rr      e                                    ; 023D: CB 1B
        exx                                          ; 023F: D9
        call    12eah                                ; 0240: CD EA 12
        ld      a,(4204h)                            ; 0243: 3A 04 42
        call    1273h                                ; 0246: CD 73 12
        jp      nc,049fh                             ; 0249: D2 9F 04
        jr      z,0259h                              ; 024C: 28 0B
        or      a                                    ; 024E: B7
        jp      z,04a4h                              ; 024F: CA A4 04
        inc     a                                    ; 0252: 3C
        jp      z,04aeh                              ; 0253: CA AE 04
        jp      04bbh                                ; 0256: C3 BB 04
        ld      hl,2120h                             ; 0259: 21 20 21
        ld      c,(ix+18h)                           ; 025C: DD 4E 18
        ld      b,(ix+19h)                           ; 025F: DD 46 19
        call    0e90h                                ; 0262: CD 90 0E
        push    bc                                   ; 0265: C5
        call    1324h                                ; 0266: CD 24 13
        pop     bc                                   ; 0269: C1
        jp      nc,049fh                             ; 026A: D2 9F 04
        jp      nz,04a4h                             ; 026D: C2 A4 04
        ld      a,(420fh)                            ; 0270: 3A 0F 42
        or      a                                    ; 0273: B7
        jp      nz,029eh                             ; 0274: C2 9E 02
        ld      a,b                                  ; 0277: 78
        ld      iy,4240h                             ; 0278: FD 21 40 42
        call    10d4h                                ; 027C: CD D4 10
        jp      nc,04bbh                             ; 027F: D2 BB 04
        exx                                          ; 0282: D9
        ld      hl,2124h                             ; 0283: 21 24 21
        call    139bh                                ; 0286: CD 9B 13
        jp      nc,049fh                             ; 0289: D2 9F 04
        call    0fcbh                                ; 028C: CD CB 0F
        jp      nc,019ch                             ; 028F: D2 9C 01
        jp      nz,020ch                             ; 0292: C2 0C 02
        ld      a,(ix+02h)                           ; 0295: DD 7E 02
        ld      (733eh),a                            ; 0298: 32 3E 73
        jp      03e1h                                ; 029B: C3 E1 03
        ld      a,(ix+01h)                           ; 029E: DD 7E 01
        and     40h                                  ; 02A1: E6 40
        jp      nz,02c6h                             ; 02A3: C2 C6 02
        ld      a,(ix+00h)                           ; 02A6: DD 7E 00
        cp      02h                                  ; 02A9: FE 02
        jr      nz,02b3h                             ; 02AB: 20 06
        ld      a,20h                                ; 02AD: 3E 20
        ld      (ix+17h),a                           ; 02AF: DD 77 17
        ret                                          ; 02B2: C9
        ld      a,(733dh)                            ; 02B3: 3A 3D 73
        or      80h                                  ; 02B6: F6 80
        ld      (733dh),a                            ; 02B8: 32 3D 73
        ld      a,02h                                ; 02BB: 3E 02
        ld      (ix+00h),a                           ; 02BD: DD 77 00
        ld      a,06h                                ; 02C0: 3E 06
        ld      (ix+14h),a                           ; 02C2: DD 77 14
        ret                                          ; 02C5: C9
complete_device_state:
        ld      b,01h                                ; 02C6: 06 01
        ld      c,20h                                ; 02C8: 0E 20
        jp      03f8h                                ; 02CA: C3 F8 03
        ld      a,(4201h)                            ; 02CD: 3A 01 42
        call    12fah                                ; 02D0: CD FA 12
        exx                                          ; 02D3: D9
        ld      hl,2124h                             ; 02D4: 21 24 21
        call    13f5h                                ; 02D7: CD F5 13
        jr      0325h                                ; 02DA: 18 49
        ld      a,(ix+09h)                           ; 02DC: DD 7E 09
        or      (ix+0ah)                             ; 02DF: DD B6 0A
        jp      z,03e1h                              ; 02E2: CA E1 03
        call    0ef7h                                ; 02E5: CD F7 0E
        jp      nc,019ch                             ; 02E8: D2 9C 01
        ld      a,(ix+11h)                           ; 02EB: DD 7E 11
        cp      03h                                  ; 02EE: FE 03
        jp      nz,02fah                             ; 02F0: C2 FA 02
        ld      b,01h                                ; 02F3: 06 01
        ld      c,04h                                ; 02F5: 0E 04
        jp      03f8h                                ; 02F7: C3 F8 03
        call    0f2ah                                ; 02FA: CD 2A 0F
        call    0542h                                ; 02FD: CD 42 05
        jp      nc,049fh                             ; 0300: D2 9F 04
        ld      a,(ix+0dh)                           ; 0303: DD 7E 0D
        out     (30h),a                              ; 0306: D3 30
        ld      hl,2124h                             ; 0308: 21 24 21
        ld      e,(ix+0bh)                           ; 030B: DD 5E 0B
        ld      d,(ix+0ch)                           ; 030E: DD 56 0C
        xor     a                                    ; 0311: AF
        rr      d                                    ; 0312: CB 1A
        rr      e                                    ; 0314: CB 1B
        ld      c,(ix+18h)                           ; 0316: DD 4E 18
        ld      b,(ix+19h)                           ; 0319: DD 46 19
        call    13f5h                                ; 031C: CD F5 13
        ld      a,(4201h)                            ; 031F: 3A 01 42
        call    12fah                                ; 0322: CD FA 12
        ld      iy,4240h                             ; 0325: FD 21 40 42
        ld      b,(ix+19h)                           ; 0329: DD 46 19
        ld      c,(ix+18h)                           ; 032C: DD 4E 18
        xor     a                                    ; 032F: AF
        or      c                                    ; 0330: B1
        jr      z,0334h                              ; 0331: 28 01
        inc     b                                    ; 0333: 04
        ld      a,b                                  ; 0334: 78
        call    0e2fh                                ; 0335: CD 2F 0E
        ld      a,(4204h)                            ; 0338: 3A 04 42
        call    1273h                                ; 033B: CD 73 12
        jp      nc,049fh                             ; 033E: D2 9F 04
        jr      z,034eh                              ; 0341: 28 0B
        or      a                                    ; 0343: B7
        jp      z,04a4h                              ; 0344: CA A4 04
        inc     a                                    ; 0347: 3C
        jp      z,04aeh                              ; 0348: CA AE 04
        jp      04bbh                                ; 034B: C3 BB 04
        ld      hl,2120h                             ; 034E: 21 20 21
        ld      c,(ix+18h)                           ; 0351: DD 4E 18
        ld      b,(ix+19h)                           ; 0354: DD 46 19
        call    0e90h                                ; 0357: CD 90 0E
        call    130bh                                ; 035A: CD 0B 13
        jp      nc,049fh                             ; 035D: D2 9F 04
        jp      nz,04a4h                             ; 0360: C2 A4 04
        call    0fcbh                                ; 0363: CD CB 0F
        jp      nc,019ch                             ; 0366: D2 9C 01
        jp      nz,02dch                             ; 0369: C2 DC 02
        ld      a,(ix+02h)                           ; 036C: DD 7E 02
        ld      (733eh),a                            ; 036F: 32 3E 73
        jp      03e1h                                ; 0372: C3 E1 03
        ld      a,(ix+0dh)                           ; 0375: DD 7E 0D
        out     (30h),a                              ; 0378: D3 30
        ld      a,00h                                ; 037A: 3E 00
        ld      (ix+1ch),a                           ; 037C: DD 77 1C
        ld      (ix+1dh),a                           ; 037F: DD 77 1D
        ld      (ix+1eh),a                           ; 0382: DD 77 1E
        ld      (ix+1fh),a                           ; 0385: DD 77 1F
        ld      a,(ix+02h)                           ; 0388: DD 7E 02
        call    11aah                                ; 038B: CD AA 11
        jr      nc,0395h                             ; 038E: 30 05
        call    1336h                                ; 0390: CD 36 13
        jr      c,039dh                              ; 0393: 38 08
        ld      b,10h                                ; 0395: 06 10
        jr      039fh                                ; 0397: 18 06
        ld      b,40h                                ; 0399: 06 40
        jr      039fh                                ; 039B: 18 02
        ld      b,00h                                ; 039D: 06 00
        ld      a,b                                  ; 039F: 78
        or      (ix+20h)                             ; 03A0: DD B6 20
        ld      (ix+20h),a                           ; 03A3: DD 77 20
        push    ix                                   ; 03A6: DD E5
        pop     hl                                   ; 03A8: E1
        ld      de,001ch                             ; 03A9: 11 1C 00
        add     hl,de                                ; 03AC: 19
        rr      h                                    ; 03AD: CB 1C
        rr      l                                    ; 03AF: CB 1D
        ld      e,(ix+0bh)                           ; 03B1: DD 5E 0B
        ld      d,(ix+0ch)                           ; 03B4: DD 56 0C
        xor     a                                    ; 03B7: AF
        rr      d                                    ; 03B8: CB 1A
        rr      e                                    ; 03BA: CB 1B
        ld      bc,0003h                             ; 03BC: 01 03 00
        call    139bh                                ; 03BF: CD 9B 13
        jp      03e1h                                ; 03C2: C3 E1 03
initialize_device_record:
        call    10b4h                                ; 03C5: CD B4 10
        xor     a                                    ; 03C8: AF
        ld      (ix+15h),a                           ; 03C9: DD 77 15
        ld      (ix+16h),a                           ; 03CC: DD 77 16
        ld      a,(ix+02h)                           ; 03CF: DD 7E 02
        call    11aah                                ; 03D2: CD AA 11
        jp      nc,049fh                             ; 03D5: D2 9F 04
        call    11d5h                                ; 03D8: CD D5 11
        call    1227h                                ; 03DB: CD 27 12
        jp      03e1h                                ; 03DE: C3 E1 03
finish_device_event:
        ld      a,(ix+00h)                           ; 03E1: DD 7E 00
        cp      03h                                  ; 03E4: FE 03
        jr      z,03ech                              ; 03E6: 28 04
        cp      02h                                  ; 03E8: FE 02
        jr      nz,03f4h                             ; 03EA: 20 08
        ld      b,04h                                ; 03EC: 06 04
        ld      c,(ix+17h)                           ; 03EE: DD 4E 17
        jp      03f8h                                ; 03F1: C3 F8 03
        ld      b,00h                                ; 03F4: 06 00
        ld      c,00h                                ; 03F6: 0E 00
clear_device_event:
        ld      a,00h                                ; 03F8: 3E 00
        ld      (ix+00h),a                           ; 03FA: DD 77 00
        ld      d,(ix+02h)                           ; 03FD: DD 56 02
        ld      e,d                                  ; 0400: 5A
        inc     d                                    ; 0401: 14
        ld      a,01h                                ; 0402: 3E 01
        dec     d                                    ; 0404: 15
        jr      z,040ah                              ; 0405: 28 03
        add     a,a                                  ; 0407: 87
        jr      0404h                                ; 0408: 18 FA
        cpl                                          ; 040A: 2F
        ld      d,a                                  ; 040B: 57
        ld      a,(733dh)                            ; 040C: 3A 3D 73
        and     d                                    ; 040F: A2
        and     0fh                                  ; 0410: E6 0F
        ld      (733dh),a                            ; 0412: 32 3D 73
        ld      a,(733bh)                            ; 0415: 3A 3B 73
        or      a                                    ; 0418: B7
        ret     nz                                   ; 0419: C0
        call    047bh                                ; 041A: CD 7B 04
        jr      z,0426h                              ; 041D: 28 07
        ld      (ix+20h),c                           ; 041F: DD 71 20
        xor     a                                    ; 0422: AF
        ld      (ix+21h),a                           ; 0423: DD 77 21
        ld      a,(ix+01h)                           ; 0426: DD 7E 01
        and     20h                                  ; 0429: E6 20
        jr      z,0460h                              ; 042B: 28 33
transfer_port_data:
        in      a,(21h)                              ; 042D: DB 21
        and     20h                                  ; 042F: E6 20
        jr      nz,042dh                             ; 0431: 20 FA
        ld      a,e                                  ; 0433: 7B
        add     a,a                                  ; 0434: 87
        add     a,a                                  ; 0435: 87
        add     a,a                                  ; 0436: 87
        add     a,a                                  ; 0437: 87
        or      b                                    ; 0438: B0
        ld      b,a                                  ; 0439: 47
        out     (41h),a                              ; 043A: D3 41
        in      a,(21h)                              ; 043C: DB 21
        and     20h                                  ; 043E: E6 20
        jr      nz,0460h                             ; 0440: 20 1E
        call    15ebh                                ; 0442: CD EB 15
        ld      a,b                                  ; 0445: 78
        out     (41h),a                              ; 0446: D3 41
        in      a,(21h)                              ; 0448: DB 21
        and     20h                                  ; 044A: E6 20
        jr      nz,045dh                             ; 044C: 20 0F
        ld      a,(420dh)                            ; 044E: 3A 0D 42
        or      a                                    ; 0451: B7
        jr      z,0445h                              ; 0452: 28 F1
        ld      a,10h                                ; 0454: 3E 10
        or      (ix+20h)                             ; 0456: DD B6 20
        ld      c,a                                  ; 0459: 4F
        ld      (ix+20h),a                           ; 045A: DD 77 20
        call    15fch                                ; 045D: CD FC 15
        xor     a                                    ; 0460: AF
        or      c                                    ; 0461: B1
        jr      z,0466h                              ; 0462: 28 02
        ld      a,04h                                ; 0464: 3E 04
        or      98h                                  ; 0466: F6 98
        ld      c,a                                  ; 0468: 4F
        ld      a,b                                  ; 0469: 78
        and     0fh                                  ; 046A: E6 0F
        cp      08h                                  ; 046C: FE 08
        ld      a,c                                  ; 046E: 79
        jr      z,0476h                              ; 046F: 28 05
        or      01h                                  ; 0471: F6 01
        out     (70h),a                              ; 0473: D3 70
        ret                                          ; 0475: C9
        or      02h                                  ; 0476: F6 02
        out     (70h),a                              ; 0478: D3 70
        ret                                          ; 047A: C9
query_channel_state:
        ld      a,c                                  ; 047B: 79
        cp      09h                                  ; 047C: FE 09
        jr      z,048eh                              ; 047E: 28 0E
        cp      21h                                  ; 0480: FE 21
        jr      z,0495h                              ; 0482: 28 11
        cp      03h                                  ; 0484: FE 03
        ret     nz                                   ; 0486: C0
        ld      a,01h                                ; 0487: 3E 01
        ld      (ix+21h),a                           ; 0489: DD 77 21
        jr      049ah                                ; 048C: 18 0C
        ld      a,04h                                ; 048E: 3E 04
        ld      (ix+21h),a                           ; 0490: DD 77 21
        jr      049ah                                ; 0493: 18 05
        ld      a,02h                                ; 0495: 3E 02
        ld      (ix+21h),a                           ; 0497: DD 77 21
        xor     a                                    ; 049A: AF
        ld      (ix+20h),a                           ; 049B: DD 77 20
        ret                                          ; 049E: C9
status_error_nc:
        ld      c,10h                                ; 049F: 0E 10
        jp      04e5h                                ; 04A1: C3 E5 04
status_error_z:
        ld      c,80h                                ; 04A4: 0E 80
        jp      04e5h                                ; 04A6: C3 E5 04
        ld      c,40h                                ; 04A9: 0E 40
        jp      04e5h                                ; 04AB: C3 E5 04
status_error_minus:
        ld      a,(ix+00h)                           ; 04AE: DD 7E 00
        cp      02h                                  ; 04B1: FE 02
        jp      z,029eh                              ; 04B3: CA 9E 02
        ld      c,08h                                ; 04B6: 0E 08
        jp      04e5h                                ; 04B8: C3 E5 04
status_error_overflow:
        ld      a,(ix+02h)                           ; 04BB: DD 7E 02
        call    11aah                                ; 04BE: CD AA 11
        jp      nc,049fh                             ; 04C1: D2 9F 04
        call    09e8h                                ; 04C4: CD E8 09
        jp      nc,049fh                             ; 04C7: D2 9F 04
        jr      nz,04d4h                             ; 04CA: 20 08
        call    0a3bh                                ; 04CC: CD 3B 0A
        ld      c,09h                                ; 04CF: 0E 09
        jp      04e5h                                ; 04D1: C3 E5 04
        cp      01h                                  ; 04D4: FE 01
        jp      z,04a4h                              ; 04D6: CA A4 04
        cp      02h                                  ; 04D9: FE 02
        jp      z,04aeh                              ; 04DB: CA AE 04
        ld      b,01h                                ; 04DE: 06 01
        ld      c,09h                                ; 04E0: 0E 09
        jp      03f8h                                ; 04E2: C3 F8 03
        ld      b,01h                                ; 04E5: 06 01
        ld      (ix+17h),c                           ; 04E7: DD 71 17
        ld      a,(ix+01h)                           ; 04EA: DD 7E 01
        and     40h                                  ; 04ED: E6 40
        jp      nz,03f8h                             ; 04EF: C2 F8 03
        ld      a,(ix+00h)                           ; 04F2: DD 7E 00
        cp      03h                                  ; 04F5: FE 03
        jp      z,03f8h                              ; 04F7: CA F8 03
        ld      (ix+1ah),a                           ; 04FA: DD 77 1A
        ld      a,03h                                ; 04FD: 3E 03
        ld      (ix+00h),a                           ; 04FF: DD 77 00
        ld      a,(ix+02h)                           ; 0502: DD 7E 02
        call    11aah                                ; 0505: CD AA 11
        jp      nc,049fh                             ; 0508: D2 9F 04
        call    11d5h                                ; 050B: CD D5 11
        call    1227h                                ; 050E: CD 27 12
        xor     a                                    ; 0511: AF
        ld      (ix+15h),a                           ; 0512: DD 77 15
        ld      (ix+16h),a                           ; 0515: DD 77 16
        ld      a,(733dh)                            ; 0518: 3A 3D 73
        or      80h                                  ; 051B: F6 80
        ld      (733dh),a                            ; 051D: 32 3D 73
        ld      a,(ix+1ah)                           ; 0520: DD 7E 1A
        cp      02h                                  ; 0523: FE 02
        ret     nz                                   ; 0525: C0
        ld      (ix+00h),a                           ; 0526: DD 77 00
        ret                                          ; 0529: C9
        call    0f05h                                ; 052A: CD 05 0F
        jp      nc,019ch                             ; 052D: D2 9C 01
        ld      a,(ix+02h)                           ; 0530: DD 7E 02
        call    11aah                                ; 0533: CD AA 11
        jp      nc,049fh                             ; 0536: D2 9F 04
        call    0552h                                ; 0539: CD 52 05
        jp      nc,049fh                             ; 053C: D2 9F 04
        jp      03e1h                                ; 053F: C3 E1 03
transfer_controller_data:
        ld      a,(ix+02h)                           ; 0542: DD 7E 02
        call    11aah                                ; 0545: CD AA 11
        ret     nc                                   ; 0548: D0
        ld      a,(ix+01h)                           ; 0549: DD 7E 01
        and     80h                                  ; 054C: E6 80
        xor     80h                                  ; 054E: EE 80
        scf                                          ; 0550: 37
        ret     z                                    ; 0551: C8
        ld      l,(ix+04h)                           ; 0552: DD 6E 04
        ld      h,(ix+05h)                           ; 0555: DD 66 05
        ld      (75b1h),hl                           ; 0558: 22 B1 75
        ld      (4202h),hl                           ; 055B: 22 02 42
        ld      a,(ix+03h)                           ; 055E: DD 7E 03
        ld      (75b3h),a                            ; 0561: 32 B3 75
        ld      (4201h),a                            ; 0564: 32 01 42
        ld      a,(ix+06h)                           ; 0567: DD 7E 06
        ld      (75b4h),a                            ; 056A: 32 B4 75
        ld      (4204h),a                            ; 056D: 32 04 42
        call    104fh                                ; 0570: CD 4F 10
        ld      hl,(4202h)                           ; 0573: 2A 02 42
        ex      de,hl                                ; 0576: EB
        ld      h,(ix+15h)                           ; 0577: DD 66 15
        ld      l,(ix+16h)                           ; 057A: DD 6E 16
        xor     a                                    ; 057D: AF
        sbc     hl,de                                ; 057E: ED 52
        jr      nc,058fh                             ; 0580: 30 0D
        push    de                                   ; 0582: D5
        ex      de,hl                                ; 0583: EB
        ld      d,(ix+15h)                           ; 0584: DD 56 15
        ld      e,(ix+16h)                           ; 0587: DD 5E 16
        xor     a                                    ; 058A: AF
        inc     a                                    ; 058B: 3C
        sbc     hl,de                                ; 058C: ED 52
        pop     de                                   ; 058E: D1
        ld      b,a                                  ; 058F: 47
        ld      a,h                                  ; 0590: 7C
        or      l                                    ; 0591: B5
        ld      a,b                                  ; 0592: 78
        jr      z,059fh                              ; 0593: 28 0A
        ld      (ix+15h),d                           ; 0595: DD 72 15
        ld      (ix+16h),e                           ; 0598: DD 73 16
        call    1242h                                ; 059B: CD 42 12
        ret     nc                                   ; 059E: D0
        xor     a                                    ; 059F: AF
        scf                                          ; 05A0: 37
        ret                                          ; 05A1: C9
        ld      a,(ix+03h)                           ; 05A2: DD 7E 03
        ld      (ix+12h),a                           ; 05A5: DD 77 12
        jp      03e1h                                ; 05A8: C3 E1 03
        jp      019ch                                ; 05AB: C3 9C 01
        jp      019ch                                ; 05AE: C3 9C 01
        jp      019ch                                ; 05B1: C3 9C 01
        call    0ef7h                                ; 05B4: CD F7 0E
        jp      nc,019ch                             ; 05B7: D2 9C 01
        ld      a,00h                                ; 05BA: 3E 00
        ld      (420fh),a                            ; 05BC: 32 0F 42
        call    0542h                                ; 05BF: CD 42 05
        jp      nc,049fh                             ; 05C2: D2 9F 04
        ld      a,(ix+0dh)                           ; 05C5: DD 7E 0D
        out     (30h),a                              ; 05C8: D3 30
        call    11b3h                                ; 05CA: CD B3 11
        jp      nc,049fh                             ; 05CD: D2 9F 04
        call    12eah                                ; 05D0: CD EA 12
        ld      a,(4204h)                            ; 05D3: 3A 04 42
        call    15ach                                ; 05D6: CD AC 15
        jp      nz,04aeh                             ; 05D9: C2 AE 04
        ld      hl,2120h                             ; 05DC: 21 20 21
        ld      bc,0105h                             ; 05DF: 01 05 01
        call    1324h                                ; 05E2: CD 24 13
        jp      nc,049fh                             ; 05E5: D2 9F 04
        jp      nz,04a4h                             ; 05E8: C2 A4 04
        ld      hl,4440h                             ; 05EB: 21 40 44
        ld      de,444ah                             ; 05EE: 11 4A 44
        ld      bc,000ah                             ; 05F1: 01 0A 00
        ldir                                         ; 05F4: ED B0
        ld      hl,2120h                             ; 05F6: 21 20 21
        ld      e,(ix+0bh)                           ; 05F9: DD 5E 0B
        ld      d,(ix+0ch)                           ; 05FC: DD 56 0C
        ld      bc,0105h                             ; 05FF: 01 05 01
        xor     a                                    ; 0602: AF
        rr      d                                    ; 0603: CB 1A
        rr      e                                    ; 0605: CB 1B
        call    139bh                                ; 0607: CD 9B 13
        jp      nc,049fh                             ; 060A: D2 9F 04
        jp      03e1h                                ; 060D: C3 E1 03
        ld      a,(ix+06h)                           ; 0610: DD 7E 06
        ld      (420ah),a                            ; 0613: 32 0A 42
        and     1fh                                  ; 0616: E6 1F
        ld      (ix+06h),a                           ; 0618: DD 77 06
        ld      (4204h),a                            ; 061B: 32 04 42
        call    0ef7h                                ; 061E: CD F7 0E
        jp      nc,019ch                             ; 0621: D2 9C 01
        xor     a                                    ; 0624: AF
        ld      (75b5h),a                            ; 0625: 32 B5 75
        ld      h,(ix+05h)                           ; 0628: DD 66 05
        ld      l,(ix+04h)                           ; 062B: DD 6E 04
        ld      (4202h),hl                           ; 062E: 22 02 42
        call    0576h                                ; 0631: CD 76 05
        jp      nc,049fh                             ; 0634: D2 9F 04
        call    11b3h                                ; 0637: CD B3 11
        jp      nc,049fh                             ; 063A: D2 9F 04
        ld      a,(ix+03h)                           ; 063D: DD 7E 03
        ld      (4201h),a                            ; 0640: 32 01 42
        call    12fah                                ; 0643: CD FA 12
        ld      a,(4204h)                            ; 0646: 3A 04 42
        call    15ach                                ; 0649: CD AC 15
        jp      nz,04aeh                             ; 064C: C2 AE 04
        ld      hl,2120h                             ; 064F: 21 20 21
        ld      bc,0105h                             ; 0652: 01 05 01
        call    1324h                                ; 0655: CD 24 13
        jp      nc,049fh                             ; 0658: D2 9F 04
        jp      nz,04a4h                             ; 065B: C2 A4 04
        ld      a,(420ah)                            ; 065E: 3A 0A 42
        bit     7,a                                  ; 0661: CB 7F
        jr      z,066ah                              ; 0663: 28 05
        ld      a,0ffh                               ; 0665: 3E FF
        ld      (75b5h),a                            ; 0667: 32 B5 75
        ld      iy,4240h                             ; 066A: FD 21 40 42
        ld      a,01h                                ; 066E: 3E 01
        call    0e2fh                                ; 0670: CD 2F 0E
        xor     a                                    ; 0673: AF
        ld      (75b5h),a                            ; 0674: 32 B5 75
        ld      a,(4204h)                            ; 0677: 3A 04 42
        call    15ach                                ; 067A: CD AC 15
        jp      nz,04aeh                             ; 067D: C2 AE 04
        ld      hl,2120h                             ; 0680: 21 20 21
        ld      bc,0105h                             ; 0683: 01 05 01
        call    130bh                                ; 0686: CD 0B 13
        jp      nc,049fh                             ; 0689: D2 9F 04
        jp      nz,04a4h                             ; 068C: C2 A4 04
        jp      03e1h                                ; 068F: C3 E1 03
        ld      a,(ix+06h)                           ; 0692: DD 7E 06
        out     (40h),a                              ; 0695: D3 40
        jp      03e1h                                ; 0697: C3 E1 03
        jp      019ch                                ; 069A: C3 9C 01
startup_dispatch:
        exx                                          ; 069D: D9
        di                                           ; 069E: F3
        ld      a,01h                                ; 069F: 3E 01
        ex      af,af'                               ; 06A1: 08
        ld      a,(08cbh)                            ; 06A2: 3A CB 08
        ld      hl,4000h                             ; 06A5: 21 00 40
        ld      (hl),a                               ; 06A8: 77
        ld      de,4001h                             ; 06A9: 11 01 40
        ld      bc,36afh                             ; 06AC: 01 AF 36
        ldir                                         ; 06AF: ED B0
        ld      hl,4000h                             ; 06B1: 21 00 40
        ld      bc,36b0h                             ; 06B4: 01 B0 36
        cp      (hl)                                 ; 06B7: BE
        jr      nz,06cch                             ; 06B8: 20 12
        inc     hl                                   ; 06BA: 23
        dec     bc                                   ; 06BB: 0B
        ld      e,a                                  ; 06BC: 5F
        ld      a,b                                  ; 06BD: 78
        or      c                                    ; 06BE: B1
        ld      a,e                                  ; 06BF: 7B
        jr      nz,06b7h                             ; 06C0: 20 F5
        ex      af,af'                               ; 06C2: 08
        dec     a                                    ; 06C3: 3D
        jr      nz,06d2h                             ; 06C4: 20 0C
        ex      af,af'                               ; 06C6: 08
        ld      a,(08ceh)                            ; 06C7: 3A CE 08
        jr      06a5h                                ; 06CA: 18 D9
        ld      a,0bh                                ; 06CC: 3E 0B
        out     (70h),a                              ; 06CE: D3 70
        jr      06cch                                ; 06D0: 18 FA
        ei                                           ; 06D2: FB
        exx                                          ; 06D3: D9
        jp      (hl)                                 ; 06D4: E9
        xor     a                                    ; 06D5: AF
        ld      (75c0h),a                            ; 06D6: 32 C0 75
        ld      h,(ix+15h)                           ; 06D9: DD 66 15
        ld      l,(ix+16h)                           ; 06DC: DD 6E 16
        ld      (ix+05h),h                           ; 06DF: DD 74 05
        ld      (ix+04h),l                           ; 06E2: DD 75 04
        jp      03e1h                                ; 06E5: C3 E1 03
        ld      a,01h                                ; 06E8: 3E 01
        ld      (75c0h),a                            ; 06EA: 32 C0 75
        call    10b4h                                ; 06ED: CD B4 10
        jp      03e1h                                ; 06F0: C3 E1 03
update_channel_value:
        ld      hl,0889h                             ; 06F3: 21 89 08
        ld      b,a                                  ; 06F6: 47
        ld      a,(hl)                               ; 06F7: 7E
        inc     hl                                   ; 06F8: 23
        cp      b                                    ; 06F9: B8
        jp      z,0705h                              ; 06FA: CA 05 07
        xor     0ffh                                 ; 06FD: EE FF
        jp      nz,06f7h                             ; 06FF: C2 F7 06
        scf                                          ; 0702: 37
        ccf                                          ; 0703: 3F
        ret                                          ; 0704: C9
        ld      a,(hl)                               ; 0705: 7E
        cp      0ffh                                 ; 0706: FE FF
        scf                                          ; 0708: 37
        ret     nz                                   ; 0709: C0
        ld      a,(0889h)                            ; 070A: 3A 89 08
        ret                                          ; 070D: C9
read_controller_state:
        ld      a,(ix+02h)                           ; 070E: DD 7E 02
        call    11aah                                ; 0711: CD AA 11
        jp      nc,049fh                             ; 0714: D2 9F 04
        call    09e8h                                ; 0717: CD E8 09
        jp      nc,049fh                             ; 071A: D2 9F 04
        jr      nz,072fh                             ; 071D: 20 10
        ld      a,(ix+02h)                           ; 071F: DD 7E 02
        call    0a3bh                                ; 0722: CD 3B 0A
        call    10b4h                                ; 0725: CD B4 10
        ld      c,00h                                ; 0728: 0E 00
        ld      b,00h                                ; 072A: 06 00
        jp      03f8h                                ; 072C: C3 F8 03
        cp      01h                                  ; 072F: FE 01
        jp      z,04a4h                              ; 0731: CA A4 04
        cp      02h                                  ; 0734: FE 02
        jp      z,04aeh                              ; 0736: CA AE 04
        ld      c,21h                                ; 0739: 0E 21
        jp      04e5h                                ; 073B: C3 E5 04
        ld      a,(ix+02h)                           ; 073E: DD 7E 02
        call    11aah                                ; 0741: CD AA 11
        jp      nc,049fh                             ; 0744: D2 9F 04
        call    11e5h                                ; 0747: CD E5 11
        call    0a64h                                ; 074A: CD 64 0A
        xor     a                                    ; 074D: AF
        ld      (75bfh),a                            ; 074E: 32 BF 75
        ld      hl,0000h                             ; 0751: 21 00 00
        ld      (75b1h),hl                           ; 0754: 22 B1 75
        inc     hl                                   ; 0757: 23
        ld      (4202h),hl                           ; 0758: 22 02 42
        ld      a,(ix+24h)                           ; 075B: DD 7E 24
        dec     a                                    ; 075E: 3D
        ld      (75b3h),a                            ; 075F: 32 B3 75
        ld      a,(ix+25h)                           ; 0762: DD 7E 25
        dec     a                                    ; 0765: 3D
        ld      (75b4h),a                            ; 0766: 32 B4 75
        ld      hl,(4202h)                           ; 0769: 2A 02 42
        ld      d,(ix+26h)                           ; 076C: DD 56 26
        ld      e,(ix+27h)                           ; 076F: DD 5E 27
        xor     a                                    ; 0772: AF
        sbc     hl,de                                ; 0773: ED 52
        jp      z,07d9h                              ; 0775: CA D9 07
        xor     a                                    ; 0778: AF
        ld      (4204h),a                            ; 0779: 32 04 42
        ld      (4201h),a                            ; 077C: 32 01 42
        ld      hl,(4202h)                           ; 077F: 2A 02 42
        call    0576h                                ; 0782: CD 76 05
        jp      nc,049fh                             ; 0785: D2 9F 04
        call    11b3h                                ; 0788: CD B3 11
        jp      nc,049fh                             ; 078B: D2 9F 04
        ld      a,(4201h)                            ; 078E: 3A 01 42
        call    12fah                                ; 0791: CD FA 12
        ld      a,(ix+25h)                           ; 0794: DD 7E 25
        ld      hl,0000h                             ; 0797: 21 00 00
        ld      bc,0105h                             ; 079A: 01 05 01
        add     hl,bc                                ; 079D: 09
        dec     a                                    ; 079E: 3D
        jr      nz,079dh                             ; 079F: 20 FC
        push    hl                                   ; 07A1: E5
        xor     a                                    ; 07A2: AF
        ld      (420fh),a                            ; 07A3: 32 0F 42
        ld      a,(4204h)                            ; 07A6: 3A 04 42
        call    15ach                                ; 07A9: CD AC 15
        pop     bc                                   ; 07AC: C1
        jp      nz,04aeh                             ; 07AD: C2 AE 04
        ld      hl,2120h                             ; 07B0: 21 20 21
        call    1324h                                ; 07B3: CD 24 13
        jp      nc,049fh                             ; 07B6: D2 9F 04
        jp      nz,04a4h                             ; 07B9: C2 A4 04
        call    1174h                                ; 07BC: CD 74 11
        ld      c,03h                                ; 07BF: 0E 03
        jp      nc,04e5h                             ; 07C1: D2 E5 04
        ld      a,(4201h)                            ; 07C4: 3A 01 42
        inc     a                                    ; 07C7: 3C
        ld      (4201h),a                            ; 07C8: 32 01 42
        cp      (ix+24h)                             ; 07CB: DD BE 24
        jr      nz,0791h                             ; 07CE: 20 C1
        ld      hl,(4202h)                           ; 07D0: 2A 02 42
        inc     hl                                   ; 07D3: 23
        ld      (4202h),hl                           ; 07D4: 22 02 42
        jr      076ch                                ; 07D7: 18 93
        ld      h,(ix+26h)                           ; 07D9: DD 66 26
        ld      l,(ix+27h)                           ; 07DC: DD 6E 27
        ld      (75b1h),hl                           ; 07DF: 22 B1 75
        xor     a                                    ; 07E2: AF
        ld      (75b3h),a                            ; 07E3: 32 B3 75
        dec     a                                    ; 07E6: 3D
        ld      (75b4h),a                            ; 07E7: 32 B4 75
        call    0a88h                                ; 07EA: CD 88 0A
        ld      a,(ix+02h)                           ; 07ED: DD 7E 02
        call    0966h                                ; 07F0: CD 66 09
        jp      nc,049fh                             ; 07F3: D2 9F 04
        jp      z,03e1h                              ; 07F6: CA E1 03
        cp      01h                                  ; 07F9: FE 01
        jp      z,04a4h                              ; 07FB: CA A4 04
        jp      04aeh                                ; 07FE: C3 AE 04
        ld      a,(ix+0dh)                           ; 0801: DD 7E 0D
        out     (30h),a                              ; 0804: D3 30
        ld      hl,4240h                             ; 0806: 21 40 42
        ld      a,(0003h)                            ; 0809: 3A 03 00
        ld      (hl),a                               ; 080C: 77
        inc     hl                                   ; 080D: 23
        ld      a,(0004h)                            ; 080E: 3A 04 00
        ld      (hl),a                               ; 0811: 77
        inc     hl                                   ; 0812: 23
        ld      de,0018h                             ; 0813: 11 18 00
        xor     a                                    ; 0816: AF
        rr      d                                    ; 0817: CB 1A
        rr      e                                    ; 0819: CB 1B
        ld      (hl),d                               ; 081B: 72
        inc     hl                                   ; 081C: 23
        ld      (hl),e                               ; 081D: 73
        ld      hl,2120h                             ; 081E: 21 20 21
        ld      e,(ix+0bh)                           ; 0821: DD 5E 0B
        ld      d,(ix+0ch)                           ; 0824: DD 56 0C
        xor     a                                    ; 0827: AF
        rr      d                                    ; 0828: CB 1A
        rr      e                                    ; 082A: CB 1B
        ld      bc,0002h                             ; 082C: 01 02 00
        call    139bh                                ; 082F: CD 9B 13
        jp      03e1h                                ; 0832: C3 E1 03
        ld      a,(ix+0dh)                           ; 0835: DD 7E 0D
        out     (30h),a                              ; 0838: D3 30
        push    ix                                   ; 083A: DD E5
        ld      ix,75c4h                             ; 083C: DD 21 C4 75
        ld      bc,002ah                             ; 0840: 01 2A 00
        ld      hl,4240h                             ; 0843: 21 40 42
        ld      a,04h                                ; 0846: 3E 04
        ld      e,(ix+22h)                           ; 0848: DD 5E 22
        ld      (hl),e                               ; 084B: 73
        inc     hl                                   ; 084C: 23
        ld      e,(ix+23h)                           ; 084D: DD 5E 23
        ld      (hl),e                               ; 0850: 73
        inc     hl                                   ; 0851: 23
        ld      e,(ix+24h)                           ; 0852: DD 5E 24
        ld      (hl),e                               ; 0855: 73
        inc     hl                                   ; 0856: 23
        ld      e,(ix+25h)                           ; 0857: DD 5E 25
        ld      (hl),e                               ; 085A: 73
        inc     hl                                   ; 085B: 23
        ld      e,(ix+26h)                           ; 085C: DD 5E 26
        ld      (hl),e                               ; 085F: 73
        inc     hl                                   ; 0860: 23
        ld      e,(ix+27h)                           ; 0861: DD 5E 27
        ld      (hl),e                               ; 0864: 73
        inc     hl                                   ; 0865: 23
        add     ix,bc                                ; 0866: DD 09
        dec     a                                    ; 0868: 3D
        jr      nz,0848h                             ; 0869: 20 DD
        pop     ix                                   ; 086B: DD E1
        ld      hl,2120h                             ; 086D: 21 20 21
        ld      e,(ix+0bh)                           ; 0870: DD 5E 0B
        ld      d,(ix+0ch)                           ; 0873: DD 56 0C
        xor     a                                    ; 0876: AF
        rr      d                                    ; 0877: CB 1A
        rr      e                                    ; 0879: CB 1B
        ld      bc,0018h                             ; 087B: 01 18 00
        xor     a                                    ; 087E: AF
        rr      b                                    ; 087F: CB 18
        rr      c                                    ; 0881: CB 19
        call    139bh                                ; 0883: CD 9B 13
        jp      03e1h                                ; 0886: C3 E1 03
        nop                                          ; 0889: 00
        jr      nz,08cch                             ; 088A: 20 40
        rst     38h                                  ; 088C: FF

; Computed dispatch tables (little-endian word targets). The state table has
; five entries; its entry #4 at 0895h is also the first opcode-table word.
state_dispatch_table:
        dw      01A3h, 01A4h, 01C1h, 01E1h ; 088D-0894: A3 01 A4 01 C1 01 E1 01
opcode_dispatch_table:
        dw      03E1h, 020Ch, 02DCh, 0375h, 03C5h, 01E4h ; 0895-08A0
        dw      052Ah, 05A2h, 05ABh, 05AEh, 05B1h, 05B4h ; 08A1-08AC
        dw      0692h, 069Ah, 069Dh, 06D5h, 0209h, 0206h ; 08AD-08B8
        dw      070Eh, 073Eh, 06E8h, 0801h, 0835h, 0610h ; 08B9-08C4

; Opaque constants/pattern bytes from 08C5h through 08DCh, preceding code at 08DDh.
; No control-flow entry into this region is evidenced; preserve its bytes as data.
unclassified_table_data_08c5:
        db      00h, 00h, 00h, 0FFh, 0FFh, 0FFh, 0AAh, 0AAh, 0AAh, 055h, 055h, 055h ; 08C5-08D0
        db      06Dh, 0B6h, 0DBh, 0B6h, 0DBh, 06Dh, 0DBh, 06Dh, 0B6h, 06Dh, 0B6h, 0DBh ; 08D1-08DC

device_action_handler:
        call    11aah                                ; 08DD: CD AA 11
        ret     nc                                   ; 08E0: D0
        call    11d5h                                ; 08E1: CD D5 11
        call    1227h                                ; 08E4: CD 27 12
        xor     a                                    ; 08E7: AF
        ld      (ix+15h),a                           ; 08E8: DD 77 15
        ld      (ix+16h),a                           ; 08EB: DD 77 16
        call    11e5h                                ; 08EE: CD E5 11
        call    0a64h                                ; 08F1: CD 64 0A
        xor     a                                    ; 08F4: AF
        ld      (4204h),a                            ; 08F5: 32 04 42
        ld      (4201h),a                            ; 08F8: 32 01 42
        ld      (75bfh),a                            ; 08FB: 32 BF 75
        ld      (75b5h),a                            ; 08FE: 32 B5 75
        ld      hl,0000h                             ; 0901: 21 00 00
        ld      (4202h),hl                           ; 0904: 22 02 42
        ld      d,(ix+26h)                           ; 0907: DD 56 26
        ld      e,(ix+27h)                           ; 090A: DD 5E 27
        xor     a                                    ; 090D: AF
        sbc     hl,de                                ; 090E: ED 52
        jr      z,095fh                              ; 0910: 28 4D
        ld      hl,(4202h)                           ; 0912: 2A 02 42
        call    0576h                                ; 0915: CD 76 05
        ret     nc                                   ; 0918: D0
        call    11b3h                                ; 0919: CD B3 11
        ret     nc                                   ; 091C: D0
        ld      iy,08c5h                             ; 091D: FD 21 C5 08
        ld      a,08h                                ; 0921: 3E 08
        ld      (420ah),a                            ; 0923: 32 0A 42
        ld      (75bbh),iy                           ; 0926: FD 22 BB 75
        call    0b20h                                ; 092A: CD 20 0B
        ret     nc                                   ; 092D: D0
        ret     nz                                   ; 092E: C0
        call    0bcdh                                ; 092F: CD CD 0B
        ret     nc                                   ; 0932: D0
        jr      nz,0951h                             ; 0933: 20 1C
        ld      iy,(75bbh)                           ; 0935: FD 2A BB 75
        ld      bc,0003h                             ; 0939: 01 03 00
        add     iy,bc                                ; 093C: FD 09
        ld      a,(420ah)                            ; 093E: 3A 0A 42
        dec     a                                    ; 0941: 3D
        ld      (420ah),a                            ; 0942: 32 0A 42
        jr      nz,0926h                             ; 0945: 20 DF
        ld      hl,(4202h)                           ; 0947: 2A 02 42
        inc     hl                                   ; 094A: 23
        ld      (4202h),hl                           ; 094B: 22 02 42
        jp      0907h                                ; 094E: C3 07 09
        cp      05h                                  ; 0951: FE 05
        jr      z,0957h                              ; 0953: 28 02
        scf                                          ; 0955: 37
        ret                                          ; 0956: C9
        call    0966h                                ; 0957: CD 66 09
        ld      b,01h                                ; 095A: 06 01
        xor     a                                    ; 095C: AF
        scf                                          ; 095D: 37
        ret                                          ; 095E: C9
        call    0b75h                                ; 095F: CD 75 0B
        ld      bc,0000h                             ; 0962: 01 00 00
        ret                                          ; 0965: C9
        xor     a                                    ; 0966: AF
        ld      (4204h),a                            ; 0967: 32 04 42
        ld      (4201h),a                            ; 096A: 32 01 42
        ld      hl,0000h                             ; 096D: 21 00 00
        ld      (4202h),hl                           ; 0970: 22 02 42
        ld      (75b1h),hl                           ; 0973: 22 B1 75
        call    0576h                                ; 0976: CD 76 05
        ret     nc                                   ; 0979: D0
        call    11b3h                                ; 097A: CD B3 11
        ret     nc                                   ; 097D: D0
        ld      iy,08c5h                             ; 097E: FD 21 C5 08
        ld      hl,4240h                             ; 0982: 21 40 42
        ld      a,01h                                ; 0985: 3E 01
        call    0de4h                                ; 0987: CD E4 0D
        ld      hl,734dh                             ; 098A: 21 4D 73
        ld      bc,0099h                             ; 098D: 01 99 00
        ld      a,(ix+02h)                           ; 0990: DD 7E 02
        inc     a                                    ; 0993: 3C
        dec     a                                    ; 0994: 3D
        jr      z,099ah                              ; 0995: 28 03
        add     hl,bc                                ; 0997: 09
        jr      0994h                                ; 0998: 18 FA
        ld      de,4248h                             ; 099A: 11 48 42
        ldir                                         ; 099D: ED B0
        ld      bc,0022h                             ; 099F: 01 22 00
        push    ix                                   ; 09A2: DD E5
        pop     hl                                   ; 09A4: E1
        add     hl,bc                                ; 09A5: 09
        ld      bc,0008h                             ; 09A6: 01 08 00
        ld      de,4440h                             ; 09A9: 11 40 44
        ldir                                         ; 09AC: ED B0
        xor     a                                    ; 09AE: AF
        jr      09c9h                                ; 09AF: 18 18
        ld      a,(4201h)                            ; 09B1: 3A 01 42
        inc     a                                    ; 09B4: 3C
        ld      (4201h),a                            ; 09B5: 32 01 42
        cp      (ix+24h)                             ; 09B8: DD BE 24
        jr      nc,09e5h                             ; 09BB: 30 28
        ld      iy,4240h                             ; 09BD: FD 21 40 42
        ld      a,01h                                ; 09C1: 3E 01
        call    0e2fh                                ; 09C3: CD 2F 0E
        ld      a,(4201h)                            ; 09C6: 3A 01 42
        call    12fah                                ; 09C9: CD FA 12
        ld      a,(4204h)                            ; 09CC: 3A 04 42
        call    15ach                                ; 09CF: CD AC 15
        ld      a,02h                                ; 09D2: 3E 02
        scf                                          ; 09D4: 37
        ret     nz                                   ; 09D5: C0
        ld      hl,2120h                             ; 09D6: 21 20 21
        ld      bc,0105h                             ; 09D9: 01 05 01
        call    130bh                                ; 09DC: CD 0B 13
        ret     nc                                   ; 09DF: D0
        ld      a,01h                                ; 09E0: 3E 01
        ret     nz                                   ; 09E2: C0
        jr      09b1h                                ; 09E3: 18 CC
        xor     a                                    ; 09E5: AF
        scf                                          ; 09E6: 37
        ret                                          ; 09E7: C9
        xor     a                                    ; 09E8: AF
        ld      (4201h),a                            ; 09E9: 32 01 42
        ld      (4204h),a                            ; 09EC: 32 04 42
        ld      hl,0000h                             ; 09EF: 21 00 00
        ld      (4202h),hl                           ; 09F2: 22 02 42
        ld      (75b1h),hl                           ; 09F5: 22 B1 75
        call    0576h                                ; 09F8: CD 76 05
        ret     nc                                   ; 09FB: D0
        call    11b3h                                ; 09FC: CD B3 11
        ret     nc                                   ; 09FF: D0
        xor     a                                    ; 0A00: AF
        jr      0a14h                                ; 0A01: 18 11
        ld      a,(4201h)                            ; 0A03: 3A 01 42
        inc     a                                    ; 0A06: 3C
        ld      (4201h),a                            ; 0A07: 32 01 42
        cp      (ix+24h)                             ; 0A0A: DD BE 24
        jr      c,0a14h                              ; 0A0D: 38 05
        ld      a,03h                                ; 0A0F: 3E 03
        or      a                                    ; 0A11: B7
        scf                                          ; 0A12: 37
        ret                                          ; 0A13: C9
        call    12fah                                ; 0A14: CD FA 12
        xor     a                                    ; 0A17: AF
        ld      (420fh),a                            ; 0A18: 32 0F 42
        ld      a,(4204h)                            ; 0A1B: 3A 04 42
        call    15ach                                ; 0A1E: CD AC 15
        ld      a,02h                                ; 0A21: 3E 02
        scf                                          ; 0A23: 37
        ret     nz                                   ; 0A24: C0
        ld      hl,2120h                             ; 0A25: 21 20 21
        ld      bc,0105h                             ; 0A28: 01 05 01
        call    1324h                                ; 0A2B: CD 24 13
        ret     nc                                   ; 0A2E: D0
        ld      a,01h                                ; 0A2F: 3E 01
        ret     nz                                   ; 0A31: C0
        ld      a,(420fh)                            ; 0A32: 3A 0F 42
        or      a                                    ; 0A35: B7
        jr      nz,0a03h                             ; 0A36: 20 CB
        xor     a                                    ; 0A38: AF
        scf                                          ; 0A39: 37
        ret                                          ; 0A3A: C9
        ld      hl,734dh                             ; 0A3B: 21 4D 73
        ld      bc,0099h                             ; 0A3E: 01 99 00
        inc     a                                    ; 0A41: 3C
        dec     a                                    ; 0A42: 3D
        jr      z,0a48h                              ; 0A43: 28 03
        add     hl,bc                                ; 0A45: 09
        jr      0a42h                                ; 0A46: 18 FA
        ld      a,01h                                ; 0A48: 3E 01
        ld      (75c0h),a                            ; 0A4A: 32 C0 75
        ld      de,4248h                             ; 0A4D: 11 48 42
        ex      de,hl                                ; 0A50: EB
        ldir                                         ; 0A51: ED B0
        ld      bc,0022h                             ; 0A53: 01 22 00
        push    ix                                   ; 0A56: DD E5
        pop     hl                                   ; 0A58: E1
        add     hl,bc                                ; 0A59: 09
        ld      bc,0008h                             ; 0A5A: 01 08 00
        ex      de,hl                                ; 0A5D: EB
        ld      hl,4440h                             ; 0A5E: 21 40 44
        ldir                                         ; 0A61: ED B0
        ret                                          ; 0A63: C9
        ld      hl,734dh                             ; 0A64: 21 4D 73
        ld      bc,0099h                             ; 0A67: 01 99 00
        ld      a,(ix+02h)                           ; 0A6A: DD 7E 02
        inc     a                                    ; 0A6D: 3C
        dec     a                                    ; 0A6E: 3D
        jr      z,0a74h                              ; 0A6F: 28 03
        add     hl,bc                                ; 0A71: 09
        jr      0a6eh                                ; 0A72: 18 FA
        ld      (75b9h),hl                           ; 0A74: 22 B9 75
        ld      (75bdh),hl                           ; 0A77: 22 BD 75
        ex      de,hl                                ; 0A7A: EB
        ld      hl,08c6h                             ; 0A7B: 21 C6 08
        ld      bc,0099h                             ; 0A7E: 01 99 00
        dec     hl                                   ; 0A81: 2B
        ldi                                          ; 0A82: ED A0
        jp      pe,0a81h                             ; 0A84: EA 81 0A
        ret                                          ; 0A87: C9
        ld      de,(75b9h)                           ; 0A88: ED 5B B9 75
        ld      hl,(75b1h)                           ; 0A8C: 2A B1 75
        ld      a,(75b3h)                            ; 0A8F: 3A B3 75
        ld      c,a                                  ; 0A92: 4F
        ld      a,(75b4h)                            ; 0A93: 3A B4 75
        inc     a                                    ; 0A96: 3C
        cp      (ix+25h)                             ; 0A97: DD BE 25
        jr      nz,0aa9h                             ; 0A9A: 20 0D
        ld      a,c                                  ; 0A9C: 79
        inc     a                                    ; 0A9D: 3C
        cp      (ix+24h)                             ; 0A9E: DD BE 24
        ld      c,a                                  ; 0AA1: 4F
        ld      a,00h                                ; 0AA2: 3E 00
        jr      nz,0aa9h                             ; 0AA4: 20 03
        ld      c,00h                                ; 0AA6: 0E 00
        inc     hl                                   ; 0AA8: 23
        sla     c                                    ; 0AA9: CB 21
        sla     c                                    ; 0AAB: CB 21
        sla     c                                    ; 0AAD: CB 21
        sla     c                                    ; 0AAF: CB 21
        sla     c                                    ; 0AB1: CB 21
        or      c                                    ; 0AB3: B1
        ld      c,a                                  ; 0AB4: 4F
        ld      a,h                                  ; 0AB5: 7C
        ld      (de),a                               ; 0AB6: 12
        inc     de                                   ; 0AB7: 13
        ld      a,l                                  ; 0AB8: 7D
        ld      (de),a                               ; 0AB9: 12
        inc     de                                   ; 0ABA: 13
        ld      a,c                                  ; 0ABB: 79
        ld      (de),a                               ; 0ABC: 12
        inc     de                                   ; 0ABD: 13
        ld      (75b9h),de                           ; 0ABE: ED 53 B9 75
        ret                                          ; 0AC2: C9
        ld      de,(75bdh)                           ; 0AC3: ED 5B BD 75
        ld      a,(4201h)                            ; 0AC7: 3A 01 42
        sla     a                                    ; 0ACA: CB 27
        sla     a                                    ; 0ACC: CB 27
        sla     a                                    ; 0ACE: CB 27
        sla     a                                    ; 0AD0: CB 27
        sla     a                                    ; 0AD2: CB 27
        ld      b,a                                  ; 0AD4: 47
        ld      a,(4204h)                            ; 0AD5: 3A 04 42
        or      b                                    ; 0AD8: B0
        ld      (75b8h),a                            ; 0AD9: 32 B8 75
        ld      a,(de)                               ; 0ADC: 1A
        ld      h,a                                  ; 0ADD: 67
        inc     de                                   ; 0ADE: 13
        ld      a,(de)                               ; 0ADF: 1A
        ld      l,a                                  ; 0AE0: 6F
        inc     de                                   ; 0AE1: 13
        or      h                                    ; 0AE2: B4
        jr      nz,0ae9h                             ; 0AE3: 20 04
        ld      a,(de)                               ; 0AE5: 1A
        or      h                                    ; 0AE6: B4
        jr      z,0afdh                              ; 0AE7: 28 14
        ld      bc,(4202h)                           ; 0AE9: ED 4B 02 42
        xor     a                                    ; 0AED: AF
        sbc     hl,bc                                ; 0AEE: ED 42
        jr      nz,0afah                             ; 0AF0: 20 08
        ld      a,(de)                               ; 0AF2: 1A
        ld      c,a                                  ; 0AF3: 4F
        ld      a,(75b8h)                            ; 0AF4: 3A B8 75
        cp      c                                    ; 0AF7: B9
        scf                                          ; 0AF8: 37
        ret     z                                    ; 0AF9: C8
        inc     de                                   ; 0AFA: 13
        jr      0adch                                ; 0AFB: 18 DF
        ld      de,(75b9h)                           ; 0AFD: ED 5B B9 75
        ld      hl,(4202h)                           ; 0B01: 2A 02 42
        ld      a,h                                  ; 0B04: 7C
        ld      (de),a                               ; 0B05: 12
        inc     de                                   ; 0B06: 13
        ld      a,l                                  ; 0B07: 7D
        ld      (de),a                               ; 0B08: 12
        inc     de                                   ; 0B09: 13
        ld      a,(75b8h)                            ; 0B0A: 3A B8 75
        ld      (de),a                               ; 0B0D: 12
        inc     de                                   ; 0B0E: 13
        ld      (75b9h),de                           ; 0B0F: ED 53 B9 75
        ld      a,(75bfh)                            ; 0B13: 3A BF 75
        inc     a                                    ; 0B16: 3C
        ld      (75bfh),a                            ; 0B17: 32 BF 75
        cp      33h                                  ; 0B1A: FE 33
        scf                                          ; 0B1C: 37
        ret     nz                                   ; 0B1D: C0
        ccf                                          ; 0B1E: 3F
        ret                                          ; 0B1F: C9
        xor     a                                    ; 0B20: AF
        ld      (4204h),a                            ; 0B21: 32 04 42
        ld      (4201h),a                            ; 0B24: 32 01 42
        ld      hl,4240h                             ; 0B27: 21 40 42
        ld      a,(ix+25h)                           ; 0B2A: DD 7E 25
        call    0de4h                                ; 0B2D: CD E4 0D
        ld      a,(4201h)                            ; 0B30: 3A 01 42
        call    12fah                                ; 0B33: CD FA 12
        ld      iy,4240h                             ; 0B36: FD 21 40 42
        ld      a,(ix+25h)                           ; 0B3A: DD 7E 25
        call    0e2fh                                ; 0B3D: CD 2F 0E
        ld      a,(ix+25h)                           ; 0B40: DD 7E 25
        ld      bc,0105h                             ; 0B43: 01 05 01
        ld      hl,0000h                             ; 0B46: 21 00 00
        add     hl,bc                                ; 0B49: 09
        dec     a                                    ; 0B4A: 3D
        jr      nz,0b49h                             ; 0B4B: 20 FC
        push    hl                                   ; 0B4D: E5
        ld      a,(4204h)                            ; 0B4E: 3A 04 42
        call    15ach                                ; 0B51: CD AC 15
        pop     bc                                   ; 0B54: C1
        ld      a,02h                                ; 0B55: 3E 02
        scf                                          ; 0B57: 37
        ret     nz                                   ; 0B58: C0
        ld      hl,2120h                             ; 0B59: 21 20 21
        call    130bh                                ; 0B5C: CD 0B 13
        ret     nc                                   ; 0B5F: D0
        ld      a,01h                                ; 0B60: 3E 01
        ret     nz                                   ; 0B62: C0
        ld      a,(4201h)                            ; 0B63: 3A 01 42
        inc     a                                    ; 0B66: 3C
        ld      (4201h),a                            ; 0B67: 32 01 42
        cp      (ix+24h)                             ; 0B6A: DD BE 24
        jr      nz,0b33h                             ; 0B6D: 20 C4
        xor     a                                    ; 0B6F: AF
        ld      (4201h),a                            ; 0B70: 32 01 42
        scf                                          ; 0B73: 37
        ret                                          ; 0B74: C9
        ld      iy,08c8h                             ; 0B75: FD 21 C8 08
        ld      hl,4240h                             ; 0B79: 21 40 42
        ld      a,01h                                ; 0B7C: 3E 01
        call    0de4h                                ; 0B7E: CD E4 0D
        ld      de,(75bdh)                           ; 0B81: ED 5B BD 75
        ld      (75b9h),de                           ; 0B85: ED 53 B9 75
        call    0cdch                                ; 0B89: CD DC 0C
        jr      z,0bcah                              ; 0B8C: 28 3C
        ld      hl,(4202h)                           ; 0B8E: 2A 02 42
        call    0576h                                ; 0B91: CD 76 05
        ret     nc                                   ; 0B94: D0
        call    11b3h                                ; 0B95: CD B3 11
        ret     nc                                   ; 0B98: D0
        ld      a,0ffh                               ; 0B99: 3E FF
        ld      (75b5h),a                            ; 0B9B: 32 B5 75
        ld      iy,4240h                             ; 0B9E: FD 21 40 42
        ld      a,01h                                ; 0BA2: 3E 01
        call    0e2fh                                ; 0BA4: CD 2F 0E
        xor     a                                    ; 0BA7: AF
        ld      (75b5h),a                            ; 0BA8: 32 B5 75
        ld      a,(4201h)                            ; 0BAB: 3A 01 42
        call    12fah                                ; 0BAE: CD FA 12
        ld      a,(4204h)                            ; 0BB1: 3A 04 42
        call    15ach                                ; 0BB4: CD AC 15
        ld      a,02h                                ; 0BB7: 3E 02
        scf                                          ; 0BB9: 37
        ret     nz                                   ; 0BBA: C0
        ld      hl,2120h                             ; 0BBB: 21 20 21
        ld      bc,0105h                             ; 0BBE: 01 05 01
        call    130bh                                ; 0BC1: CD 0B 13
        ret     nc                                   ; 0BC4: D0
        ld      a,01h                                ; 0BC5: 3E 01
        ret     nz                                   ; 0BC7: C0
        jr      0b89h                                ; 0BC8: 18 BF
        xor     a                                    ; 0BCA: AF
        scf                                          ; 0BCB: 37
        ret                                          ; 0BCC: C9
        xor     a                                    ; 0BCD: AF
        ld      (4204h),a                            ; 0BCE: 32 04 42
        ld      (4201h),a                            ; 0BD1: 32 01 42
        ld      a,(4201h)                            ; 0BD4: 3A 01 42
        call    12fah                                ; 0BD7: CD FA 12
        ld      a,06h                                ; 0BDA: 3E 06
        ld      (4209h),a                            ; 0BDC: 32 09 42
        ld      a,(ix+25h)                           ; 0BDF: DD 7E 25
        ld      hl,0000h                             ; 0BE2: 21 00 00
        ld      bc,0105h                             ; 0BE5: 01 05 01
        add     hl,bc                                ; 0BE8: 09
        dec     a                                    ; 0BE9: 3D
        jr      nz,0be8h                             ; 0BEA: 20 FC
        push    hl                                   ; 0BEC: E5
        xor     a                                    ; 0BED: AF
        ld      (420fh),a                            ; 0BEE: 32 0F 42
        ld      a,(4204h)                            ; 0BF1: 3A 04 42
        call    15ach                                ; 0BF4: CD AC 15
        pop     bc                                   ; 0BF7: C1
        ld      a,02h                                ; 0BF8: 3E 02
        scf                                          ; 0BFA: 37
        ret     nz                                   ; 0BFB: C0
        ld      hl,2120h                             ; 0BFC: 21 20 21
        call    1324h                                ; 0BFF: CD 24 13
        ret     nc                                   ; 0C02: D0
        ld      a,01h                                ; 0C03: 3E 01
        ret     nz                                   ; 0C05: C0
        ld      a,(420fh)                            ; 0C06: 3A 0F 42
        or      a                                    ; 0C09: B7
        jr      z,0c1ch                              ; 0C0A: 28 10
        ld      hl,(4202h)                           ; 0C0C: 2A 02 42
        ld      a,h                                  ; 0C0F: 7C
        or      l                                    ; 0C10: B5
        ld      a,05h                                ; 0C11: 3E 05
        jr      z,0c35h                              ; 0C13: 28 20
        call    0c38h                                ; 0C15: CD 38 0C
        ld      a,05h                                ; 0C18: 3E 05
        jr      nc,0c35h                             ; 0C1A: 30 19
        ld      a,(4209h)                            ; 0C1C: 3A 09 42
        dec     a                                    ; 0C1F: 3D
        ld      (4209h),a                            ; 0C20: 32 09 42
        jr      nz,0bdfh                             ; 0C23: 20 BA
        ld      a,(4201h)                            ; 0C25: 3A 01 42
        inc     a                                    ; 0C28: 3C
        ld      (4201h),a                            ; 0C29: 32 01 42
        cp      (ix+24h)                             ; 0C2C: DD BE 24
        jr      nz,0bd4h                             ; 0C2F: 20 A3
        xor     a                                    ; 0C31: AF
        ld      (4201h),a                            ; 0C32: 32 01 42
        or      a                                    ; 0C35: B7
        scf                                          ; 0C36: 37
        ret                                          ; 0C37: C9
        ld      iy,4240h                             ; 0C38: FD 21 40 42
        push    iy                                   ; 0C3C: FD E5
        xor     a                                    ; 0C3E: AF
        ld      (4204h),a                            ; 0C3F: 32 04 42
        ld      a,01h                                ; 0C42: 3E 01
        pop     iy                                   ; 0C44: FD E1
        push    iy                                   ; 0C46: FD E5
        call    10d4h                                ; 0C48: CD D4 10
        call    nz,0ac3h                             ; 0C4B: C4 C3 0A
        pop     hl                                   ; 0C4E: E1
        ret     nc                                   ; 0C4F: D0
        jr      nz,0c5dh                             ; 0C50: 20 0B
        push    hl                                   ; 0C52: E5
        ld      a,01h                                ; 0C53: 3E 01
        call    1134h                                ; 0C55: CD 34 11
        call    nz,0ac3h                             ; 0C58: C4 C3 0A
        pop     hl                                   ; 0C5B: E1
        ret     nc                                   ; 0C5C: D0
        ld      a,(4204h)                            ; 0C5D: 3A 04 42
        inc     a                                    ; 0C60: 3C
        cp      (ix+25h)                             ; 0C61: DD BE 25
        jr      z,0c70h                              ; 0C64: 28 0A
        ld      (4204h),a                            ; 0C66: 32 04 42
        ld      bc,020ah                             ; 0C69: 01 0A 02
        add     hl,bc                                ; 0C6C: 09
        push    hl                                   ; 0C6D: E5
        jr      0c42h                                ; 0C6E: 18 D2
        xor     a                                    ; 0C70: AF
        ld      (4204h),a                            ; 0C71: 32 04 42
        scf                                          ; 0C74: 37
        ret                                          ; 0C75: C9
        push    bc                                   ; 0C76: C5
        push    hl                                   ; 0C77: E5
        inc     c                                    ; 0C78: 0C
        dec     c                                    ; 0C79: 0D
        jr      z,0ca5h                              ; 0C7A: 28 29
        ld      a,(75b4h)                            ; 0C7C: 3A B4 75
        inc     a                                    ; 0C7F: 3C
        ld      (75b4h),a                            ; 0C80: 32 B4 75
        cp      (ix+25h)                             ; 0C83: DD BE 25
        jr      nz,0c79h                             ; 0C86: 20 F1
        xor     a                                    ; 0C88: AF
        ld      (75b4h),a                            ; 0C89: 32 B4 75
        ld      a,(75b3h)                            ; 0C8C: 3A B3 75
        inc     a                                    ; 0C8F: 3C
        ld      (75b3h),a                            ; 0C90: 32 B3 75
        cp      (ix+24h)                             ; 0C93: DD BE 24
        jr      nz,0c79h                             ; 0C96: 20 E1
        xor     a                                    ; 0C98: AF
        ld      (75b3h),a                            ; 0C99: 32 B3 75
        ld      hl,(75b1h)                           ; 0C9C: 2A B1 75
        inc     hl                                   ; 0C9F: 23
        ld      (75b1h),hl                           ; 0CA0: 22 B1 75
        jr      0c79h                                ; 0CA3: 18 D4
        pop     hl                                   ; 0CA5: E1
        pop     bc                                   ; 0CA6: C1
        ret                                          ; 0CA7: C9
        push    bc                                   ; 0CA8: C5
        push    hl                                   ; 0CA9: E5
        inc     c                                    ; 0CAA: 0C
        dec     c                                    ; 0CAB: 0D
        jr      z,0cd9h                              ; 0CAC: 28 2B
        ld      a,(4204h)                            ; 0CAE: 3A 04 42
        inc     a                                    ; 0CB1: 3C
        ld      (4204h),a                            ; 0CB2: 32 04 42
        cp      (ix+25h)                             ; 0CB5: DD BE 25
        jr      nz,0cabh                             ; 0CB8: 20 F1
        xor     a                                    ; 0CBA: AF
        ld      (4204h),a                            ; 0CBB: 32 04 42
        ld      a,(4201h)                            ; 0CBE: 3A 01 42
        inc     a                                    ; 0CC1: 3C
        ld      (4201h),a                            ; 0CC2: 32 01 42
        and     07h                                  ; 0CC5: E6 07
        cp      (ix+24h)                             ; 0CC7: DD BE 24
        jr      nz,0cabh                             ; 0CCA: 20 DF
        xor     a                                    ; 0CCC: AF
        ld      (4201h),a                            ; 0CCD: 32 01 42
        ld      hl,(4202h)                           ; 0CD0: 2A 02 42
        inc     hl                                   ; 0CD3: 23
        ld      (4202h),hl                           ; 0CD4: 22 02 42
        jr      0cabh                                ; 0CD7: 18 D2
        pop     hl                                   ; 0CD9: E1
        pop     bc                                   ; 0CDA: C1
        ret                                          ; 0CDB: C9
        ld      de,(75b9h)                           ; 0CDC: ED 5B B9 75
        ld      a,(de)                               ; 0CE0: 1A
        ld      h,a                                  ; 0CE1: 67
        inc     de                                   ; 0CE2: 13
        ld      a,(de)                               ; 0CE3: 1A
        ld      l,a                                  ; 0CE4: 6F
        inc     de                                   ; 0CE5: 13
        or      h                                    ; 0CE6: B4
        ret     z                                    ; 0CE7: C8
        ld      (4202h),hl                           ; 0CE8: 22 02 42
        ld      a,(de)                               ; 0CEB: 1A
        inc     de                                   ; 0CEC: 13
        ld      (75b9h),de                           ; 0CED: ED 53 B9 75
        ld      c,a                                  ; 0CF1: 4F
        and     1fh                                  ; 0CF2: E6 1F
        ld      (4204h),a                            ; 0CF4: 32 04 42
        ld      a,c                                  ; 0CF7: 79
        sra     a                                    ; 0CF8: CB 2F
        sra     a                                    ; 0CFA: CB 2F
        sra     a                                    ; 0CFC: CB 2F
        sra     a                                    ; 0CFE: CB 2F
        sra     a                                    ; 0D00: CB 2F
        and     07h                                  ; 0D02: E6 07
        ld      (4201h),a                            ; 0D04: 32 01 42
        or      01h                                  ; 0D07: F6 01
        ret                                          ; 0D09: C9
initialize_io_controller:
        ld      hl,75c4h                             ; 0D0A: 21 C4 75
        ld      bc,00a8h                             ; 0D0D: 01 A8 00
        xor     a                                    ; 0D10: AF
        ld      (75b5h),a                            ; 0D11: 32 B5 75
        ld      (hl),a                               ; 0D14: 77
        inc     hl                                   ; 0D15: 23
        dec     bc                                   ; 0D16: 0B
        ld      a,b                                  ; 0D17: 78
        or      c                                    ; 0D18: B1
        jp      nz,0d10h                             ; 0D19: C2 10 0D
        ld      a,01h                                ; 0D1C: 3E 01
        ld      (4211h),a                            ; 0D1E: 32 11 42
        ld      (75c0h),a                            ; 0D21: 32 C0 75
        ld      a,0ffh                               ; 0D24: 3E FF
        ld      (4200h),a                            ; 0D26: 32 00 42
        ld      (766ch),a                            ; 0D29: 32 6C 76
        ld      hl,0d9bh                             ; 0D2C: 21 9B 0D
        ld      de,4212h                             ; 0D2F: 11 12 42
        ld      bc,002eh                             ; 0D32: 01 2E 00
        ldir                                         ; 0D35: ED B0
        ld      hl,0dc9h                             ; 0D37: 21 C9 0D
        ld      de,733fh                             ; 0D3A: 11 3F 73
        ld      bc,000eh                             ; 0D3D: 01 0E 00
        ldir                                         ; 0D40: ED B0
        ld      a,00h                                ; 0D42: 3E 00
        ld      (75c4h),a                            ; 0D44: 32 C4 75
        ld      (75eeh),a                            ; 0D47: 32 EE 75
        ld      (7618h),a                            ; 0D4A: 32 18 76
        ld      (7642h),a                            ; 0D4D: 32 42 76
        ld      hl,75c4h                             ; 0D50: 21 C4 75
        ld      (75c2h),hl                           ; 0D53: 22 C2 75
        ld      a,00h                                ; 0D56: 3E 00
        ld      (75d6h),a                            ; 0D58: 32 D6 75
        ld      (7600h),a                            ; 0D5B: 32 00 76
        ld      (762ah),a                            ; 0D5E: 32 2A 76
        ld      (7654h),a                            ; 0D61: 32 54 76
        ld      (75d5h),a                            ; 0D64: 32 D5 75
        ld      (75ffh),a                            ; 0D67: 32 FF 75
        ld      (7629h),a                            ; 0D6A: 32 29 76
        ld      (7653h),a                            ; 0D6D: 32 53 76
        ld      (733dh),a                            ; 0D70: 32 3D 73
        dec     a                                    ; 0D73: 3D
        ld      (75d9h),a                            ; 0D74: 32 D9 75
        ld      (7603h),a                            ; 0D77: 32 03 76
        ld      (762dh),a                            ; 0D7A: 32 2D 76
        ld      (7657h),a                            ; 0D7D: 32 57 76
        ld      (733eh),a                            ; 0D80: 32 3E 73
        ld      iy,734dh                             ; 0D83: FD 21 4D 73
        ld      hl,0ffffh                            ; 0D87: 21 FF FF
        ld      bc,0099h                             ; 0D8A: 01 99 00
        ld      a,04h                                ; 0D8D: 3E 04
        ld      (iy+00h),h                           ; 0D8F: FD 74 00
        ld      (iy+01h),l                           ; 0D92: FD 75 01
        add     iy,bc                                ; 0D95: FD 09
        dec     a                                    ; 0D97: 3D
        ret     z                                    ; 0D98: C8
        jr      0d8fh                                ; 0D99: 18 F4
        add     a,e                                  ; 0D9B: 83
        jp      0c3c3h                               ; 0D9C: C3 C3 C3
        jp      0c3c3h                               ; 0D9F: C3 C3 C3
        ld      a,c                                  ; 0DA2: 79
        nop                                          ; 0DA3: 00
        nop                                          ; 0DA4: 00
        nop                                          ; 0DA5: 00
        nop                                          ; 0DA6: 00
        ld      d,h                                  ; 0DA7: 54
        ld      (bc),a                               ; 0DA8: 02
        ld      d,b                                  ; 0DA9: 50
        ld      (bc),a                               ; 0DAA: 02
        add     a,b                                  ; 0DAB: 80
        xor     l                                    ; 0DAC: AD
        nop                                          ; 0DAD: 00
        nop                                          ; 0DAE: 00
        adc     a,d                                  ; 0DAF: 8A
        rst     08h                                  ; 0DB0: CF
        rst     08h                                  ; 0DB1: CF
        add     a,e                                  ; 0DB2: 83
        jp      0c3c3h                               ; 0DB3: C3 C3 C3
        jp      0c3c3h                               ; 0DB6: C3 C3 C3
        ld      a,c                                  ; 0DB9: 79
        nop                                          ; 0DBA: 00
        nop                                          ; 0DBB: 00
        nop                                          ; 0DBC: 00
        nop                                          ; 0DBD: 00
        ld      e,h                                  ; 0DBE: 5C
        adc     a,50h                                ; 0DBF: CE 50
        ld      (bc),a                               ; 0DC1: 02
        add     a,b                                  ; 0DC2: 80
        xor     l                                    ; 0DC3: AD
        nop                                          ; 0DC4: 00
        nop                                          ; 0DC5: 00
        add     a,d                                  ; 0DC6: 82
        rst     08h                                  ; 0DC7: CF
        or      e                                    ; 0DC8: B3
        ld      a,h                                  ; 0DC9: 7C
        nop                                          ; 0DCA: 00
        ld      a,l                                  ; 0DCB: 7D
        nop                                          ; 0DCC: 00
        nop                                          ; 0DCD: 00
        nop                                          ; 0DCE: 00
        nop                                          ; 0DCF: 00
        dec     b                                    ; 0DD0: 05
        rst     08h                                  ; 0DD1: CF
        xor     l                                    ; 0DD2: AD
        nop                                          ; 0DD3: 00
        nop                                          ; 0DD4: 00
        ld      bc,1acfh                             ; 0DD5: 01 CF 1A
        cp      (hl)                                 ; 0DD8: BE
        jr      nz,0de2h                             ; 0DD9: 20 07
        inc     hl                                   ; 0DDB: 23
        inc     de                                   ; 0DDC: 13
        dec     bc                                   ; 0DDD: 0B
        ld      a,b                                  ; 0DDE: 78
        or      c                                    ; 0DDF: B1
        jr      nz,0dd7h                             ; 0DE0: 20 F5
        scf                                          ; 0DE2: 37
        ret                                          ; 0DE3: C9
        push    de                                   ; 0DE4: D5
        push    hl                                   ; 0DE5: E5
        push    af                                   ; 0DE6: F5
        push    af                                   ; 0DE7: F5
        ld      d,h                                  ; 0DE8: 54
        ld      e,l                                  ; 0DE9: 5D
        dec     de                                   ; 0DEA: 1B
        dec     de                                   ; 0DEB: 1B
        call    0e03h                                ; 0DEC: CD 03 0E
        ex      de,hl                                ; 0DEF: EB
        pop     af                                   ; 0DF0: F1
        dec     a                                    ; 0DF1: 3D
        jr      z,0e21h                              ; 0DF2: 28 2D
        push    af                                   ; 0DF4: F5
        ex      de,hl                                ; 0DF5: EB
        ld      bc,000ah                             ; 0DF6: 01 0A 00
        add     hl,bc                                ; 0DF9: 09
        ex      de,hl                                ; 0DFA: EB
        add     hl,bc                                ; 0DFB: 09
        ld      bc,0200h                             ; 0DFC: 01 00 02
        ldir                                         ; 0DFF: ED B0
        jr      0df0h                                ; 0E01: 18 ED
        ld      bc,0008h                             ; 0E03: 01 08 00
        add     hl,bc                                ; 0E06: 09
        ld      bc,0200h                             ; 0E07: 01 00 02
        ld      a,(iy+00h)                           ; 0E0A: FD 7E 00
        call    0e29h                                ; 0E0D: CD 29 0E
        ret     z                                    ; 0E10: C8
        ld      a,(iy+01h)                           ; 0E11: FD 7E 01
        call    0e29h                                ; 0E14: CD 29 0E
        ret     z                                    ; 0E17: C8
        ld      a,(iy+02h)                           ; 0E18: FD 7E 02
        call    0e29h                                ; 0E1B: CD 29 0E
        ret     z                                    ; 0E1E: C8
        jr      0e0ah                                ; 0E1F: 18 E9
        pop     af                                   ; 0E21: F1
        pop     iy                                   ; 0E22: FD E1
        pop     de                                   ; 0E24: D1
        call    0e2fh                                ; 0E25: CD 2F 0E
        ret                                          ; 0E28: C9
        ld      (hl),a                               ; 0E29: 77
        inc     hl                                   ; 0E2A: 23
        dec     bc                                   ; 0E2B: 0B
        ld      a,b                                  ; 0E2C: 78
        or      c                                    ; 0E2D: B1
        ret                                          ; 0E2E: C9
        inc     a                                    ; 0E2F: 3C
        push    af                                   ; 0E30: F5
        ld      a,(4204h)                            ; 0E31: 3A 04 42
        ld      (4210h),a                            ; 0E34: 32 10 42
        pop     af                                   ; 0E37: F1
        dec     a                                    ; 0E38: 3D
        ret     z                                    ; 0E39: C8
        push    af                                   ; 0E3A: F5
        ld      a,19h                                ; 0E3B: 3E 19
        ld      (iy+00h),a                           ; 0E3D: FD 77 00
        ld      a,(4210h)                            ; 0E40: 3A 10 42
        sla     a                                    ; 0E43: CB 27
        sla     a                                    ; 0E45: CB 27
        sla     a                                    ; 0E47: CB 27
        ld      c,a                                  ; 0E49: 4F
        ld      a,(4201h)                            ; 0E4A: 3A 01 42
        and     07h                                  ; 0E4D: E6 07
        or      c                                    ; 0E4F: B1
        ld      (iy+01h),a                           ; 0E50: FD 77 01
        ld      hl,(4202h)                           ; 0E53: 2A 02 42
        ld      a,h                                  ; 0E56: 7C
        ld      (iy+02h),a                           ; 0E57: FD 77 02
        ld      a,l                                  ; 0E5A: 7D
        ld      (iy+03h),a                           ; 0E5B: FD 77 03
        ld      a,(75b5h)                            ; 0E5E: 3A B5 75
        ld      (iy+04h),a                           ; 0E61: FD 77 04
        ld      (iy+05h),a                           ; 0E64: FD 77 05
        xor     a                                    ; 0E67: AF
        ld      (iy+06h),a                           ; 0E68: FD 77 06
        ld      (iy+07h),a                           ; 0E6B: FD 77 07
        ld      bc,0208h                             ; 0E6E: 01 08 02
        add     iy,bc                                ; 0E71: FD 09
        ld      (iy+00h),a                           ; 0E73: FD 77 00
        ld      (iy+01h),a                           ; 0E76: FD 77 01
        inc     iy                                   ; 0E79: FD 23
        inc     iy                                   ; 0E7B: FD 23
        ld      a,(4210h)                            ; 0E7D: 3A 10 42
        inc     a                                    ; 0E80: 3C
        ld      (4210h),a                            ; 0E81: 32 10 42
        cp      (ix+25h)                             ; 0E84: DD BE 25
        jr      nz,0e37h                             ; 0E87: 20 AE
        ld      a,00h                                ; 0E89: 3E 00
        ld      (4210h),a                            ; 0E8B: 32 10 42
        jr      0e37h                                ; 0E8E: 18 A7
        xor     a                                    ; 0E90: AF
        or      c                                    ; 0E91: B1
        jr      z,0e95h                              ; 0E92: 28 01
        inc     b                                    ; 0E94: 04
        ld      a,b                                  ; 0E95: 78
        sla     a                                    ; 0E96: CB 27
        sla     a                                    ; 0E98: CB 27
        add     a,b                                  ; 0E9A: 80
        ld      c,a                                  ; 0E9B: 4F
        ret                                          ; 0E9C: C9
        ld      a,(4204h)                            ; 0E9D: 3A 04 42
        inc     a                                    ; 0EA0: 3C
        ld      (4204h),a                            ; 0EA1: 32 04 42
        cp      (ix+25h)                             ; 0EA4: DD BE 25
        jr      c,0ef0h                              ; 0EA7: 38 47
        xor     a                                    ; 0EA9: AF
        ld      (4204h),a                            ; 0EAA: 32 04 42
        ld      a,(4201h)                            ; 0EAD: 3A 01 42
        inc     a                                    ; 0EB0: 3C
        ld      (4201h),a                            ; 0EB1: 32 01 42
        and     07h                                  ; 0EB4: E6 07
        cp      (ix+24h)                             ; 0EB6: DD BE 24
        jr      c,0eeah                              ; 0EB9: 38 2F
        xor     a                                    ; 0EBB: AF
        ld      (4201h),a                            ; 0EBC: 32 01 42
        ld      hl,(4202h)                           ; 0EBF: 2A 02 42
        inc     hl                                   ; 0EC2: 23
        ld      (4202h),hl                           ; 0EC3: 22 02 42
        ld      a,(75c0h)                            ; 0EC6: 3A C0 75
        or      a                                    ; 0EC9: B7
        jr      nz,0ed4h                             ; 0ECA: 20 08
        ld      d,(ix+26h)                           ; 0ECC: DD 56 26
        ld      e,(ix+27h)                           ; 0ECF: DD 5E 27
        jr      0edah                                ; 0ED2: 18 06
        ld      d,(ix+22h)                           ; 0ED4: DD 56 22
        ld      e,(ix+23h)                           ; 0ED7: DD 5E 23
        scf                                          ; 0EDA: 37
        ccf                                          ; 0EDB: 3F
        ex      de,hl                                ; 0EDC: EB
        sbc     hl,de                                ; 0EDD: ED 52
        jr      z,0ef4h                              ; 0EDF: 28 13
        ex      de,hl                                ; 0EE1: EB
        call    0576h                                ; 0EE2: CD 76 05
        ret     nc                                   ; 0EE5: D0
        call    11b3h                                ; 0EE6: CD B3 11
        ret     nc                                   ; 0EE9: D0
        ld      a,(4201h)                            ; 0EEA: 3A 01 42
        call    12fah                                ; 0EED: CD FA 12
        or      01h                                  ; 0EF0: F6 01
        scf                                          ; 0EF2: 37
        ret                                          ; 0EF3: C9
        xor     a                                    ; 0EF4: AF
        scf                                          ; 0EF5: 37
        ret                                          ; 0EF6: C9
        ld      a,(ix+06h)                           ; 0EF7: DD 7E 06
        cp      (ix+25h)                             ; 0EFA: DD BE 25
        ret     nc                                   ; 0EFD: D0
        ld      a,(ix+03h)                           ; 0EFE: DD 7E 03
        cp      (ix+24h)                             ; 0F01: DD BE 24
        ret     nc                                   ; 0F04: D0
        ld      l,(ix+04h)                           ; 0F05: DD 6E 04
        ld      h,(ix+05h)                           ; 0F08: DD 66 05
        ld      a,(75c0h)                            ; 0F0B: 3A C0 75
        or      a                                    ; 0F0E: B7
        jr      nz,0f19h                             ; 0F0F: 20 08
        ld      d,(ix+26h)                           ; 0F11: DD 56 26
        ld      e,(ix+27h)                           ; 0F14: DD 5E 27
        jr      0f1fh                                ; 0F17: 18 06
        ld      d,(ix+22h)                           ; 0F19: DD 56 22
        ld      e,(ix+23h)                           ; 0F1C: DD 5E 23
        scf                                          ; 0F1F: 37
        ccf                                          ; 0F20: 3F
        sbc     hl,de                                ; 0F21: ED 52
        ret     nc                                   ; 0F23: D0
        ld      a,(ix+02h)                           ; 0F24: DD 7E 02
        cp      04h                                  ; 0F27: FE 04
        ret                                          ; 0F29: C9
        ld      a,(75c0h)                            ; 0F2A: 3A C0 75
        or      a                                    ; 0F2D: B7
        ld      (420ch),a                            ; 0F2E: 32 0C 42
        ld      a,(ix+06h)                           ; 0F31: DD 7E 06
        jr      z,0fa1h                              ; 0F34: 28 6B
        ld      h,(ix+0ah)                           ; 0F36: DD 66 0A
        ld      l,(ix+09h)                           ; 0F39: DD 6E 09
        xor     a                                    ; 0F3C: AF
        ld      (420ch),a                            ; 0F3D: 32 0C 42
        or      l                                    ; 0F40: B5
        jr      z,0f44h                              ; 0F41: 28 01
        inc     h                                    ; 0F43: 24
        ld      c,h                                  ; 0F44: 4C
        ld      h,(ix+05h)                           ; 0F45: DD 66 05
        ld      l,(ix+04h)                           ; 0F48: DD 6E 04
        ld      (75b1h),hl                           ; 0F4B: 22 B1 75
        ld      (4202h),hl                           ; 0F4E: 22 02 42
        ld      a,(ix+03h)                           ; 0F51: DD 7E 03
        ld      (75b3h),a                            ; 0F54: 32 B3 75
        ld      (4201h),a                            ; 0F57: 32 01 42
        ld      a,(ix+06h)                           ; 0F5A: DD 7E 06
        ld      (75b4h),a                            ; 0F5D: 32 B4 75
        ld      (4204h),a                            ; 0F60: 32 04 42
        call    104fh                                ; 0F63: CD 4F 10
        ld      a,(420bh)                            ; 0F66: 3A 0B 42
        ld      b,a                                  ; 0F69: 47
        ld      a,(4204h)                            ; 0F6A: 3A 04 42
        push    af                                   ; 0F6D: F5
        ld      a,(420ch)                            ; 0F6E: 3A 0C 42
        inc     a                                    ; 0F71: 3C
        cp      c                                    ; 0F72: B9
        jr      z,0f9ch                              ; 0F73: 28 27
        ld      (420ch),a                            ; 0F75: 32 0C 42
        push    bc                                   ; 0F78: C5
        ld      c,01h                                ; 0F79: 0E 01
        call    0c76h                                ; 0F7B: CD 76 0C
        ld      hl,(75b1h)                           ; 0F7E: 2A B1 75
        ld      (4202h),hl                           ; 0F81: 22 02 42
        ld      a,(75b3h)                            ; 0F84: 3A B3 75
        ld      (4201h),a                            ; 0F87: 32 01 42
        ld      a,(75b4h)                            ; 0F8A: 3A B4 75
        ld      (4204h),a                            ; 0F8D: 32 04 42
        call    104fh                                ; 0F90: CD 4F 10
        pop     bc                                   ; 0F93: C1
        ld      a,(420bh)                            ; 0F94: 3A 0B 42
        cp      b                                    ; 0F97: B8
        jr      z,0f6eh                              ; 0F98: 28 D4
        jr      0fa0h                                ; 0F9A: 18 04
        xor     a                                    ; 0F9C: AF
        ld      (420ch),a                            ; 0F9D: 32 0C 42
        pop     af                                   ; 0FA0: F1
        ld      b,a                                  ; 0FA1: 47
        ld      a,(ix+25h)                           ; 0FA2: DD 7E 25
        sub     b                                    ; 0FA5: 90
        ld      b,a                                  ; 0FA6: 47
        ld      a,(420ch)                            ; 0FA7: 3A 0C 42
        ld      c,a                                  ; 0FAA: 4F
        or      a                                    ; 0FAB: B7
        ld      a,b                                  ; 0FAC: 78
        jr      z,0fb3h                              ; 0FAD: 28 04
        cp      c                                    ; 0FAF: B9
        jr      c,0fb3h                              ; 0FB0: 38 01
        ld      a,c                                  ; 0FB2: 79
        ld      h,a                                  ; 0FB3: 67
        ld      l,00h                                ; 0FB4: 2E 00
        ld      d,(ix+0ah)                           ; 0FB6: DD 56 0A
        ld      e,(ix+09h)                           ; 0FB9: DD 5E 09
        push    hl                                   ; 0FBC: E5
        xor     a                                    ; 0FBD: AF
        sbc     hl,de                                ; 0FBE: ED 52
        pop     hl                                   ; 0FC0: E1
        jr      c,0fc4h                              ; 0FC1: 38 01
        ex      de,hl                                ; 0FC3: EB
        ld      (ix+18h),l                           ; 0FC4: DD 75 18
        ld      (ix+19h),h                           ; 0FC7: DD 74 19
        ret                                          ; 0FCA: C9
        ld      l,(ix+09h)                           ; 0FCB: DD 6E 09
        ld      h,(ix+0ah)                           ; 0FCE: DD 66 0A
        ld      e,(ix+18h)                           ; 0FD1: DD 5E 18
        ld      d,(ix+19h)                           ; 0FD4: DD 56 19
        xor     a                                    ; 0FD7: AF
        sbc     hl,de                                ; 0FD8: ED 52
        ld      (ix+09h),l                           ; 0FDA: DD 75 09
        ld      (ix+0ah),h                           ; 0FDD: DD 74 0A
        scf                                          ; 0FE0: 37
        ret     z                                    ; 0FE1: C8
        ld      a,(ix+0dh)                           ; 0FE2: DD 7E 0D
        ld      h,(ix+0ch)                           ; 0FE5: DD 66 0C
        ld      l,(ix+0bh)                           ; 0FE8: DD 6E 0B
        add     hl,de                                ; 0FEB: 19
        jr      nc,0fefh                             ; 0FEC: 30 01
        inc     a                                    ; 0FEE: 3C
        add     hl,de                                ; 0FEF: 19
        jr      nc,0ff3h                             ; 0FF0: 30 01
        inc     a                                    ; 0FF2: 3C
        ld      (ix+0bh),l                           ; 0FF3: DD 75 0B
        ld      (ix+0ch),h                           ; 0FF6: DD 74 0C
        ld      (ix+0dh),a                           ; 0FF9: DD 77 0D
        ld      l,(ix+18h)                           ; 0FFC: DD 6E 18
        ld      h,(ix+19h)                           ; 0FFF: DD 66 19
        xor     a                                    ; 1002: AF
        or      l                                    ; 1003: B5
        jr      z,1007h                              ; 1004: 28 01
        inc     h                                    ; 1006: 24
        ld      c,h                                  ; 1007: 4C
        ld      a,(ix+06h)                           ; 1008: DD 7E 06
        ld      (75b4h),a                            ; 100B: 32 B4 75
        ld      a,(ix+03h)                           ; 100E: DD 7E 03
        ld      (75b3h),a                            ; 1011: 32 B3 75
        ld      l,(ix+04h)                           ; 1014: DD 6E 04
        ld      h,(ix+05h)                           ; 1017: DD 66 05
        ld      (75b1h),hl                           ; 101A: 22 B1 75
        call    0c76h                                ; 101D: CD 76 0C
        ld      a,(75b4h)                            ; 1020: 3A B4 75
        ld      (ix+06h),a                           ; 1023: DD 77 06
        ld      a,(75b3h)                            ; 1026: 3A B3 75
        ld      (ix+03h),a                           ; 1029: DD 77 03
        ld      hl,(75b1h)                           ; 102C: 2A B1 75
        ld      (ix+04h),l                           ; 102F: DD 75 04
        ld      (ix+05h),h                           ; 1032: DD 74 05
        ld      d,(ix+22h)                           ; 1035: DD 56 22
        ld      e,(ix+23h)                           ; 1038: DD 5E 23
        ld      a,(75c0h)                            ; 103B: 3A C0 75
        or      a                                    ; 103E: B7
        jr      nz,1047h                             ; 103F: 20 06
        ld      d,(ix+26h)                           ; 1041: DD 56 26
        ld      e,(ix+27h)                           ; 1044: DD 5E 27
        xor     a                                    ; 1047: AF
        sbc     hl,de                                ; 1048: ED 52
        ret     nc                                   ; 104A: D0
        or      01h                                  ; 104B: F6 01
        scf                                          ; 104D: 37
        ret                                          ; 104E: C9
        ld      a,(75c0h)                            ; 104F: 3A C0 75
        or      a                                    ; 1052: B7
        ret     z                                    ; 1053: C8
        push    bc                                   ; 1054: C5
        push    de                                   ; 1055: D5
        push    hl                                   ; 1056: E5
        ld      a,(ix+02h)                           ; 1057: DD 7E 02
        ld      hl,734dh                             ; 105A: 21 4D 73
        ld      bc,0099h                             ; 105D: 01 99 00
        inc     a                                    ; 1060: 3C
        dec     a                                    ; 1061: 3D
        jr      z,1067h                              ; 1062: 28 03
        add     hl,bc                                ; 1064: 09
        jr      1061h                                ; 1065: 18 FA
        ld      c,(ix+28h)                           ; 1067: DD 4E 28
        call    0ca8h                                ; 106A: CD A8 0C
        ld      a,0ffh                               ; 106D: 3E FF
        ld      (420bh),a                            ; 106F: 32 0B 42
        ld      a,(4201h)                            ; 1072: 3A 01 42
        sla     a                                    ; 1075: CB 27
        sla     a                                    ; 1077: CB 27
        sla     a                                    ; 1079: CB 27
        sla     a                                    ; 107B: CB 27
        sla     a                                    ; 107D: CB 27
        ld      c,a                                  ; 107F: 4F
        ld      a,(4204h)                            ; 1080: 3A 04 42
        or      c                                    ; 1083: B1
        push    af                                   ; 1084: F5
        ld      bc,(4202h)                           ; 1085: ED 4B 02 42
        ld      a,(420bh)                            ; 1089: 3A 0B 42
        inc     a                                    ; 108C: 3C
        ld      (420bh),a                            ; 108D: 32 0B 42
        ld      d,(hl)                               ; 1090: 56
        inc     hl                                   ; 1091: 23
        ld      e,(hl)                               ; 1092: 5E
        inc     hl                                   ; 1093: 23
        inc     hl                                   ; 1094: 23
        xor     a                                    ; 1095: AF
        ex      de,hl                                ; 1096: EB
        sbc     hl,bc                                ; 1097: ED 42
        ex      de,hl                                ; 1099: EB
        jr      c,1089h                              ; 109A: 38 ED
        jr      nz,10a8h                             ; 109C: 20 0A
        dec     hl                                   ; 109E: 2B
        ld      e,(hl)                               ; 109F: 5E
        inc     hl                                   ; 10A0: 23
        pop     af                                   ; 10A1: F1
        cp      e                                    ; 10A2: BB
        jr      c,10a9h                              ; 10A3: 38 04
        push    af                                   ; 10A5: F5
        jr      1089h                                ; 10A6: 18 E1
        pop     af                                   ; 10A8: F1
        ld      a,(420bh)                            ; 10A9: 3A 0B 42
        ld      c,a                                  ; 10AC: 4F
        call    0ca8h                                ; 10AD: CD A8 0C
        pop     hl                                   ; 10B0: E1
        pop     de                                   ; 10B1: D1
        pop     bc                                   ; 10B2: C1
        ret                                          ; 10B3: C9
        ld      h,(ix+05h)                           ; 10B4: DD 66 05
        ld      l,(ix+04h)                           ; 10B7: DD 6E 04
        inc     hl                                   ; 10BA: 23
        ld      (ix+05h),h                           ; 10BB: DD 74 05
        ld      (ix+04h),l                           ; 10BE: DD 75 04
        call    0f05h                                ; 10C1: CD 05 0F
        ret     c                                    ; 10C4: D8
        ld      h,(ix+22h)                           ; 10C5: DD 66 22
        ld      l,(ix+23h)                           ; 10C8: DD 6E 23
        dec     hl                                   ; 10CB: 2B
        dec     hl                                   ; 10CC: 2B
        ld      (ix+05h),h                           ; 10CD: DD 74 05
        ld      (ix+04h),l                           ; 10D0: DD 75 04
        ret                                          ; 10D3: C9
        inc     a                                    ; 10D4: 3C
        push    af                                   ; 10D5: F5
        ld      hl,(4202h)                           ; 10D6: 2A 02 42
        ld      a,(4201h)                            ; 10D9: 3A 01 42
        and     07h                                  ; 10DC: E6 07
        ld      d,a                                  ; 10DE: 57
        ld      a,(4204h)                            ; 10DF: 3A 04 42
        ld      e,a                                  ; 10E2: 5F
        pop     af                                   ; 10E3: F1
        dec     a                                    ; 10E4: 3D
        scf                                          ; 10E5: 37
        ret     z                                    ; 10E6: C8
        push    af                                   ; 10E7: F5
        ld      a,19h                                ; 10E8: 3E 19
        cp      (iy+00h)                             ; 10EA: FD BE 00
        jr      nz,112bh                             ; 10ED: 20 3C
        ld      a,e                                  ; 10EF: 7B
        sla     a                                    ; 10F0: CB 27
        sla     a                                    ; 10F2: CB 27
        sla     a                                    ; 10F4: CB 27
        or      d                                    ; 10F6: B2
        cp      (iy+01h)                             ; 10F7: FD BE 01
        jr      nz,112bh                             ; 10FA: 20 2F
        ld      a,h                                  ; 10FC: 7C
        cp      (iy+02h)                             ; 10FD: FD BE 02
        jr      nz,112bh                             ; 1100: 20 29
        ld      a,l                                  ; 1102: 7D
        cp      (iy+03h)                             ; 1103: FD BE 03
        jr      nz,112bh                             ; 1106: 20 23
        ld      h,(iy+04h)                           ; 1108: FD 66 04
        ld      a,(iy+05h)                           ; 110B: FD 7E 05
        or      h                                    ; 110E: B4
        jr      nz,1130h                             ; 110F: 20 1F
        ld      bc,020ah                             ; 1111: 01 0A 02
        add     iy,bc                                ; 1114: FD 09
        inc     e                                    ; 1116: 1C
        ld      a,e                                  ; 1117: 7B
        cp      (ix+25h)                             ; 1118: DD BE 25
        jr      nz,10e3h                             ; 111B: 20 C6
        ld      e,00h                                ; 111D: 1E 00
        inc     d                                    ; 111F: 14
        ld      a,d                                  ; 1120: 7A
        cp      (ix+24h)                             ; 1121: DD BE 24
        jr      nz,10e3h                             ; 1124: 20 BD
        ld      d,00h                                ; 1126: 16 00
        inc     hl                                   ; 1128: 23
        jr      10e3h                                ; 1129: 18 B8
        pop     af                                   ; 112B: F1
        or      01h                                  ; 112C: F6 01
        scf                                          ; 112E: 37
        ret                                          ; 112F: C9
        pop     af                                   ; 1130: F1
        xor     a                                    ; 1131: AF
        inc     a                                    ; 1132: 3C
        ret                                          ; 1133: C9
        ld      iy,(75bbh)                           ; 1134: FD 2A BB 75
        push    af                                   ; 1138: F5
        ld      de,0008h                             ; 1139: 11 08 00
        add     hl,de                                ; 113C: 19
        inc     de                                   ; 113D: 13
        inc     de                                   ; 113E: 13
        ld      bc,0200h                             ; 113F: 01 00 02
        call    114fh                                ; 1142: CD 4F 11
        jr      nz,1171h                             ; 1145: 20 2A
        pop     af                                   ; 1147: F1
        dec     a                                    ; 1148: 3D
        scf                                          ; 1149: 37
        ret     z                                    ; 114A: C8
        push    af                                   ; 114B: F5
        add     hl,de                                ; 114C: 19
        jr      113fh                                ; 114D: 18 F0
        ld      a,(hl)                               ; 114F: 7E
        cp      (iy+00h)                             ; 1150: FD BE 00
        ret     nz                                   ; 1153: C0
        call    116ch                                ; 1154: CD 6C 11
        ret     z                                    ; 1157: C8
        ld      a,(hl)                               ; 1158: 7E
        cp      (iy+01h)                             ; 1159: FD BE 01
        ret     nz                                   ; 115C: C0
        call    116ch                                ; 115D: CD 6C 11
        ret     z                                    ; 1160: C8
        ld      a,(hl)                               ; 1161: 7E
        cp      (iy+02h)                             ; 1162: FD BE 02
        ret     nz                                   ; 1165: C0
        call    116ch                                ; 1166: CD 6C 11
        ret     z                                    ; 1169: C8
        jr      114fh                                ; 116A: 18 E3
        inc     hl                                   ; 116C: 23
        dec     bc                                   ; 116D: 0B
        ld      a,b                                  ; 116E: 78
        or      c                                    ; 116F: B1
        ret                                          ; 1170: C9
        pop     de                                   ; 1171: D1
        scf                                          ; 1172: 37
        ret                                          ; 1173: C9
        ld      iy,4240h                             ; 1174: FD 21 40 42
        xor     a                                    ; 1178: AF
        push    af                                   ; 1179: F5
        ld      h,(iy+04h)                           ; 117A: FD 66 04
        ld      a,(iy+05h)                           ; 117D: FD 7E 05
        or      h                                    ; 1180: B4
        jr      z,1193h                              ; 1181: 28 10
        call    0a88h                                ; 1183: CD 88 0A
        ld      a,(75bfh)                            ; 1186: 3A BF 75
        inc     a                                    ; 1189: 3C
        ld      (75bfh),a                            ; 118A: 32 BF 75
        cp      33h                                  ; 118D: FE 33
        jr      z,11a7h                              ; 118F: 28 16
        jr      1198h                                ; 1191: 18 05
        ld      c,01h                                ; 1193: 0E 01
        call    0c76h                                ; 1195: CD 76 0C
        pop     af                                   ; 1198: F1
        inc     a                                    ; 1199: 3C
        cp      (ix+25h)                             ; 119A: DD BE 25
        scf                                          ; 119D: 37
        ret     z                                    ; 119E: C8
        push    af                                   ; 119F: F5
        ld      bc,020ah                             ; 11A0: 01 0A 02
        add     iy,bc                                ; 11A3: FD 09
        jr      117ah                                ; 11A5: 18 D3
        pop     af                                   ; 11A7: F1
        xor     a                                    ; 11A8: AF
        ret                                          ; 11A9: C9
        ld      (4200h),a                            ; 11AA: 32 00 42
        out     (90h),a                              ; 11AD: D3 90
        call    11b3h                                ; 11AF: CD B3 11
        ret                                          ; 11B2: C9
        push    bc                                   ; 11B3: C5
        ld      b,04h                                ; 11B4: 06 04
        call    15ebh                                ; 11B6: CD EB 15
        in      a,(80h)                              ; 11B9: DB 80
        and     01h                                  ; 11BB: E6 01
        jr      z,11cfh                              ; 11BD: 28 10
        ld      a,(420dh)                            ; 11BF: 3A 0D 42
        or      a                                    ; 11C2: B7
        jr      z,11b9h                              ; 11C3: 28 F4
        dec     b                                    ; 11C5: 05
        jr      nz,11b6h                             ; 11C6: 20 EE
        call    15fch                                ; 11C8: CD FC 15
        scf                                          ; 11CB: 37
        ccf                                          ; 11CC: 3F
        pop     bc                                   ; 11CD: C1
        ret                                          ; 11CE: C9
        call    15fch                                ; 11CF: CD FC 15
        scf                                          ; 11D2: 37
        pop     bc                                   ; 11D3: C1
        ret                                          ; 11D4: C9
        ld      a,01h                                ; 11D5: 3E 01
        out     (21h),a                              ; 11D7: D3 21
        xor     a                                    ; 11D9: AF
        out     (21h),a                              ; 11DA: D3 21
        ld      a,0ch                                ; 11DC: 3E 0C
        out     (20h),a                              ; 11DE: D3 20
        and     04h                                  ; 11E0: E6 04
        out     (20h),a                              ; 11E2: D3 20
        ret                                          ; 11E4: C9
        in      a,(80h)                              ; 11E5: DB 80
        srl     a                                    ; 11E7: CB 3F
        srl     a                                    ; 11E9: CB 3F
        and     03h                                  ; 11EB: E6 03
        ld      c,05h                                ; 11ED: 0E 05
        cp      03h                                  ; 11EF: FE 03
        jr      z,11ffh                              ; 11F1: 28 0C
        dec     c                                    ; 11F3: 0D
        cp      02h                                  ; 11F4: FE 02
        jr      z,11ffh                              ; 11F6: 28 07
        dec     c                                    ; 11F8: 0D
        cp      01h                                  ; 11F9: FE 01
        jr      z,11ffh                              ; 11FB: 28 02
        ld      c,01h                                ; 11FD: 0E 01
        ld      (ix+24h),c                           ; 11FF: DD 71 24
        xor     a                                    ; 1202: AF
        add     a,18h                                ; 1203: C6 18
        dec     c                                    ; 1205: 0D
        jr      nz,1203h                             ; 1206: 20 FB
        ld      (ix+28h),a                           ; 1208: DD 77 28
        ld      hl,0258h                             ; 120B: 21 58 02
        ld      (ix+22h),h                           ; 120E: DD 74 22
        ld      (ix+23h),l                           ; 1211: DD 75 23
        ld      hl,025dh                             ; 1214: 21 5D 02
        ld      (ix+26h),h                           ; 1217: DD 74 26
        ld      (ix+27h),l                           ; 121A: DD 75 27
        ld      a,18h                                ; 121D: 3E 18
        ld      (ix+25h),a                           ; 121F: DD 77 25
        xor     a                                    ; 1222: AF
        ld      (ix+29h),a                           ; 1223: DD 77 29
        ret                                          ; 1226: C9
        ld      b,04h                                ; 1227: 06 04
        call    15ebh                                ; 1229: CD EB 15
        ld      a,(420dh)                            ; 122C: 3A 0D 42
        or      a                                    ; 122F: B7
        jr      z,122ch                              ; 1230: 28 FA
        dec     b                                    ; 1232: 05
        jr      nz,1229h                             ; 1233: 20 F4
        ret                                          ; 1235: C9
        in      a,(80h)                              ; 1236: DB 80
        and     02h                                  ; 1238: E6 02
        xor     02h                                  ; 123A: EE 02
        scf                                          ; 123C: 37
        ret     z                                    ; 123D: C8
        call    15fch                                ; 123E: CD FC 15
        ret                                          ; 1241: C9
        or      04h                                  ; 1242: F6 04
        push    af                                   ; 1244: F5
        call    11b3h                                ; 1245: CD B3 11
        pop     bc                                   ; 1248: C1
        ret     nc                                   ; 1249: D0
        ld      a,06h                                ; 124A: 3E 06
        or      b                                    ; 124C: B0
        ld      c,a                                  ; 124D: 4F
        ld      a,b                                  ; 124E: 78
        out     (20h),a                              ; 124F: D3 20
        ld      d,01h                                ; 1251: 16 01
        dec     d                                    ; 1253: 15
        jr      nz,1253h                             ; 1254: 20 FD
        ld      a,c                                  ; 1256: 79
        out     (20h),a                              ; 1257: D3 20
        ld      a,b                                  ; 1259: 78
        out     (20h),a                              ; 125A: D3 20
        dec     hl                                   ; 125C: 2B
        ld      a,h                                  ; 125D: 7C
        ld      a,h                                  ; 125E: 7C
        or      l                                    ; 125F: B5
        jr      nz,1251h                             ; 1260: 20 EF
        ld      a,04h                                ; 1262: 3E 04
        out     (20h),a                              ; 1264: D3 20
        scf                                          ; 1266: 37
        ret                                          ; 1267: C9
        ld      hl,0ffffh                            ; 1268: 21 FF FF
        scf                                          ; 126B: 37
        ret     z                                    ; 126C: C8
        dec     hl                                   ; 126D: 2B
        ld      a,h                                  ; 126E: 7C
        or      l                                    ; 126F: B5
        ret     z                                    ; 1270: C8
        jr      126bh                                ; 1271: 18 F8
        dec     a                                    ; 1273: 3D
        cp      0ffh                                 ; 1274: FE FF
        jr      nz,127ch                             ; 1276: 20 04
        ld      a,(ix+25h)                           ; 1278: DD 7E 25
        dec     a                                    ; 127B: 3D
        push    af                                   ; 127C: F5
        ld      a,00h                                ; 127D: 3E 00
        ld      (4207h),a                            ; 127F: 32 07 42
        ld      hl,3998h                             ; 1282: 21 98 39
        ld      bc,0004h                             ; 1285: 01 04 00
        ld      a,00h                                ; 1288: 3E 00
        ld      (420fh),a                            ; 128A: 32 0F 42
        call    1324h                                ; 128D: CD 24 13
        pop     bc                                   ; 1290: C1
        ret     nc                                   ; 1291: D0
        ld      a,00h                                ; 1292: 3E 00
        ret     nz                                   ; 1294: C0
        push    bc                                   ; 1295: C5
        ld      a,(ix+25h)                           ; 1296: DD 7E 25
        sla     a                                    ; 1299: CB 27
        sla     a                                    ; 129B: CB 27
        ld      c,a                                  ; 129D: 4F
        ld      a,(4207h)                            ; 129E: 3A 07 42
        inc     a                                    ; 12A1: 3C
        ld      (4207h),a                            ; 12A2: 32 07 42
        cp      c                                    ; 12A5: B9
        scf                                          ; 12A6: 37
        jr      z,12dfh                              ; 12A7: 28 36
        ld      a,(420fh)                            ; 12A9: 3A 0F 42
        or      a                                    ; 12AC: B7
        jr      nz,1282h                             ; 12AD: 20 D3
        ld      a,(7331h)                            ; 12AF: 3A 31 73
        and     07h                                  ; 12B2: E6 07
        ld      b,a                                  ; 12B4: 47
        ld      a,(4201h)                            ; 12B5: 3A 01 42
        and     07h                                  ; 12B8: E6 07
        cp      b                                    ; 12BA: B8
        scf                                          ; 12BB: 37
        jr      nz,12dfh                             ; 12BC: 20 21
        ld      a,(7332h)                            ; 12BE: 3A 32 73
        ld      d,a                                  ; 12C1: 57
        ld      a,(7333h)                            ; 12C2: 3A 33 73
        ld      e,a                                  ; 12C5: 5F
        ld      hl,(4202h)                           ; 12C6: 2A 02 42
        xor     a                                    ; 12C9: AF
        sbc     hl,de                                ; 12CA: ED 52
        scf                                          ; 12CC: 37
        jr      nz,12dfh                             ; 12CD: 20 10
        ld      a,(7331h)                            ; 12CF: 3A 31 73
        srl     a                                    ; 12D2: CB 3F
        srl     a                                    ; 12D4: CB 3F
        srl     a                                    ; 12D6: CB 3F
        pop     bc                                   ; 12D8: C1
        cp      b                                    ; 12D9: B8
        scf                                          ; 12DA: 37
        ret     z                                    ; 12DB: C8
        push    bc                                   ; 12DC: C5
        jr      1282h                                ; 12DD: 18 A3
        pop     bc                                   ; 12DF: C1
        jr      nc,12e6h                             ; 12E0: 30 04
        xor     a                                    ; 12E2: AF
        dec     a                                    ; 12E3: 3D
        scf                                          ; 12E4: 37
        ret                                          ; 12E5: C9
        xor     a                                    ; 12E6: AF
        inc     a                                    ; 12E7: 3C
        scf                                          ; 12E8: 37
        ret                                          ; 12E9: C9
        push    bc                                   ; 12EA: C5
        ld      a,(ix+13h)                           ; 12EB: DD 7E 13
        and     60h                                  ; 12EE: E6 60
        sra     a                                    ; 12F0: CB 2F
        sra     a                                    ; 12F2: CB 2F
        ld      b,a                                  ; 12F4: 47
        ld      a,(4201h)                            ; 12F5: 3A 01 42
        or      b                                    ; 12F8: B0
        pop     bc                                   ; 12F9: C1
        push    bc                                   ; 12FA: C5
        ld      (4201h),a                            ; 12FB: 32 01 42
        sla     a                                    ; 12FE: CB 27
        sla     a                                    ; 1300: CB 27
        ld      b,a                                  ; 1302: 47
        ld      a,(4200h)                            ; 1303: 3A 00 42
        or      b                                    ; 1306: B0
        out     (90h),a                              ; 1307: D3 90
        pop     bc                                   ; 1309: C1
        ret                                          ; 130A: C9
        call    11b3h                                ; 130B: CD B3 11
        ret     nc                                   ; 130E: D0
        call    1236h                                ; 130F: CD 36 12
        ret     nz                                   ; 1312: C0
        di                                           ; 1313: F3
        call    136bh                                ; 1314: CD 6B 13
        ld      a,24h                                ; 1317: 3E 24
        out     (20h),a                              ; 1319: D3 20
        ld      a,04h                                ; 131B: 3E 04
        out     (20h),a                              ; 131D: D3 20
        ei                                           ; 131F: FB
        call    1236h                                ; 1320: CD 36 12
        ret                                          ; 1323: C9
        call    11b3h                                ; 1324: CD B3 11
        ret     nc                                   ; 1327: D0
        call    137bh                                ; 1328: CD 7B 13
        ld      a,14h                                ; 132B: 3E 14
        out     (20h),a                              ; 132D: D3 20
        ld      a,04h                                ; 132F: 3E 04
        out     (20h),a                              ; 1331: D3 20
        xor     a                                    ; 1333: AF
        scf                                          ; 1334: 37
        ret                                          ; 1335: C9
        ld      a,(ix+15h)                           ; 1336: DD 7E 15
        ld      (ix+1eh),a                           ; 1339: DD 77 1E
        ld      a,(ix+16h)                           ; 133C: DD 7E 16
        ld      (ix+1fh),a                           ; 133F: DD 77 1F
        xor     a                                    ; 1342: AF
        ld      (ix+1dh),a                           ; 1343: DD 77 1D
        ld      (ix+1ch),a                           ; 1346: DD 77 1C
        scf                                          ; 1349: 37
        ret                                          ; 134A: C9
program_io_controller:
        ld      hl,1355h                             ; 134B: 21 55 13
        ld      b,16h                                ; 134E: 06 16
        ld      c,00h                                ; 1350: 0E 00
        otir                                         ; 1352: ED B3
        ret                                          ; 1354: C9

; 134Bh sets HL=1355h, B=16h and C=00h, then OTIR sends these 22 bytes.
; Preserve as data; its device-specific meaning is not established here.
io_controller_otir_payload:
        db      083h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 079h, 00h, 00h, 00h ; 1355-135F
        db      00h, 054h, 0CEh, 050h, 0CEh, 080h, 0ADh, 00h, 00h, 08Ah, 0CFh ; 1360-136A

configure_io_channel:
        ld      a,00h                                ; 136B: 3E 00
        out     (50h),a                              ; 136D: D3 50
        ld      (4224h),hl                           ; 136F: 22 24 42
        ld      hl,6000h                             ; 1372: 21 00 60
        ld      (421ah),hl                           ; 1375: 22 1A 42
        jp      1388h                                ; 1378: C3 88 13
        ld      a,00h                                ; 137B: 3E 00
        out     (50h),a                              ; 137D: D3 50
        ld      (421ah),hl                           ; 137F: 22 1A 42
        ld      hl,6000h                             ; 1382: 21 00 60
        ld      (4224h),hl                           ; 1385: 22 24 42
        dec     bc                                   ; 1388: 0B
        ld      (421ch),bc                           ; 1389: ED 43 1C 42
        ld      hl,4212h                             ; 138D: 21 12 42
        ld      b,17h                                ; 1390: 06 17
        ld      c,00h                                ; 1392: 0E 00
        otir                                         ; 1394: ED B3
        ld      a,87h                                ; 1396: 3E 87
        out     (00h),a                              ; 1398: D3 00
        ret                                          ; 139A: C9
        xor     a                                    ; 139B: AF
        cp      c                                    ; 139C: B9
        jr      nz,13eah                             ; 139D: 20 4B
        inc     a                                    ; 139F: 3C
        cp      b                                    ; 13A0: B8
        jr      nz,13eah                             ; 13A1: 20 47
        ld      a,88h                                ; 13A3: 3E 88
        out     (50h),a                              ; 13A5: D3 50
        ld      a,79h                                ; 13A7: 3E 79
        ld      (733ah),a                            ; 13A9: 32 3A 73
        ld      (4230h),a                            ; 13AC: 32 30 42
        ld      (423bh),hl                           ; 13AF: 22 3B 42
        ld      (4231h),de                           ; 13B2: ED 53 31 42
        xor     a                                    ; 13B6: AF
        ex      de,hl                                ; 13B7: EB
        dec     bc                                   ; 13B8: 0B
        adc     hl,bc                                ; 13B9: ED 4A
        jp      m,13e3h                              ; 13BB: FA E3 13
        ld      hl,003fh                             ; 13BE: 21 3F 00
        ld      (4233h),hl                           ; 13C1: 22 33 42
        ld      hl,4229h                             ; 13C4: 21 29 42
        ld      b,17h                                ; 13C7: 06 17
        ld      c,00h                                ; 13C9: 0E 00
        otir                                         ; 13CB: ED B3
        ld      b,04h                                ; 13CD: 06 04
        ld      c,00h                                ; 13CF: 0E 00
        ld      a,87h                                ; 13D1: 3E 87
        ld      d,0b3h                               ; 13D3: 16 B3
        ld      e,0d3h                               ; 13D5: 1E D3
        jr      13ddh                                ; 13D7: 18 04
        out     (c),d                                ; 13D9: ED 51
        out     (c),e                                ; 13DB: ED 59
        out     (c),a                                ; 13DD: ED 79
        djnz    13d9h                                ; 13DF: 10 F8
        scf                                          ; 13E1: 37
        ret                                          ; 13E2: C9
        sbc     hl,bc                                ; 13E3: ED 42
        inc     bc                                   ; 13E5: 03
        ex      de,hl                                ; 13E6: EB
        jp      1437h                                ; 13E7: C3 37 14
        ld      a,88h                                ; 13EA: 3E 88
        out     (50h),a                              ; 13EC: D3 50
        ld      a,79h                                ; 13EE: 3E 79
        ld      (733ah),a                            ; 13F0: 32 3A 73
        jr      13feh                                ; 13F3: 18 09
        ld      a,88h                                ; 13F5: 3E 88
        out     (50h),a                              ; 13F7: D3 50
        ld      a,7dh                                ; 13F9: 3E 7D
        ld      (733ah),a                            ; 13FB: 32 3A 73
        inc     b                                    ; 13FE: 04
        dec     b                                    ; 13FF: 05
        jr      z,1426h                              ; 1400: 28 24
        push    bc                                   ; 1402: C5
        ld      bc,0100h                             ; 1403: 01 00 01
        push    de                                   ; 1406: D5
        push    hl                                   ; 1407: E5
        call    142ah                                ; 1408: CD 2A 14
        pop     hl                                   ; 140B: E1
        ld      de,0105h                             ; 140C: 11 05 01
        add     hl,de                                ; 140F: 19
        ex      (sp),hl                              ; 1410: E3
        ld      de,0100h                             ; 1411: 11 00 01
        add     hl,de                                ; 1414: 19
        bit     7,h                                  ; 1415: CB 7C
        jr      z,1421h                              ; 1417: 28 08
        res     7,h                                  ; 1419: CB BC
        ld      a,(ix+0dh)                           ; 141B: DD 7E 0D
        inc     a                                    ; 141E: 3C
        out     (30h),a                              ; 141F: D3 30
        ex      de,hl                                ; 1421: EB
        pop     hl                                   ; 1422: E1
        pop     bc                                   ; 1423: C1
        jr      13ffh                                ; 1424: 18 D9
        xor     a                                    ; 1426: AF
        or      c                                    ; 1427: B1
        scf                                          ; 1428: 37
        ret     z                                    ; 1429: C8
        ld      a,(733ah)                            ; 142A: 3A 3A 73
        ld      (4230h),a                            ; 142D: 32 30 42
        ld      (4231h),de                           ; 1430: ED 53 31 42
        ld      (423bh),hl                           ; 1434: 22 3B 42
        ld      hl,8000h                             ; 1437: 21 00 80
        xor     a                                    ; 143A: AF
        sbc     hl,de                                ; 143B: ED 52
        ex      de,hl                                ; 143D: EB
        ld      h,b                                  ; 143E: 60
        ld      l,c                                  ; 143F: 69
        xor     a                                    ; 1440: AF
        sbc     hl,de                                ; 1441: ED 52
        jr      c,1463h                              ; 1443: 38 1E
        jr      z,1463h                              ; 1445: 28 1C
        push    hl                                   ; 1447: E5
        push    de                                   ; 1448: D5
        ld      b,d                                  ; 1449: 42
        ld      c,e                                  ; 144A: 4B
        call    1463h                                ; 144B: CD 63 14
        ld      a,(ix+0dh)                           ; 144E: DD 7E 0D
        inc     a                                    ; 1451: 3C
        out     (30h),a                              ; 1452: D3 30
        ld      hl,0000h                             ; 1454: 21 00 00
        ld      (4231h),hl                           ; 1457: 22 31 42
        ld      hl,(423bh)                           ; 145A: 2A 3B 42
        pop     bc                                   ; 145D: C1
        add     hl,bc                                ; 145E: 09
        ld      (423bh),hl                           ; 145F: 22 3B 42
        pop     bc                                   ; 1462: C1
        xor     a                                    ; 1463: AF
        ld      d,a                                  ; 1464: 57
        ld      e,a                                  ; 1465: 5F
        or      c                                    ; 1466: B1
        jr      nz,1474h                             ; 1467: 20 0B
        ld      a,b                                  ; 1469: 78
        ld      b,c                                  ; 146A: 41
        add     a,a                                  ; 146B: 87
        rl      b                                    ; 146C: CB 10
        add     a,a                                  ; 146E: 87
        rl      b                                    ; 146F: CB 10
        ld      c,a                                  ; 1471: 4F
        jr      1497h                                ; 1472: 18 23
        ld      a,c                                  ; 1474: 79
        dec     a                                    ; 1475: 3D
        or      b                                    ; 1476: B0
        jr      z,14e6h                              ; 1477: 28 6D
        ld      d,06h                                ; 1479: 16 06
        ld      e,00h                                ; 147B: 1E 00
        xor     a                                    ; 147D: AF
        rr      b                                    ; 147E: CB 18
        rr      c                                    ; 1480: CB 19
        rr      e                                    ; 1482: CB 1B
        dec     d                                    ; 1484: 15
        jp      nz,147eh                             ; 1485: C2 7E 14
        srl     e                                    ; 1488: CB 3B
        srl     e                                    ; 148A: CB 3B
        ld      a,e                                  ; 148C: 7B
        or      a                                    ; 148D: B7
        jr      z,1497h                              ; 148E: 28 07
        dec     a                                    ; 1490: 3D
        jr      nz,1496h                             ; 1491: 20 03
        ld      e,41h                                ; 1493: 1E 41
        dec     bc                                   ; 1495: 0B
        dec     e                                    ; 1496: 1D
        push    de                                   ; 1497: D5
        push    bc                                   ; 1498: C5
        ld      hl,003fh                             ; 1499: 21 3F 00
        ld      (4233h),hl                           ; 149C: 22 33 42
        ld      hl,4229h                             ; 149F: 21 29 42
        ld      b,17h                                ; 14A2: 06 17
        ld      c,00h                                ; 14A4: 0E 00
        otir                                         ; 14A6: ED B3
        pop     bc                                   ; 14A8: C1
        ld      a,c                                  ; 14A9: 79
        or      b                                    ; 14AA: B0
        jp      z,14c1h                              ; 14AB: CA C1 14
        ld      b,c                                  ; 14AE: 41
        ld      c,00h                                ; 14AF: 0E 00
        ld      a,87h                                ; 14B1: 3E 87
        ld      d,0b3h                               ; 14B3: 16 B3
        ld      e,0d3h                               ; 14B5: 1E D3
        jr      14bdh                                ; 14B7: 18 04
        out     (c),d                                ; 14B9: ED 51
        out     (c),e                                ; 14BB: ED 59
        out     (c),a                                ; 14BD: ED 79
        djnz    14b9h                                ; 14BF: 10 F8
        pop     bc                                   ; 14C1: C1
        ld      a,b                                  ; 14C2: 78
        or      c                                    ; 14C3: B1
        scf                                          ; 14C4: 37
        ret     z                                    ; 14C5: C8
        ld      a,(733ah)                            ; 14C6: 3A 3A 73
        and     0e7h                                 ; 14C9: E6 E7
        out     (00h),a                              ; 14CB: D3 00
        ld      a,c                                  ; 14CD: 79
        out     (00h),a                              ; 14CE: D3 00
        ld      a,b                                  ; 14D0: 78
        out     (00h),a                              ; 14D1: D3 00
        ld      a,0b3h                               ; 14D3: 3E B3
        out     (00h),a                              ; 14D5: D3 00
        ld      a,0d3h                               ; 14D7: 3E D3
        out     (00h),a                              ; 14D9: D3 00
        ld      a,87h                                ; 14DB: 3E 87
        out     (00h),a                              ; 14DD: D3 00
        scf                                          ; 14DF: 37
        ret                                          ; 14E0: C9
        ld      a,87h                                ; 14E1: 3E 87
        out     (00h),a                              ; 14E3: D3 00
        ret                                          ; 14E5: C9
        ld      iy,4229h                             ; 14E6: FD 21 29 42
        ld      (iy+0ah),c                           ; 14EA: FD 71 0A
        ld      (iy+0bh),b                           ; 14ED: FD 70 0B
        ld      hl,4229h                             ; 14F0: 21 29 42
        ld      b,17h                                ; 14F3: 06 17
        ld      c,00h                                ; 14F5: 0E 00
        otir                                         ; 14F7: ED B3
        ld      a,(733ah)                            ; 14F9: 3A 3A 73
        cp      79h                                  ; 14FC: FE 79
        jr      nz,1531h                             ; 14FE: 20 31
        push    ix                                   ; 1500: DD E5
        ld      ix,733fh                             ; 1502: DD 21 3F 73
        ld      a,(iy+08h)                           ; 1506: FD 7E 08
        ld      (ix+03h),a                           ; 1509: DD 77 03
        ld      a,(iy+09h)                           ; 150C: FD 7E 09
        ld      (ix+04h),a                           ; 150F: DD 77 04
        ld      e,(iy+12h)                           ; 1512: FD 5E 12
        ld      d,(iy+13h)                           ; 1515: FD 56 13
        dec     de                                   ; 1518: 1B
        ld      (ix+0ah),e                           ; 1519: DD 73 0A
        ld      (ix+0bh),d                           ; 151C: DD 72 0B
        ld      de,0001h                             ; 151F: 11 01 00
        ld      (ix+05h),e                           ; 1522: DD 73 05
        ld      (ix+06h),d                           ; 1525: DD 72 06
        ld      hl,733fh                             ; 1528: 21 3F 73
        ld      b,0eh                                ; 152B: 06 0E
        otir                                         ; 152D: ED B3
        pop     ix                                   ; 152F: DD E1
        call    14e1h                                ; 1531: CD E1 14
        ret                                          ; 1534: C9
initialize_timer_counters:
        ld      a,0ffh                               ; 1535: 3E FF
        ld      (4205h),a                            ; 1537: 32 05 42
        ld      (4208h),a                            ; 153A: 32 08 42
        ld      a,l                                  ; 153D: 7D
        out     (10h),a                              ; 153E: D3 10
        ld      a,03h                                ; 1540: 3E 03
        out     (10h),a                              ; 1542: D3 10
        out     (11h),a                              ; 1544: D3 11
        out     (12h),a                              ; 1546: D3 12
        out     (13h),a                              ; 1548: D3 13
        ret                                          ; 154A: C9
interrupt_handler_1:
        push    af                                   ; 154B: F5
        ld      a,(4208h)                            ; 154C: 3A 08 42
        inc     a                                    ; 154F: 3C
        jr      z,1563h                              ; 1550: 28 11
        cp      (ix+25h)                             ; 1552: DD BE 25
        jr      c,1560h                              ; 1555: 38 09
        ld      a,(4206h)                            ; 1557: 3A 06 42
        inc     a                                    ; 155A: 3C
        ld      (4206h),a                            ; 155B: 32 06 42
        ld      a,00h                                ; 155E: 3E 00
        ld      (4208h),a                            ; 1560: 32 08 42
        ld      a,03h                                ; 1563: 3E 03
        out     (11h),a                              ; 1565: D3 11
        pop     af                                   ; 1567: F1
        ei                                           ; 1568: FB
        reti                                         ; 1569: ED 4D
interrupt_handler_2:
        push    af                                   ; 156B: F5
        ld      a,(4205h)                            ; 156C: 3A 05 42
        inc     a                                    ; 156F: 3C
        jr      z,1586h                              ; 1570: 28 14
        ld      a,00h                                ; 1572: 3E 00
        ld      (4208h),a                            ; 1574: 32 08 42
        ld      a,(4206h)                            ; 1577: 3A 06 42
        inc     a                                    ; 157A: 3C
        ld      (4206h),a                            ; 157B: 32 06 42
        ld      a,0c7h                               ; 157E: 3E C7
        out     (10h),a                              ; 1580: D3 10
        ld      a,01h                                ; 1582: 3E 01
        out     (10h),a                              ; 1584: D3 10
        pop     af                                   ; 1586: F1
        ei                                           ; 1587: FB
        reti                                         ; 1588: ED 4D
interrupt_handler_3:
        push    af                                   ; 158A: F5
        ld      a,03h                                ; 158B: 3E 03
        out     (12h),a                              ; 158D: D3 12
        pop     af                                   ; 158F: F1
        ei                                           ; 1590: FB
        reti                                         ; 1591: ED 4D
interrupt_handler_4:
        push    af                                   ; 1593: F5
        ld      a,(420eh)                            ; 1594: 3A 0E 42
        inc     a                                    ; 1597: 3C
        ld      (420eh),a                            ; 1598: 32 0E 42
        cp      2eh                                  ; 159B: FE 2E
        jr      c,15a8h                              ; 159D: 38 09
        ld      a,03h                                ; 159F: 3E 03
        out     (13h),a                              ; 15A1: D3 13
        ld      a,01h                                ; 15A3: 3E 01
        ld      (420dh),a                            ; 15A5: 32 0D 42
        pop     af                                   ; 15A8: F1
        ei                                           ; 15A9: FB
        reti                                         ; 15AA: ED 4D
        ld      b,a                                  ; 15AC: 47
        ld      a,0c7h                               ; 15AD: 3E C7
        out     (11h),a                              ; 15AF: D3 11
        ld      a,01h                                ; 15B1: 3E 01
        out     (11h),a                              ; 15B3: D3 11
        xor     a                                    ; 15B5: AF
        ld      (4205h),a                            ; 15B6: 32 05 42
        ld      (4206h),a                            ; 15B9: 32 06 42
        call    15ebh                                ; 15BC: CD EB 15
        ld      a,(4208h)                            ; 15BF: 3A 08 42
        cp      b                                    ; 15C2: B8
        jr      z,15dbh                              ; 15C3: 28 16
        ld      a,(420dh)                            ; 15C5: 3A 0D 42
        or      a                                    ; 15C8: B7
        jr      z,15bfh                              ; 15C9: 28 F4
        call    15fch                                ; 15CB: CD FC 15
        ld      a,0ffh                               ; 15CE: 3E FF
        ld      (4205h),a                            ; 15D0: 32 05 42
        ld      (4208h),a                            ; 15D3: 32 08 42
        ld      a,03h                                ; 15D6: 3E 03
        out     (10h),a                              ; 15D8: D3 10
        ret                                          ; 15DA: C9
        call    15fch                                ; 15DB: CD FC 15
        ld      a,0ffh                               ; 15DE: 3E FF
        ld      (4205h),a                            ; 15E0: 32 05 42
        ld      (4208h),a                            ; 15E3: 32 08 42
        ld      a,03h                                ; 15E6: 3E 03
        out     (10h),a                              ; 15E8: D3 10
        ret                                          ; 15EA: C9
clear_timer_interrupts:
        ld      a,00h                                ; 15EB: 3E 00
        ld      (420dh),a                            ; 15ED: 32 0D 42
        ld      (420eh),a                            ; 15F0: 32 0E 42
        ld      a,0a7h                               ; 15F3: 3E A7
        out     (13h),a                              ; 15F5: D3 13
        ld      a,0ffh                               ; 15F7: 3E FF
        out     (13h),a                              ; 15F9: D3 13
        ret                                          ; 15FB: C9
enable_timer_interrupts:
        di                                           ; 15FC: F3
        ld      a,03h                                ; 15FD: 3E 03
        out     (13h),a                              ; 15FF: D3 13
        ei                                           ; 1601: FB
        ret                                          ; 1602: C9
select_and_jump:
        ld      a,0ffh                               ; 1603: 3E FF
        out     (22h),a                              ; 1605: D3 22
        ld      a,0c0h                               ; 1607: 3E C0
        out     (22h),a                              ; 1609: D3 22
        ld      a,l                                  ; 160B: 7D
        out     (22h),a                              ; 160C: D3 22
        ld      a,0b7h                               ; 160E: 3E B7
        out     (22h),a                              ; 1610: D3 22
        ld      a,7fh                                ; 1612: 3E 7F
        out     (22h),a                              ; 1614: D3 22
        xor     a                                    ; 1616: AF
        out     (20h),a                              ; 1617: D3 20
        ld      a,0ffh                               ; 1619: 3E FF
        out     (23h),a                              ; 161B: D3 23
        ld      a,0feh                               ; 161D: 3E FE
        out     (23h),a                              ; 161F: D3 23
        ex      de,hl                                ; 1621: EB
        jp      (hl)                                 ; 1622: E9
interrupt_handler_5:
        push    af                                   ; 1623: F5
        ld      a,01h                                ; 1624: 3E 01
        ld      (420fh),a                            ; 1626: 32 0F 42
        pop     af                                   ; 1629: F1
        ei                                           ; 162A: FB
        reti                                         ; 162B: ED 4D

; Remaining bytes are erased EPROM fill, confirmed FFh through the end of image.
        org     162Dh
erased_eprom_fill:
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 162D-163B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 163C-164B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 164C-165B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 165C-166B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 166C-167B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 167C-168B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 168C-169B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 169C-16AB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16AC-16BB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16BC-16CB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16CC-16DB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16DC-16EB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16EC-16FB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 16FC-170B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 170C-171B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 171C-172B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 172C-173B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 173C-174B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 174C-175B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 175C-176B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 176C-177B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 177C-178B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 178C-179B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 179C-17AB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17AC-17BB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17BC-17CB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17CC-17DB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17DC-17EB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17EC-17FB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 17FC-180B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 180C-181B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 181C-182B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 182C-183B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 183C-184B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 184C-185B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 185C-186B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 186C-187B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 187C-188B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 188C-189B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 189C-18AB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18AC-18BB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18BC-18CB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18CC-18DB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18DC-18EB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18EC-18FB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 18FC-190B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 190C-191B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 191C-192B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 192C-193B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 193C-194B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 194C-195B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 195C-196B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 196C-197B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 197C-198B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 198C-199B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 199C-19AB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19AC-19BB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19BC-19CB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19CC-19DB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19DC-19EB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19EC-19FB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 19FC-1A0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A0C-1A1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A1C-1A2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A2C-1A3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A3C-1A4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A4C-1A5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A5C-1A6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A6C-1A7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A7C-1A8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A8C-1A9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1A9C-1AAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1AAC-1ABB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1ABC-1ACB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1ACC-1ADB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1ADC-1AEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1AEC-1AFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1AFC-1B0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B0C-1B1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B1C-1B2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B2C-1B3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B3C-1B4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B4C-1B5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B5C-1B6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B6C-1B7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B7C-1B8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B8C-1B9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1B9C-1BAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BAC-1BBB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BBC-1BCB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BCC-1BDB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BDC-1BEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BEC-1BFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1BFC-1C0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C0C-1C1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C1C-1C2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C2C-1C3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C3C-1C4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C4C-1C5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C5C-1C6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C6C-1C7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C7C-1C8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C8C-1C9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1C9C-1CAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CAC-1CBB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CBC-1CCB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CCC-1CDB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CDC-1CEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CEC-1CFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1CFC-1D0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D0C-1D1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D1C-1D2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D2C-1D3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D3C-1D4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D4C-1D5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D5C-1D6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D6C-1D7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D7C-1D8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D8C-1D9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1D9C-1DAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DAC-1DBB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DBC-1DCB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DCC-1DDB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DDC-1DEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DEC-1DFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1DFC-1E0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E0C-1E1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E1C-1E2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E2C-1E3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E3C-1E4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E4C-1E5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E5C-1E6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E6C-1E7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E7C-1E8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E8C-1E9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1E9C-1EAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1EAC-1EBB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1EBC-1ECB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1ECC-1EDB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1EDC-1EEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1EEC-1EFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1EFC-1F0B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F0C-1F1B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F1C-1F2B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F2C-1F3B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F3C-1F4B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F4C-1F5B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F5C-1F6B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F6C-1F7B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F7C-1F8B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F8C-1F9B: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1F9C-1FAB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1FAC-1FBB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1FBC-1FCB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1FCC-1FDB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1FDC-1FEB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; 1FEC-1FFB: FF
        db      0FFh, 0FFh, 0FFh, 0FFh ; 1FFC-1FFF: FF

; Reconciled WDC 8 KiB Z80 firmware listing.
; Byte authority: firmware.bin; ROM file offset equals CPU address 0000h-1FFFh.
; The image is exactly u27.bin at 0000h-0FFFh followed by u28.bin at 1000h-1FFFh.
; Data blocks are emitted as bytes/words where control flow or direct transfer proves
; they are not instructions. Original addresses and instruction bytes are omitted.
; Symbolic routine names are descriptive navigation aids, not recovered original names.
; Board map: 0000h-1FFFh EPROM, 4000h-7FFFh SRAM, C000h-FFFFh I/O space.
; The separate 512-byte PROMs are not part of firmware.bin.

; Offsets in the host command snapshot stored at IX+1 through IX+0F.
WDC_EVENT_CMD:             equ     01h
WDC_EVENT_DRV:             equ     02h
WDC_EVENT_HEAD:            equ     03h
WDC_EVENT_CYL_LO:          equ     04h
WDC_EVENT_CYL_HI:          equ     05h
WDC_EVENT_SECTOR:          equ     06h
WDC_EVENT_TRANSWRD_CNT_LO: equ     09h
WDC_EVENT_TRANSWRD_CNT_HI: equ     0Ah
WDC_EVENT_TRANSADDR_B0:    equ     0Bh
WDC_EVENT_TRANSADDR_B1:    equ     0Ch
WDC_EVENT_TRANSADDR_B2:    equ     0Dh

        org     0000h
reset_vector:
        jp      rom_entry

; 0003h-0004h are not executed after the reset JP; retain them without a semantic claim.
        org     0003h
unclassified_boot_bytes:
        db      061h, 011h
        org     0005h
copyright_text:
        db      "Copyright Zilog, Inc. 1981", 0FFh

; IM 2 vectors: the vector-byte offsets 20h,22h,24h,26h,28h select these words.
interrupt_vector_table:
        dw      interrupt_handler_1
        dw      interrupt_handler_2
        dw      interrupt_handler_3
        dw      interrupt_handler_4
        dw      interrupt_handler_5
rom_entry:
        ld      hl,0028h
        ld      de,0033h
        jp      select_and_jump
startup_stage_2:
        ld      a,04h
        out     (20h),a
        ld      hl,003dh
        jp      startup_dispatch
application_entry:
        ld      sp,41ffh
        call    00c9h
main_loop_entry:
        ld      sp,41ffh
input_wait_loop:
        in      a,(21h)
        cpl
        and     10h
        jr      nz,0055h
        ld      a,(733dh)
        or      a
        jr      nz,005bh
        jr      0046h
process_input_event:
        call    0061h
        call    nz,00c4h
        call    0160h
        jp      main_loop_entry
scan_input_event:
        ld      hl,75c4h
        in      a,(60h)
        and     1fh
        cp      00h
        jr      z,00a5h
        cp      0ch
        jr      z,00a5h
        cp      15h
        jr      z,00a5h
        cp      16h
        jr      z,00a5h
        cp      0eh
        jp      z,rom_entry
        in      a,(61h)
        cp      04h
        jp      m,build_input_mask
        in      a,(60h)
        and     20h
        call    00c4h
        ld      e,0fh
        ld      b,08h
        call    nz,042dh
        xor     a
        ret
build_input_mask:
        ld      de,002ah
        ld      b,a
        ld      a,01h
        inc     b
        dec     b
        jr      z,00a2h
        add     a,a
        add     hl,de
        jr      009bh
        ld      b,a
        jr      00a7h
        ld      b,01h
        ld      a,(hl)
        cp      00h
        ret     nz
record_input_event:
        ld      a,(733dh)
        or      b
        ld      (733dh),a
        ld      a,01h
        ld      (hl),a
        inc     hl
        ld      c,5fh
        ld      b,0fh
        inc     c
        ini
        jr      nz,00bah
        ld      a,91h
        out     (70h),a
        ret
write_control_9a:
        ld      a,9ah
        out     (70h),a
        ret
initialize_runtime:
        ld      a,01h
        ld      (733bh),a
        ld      hl,0020h
        ld      a,h
        ld      i,a
        call    1535h
        call    0d0ah
        call    134bh
        ld      a,91h
        out     (70h),a
        im      2
        ei
        ld      hl,003ch
loc_00E7:
        call    15ebh
loc_00EA:
        ld      a,(420dh)
        or      a
        jp      z,loc_00EA
        xor     a
        ld      (420dh),a
        dec     hl
        ld      a,h
        or      l
        jp      nz,loc_00E7
        call    15fch
        ld      a,04h
        push    af
        ld      ix,766ch
        pop     af
        dec     a
        jp      m,loc_0156
        push    af
        ld      de,002ah
        push    ix
        pop     hl
        xor     a
        sbc     hl,de
        push    hl
        pop     ix
        pop     af
        push    af
        ld      (ix+WDC_EVENT_DRV),a
        ld      a,44h
        ld      (ix+WDC_EVENT_CMD),a
        call    03c5h
        ld      a,c
        cp      00h
        jr      nz,013bh
        ld      a,52h
        ld      (ix+WDC_EVENT_CMD),a
        call    070eh
        ld      a,c
        cp      00h
        jr      z,0105h
        call    11e5h
        jr      0105h
        xor     a
        ld      (ix+22h),a
        ld      (ix+23h),a
        ld      (ix+24h),a
        ld      (ix+25h),a
        ld      (ix+26h),a
        ld      (ix+27h),a
        ld      (ix+28h),a
        ld      (ix+29h),a
        jr      0105h
loc_0156:
        ld      a,01h
        ld      (75c0h),a
        xor     a
        ld      (733bh),a
        ret
service_pending_event:
        ld      ix,(75c2h)
        ld      de,002ah
        add     ix,de
        ld      (75c2h),ix
        ld      a,(ix+00h)
        xor     0ffh
        jr      nz,017ch
        ld      ix,75c4h
        ld      (75c2h),ix
        ld      a,(ix+00h)
        cp      00h
        ret     z
        ld      a,0ffh
        ld      (733eh),a
        ld      a,(ix+00h)
        cp      05h
        jp      nc,invalid_state_fallback
        ld      hl,088dh
        rlca
        ld      c,a
        ld      b,00h
        add     hl,bc
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        jp      (hl)
invalid_state_fallback:
        ld      b,08h
        ld      c,00h
        jp      clear_device_event
        ret
dispatch_device_state:
        ld      a,(ix+12h)
        ld      (ix+13h),a
loc_01AA:
        ld      hl,0895h
        ld      a,(ix+WDC_EVENT_CMD)
        and     1fh
        cp      18h
        jp      nc,invalid_state_fallback
        rlca
        ld      c,a
        ld      b,00h
        add     hl,bc
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        jp      (hl)
        ld      a,(ix+14h)
        dec     a
        ld      (ix+14h),a
        jp      nz,loc_01AA
        ld      (ix+14h),06h
        ld      a,(ix+13h)
        call    06f3h
        ld      (ix+13h),a
        cp      (ix+12h)
        jp      z,complete_device_state
        jp      loc_01AA
        jp      loc_01AA
opcode_05_handler:
        ld      a,(ix+WDC_EVENT_DRV)
        call    08ddh
        jp      nc,status_error_nc
        jr      z,01f7h
        cp      01h
        jp      z,status_error_z
        jp      status_error_minus
        call    10b4h
        xor     a
        or      b
        jp      z,loc_073E
        ld      c,03h
        ld      b,01h
        jp      clear_device_event
opcode_11_handler:
        jp      invalid_state_fallback
opcode_10_handler:
        jp      invalid_state_fallback
command_01_handler:
        ld      a,(ix+WDC_EVENT_TRANSWRD_CNT_LO)
        or      (ix+WDC_EVENT_TRANSWRD_CNT_HI)
        jp      z,finish_device_event
        call    0ef7h
        jp      nc,invalid_state_fallback
        ld      a,00h
        ld      (420fh),a
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        call    0f2ah
        call    0542h
        jp      nc,status_error_nc
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        ld      c,(ix+18h)
        ld      b,(ix+19h)
        xor     a
        rr      d
        rr      e
        exx
        call    12eah
        ld      a,(4204h)
        call    1273h
        jp      nc,status_error_nc
        jr      z,0259h
        or      a
        jp      z,status_error_z
        inc     a
        jp      z,status_error_minus
        jp      status_error_overflow
        ld      hl,2120h
        ld      c,(ix+18h)
        ld      b,(ix+19h)
        call    0e90h
        push    bc
        call    1324h
        pop     bc
        jp      nc,status_error_nc
        jp      nz,status_error_z
        ld      a,(420fh)
        or      a
        jp      nz,loc_029E
        ld      a,b
        ld      iy,4240h
        call    10d4h
        jp      nc,status_error_overflow
        exx
        ld      hl,2124h
        call    139bh
        jp      nc,status_error_nc
        call    0fcbh
        jp      nc,invalid_state_fallback
        jp      nz,command_01_handler
        ld      a,(ix+WDC_EVENT_DRV)
        ld      (733eh),a
        jp      finish_device_event
loc_029E:
        ld      a,(ix+WDC_EVENT_CMD)
        and     40h
        jp      nz,complete_device_state
        ld      a,(ix+00h)
        cp      02h
        jr      nz,02b3h
        ld      a,20h
        ld      (ix+17h),a
        ret
        ld      a,(733dh)
        or      80h
        ld      (733dh),a
        ld      a,02h
        ld      (ix+00h),a
        ld      a,06h
        ld      (ix+14h),a
        ret
complete_device_state:
        ld      b,01h
        ld      c,20h
        jp      clear_device_event
        ld      a,(4201h)
        call    12fah
        exx
        ld      hl,2124h
        call    13f5h
        jr      0325h
opcode_02_handler:
loc_02DC:
        ld      a,(ix+WDC_EVENT_TRANSWRD_CNT_LO)
        or      (ix+WDC_EVENT_TRANSWRD_CNT_HI)
        jp      z,finish_device_event
        call    0ef7h
        jp      nc,invalid_state_fallback
        ld      a,(ix+11h)
        cp      03h
        jp      nz,loc_02FA
        ld      b,01h
        ld      c,04h
        jp      clear_device_event
loc_02FA:
        call    0f2ah
        call    0542h
        jp      nc,status_error_nc
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        ld      hl,2124h
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        xor     a
        rr      d
        rr      e
        ld      c,(ix+18h)
        ld      b,(ix+19h)
        call    13f5h
        ld      a,(4201h)
        call    12fah
        ld      iy,4240h
        ld      b,(ix+19h)
        ld      c,(ix+18h)
        xor     a
        or      c
        jr      z,0334h
        inc     b
        ld      a,b
        call    0e2fh
        ld      a,(4204h)
        call    1273h
        jp      nc,status_error_nc
        jr      z,034eh
        or      a
        jp      z,status_error_z
        inc     a
        jp      z,status_error_minus
        jp      status_error_overflow
        ld      hl,2120h
        ld      c,(ix+18h)
        ld      b,(ix+19h)
        call    0e90h
        call    130bh
        jp      nc,status_error_nc
        jp      nz,status_error_z
        call    0fcbh
        jp      nc,invalid_state_fallback
        jp      nz,loc_02DC
        ld      a,(ix+WDC_EVENT_DRV)
        ld      (733eh),a
        jp      finish_device_event
opcode_03_handler:
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        ld      a,00h
        ld      (ix+1ch),a
        ld      (ix+1dh),a
        ld      (ix+1eh),a
        ld      (ix+1fh),a
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jr      nc,0395h
        call    1336h
        jr      c,039dh
        ld      b,10h
        jr      039fh
        ld      b,40h
        jr      039fh
        ld      b,00h
        ld      a,b
        or      (ix+20h)
        ld      (ix+20h),a
        push    ix
        pop     hl
        ld      de,001ch
        add     hl,de
        rr      h
        rr      l
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        xor     a
        rr      d
        rr      e
        ld      bc,0003h
        call    139bh
        jp      finish_device_event
opcode_04_handler:
initialize_device_record:
        call    10b4h
        xor     a
        ld      (ix+15h),a
        ld      (ix+16h),a
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    11d5h
        call    1227h
        jp      finish_device_event
opcode_00_handler:
finish_device_event:
        ld      a,(ix+00h)
        cp      03h
        jr      z,03ech
        cp      02h
        jr      nz,03f4h
        ld      b,04h
        ld      c,(ix+17h)
        jp      clear_device_event
        ld      b,00h
        ld      c,00h
clear_device_event:
        ld      a,00h
        ld      (ix+00h),a
        ld      d,(ix+WDC_EVENT_DRV)
        ld      e,d
        inc     d
        ld      a,01h
        dec     d
        jr      z,040ah
        add     a,a
        jr      0404h
        cpl
        ld      d,a
        ld      a,(733dh)
        and     d
        and     0fh
        ld      (733dh),a
        ld      a,(733bh)
        or      a
        ret     nz
        call    047bh
        jr      z,0426h
        ld      (ix+20h),c
        xor     a
        ld      (ix+21h),a
        ld      a,(ix+WDC_EVENT_CMD)
        and     20h
        jr      z,0460h
transfer_port_data:
        in      a,(21h)
        and     20h
        jr      nz,042dh
        ld      a,e
        add     a,a
        add     a,a
        add     a,a
        add     a,a
        or      b
        ld      b,a
        out     (41h),a
        in      a,(21h)
        and     20h
        jr      nz,0460h
        call    15ebh
        ld      a,b
        out     (41h),a
        in      a,(21h)
        and     20h
        jr      nz,045dh
        ld      a,(420dh)
        or      a
        jr      z,0445h
        ld      a,10h
        or      (ix+20h)
        ld      c,a
        ld      (ix+20h),a
        call    15fch
        xor     a
        or      c
        jr      z,0466h
        ld      a,04h
        or      98h
        ld      c,a
        ld      a,b
        and     0fh
        cp      08h
        ld      a,c
        jr      z,0476h
        or      01h
        out     (70h),a
        ret
        or      02h
        out     (70h),a
        ret
query_channel_state:
        ld      a,c
        cp      09h
        jr      z,048eh
        cp      21h
        jr      z,0495h
        cp      03h
        ret     nz
        ld      a,01h
        ld      (ix+21h),a
        jr      049ah
        ld      a,04h
        ld      (ix+21h),a
        jr      049ah
        ld      a,02h
        ld      (ix+21h),a
        xor     a
        ld      (ix+20h),a
        ret
status_error_nc:
        ld      c,10h
        jp      loc_04E5
status_error_z:
        ld      c,80h
        jp      loc_04E5
        ld      c,40h
        jp      loc_04E5
status_error_minus:
        ld      a,(ix+00h)
        cp      02h
        jp      z,loc_029E
        ld      c,08h
        jp      loc_04E5
status_error_overflow:
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    09e8h
        jp      nc,status_error_nc
        jr      nz,04d4h
        call    0a3bh
        ld      c,09h
        jp      loc_04E5
        cp      01h
        jp      z,status_error_z
        cp      02h
        jp      z,status_error_minus
        ld      b,01h
        ld      c,09h
        jp      clear_device_event
loc_04E5:
        ld      b,01h
        ld      (ix+17h),c
        ld      a,(ix+WDC_EVENT_CMD)
        and     40h
        jp      nz,clear_device_event
        ld      a,(ix+00h)
        cp      03h
        jp      z,clear_device_event
        ld      (ix+1ah),a
        ld      a,03h
        ld      (ix+00h),a
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    11d5h
        call    1227h
        xor     a
        ld      (ix+15h),a
        ld      (ix+16h),a
        ld      a,(733dh)
        or      80h
        ld      (733dh),a
        ld      a,(ix+1ah)
        cp      02h
        ret     nz
        ld      (ix+00h),a
        ret
opcode_06_handler:
        call    0f05h
        jp      nc,invalid_state_fallback
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    0552h
        jp      nc,status_error_nc
        jp      finish_device_event
transfer_controller_data:
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        ret     nc
        ld      a,(ix+WDC_EVENT_CMD)
        and     80h
        xor     80h
        scf
        ret     z
        ld      l,(ix+WDC_EVENT_CYL_LO)
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      (75b1h),hl
        ld      (4202h),hl
        ld      a,(ix+WDC_EVENT_HEAD)
        ld      (75b3h),a
        ld      (4201h),a
        ld      a,(ix+WDC_EVENT_SECTOR)
        ld      (75b4h),a
        ld      (4204h),a
        call    104fh
        ld      hl,(4202h)
        ex      de,hl
        ld      h,(ix+15h)
        ld      l,(ix+16h)
        xor     a
        sbc     hl,de
        jr      nc,058fh
        push    de
        ex      de,hl
        ld      d,(ix+15h)
        ld      e,(ix+16h)
        xor     a
        inc     a
        sbc     hl,de
        pop     de
        ld      b,a
        ld      a,h
        or      l
        ld      a,b
        jr      z,059fh
        ld      (ix+15h),d
        ld      (ix+16h),e
        call    1242h
        ret     nc
        xor     a
        scf
        ret
opcode_07_handler:
        ld      a,(ix+WDC_EVENT_HEAD)
        ld      (ix+12h),a
        jp      finish_device_event
opcode_08_handler:
        jp      invalid_state_fallback
opcode_09_handler:
        jp      invalid_state_fallback
opcode_0A_handler:
        jp      invalid_state_fallback
opcode_0B_handler:
        call    0ef7h
        jp      nc,invalid_state_fallback
        ld      a,00h
        ld      (420fh),a
        call    0542h
        jp      nc,status_error_nc
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        call    11b3h
        jp      nc,status_error_nc
        call    12eah
        ld      a,(4204h)
        call    15ach
        jp      nz,status_error_minus
        ld      hl,2120h
        ld      bc,0105h
        call    1324h
        jp      nc,status_error_nc
        jp      nz,status_error_z
        ld      hl,4440h
        ld      de,444ah
        ld      bc,000ah
        ldir
        ld      hl,2120h
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        ld      bc,0105h
        xor     a
        rr      d
        rr      e
        call    139bh
        jp      nc,status_error_nc
        jp      finish_device_event
opcode_17_handler:
        ld      a,(ix+WDC_EVENT_SECTOR)
        ld      (420ah),a
        and     1fh
        ld      (ix+WDC_EVENT_SECTOR),a
        ld      (4204h),a
        call    0ef7h
        jp      nc,invalid_state_fallback
        xor     a
        ld      (75b5h),a
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      l,(ix+WDC_EVENT_CYL_LO)
        ld      (4202h),hl
        call    0576h
        jp      nc,status_error_nc
        call    11b3h
        jp      nc,status_error_nc
        ld      a,(ix+WDC_EVENT_HEAD)
        ld      (4201h),a
        call    12fah
        ld      a,(4204h)
        call    15ach
        jp      nz,status_error_minus
        ld      hl,2120h
        ld      bc,0105h
        call    1324h
        jp      nc,status_error_nc
        jp      nz,status_error_z
        ld      a,(420ah)
        bit     7,a
        jr      z,066ah
        ld      a,0ffh
        ld      (75b5h),a
        ld      iy,4240h
        ld      a,01h
        call    0e2fh
        xor     a
        ld      (75b5h),a
        ld      a,(4204h)
        call    15ach
        jp      nz,status_error_minus
        ld      hl,2120h
        ld      bc,0105h
        call    130bh
        jp      nc,status_error_nc
        jp      nz,status_error_z
        jp      finish_device_event
opcode_0C_handler:
        ld      a,(ix+WDC_EVENT_SECTOR)
        out     (40h),a
        jp      finish_device_event
opcode_0D_handler:
        jp      invalid_state_fallback
opcode_0E_handler:
startup_dispatch:
        exx
        di
        ld      a,01h
        ex      af,af'
        ld      a,(08cbh)
        ld      hl,4000h
        ld      (hl),a
        ld      de,4001h
        ld      bc,36afh
        ldir
        ld      hl,4000h
        ld      bc,36b0h
        cp      (hl)
        jr      nz,06cch
        inc     hl
        dec     bc
        ld      e,a
        ld      a,b
        or      c
        ld      a,e
        jr      nz,06b7h
        ex      af,af'
        dec     a
        jr      nz,06d2h
        ex      af,af'
        ld      a,(08ceh)
        jr      06a5h
        ld      a,0bh
        out     (70h),a
        jr      06cch
        ei
        exx
        jp      (hl)
opcode_0F_handler:
        xor     a
        ld      (75c0h),a
        ld      h,(ix+15h)
        ld      l,(ix+16h)
        ld      (ix+WDC_EVENT_CYL_HI),h
        ld      (ix+WDC_EVENT_CYL_LO),l
        jp      finish_device_event
opcode_14_handler:
        ld      a,01h
        ld      (75c0h),a
        call    10b4h
        jp      finish_device_event
update_channel_value:
        ld      hl,0889h
        ld      b,a
loc_06F7:
        ld      a,(hl)
        inc     hl
        cp      b
        jp      z,loc_0705
        xor     0ffh
        jp      nz,loc_06F7
        scf
        ccf
        ret
loc_0705:
        ld      a,(hl)
        cp      0ffh
        scf
        ret     nz
        ld      a,(0889h)
        ret
opcode_12_handler:
read_controller_state:
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    09e8h
        jp      nc,status_error_nc
        jr      nz,072fh
        ld      a,(ix+WDC_EVENT_DRV)
        call    0a3bh
        call    10b4h
        ld      c,00h
        ld      b,00h
        jp      clear_device_event
        cp      01h
        jp      z,status_error_z
        cp      02h
        jp      z,status_error_minus
        ld      c,21h
        jp      loc_04E5
opcode_13_handler:
loc_073E:
        ld      a,(ix+WDC_EVENT_DRV)
        call    11aah
        jp      nc,status_error_nc
        call    11e5h
        call    0a64h
        xor     a
        ld      (75bfh),a
        ld      hl,0000h
        ld      (75b1h),hl
        inc     hl
        ld      (4202h),hl
        ld      a,(ix+24h)
        dec     a
        ld      (75b3h),a
        ld      a,(ix+25h)
        dec     a
        ld      (75b4h),a
        ld      hl,(4202h)
        ld      d,(ix+26h)
        ld      e,(ix+27h)
        xor     a
        sbc     hl,de
        jp      z,loc_07D9
        xor     a
        ld      (4204h),a
        ld      (4201h),a
        ld      hl,(4202h)
        call    0576h
        jp      nc,status_error_nc
        call    11b3h
        jp      nc,status_error_nc
        ld      a,(4201h)
        call    12fah
        ld      a,(ix+25h)
        ld      hl,0000h
        ld      bc,0105h
        add     hl,bc
        dec     a
        jr      nz,079dh
        push    hl
        xor     a
        ld      (420fh),a
        ld      a,(4204h)
        call    15ach
        pop     bc
        jp      nz,status_error_minus
        ld      hl,2120h
        call    1324h
        jp      nc,status_error_nc
        jp      nz,status_error_z
        call    1174h
        ld      c,03h
        jp      nc,loc_04E5
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        cp      (ix+24h)
        jr      nz,0791h
        ld      hl,(4202h)
        inc     hl
        ld      (4202h),hl
        jr      076ch
loc_07D9:
        ld      h,(ix+26h)
        ld      l,(ix+27h)
        ld      (75b1h),hl
        xor     a
        ld      (75b3h),a
        dec     a
        ld      (75b4h),a
        call    0a88h
        ld      a,(ix+WDC_EVENT_DRV)
        call    0966h
        jp      nc,status_error_nc
        jp      z,finish_device_event
        cp      01h
        jp      z,status_error_z
        jp      status_error_minus
opcode_15_handler:
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        ld      hl,4240h
        ld      a,(0003h)
        ld      (hl),a
        inc     hl
        ld      a,(0004h)
        ld      (hl),a
        inc     hl
        ld      de,0018h
        xor     a
        rr      d
        rr      e
        ld      (hl),d
        inc     hl
        ld      (hl),e
        ld      hl,2120h
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        xor     a
        rr      d
        rr      e
        ld      bc,0002h
        call    139bh
        jp      finish_device_event
command_16_handler:
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        out     (30h),a
        push    ix
        ld      ix,75c4h
        ld      bc,002ah
        ld      hl,4240h
        ld      a,04h
        ld      e,(ix+22h)
        ld      (hl),e
        inc     hl
        ld      e,(ix+23h)
        ld      (hl),e
        inc     hl
        ld      e,(ix+24h)
        ld      (hl),e
        inc     hl
        ld      e,(ix+25h)
        ld      (hl),e
        inc     hl
        ld      e,(ix+26h)
        ld      (hl),e
        inc     hl
        ld      e,(ix+27h)
        ld      (hl),e
        inc     hl
        add     ix,bc
        dec     a
        jr      nz,0848h
        pop     ix
        ld      hl,2120h
        ld      e,(ix+WDC_EVENT_TRANSADDR_B0)
        ld      d,(ix+WDC_EVENT_TRANSADDR_B1)
        xor     a
        rr      d
        rr      e
        ld      bc,0018h
        xor     a
        rr      b
        rr      c
        call    139bh
        jp      finish_device_event
        nop
        jr      nz,08cch
        rst     38h

; Computed dispatch tables (little-endian word targets). The state table has
; five entries; its entry #4 at 0895h is also the first opcode-table word.
state_dispatch_table:
        dw      01A3h, 01A4h, 01C1h, 01E1h
opcode_dispatch_table:
        dw      opcode_00_handler, command_01_handler, opcode_02_handler
        dw      opcode_03_handler, opcode_04_handler, opcode_05_handler
        dw      opcode_06_handler, opcode_07_handler, opcode_08_handler
        dw      opcode_09_handler, opcode_0A_handler, opcode_0B_handler
        dw      opcode_0C_handler, opcode_0D_handler, opcode_0E_handler
        dw      opcode_0F_handler, opcode_10_handler, opcode_11_handler
        dw      opcode_12_handler, opcode_13_handler, opcode_14_handler
        dw      opcode_15_handler, command_16_handler, opcode_17_handler

; Opaque constants/pattern bytes from 08C5h through 08DCh, preceding code at 08DDh.
; No control-flow entry into this region is evidenced; preserve its bytes as data.
unclassified_table_data_08c5:
        db      00h, 00h, 00h, 0FFh, 0FFh, 0FFh, 0AAh, 0AAh, 0AAh, 055h, 055h, 055h
        db      06Dh, 0B6h, 0DBh, 0B6h, 0DBh, 06Dh, 0DBh, 06Dh, 0B6h, 06Dh, 0B6h, 0DBh

device_action_handler:
        call    11aah
        ret     nc
        call    11d5h
        call    1227h
        xor     a
        ld      (ix+15h),a
        ld      (ix+16h),a
        call    11e5h
        call    0a64h
        xor     a
        ld      (4204h),a
        ld      (4201h),a
        ld      (75bfh),a
        ld      (75b5h),a
        ld      hl,0000h
        ld      (4202h),hl
loc_0907:
        ld      d,(ix+26h)
        ld      e,(ix+27h)
        xor     a
        sbc     hl,de
        jr      z,095fh
        ld      hl,(4202h)
        call    0576h
        ret     nc
        call    11b3h
        ret     nc
        ld      iy,08c5h
        ld      a,08h
        ld      (420ah),a
        ld      (75bbh),iy
        call    0b20h
        ret     nc
        ret     nz
        call    0bcdh
        ret     nc
        jr      nz,0951h
        ld      iy,(75bbh)
        ld      bc,0003h
        add     iy,bc
        ld      a,(420ah)
        dec     a
        ld      (420ah),a
        jr      nz,0926h
        ld      hl,(4202h)
        inc     hl
        ld      (4202h),hl
        jp      loc_0907
        cp      05h
        jr      z,0957h
        scf
        ret
        call    0966h
        ld      b,01h
        xor     a
        scf
        ret
        call    0b75h
        ld      bc,0000h
        ret
        xor     a
        ld      (4204h),a
        ld      (4201h),a
        ld      hl,0000h
        ld      (4202h),hl
        ld      (75b1h),hl
        call    0576h
        ret     nc
        call    11b3h
        ret     nc
        ld      iy,08c5h
        ld      hl,4240h
        ld      a,01h
        call    0de4h
        ld      hl,734dh
        ld      bc,0099h
        ld      a,(ix+WDC_EVENT_DRV)
        inc     a
        dec     a
        jr      z,099ah
        add     hl,bc
        jr      0994h
        ld      de,4248h
        ldir
        ld      bc,0022h
        push    ix
        pop     hl
        add     hl,bc
        ld      bc,0008h
        ld      de,4440h
        ldir
        xor     a
        jr      09c9h
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        cp      (ix+24h)
        jr      nc,09e5h
        ld      iy,4240h
        ld      a,01h
        call    0e2fh
        ld      a,(4201h)
        call    12fah
        ld      a,(4204h)
        call    15ach
        ld      a,02h
        scf
        ret     nz
        ld      hl,2120h
        ld      bc,0105h
        call    130bh
        ret     nc
        ld      a,01h
        ret     nz
        jr      09b1h
        xor     a
        scf
        ret
        xor     a
        ld      (4201h),a
        ld      (4204h),a
        ld      hl,0000h
        ld      (4202h),hl
        ld      (75b1h),hl
        call    0576h
        ret     nc
        call    11b3h
        ret     nc
        xor     a
        jr      0a14h
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        cp      (ix+24h)
        jr      c,0a14h
        ld      a,03h
        or      a
        scf
        ret
        call    12fah
        xor     a
        ld      (420fh),a
        ld      a,(4204h)
        call    15ach
        ld      a,02h
        scf
        ret     nz
        ld      hl,2120h
        ld      bc,0105h
        call    1324h
        ret     nc
        ld      a,01h
        ret     nz
        ld      a,(420fh)
        or      a
        jr      nz,0a03h
        xor     a
        scf
        ret
        ld      hl,734dh
        ld      bc,0099h
        inc     a
        dec     a
        jr      z,0a48h
        add     hl,bc
        jr      0a42h
        ld      a,01h
        ld      (75c0h),a
        ld      de,4248h
        ex      de,hl
        ldir
        ld      bc,0022h
        push    ix
        pop     hl
        add     hl,bc
        ld      bc,0008h
        ex      de,hl
        ld      hl,4440h
        ldir
        ret
        ld      hl,734dh
        ld      bc,0099h
        ld      a,(ix+WDC_EVENT_DRV)
        inc     a
        dec     a
        jr      z,0a74h
        add     hl,bc
        jr      0a6eh
        ld      (75b9h),hl
        ld      (75bdh),hl
        ex      de,hl
        ld      hl,08c6h
        ld      bc,0099h
loc_0A81:
        dec     hl
        ldi
        jp      pe,loc_0A81
        ret
        ld      de,(75b9h)
        ld      hl,(75b1h)
        ld      a,(75b3h)
        ld      c,a
        ld      a,(75b4h)
        inc     a
        cp      (ix+25h)
        jr      nz,0aa9h
        ld      a,c
        inc     a
        cp      (ix+24h)
        ld      c,a
        ld      a,00h
        jr      nz,0aa9h
        ld      c,00h
        inc     hl
        sla     c
        sla     c
        sla     c
        sla     c
        sla     c
        or      c
        ld      c,a
        ld      a,h
        ld      (de),a
        inc     de
        ld      a,l
        ld      (de),a
        inc     de
        ld      a,c
        ld      (de),a
        inc     de
        ld      (75b9h),de
        ret
        ld      de,(75bdh)
        ld      a,(4201h)
        sla     a
        sla     a
        sla     a
        sla     a
        sla     a
        ld      b,a
        ld      a,(4204h)
        or      b
        ld      (75b8h),a
        ld      a,(de)
        ld      h,a
        inc     de
        ld      a,(de)
        ld      l,a
        inc     de
        or      h
        jr      nz,0ae9h
        ld      a,(de)
        or      h
        jr      z,0afdh
        ld      bc,(4202h)
        xor     a
        sbc     hl,bc
        jr      nz,0afah
        ld      a,(de)
        ld      c,a
        ld      a,(75b8h)
        cp      c
        scf
        ret     z
        inc     de
        jr      0adch
        ld      de,(75b9h)
        ld      hl,(4202h)
        ld      a,h
        ld      (de),a
        inc     de
        ld      a,l
        ld      (de),a
        inc     de
        ld      a,(75b8h)
        ld      (de),a
        inc     de
        ld      (75b9h),de
        ld      a,(75bfh)
        inc     a
        ld      (75bfh),a
        cp      33h
        scf
        ret     nz
        ccf
        ret
        xor     a
        ld      (4204h),a
        ld      (4201h),a
        ld      hl,4240h
        ld      a,(ix+25h)
        call    0de4h
        ld      a,(4201h)
        call    12fah
        ld      iy,4240h
        ld      a,(ix+25h)
        call    0e2fh
        ld      a,(ix+25h)
        ld      bc,0105h
        ld      hl,0000h
        add     hl,bc
        dec     a
        jr      nz,0b49h
        push    hl
        ld      a,(4204h)
        call    15ach
        pop     bc
        ld      a,02h
        scf
        ret     nz
        ld      hl,2120h
        call    130bh
        ret     nc
        ld      a,01h
        ret     nz
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        cp      (ix+24h)
        jr      nz,0b33h
        xor     a
        ld      (4201h),a
        scf
        ret
        ld      iy,08c8h
        ld      hl,4240h
        ld      a,01h
        call    0de4h
        ld      de,(75bdh)
        ld      (75b9h),de
        call    0cdch
        jr      z,0bcah
        ld      hl,(4202h)
        call    0576h
        ret     nc
        call    11b3h
        ret     nc
        ld      a,0ffh
        ld      (75b5h),a
        ld      iy,4240h
        ld      a,01h
        call    0e2fh
        xor     a
        ld      (75b5h),a
        ld      a,(4201h)
        call    12fah
        ld      a,(4204h)
        call    15ach
        ld      a,02h
        scf
        ret     nz
        ld      hl,2120h
        ld      bc,0105h
        call    130bh
        ret     nc
        ld      a,01h
        ret     nz
        jr      0b89h
        xor     a
        scf
        ret
        xor     a
        ld      (4204h),a
        ld      (4201h),a
        ld      a,(4201h)
        call    12fah
        ld      a,06h
        ld      (4209h),a
        ld      a,(ix+25h)
        ld      hl,0000h
        ld      bc,0105h
        add     hl,bc
        dec     a
        jr      nz,0be8h
        push    hl
        xor     a
        ld      (420fh),a
        ld      a,(4204h)
        call    15ach
        pop     bc
        ld      a,02h
        scf
        ret     nz
        ld      hl,2120h
        call    1324h
        ret     nc
        ld      a,01h
        ret     nz
        ld      a,(420fh)
        or      a
        jr      z,0c1ch
        ld      hl,(4202h)
        ld      a,h
        or      l
        ld      a,05h
        jr      z,0c35h
        call    0c38h
        ld      a,05h
        jr      nc,0c35h
        ld      a,(4209h)
        dec     a
        ld      (4209h),a
        jr      nz,0bdfh
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        cp      (ix+24h)
        jr      nz,0bd4h
        xor     a
        ld      (4201h),a
        or      a
        scf
        ret
        ld      iy,4240h
        push    iy
        xor     a
        ld      (4204h),a
        ld      a,01h
        pop     iy
        push    iy
        call    10d4h
        call    nz,0ac3h
        pop     hl
        ret     nc
        jr      nz,0c5dh
        push    hl
        ld      a,01h
        call    1134h
        call    nz,0ac3h
        pop     hl
        ret     nc
        ld      a,(4204h)
        inc     a
        cp      (ix+25h)
        jr      z,0c70h
        ld      (4204h),a
        ld      bc,020ah
        add     hl,bc
        push    hl
        jr      0c42h
        xor     a
        ld      (4204h),a
        scf
        ret
        push    bc
        push    hl
        inc     c
        dec     c
        jr      z,0ca5h
        ld      a,(75b4h)
        inc     a
        ld      (75b4h),a
        cp      (ix+25h)
        jr      nz,0c79h
        xor     a
        ld      (75b4h),a
        ld      a,(75b3h)
        inc     a
        ld      (75b3h),a
        cp      (ix+24h)
        jr      nz,0c79h
        xor     a
        ld      (75b3h),a
        ld      hl,(75b1h)
        inc     hl
        ld      (75b1h),hl
        jr      0c79h
        pop     hl
        pop     bc
        ret
        push    bc
        push    hl
        inc     c
        dec     c
        jr      z,0cd9h
        ld      a,(4204h)
        inc     a
        ld      (4204h),a
        cp      (ix+25h)
        jr      nz,0cabh
        xor     a
        ld      (4204h),a
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        and     07h
        cp      (ix+24h)
        jr      nz,0cabh
        xor     a
        ld      (4201h),a
        ld      hl,(4202h)
        inc     hl
        ld      (4202h),hl
        jr      0cabh
        pop     hl
        pop     bc
        ret
        ld      de,(75b9h)
        ld      a,(de)
        ld      h,a
        inc     de
        ld      a,(de)
        ld      l,a
        inc     de
        or      h
        ret     z
        ld      (4202h),hl
        ld      a,(de)
        inc     de
        ld      (75b9h),de
        ld      c,a
        and     1fh
        ld      (4204h),a
        ld      a,c
        sra     a
        sra     a
        sra     a
        sra     a
        sra     a
        and     07h
        ld      (4201h),a
        or      01h
        ret
initialize_io_controller:
        ld      hl,75c4h
        ld      bc,00a8h
loc_0D10:
        xor     a
        ld      (75b5h),a
        ld      (hl),a
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jp      nz,loc_0D10
        ld      a,01h
        ld      (4211h),a
        ld      (75c0h),a
        ld      a,0ffh
        ld      (4200h),a
        ld      (766ch),a
        ld      hl,0d9bh
        ld      de,4212h
        ld      bc,002eh
        ldir
        ld      hl,0dc9h
        ld      de,733fh
        ld      bc,000eh
        ldir
        ld      a,00h
        ld      (75c4h),a
        ld      (75eeh),a
        ld      (7618h),a
        ld      (7642h),a
        ld      hl,75c4h
        ld      (75c2h),hl
        ld      a,00h
        ld      (75d6h),a
        ld      (7600h),a
        ld      (762ah),a
        ld      (7654h),a
        ld      (75d5h),a
        ld      (75ffh),a
        ld      (7629h),a
        ld      (7653h),a
        ld      (733dh),a
        dec     a
        ld      (75d9h),a
        ld      (7603h),a
        ld      (762dh),a
        ld      (7657h),a
        ld      (733eh),a
        ld      iy,734dh
        ld      hl,0ffffh
        ld      bc,0099h
        ld      a,04h
        ld      (iy+00h),h
        ld      (iy+01h),l
        add     iy,bc
        dec     a
        ret     z
        jr      0d8fh
io_controller_config_block_1:
        db      083h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 079h
        db      00h, 00h, 00h, 00h, 054h, 02h, 050h, 02h
        db      080h, 0ADh, 00h, 00h, 08Ah, 0CFh, 0CFh, 083h
        db      0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 079h, 00h
        db      00h, 00h, 00h, 05Ch, 0CEh, 050h, 02h, 080h
        db      0ADh, 00h, 00h, 082h, 0CFh, 0B3h
io_controller_config_block_2:
        db      07Ch, 00h, 07Dh, 00h, 00h, 00h, 00h, 05h
        db      0CFh, 0ADh, 00h, 00h, 01h, 0CFh
        ld      a,(de)
        cp      (hl)
        jr      nz,0de2h
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jr      nz,0dd7h
        scf
        ret
        push    de
        push    hl
        push    af
        push    af
        ld      d,h
        ld      e,l
        dec     de
        dec     de
        call    0e03h
        ex      de,hl
        pop     af
        dec     a
        jr      z,0e21h
        push    af
        ex      de,hl
        ld      bc,000ah
        add     hl,bc
        ex      de,hl
        add     hl,bc
        ld      bc,0200h
        ldir
        jr      0df0h
        ld      bc,0008h
        add     hl,bc
        ld      bc,0200h
        ld      a,(iy+00h)
        call    0e29h
        ret     z
        ld      a,(iy+01h)
        call    0e29h
        ret     z
        ld      a,(iy+02h)
        call    0e29h
        ret     z
        jr      0e0ah
        pop     af
        pop     iy
        pop     de
        call    0e2fh
        ret
        ld      (hl),a
        inc     hl
        dec     bc
        ld      a,b
        or      c
        ret
        inc     a
        push    af
        ld      a,(4204h)
        ld      (4210h),a
        pop     af
        dec     a
        ret     z
        push    af
        ld      a,19h
        ld      (iy+00h),a
        ld      a,(4210h)
        sla     a
        sla     a
        sla     a
        ld      c,a
        ld      a,(4201h)
        and     07h
        or      c
        ld      (iy+01h),a
        ld      hl,(4202h)
        ld      a,h
        ld      (iy+02h),a
        ld      a,l
        ld      (iy+03h),a
        ld      a,(75b5h)
        ld      (iy+04h),a
        ld      (iy+05h),a
        xor     a
        ld      (iy+06h),a
        ld      (iy+07h),a
        ld      bc,0208h
        add     iy,bc
        ld      (iy+00h),a
        ld      (iy+01h),a
        inc     iy
        inc     iy
        ld      a,(4210h)
        inc     a
        ld      (4210h),a
        cp      (ix+25h)
        jr      nz,0e37h
        ld      a,00h
        ld      (4210h),a
        jr      0e37h
        xor     a
        or      c
        jr      z,0e95h
        inc     b
        ld      a,b
        sla     a
        sla     a
        add     a,b
        ld      c,a
        ret
        ld      a,(4204h)
        inc     a
        ld      (4204h),a
        cp      (ix+25h)
        jr      c,0ef0h
        xor     a
        ld      (4204h),a
        ld      a,(4201h)
        inc     a
        ld      (4201h),a
        and     07h
        cp      (ix+24h)
        jr      c,0eeah
        xor     a
        ld      (4201h),a
        ld      hl,(4202h)
        inc     hl
        ld      (4202h),hl
        ld      a,(75c0h)
        or      a
        jr      nz,0ed4h
        ld      d,(ix+26h)
        ld      e,(ix+27h)
        jr      0edah
        ld      d,(ix+22h)
        ld      e,(ix+23h)
        scf
        ccf
        ex      de,hl
        sbc     hl,de
        jr      z,0ef4h
        ex      de,hl
        call    0576h
        ret     nc
        call    11b3h
        ret     nc
        ld      a,(4201h)
        call    12fah
        or      01h
        scf
        ret
        xor     a
        scf
        ret
        ld      a,(ix+WDC_EVENT_SECTOR)
        cp      (ix+25h)
        ret     nc
        ld      a,(ix+WDC_EVENT_HEAD)
        cp      (ix+24h)
        ret     nc
        ld      l,(ix+WDC_EVENT_CYL_LO)
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      a,(75c0h)
        or      a
        jr      nz,0f19h
        ld      d,(ix+26h)
        ld      e,(ix+27h)
        jr      0f1fh
        ld      d,(ix+22h)
        ld      e,(ix+23h)
        scf
        ccf
        sbc     hl,de
        ret     nc
        ld      a,(ix+WDC_EVENT_DRV)
        cp      04h
        ret
        ld      a,(75c0h)
        or      a
        ld      (420ch),a
        ld      a,(ix+WDC_EVENT_SECTOR)
        jr      z,0fa1h
        ld      h,(ix+WDC_EVENT_TRANSWRD_CNT_HI)
        ld      l,(ix+WDC_EVENT_TRANSWRD_CNT_LO)
        xor     a
        ld      (420ch),a
        or      l
        jr      z,0f44h
        inc     h
        ld      c,h
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      l,(ix+WDC_EVENT_CYL_LO)
        ld      (75b1h),hl
        ld      (4202h),hl
        ld      a,(ix+WDC_EVENT_HEAD)
        ld      (75b3h),a
        ld      (4201h),a
        ld      a,(ix+WDC_EVENT_SECTOR)
        ld      (75b4h),a
        ld      (4204h),a
        call    104fh
        ld      a,(420bh)
        ld      b,a
        ld      a,(4204h)
        push    af
        ld      a,(420ch)
        inc     a
        cp      c
        jr      z,0f9ch
        ld      (420ch),a
        push    bc
        ld      c,01h
        call    0c76h
        ld      hl,(75b1h)
        ld      (4202h),hl
        ld      a,(75b3h)
        ld      (4201h),a
        ld      a,(75b4h)
        ld      (4204h),a
        call    104fh
        pop     bc
        ld      a,(420bh)
        cp      b
        jr      z,0f6eh
        jr      0fa0h
        xor     a
        ld      (420ch),a
        pop     af
        ld      b,a
        ld      a,(ix+25h)
        sub     b
        ld      b,a
        ld      a,(420ch)
        ld      c,a
        or      a
        ld      a,b
        jr      z,0fb3h
        cp      c
        jr      c,0fb3h
        ld      a,c
        ld      h,a
        ld      l,00h
        ld      d,(ix+WDC_EVENT_TRANSWRD_CNT_HI)
        ld      e,(ix+WDC_EVENT_TRANSWRD_CNT_LO)
        push    hl
        xor     a
        sbc     hl,de
        pop     hl
        jr      c,0fc4h
        ex      de,hl
        ld      (ix+18h),l
        ld      (ix+19h),h
        ret
        ld      l,(ix+WDC_EVENT_TRANSWRD_CNT_LO)
        ld      h,(ix+WDC_EVENT_TRANSWRD_CNT_HI)
        ld      e,(ix+18h)
        ld      d,(ix+19h)
        xor     a
        sbc     hl,de
        ld      (ix+WDC_EVENT_TRANSWRD_CNT_LO),l
        ld      (ix+WDC_EVENT_TRANSWRD_CNT_HI),h
        scf
        ret     z
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        ld      h,(ix+WDC_EVENT_TRANSADDR_B1)
        ld      l,(ix+WDC_EVENT_TRANSADDR_B0)
        add     hl,de
        jr      nc,0fefh
        inc     a
        add     hl,de
        jr      nc,0ff3h
        inc     a
        ld      (ix+WDC_EVENT_TRANSADDR_B0),l
        ld      (ix+WDC_EVENT_TRANSADDR_B1),h
        ld      (ix+WDC_EVENT_TRANSADDR_B2),a
        ld      l,(ix+18h)
        ld      h,(ix+19h)
        xor     a
        or      l
        jr      z,1007h
        inc     h
        ld      c,h
        ld      a,(ix+WDC_EVENT_SECTOR)
        ld      (75b4h),a
        ld      a,(ix+WDC_EVENT_HEAD)
        ld      (75b3h),a
        ld      l,(ix+WDC_EVENT_CYL_LO)
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      (75b1h),hl
        call    0c76h
        ld      a,(75b4h)
        ld      (ix+WDC_EVENT_SECTOR),a
        ld      a,(75b3h)
        ld      (ix+WDC_EVENT_HEAD),a
        ld      hl,(75b1h)
        ld      (ix+WDC_EVENT_CYL_LO),l
        ld      (ix+WDC_EVENT_CYL_HI),h
        ld      d,(ix+22h)
        ld      e,(ix+23h)
        ld      a,(75c0h)
        or      a
        jr      nz,1047h
        ld      d,(ix+26h)
        ld      e,(ix+27h)
        xor     a
        sbc     hl,de
        ret     nc
        or      01h
        scf
        ret
        ld      a,(75c0h)
        or      a
        ret     z
        push    bc
        push    de
        push    hl
        ld      a,(ix+WDC_EVENT_DRV)
        ld      hl,734dh
        ld      bc,0099h
        inc     a
        dec     a
        jr      z,1067h
        add     hl,bc
        jr      1061h
        ld      c,(ix+28h)
        call    0ca8h
        ld      a,0ffh
        ld      (420bh),a
        ld      a,(4201h)
        sla     a
        sla     a
        sla     a
        sla     a
        sla     a
        ld      c,a
        ld      a,(4204h)
        or      c
        push    af
        ld      bc,(4202h)
        ld      a,(420bh)
        inc     a
        ld      (420bh),a
        ld      d,(hl)
        inc     hl
        ld      e,(hl)
        inc     hl
        inc     hl
        xor     a
        ex      de,hl
        sbc     hl,bc
        ex      de,hl
        jr      c,1089h
        jr      nz,10a8h
        dec     hl
        ld      e,(hl)
        inc     hl
        pop     af
        cp      e
        jr      c,10a9h
        push    af
        jr      1089h
        pop     af
        ld      a,(420bh)
        ld      c,a
        call    0ca8h
        pop     hl
        pop     de
        pop     bc
        ret
        ld      h,(ix+WDC_EVENT_CYL_HI)
        ld      l,(ix+WDC_EVENT_CYL_LO)
        inc     hl
        ld      (ix+WDC_EVENT_CYL_HI),h
        ld      (ix+WDC_EVENT_CYL_LO),l
        call    0f05h
        ret     c
        ld      h,(ix+22h)
        ld      l,(ix+23h)
        dec     hl
        dec     hl
        ld      (ix+WDC_EVENT_CYL_HI),h
        ld      (ix+WDC_EVENT_CYL_LO),l
        ret
        inc     a
        push    af
        ld      hl,(4202h)
        ld      a,(4201h)
        and     07h
        ld      d,a
        ld      a,(4204h)
        ld      e,a
        pop     af
        dec     a
        scf
        ret     z
        push    af
        ld      a,19h
        cp      (iy+00h)
        jr      nz,112bh
        ld      a,e
        sla     a
        sla     a
        sla     a
        or      d
        cp      (iy+01h)
        jr      nz,112bh
        ld      a,h
        cp      (iy+02h)
        jr      nz,112bh
        ld      a,l
        cp      (iy+03h)
        jr      nz,112bh
        ld      h,(iy+04h)
        ld      a,(iy+05h)
        or      h
        jr      nz,1130h
        ld      bc,020ah
        add     iy,bc
        inc     e
        ld      a,e
        cp      (ix+25h)
        jr      nz,10e3h
        ld      e,00h
        inc     d
        ld      a,d
        cp      (ix+24h)
        jr      nz,10e3h
        ld      d,00h
        inc     hl
        jr      10e3h
        pop     af
        or      01h
        scf
        ret
        pop     af
        xor     a
        inc     a
        ret
        ld      iy,(75bbh)
        push    af
        ld      de,0008h
        add     hl,de
        inc     de
        inc     de
        ld      bc,0200h
        call    114fh
        jr      nz,1171h
        pop     af
        dec     a
        scf
        ret     z
        push    af
        add     hl,de
        jr      113fh
        ld      a,(hl)
        cp      (iy+00h)
        ret     nz
        call    116ch
        ret     z
        ld      a,(hl)
        cp      (iy+01h)
        ret     nz
        call    116ch
        ret     z
        ld      a,(hl)
        cp      (iy+02h)
        ret     nz
        call    116ch
        ret     z
        jr      114fh
        inc     hl
        dec     bc
        ld      a,b
        or      c
        ret
        pop     de
        scf
        ret
        ld      iy,4240h
        xor     a
        push    af
        ld      h,(iy+04h)
        ld      a,(iy+05h)
        or      h
        jr      z,1193h
        call    0a88h
        ld      a,(75bfh)
        inc     a
        ld      (75bfh),a
        cp      33h
        jr      z,11a7h
        jr      1198h
        ld      c,01h
        call    0c76h
        pop     af
        inc     a
        cp      (ix+25h)
        scf
        ret     z
        push    af
        ld      bc,020ah
        add     iy,bc
        jr      117ah
        pop     af
        xor     a
        ret
        ld      (4200h),a
        out     (90h),a
        call    11b3h
        ret
        push    bc
        ld      b,04h
        call    15ebh
        in      a,(80h)
        and     01h
        jr      z,11cfh
        ld      a,(420dh)
        or      a
        jr      z,11b9h
        dec     b
        jr      nz,11b6h
        call    15fch
        scf
        ccf
        pop     bc
        ret
        call    15fch
        scf
        pop     bc
        ret
        ld      a,01h
        out     (21h),a
        xor     a
        out     (21h),a
        ld      a,0ch
        out     (20h),a
        and     04h
        out     (20h),a
        ret
        in      a,(80h)
        srl     a
        srl     a
        and     03h
        ld      c,05h
        cp      03h
        jr      z,11ffh
        dec     c
        cp      02h
        jr      z,11ffh
        dec     c
        cp      01h
        jr      z,11ffh
        ld      c,01h
        ld      (ix+24h),c
        xor     a
        add     a,18h
        dec     c
        jr      nz,1203h
        ld      (ix+28h),a
        ld      hl,0258h
        ld      (ix+22h),h
        ld      (ix+23h),l
        ld      hl,025dh
        ld      (ix+26h),h
        ld      (ix+27h),l
        ld      a,18h
        ld      (ix+25h),a
        xor     a
        ld      (ix+29h),a
        ret
        ld      b,04h
        call    15ebh
        ld      a,(420dh)
        or      a
        jr      z,122ch
        dec     b
        jr      nz,1229h
        ret
        in      a,(80h)
        and     02h
        xor     02h
        scf
        ret     z
        call    15fch
        ret
        or      04h
        push    af
        call    11b3h
        pop     bc
        ret     nc
        ld      a,06h
        or      b
        ld      c,a
        ld      a,b
        out     (20h),a
        ld      d,01h
        dec     d
        jr      nz,1253h
        ld      a,c
        out     (20h),a
        ld      a,b
        out     (20h),a
        dec     hl
        ld      a,h
        ld      a,h
        or      l
        jr      nz,1251h
        ld      a,04h
        out     (20h),a
        scf
        ret
        ld      hl,0ffffh
        scf
        ret     z
        dec     hl
        ld      a,h
        or      l
        ret     z
        jr      126bh
        dec     a
        cp      0ffh
        jr      nz,127ch
        ld      a,(ix+25h)
        dec     a
        push    af
        ld      a,00h
        ld      (4207h),a
        ld      hl,3998h
        ld      bc,0004h
        ld      a,00h
        ld      (420fh),a
        call    1324h
        pop     bc
        ret     nc
        ld      a,00h
        ret     nz
        push    bc
        ld      a,(ix+25h)
        sla     a
        sla     a
        ld      c,a
        ld      a,(4207h)
        inc     a
        ld      (4207h),a
        cp      c
        scf
        jr      z,12dfh
        ld      a,(420fh)
        or      a
        jr      nz,1282h
        ld      a,(7331h)
        and     07h
        ld      b,a
        ld      a,(4201h)
        and     07h
        cp      b
        scf
        jr      nz,12dfh
        ld      a,(7332h)
        ld      d,a
        ld      a,(7333h)
        ld      e,a
        ld      hl,(4202h)
        xor     a
        sbc     hl,de
        scf
        jr      nz,12dfh
        ld      a,(7331h)
        srl     a
        srl     a
        srl     a
        pop     bc
        cp      b
        scf
        ret     z
        push    bc
        jr      1282h
        pop     bc
        jr      nc,12e6h
        xor     a
        dec     a
        scf
        ret
        xor     a
        inc     a
        scf
        ret
        push    bc
        ld      a,(ix+13h)
        and     60h
        sra     a
        sra     a
        ld      b,a
        ld      a,(4201h)
        or      b
        pop     bc
        push    bc
        ld      (4201h),a
        sla     a
        sla     a
        ld      b,a
        ld      a,(4200h)
        or      b
        out     (90h),a
        pop     bc
        ret
        call    11b3h
        ret     nc
        call    1236h
        ret     nz
        di
        call    136bh
        ld      a,24h
        out     (20h),a
        ld      a,04h
        out     (20h),a
        ei
        call    1236h
        ret
        call    11b3h
        ret     nc
        call    137bh
        ld      a,14h
        out     (20h),a
        ld      a,04h
        out     (20h),a
        xor     a
        scf
        ret
        ld      a,(ix+15h)
        ld      (ix+1eh),a
        ld      a,(ix+16h)
        ld      (ix+1fh),a
        xor     a
        ld      (ix+1dh),a
        ld      (ix+1ch),a
        scf
        ret
program_io_controller:
        ld      hl,1355h
        ld      b,16h
        ld      c,00h
        otir
        ret

; 134Bh sets HL=1355h, B=16h and C=00h, then OTIR sends these 22 bytes.
; Preserve as data; its device-specific meaning is not established here.
io_controller_otir_payload:
        db      083h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 079h, 00h, 00h, 00h
        db      00h, 054h, 0CEh, 050h, 0CEh, 080h, 0ADh, 00h, 00h, 08Ah, 0CFh

configure_io_channel:
        ld      a,00h
        out     (50h),a
        ld      (4224h),hl
        ld      hl,6000h
        ld      (421ah),hl
        jp      loc_1388
        ld      a,00h
        out     (50h),a
        ld      (421ah),hl
        ld      hl,6000h
        ld      (4224h),hl
loc_1388:
        dec     bc
        ld      (421ch),bc
        ld      hl,4212h
        ld      b,17h
        ld      c,00h
        otir
        ld      a,87h
        out     (00h),a
        ret
        xor     a
        cp      c
        jr      nz,13eah
        inc     a
        cp      b
        jr      nz,13eah
        ld      a,88h
        out     (50h),a
        ld      a,79h
        ld      (733ah),a
        ld      (4230h),a
        ld      (423bh),hl
        ld      (4231h),de
        xor     a
        ex      de,hl
        dec     bc
        adc     hl,bc
        jp      m,loc_13E3
        ld      hl,003fh
        ld      (4233h),hl
        ld      hl,4229h
        ld      b,17h
        ld      c,00h
        otir
        ld      b,04h
        ld      c,00h
        ld      a,87h
        ld      d,0b3h
        ld      e,0d3h
        jr      13ddh
        out     (c),d
        out     (c),e
        out     (c),a
        djnz    13d9h
        scf
        ret
loc_13E3:
        sbc     hl,bc
        inc     bc
        ex      de,hl
        jp      loc_1437
        ld      a,88h
        out     (50h),a
        ld      a,79h
        ld      (733ah),a
        jr      13feh
        ld      a,88h
        out     (50h),a
        ld      a,7dh
        ld      (733ah),a
        inc     b
        dec     b
        jr      z,1426h
        push    bc
        ld      bc,0100h
        push    de
        push    hl
        call    142ah
        pop     hl
        ld      de,0105h
        add     hl,de
        ex      (sp),hl
        ld      de,0100h
        add     hl,de
        bit     7,h
        jr      z,1421h
        res     7,h
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        inc     a
        out     (30h),a
        ex      de,hl
        pop     hl
        pop     bc
        jr      13ffh
        xor     a
        or      c
        scf
        ret     z
        ld      a,(733ah)
        ld      (4230h),a
        ld      (4231h),de
        ld      (423bh),hl
loc_1437:
        ld      hl,8000h
        xor     a
        sbc     hl,de
        ex      de,hl
        ld      h,b
        ld      l,c
        xor     a
        sbc     hl,de
        jr      c,1463h
        jr      z,1463h
        push    hl
        push    de
        ld      b,d
        ld      c,e
        call    1463h
        ld      a,(ix+WDC_EVENT_TRANSADDR_B2)
        inc     a
        out     (30h),a
        ld      hl,0000h
        ld      (4231h),hl
        ld      hl,(423bh)
        pop     bc
        add     hl,bc
        ld      (423bh),hl
        pop     bc
        xor     a
        ld      d,a
        ld      e,a
        or      c
        jr      nz,1474h
        ld      a,b
        ld      b,c
        add     a,a
        rl      b
        add     a,a
        rl      b
        ld      c,a
        jr      1497h
        ld      a,c
        dec     a
        or      b
        jr      z,14e6h
        ld      d,06h
        ld      e,00h
        xor     a
loc_147E:
        rr      b
        rr      c
        rr      e
        dec     d
        jp      nz,loc_147E
        srl     e
        srl     e
        ld      a,e
        or      a
        jr      z,1497h
        dec     a
        jr      nz,1496h
        ld      e,41h
        dec     bc
        dec     e
        push    de
        push    bc
        ld      hl,003fh
        ld      (4233h),hl
        ld      hl,4229h
        ld      b,17h
        ld      c,00h
        otir
        pop     bc
        ld      a,c
        or      b
        jp      z,loc_14C1
        ld      b,c
        ld      c,00h
        ld      a,87h
        ld      d,0b3h
        ld      e,0d3h
        jr      14bdh
        out     (c),d
        out     (c),e
        out     (c),a
        djnz    14b9h
loc_14C1:
        pop     bc
        ld      a,b
        or      c
        scf
        ret     z
        ld      a,(733ah)
        and     0e7h
        out     (00h),a
        ld      a,c
        out     (00h),a
        ld      a,b
        out     (00h),a
        ld      a,0b3h
        out     (00h),a
        ld      a,0d3h
        out     (00h),a
        ld      a,87h
        out     (00h),a
        scf
        ret
        ld      a,87h
        out     (00h),a
        ret
        ld      iy,4229h
        ld      (iy+0ah),c
        ld      (iy+0bh),b
        ld      hl,4229h
        ld      b,17h
        ld      c,00h
        otir
        ld      a,(733ah)
        cp      79h
        jr      nz,1531h
        push    ix
        ld      ix,733fh
        ld      a,(iy+08h)
        ld      (ix+03h),a
        ld      a,(iy+09h)
        ld      (ix+04h),a
        ld      e,(iy+12h)
        ld      d,(iy+13h)
        dec     de
        ld      (ix+0ah),e
        ld      (ix+0bh),d
        ld      de,0001h
        ld      (ix+05h),e
        ld      (ix+06h),d
        ld      hl,733fh
        ld      b,0eh
        otir
        pop     ix
        call    14e1h
        ret
initialize_timer_counters:
        ld      a,0ffh
        ld      (4205h),a
        ld      (4208h),a
        ld      a,l
        out     (10h),a
        ld      a,03h
        out     (10h),a
        out     (11h),a
        out     (12h),a
        out     (13h),a
        ret
interrupt_handler_1:
        push    af
        ld      a,(4208h)
        inc     a
        jr      z,1563h
        cp      (ix+25h)
        jr      c,1560h
        ld      a,(4206h)
        inc     a
        ld      (4206h),a
        ld      a,00h
        ld      (4208h),a
        ld      a,03h
        out     (11h),a
        pop     af
        ei
        reti
interrupt_handler_2:
        push    af
        ld      a,(4205h)
        inc     a
        jr      z,1586h
        ld      a,00h
        ld      (4208h),a
        ld      a,(4206h)
        inc     a
        ld      (4206h),a
        ld      a,0c7h
        out     (10h),a
        ld      a,01h
        out     (10h),a
        pop     af
        ei
        reti
interrupt_handler_3:
        push    af
        ld      a,03h
        out     (12h),a
        pop     af
        ei
        reti
interrupt_handler_4:
        push    af
        ld      a,(420eh)
        inc     a
        ld      (420eh),a
        cp      2eh
        jr      c,15a8h
        ld      a,03h
        out     (13h),a
        ld      a,01h
        ld      (420dh),a
        pop     af
        ei
        reti
        ld      b,a
        ld      a,0c7h
        out     (11h),a
        ld      a,01h
        out     (11h),a
        xor     a
        ld      (4205h),a
        ld      (4206h),a
        call    15ebh
        ld      a,(4208h)
        cp      b
        jr      z,15dbh
        ld      a,(420dh)
        or      a
        jr      z,15bfh
        call    15fch
        ld      a,0ffh
        ld      (4205h),a
        ld      (4208h),a
        ld      a,03h
        out     (10h),a
        ret
        call    15fch
        ld      a,0ffh
        ld      (4205h),a
        ld      (4208h),a
        ld      a,03h
        out     (10h),a
        ret
clear_timer_interrupts:
        ld      a,00h
        ld      (420dh),a
        ld      (420eh),a
        ld      a,0a7h
        out     (13h),a
        ld      a,0ffh
        out     (13h),a
        ret
enable_timer_interrupts:
        di
        ld      a,03h
        out     (13h),a
        ei
        ret
select_and_jump:
        ld      a,0ffh
        out     (22h),a
        ld      a,0c0h
        out     (22h),a
        ld      a,l
        out     (22h),a
        ld      a,0b7h
        out     (22h),a
        ld      a,7fh
        out     (22h),a
        xor     a
        out     (20h),a
        ld      a,0ffh
        out     (23h),a
        ld      a,0feh
        out     (23h),a
        ex      de,hl
        jp      (hl)
interrupt_handler_5:
        push    af
        ld      a,01h
        ld      (420fh),a
        pop     af
        ei
        reti

; Remaining bytes are erased EPROM fill, confirmed FFh through the end of image.
        org     162Dh
erased_eprom_fill:
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        db      0FFh, 0FFh, 0FFh, 0FFh

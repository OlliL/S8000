        cpu z8001
      org    %000000
_zdopen:
      dec    r15, #12
      ldl    |<<0>>%0004|(r15), rr6
      test   <<1>>%004E
      jp     nz, <<0>>%0148
      inc    <<1>>%004E, #1
      clr    |<<0>>%0008|(r15)
      jr     %00004A
      ld     r5, |<<0>>%0008|(r15)
      mult   rr4, #6
      ldl    rr6, #2
      add    r7, r5
      ldb    @rr6, #3
      ld     r5, |<<0>>%0008|(r15)
      mult   rr4, #6
      ldl    rr6, #3
      add    r7, r5
      ldb    @rr6, #24
      inc    |<<0>>%0008|(r15), #1
      ld     r2, |<<0>>%0008|(r15)
      cp     r2, <<1>>%0026
      jr     lt, %00001E
      ldl    rr6, #0
      call   <<0>>%0000
      ldl    <<0>>%0000, rr2
      ldl    rr6, rr2
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #10
      outb   @r7, rl6
      ldl    rr6, <<0>>%0000
      srll   rr6, #8
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #11
      outb   @r7, rl6
      ldl    rr6, <<0>>%0000
      srll   rr6, #16
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #12
      outb   @r7, rl6
      ld     r7, #22
      calr _polled_command
      clr    |<<0>>%0008|(r15)
      jr     %0000F2
      ld     r5, |<<0>>%0008|(r15)
      mult   rr4, #6
      ldb    rl3, <<0>>%0002(r5)
      extsb  r3
      ld     r5, |<<0>>%0008|(r15)
      mult   rr4, #6
      ldb    rl4, <<0>>%0003(r5)
      extsb  r4
      ld     r7, r3
      mult   rr6, r4
      ld     r2, |<<0>>%0008|(r15)
      add    r2, r2
      ldl    rr4, #0
      add    r5, r2
      ld     @rr4, r7
      inc    |<<0>>%0008|(r15), #1
      ld     r2, |<<0>>%0008|(r15)
      cp     r2, <<1>>%0026
      jr     lt, %0000BA
      ldl    rr2, #0
      ldl    <<0>>%000E, rr2
      ldl    rr2, #0
      ldl    <<0>>%000A, rr2
      ldl    rr6, #0
      call   <<0>>%0000
      ldl    <<0>>%0000, rr2
      ld     r7, <<0>>%0000
      inc    r7, #1
      sub    r6, r6
      out    @r7, r6
      ld     r7, <<0>>%0000
      inc    r7, #5
      ld     r6, <<0>>%0000
      out    @r7, r6
      ldk    r7, #12
      calr _polled_command
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%002A(r2)
      test   r3
      jr     nz, %0001B6
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%002C(r2)
      test   r3
      jr     nz, %0001B6
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      ldb    rh2, rl2
      clrb   rl2
      ldl    rr4, #0
      add    r5, r2
      ldl    |<<0>>%0000|(r15), rr4
      ld     r7, |<<0>>%0006|(r15)
      and    r7, #%00F0
      ldl    rr4, #%0100002A
      ldl    rr2, #%000002CC
      call   <<0>>%0000
      test   r2
      jr     nz, %000206
      ld     r2, |<<0>>%0006|(r15)
      ldb    rl2, rh2
      extsb  r2
      cp     r2, #32
      jr     nz, %0001DC
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%0100002A
      jr     %0001F2
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%0100002C
      add    r5, r2
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #15
      ldk    r3, #1
      sda    r3, r2
      or     r3, @rr4
      ld     @rr4, r3
      inc    r15, #12
      ret
_zdclose:
      dec    r15, #4
      ldl    |<<0>>%0000|(r15), rr6
      ld     r2, |<<0>>%0002|(r15)
      ldb    rl2, rh2
      extsb  r2
      cp     r2, #32
      jr     nz, %000248
      and    r7, #%00F0
      sra    r7, #4
      sla    r7, #3
      ldl    rr2, #%0100002A
      add    r3, r7
      ld     r7, |<<0>>%0002|(r15)
      and    r7, #15
      ldk    r4, #1
      sda    r4, r7
      com    r4
      and    r4, @rr2
      ld     @rr2, r4
      jr     %000274
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%0100002C
      add    r5, r2
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #15
      ldk    r3, #1
      sda    r3, r2
      com    r3
      and    r3, @rr4
      ld     @rr4, r3
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%002A(r2)
      test   r3
      jr     nz, %0002C8
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%002C(r2)
      test   r3
      jr     nz, %0002C8
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%0100002E
      add    r5, r2
      ldl    rr2, #0
      ldl    @rr4, rr2
      inc    r15, #4
      ret
_zdstrategy:
      sub    r15, #22
      ldm    <<0>>%000A(r15), r8, #6
      ldl    rr12, rr6
      ldl    rr2, rr12(#30)
      ldk    r2, #0
      and    r3, #1
      testl  rr2
      jr     nz, %0002F0
      ld     r2, rr12(#20)
      bit    r2, #0
      jr     z, %000306
      ldb    <<0>>%0015, #14
      ldl    rr6, rr12
      call   <<0>>%0000
      jp     <<0>>%042C
      ld     r2, rr12(#18)
      and    r2, #%00FF
      cp     r2, <<1>>%0028
      jr     ge, %000358
      ld     r2, rr12(#18)
      and    r2, #15
      sla    r2, #4
      inc    r2, #4
      ld     r3, rr12(#18)
      and    r3, #%00F0
      sra    r3, #4
      sla    r3, #3
      ldl    rr4, <<1>>%002E(r3)
      add    r5, r2
      ldl    rr2, rr12(#26)
      ld     r6, rr12(#20)
      ldk    r0, #0
      ld     r1, r6
      addl   rr0, #%000001FF
      sral   rr0, #9
      addl   rr2, rr0
      cpl    rr2, @rr4
      jr     ule, %000366
      set    @rr12, #2
      ldl    rr2, rr12
      add    r3, #%0022
      ld     @rr2, #6
      jr     %0002F8
      ld     r2, rr12(#18)
      and    r2, #%00F0
      sra    r2, #4
      ld     |<<0>>%0008|(r15), r2
      ld     r2, rr12(#18)
      and    r2, #15
      sla    r2, #4
      ld     r3, rr12(#18)
      and    r3, #%00F0
      sra    r3, #4
      sla    r3, #3
      ldl    rr4, <<1>>%002E(r3)
      ldl    rr6, rr4(r2)
      ldl    rr2, rr12(#26)
      add    r3, r7
      ld     r9, r3
      ld     r2, |<<0>>%0008|(r15)
      add    r2, r2
      ldl    rr6, #0
      add    r7, r2
      ldk    r2, #0
      div    rr2, @rr6
      ldl    rr6, rr12
      add    r7, #%0022
      ld     @rr6, r3
      ld     r8, r3
      ld     r2, rr12(#20)
      ldl    rr6, rr12
      add    r7, #%0024
      ld     @rr6, r2
      ldctl  r2, fcw
      di     vi
      ldl    rr10, <<0>>%000A
      jr     %0003E8
      ldl    rr2, rr10
      add    r3, #%0022
      cp     r8, @rr2
      jr     c, %0003F0
      ldl    rr2, rr10(#10)
      ldl    rr10, rr2
      cpl    rr10, #0
      jr     nz, %0003D8
      ldl    rr2, rr12
      inc    r3, #10
      ldl    @rr2, rr10
      ldl    rr2, rr10(#14)
      ldl    rr4, rr12
      inc    r5, #14
      ldl    @rr4, rr2
      inc    r3, #10
      ldl    @rr2, rr12
      ldl    rr2, rr10
      inc    r3, #14
      ldl    @rr2, rr12
      ldl    rr2, <<1>>%004A
      cpl    rr2, #0
      jr     nz, %00041E
      ldl    <<1>>%004A, rr12
      ldctl  r2, fcw
      ei     vi
      testb  <<0>>%0014
      jr     nz, %00042C
      calr _zdstart
      ldm    r8, <<0>>%000A(r15), #6
      add    r15, #22
      ret
_zdstart:
      sub    r15, #18
      ldm    <<0>>%0008(r15), r9, #5
      ldl    rr12, <<1>>%004A
      cpl    rr12, #0
      jp     z, <<0>>%05F4
      incb   <<0>>%0014, #1
      ld     r2, rr12(#18)
      and    r2, #15
      sla    r2, #4
      ld     r3, rr12(#18)
      and    r3, #%00F0
      sra    r3, #4
      sla    r3, #3
      ldl    rr4, <<1>>%002E(r3)
      ldl    rr6, rr4(r2)
      ldl    rr2, rr12(#26)
      add    r3, r7
      ld     r11, r3
      ld     r7, <<0>>%0000
      inc    r7, #16
      inb    rl2, @r7
      xorb   rh2, rh2
      and    r2, #%0080
      test   r2
      jr     nz, %0004AC
      ldl    rr6, #%01000050
      call   <<0>>%0000
      ld     r2, rr12(#18)
      and    r2, #%00F0
      sra    r2, #4
      ld     r9, r2
      ld     r7, <<0>>%0000
      inc    r7, #1
      ld     r6, r9
      out    @r7, r6
      ld     r3, r9
      mult   rr2, #6
      ldb    rl2, <<0>>%0003(r3)
      extsb  r2
      ld     r7, r11
      ldk    r6, #0
      div    rr6, r2
      ld     r3, r9
      mult   rr2, #6
      ldb    rl2, <<0>>%0002(r3)
      extsb  r2
      ld     r5, r7
      ldk    r4, #0
      div    rr4, r2
      ld     r6, r4
      ld     r7, <<0>>%0000
      inc    r7, #2
      out    @r7, r6
      ld     r2, r9
      add    r2, r9
      ldl    rr4, #0
      add    r5, r2
      ld     r7, r11
      ldk    r6, #0
      div    rr6, @rr4
      ld     r10, r7
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #3
      out    @r7, r6
      ld     r7, <<0>>%0000
      inc    r7, #4
      ld     r6, r10
      ldb    rl6, rh6
      clrb   rh6
      and    r6, #%00FF
      out    @r7, r6
      ld     r3, r9
      mult   rr2, #6
      ldb    rl2, <<0>>%0003(r3)
      extsb  r2
      ld     r7, r11
      ldk    r6, #0
      div    rr6, r2
      ld     r7, <<0>>%0000
      inc    r7, #5
      out    @r7, r6
      ld     r7, rr12(#%0024)
      ld     r6, #%FC00
      call   <<0>>%0000
      ld     r10, r2
      res    r2, #0
      rr     r2, #1
      and    r2, #%00FF
      ld     |<<0>>%0006|(r15), r2
      ld     r7, <<0>>%0000
      inc    r7, #8
      ld     r6, |<<0>>%0006|(r15)
      out    @r7, r6
      ld     r7, <<0>>%0000
      inc    r7, #9
      ld     r6, r10
      res    r6, #0
      rr     r6, #1
      ldb    rl6, rh6
      clrb   rh6
      and    r6, #%00FF
      out    @r7, r6
      ldl    rr6, rr12(#30)
      and    r7, #%00FE
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #10
      out    @r7, r6
      ldl    rr6, rr12(#30)
      srll   rr6, #8
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #11
      out    @r7, r6
      ldl    rr6, rr12(#30)
      srll   rr6, #16
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #12
      out    @r7, r6
      bit    @rr12, #0
      jr     z, %0005E0
      ld     r6, #%0021
      jr     %0005E4
      ld     r6, #%0022
      ld     r7, <<0>>%0000
      out    @r7, r6
      ld     <<0>>%0000, #1
      ldm    r9, <<0>>%0008(r15), #5
      add    r15, #18
      ret
_zdint:
      dec    r15, #12
      ldm    <<0>>%0004(r15), r10, #4
      ldl    rr12, rr6
      clr    <<0>>%0000
      ld     <<0>>%0000, #10
      ldctl  r2, fcw
      ei     vi
      testb  <<0>>%0014
      jr     nz, %00063E
      ld     r5, rr12(#32)
      ldl    rr6, #%0100006A
      call   <<0>>%0000
      jp     <<0>>%07BA
      clrb   <<0>>%0014
      ldl    rr10, <<1>>%004A
      ld     r2, rr12(#32)
      and    r2, #%0100
      test   r2
      jr     nz, %0006A0
      ld     r7, rr10(#%0024)
      ld     r6, #%FC00
      call   <<0>>%0000
      ldl    rr4, rr10
      add    r5, #%0024
      ld     r3, @rr4
      sub    r3, r2
      ld     @rr4, r3
      test   r3
      jr     z, %000734
      ldl    rr2, rr10
      add    r3, #26
      ldl    rr4, @rr2
      addl   rr4, #%0000007E
      ldl    @rr2, rr4
      ldl    rr2, rr10
      add    r3, #30
      ldl    rr4, @rr2
      addl   rr4, #%0000FC00
      ldl    @rr2, rr4
      clrb   <<0>>%0015
      jp     <<0>>%07A8
      ld     r7, rr10(#18)
      and    r7, #%00F0
      sra    r7, #4
      calr _read_status
      ldb    rl2, <<0>>%0005
      extsb  r2
      bit    r2, #2
      jr     z, %0006FC
      ld     r6, rr10(#18)
      and    r6, #%00F0
      sra    r6, #4
      ld     r7, <<0>>%0000
      inc    r7, #1
      outb   @r7, rl6
      ld     r7, #19
      calr _polled_command
      ld     r7, rr10(#18)
      and    r7, #%00F0
      sra    r7, #4
      calr _read_status
      ldb    rl2, <<0>>%0005
      extsb  r2
      bit    r2, #0
      jr     z, %0006FC
      ldl    rr6, #%0100008E
      call   <<0>>%0000
      testb  <<0>>%0015
      jr     z, %000712
      ld     r5, rr12(#32)
      ldl    rr6, rr10
      sub    r4, r4
      call   <<0>>%0000
      ldk    r7, #4
      calr _polled_command
      incb   <<0>>%0015, #1
      cpb    <<0>>%0015, #4
      jr     lt, %0007A8
      ldl    rr6, #%010000AE
      call   <<0>>%0000
      set    @rr10, #2
      ldl    rr2, rr10(#14)
      ldl    rr4, rr10(#10)
      inc    r5, #14
      ldl    @rr4, rr2
      inc    r3, #10
      ldl    rr4, rr10(#10)
      ldl    @rr2, rr4
      test   <<1>>%0068
      jr     z, %000756
      ldl    rr2, rr10(#10)
      jr     %00075A
      ldl    rr2, rr10(#14)
      ldl    <<1>>%004A, rr2
      cpl    rr2, #0
      jr     nz, %000790
      test   <<1>>%0068
      jr     nz, %000774
      ldk    r2, #1
      jr     %000776
      ldk    r2, #0
      ld     <<1>>%0068, r2
      test   r2
      jr     z, %000786
      ldl    rr2, rr10(#10)
      jr     %00078A
      ldl    rr2, rr10(#14)
      ldl    <<1>>%004A, rr2
      ldl    rr2, rr10
      add    r3, #%0022
      clr    @rr2
      sub    r2, r2
      ldb    <<0>>%0015, rl2
      ldl    rr6, rr10
      call   <<0>>%0000
      calr _zdstart
      ldctl  r2, fcw
      di     vi
      ld     r7, <<0>>%0000
      inc    r7, #16
      sub    r6, r6
      out    @r7, r6
      ldm    r10, <<0>>%0004(r15), #4
      inc    r15, #12
      ret
_zdread:
      dec    r15, #2
      ld     |<<0>>%0000|(r15), r7
      ldl    rr6, #%000002CC
      ldl    rr4, #0
      ld     r3, |<<0>>%0000|(r15)
      ldk    r2, #1
      call   <<0>>%0000
      inc    r15, #2
      ret
_zdwrite:
      dec    r15, #2
      ld     |<<0>>%0000|(r15), r7
      ldl    rr6, #%000002CC
      ldl    rr4, #0
      ld     r3, |<<0>>%0000|(r15)
      sub    r2, r2
      call   <<0>>%0000
      inc    r15, #2
      ret
_read_status:
      dec    r15, #2
      ld     |<<0>>%0000|(r15), r7
      ld     r7, <<0>>%0000
      inc    r7, #1
      ld     r6, |<<0>>%0000|(r15)
      out    @r7, r6
      ldl    rr6, <<0>>%0000
      ldk    r6, #0
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #10
      outb   @r7, rl6
      ldl    rr6, <<0>>%0000
      srll   rr6, #8
      ldk    r6, #0
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #11
      outb   @r7, rl6
      ldl    rr6, <<0>>%0000
      srll   rr6, #16
      ldk    r6, #0
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, <<0>>%0000
      inc    r7, #12
      outb   @r7, rl6
      ldk    r7, #3
      calr _polled_command
      inc    r15, #2
      ret
_polled_command:
      dec    r15, #4
      ld     |<<0>>%0000|(r15), r7
      ld     r7, <<0>>%0000
      ldb    rl6, |<<0>>%0001|(r15)
      extsb  r6
      outb   @r7, rl6
      ld     r7, <<0>>%0000
      inc    r7, #16
      inb    rl2, @r7
      xorb   rh2, rh2
      and    r2, #%0080
      test   r2
      jr     z, %00088A
      ld     r7, <<0>>%0000
      inc    r7, #16
      inb    rl2, @r7
      xorb   rh2, rh2
      bit    r2, #1
      jr     z, %0008C6
      ldl    rr6, #%010000C0
      ldb    rl5, |<<0>>%0001|(r15)
      ldb    rh5, #0
      call   <<0>>%0000
      ld     r2, #%FFFF
      jr     %0008DC
      ld     r7, <<0>>%0000
      inc    r7, #16
      inb    rl2, @r7
      xorb   rh2, rh2
      and    r2, #8
      test   r2
      jr     z, %0008C6
      sub    r2, r2
      inc    r15, #4
      ret
end

        cpu z8001
      org    %000000
_mdopen:
      sub    r15, #30
      ldm    <<0>>%0018(r15), r11, #3
      ldl    |<<0>>%0004|(r15), rr6
      ld     r2, <<1>>%002C
      and    r2, #1
      test   r2
      jp     nz, <<0>>%050A
      ldk    r12, #0
      ld     r3, r12
      mult   rr2, #%0028
      ldl    rr4, #%0100007E
      add    r5, r3
      ld     r2, r12
      sla    r2, #3
      ldl    rr6, #%0100011E
      add    r7, r2
      ldl    @rr6, rr4
      ld     r2, r12
      sla    r2, #3
      ldl    rr4, #%01000122
      add    r5, r2
      clr    @rr4
      ld     r2, r12
      sla    r2, #3
      ldl    rr4, #%01000124
      add    r5, r2
      ld     @rr4, #1
      ld     r3, r12
      mult   rr2, #%0028
      ldl    rr4, #%0100007E
      add    r5, r3
      ld     r3, r12
      mult   rr2, #%0028
      ldl    rr6, #%0100008C
      add    r7, r3
      ldl    @rr6, rr4
      ld     r3, r12
      mult   rr2, #%0028
      ldl    rr6, #%01000088
      add    r7, r3
      ldl    @rr6, rr4
      ld     r2, r12
      add    r2, r12
      ldl    rr4, #%0100014A
      add    r5, r2
      clr    @rr4
      inc    r12, #1
      cp     r12, #4
      jr     lt, %000024
      ldl    rr6, #%01000172
      call _mdopen
      ldl    |<<0>>%000A|(r15), rr2
      ldk    r12, #0
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%01000174
      add    r5, r2
      ld     @rr4, #%FFFF
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%01000176
      add    r5, r2
      ldl    rr2, #%FFFFFFFF
      ldl    @rr4, rr2
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%0100017A
      add    r5, r2
      ldl    rr2, #%FFFFFFFF
      ldl    @rr4, rr2
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%0100017E
      add    r5, r2
      ld     @rr4, #%FFFF
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%01000180
      add    r5, r2
      ld     @rr4, #%FFFF
      ld     r2, r12
      sla    r2, #4
      ldl    rr4, #%01000182
      add    r5, r2
      ld     @rr4, #%FFFF
      inc    r12, #1
      cp     r12, #4
      jr     lt, %0000BA
      ld     <<1>>%0172, #%FFFF
      ld     r7, #%80F0
      ld     r6, #%F1F1
      out    @r7, r6
      clr    |<<0>>%0008|(r15)
      inc    |<<0>>%0008|(r15), #1
      cp     |<<0>>%0008|(r15), #%FFFF
      jr     c, %00014C
      ldl    rr6, |<<0>>%000A|(r15)
      sral   rr6, #16
      and    r7, #%00FF
      ld     r6, r7
      ld     r7, #%80F0
      out    @r7, r6
      clr    |<<0>>%0008|(r15)
      inc    |<<0>>%0008|(r15), #1
      cp     |<<0>>%0008|(r15), #%FFFF
      jr     c, %000170
      ld     r6, |<<0>>%000C|(r15)
      ld     r7, #%80F0
      out    @r7, r6
      ldk    r12, #0
      ldk    r13, #0
      test   <<1>>%0172
      jr     z, %0001BE
      clr    |<<0>>%0008|(r15)
      inc    |<<0>>%0008|(r15), #1
      cp     |<<0>>%0008|(r15), #%FFFF
      jr     c, %000196
      inc    r12, #1
      cp     r12, #%00B4
      jr     lt, %00018A
      ldl    rr6, #%010001B4
      ld     r5, <<1>>%0172
      call _mdopen
      inc    r13, #1
      test   r13
      jr     nz, %00013E
      ld     r7, #%80F0
      ld     r6, #%1D1D
      out    @r7, r6
      clr    |<<0>>%0008|(r15)
      inc    |<<0>>%0008|(r15), #1
      cp     |<<0>>%0008|(r15), #%FFFF
      jr     c, %0001D0
      clr    |<<0>>%0008|(r15)
      inc    |<<0>>%0008|(r15), #1
      cp     |<<0>>%0008|(r15), #%FFFF
      jr     c, %0001E0
      ld     r2, <<1>>%0172
      ld     <<1>>%002A, r2
      and    r2, #%FF00
      cp     r2, #%0100
      jr     nz, %00020A
      clr    <<1>>%0028
      jr     %000212
      ld     <<1>>%0028, #1
      clr    <<1>>%0172
      test   <<1>>%0028
      jr     nz, %000268
      ldk    r12, #0
      cp     r12, #4
      jr     ge, %0002AE
      ld     r3, r12
      mult   rr2, #12
      ld     r2, <<1>>%017E(r3)
      and    r2, #%1F00
      test   r2
      jr     z, %00024C
      ld     r3, r12
      mult   rr2, #12
      ld     r2, <<1>>%0174(r3)
      bit    r2, #15
      jr     z, %000264
      ld     r2, <<1>>%013E
      add    r2, r2
      ldl    rr4, #%01000140
      add    r5, r2
      ld     @rr4, r12
      inc    <<1>>%013E, #1
      inc    r12, #1
      jr     %000222
      ldk    r12, #0
      ld     r2, r12
      sla    r2, #4
      ld     r3, <<1>>%0182(r2)
      and    r3, #%1F00
      test   r3
      jr     z, %00028E
      ld     r2, r12
      sla    r2, #4
      ld     r3, <<1>>%0174(r2)
      bit    r3, #15
      jr     z, %0002A6
      ld     r2, <<1>>%013E
      add    r2, r2
      ldl    rr4, #%01000140
      add    r5, r2
      ld     @rr4, r12
      inc    <<1>>%013E, #1
      inc    r12, #1
      cp     r12, #4
      jr     lt, %00026A
      clr    |<<0>>%0010|(r15)
      clr    <<1>>%0172
      ldk    r12, #0
      jp     <<0>>%043E
      ld     r2, r12
      add    r2, r12
      ld     r3, <<1>>%0140(r2)
      ld     |<<0>>%000E|(r15), r3
      ld     r2, r3
      add    r2, r3
      ldk    r4, #3
      sda    r4, r2
      or     r4, |<<0>>%0010|(r15)
      ld     |<<0>>%0010|(r15), r4
      ld     r2, |<<0>>%000E|(r15)
      add    r2, r2
      ldk    r4, #1
      sda    r4, r2
      or     r4, <<1>>%0172
      ld     <<1>>%0172, r4
      test   <<1>>%0028
      jr     nz, %00039C
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr6, #0
      add    r7, r2
      call _mdopen
      ldl    |<<0>>%0014|(r15), rr2
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr4, #%01000174
      add    r5, r3
      ld     @rr4, #1
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr4, #%01000176
      add    r5, r3
      clr    @rr4
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr4, #%01000178
      add    r5, r3
      clr    @rr4
      ldl    rr2, #20
      add    r3, r15
      ld     r4, rr2(#2)
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr6, #%0100017A
      add    r7, r3
      ld     @rr6, r4
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr4, #%0100017C
      add    r5, r3
      ld     r2, |<<0>>%0014|(r15)
      and    r2, #%00FF
      ld     @rr4, r2
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ldl    rr4, #%0100017E
      add    r5, r3
      jr     %00043A
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #20
      ldl    rr6, #0
      add    r7, r3
      call _mdopen
      ldl    |<<0>>%0014|(r15), rr2
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #%01000174
      add    r5, r2
      ld     @rr4, #1
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #%01000176
      add    r5, r2
      subl   rr2, rr2
      ldl    @rr4, rr2
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #%0100017A
      add    r5, r2
      subl   rr2, rr2
      ldl    @rr4, rr2
      ldl    rr2, #20
      add    r3, r15
      ld     r4, rr2(#2)
      ld     r5, |<<0>>%000E|(r15)
      sla    r5, #4
      ldl    rr2, #%0100017E
      add    r3, r5
      ld     @rr2, r4
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #%01000180
      add    r5, r2
      ld     r2, |<<0>>%0014|(r15)
      and    r2, #%00FF
      ld     @rr4, r2
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #%01000182
      add    r5, r2
      clr    @rr4
      inc    r12, #1
      cp     r12, <<1>>%013E
      jp     lt, <<0>>%02C0
      ld     r7, #%80F0
      sub    r6, r6
      out    @r7, r6
      ld     r2, <<1>>%0172
      and    r2, |<<0>>%0010|(r15)
      jr     nz, %000452
      ldk    r12, #0
      jr     %0004FC
      ld     r2, r12
      add    r2, r12
      ld     r3, <<1>>%0140(r2)
      ld     |<<0>>%000E|(r15), r3
      test   <<1>>%0028
      jr     nz, %00049A
      ld     r5, r3
      mult   rr4, #12
      ld     r2, <<1>>%017E(r5)
      ld     r11, r2
      ld     r5, |<<0>>%000E|(r15)
      mult   rr4, #12
      ld     r2, <<1>>%0174(r5)
      ld     |<<0>>%0012|(r15), r2
      jr     %0004BC
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ld     r3, <<1>>%0182(r2)
      ld     r11, r3
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ld     r3, <<1>>%0174(r2)
      ld     |<<0>>%0012|(r15), r3
      ld     r2, r11
      and    r2, #%1F00
      test   r2
      jr     z, %0004CC
      bit    |<<0>>%0012|(r15), #15
      jr     z, %0004FA
      test   <<1>>%0028
      jr     nz, %0004E6
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ldl    rr4, #14
      add    r5, r2
      jr     %0004F6
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #20
      ldl    rr4, #18
      add    r5, r3
      ld     @rr4, #1
      inc    r12, #1
      cp     r12, <<1>>%013E
      jr     lt, %000462
      set    <<1>>%002C, #0
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%0152(r2)
      test   r3
      jr     nz, %00057C
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%0154(r2)
      test   r3
      jr     nz, %00057C
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
      or     r7, #%0400
      ldl    rr4, #%01000152
      ldl    rr2, #%0000074E
      call _mdopen
      test   r2
      jr     nz, %0005CC
      ld     r2, |<<0>>%0006|(r15)
      ldb    rl2, rh2
      extsb  r2
      cp     r2, #4
      jr     nz, %0005A2
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%01000152
      jr     %0005B8
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%01000154
      add    r5, r2
      ld     r2, |<<0>>%0006|(r15)
      and    r2, #15
      ldk    r3, #1
      sda    r3, r2
      or     r3, @rr4
      ld     @rr4, r3
      ldm    r11, <<0>>%0018(r15), #3
      add    r15, #30
      ret
_mdclose:
      dec    r15, #4
      ldl    |<<0>>%0000|(r15), rr6
      ld     r2, |<<0>>%0002|(r15)
      ldb    rl2, rh2
      extsb  r2
      cp     r2, #4
      jr     nz, %000618
      and    r7, #%00F0
      sra    r7, #4
      sla    r7, #3
      ldl    rr2, #%01000152
      add    r3, r7
      ld     r7, |<<0>>%0002|(r15)
      and    r7, #15
      ldk    r4, #1
      sda    r4, r7
      com    r4
      and    r4, @rr2
      ld     @rr2, r4
      jr     %000644
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%01000154
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
      ld     r3, <<1>>%0152(r2)
      test   r3
      jr     nz, %000698
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ld     r3, <<1>>%0154(r2)
      test   r3
      jr     nz, %000698
      ld     r2, |<<0>>%0002|(r15)
      and    r2, #%00F0
      sra    r2, #4
      sla    r2, #3
      ldl    rr4, #%01000156
      add    r5, r2
      ldl    rr2, #0
      ldl    @rr4, rr2
      inc    r15, #4
      ret
_mdioctl:
      dec    r15, #14
      ldm    <<0>>%0008(r15), r11, #2
      ld     r11, r5
      ld     r12, r6
      ld     r1, r7
      ld     r2, r7
      and    r2, #%00F0
      sra    r2, #4
      ld     |<<0>>%0006|(r15), r2
      ld     r2, r6
      cp     r6, #%6400
      jr     nz, %00073A
      test   <<1>>%0028
      jr     nz, %0006F8
      ld     r3, |<<0>>%0006|(r15)
      sla    r3, #4
      ld     r4, <<0>>%000E(r3)
      cp     r4, #1
      jr     nz, %0006F8
      ld     r3, |<<0>>%0006|(r15)
      sla    r3, #4
      ld     r4, <<0>>%0008(r3)
      srl    r4, #11
      ld     <<0>>%0028, r4
      jr     %000742
      cp     <<1>>%0028, #1
      jr     nz, %000730
      ld     r5, |<<0>>%0006|(r15)
      mult   rr4, #20
      ld     r3, <<0>>%0012(r5)
      cp     r3, #1
      jr     nz, %000730
      ld     r5, |<<0>>%0006|(r15)
      mult   rr4, #20
      ldl    rr6, <<0>>%000A(r5)
      srll   rr6, #11
      ld     <<0>>%0028, r7
      jr     %000742
      ldb    <<0>>%0015, #19
      jr     %000742
      ldb    <<0>>%0015, #22
      ldm    r11, <<0>>%0008(r15), #2
      inc    r15, #14
      ret
_mdstrategy:
      sub    r15, #26
      ldm    <<0>>%0010(r15), r9, #5
      ldl    rr12, rr6
      ldl    rr2, rr12(#30)
      ldk    r2, #0
      and    r3, #1
      testl  rr2
      jr     nz, %000772
      ld     r2, rr12(#20)
      bit    r2, #0
      jr     z, %000788
      ldb    <<0>>%0015, #14
      ldl    rr6, rr12
      call _mdopen
      jp     <<0>>%090A
      clr    |<<0>>%000E|(r15)
      jr     %0007AE
      ld     r2, |<<0>>%000E|(r15)
      add    r2, r2
      ld     r3, <<1>>%0140(r2)
      ld     r2, rr12(#18)
      and    r2, #%00F0
      sra    r2, #4
      cp     r3, r2
      jr     z, %0007BA
      inc    |<<0>>%000E|(r15), #1
      ld     r2, |<<0>>%000E|(r15)
      cp     r2, <<1>>%013E
      jr     lt, %00078E
      ld     r2, |<<0>>%000E|(r15)
      cp     r2, <<1>>%013E
      jr     nz, %0007D4
      set    @rr12, #2
      ldl    rr4, rr12
      add    r5, #%0022
      ld     @rr4, #19
      jr     %00077A
      ld     r2, rr12(#18)
      and    r2, #15
      sla    r2, #4
      inc    r2, #4
      ld     r3, rr12(#18)
      and    r3, #%00F0
      sra    r3, #4
      sla    r3, #3
      ldl    rr4, <<1>>%0156(r3)
      add    r5, r2
      ldl    rr2, rr12(#26)
      ld     r6, rr12(#20)
      ldk    r0, #0
      ld     r1, r6
      addl   rr0, #%000001FF
      sral   rr0, #9
      addl   rr2, rr0
      cpl    rr2, @rr4
      jr     ule, %000824
      set    @rr12, #2
      ldl    rr2, rr12
      add    r3, #%0022
      ld     @rr2, #6
      jr     %00077A
      ld     r2, rr12(#18)
      and    r2, #15
      sla    r2, #4
      ld     r3, rr12(#18)
      and    r3, #%00F0
      sra    r3, #4
      sla    r3, #3
      ldl    rr4, <<1>>%0156(r3)
      add    r5, r2
      ldl    rr2, rr12(#26)
      addl   rr2, @rr4
      ldl    rr4, rr12
      add    r5, #%0026
      ldl    @rr4, rr2
      ldl    |<<0>>%000A|(r15), rr2
      ld     r2, rr12(#18)
      and    r2, #%00F0
      sra    r2, #4
      ld     r9, r2
      ld     r2, rr12(#20)
      ldl    rr4, rr12
      add    r5, #%0024
      ld     @rr4, r2
      ldctl  r2, fcw
      di     vi
      ld     r3, r9
      mult   rr2, #%0028
      ldl    rr4, <<1>>%0088(r3)
      ldl    rr10, rr4
      jr     %00089C
      ldl    rr2, rr10
      add    r3, #%0026
      ldl    rr4, |<<0>>%000A|(r15)
      cpl    rr4, @rr2
      jr     lt, %0008AE
      ldl    rr2, rr10(#10)
      ldl    rr10, rr2
      ld     r3, r9
      mult   rr2, #%0028
      ldl    rr4, #%0100007E
      add    r5, r3
      cpl    rr10, rr4
      jr     nz, %000888
      ldl    rr2, rr12
      inc    r3, #10
      ldl    @rr2, rr10
      ldl    rr2, rr10(#14)
      ldl    rr4, rr12
      inc    r5, #14
      ldl    @rr4, rr2
      ldl    rr2, rr10(#14)
      inc    r3, #10
      ldl    @rr2, rr12
      ldl    rr2, rr10
      inc    r3, #14
      ldl    @rr2, rr12
      ld     r2, r9
      sla    r2, #3
      ldl    rr4, <<1>>%011E(r2)
      ld     r3, r9
      mult   rr2, #%0028
      ldl    rr6, #%0100007E
      add    r7, r3
      cpl    rr4, rr6
      jr     nz, %0008FA
      ld     r2, r9
      sla    r2, #3
      ldl    rr4, #%0100011E
      add    r5, r2
      ldl    @rr4, rr12
      testb  <<1>>%0040
      jr     nz, %000906
      ld     r7, r9
      calr   _mdstart
      ldctl  r2, fcw
      ei     vi
      ldm    r9, <<0>>%0010(r15), #5
      add    r15, #26
      ret
_mdstart:
      sub    r15, #20
      ldm    <<0>>%0008(r15), r8, #6
      ld     r13, r7
      testb  <<1>>%0040
      jp     nz, <<0>>%0AEE
      ldctl  r2, fcw
      ei     vi
      ld     |<<0>>%0004|(r15), r2
      ldk    r12, #0
      jp     <<0>>%0ABA
      ld     r2, r13
      sla    r2, #3
      ldl    rr4, <<1>>%011E(r2)
      ldl    rr10, rr4
      ld     r3, r13
      mult   rr2, #%0028
      ldl    rr6, #%0100007E
      add    r7, r3
      cpl    rr4, rr6
      jp     z, <<0>>%0AA2
      ld     r2, r13
      sla    r2, #3
      ldl    rr4, #%01000122
      add    r5, r2
      ld     @rr4, #1
      inc    <<1>>%0148, #1
      test   <<1>>%0028
      jr     nz, %000A08
      ld     r3, r13
      mult   rr2, #12
      ldl    rr4, #%01000174
      add    r5, r3
      ldl    rr8, rr4
      ldl    rr2, rr10(#%0026)
      inc    r5, #2
      ld     @rr4, r3
      ld     r2, rr10(#%0024)
      ld     r5, r2
      ldk    r4, #0
      addl   rr4, #%000001FF
      sral   rr4, #9
      ldl    rr2, rr8
      inc    r3, #4
      ld     @rr2, r5
      ldl    rr2, rr10(#30)
      ldl    rr4, rr8
      inc    r5, #6
      ld     @rr4, r3
      ldl    rr2, rr10(#30)
      srll   rr2, #16
      ldk    r2, #0
      and    r3, #%00FF
      ldl    rr4, rr8
      inc    r5, #8
      ld     @rr4, r3
      bit    @rr10, #0
      jr     z, %0009EA
      ld     r2, rr10(#%0024)
      and    r2, #%01FF
      sla    r2, #7
      ld     |<<0>>%0006|(r15), r2
      jr     %0009EE
      clr    |<<0>>%0006|(r15)
      ldl    rr2, rr8
      inc    r3, #10
      ld     r4, |<<0>>%0006|(r15)
      or     r4, <<0>>%0000
      ld     @rr2, r4
      bit    @rr10, #0
      jr     z, %000A84
      ld     r2, #%0110
      jr     %000A88
      ld     r2, r13
      sla    r2, #4
      ldl    rr4, #%01000174
      add    r5, r2
      ldl    rr8, rr4
      ldl    rr2, rr10(#%0026)
      inc    r5, #2
      ldl    @rr4, rr2
      ld     r2, rr10(#%0024)
      ld     r5, r2
      ldk    r4, #0
      addl   rr4, #%000001FF
      sral   rr4, #9
      ldl    rr2, rr8
      inc    r3, #6
      ldl    @rr2, rr4
      ldl    rr2, rr10(#30)
      ldl    rr4, rr8
      inc    r5, #10
      ld     @rr4, r3
      ldl    rr2, rr10(#30)
      srll   rr2, #16
      ldk    r2, #0
      and    r3, #%00FF
      ldl    rr4, rr8
      inc    r5, #12
      ld     @rr4, r3
      bit    @rr10, #0
      jr     z, %000A6C
      ld     r2, rr10(#%0024)
      and    r2, #%01FF
      sla    r2, #7
      ld     |<<0>>%0006|(r15), r2
      jr     %000A70
      clr    |<<0>>%0006|(r15)
      ldl    rr2, rr8
      inc    r3, #14
      ld     r4, |<<0>>%0006|(r15)
      or     r4, <<0>>%0000
      ld     @rr2, r4
      bit    @rr10, #0
      jr     nz, %000A02
      ld     r2, #%0111
      ld     @rr8, r2
      ld     r2, r13
      add    r2, r13
      ldk    r3, #1
      sda    r3, r2
      or     r3, <<1>>%0172
      ld     <<1>>%0172, r3
      jr     %000AC6
      inc    r12, #1
      ld     r2, r13
      inc    r2, #1
      cp     r2, <<1>>%013E
      jr     ge, %000AB6
      ld     r2, r13
      inc    r2, #1
      jr     %000AB8
      sub    r2, r2
      ld     r13, r2
      cp     r12, <<1>>%013E
      jp     lt, <<0>>%0942
      test   <<1>>%0148
      jr     z, %000AE8
      incb   <<1>>%0040, #1
      ld     r2, <<1>>%0148
      ld     <<0>>%0000, r2
      ld     r7, #%80F0
      sub    r6, r6
      out    @r7, r6
      ld     r7, |<<0>>%0004|(r15)
      ldctl  fcw, r7
      ldm    r8, <<0>>%0008(r15), #6
      add    r15, #20
      ret
_mdint:
      sub    r15, #28
      ldm    <<0>>%0010(r15), r8, #6
      ldl    rr12, rr6
      dec    <<0>>%0000, #1
      dec    <<1>>%0148, #1
      ld     <<0>>%0000, #11
      cp     <<1>>%002A, #%0204
      jr     lt, %000B30
      ld     r7, #%80F2
      sub    r6, r6
      out    @r7, r6
      ld     r2, rr12(#32)
      and    r2, #%E000
      srl    r2, #13
      ld     |<<0>>%000E|(r15), r2
      sla    r2, #3
      ldl    rr4, #%0100011E
      add    r5, r2
      ldl    rr8, rr4
      ld     r2, rr8(#4)
      test   r2
      jr     nz, %000B6C
      ld     r5, rr12(#32)
      ldl    rr6, #%010001CC
      call _mdopen
      jp     <<0>>%0CA4
      test   <<1>>%0148
      jr     nz, %000B7A
      clrb   <<1>>%0040
      ldl    rr10, @rr8
      test   <<1>>%0028
      jr     nz, %000B98
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #12
      ld     r2, <<1>>%0174(r3)
      ld     |<<0>>%000C|(r15), r2
      jr     %000BAA
      ld     r2, |<<0>>%000E|(r15)
      sla    r2, #4
      ld     r3, <<1>>%0174(r2)
      ld     |<<0>>%000C|(r15), r3
      ld     r2, rr12(#32)
      and    r2, #%1F00
      test   r2
      jr     z, %000BBC
      bit    |<<0>>%000C|(r15), #15
      jr     z, %000BC6
      ldl    rr2, rr10
      add    r3, #%0024
      clr    @rr2
      jr     %000BFE
      ld     r5, rr12(#32)
      ldl    rr6, rr10
      sub    r4, r4
      call _mdopen
      ld     r2, |<<0>>%000E|(r15)
      add    r2, r2
      ldl    rr4, #%0100014A
      add    r5, r2
      inc    @rr4, #1
      ld     r2, @rr4
      cp     r2, #4
      jr     ge, %000BFC
      cp     <<1>>%002A, #%0204
      jr     lt, %000C96
      ld     r7, #%80F4
      jr     %000C9A
      set    @rr10, #2
      ldl    rr2, rr10(#14)
      ldl    rr4, rr10(#10)
      inc    r5, #14
      ldl    @rr4, rr2
      ldl    rr2, rr10(#10)
      ldl    rr4, rr10(#14)
      inc    r5, #10
      ldl    @rr4, rr2
      ld     r2, rr8(#6)
      test   r2
      jr     z, %000C24
      ldl    rr2, rr10(#10)
      jr     %000C28
      ldl    rr2, rr10(#14)
      ldl    @rr8, rr2
      ld     r3, |<<0>>%000E|(r15)
      mult   rr2, #%0028
      ldl    rr4, #%0100007E
      add    r5, r3
      cpl    rr4, @rr8
      jr     nz, %000C66
      ld     r2, rr8(#6)
      test   r2
      jr     nz, %000C4A
      ldk    r2, #1
      jr     %000C4C
      ldk    r2, #0
      ldl    rr4, rr8
      inc    r5, #6
      ld     @rr4, r2
      ld     r2, rr8(#6)
      test   r2
      jr     z, %000C60
      ldl    rr2, rr10(#10)
      jr     %000C64
      ldl    rr2, rr10(#14)
      ldl    @rr8, rr2
      ldl    rr2, rr10
      add    r3, #%0022
      clr    @rr2
      ld     r2, |<<0>>%000E|(r15)
      add    r2, r2
      ldl    rr4, #%0100014A
      add    r5, r2
      clr    @rr4
      ldl    rr2, rr8
      inc    r3, #4
      clr    @rr2
      ldl    rr6, rr10
      call _mdopen
      cp     <<1>>%002A, #%0204
      jr     ge, %000BF6
      ld     r7, #%80F2
      sub    r6, r6
      out    @r7, r6
      ld     r7, |<<0>>%000E|(r15)
      calr   _mdstart
      ldm    r8, <<0>>%0010(r15), #6
      add    r15, #28
      ret
_mdread:
      dec    r15, #2
      ld     |<<0>>%0000|(r15), r7
      ldl    rr6, #%0000074E
      ldl    rr4, #%01000054
      ld     r3, |<<0>>%0000|(r15)
      ldk    r2, #1
      call _mdopen
      inc    r15, #2
      ret
_mdwrite:
      dec    r15, #2
      ld     |<<0>>%0000|(r15), r7
      ldl    rr6, #%0000074E
      ldl    rr4, #%01000054
      ld     r3, |<<0>>%0000|(r15)
      sub    r2, r2
      call _mdopen
      inc    r15, #2
      ret
end

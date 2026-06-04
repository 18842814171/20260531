
/home/linda/5.29/code/myos/home/root/return0:     file format elf64-littleriscv


Disassembly of section .text:

0000000080380000 <_start>:
    80380000:	00008137          	lui	sp,0x8
    80380004:	0391011b          	addiw	sp,sp,57 # 8039 <_start-0x80377fc7>
    80380008:	0142                	slli	sp,sp,0x10
    8038000a:	010000ef          	jal	8038001a <main>
    8038000e:	4501                	li	a0,0
    80380010:	05d00893          	li	a7,93
    80380014:	00000073          	ecall
    80380018:	a001                	j	80380018 <_start+0x18>

000000008038001a <main>:
    8038001a:	1141                	addi	sp,sp,-16
    8038001c:	e406                	sd	ra,8(sp)
    8038001e:	e022                	sd	s0,0(sp)
    80380020:	0800                	addi	s0,sp,16
    80380022:	4781                	li	a5,0
    80380024:	853e                	mv	a0,a5
    80380026:	60a2                	ld	ra,8(sp)
    80380028:	6402                	ld	s0,0(sp)
    8038002a:	0141                	addi	sp,sp,16
    8038002c:	8082                	ret

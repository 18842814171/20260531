
code/myos/home/root/hi:     file format elf64-littleriscv


Disassembly of section .text:

0000000080380000 <_start>:
    80380000:	00008137          	lui	sp,0x8
    80380004:	0391011b          	addiw	sp,sp,57 # 8039 <_start-0x80377fc7>
    80380008:	0142                	slli	sp,sp,0x10
    8038000a:	052000ef          	jal	8038005c <main>
    8038000e:	4501                	li	a0,0
    80380010:	05d00893          	li	a7,93
    80380014:	00000073          	ecall
    80380018:	a001                	j	80380018 <_start+0x18>

000000008038001a <write>:
    8038001a:	1101                	addi	sp,sp,-32
    8038001c:	ec06                	sd	ra,24(sp)
    8038001e:	e822                	sd	s0,16(sp)
    80380020:	1000                	addi	s0,sp,32
    80380022:	87aa                	mv	a5,a0
    80380024:	feb43023          	sd	a1,-32(s0)
    80380028:	8732                	mv	a4,a2
    8038002a:	fef42623          	sw	a5,-20(s0)
    8038002e:	87ba                	mv	a5,a4
    80380030:	fef42423          	sw	a5,-24(s0)
    80380034:	fec42783          	lw	a5,-20(s0)
    80380038:	853e                	mv	a0,a5
    8038003a:	fe043783          	ld	a5,-32(s0)
    8038003e:	85be                	mv	a1,a5
    80380040:	fe842783          	lw	a5,-24(s0)
    80380044:	863e                	mv	a2,a5
    80380046:	04000893          	li	a7,64
    8038004a:	00000073          	ecall
    8038004e:	87aa                	mv	a5,a0
    80380050:	2781                	sext.w	a5,a5
    80380052:	853e                	mv	a0,a5
    80380054:	60e2                	ld	ra,24(sp)
    80380056:	6442                	ld	s0,16(sp)
    80380058:	6105                	addi	sp,sp,32
    8038005a:	8082                	ret

000000008038005c <main>:
    8038005c:	1141                	addi	sp,sp,-16
    8038005e:	e406                	sd	ra,8(sp)
    80380060:	e022                	sd	s0,0(sp)
    80380062:	0800                	addi	s0,sp,16
    80380064:	4635                	li	a2,13
    80380066:	00000597          	auipc	a1,0x0
    8038006a:	01a58593          	addi	a1,a1,26 # 80380080 <main+0x24>
    8038006e:	4505                	li	a0,1
    80380070:	fabff0ef          	jal	8038001a <write>
    80380074:	4781                	li	a5,0
    80380076:	853e                	mv	a0,a5
    80380078:	60a2                	ld	ra,8(sp)
    8038007a:	6402                	ld	s0,0(sp)
    8038007c:	0141                	addi	sp,sp,16
    8038007e:	8082                	ret

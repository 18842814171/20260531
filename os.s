
code/myos/out/os:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_start>:
    80200000:	822a                	mv	tp,a0
    80200002:	e921                	bnez	a0,80200052 <park>
    80200004:	10401073          	csrw	sie,zero
    80200008:	4309                	li	t1,2
    8020000a:	10033073          	csrc	sstatus,t1
    8020000e:	00008137          	lui	sp,0x8
    80200012:	0211011b          	addiw	sp,sp,33 # 8021 <STACK_SIZE+0x7021>
    80200016:	0142                	slli	sp,sp,0x10
    80200018:	0000f297          	auipc	t0,0xf
    8020001c:	05828293          	addi	t0,t0,88 # 8020f070 <boot_hartid>
    80200020:	00119317          	auipc	t1,0x119
    80200024:	bb830313          	addi	t1,t1,-1096 # 80318bd8 <_bss_end>
    80200028:	0062f763          	bgeu	t0,t1,80200036 <_start+0x36>
    8020002c:	0002b023          	sd	zero,0(t0)
    80200030:	02a1                	addi	t0,t0,8
    80200032:	fe62ede3          	bltu	t0,t1,8020002c <_start+0x2c>
    80200036:	0000f397          	auipc	t2,0xf
    8020003a:	03a38393          	addi	t2,t2,58 # 8020f070 <boot_hartid>
    8020003e:	00a3b023          	sd	a0,0(t2)
    80200042:	0000f397          	auipc	t2,0xf
    80200046:	03638393          	addi	t2,t2,54 # 8020f078 <boot_dtb>
    8020004a:	00b3b023          	sd	a1,0(t2)
    8020004e:	4820006f          	j	802004d0 <start_kernel>

0000000080200052 <park>:
    80200052:	10500073          	wfi
    80200056:	bff5                	j	80200052 <park>

0000000080200058 <trap_vector>:
    80200058:	140f9ff3          	csrrw	t6,sscratch,t6
    8020005c:	14102ef3          	csrr	t4,sepc
    80200060:	00007297          	auipc	t0,0x7
    80200064:	e0828293          	addi	t0,t0,-504 # 80206e68 <user_code_start>
    80200068:	0002b283          	ld	t0,0(t0)
    8020006c:	005eee63          	bltu	t4,t0,80200088 <trap_vector+0x30>
    80200070:	00007297          	auipc	t0,0x7
    80200074:	e0028293          	addi	t0,t0,-512 # 80206e70 <user_code_end>
    80200078:	0002b283          	ld	t0,0(t0)
    8020007c:	005ef663          	bgeu	t4,t0,80200088 <trap_vector+0x30>
    80200080:	00013f97          	auipc	t6,0x13
    80200084:	c58f8f93          	addi	t6,t6,-936 # 80212cd8 <user_cxt>
    80200088:	001fb023          	sd	ra,0(t6)
    8020008c:	002fb423          	sd	sp,8(t6)
    80200090:	003fb823          	sd	gp,16(t6)
    80200094:	004fbc23          	sd	tp,24(t6)
    80200098:	025fb023          	sd	t0,32(t6)
    8020009c:	026fb423          	sd	t1,40(t6)
    802000a0:	027fb823          	sd	t2,48(t6)
    802000a4:	028fbc23          	sd	s0,56(t6)
    802000a8:	049fb023          	sd	s1,64(t6)
    802000ac:	04afb423          	sd	a0,72(t6)
    802000b0:	04bfb823          	sd	a1,80(t6)
    802000b4:	04cfbc23          	sd	a2,88(t6)
    802000b8:	06dfb023          	sd	a3,96(t6)
    802000bc:	06efb423          	sd	a4,104(t6)
    802000c0:	06ffb823          	sd	a5,112(t6)
    802000c4:	070fbc23          	sd	a6,120(t6)
    802000c8:	091fb023          	sd	a7,128(t6)
    802000cc:	092fb423          	sd	s2,136(t6)
    802000d0:	093fb823          	sd	s3,144(t6)
    802000d4:	094fbc23          	sd	s4,152(t6)
    802000d8:	0b5fb023          	sd	s5,160(t6)
    802000dc:	0b6fb423          	sd	s6,168(t6)
    802000e0:	0b7fb823          	sd	s7,176(t6)
    802000e4:	0b8fbc23          	sd	s8,184(t6)
    802000e8:	0d9fb023          	sd	s9,192(t6)
    802000ec:	0dafb423          	sd	s10,200(t6)
    802000f0:	0dbfb823          	sd	s11,208(t6)
    802000f4:	0dcfbc23          	sd	t3,216(t6)
    802000f8:	0fdfb023          	sd	t4,224(t6)
    802000fc:	0fefb423          	sd	t5,232(t6)
    80200100:	8f7e                	mv	t5,t6
    80200102:	14002ff3          	csrr	t6,sscratch
    80200106:	0fff3823          	sd	t6,240(t5)
    8020010a:	14102573          	csrr	a0,sepc
    8020010e:	0eaf3c23          	sd	a0,248(t5)
    80200112:	140f1073          	csrw	sscratch,t5
    80200116:	14102573          	csrr	a0,sepc
    8020011a:	142025f3          	csrr	a1,scause
    8020011e:	867a                	mv	a2,t5
    80200120:	14102ef3          	csrr	t4,sepc
    80200124:	00007297          	auipc	t0,0x7
    80200128:	d4428293          	addi	t0,t0,-700 # 80206e68 <user_code_start>
    8020012c:	0002b283          	ld	t0,0(t0)
    80200130:	025ee063          	bltu	t4,t0,80200150 <trap_vector+0xf8>
    80200134:	00007297          	auipc	t0,0x7
    80200138:	d3c28293          	addi	t0,t0,-708 # 80206e70 <user_code_end>
    8020013c:	0002b283          	ld	t0,0(t0)
    80200140:	005ef863          	bgeu	t4,t0,80200150 <trap_vector+0xf8>
    80200144:	00007e17          	auipc	t3,0x7
    80200148:	d1ce0e13          	addi	t3,t3,-740 # 80206e60 <kernel_trap_sp>
    8020014c:	000e3103          	ld	sp,0(t3)
    80200150:	407010ef          	jal	80201d56 <trap_handler>
    80200154:	14151073          	csrw	sepc,a0
    80200158:	1141                	addi	sp,sp,-16
    8020015a:	e006                	sd	ra,0(sp)
    8020015c:	e42a                	sd	a0,8(sp)
    8020015e:	7c5010ef          	jal	80202122 <trap_diag_post_handler>
    80200162:	6522                	ld	a0,8(sp)
    80200164:	6082                	ld	ra,0(sp)
    80200166:	0141                	addi	sp,sp,16
    80200168:	0000fe97          	auipc	t4,0xf
    8020016c:	f2ce8e93          	addi	t4,t4,-212 # 8020f094 <prog_exec_restore_shell>
    80200170:	000eae83          	lw	t4,0(t4)
    80200174:	000e8d63          	beqz	t4,8020018e <trap_vector+0x136>
    80200178:	1141                	addi	sp,sp,-16
    8020017a:	e006                	sd	ra,0(sp)
    8020017c:	022020ef          	jal	8020219e <trap_diag_shell_restore_branch>
    80200180:	6082                	ld	ra,0(sp)
    80200182:	0141                	addi	sp,sp,16
    80200184:	00013f97          	auipc	t6,0x13
    80200188:	c54f8f93          	addi	t6,t6,-940 # 80212dd8 <shell_save_cxt>
    8020018c:	a019                	j	80200192 <trap_vector+0x13a>
    8020018e:	14002ff3          	csrr	t6,sscratch
    80200192:	000fb083          	ld	ra,0(t6)
    80200196:	008fb103          	ld	sp,8(t6)
    8020019a:	010fb183          	ld	gp,16(t6)
    8020019e:	018fb203          	ld	tp,24(t6)
    802001a2:	020fb283          	ld	t0,32(t6)
    802001a6:	028fb303          	ld	t1,40(t6)
    802001aa:	030fb383          	ld	t2,48(t6)
    802001ae:	038fb403          	ld	s0,56(t6)
    802001b2:	040fb483          	ld	s1,64(t6)
    802001b6:	048fb503          	ld	a0,72(t6)
    802001ba:	050fb583          	ld	a1,80(t6)
    802001be:	058fb603          	ld	a2,88(t6)
    802001c2:	060fb683          	ld	a3,96(t6)
    802001c6:	068fb703          	ld	a4,104(t6)
    802001ca:	070fb783          	ld	a5,112(t6)
    802001ce:	078fb803          	ld	a6,120(t6)
    802001d2:	080fb883          	ld	a7,128(t6)
    802001d6:	088fb903          	ld	s2,136(t6)
    802001da:	090fb983          	ld	s3,144(t6)
    802001de:	098fba03          	ld	s4,152(t6)
    802001e2:	0a0fba83          	ld	s5,160(t6)
    802001e6:	0a8fbb03          	ld	s6,168(t6)
    802001ea:	0b0fbb83          	ld	s7,176(t6)
    802001ee:	0b8fbc03          	ld	s8,184(t6)
    802001f2:	0c0fbc83          	ld	s9,192(t6)
    802001f6:	0c8fbd03          	ld	s10,200(t6)
    802001fa:	0d0fbd83          	ld	s11,208(t6)
    802001fe:	0d8fbe03          	ld	t3,216(t6)
    80200202:	0e0fbe83          	ld	t4,224(t6)
    80200206:	0e8fbf03          	ld	t5,232(t6)
    8020020a:	0f0fbf83          	ld	t6,240(t6)
    8020020e:	0000fe97          	auipc	t4,0xf
    80200212:	e86e8e93          	addi	t4,t4,-378 # 8020f094 <prog_exec_restore_shell>
    80200216:	000e8863          	beqz	t4,80200226 <trap_vector+0x1ce>
    8020021a:	0000fe97          	auipc	t4,0xf
    8020021e:	e7ae8e93          	addi	t4,t4,-390 # 8020f094 <prog_exec_restore_shell>
    80200222:	000ea023          	sw	zero,0(t4)
    80200226:	10200073          	sret
    8020022a:	0001                	nop

000000008020022c <switch_to>:
    8020022c:	7d6c                	ld	a1,248(a0)
    8020022e:	14159073          	csrw	sepc,a1
    80200232:	8faa                	mv	t6,a0
    80200234:	000fb083          	ld	ra,0(t6)
    80200238:	008fb103          	ld	sp,8(t6)
    8020023c:	010fb183          	ld	gp,16(t6)
    80200240:	018fb203          	ld	tp,24(t6)
    80200244:	020fb283          	ld	t0,32(t6)
    80200248:	028fb303          	ld	t1,40(t6)
    8020024c:	030fb383          	ld	t2,48(t6)
    80200250:	038fb403          	ld	s0,56(t6)
    80200254:	040fb483          	ld	s1,64(t6)
    80200258:	048fb503          	ld	a0,72(t6)
    8020025c:	050fb583          	ld	a1,80(t6)
    80200260:	058fb603          	ld	a2,88(t6)
    80200264:	060fb683          	ld	a3,96(t6)
    80200268:	068fb703          	ld	a4,104(t6)
    8020026c:	070fb783          	ld	a5,112(t6)
    80200270:	078fb803          	ld	a6,120(t6)
    80200274:	080fb883          	ld	a7,128(t6)
    80200278:	088fb903          	ld	s2,136(t6)
    8020027c:	090fb983          	ld	s3,144(t6)
    80200280:	098fba03          	ld	s4,152(t6)
    80200284:	0a0fba83          	ld	s5,160(t6)
    80200288:	0a8fbb03          	ld	s6,168(t6)
    8020028c:	0b0fbb83          	ld	s7,176(t6)
    80200290:	0b8fbc03          	ld	s8,184(t6)
    80200294:	0c0fbc83          	ld	s9,192(t6)
    80200298:	0c8fbd03          	ld	s10,200(t6)
    8020029c:	0d0fbd83          	ld	s11,208(t6)
    802002a0:	0d8fbe03          	ld	t3,216(t6)
    802002a4:	0e0fbe83          	ld	t4,224(t6)
    802002a8:	0e8fbf03          	ld	t5,232(t6)
    802002ac:	0f0fbf83          	ld	t6,240(t6)
    802002b0:	10200073          	sret
    802002b4:	0001                	nop

00000000802002b6 <gethid>:
    802002b6:	4885                	li	a7,1
    802002b8:	00000073          	ecall
    802002bc:	8082                	ret

00000000802002be <write>:
    802002be:	04000893          	li	a7,64
    802002c2:	00000073          	ecall
    802002c6:	8082                	ret

00000000802002c8 <read>:
    802002c8:	03f00893          	li	a7,63
    802002cc:	00000073          	ecall
    802002d0:	8082                	ret

00000000802002d2 <exit>:
    802002d2:	05d00893          	li	a7,93
    802002d6:	00000073          	ecall
    802002da:	8082                	ret

00000000802002dc <fork>:
    802002dc:	0d600893          	li	a7,214
    802002e0:	00000073          	ecall
    802002e4:	8082                	ret

00000000802002e6 <r_sstatus>:
    802002e6:	1101                	addi	sp,sp,-32
    802002e8:	ec06                	sd	ra,24(sp)
    802002ea:	e822                	sd	s0,16(sp)
    802002ec:	1000                	addi	s0,sp,32
    802002ee:	100027f3          	csrr	a5,sstatus
    802002f2:	fef43423          	sd	a5,-24(s0)
    802002f6:	fe843783          	ld	a5,-24(s0)
    802002fa:	853e                	mv	a0,a5
    802002fc:	60e2                	ld	ra,24(sp)
    802002fe:	6442                	ld	s0,16(sp)
    80200300:	6105                	addi	sp,sp,32
    80200302:	8082                	ret

0000000080200304 <w_sstatus>:
    80200304:	1101                	addi	sp,sp,-32
    80200306:	ec06                	sd	ra,24(sp)
    80200308:	e822                	sd	s0,16(sp)
    8020030a:	1000                	addi	s0,sp,32
    8020030c:	fea43423          	sd	a0,-24(s0)
    80200310:	fe843783          	ld	a5,-24(s0)
    80200314:	10079073          	csrw	sstatus,a5
    80200318:	0001                	nop
    8020031a:	60e2                	ld	ra,24(sp)
    8020031c:	6442                	ld	s0,16(sp)
    8020031e:	6105                	addi	sp,sp,32
    80200320:	8082                	ret

0000000080200322 <r_stvec>:
    80200322:	1101                	addi	sp,sp,-32
    80200324:	ec06                	sd	ra,24(sp)
    80200326:	e822                	sd	s0,16(sp)
    80200328:	1000                	addi	s0,sp,32
    8020032a:	105027f3          	csrr	a5,stvec
    8020032e:	fef43423          	sd	a5,-24(s0)
    80200332:	fe843783          	ld	a5,-24(s0)
    80200336:	853e                	mv	a0,a5
    80200338:	60e2                	ld	ra,24(sp)
    8020033a:	6442                	ld	s0,16(sp)
    8020033c:	6105                	addi	sp,sp,32
    8020033e:	8082                	ret

0000000080200340 <trap_vec_read>:
    80200340:	1141                	addi	sp,sp,-16
    80200342:	e406                	sd	ra,8(sp)
    80200344:	e022                	sd	s0,0(sp)
    80200346:	0800                	addi	s0,sp,16
    80200348:	fdbff0ef          	jal	80200322 <r_stvec>
    8020034c:	87aa                	mv	a5,a0
    8020034e:	853e                	mv	a0,a5
    80200350:	60a2                	ld	ra,8(sp)
    80200352:	6402                	ld	s0,0(sp)
    80200354:	0141                	addi	sp,sp,16
    80200356:	8082                	ret

0000000080200358 <cpu_irq_enable>:
    80200358:	1141                	addi	sp,sp,-16
    8020035a:	e406                	sd	ra,8(sp)
    8020035c:	e022                	sd	s0,0(sp)
    8020035e:	0800                	addi	s0,sp,16
    80200360:	f87ff0ef          	jal	802002e6 <r_sstatus>
    80200364:	87aa                	mv	a5,a0
    80200366:	0027e793          	ori	a5,a5,2
    8020036a:	853e                	mv	a0,a5
    8020036c:	f99ff0ef          	jal	80200304 <w_sstatus>
    80200370:	0001                	nop
    80200372:	60a2                	ld	ra,8(sp)
    80200374:	6402                	ld	s0,0(sp)
    80200376:	0141                	addi	sp,sp,16
    80200378:	8082                	ret

000000008020037a <clear_bss>:
    8020037a:	1101                	addi	sp,sp,-32
    8020037c:	ec06                	sd	ra,24(sp)
    8020037e:	e822                	sd	s0,16(sp)
    80200380:	1000                	addi	s0,sp,32
    80200382:	0000f797          	auipc	a5,0xf
    80200386:	cee78793          	addi	a5,a5,-786 # 8020f070 <boot_hartid>
    8020038a:	fef43423          	sd	a5,-24(s0)
    8020038e:	a811                	j	802003a2 <clear_bss+0x28>
    80200390:	fe843783          	ld	a5,-24(s0)
    80200394:	00078023          	sb	zero,0(a5)
    80200398:	fe843783          	ld	a5,-24(s0)
    8020039c:	0785                	addi	a5,a5,1
    8020039e:	fef43423          	sd	a5,-24(s0)
    802003a2:	fe843703          	ld	a4,-24(s0)
    802003a6:	00119797          	auipc	a5,0x119
    802003aa:	83278793          	addi	a5,a5,-1998 # 80318bd8 <_bss_end>
    802003ae:	fef761e3          	bltu	a4,a5,80200390 <clear_bss+0x16>
    802003b2:	0001                	nop
    802003b4:	0001                	nop
    802003b6:	60e2                	ld	ra,24(sp)
    802003b8:	6442                	ld	s0,16(sp)
    802003ba:	6105                	addi	sp,sp,32
    802003bc:	8082                	ret

00000000802003be <osviz_log_boot_progress>:
    802003be:	7135                	addi	sp,sp,-160
    802003c0:	ed06                	sd	ra,152(sp)
    802003c2:	e922                	sd	s0,144(sp)
    802003c4:	1100                	addi	s0,sp,160
    802003c6:	00007797          	auipc	a5,0x7
    802003ca:	a9278793          	addi	a5,a5,-1390 # 80206e58 <BSS_END>
    802003ce:	6398                	ld	a4,0(a5)
    802003d0:	00007797          	auipc	a5,0x7
    802003d4:	a8078793          	addi	a5,a5,-1408 # 80206e50 <BSS_START>
    802003d8:	639c                	ld	a5,0(a5)
    802003da:	40f707b3          	sub	a5,a4,a5
    802003de:	fef43423          	sd	a5,-24(s0)
    802003e2:	00007617          	auipc	a2,0x7
    802003e6:	a9660613          	addi	a2,a2,-1386 # 80206e78 <user_code_end+0x8>
    802003ea:	00007597          	auipc	a1,0x7
    802003ee:	ac658593          	addi	a1,a1,-1338 # 80206eb0 <user_code_end+0x40>
    802003f2:	00007517          	auipc	a0,0x7
    802003f6:	ac650513          	addi	a0,a0,-1338 # 80206eb8 <user_code_end+0x48>
    802003fa:	284010ef          	jal	8020167e <osviz_event>
    802003fe:	0000f797          	auipc	a5,0xf
    80200402:	c7278793          	addi	a5,a5,-910 # 8020f070 <boot_hartid>
    80200406:	639c                	ld	a5,0(a5)
    80200408:	0007869b          	sext.w	a3,a5
    8020040c:	0000f797          	auipc	a5,0xf
    80200410:	c6c78793          	addi	a5,a5,-916 # 8020f078 <boot_dtb>
    80200414:	6398                	ld	a4,0(a5)
    80200416:	f6840793          	addi	a5,s0,-152
    8020041a:	00007617          	auipc	a2,0x7
    8020041e:	aa660613          	addi	a2,a2,-1370 # 80206ec0 <user_code_end+0x50>
    80200422:	08000593          	li	a1,128
    80200426:	853e                	mv	a0,a5
    80200428:	066010ef          	jal	8020148e <snprintf>
    8020042c:	f6840793          	addi	a5,s0,-152
    80200430:	863e                	mv	a2,a5
    80200432:	00007597          	auipc	a1,0x7
    80200436:	aa658593          	addi	a1,a1,-1370 # 80206ed8 <user_code_end+0x68>
    8020043a:	00007517          	auipc	a0,0x7
    8020043e:	a7e50513          	addi	a0,a0,-1410 # 80206eb8 <user_code_end+0x48>
    80200442:	23c010ef          	jal	8020167e <osviz_event>
    80200446:	00007797          	auipc	a5,0x7
    8020044a:	a0a78793          	addi	a5,a5,-1526 # 80206e50 <BSS_START>
    8020044e:	6394                	ld	a3,0(a5)
    80200450:	00007797          	auipc	a5,0x7
    80200454:	a0878793          	addi	a5,a5,-1528 # 80206e58 <BSS_END>
    80200458:	6398                	ld	a4,0(a5)
    8020045a:	fe843783          	ld	a5,-24(s0)
    8020045e:	2781                	sext.w	a5,a5
    80200460:	f6840513          	addi	a0,s0,-152
    80200464:	00007617          	auipc	a2,0x7
    80200468:	a8460613          	addi	a2,a2,-1404 # 80206ee8 <user_code_end+0x78>
    8020046c:	08000593          	li	a1,128
    80200470:	01e010ef          	jal	8020148e <snprintf>
    80200474:	f6840793          	addi	a5,s0,-152
    80200478:	863e                	mv	a2,a5
    8020047a:	00007597          	auipc	a1,0x7
    8020047e:	aa658593          	addi	a1,a1,-1370 # 80206f20 <user_code_end+0xb0>
    80200482:	00007517          	auipc	a0,0x7
    80200486:	a3650513          	addi	a0,a0,-1482 # 80206eb8 <user_code_end+0x48>
    8020048a:	1f4010ef          	jal	8020167e <osviz_event>
    8020048e:	00007617          	auipc	a2,0x7
    80200492:	aa260613          	addi	a2,a2,-1374 # 80206f30 <user_code_end+0xc0>
    80200496:	00007597          	auipc	a1,0x7
    8020049a:	aaa58593          	addi	a1,a1,-1366 # 80206f40 <user_code_end+0xd0>
    8020049e:	00007517          	auipc	a0,0x7
    802004a2:	a1a50513          	addi	a0,a0,-1510 # 80206eb8 <user_code_end+0x48>
    802004a6:	1d8010ef          	jal	8020167e <osviz_event>
    802004aa:	00007617          	auipc	a2,0x7
    802004ae:	aa660613          	addi	a2,a2,-1370 # 80206f50 <user_code_end+0xe0>
    802004b2:	00007597          	auipc	a1,0x7
    802004b6:	ace58593          	addi	a1,a1,-1330 # 80206f80 <user_code_end+0x110>
    802004ba:	00007517          	auipc	a0,0x7
    802004be:	9fe50513          	addi	a0,a0,-1538 # 80206eb8 <user_code_end+0x48>
    802004c2:	1bc010ef          	jal	8020167e <osviz_event>
    802004c6:	0001                	nop
    802004c8:	60ea                	ld	ra,152(sp)
    802004ca:	644a                	ld	s0,144(sp)
    802004cc:	610d                	addi	sp,sp,160
    802004ce:	8082                	ret

00000000802004d0 <start_kernel>:
    802004d0:	715d                	addi	sp,sp,-80
    802004d2:	e486                	sd	ra,72(sp)
    802004d4:	e0a2                	sd	s0,64(sp)
    802004d6:	0880                	addi	s0,sp,80
    802004d8:	446000ef          	jal	8020091e <uart_init>
    802004dc:	7c0010ef          	jal	80201c9c <trap_init>
    802004e0:	10c010ef          	jal	802015ec <osviz_init>
    802004e4:	318010ef          	jal	802017fc <osviz_boot_banner>
    802004e8:	ed7ff0ef          	jal	802003be <osviz_log_boot_progress>
    802004ec:	4601                	li	a2,0
    802004ee:	00007597          	auipc	a1,0x7
    802004f2:	aa258593          	addi	a1,a1,-1374 # 80206f90 <user_code_end+0x120>
    802004f6:	00007517          	auipc	a0,0x7
    802004fa:	9c250513          	addi	a0,a0,-1598 # 80206eb8 <user_code_end+0x48>
    802004fe:	180010ef          	jal	8020167e <osviz_event>
    80200502:	0d4050ef          	jal	802055d6 <fs_init>
    80200506:	1d1020ef          	jal	80202ed6 <proc_init>
    8020050a:	278020ef          	jal	80202782 <page_init>
    8020050e:	4601                	li	a2,0
    80200510:	00007597          	auipc	a1,0x7
    80200514:	a9058593          	addi	a1,a1,-1392 # 80206fa0 <user_code_end+0x130>
    80200518:	00007517          	auipc	a0,0x7
    8020051c:	9a050513          	addi	a0,a0,-1632 # 80206eb8 <user_code_end+0x48>
    80200520:	15e010ef          	jal	8020167e <osviz_event>
    80200524:	e1dff0ef          	jal	80200340 <trap_vec_read>
    80200528:	872a                	mv	a4,a0
    8020052a:	fb040793          	addi	a5,s0,-80
    8020052e:	86ba                	mv	a3,a4
    80200530:	00007617          	auipc	a2,0x7
    80200534:	a8060613          	addi	a2,a2,-1408 # 80206fb0 <user_code_end+0x140>
    80200538:	04000593          	li	a1,64
    8020053c:	853e                	mv	a0,a5
    8020053e:	751000ef          	jal	8020148e <snprintf>
    80200542:	fb040793          	addi	a5,s0,-80
    80200546:	863e                	mv	a2,a5
    80200548:	00007597          	auipc	a1,0x7
    8020054c:	a7858593          	addi	a1,a1,-1416 # 80206fc0 <user_code_end+0x150>
    80200550:	00007517          	auipc	a0,0x7
    80200554:	96850513          	addi	a0,a0,-1688 # 80206eb8 <user_code_end+0x48>
    80200558:	126010ef          	jal	8020167e <osviz_event>
    8020055c:	034020ef          	jal	80202590 <plic_init>
    80200560:	4601                	li	a2,0
    80200562:	00007597          	auipc	a1,0x7
    80200566:	a6e58593          	addi	a1,a1,-1426 # 80206fd0 <user_code_end+0x160>
    8020056a:	00007517          	auipc	a0,0x7
    8020056e:	94e50513          	addi	a0,a0,-1714 # 80206eb8 <user_code_end+0x48>
    80200572:	10c010ef          	jal	8020167e <osviz_event>
    80200576:	44e000ef          	jal	802009c4 <uart_irq_enable>
    8020057a:	53f010ef          	jal	802022b8 <timer_init>
    8020057e:	00007617          	auipc	a2,0x7
    80200582:	a6260613          	addi	a2,a2,-1438 # 80206fe0 <user_code_end+0x170>
    80200586:	00007597          	auipc	a1,0x7
    8020058a:	a6a58593          	addi	a1,a1,-1430 # 80206ff0 <user_code_end+0x180>
    8020058e:	00007517          	auipc	a0,0x7
    80200592:	92a50513          	addi	a0,a0,-1750 # 80206eb8 <user_code_end+0x48>
    80200596:	0e8010ef          	jal	8020167e <osviz_event>
    8020059a:	6c8020ef          	jal	80202c62 <sched_init>
    8020059e:	4601                	li	a2,0
    802005a0:	00007597          	auipc	a1,0x7
    802005a4:	a6058593          	addi	a1,a1,-1440 # 80207000 <user_code_end+0x190>
    802005a8:	00007517          	auipc	a0,0x7
    802005ac:	91050513          	addi	a0,a0,-1776 # 80206eb8 <user_code_end+0x48>
    802005b0:	0ce010ef          	jal	8020167e <osviz_event>
    802005b4:	218050ef          	jal	802057cc <os_main>
    802005b8:	00007617          	auipc	a2,0x7
    802005bc:	a5860613          	addi	a2,a2,-1448 # 80207010 <user_code_end+0x1a0>
    802005c0:	00007597          	auipc	a1,0x7
    802005c4:	a6058593          	addi	a1,a1,-1440 # 80207020 <user_code_end+0x1b0>
    802005c8:	00007517          	auipc	a0,0x7
    802005cc:	8f050513          	addi	a0,a0,-1808 # 80206eb8 <user_code_end+0x48>
    802005d0:	0ae010ef          	jal	8020167e <osviz_event>
    802005d4:	00007617          	auipc	a2,0x7
    802005d8:	a5c60613          	addi	a2,a2,-1444 # 80207030 <user_code_end+0x1c0>
    802005dc:	00007597          	auipc	a1,0x7
    802005e0:	a6458593          	addi	a1,a1,-1436 # 80207040 <user_code_end+0x1d0>
    802005e4:	00007517          	auipc	a0,0x7
    802005e8:	8d450513          	addi	a0,a0,-1836 # 80206eb8 <user_code_end+0x48>
    802005ec:	092010ef          	jal	8020167e <osviz_event>
    802005f0:	d69ff0ef          	jal	80200358 <cpu_irq_enable>
    802005f4:	00007517          	auipc	a0,0x7
    802005f8:	a5c50513          	addi	a0,a0,-1444 # 80207050 <user_code_end+0x1e0>
    802005fc:	448000ef          	jal	80200a44 <uart_puts>
    80200600:	00007517          	auipc	a0,0x7
    80200604:	a6050513          	addi	a0,a0,-1440 # 80207060 <user_code_end+0x1f0>
    80200608:	43c000ef          	jal	80200a44 <uart_puts>
    8020060c:	122060ef          	jal	8020672e <console_run>
    80200610:	0001                	nop
    80200612:	60a6                	ld	ra,72(sp)
    80200614:	6406                	ld	s0,64(sp)
    80200616:	6161                	addi	sp,sp,80
    80200618:	8082                	ret

000000008020061a <uart_read_reg>:
    8020061a:	1101                	addi	sp,sp,-32
    8020061c:	ec06                	sd	ra,24(sp)
    8020061e:	e822                	sd	s0,16(sp)
    80200620:	1000                	addi	s0,sp,32
    80200622:	87aa                	mv	a5,a0
    80200624:	fef42623          	sw	a5,-20(s0)
    80200628:	fec42703          	lw	a4,-20(s0)
    8020062c:	100007b7          	lui	a5,0x10000
    80200630:	97ba                	add	a5,a5,a4
    80200632:	0007c783          	lbu	a5,0(a5) # 10000000 <_heap_size+0x8118bd8>
    80200636:	0ff7f793          	zext.b	a5,a5
    8020063a:	853e                	mv	a0,a5
    8020063c:	60e2                	ld	ra,24(sp)
    8020063e:	6442                	ld	s0,16(sp)
    80200640:	6105                	addi	sp,sp,32
    80200642:	8082                	ret

0000000080200644 <uart_write_reg>:
    80200644:	1101                	addi	sp,sp,-32
    80200646:	ec06                	sd	ra,24(sp)
    80200648:	e822                	sd	s0,16(sp)
    8020064a:	1000                	addi	s0,sp,32
    8020064c:	87aa                	mv	a5,a0
    8020064e:	872e                	mv	a4,a1
    80200650:	fef42623          	sw	a5,-20(s0)
    80200654:	87ba                	mv	a5,a4
    80200656:	fef405a3          	sb	a5,-21(s0)
    8020065a:	fec42703          	lw	a4,-20(s0)
    8020065e:	100007b7          	lui	a5,0x10000
    80200662:	97ba                	add	a5,a5,a4
    80200664:	873e                	mv	a4,a5
    80200666:	feb44783          	lbu	a5,-21(s0)
    8020066a:	00f70023          	sb	a5,0(a4)
    8020066e:	0001                	nop
    80200670:	60e2                	ld	ra,24(sp)
    80200672:	6442                	ld	s0,16(sp)
    80200674:	6105                	addi	sp,sp,32
    80200676:	8082                	ret

0000000080200678 <uart_rx_put>:
    80200678:	7179                	addi	sp,sp,-48
    8020067a:	f406                	sd	ra,40(sp)
    8020067c:	f022                	sd	s0,32(sp)
    8020067e:	1800                	addi	s0,sp,48
    80200680:	87aa                	mv	a5,a0
    80200682:	fcf40fa3          	sb	a5,-33(s0)
    80200686:	0000f797          	auipc	a5,0xf
    8020068a:	b1278793          	addi	a5,a5,-1262 # 8020f198 <uart_rx_head>
    8020068e:	439c                	lw	a5,0(a5)
    80200690:	2781                	sext.w	a5,a5
    80200692:	2785                	addiw	a5,a5,1
    80200694:	2781                	sext.w	a5,a5
    80200696:	873e                	mv	a4,a5
    80200698:	41f7579b          	sraiw	a5,a4,0x1f
    8020069c:	0187d79b          	srliw	a5,a5,0x18
    802006a0:	9f3d                	addw	a4,a4,a5
    802006a2:	0ff77713          	zext.b	a4,a4
    802006a6:	40f707bb          	subw	a5,a4,a5
    802006aa:	fef42623          	sw	a5,-20(s0)
    802006ae:	0000f797          	auipc	a5,0xf
    802006b2:	aee78793          	addi	a5,a5,-1298 # 8020f19c <uart_rx_tail>
    802006b6:	439c                	lw	a5,0(a5)
    802006b8:	2781                	sext.w	a5,a5
    802006ba:	fec42703          	lw	a4,-20(s0)
    802006be:	2701                	sext.w	a4,a4
    802006c0:	02f70b63          	beq	a4,a5,802006f6 <uart_rx_put+0x7e>
    802006c4:	0000f797          	auipc	a5,0xf
    802006c8:	ad478793          	addi	a5,a5,-1324 # 8020f198 <uart_rx_head>
    802006cc:	439c                	lw	a5,0(a5)
    802006ce:	2781                	sext.w	a5,a5
    802006d0:	0000f717          	auipc	a4,0xf
    802006d4:	9c870713          	addi	a4,a4,-1592 # 8020f098 <uart_rx_buf>
    802006d8:	97ba                	add	a5,a5,a4
    802006da:	fdf44703          	lbu	a4,-33(s0)
    802006de:	00e78023          	sb	a4,0(a5)
    802006e2:	0000f797          	auipc	a5,0xf
    802006e6:	ab678793          	addi	a5,a5,-1354 # 8020f198 <uart_rx_head>
    802006ea:	fec42703          	lw	a4,-20(s0)
    802006ee:	c398                	sw	a4,0(a5)
    802006f0:	1b2010ef          	jal	802018a2 <stats_inc_uart_rx>
    802006f4:	a011                	j	802006f8 <uart_rx_put+0x80>
    802006f6:	0001                	nop
    802006f8:	70a2                	ld	ra,40(sp)
    802006fa:	7402                	ld	s0,32(sp)
    802006fc:	6145                	addi	sp,sp,48
    802006fe:	8082                	ret

0000000080200700 <uart_rx_get>:
    80200700:	1101                	addi	sp,sp,-32
    80200702:	ec06                	sd	ra,24(sp)
    80200704:	e822                	sd	s0,16(sp)
    80200706:	1000                	addi	s0,sp,32
    80200708:	0000f797          	auipc	a5,0xf
    8020070c:	a9078793          	addi	a5,a5,-1392 # 8020f198 <uart_rx_head>
    80200710:	439c                	lw	a5,0(a5)
    80200712:	0007871b          	sext.w	a4,a5
    80200716:	0000f797          	auipc	a5,0xf
    8020071a:	a8678793          	addi	a5,a5,-1402 # 8020f19c <uart_rx_tail>
    8020071e:	439c                	lw	a5,0(a5)
    80200720:	2781                	sext.w	a5,a5
    80200722:	00f71463          	bne	a4,a5,8020072a <uart_rx_get+0x2a>
    80200726:	57fd                	li	a5,-1
    80200728:	a8a1                	j	80200780 <uart_rx_get+0x80>
    8020072a:	0000f797          	auipc	a5,0xf
    8020072e:	a7278793          	addi	a5,a5,-1422 # 8020f19c <uart_rx_tail>
    80200732:	439c                	lw	a5,0(a5)
    80200734:	2781                	sext.w	a5,a5
    80200736:	0000f717          	auipc	a4,0xf
    8020073a:	96270713          	addi	a4,a4,-1694 # 8020f098 <uart_rx_buf>
    8020073e:	97ba                	add	a5,a5,a4
    80200740:	0007c783          	lbu	a5,0(a5)
    80200744:	fef407a3          	sb	a5,-17(s0)
    80200748:	0000f797          	auipc	a5,0xf
    8020074c:	a5478793          	addi	a5,a5,-1452 # 8020f19c <uart_rx_tail>
    80200750:	439c                	lw	a5,0(a5)
    80200752:	2781                	sext.w	a5,a5
    80200754:	2785                	addiw	a5,a5,1
    80200756:	2781                	sext.w	a5,a5
    80200758:	873e                	mv	a4,a5
    8020075a:	41f7579b          	sraiw	a5,a4,0x1f
    8020075e:	0187d79b          	srliw	a5,a5,0x18
    80200762:	9f3d                	addw	a4,a4,a5
    80200764:	0ff77713          	zext.b	a4,a4
    80200768:	40f707bb          	subw	a5,a4,a5
    8020076c:	0007871b          	sext.w	a4,a5
    80200770:	0000f797          	auipc	a5,0xf
    80200774:	a2c78793          	addi	a5,a5,-1492 # 8020f19c <uart_rx_tail>
    80200778:	c398                	sw	a4,0(a5)
    8020077a:	fef44783          	lbu	a5,-17(s0)
    8020077e:	2781                	sext.w	a5,a5
    80200780:	853e                	mv	a0,a5
    80200782:	60e2                	ld	ra,24(sp)
    80200784:	6442                	ld	s0,16(sp)
    80200786:	6105                	addi	sp,sp,32
    80200788:	8082                	ret

000000008020078a <uart_rx_unget>:
    8020078a:	7179                	addi	sp,sp,-48
    8020078c:	f406                	sd	ra,40(sp)
    8020078e:	f022                	sd	s0,32(sp)
    80200790:	1800                	addi	s0,sp,48
    80200792:	87aa                	mv	a5,a0
    80200794:	fcf40fa3          	sb	a5,-33(s0)
    80200798:	0000f797          	auipc	a5,0xf
    8020079c:	a0478793          	addi	a5,a5,-1532 # 8020f19c <uart_rx_tail>
    802007a0:	439c                	lw	a5,0(a5)
    802007a2:	2781                	sext.w	a5,a5
    802007a4:	0ff7879b          	addiw	a5,a5,255
    802007a8:	2781                	sext.w	a5,a5
    802007aa:	873e                	mv	a4,a5
    802007ac:	41f7579b          	sraiw	a5,a4,0x1f
    802007b0:	0187d79b          	srliw	a5,a5,0x18
    802007b4:	9f3d                	addw	a4,a4,a5
    802007b6:	0ff77713          	zext.b	a4,a4
    802007ba:	40f707bb          	subw	a5,a4,a5
    802007be:	fef42623          	sw	a5,-20(s0)
    802007c2:	0000f797          	auipc	a5,0xf
    802007c6:	9d678793          	addi	a5,a5,-1578 # 8020f198 <uart_rx_head>
    802007ca:	439c                	lw	a5,0(a5)
    802007cc:	2781                	sext.w	a5,a5
    802007ce:	fec42703          	lw	a4,-20(s0)
    802007d2:	2701                	sext.w	a4,a4
    802007d4:	02f70963          	beq	a4,a5,80200806 <uart_rx_unget+0x7c>
    802007d8:	0000f797          	auipc	a5,0xf
    802007dc:	9c478793          	addi	a5,a5,-1596 # 8020f19c <uart_rx_tail>
    802007e0:	fec42703          	lw	a4,-20(s0)
    802007e4:	c398                	sw	a4,0(a5)
    802007e6:	0000f797          	auipc	a5,0xf
    802007ea:	9b678793          	addi	a5,a5,-1610 # 8020f19c <uart_rx_tail>
    802007ee:	439c                	lw	a5,0(a5)
    802007f0:	2781                	sext.w	a5,a5
    802007f2:	0000f717          	auipc	a4,0xf
    802007f6:	8a670713          	addi	a4,a4,-1882 # 8020f098 <uart_rx_buf>
    802007fa:	97ba                	add	a5,a5,a4
    802007fc:	fdf44703          	lbu	a4,-33(s0)
    80200800:	00e78023          	sb	a4,0(a5)
    80200804:	a011                	j	80200808 <uart_rx_unget+0x7e>
    80200806:	0001                	nop
    80200808:	70a2                	ld	ra,40(sp)
    8020080a:	7402                	ld	s0,32(sp)
    8020080c:	6145                	addi	sp,sp,48
    8020080e:	8082                	ret

0000000080200810 <uart_drain_echo_prefix>:
    80200810:	7159                	addi	sp,sp,-112
    80200812:	f486                	sd	ra,104(sp)
    80200814:	f0a2                	sd	s0,96(sp)
    80200816:	1880                	addi	s0,sp,112
    80200818:	f8a43c23          	sd	a0,-104(s0)
    8020081c:	fe042623          	sw	zero,-20(s0)
    80200820:	f9843783          	ld	a5,-104(s0)
    80200824:	cbd5                	beqz	a5,802008d8 <uart_drain_echo_prefix+0xc8>
    80200826:	a095                	j	8020088a <uart_drain_echo_prefix+0x7a>
    80200828:	4515                	li	a0,5
    8020082a:	df1ff0ef          	jal	8020061a <uart_read_reg>
    8020082e:	87aa                	mv	a5,a0
    80200830:	2781                	sext.w	a5,a5
    80200832:	8b85                	andi	a5,a5,1
    80200834:	2781                	sext.w	a5,a5
    80200836:	cbbd                	beqz	a5,802008ac <uart_drain_echo_prefix+0x9c>
    80200838:	4501                	li	a0,0
    8020083a:	de1ff0ef          	jal	8020061a <uart_read_reg>
    8020083e:	87aa                	mv	a5,a0
    80200840:	fef42423          	sw	a5,-24(s0)
    80200844:	fec42783          	lw	a5,-20(s0)
    80200848:	f9843703          	ld	a4,-104(s0)
    8020084c:	97ba                	add	a5,a5,a4
    8020084e:	0007c783          	lbu	a5,0(a5)
    80200852:	2781                	sext.w	a5,a5
    80200854:	fe842703          	lw	a4,-24(s0)
    80200858:	2701                	sext.w	a4,a4
    8020085a:	00f70a63          	beq	a4,a5,8020086e <uart_drain_echo_prefix+0x5e>
    8020085e:	fe842783          	lw	a5,-24(s0)
    80200862:	0ff7f793          	zext.b	a5,a5
    80200866:	853e                	mv	a0,a5
    80200868:	f23ff0ef          	jal	8020078a <uart_rx_unget>
    8020086c:	a089                	j	802008ae <uart_drain_echo_prefix+0x9e>
    8020086e:	fec42783          	lw	a5,-20(s0)
    80200872:	0017871b          	addiw	a4,a5,1
    80200876:	fee42623          	sw	a4,-20(s0)
    8020087a:	fe842703          	lw	a4,-24(s0)
    8020087e:	0ff77713          	zext.b	a4,a4
    80200882:	17c1                	addi	a5,a5,-16
    80200884:	97a2                	add	a5,a5,s0
    80200886:	fae78c23          	sb	a4,-72(a5)
    8020088a:	fec42783          	lw	a5,-20(s0)
    8020088e:	f9843703          	ld	a4,-104(s0)
    80200892:	97ba                	add	a5,a5,a4
    80200894:	0007c783          	lbu	a5,0(a5)
    80200898:	c3b1                	beqz	a5,802008dc <uart_drain_echo_prefix+0xcc>
    8020089a:	fec42783          	lw	a5,-20(s0)
    8020089e:	0007871b          	sext.w	a4,a5
    802008a2:	03e00793          	li	a5,62
    802008a6:	f8e7d1e3          	bge	a5,a4,80200828 <uart_drain_echo_prefix+0x18>
    802008aa:	a80d                	j	802008dc <uart_drain_echo_prefix+0xcc>
    802008ac:	0001                	nop
    802008ae:	a839                	j	802008cc <uart_drain_echo_prefix+0xbc>
    802008b0:	fec42783          	lw	a5,-20(s0)
    802008b4:	37fd                	addiw	a5,a5,-1
    802008b6:	fef42623          	sw	a5,-20(s0)
    802008ba:	fec42783          	lw	a5,-20(s0)
    802008be:	17c1                	addi	a5,a5,-16
    802008c0:	97a2                	add	a5,a5,s0
    802008c2:	fb87c783          	lbu	a5,-72(a5)
    802008c6:	853e                	mv	a0,a5
    802008c8:	ec3ff0ef          	jal	8020078a <uart_rx_unget>
    802008cc:	fec42783          	lw	a5,-20(s0)
    802008d0:	2781                	sext.w	a5,a5
    802008d2:	fcf04fe3          	bgtz	a5,802008b0 <uart_drain_echo_prefix+0xa0>
    802008d6:	a021                	j	802008de <uart_drain_echo_prefix+0xce>
    802008d8:	0001                	nop
    802008da:	a011                	j	802008de <uart_drain_echo_prefix+0xce>
    802008dc:	0001                	nop
    802008de:	70a6                	ld	ra,104(sp)
    802008e0:	7406                	ld	s0,96(sp)
    802008e2:	6165                	addi	sp,sp,112
    802008e4:	8082                	ret

00000000802008e6 <uart_rx_flush>:
    802008e6:	1141                	addi	sp,sp,-16
    802008e8:	e406                	sd	ra,8(sp)
    802008ea:	e022                	sd	s0,0(sp)
    802008ec:	0800                	addi	s0,sp,16
    802008ee:	0001                	nop
    802008f0:	e11ff0ef          	jal	80200700 <uart_rx_get>
    802008f4:	87aa                	mv	a5,a0
    802008f6:	fe07dde3          	bgez	a5,802008f0 <uart_rx_flush+0xa>
    802008fa:	a021                	j	80200902 <uart_rx_flush+0x1c>
    802008fc:	4501                	li	a0,0
    802008fe:	d1dff0ef          	jal	8020061a <uart_read_reg>
    80200902:	4515                	li	a0,5
    80200904:	d17ff0ef          	jal	8020061a <uart_read_reg>
    80200908:	87aa                	mv	a5,a0
    8020090a:	2781                	sext.w	a5,a5
    8020090c:	8b85                	andi	a5,a5,1
    8020090e:	2781                	sext.w	a5,a5
    80200910:	f7f5                	bnez	a5,802008fc <uart_rx_flush+0x16>
    80200912:	0001                	nop
    80200914:	0001                	nop
    80200916:	60a2                	ld	ra,8(sp)
    80200918:	6402                	ld	s0,0(sp)
    8020091a:	0141                	addi	sp,sp,16
    8020091c:	8082                	ret

000000008020091e <uart_init>:
    8020091e:	1101                	addi	sp,sp,-32
    80200920:	ec06                	sd	ra,24(sp)
    80200922:	e822                	sd	s0,16(sp)
    80200924:	1000                	addi	s0,sp,32
    80200926:	0000f797          	auipc	a5,0xf
    8020092a:	87278793          	addi	a5,a5,-1934 # 8020f198 <uart_rx_head>
    8020092e:	0007a023          	sw	zero,0(a5)
    80200932:	0000f797          	auipc	a5,0xf
    80200936:	86a78793          	addi	a5,a5,-1942 # 8020f19c <uart_rx_tail>
    8020093a:	0007a023          	sw	zero,0(a5)
    8020093e:	0000f797          	auipc	a5,0xf
    80200942:	86278793          	addi	a5,a5,-1950 # 8020f1a0 <uart_rx_use_irq>
    80200946:	0007a023          	sw	zero,0(a5)
    8020094a:	4581                	li	a1,0
    8020094c:	4505                	li	a0,1
    8020094e:	cf7ff0ef          	jal	80200644 <uart_write_reg>
    80200952:	450d                	li	a0,3
    80200954:	cc7ff0ef          	jal	8020061a <uart_read_reg>
    80200958:	87aa                	mv	a5,a0
    8020095a:	fef407a3          	sb	a5,-17(s0)
    8020095e:	fef44783          	lbu	a5,-17(s0)
    80200962:	f807e793          	ori	a5,a5,-128
    80200966:	0ff7f793          	zext.b	a5,a5
    8020096a:	85be                	mv	a1,a5
    8020096c:	450d                	li	a0,3
    8020096e:	cd7ff0ef          	jal	80200644 <uart_write_reg>
    80200972:	458d                	li	a1,3
    80200974:	4501                	li	a0,0
    80200976:	ccfff0ef          	jal	80200644 <uart_write_reg>
    8020097a:	4581                	li	a1,0
    8020097c:	4505                	li	a0,1
    8020097e:	cc7ff0ef          	jal	80200644 <uart_write_reg>
    80200982:	450d                	li	a0,3
    80200984:	c97ff0ef          	jal	8020061a <uart_read_reg>
    80200988:	87aa                	mv	a5,a0
    8020098a:	fef407a3          	sb	a5,-17(s0)
    8020098e:	fef40783          	lb	a5,-17(s0)
    80200992:	07c7f793          	andi	a5,a5,124
    80200996:	0187979b          	slliw	a5,a5,0x18
    8020099a:	4187d79b          	sraiw	a5,a5,0x18
    8020099e:	0037e793          	ori	a5,a5,3
    802009a2:	0187979b          	slliw	a5,a5,0x18
    802009a6:	4187d79b          	sraiw	a5,a5,0x18
    802009aa:	0ff7f793          	zext.b	a5,a5
    802009ae:	85be                	mv	a1,a5
    802009b0:	450d                	li	a0,3
    802009b2:	c93ff0ef          	jal	80200644 <uart_write_reg>
    802009b6:	f31ff0ef          	jal	802008e6 <uart_rx_flush>
    802009ba:	0001                	nop
    802009bc:	60e2                	ld	ra,24(sp)
    802009be:	6442                	ld	s0,16(sp)
    802009c0:	6105                	addi	sp,sp,32
    802009c2:	8082                	ret

00000000802009c4 <uart_irq_enable>:
    802009c4:	1141                	addi	sp,sp,-16
    802009c6:	e406                	sd	ra,8(sp)
    802009c8:	e022                	sd	s0,0(sp)
    802009ca:	0800                	addi	s0,sp,16
    802009cc:	0000e797          	auipc	a5,0xe
    802009d0:	7d478793          	addi	a5,a5,2004 # 8020f1a0 <uart_rx_use_irq>
    802009d4:	0007a023          	sw	zero,0(a5)
    802009d8:	4581                	li	a1,0
    802009da:	4505                	li	a0,1
    802009dc:	c69ff0ef          	jal	80200644 <uart_write_reg>
    802009e0:	00006617          	auipc	a2,0x6
    802009e4:	6b060613          	addi	a2,a2,1712 # 80207090 <user_code_end+0x220>
    802009e8:	00006597          	auipc	a1,0x6
    802009ec:	6c858593          	addi	a1,a1,1736 # 802070b0 <user_code_end+0x240>
    802009f0:	00006517          	auipc	a0,0x6
    802009f4:	6d050513          	addi	a0,a0,1744 # 802070c0 <user_code_end+0x250>
    802009f8:	487000ef          	jal	8020167e <osviz_event>
    802009fc:	0001                	nop
    802009fe:	60a2                	ld	ra,8(sp)
    80200a00:	6402                	ld	s0,0(sp)
    80200a02:	0141                	addi	sp,sp,16
    80200a04:	8082                	ret

0000000080200a06 <uart_putc>:
    80200a06:	1101                	addi	sp,sp,-32
    80200a08:	ec06                	sd	ra,24(sp)
    80200a0a:	e822                	sd	s0,16(sp)
    80200a0c:	1000                	addi	s0,sp,32
    80200a0e:	87aa                	mv	a5,a0
    80200a10:	fef407a3          	sb	a5,-17(s0)
    80200a14:	0001                	nop
    80200a16:	4515                	li	a0,5
    80200a18:	c03ff0ef          	jal	8020061a <uart_read_reg>
    80200a1c:	87aa                	mv	a5,a0
    80200a1e:	2781                	sext.w	a5,a5
    80200a20:	0207f793          	andi	a5,a5,32
    80200a24:	2781                	sext.w	a5,a5
    80200a26:	dbe5                	beqz	a5,80200a16 <uart_putc+0x10>
    80200a28:	fef44783          	lbu	a5,-17(s0)
    80200a2c:	85be                	mv	a1,a5
    80200a2e:	4501                	li	a0,0
    80200a30:	c15ff0ef          	jal	80200644 <uart_write_reg>
    80200a34:	fef44783          	lbu	a5,-17(s0)
    80200a38:	2781                	sext.w	a5,a5
    80200a3a:	853e                	mv	a0,a5
    80200a3c:	60e2                	ld	ra,24(sp)
    80200a3e:	6442                	ld	s0,16(sp)
    80200a40:	6105                	addi	sp,sp,32
    80200a42:	8082                	ret

0000000080200a44 <uart_puts>:
    80200a44:	1101                	addi	sp,sp,-32
    80200a46:	ec06                	sd	ra,24(sp)
    80200a48:	e822                	sd	s0,16(sp)
    80200a4a:	1000                	addi	s0,sp,32
    80200a4c:	fea43423          	sd	a0,-24(s0)
    80200a50:	a821                	j	80200a68 <uart_puts+0x24>
    80200a52:	fe843783          	ld	a5,-24(s0)
    80200a56:	00178713          	addi	a4,a5,1
    80200a5a:	fee43423          	sd	a4,-24(s0)
    80200a5e:	0007c783          	lbu	a5,0(a5)
    80200a62:	853e                	mv	a0,a5
    80200a64:	fa3ff0ef          	jal	80200a06 <uart_putc>
    80200a68:	fe843783          	ld	a5,-24(s0)
    80200a6c:	0007c783          	lbu	a5,0(a5)
    80200a70:	f3ed                	bnez	a5,80200a52 <uart_puts+0xe>
    80200a72:	0001                	nop
    80200a74:	0001                	nop
    80200a76:	60e2                	ld	ra,24(sp)
    80200a78:	6442                	ld	s0,16(sp)
    80200a7a:	6105                	addi	sp,sp,32
    80200a7c:	8082                	ret

0000000080200a7e <uart_getc>:
    80200a7e:	1101                	addi	sp,sp,-32
    80200a80:	ec06                	sd	ra,24(sp)
    80200a82:	e822                	sd	s0,16(sp)
    80200a84:	1000                	addi	s0,sp,32
    80200a86:	0000e797          	auipc	a5,0xe
    80200a8a:	71a78793          	addi	a5,a5,1818 # 8020f1a0 <uart_rx_use_irq>
    80200a8e:	439c                	lw	a5,0(a5)
    80200a90:	c395                	beqz	a5,80200ab4 <uart_getc+0x36>
    80200a92:	c6fff0ef          	jal	80200700 <uart_rx_get>
    80200a96:	87aa                	mv	a5,a0
    80200a98:	fef42623          	sw	a5,-20(s0)
    80200a9c:	fec42783          	lw	a5,-20(s0)
    80200aa0:	2781                	sext.w	a5,a5
    80200aa2:	0607c263          	bltz	a5,80200b06 <uart_getc+0x88>
    80200aa6:	fec42783          	lw	a5,-20(s0)
    80200aaa:	2781                	sext.w	a5,a5
    80200aac:	cfb9                	beqz	a5,80200b0a <uart_getc+0x8c>
    80200aae:	fec42783          	lw	a5,-20(s0)
    80200ab2:	a085                	j	80200b12 <uart_getc+0x94>
    80200ab4:	c4dff0ef          	jal	80200700 <uart_rx_get>
    80200ab8:	87aa                	mv	a5,a0
    80200aba:	fef42623          	sw	a5,-20(s0)
    80200abe:	fec42783          	lw	a5,-20(s0)
    80200ac2:	2781                	sext.w	a5,a5
    80200ac4:	0007c963          	bltz	a5,80200ad6 <uart_getc+0x58>
    80200ac8:	fec42783          	lw	a5,-20(s0)
    80200acc:	2781                	sext.w	a5,a5
    80200ace:	c3a1                	beqz	a5,80200b0e <uart_getc+0x90>
    80200ad0:	fec42783          	lw	a5,-20(s0)
    80200ad4:	a83d                	j	80200b12 <uart_getc+0x94>
    80200ad6:	0001                	nop
    80200ad8:	4515                	li	a0,5
    80200ada:	b41ff0ef          	jal	8020061a <uart_read_reg>
    80200ade:	87aa                	mv	a5,a0
    80200ae0:	2781                	sext.w	a5,a5
    80200ae2:	8b85                	andi	a5,a5,1
    80200ae4:	2781                	sext.w	a5,a5
    80200ae6:	dbed                	beqz	a5,80200ad8 <uart_getc+0x5a>
    80200ae8:	4501                	li	a0,0
    80200aea:	b31ff0ef          	jal	8020061a <uart_read_reg>
    80200aee:	87aa                	mv	a5,a0
    80200af0:	fef42623          	sw	a5,-20(s0)
    80200af4:	fec42783          	lw	a5,-20(s0)
    80200af8:	2781                	sext.w	a5,a5
    80200afa:	d7d1                	beqz	a5,80200a86 <uart_getc+0x8>
    80200afc:	5a7000ef          	jal	802018a2 <stats_inc_uart_rx>
    80200b00:	fec42783          	lw	a5,-20(s0)
    80200b04:	a039                	j	80200b12 <uart_getc+0x94>
    80200b06:	0001                	nop
    80200b08:	bfbd                	j	80200a86 <uart_getc+0x8>
    80200b0a:	0001                	nop
    80200b0c:	bfad                	j	80200a86 <uart_getc+0x8>
    80200b0e:	0001                	nop
    80200b10:	bf9d                	j	80200a86 <uart_getc+0x8>
    80200b12:	853e                	mv	a0,a5
    80200b14:	60e2                	ld	ra,24(sp)
    80200b16:	6442                	ld	s0,16(sp)
    80200b18:	6105                	addi	sp,sp,32
    80200b1a:	8082                	ret

0000000080200b1c <uart_read_buf>:
    80200b1c:	7179                	addi	sp,sp,-48
    80200b1e:	f406                	sd	ra,40(sp)
    80200b20:	f022                	sd	s0,32(sp)
    80200b22:	1800                	addi	s0,sp,48
    80200b24:	fca43c23          	sd	a0,-40(s0)
    80200b28:	87ae                	mv	a5,a1
    80200b2a:	fcf42a23          	sw	a5,-44(s0)
    80200b2e:	fe042623          	sw	zero,-20(s0)
    80200b32:	fd843783          	ld	a5,-40(s0)
    80200b36:	c791                	beqz	a5,80200b42 <uart_read_buf+0x26>
    80200b38:	fd442783          	lw	a5,-44(s0)
    80200b3c:	2781                	sext.w	a5,a5
    80200b3e:	02f04e63          	bgtz	a5,80200b7a <uart_read_buf+0x5e>
    80200b42:	4781                	li	a5,0
    80200b44:	a881                	j	80200b94 <uart_read_buf+0x78>
    80200b46:	bbbff0ef          	jal	80200700 <uart_rx_get>
    80200b4a:	87aa                	mv	a5,a0
    80200b4c:	fef42423          	sw	a5,-24(s0)
    80200b50:	fe842783          	lw	a5,-24(s0)
    80200b54:	2781                	sext.w	a5,a5
    80200b56:	0207cc63          	bltz	a5,80200b8e <uart_read_buf+0x72>
    80200b5a:	fec42783          	lw	a5,-20(s0)
    80200b5e:	0017871b          	addiw	a4,a5,1
    80200b62:	fee42623          	sw	a4,-20(s0)
    80200b66:	873e                	mv	a4,a5
    80200b68:	fd843783          	ld	a5,-40(s0)
    80200b6c:	97ba                	add	a5,a5,a4
    80200b6e:	fe842703          	lw	a4,-24(s0)
    80200b72:	0ff77713          	zext.b	a4,a4
    80200b76:	00e78023          	sb	a4,0(a5)
    80200b7a:	fec42783          	lw	a5,-20(s0)
    80200b7e:	873e                	mv	a4,a5
    80200b80:	fd442783          	lw	a5,-44(s0)
    80200b84:	2701                	sext.w	a4,a4
    80200b86:	2781                	sext.w	a5,a5
    80200b88:	faf74fe3          	blt	a4,a5,80200b46 <uart_read_buf+0x2a>
    80200b8c:	a011                	j	80200b90 <uart_read_buf+0x74>
    80200b8e:	0001                	nop
    80200b90:	fec42783          	lw	a5,-20(s0)
    80200b94:	853e                	mv	a0,a5
    80200b96:	70a2                	ld	ra,40(sp)
    80200b98:	7402                	ld	s0,32(sp)
    80200b9a:	6145                	addi	sp,sp,48
    80200b9c:	8082                	ret

0000000080200b9e <uart_read_line>:
    80200b9e:	7179                	addi	sp,sp,-48
    80200ba0:	f406                	sd	ra,40(sp)
    80200ba2:	f022                	sd	s0,32(sp)
    80200ba4:	1800                	addi	s0,sp,48
    80200ba6:	fca43c23          	sd	a0,-40(s0)
    80200baa:	87ae                	mv	a5,a1
    80200bac:	fcf42a23          	sw	a5,-44(s0)
    80200bb0:	fe042623          	sw	zero,-20(s0)
    80200bb4:	fd442783          	lw	a5,-44(s0)
    80200bb8:	0007871b          	sext.w	a4,a5
    80200bbc:	4785                	li	a5,1
    80200bbe:	12e7c363          	blt	a5,a4,80200ce4 <uart_read_line+0x146>
    80200bc2:	4781                	li	a5,0
    80200bc4:	aaa9                	j	80200d1e <uart_read_line+0x180>
    80200bc6:	eb9ff0ef          	jal	80200a7e <uart_getc>
    80200bca:	87aa                	mv	a5,a0
    80200bcc:	fef42423          	sw	a5,-24(s0)
    80200bd0:	fe842783          	lw	a5,-24(s0)
    80200bd4:	0007871b          	sext.w	a4,a5
    80200bd8:	47b5                	li	a5,13
    80200bda:	00f70963          	beq	a4,a5,80200bec <uart_read_line+0x4e>
    80200bde:	fe842783          	lw	a5,-24(s0)
    80200be2:	0007871b          	sext.w	a4,a5
    80200be6:	47a9                	li	a5,10
    80200be8:	04f71d63          	bne	a4,a5,80200c42 <uart_read_line+0xa4>
    80200bec:	fe842783          	lw	a5,-24(s0)
    80200bf0:	0007871b          	sext.w	a4,a5
    80200bf4:	47b5                	li	a5,13
    80200bf6:	10f71163          	bne	a4,a5,80200cf8 <uart_read_line+0x15a>
    80200bfa:	a81d                	j	80200c30 <uart_read_line+0x92>
    80200bfc:	4501                	li	a0,0
    80200bfe:	a1dff0ef          	jal	8020061a <uart_read_reg>
    80200c02:	87aa                	mv	a5,a0
    80200c04:	fef42223          	sw	a5,-28(s0)
    80200c08:	fe442783          	lw	a5,-28(s0)
    80200c0c:	0007871b          	sext.w	a4,a5
    80200c10:	47a9                	li	a5,10
    80200c12:	0ef70363          	beq	a4,a5,80200cf8 <uart_read_line+0x15a>
    80200c16:	fe442783          	lw	a5,-28(s0)
    80200c1a:	2781                	sext.w	a5,a5
    80200c1c:	cff1                	beqz	a5,80200cf8 <uart_read_line+0x15a>
    80200c1e:	fe442783          	lw	a5,-28(s0)
    80200c22:	0ff7f793          	zext.b	a5,a5
    80200c26:	853e                	mv	a0,a5
    80200c28:	b63ff0ef          	jal	8020078a <uart_rx_unget>
    80200c2c:	0001                	nop
    80200c2e:	a0e9                	j	80200cf8 <uart_read_line+0x15a>
    80200c30:	4515                	li	a0,5
    80200c32:	9e9ff0ef          	jal	8020061a <uart_read_reg>
    80200c36:	87aa                	mv	a5,a0
    80200c38:	2781                	sext.w	a5,a5
    80200c3a:	8b85                	andi	a5,a5,1
    80200c3c:	2781                	sext.w	a5,a5
    80200c3e:	ffdd                	bnez	a5,80200bfc <uart_read_line+0x5e>
    80200c40:	a865                	j	80200cf8 <uart_read_line+0x15a>
    80200c42:	fe842783          	lw	a5,-24(s0)
    80200c46:	0007871b          	sext.w	a4,a5
    80200c4a:	478d                	li	a5,3
    80200c4c:	08f70963          	beq	a4,a5,80200cde <uart_read_line+0x140>
    80200c50:	fe842783          	lw	a5,-24(s0)
    80200c54:	0007871b          	sext.w	a4,a5
    80200c58:	47a1                	li	a5,8
    80200c5a:	00f70a63          	beq	a4,a5,80200c6e <uart_read_line+0xd0>
    80200c5e:	fe842783          	lw	a5,-24(s0)
    80200c62:	0007871b          	sext.w	a4,a5
    80200c66:	07f00793          	li	a5,127
    80200c6a:	02f71363          	bne	a4,a5,80200c90 <uart_read_line+0xf2>
    80200c6e:	fec42783          	lw	a5,-20(s0)
    80200c72:	2781                	sext.w	a5,a5
    80200c74:	06f05763          	blez	a5,80200ce2 <uart_read_line+0x144>
    80200c78:	fec42783          	lw	a5,-20(s0)
    80200c7c:	37fd                	addiw	a5,a5,-1
    80200c7e:	fef42623          	sw	a5,-20(s0)
    80200c82:	00006517          	auipc	a0,0x6
    80200c86:	44650513          	addi	a0,a0,1094 # 802070c8 <user_code_end+0x258>
    80200c8a:	dbbff0ef          	jal	80200a44 <uart_puts>
    80200c8e:	a891                	j	80200ce2 <uart_read_line+0x144>
    80200c90:	fe842783          	lw	a5,-24(s0)
    80200c94:	0007871b          	sext.w	a4,a5
    80200c98:	47fd                	li	a5,31
    80200c9a:	04e7d563          	bge	a5,a4,80200ce4 <uart_read_line+0x146>
    80200c9e:	fe842783          	lw	a5,-24(s0)
    80200ca2:	0007871b          	sext.w	a4,a5
    80200ca6:	07e00793          	li	a5,126
    80200caa:	02e7cd63          	blt	a5,a4,80200ce4 <uart_read_line+0x146>
    80200cae:	fec42783          	lw	a5,-20(s0)
    80200cb2:	0017871b          	addiw	a4,a5,1
    80200cb6:	fee42623          	sw	a4,-20(s0)
    80200cba:	873e                	mv	a4,a5
    80200cbc:	fd843783          	ld	a5,-40(s0)
    80200cc0:	97ba                	add	a5,a5,a4
    80200cc2:	fe842703          	lw	a4,-24(s0)
    80200cc6:	0ff77713          	zext.b	a4,a4
    80200cca:	00e78023          	sb	a4,0(a5)
    80200cce:	fe842783          	lw	a5,-24(s0)
    80200cd2:	0ff7f793          	zext.b	a5,a5
    80200cd6:	853e                	mv	a0,a5
    80200cd8:	d2fff0ef          	jal	80200a06 <uart_putc>
    80200cdc:	a021                	j	80200ce4 <uart_read_line+0x146>
    80200cde:	0001                	nop
    80200ce0:	a011                	j	80200ce4 <uart_read_line+0x146>
    80200ce2:	0001                	nop
    80200ce4:	fd442783          	lw	a5,-44(s0)
    80200ce8:	37fd                	addiw	a5,a5,-1
    80200cea:	2781                	sext.w	a5,a5
    80200cec:	fec42703          	lw	a4,-20(s0)
    80200cf0:	2701                	sext.w	a4,a4
    80200cf2:	ecf74ae3          	blt	a4,a5,80200bc6 <uart_read_line+0x28>
    80200cf6:	a011                	j	80200cfa <uart_read_line+0x15c>
    80200cf8:	0001                	nop
    80200cfa:	fec42783          	lw	a5,-20(s0)
    80200cfe:	fd843703          	ld	a4,-40(s0)
    80200d02:	97ba                	add	a5,a5,a4
    80200d04:	00078023          	sb	zero,0(a5)
    80200d08:	4529                	li	a0,10
    80200d0a:	cfdff0ef          	jal	80200a06 <uart_putc>
    80200d0e:	00006517          	auipc	a0,0x6
    80200d12:	3c250513          	addi	a0,a0,962 # 802070d0 <user_code_end+0x260>
    80200d16:	afbff0ef          	jal	80200810 <uart_drain_echo_prefix>
    80200d1a:	fec42783          	lw	a5,-20(s0)
    80200d1e:	853e                	mv	a0,a5
    80200d20:	70a2                	ld	ra,40(sp)
    80200d22:	7402                	ld	s0,32(sp)
    80200d24:	6145                	addi	sp,sp,48
    80200d26:	8082                	ret

0000000080200d28 <uart_prompt_and_read_line>:
    80200d28:	7179                	addi	sp,sp,-48
    80200d2a:	f406                	sd	ra,40(sp)
    80200d2c:	f022                	sd	s0,32(sp)
    80200d2e:	1800                	addi	s0,sp,48
    80200d30:	fea43423          	sd	a0,-24(s0)
    80200d34:	feb43023          	sd	a1,-32(s0)
    80200d38:	87b2                	mv	a5,a2
    80200d3a:	fcf42e23          	sw	a5,-36(s0)
    80200d3e:	fe843783          	ld	a5,-24(s0)
    80200d42:	c789                	beqz	a5,80200d4c <uart_prompt_and_read_line+0x24>
    80200d44:	fe843503          	ld	a0,-24(s0)
    80200d48:	cfdff0ef          	jal	80200a44 <uart_puts>
    80200d4c:	fdc42783          	lw	a5,-36(s0)
    80200d50:	85be                	mv	a1,a5
    80200d52:	fe043503          	ld	a0,-32(s0)
    80200d56:	e49ff0ef          	jal	80200b9e <uart_read_line>
    80200d5a:	87aa                	mv	a5,a0
    80200d5c:	853e                	mv	a0,a5
    80200d5e:	70a2                	ld	ra,40(sp)
    80200d60:	7402                	ld	s0,32(sp)
    80200d62:	6145                	addi	sp,sp,48
    80200d64:	8082                	ret

0000000080200d66 <uart_isr>:
    80200d66:	1101                	addi	sp,sp,-32
    80200d68:	ec06                	sd	ra,24(sp)
    80200d6a:	e822                	sd	s0,16(sp)
    80200d6c:	1000                	addi	s0,sp,32
    80200d6e:	a0ad                	j	80200dd8 <uart_isr+0x72>
    80200d70:	4501                	li	a0,0
    80200d72:	8a9ff0ef          	jal	8020061a <uart_read_reg>
    80200d76:	87aa                	mv	a5,a0
    80200d78:	fef42623          	sw	a5,-20(s0)
    80200d7c:	fec42783          	lw	a5,-20(s0)
    80200d80:	2781                	sext.w	a5,a5
    80200d82:	cbb1                	beqz	a5,80200dd6 <uart_isr+0x70>
    80200d84:	fec42783          	lw	a5,-20(s0)
    80200d88:	0007871b          	sext.w	a4,a5
    80200d8c:	47fd                	li	a5,31
    80200d8e:	02e7d263          	bge	a5,a4,80200db2 <uart_isr+0x4c>
    80200d92:	fec42783          	lw	a5,-20(s0)
    80200d96:	0007871b          	sext.w	a4,a5
    80200d9a:	07e00793          	li	a5,126
    80200d9e:	00e7ca63          	blt	a5,a4,80200db2 <uart_isr+0x4c>
    80200da2:	fec42783          	lw	a5,-20(s0)
    80200da6:	0ff7f793          	zext.b	a5,a5
    80200daa:	853e                	mv	a0,a5
    80200dac:	8cdff0ef          	jal	80200678 <uart_rx_put>
    80200db0:	a025                	j	80200dd8 <uart_isr+0x72>
    80200db2:	fec42783          	lw	a5,-20(s0)
    80200db6:	0007871b          	sext.w	a4,a5
    80200dba:	47b5                	li	a5,13
    80200dbc:	00f70963          	beq	a4,a5,80200dce <uart_isr+0x68>
    80200dc0:	fec42783          	lw	a5,-20(s0)
    80200dc4:	0007871b          	sext.w	a4,a5
    80200dc8:	47a9                	li	a5,10
    80200dca:	00f71763          	bne	a4,a5,80200dd8 <uart_isr+0x72>
    80200dce:	4529                	li	a0,10
    80200dd0:	8a9ff0ef          	jal	80200678 <uart_rx_put>
    80200dd4:	a011                	j	80200dd8 <uart_isr+0x72>
    80200dd6:	0001                	nop
    80200dd8:	4515                	li	a0,5
    80200dda:	841ff0ef          	jal	8020061a <uart_read_reg>
    80200dde:	87aa                	mv	a5,a0
    80200de0:	2781                	sext.w	a5,a5
    80200de2:	8b85                	andi	a5,a5,1
    80200de4:	2781                	sext.w	a5,a5
    80200de6:	f7c9                	bnez	a5,80200d70 <uart_isr+0xa>
    80200de8:	0001                	nop
    80200dea:	0001                	nop
    80200dec:	60e2                	ld	ra,24(sp)
    80200dee:	6442                	ld	s0,16(sp)
    80200df0:	6105                	addi	sp,sp,32
    80200df2:	8082                	ret

0000000080200df4 <r_sstatus>:
    80200df4:	1101                	addi	sp,sp,-32
    80200df6:	ec06                	sd	ra,24(sp)
    80200df8:	e822                	sd	s0,16(sp)
    80200dfa:	1000                	addi	s0,sp,32
    80200dfc:	100027f3          	csrr	a5,sstatus
    80200e00:	fef43423          	sd	a5,-24(s0)
    80200e04:	fe843783          	ld	a5,-24(s0)
    80200e08:	853e                	mv	a0,a5
    80200e0a:	60e2                	ld	ra,24(sp)
    80200e0c:	6442                	ld	s0,16(sp)
    80200e0e:	6105                	addi	sp,sp,32
    80200e10:	8082                	ret

0000000080200e12 <w_sstatus>:
    80200e12:	1101                	addi	sp,sp,-32
    80200e14:	ec06                	sd	ra,24(sp)
    80200e16:	e822                	sd	s0,16(sp)
    80200e18:	1000                	addi	s0,sp,32
    80200e1a:	fea43423          	sd	a0,-24(s0)
    80200e1e:	fe843783          	ld	a5,-24(s0)
    80200e22:	10079073          	csrw	sstatus,a5
    80200e26:	0001                	nop
    80200e28:	60e2                	ld	ra,24(sp)
    80200e2a:	6442                	ld	s0,16(sp)
    80200e2c:	6105                	addi	sp,sp,32
    80200e2e:	8082                	ret

0000000080200e30 <w_sie>:
    80200e30:	1101                	addi	sp,sp,-32
    80200e32:	ec06                	sd	ra,24(sp)
    80200e34:	e822                	sd	s0,16(sp)
    80200e36:	1000                	addi	s0,sp,32
    80200e38:	fea43423          	sd	a0,-24(s0)
    80200e3c:	fe843783          	ld	a5,-24(s0)
    80200e40:	10479073          	csrw	sie,a5
    80200e44:	0001                	nop
    80200e46:	60e2                	ld	ra,24(sp)
    80200e48:	6442                	ld	s0,16(sp)
    80200e4a:	6105                	addi	sp,sp,32
    80200e4c:	8082                	ret

0000000080200e4e <cpu_irq_disable>:
    80200e4e:	1141                	addi	sp,sp,-16
    80200e50:	e406                	sd	ra,8(sp)
    80200e52:	e022                	sd	s0,0(sp)
    80200e54:	0800                	addi	s0,sp,16
    80200e56:	f9fff0ef          	jal	80200df4 <r_sstatus>
    80200e5a:	87aa                	mv	a5,a0
    80200e5c:	9bf5                	andi	a5,a5,-3
    80200e5e:	853e                	mv	a0,a5
    80200e60:	fb3ff0ef          	jal	80200e12 <w_sstatus>
    80200e64:	0001                	nop
    80200e66:	60a2                	ld	ra,8(sp)
    80200e68:	6402                	ld	s0,0(sp)
    80200e6a:	0141                	addi	sp,sp,16
    80200e6c:	8082                	ret

0000000080200e6e <sbi_shutdown>:
    80200e6e:	1141                	addi	sp,sp,-16
    80200e70:	e406                	sd	ra,8(sp)
    80200e72:	e022                	sd	s0,0(sp)
    80200e74:	0800                	addi	s0,sp,16
    80200e76:	48a1                	li	a7,8
    80200e78:	00000073          	ecall
    80200e7c:	0001                	nop
    80200e7e:	60a2                	ld	ra,8(sp)
    80200e80:	6402                	ld	s0,0(sp)
    80200e82:	0141                	addi	sp,sp,16
    80200e84:	8082                	ret

0000000080200e86 <qemu_test_poweroff>:
    80200e86:	1141                	addi	sp,sp,-16
    80200e88:	e406                	sd	ra,8(sp)
    80200e8a:	e022                	sd	s0,0(sp)
    80200e8c:	0800                	addi	s0,sp,16
    80200e8e:	001007b7          	lui	a5,0x100
    80200e92:	6715                	lui	a4,0x5
    80200e94:	55570713          	addi	a4,a4,1365 # 5555 <STACK_SIZE+0x4555>
    80200e98:	c398                	sw	a4,0(a5)
    80200e9a:	0001                	nop
    80200e9c:	60a2                	ld	ra,8(sp)
    80200e9e:	6402                	ld	s0,0(sp)
    80200ea0:	0141                	addi	sp,sp,16
    80200ea2:	8082                	ret

0000000080200ea4 <shutdown_quiesce>:
    80200ea4:	1141                	addi	sp,sp,-16
    80200ea6:	e406                	sd	ra,8(sp)
    80200ea8:	e022                	sd	s0,0(sp)
    80200eaa:	0800                	addi	s0,sp,16
    80200eac:	fa3ff0ef          	jal	80200e4e <cpu_irq_disable>
    80200eb0:	4501                	li	a0,0
    80200eb2:	f7fff0ef          	jal	80200e30 <w_sie>
    80200eb6:	0001                	nop
    80200eb8:	60a2                	ld	ra,8(sp)
    80200eba:	6402                	ld	s0,0(sp)
    80200ebc:	0141                	addi	sp,sp,16
    80200ebe:	8082                	ret

0000000080200ec0 <machine_poweroff>:
    80200ec0:	1141                	addi	sp,sp,-16
    80200ec2:	e406                	sd	ra,8(sp)
    80200ec4:	e022                	sd	s0,0(sp)
    80200ec6:	0800                	addi	s0,sp,16
    80200ec8:	fddff0ef          	jal	80200ea4 <shutdown_quiesce>
    80200ecc:	00006517          	auipc	a0,0x6
    80200ed0:	20c50513          	addi	a0,a0,524 # 802070d8 <user_code_end+0x268>
    80200ed4:	b71ff0ef          	jal	80200a44 <uart_puts>
    80200ed8:	00006617          	auipc	a2,0x6
    80200edc:	21860613          	addi	a2,a2,536 # 802070f0 <user_code_end+0x280>
    80200ee0:	00006597          	auipc	a1,0x6
    80200ee4:	22858593          	addi	a1,a1,552 # 80207108 <user_code_end+0x298>
    80200ee8:	00006517          	auipc	a0,0x6
    80200eec:	23050513          	addi	a0,a0,560 # 80207118 <user_code_end+0x2a8>
    80200ef0:	78e000ef          	jal	8020167e <osviz_event>
    80200ef4:	f7bff0ef          	jal	80200e6e <sbi_shutdown>
    80200ef8:	00006517          	auipc	a0,0x6
    80200efc:	22850513          	addi	a0,a0,552 # 80207120 <user_code_end+0x2b0>
    80200f00:	b45ff0ef          	jal	80200a44 <uart_puts>
    80200f04:	f83ff0ef          	jal	80200e86 <qemu_test_poweroff>
    80200f08:	00006517          	auipc	a0,0x6
    80200f0c:	25050513          	addi	a0,a0,592 # 80207158 <user_code_end+0x2e8>
    80200f10:	b35ff0ef          	jal	80200a44 <uart_puts>
    80200f14:	10500073          	wfi
    80200f18:	bff5                	j	80200f14 <machine_poweroff+0x54>

0000000080200f1a <_vsnprintf>:
    80200f1a:	7119                	addi	sp,sp,-128
    80200f1c:	fc86                	sd	ra,120(sp)
    80200f1e:	f8a2                	sd	s0,112(sp)
    80200f20:	0100                	addi	s0,sp,128
    80200f22:	f8a43c23          	sd	a0,-104(s0)
    80200f26:	f8b43823          	sd	a1,-112(s0)
    80200f2a:	f8c43423          	sd	a2,-120(s0)
    80200f2e:	f8d43023          	sd	a3,-128(s0)
    80200f32:	fe042623          	sw	zero,-20(s0)
    80200f36:	fe042423          	sw	zero,-24(s0)
    80200f3a:	fe043023          	sd	zero,-32(s0)
    80200f3e:	a939                	j	8020135c <_vsnprintf+0x442>
    80200f40:	fec42783          	lw	a5,-20(s0)
    80200f44:	2781                	sext.w	a5,a5
    80200f46:	3a078e63          	beqz	a5,80201302 <_vsnprintf+0x3e8>
    80200f4a:	f8843783          	ld	a5,-120(s0)
    80200f4e:	0007c783          	lbu	a5,0(a5) # 100000 <STACK_SIZE+0xff000>
    80200f52:	2781                	sext.w	a5,a5
    80200f54:	07800713          	li	a4,120
    80200f58:	0ae78c63          	beq	a5,a4,80201010 <_vsnprintf+0xf6>
    80200f5c:	07800713          	li	a4,120
    80200f60:	3ef74863          	blt	a4,a5,80201350 <_vsnprintf+0x436>
    80200f64:	07300713          	li	a4,115
    80200f68:	2ee78863          	beq	a5,a4,80201258 <_vsnprintf+0x33e>
    80200f6c:	07300713          	li	a4,115
    80200f70:	3ef74063          	blt	a4,a5,80201350 <_vsnprintf+0x436>
    80200f74:	07000713          	li	a4,112
    80200f78:	02e78b63          	beq	a5,a4,80200fae <_vsnprintf+0x94>
    80200f7c:	07000713          	li	a4,112
    80200f80:	3cf74863          	blt	a4,a5,80201350 <_vsnprintf+0x436>
    80200f84:	06c00713          	li	a4,108
    80200f88:	00e78f63          	beq	a5,a4,80200fa6 <_vsnprintf+0x8c>
    80200f8c:	06c00713          	li	a4,108
    80200f90:	3cf74063          	blt	a4,a5,80201350 <_vsnprintf+0x436>
    80200f94:	06300713          	li	a4,99
    80200f98:	32e78263          	beq	a5,a4,802012bc <_vsnprintf+0x3a2>
    80200f9c:	06400713          	li	a4,100
    80200fa0:	14e78863          	beq	a5,a4,802010f0 <_vsnprintf+0x1d6>
    80200fa4:	a675                	j	80201350 <_vsnprintf+0x436>
    80200fa6:	4785                	li	a5,1
    80200fa8:	fef42423          	sw	a5,-24(s0)
    80200fac:	a65d                	j	80201352 <_vsnprintf+0x438>
    80200fae:	4785                	li	a5,1
    80200fb0:	fef42423          	sw	a5,-24(s0)
    80200fb4:	f9843783          	ld	a5,-104(s0)
    80200fb8:	c385                	beqz	a5,80200fd8 <_vsnprintf+0xbe>
    80200fba:	fe043703          	ld	a4,-32(s0)
    80200fbe:	f9043783          	ld	a5,-112(s0)
    80200fc2:	00f77b63          	bgeu	a4,a5,80200fd8 <_vsnprintf+0xbe>
    80200fc6:	f9843703          	ld	a4,-104(s0)
    80200fca:	fe043783          	ld	a5,-32(s0)
    80200fce:	97ba                	add	a5,a5,a4
    80200fd0:	03000713          	li	a4,48
    80200fd4:	00e78023          	sb	a4,0(a5)
    80200fd8:	fe043783          	ld	a5,-32(s0)
    80200fdc:	0785                	addi	a5,a5,1
    80200fde:	fef43023          	sd	a5,-32(s0)
    80200fe2:	f9843783          	ld	a5,-104(s0)
    80200fe6:	c385                	beqz	a5,80201006 <_vsnprintf+0xec>
    80200fe8:	fe043703          	ld	a4,-32(s0)
    80200fec:	f9043783          	ld	a5,-112(s0)
    80200ff0:	00f77b63          	bgeu	a4,a5,80201006 <_vsnprintf+0xec>
    80200ff4:	f9843703          	ld	a4,-104(s0)
    80200ff8:	fe043783          	ld	a5,-32(s0)
    80200ffc:	97ba                	add	a5,a5,a4
    80200ffe:	07800713          	li	a4,120
    80201002:	00e78023          	sb	a4,0(a5)
    80201006:	fe043783          	ld	a5,-32(s0)
    8020100a:	0785                	addi	a5,a5,1
    8020100c:	fef43023          	sd	a5,-32(s0)
    80201010:	fe842783          	lw	a5,-24(s0)
    80201014:	2781                	sext.w	a5,a5
    80201016:	cb99                	beqz	a5,8020102c <_vsnprintf+0x112>
    80201018:	f8043783          	ld	a5,-128(s0)
    8020101c:	00878713          	addi	a4,a5,8
    80201020:	f8e43023          	sd	a4,-128(s0)
    80201024:	639c                	ld	a5,0(a5)
    80201026:	fcf43c23          	sd	a5,-40(s0)
    8020102a:	a811                	j	8020103e <_vsnprintf+0x124>
    8020102c:	f8043783          	ld	a5,-128(s0)
    80201030:	00878713          	addi	a4,a5,8
    80201034:	f8e43023          	sd	a4,-128(s0)
    80201038:	439c                	lw	a5,0(a5)
    8020103a:	fcf43c23          	sd	a5,-40(s0)
    8020103e:	fe842783          	lw	a5,-24(s0)
    80201042:	2781                	sext.w	a5,a5
    80201044:	c789                	beqz	a5,8020104e <_vsnprintf+0x134>
    80201046:	47bd                	li	a5,15
    80201048:	fcf42a23          	sw	a5,-44(s0)
    8020104c:	a021                	j	80201054 <_vsnprintf+0x13a>
    8020104e:	479d                	li	a5,7
    80201050:	fcf42a23          	sw	a5,-44(s0)
    80201054:	fd442783          	lw	a5,-44(s0)
    80201058:	fcf42823          	sw	a5,-48(s0)
    8020105c:	a041                	j	802010dc <_vsnprintf+0x1c2>
    8020105e:	fd042783          	lw	a5,-48(s0)
    80201062:	0027979b          	slliw	a5,a5,0x2
    80201066:	2781                	sext.w	a5,a5
    80201068:	fd843703          	ld	a4,-40(s0)
    8020106c:	40f757b3          	sra	a5,a4,a5
    80201070:	2781                	sext.w	a5,a5
    80201072:	8bbd                	andi	a5,a5,15
    80201074:	faf42223          	sw	a5,-92(s0)
    80201078:	f9843783          	ld	a5,-104(s0)
    8020107c:	c7b1                	beqz	a5,802010c8 <_vsnprintf+0x1ae>
    8020107e:	fe043703          	ld	a4,-32(s0)
    80201082:	f9043783          	ld	a5,-112(s0)
    80201086:	04f77163          	bgeu	a4,a5,802010c8 <_vsnprintf+0x1ae>
    8020108a:	fa442783          	lw	a5,-92(s0)
    8020108e:	0007871b          	sext.w	a4,a5
    80201092:	47a5                	li	a5,9
    80201094:	00e7cb63          	blt	a5,a4,802010aa <_vsnprintf+0x190>
    80201098:	fa442783          	lw	a5,-92(s0)
    8020109c:	0ff7f793          	zext.b	a5,a5
    802010a0:	0307879b          	addiw	a5,a5,48
    802010a4:	0ff7f793          	zext.b	a5,a5
    802010a8:	a809                	j	802010ba <_vsnprintf+0x1a0>
    802010aa:	fa442783          	lw	a5,-92(s0)
    802010ae:	0ff7f793          	zext.b	a5,a5
    802010b2:	0577879b          	addiw	a5,a5,87
    802010b6:	0ff7f793          	zext.b	a5,a5
    802010ba:	f9843683          	ld	a3,-104(s0)
    802010be:	fe043703          	ld	a4,-32(s0)
    802010c2:	9736                	add	a4,a4,a3
    802010c4:	00f70023          	sb	a5,0(a4)
    802010c8:	fe043783          	ld	a5,-32(s0)
    802010cc:	0785                	addi	a5,a5,1
    802010ce:	fef43023          	sd	a5,-32(s0)
    802010d2:	fd042783          	lw	a5,-48(s0)
    802010d6:	37fd                	addiw	a5,a5,-1
    802010d8:	fcf42823          	sw	a5,-48(s0)
    802010dc:	fd042783          	lw	a5,-48(s0)
    802010e0:	2781                	sext.w	a5,a5
    802010e2:	f607dee3          	bgez	a5,8020105e <_vsnprintf+0x144>
    802010e6:	fe042423          	sw	zero,-24(s0)
    802010ea:	fe042623          	sw	zero,-20(s0)
    802010ee:	a495                	j	80201352 <_vsnprintf+0x438>
    802010f0:	fe842783          	lw	a5,-24(s0)
    802010f4:	2781                	sext.w	a5,a5
    802010f6:	cb99                	beqz	a5,8020110c <_vsnprintf+0x1f2>
    802010f8:	f8043783          	ld	a5,-128(s0)
    802010fc:	00878713          	addi	a4,a5,8
    80201100:	f8e43023          	sd	a4,-128(s0)
    80201104:	639c                	ld	a5,0(a5)
    80201106:	fcf43423          	sd	a5,-56(s0)
    8020110a:	a811                	j	8020111e <_vsnprintf+0x204>
    8020110c:	f8043783          	ld	a5,-128(s0)
    80201110:	00878713          	addi	a4,a5,8
    80201114:	f8e43023          	sd	a4,-128(s0)
    80201118:	439c                	lw	a5,0(a5)
    8020111a:	fcf43423          	sd	a5,-56(s0)
    8020111e:	fc843783          	ld	a5,-56(s0)
    80201122:	0207df63          	bgez	a5,80201160 <_vsnprintf+0x246>
    80201126:	fc843783          	ld	a5,-56(s0)
    8020112a:	40f007b3          	neg	a5,a5
    8020112e:	fcf43423          	sd	a5,-56(s0)
    80201132:	f9843783          	ld	a5,-104(s0)
    80201136:	c385                	beqz	a5,80201156 <_vsnprintf+0x23c>
    80201138:	fe043703          	ld	a4,-32(s0)
    8020113c:	f9043783          	ld	a5,-112(s0)
    80201140:	00f77b63          	bgeu	a4,a5,80201156 <_vsnprintf+0x23c>
    80201144:	f9843703          	ld	a4,-104(s0)
    80201148:	fe043783          	ld	a5,-32(s0)
    8020114c:	97ba                	add	a5,a5,a4
    8020114e:	02d00713          	li	a4,45
    80201152:	00e78023          	sb	a4,0(a5)
    80201156:	fe043783          	ld	a5,-32(s0)
    8020115a:	0785                	addi	a5,a5,1
    8020115c:	fef43023          	sd	a5,-32(s0)
    80201160:	4785                	li	a5,1
    80201162:	fcf43023          	sd	a5,-64(s0)
    80201166:	fc843783          	ld	a5,-56(s0)
    8020116a:	faf43c23          	sd	a5,-72(s0)
    8020116e:	a031                	j	8020117a <_vsnprintf+0x260>
    80201170:	fc043783          	ld	a5,-64(s0)
    80201174:	0785                	addi	a5,a5,1
    80201176:	fcf43023          	sd	a5,-64(s0)
    8020117a:	fb843783          	ld	a5,-72(s0)
    8020117e:	00006717          	auipc	a4,0x6
    80201182:	03270713          	addi	a4,a4,50 # 802071b0 <user_code_end+0x340>
    80201186:	6318                	ld	a4,0(a4)
    80201188:	02e79733          	mulh	a4,a5,a4
    8020118c:	8709                	srai	a4,a4,0x2
    8020118e:	97fd                	srai	a5,a5,0x3f
    80201190:	40f707b3          	sub	a5,a4,a5
    80201194:	faf43c23          	sd	a5,-72(s0)
    80201198:	fb843783          	ld	a5,-72(s0)
    8020119c:	fbf1                	bnez	a5,80201170 <_vsnprintf+0x256>
    8020119e:	fc043783          	ld	a5,-64(s0)
    802011a2:	2781                	sext.w	a5,a5
    802011a4:	37fd                	addiw	a5,a5,-1
    802011a6:	2781                	sext.w	a5,a5
    802011a8:	faf42a23          	sw	a5,-76(s0)
    802011ac:	a069                	j	80201236 <_vsnprintf+0x31c>
    802011ae:	f9843783          	ld	a5,-104(s0)
    802011b2:	cfb1                	beqz	a5,8020120e <_vsnprintf+0x2f4>
    802011b4:	fb442703          	lw	a4,-76(s0)
    802011b8:	fe043783          	ld	a5,-32(s0)
    802011bc:	97ba                	add	a5,a5,a4
    802011be:	f9043703          	ld	a4,-112(s0)
    802011c2:	04e7f663          	bgeu	a5,a4,8020120e <_vsnprintf+0x2f4>
    802011c6:	fc843703          	ld	a4,-56(s0)
    802011ca:	00006797          	auipc	a5,0x6
    802011ce:	fe678793          	addi	a5,a5,-26 # 802071b0 <user_code_end+0x340>
    802011d2:	639c                	ld	a5,0(a5)
    802011d4:	02f717b3          	mulh	a5,a4,a5
    802011d8:	4027d693          	srai	a3,a5,0x2
    802011dc:	43f75793          	srai	a5,a4,0x3f
    802011e0:	8e9d                	sub	a3,a3,a5
    802011e2:	87b6                	mv	a5,a3
    802011e4:	078a                	slli	a5,a5,0x2
    802011e6:	97b6                	add	a5,a5,a3
    802011e8:	0786                	slli	a5,a5,0x1
    802011ea:	40f706b3          	sub	a3,a4,a5
    802011ee:	0ff6f713          	zext.b	a4,a3
    802011f2:	fb442683          	lw	a3,-76(s0)
    802011f6:	fe043783          	ld	a5,-32(s0)
    802011fa:	97b6                	add	a5,a5,a3
    802011fc:	f9843683          	ld	a3,-104(s0)
    80201200:	97b6                	add	a5,a5,a3
    80201202:	0307071b          	addiw	a4,a4,48
    80201206:	0ff77713          	zext.b	a4,a4
    8020120a:	00e78023          	sb	a4,0(a5)
    8020120e:	fc843783          	ld	a5,-56(s0)
    80201212:	00006717          	auipc	a4,0x6
    80201216:	f9e70713          	addi	a4,a4,-98 # 802071b0 <user_code_end+0x340>
    8020121a:	6318                	ld	a4,0(a4)
    8020121c:	02e79733          	mulh	a4,a5,a4
    80201220:	8709                	srai	a4,a4,0x2
    80201222:	97fd                	srai	a5,a5,0x3f
    80201224:	40f707b3          	sub	a5,a4,a5
    80201228:	fcf43423          	sd	a5,-56(s0)
    8020122c:	fb442783          	lw	a5,-76(s0)
    80201230:	37fd                	addiw	a5,a5,-1
    80201232:	faf42a23          	sw	a5,-76(s0)
    80201236:	fb442783          	lw	a5,-76(s0)
    8020123a:	2781                	sext.w	a5,a5
    8020123c:	f607d9e3          	bgez	a5,802011ae <_vsnprintf+0x294>
    80201240:	fc043783          	ld	a5,-64(s0)
    80201244:	fe043703          	ld	a4,-32(s0)
    80201248:	97ba                	add	a5,a5,a4
    8020124a:	fef43023          	sd	a5,-32(s0)
    8020124e:	fe042423          	sw	zero,-24(s0)
    80201252:	fe042623          	sw	zero,-20(s0)
    80201256:	a8f5                	j	80201352 <_vsnprintf+0x438>
    80201258:	f8043783          	ld	a5,-128(s0)
    8020125c:	00878713          	addi	a4,a5,8
    80201260:	f8e43023          	sd	a4,-128(s0)
    80201264:	639c                	ld	a5,0(a5)
    80201266:	faf43423          	sd	a5,-88(s0)
    8020126a:	a83d                	j	802012a8 <_vsnprintf+0x38e>
    8020126c:	f9843783          	ld	a5,-104(s0)
    80201270:	c395                	beqz	a5,80201294 <_vsnprintf+0x37a>
    80201272:	fe043703          	ld	a4,-32(s0)
    80201276:	f9043783          	ld	a5,-112(s0)
    8020127a:	00f77d63          	bgeu	a4,a5,80201294 <_vsnprintf+0x37a>
    8020127e:	f9843703          	ld	a4,-104(s0)
    80201282:	fe043783          	ld	a5,-32(s0)
    80201286:	97ba                	add	a5,a5,a4
    80201288:	fa843703          	ld	a4,-88(s0)
    8020128c:	00074703          	lbu	a4,0(a4)
    80201290:	00e78023          	sb	a4,0(a5)
    80201294:	fe043783          	ld	a5,-32(s0)
    80201298:	0785                	addi	a5,a5,1
    8020129a:	fef43023          	sd	a5,-32(s0)
    8020129e:	fa843783          	ld	a5,-88(s0)
    802012a2:	0785                	addi	a5,a5,1
    802012a4:	faf43423          	sd	a5,-88(s0)
    802012a8:	fa843783          	ld	a5,-88(s0)
    802012ac:	0007c783          	lbu	a5,0(a5)
    802012b0:	ffd5                	bnez	a5,8020126c <_vsnprintf+0x352>
    802012b2:	fe042423          	sw	zero,-24(s0)
    802012b6:	fe042623          	sw	zero,-20(s0)
    802012ba:	a861                	j	80201352 <_vsnprintf+0x438>
    802012bc:	f9843783          	ld	a5,-104(s0)
    802012c0:	c79d                	beqz	a5,802012ee <_vsnprintf+0x3d4>
    802012c2:	fe043703          	ld	a4,-32(s0)
    802012c6:	f9043783          	ld	a5,-112(s0)
    802012ca:	02f77263          	bgeu	a4,a5,802012ee <_vsnprintf+0x3d4>
    802012ce:	f8043783          	ld	a5,-128(s0)
    802012d2:	00878713          	addi	a4,a5,8
    802012d6:	f8e43023          	sd	a4,-128(s0)
    802012da:	4394                	lw	a3,0(a5)
    802012dc:	f9843703          	ld	a4,-104(s0)
    802012e0:	fe043783          	ld	a5,-32(s0)
    802012e4:	97ba                	add	a5,a5,a4
    802012e6:	0ff6f713          	zext.b	a4,a3
    802012ea:	00e78023          	sb	a4,0(a5)
    802012ee:	fe043783          	ld	a5,-32(s0)
    802012f2:	0785                	addi	a5,a5,1
    802012f4:	fef43023          	sd	a5,-32(s0)
    802012f8:	fe042423          	sw	zero,-24(s0)
    802012fc:	fe042623          	sw	zero,-20(s0)
    80201300:	a889                	j	80201352 <_vsnprintf+0x438>
    80201302:	f8843783          	ld	a5,-120(s0)
    80201306:	0007c783          	lbu	a5,0(a5)
    8020130a:	873e                	mv	a4,a5
    8020130c:	02500793          	li	a5,37
    80201310:	00f71663          	bne	a4,a5,8020131c <_vsnprintf+0x402>
    80201314:	4785                	li	a5,1
    80201316:	fef42623          	sw	a5,-20(s0)
    8020131a:	a825                	j	80201352 <_vsnprintf+0x438>
    8020131c:	f9843783          	ld	a5,-104(s0)
    80201320:	c395                	beqz	a5,80201344 <_vsnprintf+0x42a>
    80201322:	fe043703          	ld	a4,-32(s0)
    80201326:	f9043783          	ld	a5,-112(s0)
    8020132a:	00f77d63          	bgeu	a4,a5,80201344 <_vsnprintf+0x42a>
    8020132e:	f9843703          	ld	a4,-104(s0)
    80201332:	fe043783          	ld	a5,-32(s0)
    80201336:	97ba                	add	a5,a5,a4
    80201338:	f8843703          	ld	a4,-120(s0)
    8020133c:	00074703          	lbu	a4,0(a4)
    80201340:	00e78023          	sb	a4,0(a5)
    80201344:	fe043783          	ld	a5,-32(s0)
    80201348:	0785                	addi	a5,a5,1
    8020134a:	fef43023          	sd	a5,-32(s0)
    8020134e:	a011                	j	80201352 <_vsnprintf+0x438>
    80201350:	0001                	nop
    80201352:	f8843783          	ld	a5,-120(s0)
    80201356:	0785                	addi	a5,a5,1
    80201358:	f8f43423          	sd	a5,-120(s0)
    8020135c:	f8843783          	ld	a5,-120(s0)
    80201360:	0007c783          	lbu	a5,0(a5)
    80201364:	bc079ee3          	bnez	a5,80200f40 <_vsnprintf+0x26>
    80201368:	f9843783          	ld	a5,-104(s0)
    8020136c:	cf99                	beqz	a5,8020138a <_vsnprintf+0x470>
    8020136e:	fe043703          	ld	a4,-32(s0)
    80201372:	f9043783          	ld	a5,-112(s0)
    80201376:	00f77a63          	bgeu	a4,a5,8020138a <_vsnprintf+0x470>
    8020137a:	f9843703          	ld	a4,-104(s0)
    8020137e:	fe043783          	ld	a5,-32(s0)
    80201382:	97ba                	add	a5,a5,a4
    80201384:	00078023          	sb	zero,0(a5)
    80201388:	a839                	j	802013a6 <_vsnprintf+0x48c>
    8020138a:	f9843783          	ld	a5,-104(s0)
    8020138e:	cf81                	beqz	a5,802013a6 <_vsnprintf+0x48c>
    80201390:	f9043783          	ld	a5,-112(s0)
    80201394:	cb89                	beqz	a5,802013a6 <_vsnprintf+0x48c>
    80201396:	f9043783          	ld	a5,-112(s0)
    8020139a:	17fd                	addi	a5,a5,-1
    8020139c:	f9843703          	ld	a4,-104(s0)
    802013a0:	97ba                	add	a5,a5,a4
    802013a2:	00078023          	sb	zero,0(a5)
    802013a6:	fe043783          	ld	a5,-32(s0)
    802013aa:	2781                	sext.w	a5,a5
    802013ac:	853e                	mv	a0,a5
    802013ae:	70e6                	ld	ra,120(sp)
    802013b0:	7446                	ld	s0,112(sp)
    802013b2:	6109                	addi	sp,sp,128
    802013b4:	8082                	ret

00000000802013b6 <_vprintf>:
    802013b6:	7179                	addi	sp,sp,-48
    802013b8:	f406                	sd	ra,40(sp)
    802013ba:	f022                	sd	s0,32(sp)
    802013bc:	1800                	addi	s0,sp,48
    802013be:	fca43c23          	sd	a0,-40(s0)
    802013c2:	fcb43823          	sd	a1,-48(s0)
    802013c6:	fd043683          	ld	a3,-48(s0)
    802013ca:	fd843603          	ld	a2,-40(s0)
    802013ce:	55fd                	li	a1,-1
    802013d0:	4501                	li	a0,0
    802013d2:	b49ff0ef          	jal	80200f1a <_vsnprintf>
    802013d6:	87aa                	mv	a5,a0
    802013d8:	fef42623          	sw	a5,-20(s0)
    802013dc:	fec42783          	lw	a5,-20(s0)
    802013e0:	2785                	addiw	a5,a5,1
    802013e2:	2781                	sext.w	a5,a5
    802013e4:	873e                	mv	a4,a5
    802013e6:	3e700793          	li	a5,999
    802013ea:	00e7fa63          	bgeu	a5,a4,802013fe <_vprintf+0x48>
    802013ee:	00006517          	auipc	a0,0x6
    802013f2:	d8a50513          	addi	a0,a0,-630 # 80207178 <user_code_end+0x308>
    802013f6:	e4eff0ef          	jal	80200a44 <uart_puts>
    802013fa:	0001                	nop
    802013fc:	bffd                	j	802013fa <_vprintf+0x44>
    802013fe:	fec42783          	lw	a5,-20(s0)
    80201402:	2785                	addiw	a5,a5,1
    80201404:	2781                	sext.w	a5,a5
    80201406:	fd043683          	ld	a3,-48(s0)
    8020140a:	fd843603          	ld	a2,-40(s0)
    8020140e:	85be                	mv	a1,a5
    80201410:	0000e517          	auipc	a0,0xe
    80201414:	d9850513          	addi	a0,a0,-616 # 8020f1a8 <out_buf>
    80201418:	b03ff0ef          	jal	80200f1a <_vsnprintf>
    8020141c:	0000e517          	auipc	a0,0xe
    80201420:	d8c50513          	addi	a0,a0,-628 # 8020f1a8 <out_buf>
    80201424:	e20ff0ef          	jal	80200a44 <uart_puts>
    80201428:	fec42783          	lw	a5,-20(s0)
    8020142c:	853e                	mv	a0,a5
    8020142e:	70a2                	ld	ra,40(sp)
    80201430:	7402                	ld	s0,32(sp)
    80201432:	6145                	addi	sp,sp,48
    80201434:	8082                	ret

0000000080201436 <printf>:
    80201436:	7159                	addi	sp,sp,-112
    80201438:	f406                	sd	ra,40(sp)
    8020143a:	f022                	sd	s0,32(sp)
    8020143c:	1800                	addi	s0,sp,48
    8020143e:	fca43c23          	sd	a0,-40(s0)
    80201442:	e40c                	sd	a1,8(s0)
    80201444:	e810                	sd	a2,16(s0)
    80201446:	ec14                	sd	a3,24(s0)
    80201448:	f018                	sd	a4,32(s0)
    8020144a:	f41c                	sd	a5,40(s0)
    8020144c:	03043823          	sd	a6,48(s0)
    80201450:	03143c23          	sd	a7,56(s0)
    80201454:	fe042623          	sw	zero,-20(s0)
    80201458:	04040793          	addi	a5,s0,64
    8020145c:	fcf43823          	sd	a5,-48(s0)
    80201460:	fd043783          	ld	a5,-48(s0)
    80201464:	fc878793          	addi	a5,a5,-56
    80201468:	fef43023          	sd	a5,-32(s0)
    8020146c:	fe043783          	ld	a5,-32(s0)
    80201470:	85be                	mv	a1,a5
    80201472:	fd843503          	ld	a0,-40(s0)
    80201476:	f41ff0ef          	jal	802013b6 <_vprintf>
    8020147a:	87aa                	mv	a5,a0
    8020147c:	fef42623          	sw	a5,-20(s0)
    80201480:	fec42783          	lw	a5,-20(s0)
    80201484:	853e                	mv	a0,a5
    80201486:	70a2                	ld	ra,40(sp)
    80201488:	7402                	ld	s0,32(sp)
    8020148a:	6165                	addi	sp,sp,112
    8020148c:	8082                	ret

000000008020148e <snprintf>:
    8020148e:	7159                	addi	sp,sp,-112
    80201490:	fc06                	sd	ra,56(sp)
    80201492:	f822                	sd	s0,48(sp)
    80201494:	0080                	addi	s0,sp,64
    80201496:	fca43c23          	sd	a0,-40(s0)
    8020149a:	fcb43823          	sd	a1,-48(s0)
    8020149e:	fcc43423          	sd	a2,-56(s0)
    802014a2:	e414                	sd	a3,8(s0)
    802014a4:	e818                	sd	a4,16(s0)
    802014a6:	ec1c                	sd	a5,24(s0)
    802014a8:	03043023          	sd	a6,32(s0)
    802014ac:	03143423          	sd	a7,40(s0)
    802014b0:	fd843783          	ld	a5,-40(s0)
    802014b4:	c781                	beqz	a5,802014bc <snprintf+0x2e>
    802014b6:	fd043783          	ld	a5,-48(s0)
    802014ba:	e399                	bnez	a5,802014c0 <snprintf+0x32>
    802014bc:	4781                	li	a5,0
    802014be:	a81d                	j	802014f4 <snprintf+0x66>
    802014c0:	03040793          	addi	a5,s0,48
    802014c4:	fcf43023          	sd	a5,-64(s0)
    802014c8:	fc043783          	ld	a5,-64(s0)
    802014cc:	fd878793          	addi	a5,a5,-40
    802014d0:	fef43023          	sd	a5,-32(s0)
    802014d4:	fe043783          	ld	a5,-32(s0)
    802014d8:	86be                	mv	a3,a5
    802014da:	fc843603          	ld	a2,-56(s0)
    802014de:	fd043583          	ld	a1,-48(s0)
    802014e2:	fd843503          	ld	a0,-40(s0)
    802014e6:	a35ff0ef          	jal	80200f1a <_vsnprintf>
    802014ea:	87aa                	mv	a5,a0
    802014ec:	fef42623          	sw	a5,-20(s0)
    802014f0:	fec42783          	lw	a5,-20(s0)
    802014f4:	853e                	mv	a0,a5
    802014f6:	70e2                	ld	ra,56(sp)
    802014f8:	7442                	ld	s0,48(sp)
    802014fa:	6165                	addi	sp,sp,112
    802014fc:	8082                	ret

00000000802014fe <panic>:
    802014fe:	1101                	addi	sp,sp,-32
    80201500:	ec06                	sd	ra,24(sp)
    80201502:	e822                	sd	s0,16(sp)
    80201504:	1000                	addi	s0,sp,32
    80201506:	fea43423          	sd	a0,-24(s0)
    8020150a:	00006517          	auipc	a0,0x6
    8020150e:	c9650513          	addi	a0,a0,-874 # 802071a0 <user_code_end+0x330>
    80201512:	f25ff0ef          	jal	80201436 <printf>
    80201516:	fe843503          	ld	a0,-24(s0)
    8020151a:	f1dff0ef          	jal	80201436 <printf>
    8020151e:	00006517          	auipc	a0,0x6
    80201522:	c8a50513          	addi	a0,a0,-886 # 802071a8 <user_code_end+0x338>
    80201526:	f11ff0ef          	jal	80201436 <printf>
    8020152a:	0001                	nop
    8020152c:	bffd                	j	8020152a <panic+0x2c>

000000008020152e <r_tp>:
    8020152e:	1101                	addi	sp,sp,-32
    80201530:	ec06                	sd	ra,24(sp)
    80201532:	e822                	sd	s0,16(sp)
    80201534:	1000                	addi	s0,sp,32
    80201536:	8792                	mv	a5,tp
    80201538:	fef43423          	sd	a5,-24(s0)
    8020153c:	fe843783          	ld	a5,-24(s0)
    80201540:	853e                	mv	a0,a5
    80201542:	60e2                	ld	ra,24(sp)
    80201544:	6442                	ld	s0,16(sp)
    80201546:	6105                	addi	sp,sp,32
    80201548:	8082                	ret

000000008020154a <r_mhartid>:
    8020154a:	1141                	addi	sp,sp,-16
    8020154c:	e406                	sd	ra,8(sp)
    8020154e:	e022                	sd	s0,0(sp)
    80201550:	0800                	addi	s0,sp,16
    80201552:	fddff0ef          	jal	8020152e <r_tp>
    80201556:	87aa                	mv	a5,a0
    80201558:	853e                	mv	a0,a5
    8020155a:	60a2                	ld	ra,8(sp)
    8020155c:	6402                	ld	s0,0(sp)
    8020155e:	0141                	addi	sp,sp,16
    80201560:	8082                	ret

0000000080201562 <r_sstatus>:
    80201562:	1101                	addi	sp,sp,-32
    80201564:	ec06                	sd	ra,24(sp)
    80201566:	e822                	sd	s0,16(sp)
    80201568:	1000                	addi	s0,sp,32
    8020156a:	100027f3          	csrr	a5,sstatus
    8020156e:	fef43423          	sd	a5,-24(s0)
    80201572:	fe843783          	ld	a5,-24(s0)
    80201576:	853e                	mv	a0,a5
    80201578:	60e2                	ld	ra,24(sp)
    8020157a:	6442                	ld	s0,16(sp)
    8020157c:	6105                	addi	sp,sp,32
    8020157e:	8082                	ret

0000000080201580 <r_stvec>:
    80201580:	1101                	addi	sp,sp,-32
    80201582:	ec06                	sd	ra,24(sp)
    80201584:	e822                	sd	s0,16(sp)
    80201586:	1000                	addi	s0,sp,32
    80201588:	105027f3          	csrr	a5,stvec
    8020158c:	fef43423          	sd	a5,-24(s0)
    80201590:	fe843783          	ld	a5,-24(s0)
    80201594:	853e                	mv	a0,a5
    80201596:	60e2                	ld	ra,24(sp)
    80201598:	6442                	ld	s0,16(sp)
    8020159a:	6105                	addi	sp,sp,32
    8020159c:	8082                	ret

000000008020159e <r_priv_mode_bits>:
    8020159e:	1141                	addi	sp,sp,-16
    802015a0:	e406                	sd	ra,8(sp)
    802015a2:	e022                	sd	s0,0(sp)
    802015a4:	0800                	addi	s0,sp,16
    802015a6:	fbdff0ef          	jal	80201562 <r_sstatus>
    802015aa:	87aa                	mv	a5,a0
    802015ac:	853e                	mv	a0,a5
    802015ae:	60a2                	ld	ra,8(sp)
    802015b0:	6402                	ld	s0,0(sp)
    802015b2:	0141                	addi	sp,sp,16
    802015b4:	8082                	ret

00000000802015b6 <trap_vec_read>:
    802015b6:	1141                	addi	sp,sp,-16
    802015b8:	e406                	sd	ra,8(sp)
    802015ba:	e022                	sd	s0,0(sp)
    802015bc:	0800                	addi	s0,sp,16
    802015be:	fc3ff0ef          	jal	80201580 <r_stvec>
    802015c2:	87aa                	mv	a5,a0
    802015c4:	853e                	mv	a0,a5
    802015c6:	60a2                	ld	ra,8(sp)
    802015c8:	6402                	ld	s0,0(sp)
    802015ca:	0141                	addi	sp,sp,16
    802015cc:	8082                	ret

00000000802015ce <r_time>:
    802015ce:	1101                	addi	sp,sp,-32
    802015d0:	ec06                	sd	ra,24(sp)
    802015d2:	e822                	sd	s0,16(sp)
    802015d4:	1000                	addi	s0,sp,32
    802015d6:	c01027f3          	rdtime	a5
    802015da:	fef43423          	sd	a5,-24(s0)
    802015de:	fe843783          	ld	a5,-24(s0)
    802015e2:	853e                	mv	a0,a5
    802015e4:	60e2                	ld	ra,24(sp)
    802015e6:	6442                	ld	s0,16(sp)
    802015e8:	6105                	addi	sp,sp,32
    802015ea:	8082                	ret

00000000802015ec <osviz_init>:
    802015ec:	1141                	addi	sp,sp,-16
    802015ee:	e406                	sd	ra,8(sp)
    802015f0:	e022                	sd	s0,0(sp)
    802015f2:	0800                	addi	s0,sp,16
    802015f4:	fdbff0ef          	jal	802015ce <r_time>
    802015f8:	872a                	mv	a4,a0
    802015fa:	0000e797          	auipc	a5,0xe
    802015fe:	f9678793          	addi	a5,a5,-106 # 8020f590 <boot_mtime>
    80201602:	e398                	sd	a4,0(a5)
    80201604:	0001                	nop
    80201606:	60a2                	ld	ra,8(sp)
    80201608:	6402                	ld	s0,0(sp)
    8020160a:	0141                	addi	sp,sp,16
    8020160c:	8082                	ret

000000008020160e <osviz_millis>:
    8020160e:	1101                	addi	sp,sp,-32
    80201610:	ec06                	sd	ra,24(sp)
    80201612:	e822                	sd	s0,16(sp)
    80201614:	1000                	addi	s0,sp,32
    80201616:	fb9ff0ef          	jal	802015ce <r_time>
    8020161a:	fea43423          	sd	a0,-24(s0)
    8020161e:	0000e797          	auipc	a5,0xe
    80201622:	f7278793          	addi	a5,a5,-142 # 8020f590 <boot_mtime>
    80201626:	639c                	ld	a5,0(a5)
    80201628:	fe843703          	ld	a4,-24(s0)
    8020162c:	00f77463          	bgeu	a4,a5,80201634 <osviz_millis+0x26>
    80201630:	4781                	li	a5,0
    80201632:	a089                	j	80201674 <osviz_millis+0x66>
    80201634:	fe843783          	ld	a5,-24(s0)
    80201638:	0007871b          	sext.w	a4,a5
    8020163c:	0000e797          	auipc	a5,0xe
    80201640:	f5478793          	addi	a5,a5,-172 # 8020f590 <boot_mtime>
    80201644:	639c                	ld	a5,0(a5)
    80201646:	2781                	sext.w	a5,a5
    80201648:	40f707bb          	subw	a5,a4,a5
    8020164c:	fef42223          	sw	a5,-28(s0)
    80201650:	fe442783          	lw	a5,-28(s0)
    80201654:	02079713          	slli	a4,a5,0x20
    80201658:	9301                	srli	a4,a4,0x20
    8020165a:	00006797          	auipc	a5,0x6
    8020165e:	d9e78793          	addi	a5,a5,-610 # 802073f8 <user_code_end+0x588>
    80201662:	639c                	ld	a5,0(a5)
    80201664:	02f707b3          	mul	a5,a4,a5
    80201668:	9381                	srli	a5,a5,0x20
    8020166a:	00d7d79b          	srliw	a5,a5,0xd
    8020166e:	2781                	sext.w	a5,a5
    80201670:	1782                	slli	a5,a5,0x20
    80201672:	9381                	srli	a5,a5,0x20
    80201674:	853e                	mv	a0,a5
    80201676:	60e2                	ld	ra,24(sp)
    80201678:	6442                	ld	s0,16(sp)
    8020167a:	6105                	addi	sp,sp,32
    8020167c:	8082                	ret

000000008020167e <osviz_event>:
    8020167e:	7139                	addi	sp,sp,-64
    80201680:	fc06                	sd	ra,56(sp)
    80201682:	f822                	sd	s0,48(sp)
    80201684:	0080                	addi	s0,sp,64
    80201686:	fca43c23          	sd	a0,-40(s0)
    8020168a:	fcb43823          	sd	a1,-48(s0)
    8020168e:	fcc43423          	sd	a2,-56(s0)
    80201692:	eb9ff0ef          	jal	8020154a <r_mhartid>
    80201696:	fea43423          	sd	a0,-24(s0)
    8020169a:	f75ff0ef          	jal	8020160e <osviz_millis>
    8020169e:	fea43023          	sd	a0,-32(s0)
    802016a2:	fd843783          	ld	a5,-40(s0)
    802016a6:	c781                	beqz	a5,802016ae <osviz_event+0x30>
    802016a8:	fd043783          	ld	a5,-48(s0)
    802016ac:	e399                	bnez	a5,802016b2 <osviz_event+0x34>
    802016ae:	57fd                	li	a5,-1
    802016b0:	a0bd                	j	8020171e <osviz_event+0xa0>
    802016b2:	fc843783          	ld	a5,-56(s0)
    802016b6:	cf95                	beqz	a5,802016f2 <osviz_event+0x74>
    802016b8:	fc843783          	ld	a5,-56(s0)
    802016bc:	0007c783          	lbu	a5,0(a5)
    802016c0:	cb8d                	beqz	a5,802016f2 <osviz_event+0x74>
    802016c2:	fe043783          	ld	a5,-32(s0)
    802016c6:	0007861b          	sext.w	a2,a5
    802016ca:	fe843783          	ld	a5,-24(s0)
    802016ce:	2781                	sext.w	a5,a5
    802016d0:	fc843803          	ld	a6,-56(s0)
    802016d4:	fd043703          	ld	a4,-48(s0)
    802016d8:	fd843683          	ld	a3,-40(s0)
    802016dc:	00006597          	auipc	a1,0x6
    802016e0:	adc58593          	addi	a1,a1,-1316 # 802071b8 <user_code_end+0x348>
    802016e4:	00006517          	auipc	a0,0x6
    802016e8:	adc50513          	addi	a0,a0,-1316 # 802071c0 <user_code_end+0x350>
    802016ec:	d4bff0ef          	jal	80201436 <printf>
    802016f0:	a035                	j	8020171c <osviz_event+0x9e>
    802016f2:	fe043783          	ld	a5,-32(s0)
    802016f6:	0007861b          	sext.w	a2,a5
    802016fa:	fe843783          	ld	a5,-24(s0)
    802016fe:	2781                	sext.w	a5,a5
    80201700:	fd043703          	ld	a4,-48(s0)
    80201704:	fd843683          	ld	a3,-40(s0)
    80201708:	00006597          	auipc	a1,0x6
    8020170c:	ab058593          	addi	a1,a1,-1360 # 802071b8 <user_code_end+0x348>
    80201710:	00006517          	auipc	a0,0x6
    80201714:	af850513          	addi	a0,a0,-1288 # 80207208 <user_code_end+0x398>
    80201718:	d1fff0ef          	jal	80201436 <printf>
    8020171c:	4781                	li	a5,0
    8020171e:	853e                	mv	a0,a5
    80201720:	70e2                	ld	ra,56(sp)
    80201722:	7442                	ld	s0,48(sp)
    80201724:	6121                	addi	sp,sp,64
    80201726:	8082                	ret

0000000080201728 <osviz_snapshot>:
    80201728:	7105                	addi	sp,sp,-480
    8020172a:	ef86                	sd	ra,472(sp)
    8020172c:	eba2                	sd	s0,464(sp)
    8020172e:	e7a6                	sd	s1,456(sp)
    80201730:	e3ca                	sd	s2,448(sp)
    80201732:	1380                	addi	s0,sp,480
    80201734:	e83ff0ef          	jal	802015b6 <trap_vec_read>
    80201738:	fca43c23          	sd	a0,-40(s0)
    8020173c:	e63ff0ef          	jal	8020159e <r_priv_mode_bits>
    80201740:	fca43823          	sd	a0,-48(s0)
    80201744:	fd843483          	ld	s1,-40(s0)
    80201748:	fd043903          	ld	s2,-48(s0)
    8020174c:	dffff0ef          	jal	8020154a <r_mhartid>
    80201750:	87aa                	mv	a5,a0
    80201752:	0007871b          	sext.w	a4,a5
    80201756:	0000e797          	auipc	a5,0xe
    8020175a:	e4278793          	addi	a5,a5,-446 # 8020f598 <g_irq_stats>
    8020175e:	439c                	lw	a5,0(a5)
    80201760:	86be                	mv	a3,a5
    80201762:	0000e797          	auipc	a5,0xe
    80201766:	e3678793          	addi	a5,a5,-458 # 8020f598 <g_irq_stats>
    8020176a:	43dc                	lw	a5,4(a5)
    8020176c:	863e                	mv	a2,a5
    8020176e:	0000e797          	auipc	a5,0xe
    80201772:	e2a78793          	addi	a5,a5,-470 # 8020f598 <g_irq_stats>
    80201776:	479c                	lw	a5,8(a5)
    80201778:	85be                	mv	a1,a5
    8020177a:	0000e797          	auipc	a5,0xe
    8020177e:	e1e78793          	addi	a5,a5,-482 # 8020f598 <g_irq_stats>
    80201782:	47dc                	lw	a5,12(a5)
    80201784:	883e                	mv	a6,a5
    80201786:	0000e797          	auipc	a5,0xe
    8020178a:	e1278793          	addi	a5,a5,-494 # 8020f598 <g_irq_stats>
    8020178e:	4b9c                	lw	a5,16(a5)
    80201790:	88be                	mv	a7,a5
    80201792:	0000e797          	auipc	a5,0xe
    80201796:	e0678793          	addi	a5,a5,-506 # 8020f598 <g_irq_stats>
    8020179a:	4bdc                	lw	a5,20(a5)
    8020179c:	e5040513          	addi	a0,s0,-432
    802017a0:	f43e                	sd	a5,40(sp)
    802017a2:	f046                	sd	a7,32(sp)
    802017a4:	ec42                	sd	a6,24(sp)
    802017a6:	e82e                	sd	a1,16(sp)
    802017a8:	e432                	sd	a2,8(sp)
    802017aa:	e036                	sd	a3,0(sp)
    802017ac:	88ba                	mv	a7,a4
    802017ae:	884a                	mv	a6,s2
    802017b0:	87a6                	mv	a5,s1
    802017b2:	00006717          	auipc	a4,0x6
    802017b6:	a8e70713          	addi	a4,a4,-1394 # 80207240 <user_code_end+0x3d0>
    802017ba:	00006697          	auipc	a3,0x6
    802017be:	a9668693          	addi	a3,a3,-1386 # 80207250 <user_code_end+0x3e0>
    802017c2:	00006617          	auipc	a2,0x6
    802017c6:	a9660613          	addi	a2,a2,-1386 # 80207258 <user_code_end+0x3e8>
    802017ca:	18000593          	li	a1,384
    802017ce:	cc1ff0ef          	jal	8020148e <snprintf>
    802017d2:	e5040793          	addi	a5,s0,-432
    802017d6:	863e                	mv	a2,a5
    802017d8:	00006597          	auipc	a1,0x6
    802017dc:	b4858593          	addi	a1,a1,-1208 # 80207320 <user_code_end+0x4b0>
    802017e0:	00006517          	auipc	a0,0x6
    802017e4:	b5050513          	addi	a0,a0,-1200 # 80207330 <user_code_end+0x4c0>
    802017e8:	c4fff0ef          	jal	80201436 <printf>
    802017ec:	4781                	li	a5,0
    802017ee:	853e                	mv	a0,a5
    802017f0:	60fe                	ld	ra,472(sp)
    802017f2:	645e                	ld	s0,464(sp)
    802017f4:	64be                	ld	s1,456(sp)
    802017f6:	691e                	ld	s2,448(sp)
    802017f8:	613d                	addi	sp,sp,480
    802017fa:	8082                	ret

00000000802017fc <osviz_boot_banner>:
    802017fc:	1141                	addi	sp,sp,-16
    802017fe:	e406                	sd	ra,8(sp)
    80201800:	e022                	sd	s0,0(sp)
    80201802:	0800                	addi	s0,sp,16
    80201804:	00006517          	auipc	a0,0x6
    80201808:	b3450513          	addi	a0,a0,-1228 # 80207338 <user_code_end+0x4c8>
    8020180c:	c2bff0ef          	jal	80201436 <printf>
    80201810:	00006517          	auipc	a0,0x6
    80201814:	b3050513          	addi	a0,a0,-1232 # 80207340 <user_code_end+0x4d0>
    80201818:	c1fff0ef          	jal	80201436 <printf>
    8020181c:	00006617          	auipc	a2,0x6
    80201820:	a2460613          	addi	a2,a2,-1500 # 80207240 <user_code_end+0x3d0>
    80201824:	00006597          	auipc	a1,0x6
    80201828:	a2c58593          	addi	a1,a1,-1492 # 80207250 <user_code_end+0x3e0>
    8020182c:	00006517          	auipc	a0,0x6
    80201830:	b4450513          	addi	a0,a0,-1212 # 80207370 <user_code_end+0x500>
    80201834:	c03ff0ef          	jal	80201436 <printf>
    80201838:	00006517          	auipc	a0,0x6
    8020183c:	b6850513          	addi	a0,a0,-1176 # 802073a0 <user_code_end+0x530>
    80201840:	bf7ff0ef          	jal	80201436 <printf>
    80201844:	00006517          	auipc	a0,0x6
    80201848:	afc50513          	addi	a0,a0,-1284 # 80207340 <user_code_end+0x4d0>
    8020184c:	bebff0ef          	jal	80201436 <printf>
    80201850:	00006617          	auipc	a2,0x6
    80201854:	b8060613          	addi	a2,a2,-1152 # 802073d0 <user_code_end+0x560>
    80201858:	00006597          	auipc	a1,0x6
    8020185c:	b9058593          	addi	a1,a1,-1136 # 802073e8 <user_code_end+0x578>
    80201860:	00006517          	auipc	a0,0x6
    80201864:	b9050513          	addi	a0,a0,-1136 # 802073f0 <user_code_end+0x580>
    80201868:	e17ff0ef          	jal	8020167e <osviz_event>
    8020186c:	0001                	nop
    8020186e:	60a2                	ld	ra,8(sp)
    80201870:	6402                	ld	s0,0(sp)
    80201872:	0141                	addi	sp,sp,16
    80201874:	8082                	ret

0000000080201876 <stats_inc_timer>:
    80201876:	1141                	addi	sp,sp,-16
    80201878:	e406                	sd	ra,8(sp)
    8020187a:	e022                	sd	s0,0(sp)
    8020187c:	0800                	addi	s0,sp,16
    8020187e:	0000e797          	auipc	a5,0xe
    80201882:	d1a78793          	addi	a5,a5,-742 # 8020f598 <g_irq_stats>
    80201886:	439c                	lw	a5,0(a5)
    80201888:	2785                	addiw	a5,a5,1
    8020188a:	0007871b          	sext.w	a4,a5
    8020188e:	0000e797          	auipc	a5,0xe
    80201892:	d0a78793          	addi	a5,a5,-758 # 8020f598 <g_irq_stats>
    80201896:	c398                	sw	a4,0(a5)
    80201898:	0001                	nop
    8020189a:	60a2                	ld	ra,8(sp)
    8020189c:	6402                	ld	s0,0(sp)
    8020189e:	0141                	addi	sp,sp,16
    802018a0:	8082                	ret

00000000802018a2 <stats_inc_uart_rx>:
    802018a2:	1141                	addi	sp,sp,-16
    802018a4:	e406                	sd	ra,8(sp)
    802018a6:	e022                	sd	s0,0(sp)
    802018a8:	0800                	addi	s0,sp,16
    802018aa:	0000e797          	auipc	a5,0xe
    802018ae:	cee78793          	addi	a5,a5,-786 # 8020f598 <g_irq_stats>
    802018b2:	43dc                	lw	a5,4(a5)
    802018b4:	2785                	addiw	a5,a5,1
    802018b6:	0007871b          	sext.w	a4,a5
    802018ba:	0000e797          	auipc	a5,0xe
    802018be:	cde78793          	addi	a5,a5,-802 # 8020f598 <g_irq_stats>
    802018c2:	c3d8                	sw	a4,4(a5)
    802018c4:	0001                	nop
    802018c6:	60a2                	ld	ra,8(sp)
    802018c8:	6402                	ld	s0,0(sp)
    802018ca:	0141                	addi	sp,sp,16
    802018cc:	8082                	ret

00000000802018ce <stats_inc_sw_irq>:
    802018ce:	1141                	addi	sp,sp,-16
    802018d0:	e406                	sd	ra,8(sp)
    802018d2:	e022                	sd	s0,0(sp)
    802018d4:	0800                	addi	s0,sp,16
    802018d6:	0000e797          	auipc	a5,0xe
    802018da:	cc278793          	addi	a5,a5,-830 # 8020f598 <g_irq_stats>
    802018de:	479c                	lw	a5,8(a5)
    802018e0:	2785                	addiw	a5,a5,1
    802018e2:	0007871b          	sext.w	a4,a5
    802018e6:	0000e797          	auipc	a5,0xe
    802018ea:	cb278793          	addi	a5,a5,-846 # 8020f598 <g_irq_stats>
    802018ee:	c798                	sw	a4,8(a5)
    802018f0:	0001                	nop
    802018f2:	60a2                	ld	ra,8(sp)
    802018f4:	6402                	ld	s0,0(sp)
    802018f6:	0141                	addi	sp,sp,16
    802018f8:	8082                	ret

00000000802018fa <stats_inc_ext_irq>:
    802018fa:	1141                	addi	sp,sp,-16
    802018fc:	e406                	sd	ra,8(sp)
    802018fe:	e022                	sd	s0,0(sp)
    80201900:	0800                	addi	s0,sp,16
    80201902:	0000e797          	auipc	a5,0xe
    80201906:	c9678793          	addi	a5,a5,-874 # 8020f598 <g_irq_stats>
    8020190a:	47dc                	lw	a5,12(a5)
    8020190c:	2785                	addiw	a5,a5,1
    8020190e:	0007871b          	sext.w	a4,a5
    80201912:	0000e797          	auipc	a5,0xe
    80201916:	c8678793          	addi	a5,a5,-890 # 8020f598 <g_irq_stats>
    8020191a:	c7d8                	sw	a4,12(a5)
    8020191c:	0001                	nop
    8020191e:	60a2                	ld	ra,8(sp)
    80201920:	6402                	ld	s0,0(sp)
    80201922:	0141                	addi	sp,sp,16
    80201924:	8082                	ret

0000000080201926 <stats_inc_ecall>:
    80201926:	1141                	addi	sp,sp,-16
    80201928:	e406                	sd	ra,8(sp)
    8020192a:	e022                	sd	s0,0(sp)
    8020192c:	0800                	addi	s0,sp,16
    8020192e:	0000e797          	auipc	a5,0xe
    80201932:	c6a78793          	addi	a5,a5,-918 # 8020f598 <g_irq_stats>
    80201936:	4b9c                	lw	a5,16(a5)
    80201938:	2785                	addiw	a5,a5,1
    8020193a:	0007871b          	sext.w	a4,a5
    8020193e:	0000e797          	auipc	a5,0xe
    80201942:	c5a78793          	addi	a5,a5,-934 # 8020f598 <g_irq_stats>
    80201946:	cb98                	sw	a4,16(a5)
    80201948:	0001                	nop
    8020194a:	60a2                	ld	ra,8(sp)
    8020194c:	6402                	ld	s0,0(sp)
    8020194e:	0141                	addi	sp,sp,16
    80201950:	8082                	ret

0000000080201952 <stats_inc_page_fault>:
    80201952:	1141                	addi	sp,sp,-16
    80201954:	e406                	sd	ra,8(sp)
    80201956:	e022                	sd	s0,0(sp)
    80201958:	0800                	addi	s0,sp,16
    8020195a:	0000e797          	auipc	a5,0xe
    8020195e:	c3e78793          	addi	a5,a5,-962 # 8020f598 <g_irq_stats>
    80201962:	4bdc                	lw	a5,20(a5)
    80201964:	2785                	addiw	a5,a5,1
    80201966:	0007871b          	sext.w	a4,a5
    8020196a:	0000e797          	auipc	a5,0xe
    8020196e:	c2e78793          	addi	a5,a5,-978 # 8020f598 <g_irq_stats>
    80201972:	cbd8                	sw	a4,20(a5)
    80201974:	0001                	nop
    80201976:	60a2                	ld	ra,8(sp)
    80201978:	6402                	ld	s0,0(sp)
    8020197a:	0141                	addi	sp,sp,16
    8020197c:	8082                	ret

000000008020197e <r_sstatus>:
    8020197e:	1101                	addi	sp,sp,-32
    80201980:	ec06                	sd	ra,24(sp)
    80201982:	e822                	sd	s0,16(sp)
    80201984:	1000                	addi	s0,sp,32
    80201986:	100027f3          	csrr	a5,sstatus
    8020198a:	fef43423          	sd	a5,-24(s0)
    8020198e:	fe843783          	ld	a5,-24(s0)
    80201992:	853e                	mv	a0,a5
    80201994:	60e2                	ld	ra,24(sp)
    80201996:	6442                	ld	s0,16(sp)
    80201998:	6105                	addi	sp,sp,32
    8020199a:	8082                	ret

000000008020199c <w_sstatus>:
    8020199c:	1101                	addi	sp,sp,-32
    8020199e:	ec06                	sd	ra,24(sp)
    802019a0:	e822                	sd	s0,16(sp)
    802019a2:	1000                	addi	s0,sp,32
    802019a4:	fea43423          	sd	a0,-24(s0)
    802019a8:	fe843783          	ld	a5,-24(s0)
    802019ac:	10079073          	csrw	sstatus,a5
    802019b0:	0001                	nop
    802019b2:	60e2                	ld	ra,24(sp)
    802019b4:	6442                	ld	s0,16(sp)
    802019b6:	6105                	addi	sp,sp,32
    802019b8:	8082                	ret

00000000802019ba <w_sscratch>:
    802019ba:	1101                	addi	sp,sp,-32
    802019bc:	ec06                	sd	ra,24(sp)
    802019be:	e822                	sd	s0,16(sp)
    802019c0:	1000                	addi	s0,sp,32
    802019c2:	fea43423          	sd	a0,-24(s0)
    802019c6:	fe843783          	ld	a5,-24(s0)
    802019ca:	14079073          	csrw	sscratch,a5
    802019ce:	0001                	nop
    802019d0:	60e2                	ld	ra,24(sp)
    802019d2:	6442                	ld	s0,16(sp)
    802019d4:	6105                	addi	sp,sp,32
    802019d6:	8082                	ret

00000000802019d8 <w_stvec>:
    802019d8:	1101                	addi	sp,sp,-32
    802019da:	ec06                	sd	ra,24(sp)
    802019dc:	e822                	sd	s0,16(sp)
    802019de:	1000                	addi	s0,sp,32
    802019e0:	fea43423          	sd	a0,-24(s0)
    802019e4:	fe843783          	ld	a5,-24(s0)
    802019e8:	10579073          	csrw	stvec,a5
    802019ec:	0001                	nop
    802019ee:	60e2                	ld	ra,24(sp)
    802019f0:	6442                	ld	s0,16(sp)
    802019f2:	6105                	addi	sp,sp,32
    802019f4:	8082                	ret

00000000802019f6 <r_sip>:
    802019f6:	1101                	addi	sp,sp,-32
    802019f8:	ec06                	sd	ra,24(sp)
    802019fa:	e822                	sd	s0,16(sp)
    802019fc:	1000                	addi	s0,sp,32
    802019fe:	144027f3          	csrr	a5,sip
    80201a02:	fef43423          	sd	a5,-24(s0)
    80201a06:	fe843783          	ld	a5,-24(s0)
    80201a0a:	853e                	mv	a0,a5
    80201a0c:	60e2                	ld	ra,24(sp)
    80201a0e:	6442                	ld	s0,16(sp)
    80201a10:	6105                	addi	sp,sp,32
    80201a12:	8082                	ret

0000000080201a14 <w_sip>:
    80201a14:	1101                	addi	sp,sp,-32
    80201a16:	ec06                	sd	ra,24(sp)
    80201a18:	e822                	sd	s0,16(sp)
    80201a1a:	1000                	addi	s0,sp,32
    80201a1c:	fea43423          	sd	a0,-24(s0)
    80201a20:	fe843783          	ld	a5,-24(s0)
    80201a24:	14479073          	csrw	sip,a5
    80201a28:	0001                	nop
    80201a2a:	60e2                	ld	ra,24(sp)
    80201a2c:	6442                	ld	s0,16(sp)
    80201a2e:	6105                	addi	sp,sp,32
    80201a30:	8082                	ret

0000000080201a32 <trap_vec_init>:
    80201a32:	1101                	addi	sp,sp,-32
    80201a34:	ec06                	sd	ra,24(sp)
    80201a36:	e822                	sd	s0,16(sp)
    80201a38:	1000                	addi	s0,sp,32
    80201a3a:	fea43423          	sd	a0,-24(s0)
    80201a3e:	fe843503          	ld	a0,-24(s0)
    80201a42:	f97ff0ef          	jal	802019d8 <w_stvec>
    80201a46:	0001                	nop
    80201a48:	60e2                	ld	ra,24(sp)
    80201a4a:	6442                	ld	s0,16(sp)
    80201a4c:	6105                	addi	sp,sp,32
    80201a4e:	8082                	ret

0000000080201a50 <trap_scratch_init>:
    80201a50:	1101                	addi	sp,sp,-32
    80201a52:	ec06                	sd	ra,24(sp)
    80201a54:	e822                	sd	s0,16(sp)
    80201a56:	1000                	addi	s0,sp,32
    80201a58:	fea43423          	sd	a0,-24(s0)
    80201a5c:	fe843503          	ld	a0,-24(s0)
    80201a60:	f5bff0ef          	jal	802019ba <w_sscratch>
    80201a64:	0001                	nop
    80201a66:	60e2                	ld	ra,24(sp)
    80201a68:	6442                	ld	s0,16(sp)
    80201a6a:	6105                	addi	sp,sp,32
    80201a6c:	8082                	ret

0000000080201a6e <cpu_irq_disable>:
    80201a6e:	1141                	addi	sp,sp,-16
    80201a70:	e406                	sd	ra,8(sp)
    80201a72:	e022                	sd	s0,0(sp)
    80201a74:	0800                	addi	s0,sp,16
    80201a76:	f09ff0ef          	jal	8020197e <r_sstatus>
    80201a7a:	87aa                	mv	a5,a0
    80201a7c:	9bf5                	andi	a5,a5,-3
    80201a7e:	853e                	mv	a0,a5
    80201a80:	f1dff0ef          	jal	8020199c <w_sstatus>
    80201a84:	0001                	nop
    80201a86:	60a2                	ld	ra,8(sp)
    80201a88:	6402                	ld	s0,0(sp)
    80201a8a:	0141                	addi	sp,sp,16
    80201a8c:	8082                	ret

0000000080201a8e <cpu_irq_enable>:
    80201a8e:	1141                	addi	sp,sp,-16
    80201a90:	e406                	sd	ra,8(sp)
    80201a92:	e022                	sd	s0,0(sp)
    80201a94:	0800                	addi	s0,sp,16
    80201a96:	ee9ff0ef          	jal	8020197e <r_sstatus>
    80201a9a:	87aa                	mv	a5,a0
    80201a9c:	0027e793          	ori	a5,a5,2
    80201aa0:	853e                	mv	a0,a5
    80201aa2:	efbff0ef          	jal	8020199c <w_sstatus>
    80201aa6:	0001                	nop
    80201aa8:	60a2                	ld	ra,8(sp)
    80201aaa:	6402                	ld	s0,0(sp)
    80201aac:	0141                	addi	sp,sp,16
    80201aae:	8082                	ret

0000000080201ab0 <handle_sync_exception>:
    80201ab0:	7159                	addi	sp,sp,-112
    80201ab2:	f486                	sd	ra,104(sp)
    80201ab4:	f0a2                	sd	s0,96(sp)
    80201ab6:	1880                	addi	s0,sp,112
    80201ab8:	faa43423          	sd	a0,-88(s0)
    80201abc:	fab43023          	sd	a1,-96(s0)
    80201ac0:	f8c43c23          	sd	a2,-104(s0)
    80201ac4:	f8d43823          	sd	a3,-112(s0)
    80201ac8:	fa843703          	ld	a4,-88(s0)
    80201acc:	47bd                	li	a5,15
    80201ace:	0ef70d63          	beq	a4,a5,80201bc8 <handle_sync_exception+0x118>
    80201ad2:	fa843703          	ld	a4,-88(s0)
    80201ad6:	47bd                	li	a5,15
    80201ad8:	14e7e963          	bltu	a5,a4,80201c2a <handle_sync_exception+0x17a>
    80201adc:	fa843703          	ld	a4,-88(s0)
    80201ae0:	47a5                	li	a5,9
    80201ae2:	00e7e863          	bltu	a5,a4,80201af2 <handle_sync_exception+0x42>
    80201ae6:	fa843703          	ld	a4,-88(s0)
    80201aea:	47a1                	li	a5,8
    80201aec:	00f77b63          	bgeu	a4,a5,80201b02 <handle_sync_exception+0x52>
    80201af0:	aa2d                	j	80201c2a <handle_sync_exception+0x17a>
    80201af2:	fa843783          	ld	a5,-88(s0)
    80201af6:	ff478713          	addi	a4,a5,-12
    80201afa:	4785                	li	a5,1
    80201afc:	12e7e763          	bltu	a5,a4,80201c2a <handle_sync_exception+0x17a>
    80201b00:	a0e1                	j	80201bc8 <handle_sync_exception+0x118>
    80201b02:	e25ff0ef          	jal	80201926 <stats_inc_ecall>
    80201b06:	f9843783          	ld	a5,-104(s0)
    80201b0a:	63d8                	ld	a4,128(a5)
    80201b0c:	05d00793          	li	a5,93
    80201b10:	08f71f63          	bne	a4,a5,80201bae <handle_sync_exception+0xfe>
    80201b14:	0000d797          	auipc	a5,0xd
    80201b18:	57c78793          	addi	a5,a5,1404 # 8020f090 <prog_exec_active>
    80201b1c:	439c                	lw	a5,0(a5)
    80201b1e:	cfa9                	beqz	a5,80201b78 <handle_sync_exception+0xc8>
    80201b20:	f9843783          	ld	a5,-104(s0)
    80201b24:	67b8                	ld	a4,72(a5)
    80201b26:	00011797          	auipc	a5,0x11
    80201b2a:	2b278793          	addi	a5,a5,690 # 80212dd8 <shell_save_cxt>
    80201b2e:	e7b8                	sd	a4,72(a5)
    80201b30:	0000d797          	auipc	a5,0xd
    80201b34:	56478793          	addi	a5,a5,1380 # 8020f094 <prog_exec_restore_shell>
    80201b38:	4705                	li	a4,1
    80201b3a:	c398                	sw	a4,0(a5)
    80201b3c:	0000d797          	auipc	a5,0xd
    80201b40:	55478793          	addi	a5,a5,1364 # 8020f090 <prog_exec_active>
    80201b44:	0007a023          	sw	zero,0(a5)
    80201b48:	18e000ef          	jal	80201cd6 <trap_use_kernel_cxt>
    80201b4c:	00002717          	auipc	a4,0x2
    80201b50:	43470713          	addi	a4,a4,1076 # 80203f80 <prog_exec_done>
    80201b54:	f9043783          	ld	a5,-112(s0)
    80201b58:	e398                	sd	a4,0(a5)
    80201b5a:	00006617          	auipc	a2,0x6
    80201b5e:	8a660613          	addi	a2,a2,-1882 # 80207400 <user_code_end+0x590>
    80201b62:	00006597          	auipc	a1,0x6
    80201b66:	8b658593          	addi	a1,a1,-1866 # 80207418 <user_code_end+0x5a8>
    80201b6a:	00006517          	auipc	a0,0x6
    80201b6e:	8b650513          	addi	a0,a0,-1866 # 80207420 <user_code_end+0x5b0>
    80201b72:	b0dff0ef          	jal	8020167e <osviz_event>
    80201b76:	aa31                	j	80201c92 <handle_sync_exception+0x1e2>
    80201b78:	f9843783          	ld	a5,-104(s0)
    80201b7c:	67bc                	ld	a5,72(a5)
    80201b7e:	2781                	sext.w	a5,a5
    80201b80:	85be                	mv	a1,a5
    80201b82:	f9843503          	ld	a0,-104(s0)
    80201b86:	228010ef          	jal	80202dae <task_exit_to_idle>
    80201b8a:	4601                	li	a2,0
    80201b8c:	00006597          	auipc	a1,0x6
    80201b90:	88c58593          	addi	a1,a1,-1908 # 80207418 <user_code_end+0x5a8>
    80201b94:	00006517          	auipc	a0,0x6
    80201b98:	88c50513          	addi	a0,a0,-1908 # 80207420 <user_code_end+0x5b0>
    80201b9c:	ae3ff0ef          	jal	8020167e <osviz_event>
    80201ba0:	f9843783          	ld	a5,-104(s0)
    80201ba4:	7ff8                	ld	a4,248(a5)
    80201ba6:	f9043783          	ld	a5,-112(s0)
    80201baa:	e398                	sd	a4,0(a5)
    80201bac:	a0dd                	j	80201c92 <handle_sync_exception+0x1e2>
    80201bae:	f9843503          	ld	a0,-104(s0)
    80201bb2:	573010ef          	jal	80203924 <do_syscall>
    80201bb6:	f9043783          	ld	a5,-112(s0)
    80201bba:	639c                	ld	a5,0(a5)
    80201bbc:	00478713          	addi	a4,a5,4
    80201bc0:	f9043783          	ld	a5,-112(s0)
    80201bc4:	e398                	sd	a4,0(a5)
    80201bc6:	a0f1                	j	80201c92 <handle_sync_exception+0x1e2>
    80201bc8:	d8bff0ef          	jal	80201952 <stats_inc_page_fault>
    80201bcc:	fa043683          	ld	a3,-96(s0)
    80201bd0:	fa843703          	ld	a4,-88(s0)
    80201bd4:	fb040793          	addi	a5,s0,-80
    80201bd8:	00006617          	auipc	a2,0x6
    80201bdc:	85060613          	addi	a2,a2,-1968 # 80207428 <user_code_end+0x5b8>
    80201be0:	04000593          	li	a1,64
    80201be4:	853e                	mv	a0,a5
    80201be6:	8a9ff0ef          	jal	8020148e <snprintf>
    80201bea:	fb040793          	addi	a5,s0,-80
    80201bee:	863e                	mv	a2,a5
    80201bf0:	00006597          	auipc	a1,0x6
    80201bf4:	85858593          	addi	a1,a1,-1960 # 80207448 <user_code_end+0x5d8>
    80201bf8:	00006517          	auipc	a0,0x6
    80201bfc:	86050513          	addi	a0,a0,-1952 # 80207458 <user_code_end+0x5e8>
    80201c00:	a7fff0ef          	jal	8020167e <osviz_event>
    80201c04:	fa043783          	ld	a5,-96(s0)
    80201c08:	fa843703          	ld	a4,-88(s0)
    80201c0c:	863a                	mv	a2,a4
    80201c0e:	85be                	mv	a1,a5
    80201c10:	00006517          	auipc	a0,0x6
    80201c14:	85050513          	addi	a0,a0,-1968 # 80207460 <user_code_end+0x5f0>
    80201c18:	81fff0ef          	jal	80201436 <printf>
    80201c1c:	00006517          	auipc	a0,0x6
    80201c20:	86c50513          	addi	a0,a0,-1940 # 80207488 <user_code_end+0x618>
    80201c24:	8dbff0ef          	jal	802014fe <panic>
    80201c28:	a0ad                	j	80201c92 <handle_sync_exception+0x1e2>
    80201c2a:	fa843703          	ld	a4,-88(s0)
    80201c2e:	fb040793          	addi	a5,s0,-80
    80201c32:	86ba                	mv	a3,a4
    80201c34:	00006617          	auipc	a2,0x6
    80201c38:	87c60613          	addi	a2,a2,-1924 # 802074b0 <user_code_end+0x640>
    80201c3c:	04000593          	li	a1,64
    80201c40:	853e                	mv	a0,a5
    80201c42:	84dff0ef          	jal	8020148e <snprintf>
    80201c46:	fb040793          	addi	a5,s0,-80
    80201c4a:	863e                	mv	a2,a5
    80201c4c:	00006597          	auipc	a1,0x6
    80201c50:	87458593          	addi	a1,a1,-1932 # 802074c0 <user_code_end+0x650>
    80201c54:	00006517          	auipc	a0,0x6
    80201c58:	80450513          	addi	a0,a0,-2044 # 80207458 <user_code_end+0x5e8>
    80201c5c:	a23ff0ef          	jal	8020167e <osviz_event>
    80201c60:	fa843783          	ld	a5,-88(s0)
    80201c64:	fa043703          	ld	a4,-96(s0)
    80201c68:	863a                	mv	a2,a4
    80201c6a:	85be                	mv	a1,a5
    80201c6c:	00006517          	auipc	a0,0x6
    80201c70:	86450513          	addi	a0,a0,-1948 # 802074d0 <user_code_end+0x660>
    80201c74:	fc2ff0ef          	jal	80201436 <printf>
    80201c78:	00006517          	auipc	a0,0x6
    80201c7c:	88050513          	addi	a0,a0,-1920 # 802074f8 <user_code_end+0x688>
    80201c80:	378000ef          	jal	80201ff8 <trap_diag_print_csrs>
    80201c84:	00006517          	auipc	a0,0x6
    80201c88:	88450513          	addi	a0,a0,-1916 # 80207508 <user_code_end+0x698>
    80201c8c:	873ff0ef          	jal	802014fe <panic>
    80201c90:	0001                	nop
    80201c92:	0001                	nop
    80201c94:	70a6                	ld	ra,104(sp)
    80201c96:	7406                	ld	s0,96(sp)
    80201c98:	6165                	addi	sp,sp,112
    80201c9a:	8082                	ret

0000000080201c9c <trap_init>:
    80201c9c:	1141                	addi	sp,sp,-16
    80201c9e:	e406                	sd	ra,8(sp)
    80201ca0:	e022                	sd	s0,0(sp)
    80201ca2:	0800                	addi	s0,sp,16
    80201ca4:	870e                	mv	a4,gp
    80201ca6:	0000d797          	auipc	a5,0xd
    80201caa:	3da78793          	addi	a5,a5,986 # 8020f080 <kernel_gp_value>
    80201cae:	e398                	sd	a4,0(a5)
    80201cb0:	ffffe797          	auipc	a5,0xffffe
    80201cb4:	3a878793          	addi	a5,a5,936 # 80200058 <trap_vector>
    80201cb8:	853e                	mv	a0,a5
    80201cba:	d79ff0ef          	jal	80201a32 <trap_vec_init>
    80201cbe:	0000e797          	auipc	a5,0xe
    80201cc2:	8f278793          	addi	a5,a5,-1806 # 8020f5b0 <kernel_trap_cxt>
    80201cc6:	853e                	mv	a0,a5
    80201cc8:	d89ff0ef          	jal	80201a50 <trap_scratch_init>
    80201ccc:	0001                	nop
    80201cce:	60a2                	ld	ra,8(sp)
    80201cd0:	6402                	ld	s0,0(sp)
    80201cd2:	0141                	addi	sp,sp,16
    80201cd4:	8082                	ret

0000000080201cd6 <trap_use_kernel_cxt>:
    80201cd6:	1141                	addi	sp,sp,-16
    80201cd8:	e406                	sd	ra,8(sp)
    80201cda:	e022                	sd	s0,0(sp)
    80201cdc:	0800                	addi	s0,sp,16
    80201cde:	0000e797          	auipc	a5,0xe
    80201ce2:	8d278793          	addi	a5,a5,-1838 # 8020f5b0 <kernel_trap_cxt>
    80201ce6:	853e                	mv	a0,a5
    80201ce8:	d69ff0ef          	jal	80201a50 <trap_scratch_init>
    80201cec:	0001                	nop
    80201cee:	60a2                	ld	ra,8(sp)
    80201cf0:	6402                	ld	s0,0(sp)
    80201cf2:	0141                	addi	sp,sp,16
    80201cf4:	8082                	ret

0000000080201cf6 <external_interrupt_handler>:
    80201cf6:	1101                	addi	sp,sp,-32
    80201cf8:	ec06                	sd	ra,24(sp)
    80201cfa:	e822                	sd	s0,16(sp)
    80201cfc:	1000                	addi	s0,sp,32
    80201cfe:	123000ef          	jal	80202620 <plic_claim>
    80201d02:	87aa                	mv	a5,a0
    80201d04:	fef42623          	sw	a5,-20(s0)
    80201d08:	bf3ff0ef          	jal	802018fa <stats_inc_ext_irq>
    80201d0c:	fec42783          	lw	a5,-20(s0)
    80201d10:	0007871b          	sext.w	a4,a5
    80201d14:	47a9                	li	a5,10
    80201d16:	00f71563          	bne	a4,a5,80201d20 <external_interrupt_handler+0x2a>
    80201d1a:	84cff0ef          	jal	80200d66 <uart_isr>
    80201d1e:	a831                	j	80201d3a <external_interrupt_handler+0x44>
    80201d20:	fec42783          	lw	a5,-20(s0)
    80201d24:	2781                	sext.w	a5,a5
    80201d26:	cb91                	beqz	a5,80201d3a <external_interrupt_handler+0x44>
    80201d28:	fec42783          	lw	a5,-20(s0)
    80201d2c:	85be                	mv	a1,a5
    80201d2e:	00005517          	auipc	a0,0x5
    80201d32:	7f250513          	addi	a0,a0,2034 # 80207520 <user_code_end+0x6b0>
    80201d36:	f00ff0ef          	jal	80201436 <printf>
    80201d3a:	fec42783          	lw	a5,-20(s0)
    80201d3e:	2781                	sext.w	a5,a5
    80201d40:	c791                	beqz	a5,80201d4c <external_interrupt_handler+0x56>
    80201d42:	fec42783          	lw	a5,-20(s0)
    80201d46:	853e                	mv	a0,a5
    80201d48:	115000ef          	jal	8020265c <plic_complete>
    80201d4c:	0001                	nop
    80201d4e:	60e2                	ld	ra,24(sp)
    80201d50:	6442                	ld	s0,16(sp)
    80201d52:	6105                	addi	sp,sp,32
    80201d54:	8082                	ret

0000000080201d56 <trap_handler>:
    80201d56:	715d                	addi	sp,sp,-80
    80201d58:	e486                	sd	ra,72(sp)
    80201d5a:	e0a2                	sd	s0,64(sp)
    80201d5c:	0880                	addi	s0,sp,80
    80201d5e:	fca43423          	sd	a0,-56(s0)
    80201d62:	fcb43023          	sd	a1,-64(s0)
    80201d66:	fac43c23          	sd	a2,-72(s0)
    80201d6a:	fc843783          	ld	a5,-56(s0)
    80201d6e:	fcf43c23          	sd	a5,-40(s0)
    80201d72:	fc043703          	ld	a4,-64(s0)
    80201d76:	57fd                	li	a5,-1
    80201d78:	8385                	srli	a5,a5,0x1
    80201d7a:	8ff9                	and	a5,a5,a4
    80201d7c:	fef43423          	sd	a5,-24(s0)
    80201d80:	0000d797          	auipc	a5,0xd
    80201d84:	30078793          	addi	a5,a5,768 # 8020f080 <kernel_gp_value>
    80201d88:	639c                	ld	a5,0(a5)
    80201d8a:	81be                	mv	gp,a5
    80201d8c:	bf3ff0ef          	jal	8020197e <r_sstatus>
    80201d90:	87aa                	mv	a5,a0
    80201d92:	8b89                	andi	a5,a5,2
    80201d94:	fef43023          	sd	a5,-32(s0)
    80201d98:	cd7ff0ef          	jal	80201a6e <cpu_irq_disable>
    80201d9c:	fb843603          	ld	a2,-72(s0)
    80201da0:	fc043583          	ld	a1,-64(s0)
    80201da4:	fc843503          	ld	a0,-56(s0)
    80201da8:	2ae000ef          	jal	80202056 <trap_diag_trap_enter>
    80201dac:	fc043783          	ld	a5,-64(s0)
    80201db0:	0607d163          	bgez	a5,80201e12 <trap_handler+0xbc>
    80201db4:	fe843703          	ld	a4,-24(s0)
    80201db8:	47a5                	li	a5,9
    80201dba:	02f70f63          	beq	a4,a5,80201df8 <trap_handler+0xa2>
    80201dbe:	fe843703          	ld	a4,-24(s0)
    80201dc2:	47a5                	li	a5,9
    80201dc4:	02e7ed63          	bltu	a5,a4,80201dfe <trap_handler+0xa8>
    80201dc8:	fe843703          	ld	a4,-24(s0)
    80201dcc:	4785                	li	a5,1
    80201dce:	00f70863          	beq	a4,a5,80201dde <trap_handler+0x88>
    80201dd2:	fe843703          	ld	a4,-24(s0)
    80201dd6:	4795                	li	a5,5
    80201dd8:	00f70d63          	beq	a4,a5,80201df2 <trap_handler+0x9c>
    80201ddc:	a00d                	j	80201dfe <trap_handler+0xa8>
    80201dde:	af1ff0ef          	jal	802018ce <stats_inc_sw_irq>
    80201de2:	c15ff0ef          	jal	802019f6 <r_sip>
    80201de6:	87aa                	mv	a5,a0
    80201de8:	9bf5                	andi	a5,a5,-3
    80201dea:	853e                	mv	a0,a5
    80201dec:	c29ff0ef          	jal	80201a14 <w_sip>
    80201df0:	a825                	j	80201e28 <trap_handler+0xd2>
    80201df2:	6e0000ef          	jal	802024d2 <timer_handler>
    80201df6:	a80d                	j	80201e28 <trap_handler+0xd2>
    80201df8:	effff0ef          	jal	80201cf6 <external_interrupt_handler>
    80201dfc:	a035                	j	80201e28 <trap_handler+0xd2>
    80201dfe:	fe843783          	ld	a5,-24(s0)
    80201e02:	85be                	mv	a1,a5
    80201e04:	00005517          	auipc	a0,0x5
    80201e08:	73c50513          	addi	a0,a0,1852 # 80207540 <user_code_end+0x6d0>
    80201e0c:	e2aff0ef          	jal	80201436 <printf>
    80201e10:	a821                	j	80201e28 <trap_handler+0xd2>
    80201e12:	fd840793          	addi	a5,s0,-40
    80201e16:	86be                	mv	a3,a5
    80201e18:	fb843603          	ld	a2,-72(s0)
    80201e1c:	fc843583          	ld	a1,-56(s0)
    80201e20:	fe843503          	ld	a0,-24(s0)
    80201e24:	c8dff0ef          	jal	80201ab0 <handle_sync_exception>
    80201e28:	fe043783          	ld	a5,-32(s0)
    80201e2c:	c399                	beqz	a5,80201e32 <trap_handler+0xdc>
    80201e2e:	c61ff0ef          	jal	80201a8e <cpu_irq_enable>
    80201e32:	fd843783          	ld	a5,-40(s0)
    80201e36:	853e                	mv	a0,a5
    80201e38:	2ea000ef          	jal	80202122 <trap_diag_post_handler>
    80201e3c:	fd843783          	ld	a5,-40(s0)
    80201e40:	853e                	mv	a0,a5
    80201e42:	60a6                	ld	ra,72(sp)
    80201e44:	6406                	ld	s0,64(sp)
    80201e46:	6161                	addi	sp,sp,80
    80201e48:	8082                	ret

0000000080201e4a <r_sstatus>:
    80201e4a:	1101                	addi	sp,sp,-32
    80201e4c:	ec06                	sd	ra,24(sp)
    80201e4e:	e822                	sd	s0,16(sp)
    80201e50:	1000                	addi	s0,sp,32
    80201e52:	100027f3          	csrr	a5,sstatus
    80201e56:	fef43423          	sd	a5,-24(s0)
    80201e5a:	fe843783          	ld	a5,-24(s0)
    80201e5e:	853e                	mv	a0,a5
    80201e60:	60e2                	ld	ra,24(sp)
    80201e62:	6442                	ld	s0,16(sp)
    80201e64:	6105                	addi	sp,sp,32
    80201e66:	8082                	ret

0000000080201e68 <r_sepc>:
    80201e68:	1101                	addi	sp,sp,-32
    80201e6a:	ec06                	sd	ra,24(sp)
    80201e6c:	e822                	sd	s0,16(sp)
    80201e6e:	1000                	addi	s0,sp,32
    80201e70:	141027f3          	csrr	a5,sepc
    80201e74:	fef43423          	sd	a5,-24(s0)
    80201e78:	fe843783          	ld	a5,-24(s0)
    80201e7c:	853e                	mv	a0,a5
    80201e7e:	60e2                	ld	ra,24(sp)
    80201e80:	6442                	ld	s0,16(sp)
    80201e82:	6105                	addi	sp,sp,32
    80201e84:	8082                	ret

0000000080201e86 <r_sscratch>:
    80201e86:	1101                	addi	sp,sp,-32
    80201e88:	ec06                	sd	ra,24(sp)
    80201e8a:	e822                	sd	s0,16(sp)
    80201e8c:	1000                	addi	s0,sp,32
    80201e8e:	140027f3          	csrr	a5,sscratch
    80201e92:	fef43423          	sd	a5,-24(s0)
    80201e96:	fe843783          	ld	a5,-24(s0)
    80201e9a:	853e                	mv	a0,a5
    80201e9c:	60e2                	ld	ra,24(sp)
    80201e9e:	6442                	ld	s0,16(sp)
    80201ea0:	6105                	addi	sp,sp,32
    80201ea2:	8082                	ret

0000000080201ea4 <r_stval>:
    80201ea4:	1101                	addi	sp,sp,-32
    80201ea6:	ec06                	sd	ra,24(sp)
    80201ea8:	e822                	sd	s0,16(sp)
    80201eaa:	1000                	addi	s0,sp,32
    80201eac:	143027f3          	csrr	a5,stval
    80201eb0:	fef43423          	sd	a5,-24(s0)
    80201eb4:	fe843783          	ld	a5,-24(s0)
    80201eb8:	853e                	mv	a0,a5
    80201eba:	60e2                	ld	ra,24(sp)
    80201ebc:	6442                	ld	s0,16(sp)
    80201ebe:	6105                	addi	sp,sp,32
    80201ec0:	8082                	ret

0000000080201ec2 <r_scause>:
    80201ec2:	1101                	addi	sp,sp,-32
    80201ec4:	ec06                	sd	ra,24(sp)
    80201ec6:	e822                	sd	s0,16(sp)
    80201ec8:	1000                	addi	s0,sp,32
    80201eca:	142027f3          	csrr	a5,scause
    80201ece:	fef43423          	sd	a5,-24(s0)
    80201ed2:	fe843783          	ld	a5,-24(s0)
    80201ed6:	853e                	mv	a0,a5
    80201ed8:	60e2                	ld	ra,24(sp)
    80201eda:	6442                	ld	s0,16(sp)
    80201edc:	6105                	addi	sp,sp,32
    80201ede:	8082                	ret

0000000080201ee0 <epc_in_user>:
    80201ee0:	1101                	addi	sp,sp,-32
    80201ee2:	ec06                	sd	ra,24(sp)
    80201ee4:	e822                	sd	s0,16(sp)
    80201ee6:	1000                	addi	s0,sp,32
    80201ee8:	fea43423          	sd	a0,-24(s0)
    80201eec:	fe843703          	ld	a4,-24(s0)
    80201ef0:	010077b7          	lui	a5,0x1007
    80201ef4:	079e                	slli	a5,a5,0x7
    80201ef6:	00f76b63          	bltu	a4,a5,80201f0c <epc_in_user+0x2c>
    80201efa:	fe843703          	ld	a4,-24(s0)
    80201efe:	20100793          	li	a5,513
    80201f02:	07da                	slli	a5,a5,0x16
    80201f04:	00f77463          	bgeu	a4,a5,80201f0c <epc_in_user+0x2c>
    80201f08:	4785                	li	a5,1
    80201f0a:	a011                	j	80201f0e <epc_in_user+0x2e>
    80201f0c:	4781                	li	a5,0
    80201f0e:	853e                	mv	a0,a5
    80201f10:	60e2                	ld	ra,24(sp)
    80201f12:	6442                	ld	s0,16(sp)
    80201f14:	6105                	addi	sp,sp,32
    80201f16:	8082                	ret

0000000080201f18 <frame_name>:
    80201f18:	7179                	addi	sp,sp,-48
    80201f1a:	f406                	sd	ra,40(sp)
    80201f1c:	f022                	sd	s0,32(sp)
    80201f1e:	1800                	addi	s0,sp,48
    80201f20:	fca43c23          	sd	a0,-40(s0)
    80201f24:	fd843783          	ld	a5,-40(s0)
    80201f28:	fef43423          	sd	a5,-24(s0)
    80201f2c:	00011797          	auipc	a5,0x11
    80201f30:	dac78793          	addi	a5,a5,-596 # 80212cd8 <user_cxt>
    80201f34:	fe843703          	ld	a4,-24(s0)
    80201f38:	00f71763          	bne	a4,a5,80201f46 <frame_name+0x2e>
    80201f3c:	00005797          	auipc	a5,0x5
    80201f40:	62478793          	addi	a5,a5,1572 # 80207560 <user_code_end+0x6f0>
    80201f44:	a83d                	j	80201f82 <frame_name+0x6a>
    80201f46:	0000d797          	auipc	a5,0xd
    80201f4a:	66a78793          	addi	a5,a5,1642 # 8020f5b0 <kernel_trap_cxt>
    80201f4e:	fe843703          	ld	a4,-24(s0)
    80201f52:	00f71763          	bne	a4,a5,80201f60 <frame_name+0x48>
    80201f56:	00005797          	auipc	a5,0x5
    80201f5a:	61a78793          	addi	a5,a5,1562 # 80207570 <user_code_end+0x700>
    80201f5e:	a015                	j	80201f82 <frame_name+0x6a>
    80201f60:	00011797          	auipc	a5,0x11
    80201f64:	e7878793          	addi	a5,a5,-392 # 80212dd8 <shell_save_cxt>
    80201f68:	fe843703          	ld	a4,-24(s0)
    80201f6c:	00f71763          	bne	a4,a5,80201f7a <frame_name+0x62>
    80201f70:	00005797          	auipc	a5,0x5
    80201f74:	61078793          	addi	a5,a5,1552 # 80207580 <user_code_end+0x710>
    80201f78:	a029                	j	80201f82 <frame_name+0x6a>
    80201f7a:	00005797          	auipc	a5,0x5
    80201f7e:	61678793          	addi	a5,a5,1558 # 80207590 <user_code_end+0x720>
    80201f82:	853e                	mv	a0,a5
    80201f84:	70a2                	ld	ra,40(sp)
    80201f86:	7402                	ld	s0,32(sp)
    80201f88:	6145                	addi	sp,sp,48
    80201f8a:	8082                	ret

0000000080201f8c <trap_diag_interesting>:
    80201f8c:	7179                	addi	sp,sp,-48
    80201f8e:	f406                	sd	ra,40(sp)
    80201f90:	f022                	sd	s0,32(sp)
    80201f92:	1800                	addi	s0,sp,48
    80201f94:	fea43423          	sd	a0,-24(s0)
    80201f98:	feb43023          	sd	a1,-32(s0)
    80201f9c:	fcc43c23          	sd	a2,-40(s0)
    80201fa0:	fe043783          	ld	a5,-32(s0)
    80201fa4:	0007c463          	bltz	a5,80201fac <trap_diag_interesting+0x20>
    80201fa8:	4785                	li	a5,1
    80201faa:	a091                	j	80201fee <trap_diag_interesting+0x62>
    80201fac:	fe843503          	ld	a0,-24(s0)
    80201fb0:	f31ff0ef          	jal	80201ee0 <epc_in_user>
    80201fb4:	87aa                	mv	a5,a0
    80201fb6:	c399                	beqz	a5,80201fbc <trap_diag_interesting+0x30>
    80201fb8:	4785                	li	a5,1
    80201fba:	a815                	j	80201fee <trap_diag_interesting+0x62>
    80201fbc:	fd843703          	ld	a4,-40(s0)
    80201fc0:	00011797          	auipc	a5,0x11
    80201fc4:	d1878793          	addi	a5,a5,-744 # 80212cd8 <user_cxt>
    80201fc8:	00f71463          	bne	a4,a5,80201fd0 <trap_diag_interesting+0x44>
    80201fcc:	4785                	li	a5,1
    80201fce:	a005                	j	80201fee <trap_diag_interesting+0x62>
    80201fd0:	0000d797          	auipc	a5,0xd
    80201fd4:	0c078793          	addi	a5,a5,192 # 8020f090 <prog_exec_active>
    80201fd8:	439c                	lw	a5,0(a5)
    80201fda:	e799                	bnez	a5,80201fe8 <trap_diag_interesting+0x5c>
    80201fdc:	0000d797          	auipc	a5,0xd
    80201fe0:	0b878793          	addi	a5,a5,184 # 8020f094 <prog_exec_restore_shell>
    80201fe4:	439c                	lw	a5,0(a5)
    80201fe6:	c399                	beqz	a5,80201fec <trap_diag_interesting+0x60>
    80201fe8:	4785                	li	a5,1
    80201fea:	a011                	j	80201fee <trap_diag_interesting+0x62>
    80201fec:	4781                	li	a5,0
    80201fee:	853e                	mv	a0,a5
    80201ff0:	70a2                	ld	ra,40(sp)
    80201ff2:	7402                	ld	s0,32(sp)
    80201ff4:	6145                	addi	sp,sp,48
    80201ff6:	8082                	ret

0000000080201ff8 <trap_diag_print_csrs>:
    80201ff8:	7139                	addi	sp,sp,-64
    80201ffa:	fc06                	sd	ra,56(sp)
    80201ffc:	f822                	sd	s0,48(sp)
    80201ffe:	f426                	sd	s1,40(sp)
    80202000:	f04a                	sd	s2,32(sp)
    80202002:	ec4e                	sd	s3,24(sp)
    80202004:	e852                	sd	s4,16(sp)
    80202006:	0080                	addi	s0,sp,64
    80202008:	fca43423          	sd	a0,-56(s0)
    8020200c:	eb7ff0ef          	jal	80201ec2 <r_scause>
    80202010:	84aa                	mv	s1,a0
    80202012:	e93ff0ef          	jal	80201ea4 <r_stval>
    80202016:	892a                	mv	s2,a0
    80202018:	e51ff0ef          	jal	80201e68 <r_sepc>
    8020201c:	89aa                	mv	s3,a0
    8020201e:	e2dff0ef          	jal	80201e4a <r_sstatus>
    80202022:	8a2a                	mv	s4,a0
    80202024:	e63ff0ef          	jal	80201e86 <r_sscratch>
    80202028:	87aa                	mv	a5,a0
    8020202a:	883e                	mv	a6,a5
    8020202c:	87d2                	mv	a5,s4
    8020202e:	874e                	mv	a4,s3
    80202030:	86ca                	mv	a3,s2
    80202032:	8626                	mv	a2,s1
    80202034:	fc843583          	ld	a1,-56(s0)
    80202038:	00005517          	auipc	a0,0x5
    8020203c:	56050513          	addi	a0,a0,1376 # 80207598 <user_code_end+0x728>
    80202040:	bf6ff0ef          	jal	80201436 <printf>
    80202044:	0001                	nop
    80202046:	70e2                	ld	ra,56(sp)
    80202048:	7442                	ld	s0,48(sp)
    8020204a:	74a2                	ld	s1,40(sp)
    8020204c:	7902                	ld	s2,32(sp)
    8020204e:	69e2                	ld	s3,24(sp)
    80202050:	6a42                	ld	s4,16(sp)
    80202052:	6121                	addi	sp,sp,64
    80202054:	8082                	ret

0000000080202056 <trap_diag_trap_enter>:
    80202056:	711d                	addi	sp,sp,-96
    80202058:	ec86                	sd	ra,88(sp)
    8020205a:	e8a2                	sd	s0,80(sp)
    8020205c:	e4a6                	sd	s1,72(sp)
    8020205e:	e0ca                	sd	s2,64(sp)
    80202060:	1080                	addi	s0,sp,96
    80202062:	fca43423          	sd	a0,-56(s0)
    80202066:	fcb43023          	sd	a1,-64(s0)
    8020206a:	fac43c23          	sd	a2,-72(s0)
    8020206e:	fb843603          	ld	a2,-72(s0)
    80202072:	fc043583          	ld	a1,-64(s0)
    80202076:	fc843503          	ld	a0,-56(s0)
    8020207a:	f13ff0ef          	jal	80201f8c <trap_diag_interesting>
    8020207e:	87aa                	mv	a5,a0
    80202080:	cbd1                	beqz	a5,80202114 <trap_diag_trap_enter+0xbe>
    80202082:	fc043783          	ld	a5,-64(s0)
    80202086:	0007d963          	bgez	a5,80202098 <trap_diag_trap_enter+0x42>
    8020208a:	00005797          	auipc	a5,0x5
    8020208e:	56678793          	addi	a5,a5,1382 # 802075f0 <user_code_end+0x780>
    80202092:	fcf43c23          	sd	a5,-40(s0)
    80202096:	a039                	j	802020a4 <trap_diag_trap_enter+0x4e>
    80202098:	00005797          	auipc	a5,0x5
    8020209c:	56078793          	addi	a5,a5,1376 # 802075f8 <user_code_end+0x788>
    802020a0:	fcf43c23          	sd	a5,-40(s0)
    802020a4:	de3ff0ef          	jal	80201e86 <r_sscratch>
    802020a8:	fca43823          	sd	a0,-48(s0)
    802020ac:	fc043703          	ld	a4,-64(s0)
    802020b0:	57fd                	li	a5,-1
    802020b2:	8385                	srli	a5,a5,0x1
    802020b4:	00f774b3          	and	s1,a4,a5
    802020b8:	fb843503          	ld	a0,-72(s0)
    802020bc:	e5dff0ef          	jal	80201f18 <frame_name>
    802020c0:	892a                	mv	s2,a0
    802020c2:	fc843503          	ld	a0,-56(s0)
    802020c6:	e1bff0ef          	jal	80201ee0 <epc_in_user>
    802020ca:	87aa                	mv	a5,a0
    802020cc:	00f037b3          	snez	a5,a5
    802020d0:	0ff7f793          	zext.b	a5,a5
    802020d4:	0007869b          	sext.w	a3,a5
    802020d8:	0000d797          	auipc	a5,0xd
    802020dc:	fb878793          	addi	a5,a5,-72 # 8020f090 <prog_exec_active>
    802020e0:	439c                	lw	a5,0(a5)
    802020e2:	0000d717          	auipc	a4,0xd
    802020e6:	fa670713          	addi	a4,a4,-90 # 8020f088 <trap_diag_shell_restore_count>
    802020ea:	6318                	ld	a4,0(a4)
    802020ec:	e43a                	sd	a4,8(sp)
    802020ee:	e03e                	sd	a5,0(sp)
    802020f0:	fd043883          	ld	a7,-48(s0)
    802020f4:	8836                	mv	a6,a3
    802020f6:	87ca                	mv	a5,s2
    802020f8:	8726                	mv	a4,s1
    802020fa:	fc043683          	ld	a3,-64(s0)
    802020fe:	fc843603          	ld	a2,-56(s0)
    80202102:	fd843583          	ld	a1,-40(s0)
    80202106:	00005517          	auipc	a0,0x5
    8020210a:	4fa50513          	addi	a0,a0,1274 # 80207600 <user_code_end+0x790>
    8020210e:	b28ff0ef          	jal	80201436 <printf>
    80202112:	a011                	j	80202116 <trap_diag_trap_enter+0xc0>
    80202114:	0001                	nop
    80202116:	60e6                	ld	ra,88(sp)
    80202118:	6446                	ld	s0,80(sp)
    8020211a:	64a6                	ld	s1,72(sp)
    8020211c:	6906                	ld	s2,64(sp)
    8020211e:	6125                	addi	sp,sp,96
    80202120:	8082                	ret

0000000080202122 <trap_diag_post_handler>:
    80202122:	7139                	addi	sp,sp,-64
    80202124:	fc06                	sd	ra,56(sp)
    80202126:	f822                	sd	s0,48(sp)
    80202128:	f426                	sd	s1,40(sp)
    8020212a:	f04a                	sd	s2,32(sp)
    8020212c:	0080                	addi	s0,sp,64
    8020212e:	fca43423          	sd	a0,-56(s0)
    80202132:	0000d797          	auipc	a5,0xd
    80202136:	f6278793          	addi	a5,a5,-158 # 8020f094 <prog_exec_restore_shell>
    8020213a:	439c                	lw	a5,0(a5)
    8020213c:	fcf42e23          	sw	a5,-36(s0)
    80202140:	fdc42783          	lw	a5,-36(s0)
    80202144:	2781                	sext.w	a5,a5
    80202146:	ef89                	bnez	a5,80202160 <trap_diag_post_handler+0x3e>
    80202148:	0000d797          	auipc	a5,0xd
    8020214c:	f4878793          	addi	a5,a5,-184 # 8020f090 <prog_exec_active>
    80202150:	439c                	lw	a5,0(a5)
    80202152:	e799                	bnez	a5,80202160 <trap_diag_post_handler+0x3e>
    80202154:	fc843503          	ld	a0,-56(s0)
    80202158:	d89ff0ef          	jal	80201ee0 <epc_in_user>
    8020215c:	87aa                	mv	a5,a0
    8020215e:	cb8d                	beqz	a5,80202190 <trap_diag_post_handler+0x6e>
    80202160:	0000d797          	auipc	a5,0xd
    80202164:	f2878793          	addi	a5,a5,-216 # 8020f088 <trap_diag_shell_restore_count>
    80202168:	6384                	ld	s1,0(a5)
    8020216a:	d1dff0ef          	jal	80201e86 <r_sscratch>
    8020216e:	892a                	mv	s2,a0
    80202170:	cdbff0ef          	jal	80201e4a <r_sstatus>
    80202174:	87aa                	mv	a5,a0
    80202176:	fdc42603          	lw	a2,-36(s0)
    8020217a:	874a                	mv	a4,s2
    8020217c:	86a6                	mv	a3,s1
    8020217e:	fc843583          	ld	a1,-56(s0)
    80202182:	00005517          	auipc	a0,0x5
    80202186:	4fe50513          	addi	a0,a0,1278 # 80207680 <user_code_end+0x810>
    8020218a:	aacff0ef          	jal	80201436 <printf>
    8020218e:	a011                	j	80202192 <trap_diag_post_handler+0x70>
    80202190:	0001                	nop
    80202192:	70e2                	ld	ra,56(sp)
    80202194:	7442                	ld	s0,48(sp)
    80202196:	74a2                	ld	s1,40(sp)
    80202198:	7902                	ld	s2,32(sp)
    8020219a:	6121                	addi	sp,sp,64
    8020219c:	8082                	ret

000000008020219e <trap_diag_shell_restore_branch>:
    8020219e:	1141                	addi	sp,sp,-16
    802021a0:	e406                	sd	ra,8(sp)
    802021a2:	e022                	sd	s0,0(sp)
    802021a4:	0800                	addi	s0,sp,16
    802021a6:	0000d797          	auipc	a5,0xd
    802021aa:	ee278793          	addi	a5,a5,-286 # 8020f088 <trap_diag_shell_restore_count>
    802021ae:	639c                	ld	a5,0(a5)
    802021b0:	00178713          	addi	a4,a5,1
    802021b4:	0000d797          	auipc	a5,0xd
    802021b8:	ed478793          	addi	a5,a5,-300 # 8020f088 <trap_diag_shell_restore_count>
    802021bc:	e398                	sd	a4,0(a5)
    802021be:	0000d797          	auipc	a5,0xd
    802021c2:	eca78793          	addi	a5,a5,-310 # 8020f088 <trap_diag_shell_restore_count>
    802021c6:	639c                	ld	a5,0(a5)
    802021c8:	85be                	mv	a1,a5
    802021ca:	00005517          	auipc	a0,0x5
    802021ce:	53650513          	addi	a0,a0,1334 # 80207700 <user_code_end+0x890>
    802021d2:	a64ff0ef          	jal	80201436 <printf>
    802021d6:	00005517          	auipc	a0,0x5
    802021da:	57250513          	addi	a0,a0,1394 # 80207748 <user_code_end+0x8d8>
    802021de:	e1bff0ef          	jal	80201ff8 <trap_diag_print_csrs>
    802021e2:	0001                	nop
    802021e4:	60a2                	ld	ra,8(sp)
    802021e6:	6402                	ld	s0,0(sp)
    802021e8:	0141                	addi	sp,sp,16
    802021ea:	8082                	ret

00000000802021ec <r_sie>:
    802021ec:	1101                	addi	sp,sp,-32
    802021ee:	ec06                	sd	ra,24(sp)
    802021f0:	e822                	sd	s0,16(sp)
    802021f2:	1000                	addi	s0,sp,32
    802021f4:	104027f3          	csrr	a5,sie
    802021f8:	fef43423          	sd	a5,-24(s0)
    802021fc:	fe843783          	ld	a5,-24(s0)
    80202200:	853e                	mv	a0,a5
    80202202:	60e2                	ld	ra,24(sp)
    80202204:	6442                	ld	s0,16(sp)
    80202206:	6105                	addi	sp,sp,32
    80202208:	8082                	ret

000000008020220a <w_sie>:
    8020220a:	1101                	addi	sp,sp,-32
    8020220c:	ec06                	sd	ra,24(sp)
    8020220e:	e822                	sd	s0,16(sp)
    80202210:	1000                	addi	s0,sp,32
    80202212:	fea43423          	sd	a0,-24(s0)
    80202216:	fe843783          	ld	a5,-24(s0)
    8020221a:	10479073          	csrw	sie,a5
    8020221e:	0001                	nop
    80202220:	60e2                	ld	ra,24(sp)
    80202222:	6442                	ld	s0,16(sp)
    80202224:	6105                	addi	sp,sp,32
    80202226:	8082                	ret

0000000080202228 <trap_ie_enable>:
    80202228:	1101                	addi	sp,sp,-32
    8020222a:	ec06                	sd	ra,24(sp)
    8020222c:	e822                	sd	s0,16(sp)
    8020222e:	1000                	addi	s0,sp,32
    80202230:	fea43423          	sd	a0,-24(s0)
    80202234:	fb9ff0ef          	jal	802021ec <r_sie>
    80202238:	872a                	mv	a4,a0
    8020223a:	fe843783          	ld	a5,-24(s0)
    8020223e:	8fd9                	or	a5,a5,a4
    80202240:	853e                	mv	a0,a5
    80202242:	fc9ff0ef          	jal	8020220a <w_sie>
    80202246:	0001                	nop
    80202248:	60e2                	ld	ra,24(sp)
    8020224a:	6442                	ld	s0,16(sp)
    8020224c:	6105                	addi	sp,sp,32
    8020224e:	8082                	ret

0000000080202250 <r_time>:
    80202250:	1101                	addi	sp,sp,-32
    80202252:	ec06                	sd	ra,24(sp)
    80202254:	e822                	sd	s0,16(sp)
    80202256:	1000                	addi	s0,sp,32
    80202258:	c01027f3          	rdtime	a5
    8020225c:	fef43423          	sd	a5,-24(s0)
    80202260:	fe843783          	ld	a5,-24(s0)
    80202264:	853e                	mv	a0,a5
    80202266:	60e2                	ld	ra,24(sp)
    80202268:	6442                	ld	s0,16(sp)
    8020226a:	6105                	addi	sp,sp,32
    8020226c:	8082                	ret

000000008020226e <sbi_set_timer>:
    8020226e:	1101                	addi	sp,sp,-32
    80202270:	ec06                	sd	ra,24(sp)
    80202272:	e822                	sd	s0,16(sp)
    80202274:	1000                	addi	s0,sp,32
    80202276:	fea43423          	sd	a0,-24(s0)
    8020227a:	fe843503          	ld	a0,-24(s0)
    8020227e:	4881                	li	a7,0
    80202280:	00000073          	ecall
    80202284:	0001                	nop
    80202286:	60e2                	ld	ra,24(sp)
    80202288:	6442                	ld	s0,16(sp)
    8020228a:	6105                	addi	sp,sp,32
    8020228c:	8082                	ret

000000008020228e <timer_load>:
    8020228e:	1101                	addi	sp,sp,-32
    80202290:	ec06                	sd	ra,24(sp)
    80202292:	e822                	sd	s0,16(sp)
    80202294:	1000                	addi	s0,sp,32
    80202296:	87aa                	mv	a5,a0
    80202298:	fef42623          	sw	a5,-20(s0)
    8020229c:	fb5ff0ef          	jal	80202250 <r_time>
    802022a0:	872a                	mv	a4,a0
    802022a2:	fec42783          	lw	a5,-20(s0)
    802022a6:	97ba                	add	a5,a5,a4
    802022a8:	853e                	mv	a0,a5
    802022aa:	fc5ff0ef          	jal	8020226e <sbi_set_timer>
    802022ae:	0001                	nop
    802022b0:	60e2                	ld	ra,24(sp)
    802022b2:	6442                	ld	s0,16(sp)
    802022b4:	6105                	addi	sp,sp,32
    802022b6:	8082                	ret

00000000802022b8 <timer_init>:
    802022b8:	1101                	addi	sp,sp,-32
    802022ba:	ec06                	sd	ra,24(sp)
    802022bc:	e822                	sd	s0,16(sp)
    802022be:	1000                	addi	s0,sp,32
    802022c0:	0000d797          	auipc	a5,0xd
    802022c4:	3f878793          	addi	a5,a5,1016 # 8020f6b8 <timer_list>
    802022c8:	fef43423          	sd	a5,-24(s0)
    802022cc:	fe042223          	sw	zero,-28(s0)
    802022d0:	a01d                	j	802022f6 <timer_init+0x3e>
    802022d2:	fe843783          	ld	a5,-24(s0)
    802022d6:	0007b023          	sd	zero,0(a5)
    802022da:	fe843783          	ld	a5,-24(s0)
    802022de:	0007b423          	sd	zero,8(a5)
    802022e2:	fe843783          	ld	a5,-24(s0)
    802022e6:	07e1                	addi	a5,a5,24
    802022e8:	fef43423          	sd	a5,-24(s0)
    802022ec:	fe442783          	lw	a5,-28(s0)
    802022f0:	2785                	addiw	a5,a5,1
    802022f2:	fef42223          	sw	a5,-28(s0)
    802022f6:	fe442783          	lw	a5,-28(s0)
    802022fa:	0007871b          	sext.w	a4,a5
    802022fe:	47a5                	li	a5,9
    80202300:	fce7d9e3          	bge	a5,a4,802022d2 <timer_init+0x1a>
    80202304:	67e1                	lui	a5,0x18
    80202306:	6a078513          	addi	a0,a5,1696 # 186a0 <STACK_SIZE+0x176a0>
    8020230a:	f85ff0ef          	jal	8020228e <timer_load>
    8020230e:	02000513          	li	a0,32
    80202312:	f17ff0ef          	jal	80202228 <trap_ie_enable>
    80202316:	0001                	nop
    80202318:	60e2                	ld	ra,24(sp)
    8020231a:	6442                	ld	s0,16(sp)
    8020231c:	6105                	addi	sp,sp,32
    8020231e:	8082                	ret

0000000080202320 <timer_create>:
    80202320:	7139                	addi	sp,sp,-64
    80202322:	fc06                	sd	ra,56(sp)
    80202324:	f822                	sd	s0,48(sp)
    80202326:	0080                	addi	s0,sp,64
    80202328:	fca43c23          	sd	a0,-40(s0)
    8020232c:	fcb43823          	sd	a1,-48(s0)
    80202330:	87b2                	mv	a5,a2
    80202332:	fcf42623          	sw	a5,-52(s0)
    80202336:	fd843783          	ld	a5,-40(s0)
    8020233a:	c789                	beqz	a5,80202344 <timer_create+0x24>
    8020233c:	fcc42783          	lw	a5,-52(s0)
    80202340:	2781                	sext.w	a5,a5
    80202342:	e399                	bnez	a5,80202348 <timer_create+0x28>
    80202344:	4781                	li	a5,0
    80202346:	a071                	j	802023d2 <timer_create+0xb2>
    80202348:	35f000ef          	jal	80202ea6 <spin_lock>
    8020234c:	0000d797          	auipc	a5,0xd
    80202350:	36c78793          	addi	a5,a5,876 # 8020f6b8 <timer_list>
    80202354:	fef43423          	sd	a5,-24(s0)
    80202358:	fe042223          	sw	zero,-28(s0)
    8020235c:	a839                	j	8020237a <timer_create+0x5a>
    8020235e:	fe843783          	ld	a5,-24(s0)
    80202362:	639c                	ld	a5,0(a5)
    80202364:	c39d                	beqz	a5,8020238a <timer_create+0x6a>
    80202366:	fe843783          	ld	a5,-24(s0)
    8020236a:	07e1                	addi	a5,a5,24
    8020236c:	fef43423          	sd	a5,-24(s0)
    80202370:	fe442783          	lw	a5,-28(s0)
    80202374:	2785                	addiw	a5,a5,1
    80202376:	fef42223          	sw	a5,-28(s0)
    8020237a:	fe442783          	lw	a5,-28(s0)
    8020237e:	0007871b          	sext.w	a4,a5
    80202382:	47a5                	li	a5,9
    80202384:	fce7dde3          	bge	a5,a4,8020235e <timer_create+0x3e>
    80202388:	a011                	j	8020238c <timer_create+0x6c>
    8020238a:	0001                	nop
    8020238c:	fe843783          	ld	a5,-24(s0)
    80202390:	639c                	ld	a5,0(a5)
    80202392:	c789                	beqz	a5,8020239c <timer_create+0x7c>
    80202394:	32b000ef          	jal	80202ebe <spin_unlock>
    80202398:	4781                	li	a5,0
    8020239a:	a825                	j	802023d2 <timer_create+0xb2>
    8020239c:	fe843783          	ld	a5,-24(s0)
    802023a0:	fd843703          	ld	a4,-40(s0)
    802023a4:	e398                	sd	a4,0(a5)
    802023a6:	fe843783          	ld	a5,-24(s0)
    802023aa:	fd043703          	ld	a4,-48(s0)
    802023ae:	e798                	sd	a4,8(a5)
    802023b0:	0000d797          	auipc	a5,0xd
    802023b4:	30078793          	addi	a5,a5,768 # 8020f6b0 <_tick>
    802023b8:	439c                	lw	a5,0(a5)
    802023ba:	fcc42703          	lw	a4,-52(s0)
    802023be:	9fb9                	addw	a5,a5,a4
    802023c0:	0007871b          	sext.w	a4,a5
    802023c4:	fe843783          	ld	a5,-24(s0)
    802023c8:	cb98                	sw	a4,16(a5)
    802023ca:	2f5000ef          	jal	80202ebe <spin_unlock>
    802023ce:	fe843783          	ld	a5,-24(s0)
    802023d2:	853e                	mv	a0,a5
    802023d4:	70e2                	ld	ra,56(sp)
    802023d6:	7442                	ld	s0,48(sp)
    802023d8:	6121                	addi	sp,sp,64
    802023da:	8082                	ret

00000000802023dc <timer_delete>:
    802023dc:	7179                	addi	sp,sp,-48
    802023de:	f406                	sd	ra,40(sp)
    802023e0:	f022                	sd	s0,32(sp)
    802023e2:	1800                	addi	s0,sp,48
    802023e4:	fca43c23          	sd	a0,-40(s0)
    802023e8:	2bf000ef          	jal	80202ea6 <spin_lock>
    802023ec:	0000d797          	auipc	a5,0xd
    802023f0:	2cc78793          	addi	a5,a5,716 # 8020f6b8 <timer_list>
    802023f4:	fef43423          	sd	a5,-24(s0)
    802023f8:	fe042223          	sw	zero,-28(s0)
    802023fc:	a815                	j	80202430 <timer_delete+0x54>
    802023fe:	fe843703          	ld	a4,-24(s0)
    80202402:	fd843783          	ld	a5,-40(s0)
    80202406:	00f71b63          	bne	a4,a5,8020241c <timer_delete+0x40>
    8020240a:	fe843783          	ld	a5,-24(s0)
    8020240e:	0007b023          	sd	zero,0(a5)
    80202412:	fe843783          	ld	a5,-24(s0)
    80202416:	0007b423          	sd	zero,8(a5)
    8020241a:	a015                	j	8020243e <timer_delete+0x62>
    8020241c:	fe843783          	ld	a5,-24(s0)
    80202420:	07e1                	addi	a5,a5,24
    80202422:	fef43423          	sd	a5,-24(s0)
    80202426:	fe442783          	lw	a5,-28(s0)
    8020242a:	2785                	addiw	a5,a5,1
    8020242c:	fef42223          	sw	a5,-28(s0)
    80202430:	fe442783          	lw	a5,-28(s0)
    80202434:	0007871b          	sext.w	a4,a5
    80202438:	47a5                	li	a5,9
    8020243a:	fce7d2e3          	bge	a5,a4,802023fe <timer_delete+0x22>
    8020243e:	281000ef          	jal	80202ebe <spin_unlock>
    80202442:	0001                	nop
    80202444:	70a2                	ld	ra,40(sp)
    80202446:	7402                	ld	s0,32(sp)
    80202448:	6145                	addi	sp,sp,48
    8020244a:	8082                	ret

000000008020244c <timer_check>:
    8020244c:	1101                	addi	sp,sp,-32
    8020244e:	ec06                	sd	ra,24(sp)
    80202450:	e822                	sd	s0,16(sp)
    80202452:	1000                	addi	s0,sp,32
    80202454:	0000d797          	auipc	a5,0xd
    80202458:	26478793          	addi	a5,a5,612 # 8020f6b8 <timer_list>
    8020245c:	fef43423          	sd	a5,-24(s0)
    80202460:	fe042223          	sw	zero,-28(s0)
    80202464:	a891                	j	802024b8 <timer_check+0x6c>
    80202466:	fe843783          	ld	a5,-24(s0)
    8020246a:	639c                	ld	a5,0(a5)
    8020246c:	cf85                	beqz	a5,802024a4 <timer_check+0x58>
    8020246e:	fe843783          	ld	a5,-24(s0)
    80202472:	4b98                	lw	a4,16(a5)
    80202474:	0000d797          	auipc	a5,0xd
    80202478:	23c78793          	addi	a5,a5,572 # 8020f6b0 <_tick>
    8020247c:	439c                	lw	a5,0(a5)
    8020247e:	02e7e363          	bltu	a5,a4,802024a4 <timer_check+0x58>
    80202482:	fe843783          	ld	a5,-24(s0)
    80202486:	639c                	ld	a5,0(a5)
    80202488:	fe843703          	ld	a4,-24(s0)
    8020248c:	6718                	ld	a4,8(a4)
    8020248e:	853a                	mv	a0,a4
    80202490:	9782                	jalr	a5
    80202492:	fe843783          	ld	a5,-24(s0)
    80202496:	0007b023          	sd	zero,0(a5)
    8020249a:	fe843783          	ld	a5,-24(s0)
    8020249e:	0007b423          	sd	zero,8(a5)
    802024a2:	a01d                	j	802024c8 <timer_check+0x7c>
    802024a4:	fe843783          	ld	a5,-24(s0)
    802024a8:	07e1                	addi	a5,a5,24
    802024aa:	fef43423          	sd	a5,-24(s0)
    802024ae:	fe442783          	lw	a5,-28(s0)
    802024b2:	2785                	addiw	a5,a5,1
    802024b4:	fef42223          	sw	a5,-28(s0)
    802024b8:	fe442783          	lw	a5,-28(s0)
    802024bc:	0007871b          	sext.w	a4,a5
    802024c0:	47a5                	li	a5,9
    802024c2:	fae7d2e3          	bge	a5,a4,80202466 <timer_check+0x1a>
    802024c6:	0001                	nop
    802024c8:	0001                	nop
    802024ca:	60e2                	ld	ra,24(sp)
    802024cc:	6442                	ld	s0,16(sp)
    802024ce:	6105                	addi	sp,sp,32
    802024d0:	8082                	ret

00000000802024d2 <timer_handler>:
    802024d2:	1141                	addi	sp,sp,-16
    802024d4:	e406                	sd	ra,8(sp)
    802024d6:	e022                	sd	s0,0(sp)
    802024d8:	0800                	addi	s0,sp,16
    802024da:	0000d797          	auipc	a5,0xd
    802024de:	1d678793          	addi	a5,a5,470 # 8020f6b0 <_tick>
    802024e2:	439c                	lw	a5,0(a5)
    802024e4:	2785                	addiw	a5,a5,1
    802024e6:	0007871b          	sext.w	a4,a5
    802024ea:	0000d797          	auipc	a5,0xd
    802024ee:	1c678793          	addi	a5,a5,454 # 8020f6b0 <_tick>
    802024f2:	c398                	sw	a4,0(a5)
    802024f4:	b82ff0ef          	jal	80201876 <stats_inc_timer>
    802024f8:	f55ff0ef          	jal	8020244c <timer_check>
    802024fc:	67e1                	lui	a5,0x18
    802024fe:	6a078513          	addi	a0,a5,1696 # 186a0 <STACK_SIZE+0x176a0>
    80202502:	d8dff0ef          	jal	8020228e <timer_load>
    80202506:	0001                	nop
    80202508:	60a2                	ld	ra,8(sp)
    8020250a:	6402                	ld	s0,0(sp)
    8020250c:	0141                	addi	sp,sp,16
    8020250e:	8082                	ret

0000000080202510 <r_tp>:
    80202510:	1101                	addi	sp,sp,-32
    80202512:	ec06                	sd	ra,24(sp)
    80202514:	e822                	sd	s0,16(sp)
    80202516:	1000                	addi	s0,sp,32
    80202518:	8792                	mv	a5,tp
    8020251a:	fef43423          	sd	a5,-24(s0)
    8020251e:	fe843783          	ld	a5,-24(s0)
    80202522:	853e                	mv	a0,a5
    80202524:	60e2                	ld	ra,24(sp)
    80202526:	6442                	ld	s0,16(sp)
    80202528:	6105                	addi	sp,sp,32
    8020252a:	8082                	ret

000000008020252c <r_sie>:
    8020252c:	1101                	addi	sp,sp,-32
    8020252e:	ec06                	sd	ra,24(sp)
    80202530:	e822                	sd	s0,16(sp)
    80202532:	1000                	addi	s0,sp,32
    80202534:	104027f3          	csrr	a5,sie
    80202538:	fef43423          	sd	a5,-24(s0)
    8020253c:	fe843783          	ld	a5,-24(s0)
    80202540:	853e                	mv	a0,a5
    80202542:	60e2                	ld	ra,24(sp)
    80202544:	6442                	ld	s0,16(sp)
    80202546:	6105                	addi	sp,sp,32
    80202548:	8082                	ret

000000008020254a <w_sie>:
    8020254a:	1101                	addi	sp,sp,-32
    8020254c:	ec06                	sd	ra,24(sp)
    8020254e:	e822                	sd	s0,16(sp)
    80202550:	1000                	addi	s0,sp,32
    80202552:	fea43423          	sd	a0,-24(s0)
    80202556:	fe843783          	ld	a5,-24(s0)
    8020255a:	10479073          	csrw	sie,a5
    8020255e:	0001                	nop
    80202560:	60e2                	ld	ra,24(sp)
    80202562:	6442                	ld	s0,16(sp)
    80202564:	6105                	addi	sp,sp,32
    80202566:	8082                	ret

0000000080202568 <trap_ie_enable>:
    80202568:	1101                	addi	sp,sp,-32
    8020256a:	ec06                	sd	ra,24(sp)
    8020256c:	e822                	sd	s0,16(sp)
    8020256e:	1000                	addi	s0,sp,32
    80202570:	fea43423          	sd	a0,-24(s0)
    80202574:	fb9ff0ef          	jal	8020252c <r_sie>
    80202578:	872a                	mv	a4,a0
    8020257a:	fe843783          	ld	a5,-24(s0)
    8020257e:	8fd9                	or	a5,a5,a4
    80202580:	853e                	mv	a0,a5
    80202582:	fc9ff0ef          	jal	8020254a <w_sie>
    80202586:	0001                	nop
    80202588:	60e2                	ld	ra,24(sp)
    8020258a:	6442                	ld	s0,16(sp)
    8020258c:	6105                	addi	sp,sp,32
    8020258e:	8082                	ret

0000000080202590 <plic_init>:
    80202590:	1101                	addi	sp,sp,-32
    80202592:	ec06                	sd	ra,24(sp)
    80202594:	e822                	sd	s0,16(sp)
    80202596:	1000                	addi	s0,sp,32
    80202598:	f79ff0ef          	jal	80202510 <r_tp>
    8020259c:	87aa                	mv	a5,a0
    8020259e:	fef42623          	sw	a5,-20(s0)
    802025a2:	fec42783          	lw	a5,-20(s0)
    802025a6:	0017979b          	slliw	a5,a5,0x1
    802025aa:	2781                	sext.w	a5,a5
    802025ac:	2785                	addiw	a5,a5,1
    802025ae:	2781                	sext.w	a5,a5
    802025b0:	00c7979b          	slliw	a5,a5,0xc
    802025b4:	2781                	sext.w	a5,a5
    802025b6:	873e                	mv	a4,a5
    802025b8:	0c2007b7          	lui	a5,0xc200
    802025bc:	97ba                	add	a5,a5,a4
    802025be:	0007a023          	sw	zero,0(a5) # c200000 <_heap_size+0x4318bd8>
    802025c2:	20000513          	li	a0,512
    802025c6:	fa3ff0ef          	jal	80202568 <trap_ie_enable>
    802025ca:	0001                	nop
    802025cc:	60e2                	ld	ra,24(sp)
    802025ce:	6442                	ld	s0,16(sp)
    802025d0:	6105                	addi	sp,sp,32
    802025d2:	8082                	ret

00000000802025d4 <plic_uart_enable>:
    802025d4:	1101                	addi	sp,sp,-32
    802025d6:	ec06                	sd	ra,24(sp)
    802025d8:	e822                	sd	s0,16(sp)
    802025da:	1000                	addi	s0,sp,32
    802025dc:	f35ff0ef          	jal	80202510 <r_tp>
    802025e0:	87aa                	mv	a5,a0
    802025e2:	fef42623          	sw	a5,-20(s0)
    802025e6:	0c0007b7          	lui	a5,0xc000
    802025ea:	02878793          	addi	a5,a5,40 # c000028 <_heap_size+0x4118c00>
    802025ee:	4705                	li	a4,1
    802025f0:	c398                	sw	a4,0(a5)
    802025f2:	fec42783          	lw	a5,-20(s0)
    802025f6:	0017979b          	slliw	a5,a5,0x1
    802025fa:	2781                	sext.w	a5,a5
    802025fc:	2785                	addiw	a5,a5,1
    802025fe:	2781                	sext.w	a5,a5
    80202600:	0077979b          	slliw	a5,a5,0x7
    80202604:	2781                	sext.w	a5,a5
    80202606:	873e                	mv	a4,a5
    80202608:	0c0027b7          	lui	a5,0xc002
    8020260c:	97ba                	add	a5,a5,a4
    8020260e:	873e                	mv	a4,a5
    80202610:	40000793          	li	a5,1024
    80202614:	c31c                	sw	a5,0(a4)
    80202616:	0001                	nop
    80202618:	60e2                	ld	ra,24(sp)
    8020261a:	6442                	ld	s0,16(sp)
    8020261c:	6105                	addi	sp,sp,32
    8020261e:	8082                	ret

0000000080202620 <plic_claim>:
    80202620:	1101                	addi	sp,sp,-32
    80202622:	ec06                	sd	ra,24(sp)
    80202624:	e822                	sd	s0,16(sp)
    80202626:	1000                	addi	s0,sp,32
    80202628:	ee9ff0ef          	jal	80202510 <r_tp>
    8020262c:	87aa                	mv	a5,a0
    8020262e:	fef42623          	sw	a5,-20(s0)
    80202632:	fec42783          	lw	a5,-20(s0)
    80202636:	0017979b          	slliw	a5,a5,0x1
    8020263a:	2781                	sext.w	a5,a5
    8020263c:	2785                	addiw	a5,a5,1 # c002001 <_heap_size+0x411abd9>
    8020263e:	2781                	sext.w	a5,a5
    80202640:	00c7979b          	slliw	a5,a5,0xc
    80202644:	2781                	sext.w	a5,a5
    80202646:	873e                	mv	a4,a5
    80202648:	0c2007b7          	lui	a5,0xc200
    8020264c:	0791                	addi	a5,a5,4 # c200004 <_heap_size+0x4318bdc>
    8020264e:	97ba                	add	a5,a5,a4
    80202650:	439c                	lw	a5,0(a5)
    80202652:	853e                	mv	a0,a5
    80202654:	60e2                	ld	ra,24(sp)
    80202656:	6442                	ld	s0,16(sp)
    80202658:	6105                	addi	sp,sp,32
    8020265a:	8082                	ret

000000008020265c <plic_complete>:
    8020265c:	7179                	addi	sp,sp,-48
    8020265e:	f406                	sd	ra,40(sp)
    80202660:	f022                	sd	s0,32(sp)
    80202662:	1800                	addi	s0,sp,48
    80202664:	87aa                	mv	a5,a0
    80202666:	fcf42e23          	sw	a5,-36(s0)
    8020266a:	ea7ff0ef          	jal	80202510 <r_tp>
    8020266e:	87aa                	mv	a5,a0
    80202670:	fef42623          	sw	a5,-20(s0)
    80202674:	fec42783          	lw	a5,-20(s0)
    80202678:	0017979b          	slliw	a5,a5,0x1
    8020267c:	2781                	sext.w	a5,a5
    8020267e:	2785                	addiw	a5,a5,1
    80202680:	2781                	sext.w	a5,a5
    80202682:	00c7979b          	slliw	a5,a5,0xc
    80202686:	2781                	sext.w	a5,a5
    80202688:	873e                	mv	a4,a5
    8020268a:	0c2007b7          	lui	a5,0xc200
    8020268e:	0791                	addi	a5,a5,4 # c200004 <_heap_size+0x4318bdc>
    80202690:	97ba                	add	a5,a5,a4
    80202692:	873e                	mv	a4,a5
    80202694:	fdc42783          	lw	a5,-36(s0)
    80202698:	c31c                	sw	a5,0(a4)
    8020269a:	0001                	nop
    8020269c:	70a2                	ld	ra,40(sp)
    8020269e:	7402                	ld	s0,32(sp)
    802026a0:	6145                	addi	sp,sp,48
    802026a2:	8082                	ret

00000000802026a4 <_clear>:
    802026a4:	1101                	addi	sp,sp,-32
    802026a6:	ec06                	sd	ra,24(sp)
    802026a8:	e822                	sd	s0,16(sp)
    802026aa:	1000                	addi	s0,sp,32
    802026ac:	fea43423          	sd	a0,-24(s0)
    802026b0:	fe843783          	ld	a5,-24(s0)
    802026b4:	00078023          	sb	zero,0(a5)
    802026b8:	0001                	nop
    802026ba:	60e2                	ld	ra,24(sp)
    802026bc:	6442                	ld	s0,16(sp)
    802026be:	6105                	addi	sp,sp,32
    802026c0:	8082                	ret

00000000802026c2 <_is_free>:
    802026c2:	1101                	addi	sp,sp,-32
    802026c4:	ec06                	sd	ra,24(sp)
    802026c6:	e822                	sd	s0,16(sp)
    802026c8:	1000                	addi	s0,sp,32
    802026ca:	fea43423          	sd	a0,-24(s0)
    802026ce:	fe843783          	ld	a5,-24(s0)
    802026d2:	0007c783          	lbu	a5,0(a5)
    802026d6:	2781                	sext.w	a5,a5
    802026d8:	8b85                	andi	a5,a5,1
    802026da:	2781                	sext.w	a5,a5
    802026dc:	c399                	beqz	a5,802026e2 <_is_free+0x20>
    802026de:	4781                	li	a5,0
    802026e0:	a011                	j	802026e4 <_is_free+0x22>
    802026e2:	4785                	li	a5,1
    802026e4:	853e                	mv	a0,a5
    802026e6:	60e2                	ld	ra,24(sp)
    802026e8:	6442                	ld	s0,16(sp)
    802026ea:	6105                	addi	sp,sp,32
    802026ec:	8082                	ret

00000000802026ee <_set_flag>:
    802026ee:	1101                	addi	sp,sp,-32
    802026f0:	ec06                	sd	ra,24(sp)
    802026f2:	e822                	sd	s0,16(sp)
    802026f4:	1000                	addi	s0,sp,32
    802026f6:	fea43423          	sd	a0,-24(s0)
    802026fa:	87ae                	mv	a5,a1
    802026fc:	fef403a3          	sb	a5,-25(s0)
    80202700:	fe843783          	ld	a5,-24(s0)
    80202704:	0007c783          	lbu	a5,0(a5)
    80202708:	fe744703          	lbu	a4,-25(s0)
    8020270c:	8fd9                	or	a5,a5,a4
    8020270e:	0ff7f713          	zext.b	a4,a5
    80202712:	fe843783          	ld	a5,-24(s0)
    80202716:	00e78023          	sb	a4,0(a5)
    8020271a:	0001                	nop
    8020271c:	60e2                	ld	ra,24(sp)
    8020271e:	6442                	ld	s0,16(sp)
    80202720:	6105                	addi	sp,sp,32
    80202722:	8082                	ret

0000000080202724 <_is_last>:
    80202724:	1101                	addi	sp,sp,-32
    80202726:	ec06                	sd	ra,24(sp)
    80202728:	e822                	sd	s0,16(sp)
    8020272a:	1000                	addi	s0,sp,32
    8020272c:	fea43423          	sd	a0,-24(s0)
    80202730:	fe843783          	ld	a5,-24(s0)
    80202734:	0007c783          	lbu	a5,0(a5)
    80202738:	2781                	sext.w	a5,a5
    8020273a:	8b89                	andi	a5,a5,2
    8020273c:	2781                	sext.w	a5,a5
    8020273e:	c399                	beqz	a5,80202744 <_is_last+0x20>
    80202740:	4785                	li	a5,1
    80202742:	a011                	j	80202746 <_is_last+0x22>
    80202744:	4781                	li	a5,0
    80202746:	853e                	mv	a0,a5
    80202748:	60e2                	ld	ra,24(sp)
    8020274a:	6442                	ld	s0,16(sp)
    8020274c:	6105                	addi	sp,sp,32
    8020274e:	8082                	ret

0000000080202750 <_align_page>:
    80202750:	7179                	addi	sp,sp,-48
    80202752:	f406                	sd	ra,40(sp)
    80202754:	f022                	sd	s0,32(sp)
    80202756:	1800                	addi	s0,sp,48
    80202758:	fca43c23          	sd	a0,-40(s0)
    8020275c:	6785                	lui	a5,0x1
    8020275e:	17fd                	addi	a5,a5,-1 # fff <STACK_SIZE-0x1>
    80202760:	fef43423          	sd	a5,-24(s0)
    80202764:	fd843703          	ld	a4,-40(s0)
    80202768:	fe843783          	ld	a5,-24(s0)
    8020276c:	973e                	add	a4,a4,a5
    8020276e:	fe843783          	ld	a5,-24(s0)
    80202772:	fff7c793          	not	a5,a5
    80202776:	8ff9                	and	a5,a5,a4
    80202778:	853e                	mv	a0,a5
    8020277a:	70a2                	ld	ra,40(sp)
    8020277c:	7402                	ld	s0,32(sp)
    8020277e:	6145                	addi	sp,sp,48
    80202780:	8082                	ret

0000000080202782 <page_init>:
    80202782:	7179                	addi	sp,sp,-48
    80202784:	f406                	sd	ra,40(sp)
    80202786:	f022                	sd	s0,32(sp)
    80202788:	1800                	addi	s0,sp,48
    8020278a:	00004797          	auipc	a5,0x4
    8020278e:	68678793          	addi	a5,a5,1670 # 80206e10 <HEAP_START>
    80202792:	639c                	ld	a5,0(a5)
    80202794:	853e                	mv	a0,a5
    80202796:	fbbff0ef          	jal	80202750 <_align_page>
    8020279a:	fca43c23          	sd	a0,-40(s0)
    8020279e:	47a1                	li	a5,8
    802027a0:	fcf42a23          	sw	a5,-44(s0)
    802027a4:	00004797          	auipc	a5,0x4
    802027a8:	66c78793          	addi	a5,a5,1644 # 80206e10 <HEAP_START>
    802027ac:	6398                	ld	a4,0(a5)
    802027ae:	fd843783          	ld	a5,-40(s0)
    802027b2:	8f1d                	sub	a4,a4,a5
    802027b4:	00004797          	auipc	a5,0x4
    802027b8:	66478793          	addi	a5,a5,1636 # 80206e18 <HEAP_SIZE>
    802027bc:	639c                	ld	a5,0(a5)
    802027be:	97ba                	add	a5,a5,a4
    802027c0:	83b1                	srli	a5,a5,0xc
    802027c2:	2781                	sext.w	a5,a5
    802027c4:	fd442703          	lw	a4,-44(s0)
    802027c8:	9f99                	subw	a5,a5,a4
    802027ca:	0007871b          	sext.w	a4,a5
    802027ce:	0000d797          	auipc	a5,0xd
    802027d2:	fea78793          	addi	a5,a5,-22 # 8020f7b8 <_num_pages>
    802027d6:	c398                	sw	a4,0(a5)
    802027d8:	00004797          	auipc	a5,0x4
    802027dc:	63878793          	addi	a5,a5,1592 # 80206e10 <HEAP_START>
    802027e0:	638c                	ld	a1,0(a5)
    802027e2:	00004797          	auipc	a5,0x4
    802027e6:	63678793          	addi	a5,a5,1590 # 80206e18 <HEAP_SIZE>
    802027ea:	6394                	ld	a3,0(a5)
    802027ec:	0000d797          	auipc	a5,0xd
    802027f0:	fcc78793          	addi	a5,a5,-52 # 8020f7b8 <_num_pages>
    802027f4:	439c                	lw	a5,0(a5)
    802027f6:	fd442703          	lw	a4,-44(s0)
    802027fa:	fd843603          	ld	a2,-40(s0)
    802027fe:	00005517          	auipc	a0,0x5
    80202802:	f6250513          	addi	a0,a0,-158 # 80207760 <user_code_end+0x8f0>
    80202806:	c31fe0ef          	jal	80201436 <printf>
    8020280a:	00004797          	auipc	a5,0x4
    8020280e:	60678793          	addi	a5,a5,1542 # 80206e10 <HEAP_START>
    80202812:	639c                	ld	a5,0(a5)
    80202814:	fef43423          	sd	a5,-24(s0)
    80202818:	fe042223          	sw	zero,-28(s0)
    8020281c:	a839                	j	8020283a <page_init+0xb8>
    8020281e:	fe843503          	ld	a0,-24(s0)
    80202822:	e83ff0ef          	jal	802026a4 <_clear>
    80202826:	fe843783          	ld	a5,-24(s0)
    8020282a:	0785                	addi	a5,a5,1
    8020282c:	fef43423          	sd	a5,-24(s0)
    80202830:	fe442783          	lw	a5,-28(s0)
    80202834:	2785                	addiw	a5,a5,1
    80202836:	fef42223          	sw	a5,-28(s0)
    8020283a:	fe442703          	lw	a4,-28(s0)
    8020283e:	0000d797          	auipc	a5,0xd
    80202842:	f7a78793          	addi	a5,a5,-134 # 8020f7b8 <_num_pages>
    80202846:	439c                	lw	a5,0(a5)
    80202848:	fcf76be3          	bltu	a4,a5,8020281e <page_init+0x9c>
    8020284c:	fd442783          	lw	a5,-44(s0)
    80202850:	00c7979b          	slliw	a5,a5,0xc
    80202854:	2781                	sext.w	a5,a5
    80202856:	02079713          	slli	a4,a5,0x20
    8020285a:	9301                	srli	a4,a4,0x20
    8020285c:	fd843783          	ld	a5,-40(s0)
    80202860:	973e                	add	a4,a4,a5
    80202862:	0000d797          	auipc	a5,0xd
    80202866:	f4678793          	addi	a5,a5,-186 # 8020f7a8 <_alloc_start>
    8020286a:	e398                	sd	a4,0(a5)
    8020286c:	0000d797          	auipc	a5,0xd
    80202870:	f4c78793          	addi	a5,a5,-180 # 8020f7b8 <_num_pages>
    80202874:	439c                	lw	a5,0(a5)
    80202876:	00c7979b          	slliw	a5,a5,0xc
    8020287a:	2781                	sext.w	a5,a5
    8020287c:	02079713          	slli	a4,a5,0x20
    80202880:	9301                	srli	a4,a4,0x20
    80202882:	0000d797          	auipc	a5,0xd
    80202886:	f2678793          	addi	a5,a5,-218 # 8020f7a8 <_alloc_start>
    8020288a:	639c                	ld	a5,0(a5)
    8020288c:	973e                	add	a4,a4,a5
    8020288e:	0000d797          	auipc	a5,0xd
    80202892:	f2278793          	addi	a5,a5,-222 # 8020f7b0 <_alloc_end>
    80202896:	e398                	sd	a4,0(a5)
    80202898:	00004797          	auipc	a5,0x4
    8020289c:	58878793          	addi	a5,a5,1416 # 80206e20 <TEXT_START>
    802028a0:	6398                	ld	a4,0(a5)
    802028a2:	00004797          	auipc	a5,0x4
    802028a6:	58678793          	addi	a5,a5,1414 # 80206e28 <TEXT_END>
    802028aa:	639c                	ld	a5,0(a5)
    802028ac:	863e                	mv	a2,a5
    802028ae:	85ba                	mv	a1,a4
    802028b0:	00005517          	auipc	a0,0x5
    802028b4:	f3050513          	addi	a0,a0,-208 # 802077e0 <user_code_end+0x970>
    802028b8:	b7ffe0ef          	jal	80201436 <printf>
    802028bc:	00004797          	auipc	a5,0x4
    802028c0:	58478793          	addi	a5,a5,1412 # 80206e40 <RODATA_START>
    802028c4:	6398                	ld	a4,0(a5)
    802028c6:	00004797          	auipc	a5,0x4
    802028ca:	58278793          	addi	a5,a5,1410 # 80206e48 <RODATA_END>
    802028ce:	639c                	ld	a5,0(a5)
    802028d0:	863e                	mv	a2,a5
    802028d2:	85ba                	mv	a1,a4
    802028d4:	00005517          	auipc	a0,0x5
    802028d8:	f2450513          	addi	a0,a0,-220 # 802077f8 <user_code_end+0x988>
    802028dc:	b5bfe0ef          	jal	80201436 <printf>
    802028e0:	00004797          	auipc	a5,0x4
    802028e4:	55078793          	addi	a5,a5,1360 # 80206e30 <DATA_START>
    802028e8:	6398                	ld	a4,0(a5)
    802028ea:	00004797          	auipc	a5,0x4
    802028ee:	54e78793          	addi	a5,a5,1358 # 80206e38 <DATA_END>
    802028f2:	639c                	ld	a5,0(a5)
    802028f4:	863e                	mv	a2,a5
    802028f6:	85ba                	mv	a1,a4
    802028f8:	00005517          	auipc	a0,0x5
    802028fc:	f1850513          	addi	a0,a0,-232 # 80207810 <user_code_end+0x9a0>
    80202900:	b37fe0ef          	jal	80201436 <printf>
    80202904:	00004797          	auipc	a5,0x4
    80202908:	54c78793          	addi	a5,a5,1356 # 80206e50 <BSS_START>
    8020290c:	6398                	ld	a4,0(a5)
    8020290e:	00004797          	auipc	a5,0x4
    80202912:	54a78793          	addi	a5,a5,1354 # 80206e58 <BSS_END>
    80202916:	639c                	ld	a5,0(a5)
    80202918:	863e                	mv	a2,a5
    8020291a:	85ba                	mv	a1,a4
    8020291c:	00005517          	auipc	a0,0x5
    80202920:	f0c50513          	addi	a0,a0,-244 # 80207828 <user_code_end+0x9b8>
    80202924:	b13fe0ef          	jal	80201436 <printf>
    80202928:	0000d797          	auipc	a5,0xd
    8020292c:	e8078793          	addi	a5,a5,-384 # 8020f7a8 <_alloc_start>
    80202930:	6398                	ld	a4,0(a5)
    80202932:	0000d797          	auipc	a5,0xd
    80202936:	e7e78793          	addi	a5,a5,-386 # 8020f7b0 <_alloc_end>
    8020293a:	639c                	ld	a5,0(a5)
    8020293c:	863e                	mv	a2,a5
    8020293e:	85ba                	mv	a1,a4
    80202940:	00005517          	auipc	a0,0x5
    80202944:	f0050513          	addi	a0,a0,-256 # 80207840 <user_code_end+0x9d0>
    80202948:	aeffe0ef          	jal	80201436 <printf>
    8020294c:	0001                	nop
    8020294e:	70a2                	ld	ra,40(sp)
    80202950:	7402                	ld	s0,32(sp)
    80202952:	6145                	addi	sp,sp,48
    80202954:	8082                	ret

0000000080202956 <page_alloc>:
    80202956:	711d                	addi	sp,sp,-96
    80202958:	ec86                	sd	ra,88(sp)
    8020295a:	e8a2                	sd	s0,80(sp)
    8020295c:	1080                	addi	s0,sp,96
    8020295e:	87aa                	mv	a5,a0
    80202960:	faf42623          	sw	a5,-84(s0)
    80202964:	fe042623          	sw	zero,-20(s0)
    80202968:	00004797          	auipc	a5,0x4
    8020296c:	4a878793          	addi	a5,a5,1192 # 80206e10 <HEAP_START>
    80202970:	639c                	ld	a5,0(a5)
    80202972:	fef43023          	sd	a5,-32(s0)
    80202976:	fc042e23          	sw	zero,-36(s0)
    8020297a:	a8ed                	j	80202a74 <page_alloc+0x11e>
    8020297c:	fe043503          	ld	a0,-32(s0)
    80202980:	d43ff0ef          	jal	802026c2 <_is_free>
    80202984:	87aa                	mv	a5,a0
    80202986:	cfe9                	beqz	a5,80202a60 <page_alloc+0x10a>
    80202988:	4785                	li	a5,1
    8020298a:	fef42623          	sw	a5,-20(s0)
    8020298e:	fe043783          	ld	a5,-32(s0)
    80202992:	0785                	addi	a5,a5,1
    80202994:	fcf43823          	sd	a5,-48(s0)
    80202998:	fdc42783          	lw	a5,-36(s0)
    8020299c:	2785                	addiw	a5,a5,1
    8020299e:	fcf42623          	sw	a5,-52(s0)
    802029a2:	a025                	j	802029ca <page_alloc+0x74>
    802029a4:	fd043503          	ld	a0,-48(s0)
    802029a8:	d1bff0ef          	jal	802026c2 <_is_free>
    802029ac:	87aa                	mv	a5,a0
    802029ae:	e781                	bnez	a5,802029b6 <page_alloc+0x60>
    802029b0:	fe042623          	sw	zero,-20(s0)
    802029b4:	a03d                	j	802029e2 <page_alloc+0x8c>
    802029b6:	fd043783          	ld	a5,-48(s0)
    802029ba:	0785                	addi	a5,a5,1
    802029bc:	fcf43823          	sd	a5,-48(s0)
    802029c0:	fcc42783          	lw	a5,-52(s0)
    802029c4:	2785                	addiw	a5,a5,1
    802029c6:	fcf42623          	sw	a5,-52(s0)
    802029ca:	fdc42783          	lw	a5,-36(s0)
    802029ce:	873e                	mv	a4,a5
    802029d0:	fac42783          	lw	a5,-84(s0)
    802029d4:	9fb9                	addw	a5,a5,a4
    802029d6:	2781                	sext.w	a5,a5
    802029d8:	fcc42703          	lw	a4,-52(s0)
    802029dc:	2701                	sext.w	a4,a4
    802029de:	fcf743e3          	blt	a4,a5,802029a4 <page_alloc+0x4e>
    802029e2:	fec42783          	lw	a5,-20(s0)
    802029e6:	2781                	sext.w	a5,a5
    802029e8:	cfa5                	beqz	a5,80202a60 <page_alloc+0x10a>
    802029ea:	fe043783          	ld	a5,-32(s0)
    802029ee:	fcf43023          	sd	a5,-64(s0)
    802029f2:	fdc42783          	lw	a5,-36(s0)
    802029f6:	faf42e23          	sw	a5,-68(s0)
    802029fa:	a005                	j	80202a1a <page_alloc+0xc4>
    802029fc:	4585                	li	a1,1
    802029fe:	fc043503          	ld	a0,-64(s0)
    80202a02:	cedff0ef          	jal	802026ee <_set_flag>
    80202a06:	fc043783          	ld	a5,-64(s0)
    80202a0a:	0785                	addi	a5,a5,1
    80202a0c:	fcf43023          	sd	a5,-64(s0)
    80202a10:	fbc42783          	lw	a5,-68(s0)
    80202a14:	2785                	addiw	a5,a5,1
    80202a16:	faf42e23          	sw	a5,-68(s0)
    80202a1a:	fdc42783          	lw	a5,-36(s0)
    80202a1e:	873e                	mv	a4,a5
    80202a20:	fac42783          	lw	a5,-84(s0)
    80202a24:	9fb9                	addw	a5,a5,a4
    80202a26:	2781                	sext.w	a5,a5
    80202a28:	fbc42703          	lw	a4,-68(s0)
    80202a2c:	2701                	sext.w	a4,a4
    80202a2e:	fcf747e3          	blt	a4,a5,802029fc <page_alloc+0xa6>
    80202a32:	fc043783          	ld	a5,-64(s0)
    80202a36:	17fd                	addi	a5,a5,-1
    80202a38:	fcf43023          	sd	a5,-64(s0)
    80202a3c:	4589                	li	a1,2
    80202a3e:	fc043503          	ld	a0,-64(s0)
    80202a42:	cadff0ef          	jal	802026ee <_set_flag>
    80202a46:	fdc42783          	lw	a5,-36(s0)
    80202a4a:	00c7979b          	slliw	a5,a5,0xc
    80202a4e:	2781                	sext.w	a5,a5
    80202a50:	873e                	mv	a4,a5
    80202a52:	0000d797          	auipc	a5,0xd
    80202a56:	d5678793          	addi	a5,a5,-682 # 8020f7a8 <_alloc_start>
    80202a5a:	639c                	ld	a5,0(a5)
    80202a5c:	97ba                	add	a5,a5,a4
    80202a5e:	a81d                	j	80202a94 <page_alloc+0x13e>
    80202a60:	fe043783          	ld	a5,-32(s0)
    80202a64:	0785                	addi	a5,a5,1
    80202a66:	fef43023          	sd	a5,-32(s0)
    80202a6a:	fdc42783          	lw	a5,-36(s0)
    80202a6e:	2785                	addiw	a5,a5,1
    80202a70:	fcf42e23          	sw	a5,-36(s0)
    80202a74:	0000d797          	auipc	a5,0xd
    80202a78:	d4478793          	addi	a5,a5,-700 # 8020f7b8 <_num_pages>
    80202a7c:	4398                	lw	a4,0(a5)
    80202a7e:	fac42783          	lw	a5,-84(s0)
    80202a82:	40f707bb          	subw	a5,a4,a5
    80202a86:	0007871b          	sext.w	a4,a5
    80202a8a:	fdc42783          	lw	a5,-36(s0)
    80202a8e:	eef777e3          	bgeu	a4,a5,8020297c <page_alloc+0x26>
    80202a92:	4781                	li	a5,0
    80202a94:	853e                	mv	a0,a5
    80202a96:	60e6                	ld	ra,88(sp)
    80202a98:	6446                	ld	s0,80(sp)
    80202a9a:	6125                	addi	sp,sp,96
    80202a9c:	8082                	ret

0000000080202a9e <page_free>:
    80202a9e:	7179                	addi	sp,sp,-48
    80202aa0:	f406                	sd	ra,40(sp)
    80202aa2:	f022                	sd	s0,32(sp)
    80202aa4:	1800                	addi	s0,sp,48
    80202aa6:	fca43c23          	sd	a0,-40(s0)
    80202aaa:	fd843783          	ld	a5,-40(s0)
    80202aae:	cfa5                	beqz	a5,80202b26 <page_free+0x88>
    80202ab0:	fd843703          	ld	a4,-40(s0)
    80202ab4:	0000d797          	auipc	a5,0xd
    80202ab8:	cfc78793          	addi	a5,a5,-772 # 8020f7b0 <_alloc_end>
    80202abc:	639c                	ld	a5,0(a5)
    80202abe:	06f77463          	bgeu	a4,a5,80202b26 <page_free+0x88>
    80202ac2:	00004797          	auipc	a5,0x4
    80202ac6:	34e78793          	addi	a5,a5,846 # 80206e10 <HEAP_START>
    80202aca:	639c                	ld	a5,0(a5)
    80202acc:	fef43423          	sd	a5,-24(s0)
    80202ad0:	fd843703          	ld	a4,-40(s0)
    80202ad4:	0000d797          	auipc	a5,0xd
    80202ad8:	cd478793          	addi	a5,a5,-812 # 8020f7a8 <_alloc_start>
    80202adc:	639c                	ld	a5,0(a5)
    80202ade:	40f707b3          	sub	a5,a4,a5
    80202ae2:	83b1                	srli	a5,a5,0xc
    80202ae4:	fe843703          	ld	a4,-24(s0)
    80202ae8:	97ba                	add	a5,a5,a4
    80202aea:	fef43423          	sd	a5,-24(s0)
    80202aee:	a02d                	j	80202b18 <page_free+0x7a>
    80202af0:	fe843503          	ld	a0,-24(s0)
    80202af4:	c31ff0ef          	jal	80202724 <_is_last>
    80202af8:	87aa                	mv	a5,a0
    80202afa:	c791                	beqz	a5,80202b06 <page_free+0x68>
    80202afc:	fe843503          	ld	a0,-24(s0)
    80202b00:	ba5ff0ef          	jal	802026a4 <_clear>
    80202b04:	a015                	j	80202b28 <page_free+0x8a>
    80202b06:	fe843503          	ld	a0,-24(s0)
    80202b0a:	b9bff0ef          	jal	802026a4 <_clear>
    80202b0e:	fe843783          	ld	a5,-24(s0)
    80202b12:	0785                	addi	a5,a5,1
    80202b14:	fef43423          	sd	a5,-24(s0)
    80202b18:	fe843503          	ld	a0,-24(s0)
    80202b1c:	ba7ff0ef          	jal	802026c2 <_is_free>
    80202b20:	87aa                	mv	a5,a0
    80202b22:	d7f9                	beqz	a5,80202af0 <page_free+0x52>
    80202b24:	a011                	j	80202b28 <page_free+0x8a>
    80202b26:	0001                	nop
    80202b28:	70a2                	ld	ra,40(sp)
    80202b2a:	7402                	ld	s0,32(sp)
    80202b2c:	6145                	addi	sp,sp,48
    80202b2e:	8082                	ret

0000000080202b30 <page_test>:
    80202b30:	7179                	addi	sp,sp,-48
    80202b32:	f406                	sd	ra,40(sp)
    80202b34:	f022                	sd	s0,32(sp)
    80202b36:	1800                	addi	s0,sp,48
    80202b38:	4509                	li	a0,2
    80202b3a:	e1dff0ef          	jal	80202956 <page_alloc>
    80202b3e:	fea43423          	sd	a0,-24(s0)
    80202b42:	fe843583          	ld	a1,-24(s0)
    80202b46:	00005517          	auipc	a0,0x5
    80202b4a:	d1250513          	addi	a0,a0,-750 # 80207858 <user_code_end+0x9e8>
    80202b4e:	8e9fe0ef          	jal	80201436 <printf>
    80202b52:	451d                	li	a0,7
    80202b54:	e03ff0ef          	jal	80202956 <page_alloc>
    80202b58:	fea43023          	sd	a0,-32(s0)
    80202b5c:	fe043583          	ld	a1,-32(s0)
    80202b60:	00005517          	auipc	a0,0x5
    80202b64:	d0050513          	addi	a0,a0,-768 # 80207860 <user_code_end+0x9f0>
    80202b68:	8cffe0ef          	jal	80201436 <printf>
    80202b6c:	fe043503          	ld	a0,-32(s0)
    80202b70:	f2fff0ef          	jal	80202a9e <page_free>
    80202b74:	4511                	li	a0,4
    80202b76:	de1ff0ef          	jal	80202956 <page_alloc>
    80202b7a:	fca43c23          	sd	a0,-40(s0)
    80202b7e:	fd843583          	ld	a1,-40(s0)
    80202b82:	00005517          	auipc	a0,0x5
    80202b86:	cee50513          	addi	a0,a0,-786 # 80207870 <user_code_end+0xa00>
    80202b8a:	8adfe0ef          	jal	80201436 <printf>
    80202b8e:	0001                	nop
    80202b90:	70a2                	ld	ra,40(sp)
    80202b92:	7402                	ld	s0,32(sp)
    80202b94:	6145                	addi	sp,sp,48
    80202b96:	8082                	ret

0000000080202b98 <r_sie>:
    80202b98:	1101                	addi	sp,sp,-32
    80202b9a:	ec06                	sd	ra,24(sp)
    80202b9c:	e822                	sd	s0,16(sp)
    80202b9e:	1000                	addi	s0,sp,32
    80202ba0:	104027f3          	csrr	a5,sie
    80202ba4:	fef43423          	sd	a5,-24(s0)
    80202ba8:	fe843783          	ld	a5,-24(s0)
    80202bac:	853e                	mv	a0,a5
    80202bae:	60e2                	ld	ra,24(sp)
    80202bb0:	6442                	ld	s0,16(sp)
    80202bb2:	6105                	addi	sp,sp,32
    80202bb4:	8082                	ret

0000000080202bb6 <w_sie>:
    80202bb6:	1101                	addi	sp,sp,-32
    80202bb8:	ec06                	sd	ra,24(sp)
    80202bba:	e822                	sd	s0,16(sp)
    80202bbc:	1000                	addi	s0,sp,32
    80202bbe:	fea43423          	sd	a0,-24(s0)
    80202bc2:	fe843783          	ld	a5,-24(s0)
    80202bc6:	10479073          	csrw	sie,a5
    80202bca:	0001                	nop
    80202bcc:	60e2                	ld	ra,24(sp)
    80202bce:	6442                	ld	s0,16(sp)
    80202bd0:	6105                	addi	sp,sp,32
    80202bd2:	8082                	ret

0000000080202bd4 <r_sip>:
    80202bd4:	1101                	addi	sp,sp,-32
    80202bd6:	ec06                	sd	ra,24(sp)
    80202bd8:	e822                	sd	s0,16(sp)
    80202bda:	1000                	addi	s0,sp,32
    80202bdc:	144027f3          	csrr	a5,sip
    80202be0:	fef43423          	sd	a5,-24(s0)
    80202be4:	fe843783          	ld	a5,-24(s0)
    80202be8:	853e                	mv	a0,a5
    80202bea:	60e2                	ld	ra,24(sp)
    80202bec:	6442                	ld	s0,16(sp)
    80202bee:	6105                	addi	sp,sp,32
    80202bf0:	8082                	ret

0000000080202bf2 <w_sip>:
    80202bf2:	1101                	addi	sp,sp,-32
    80202bf4:	ec06                	sd	ra,24(sp)
    80202bf6:	e822                	sd	s0,16(sp)
    80202bf8:	1000                	addi	s0,sp,32
    80202bfa:	fea43423          	sd	a0,-24(s0)
    80202bfe:	fe843783          	ld	a5,-24(s0)
    80202c02:	14479073          	csrw	sip,a5
    80202c06:	0001                	nop
    80202c08:	60e2                	ld	ra,24(sp)
    80202c0a:	6442                	ld	s0,16(sp)
    80202c0c:	6105                	addi	sp,sp,32
    80202c0e:	8082                	ret

0000000080202c10 <trap_ie_enable>:
    80202c10:	1101                	addi	sp,sp,-32
    80202c12:	ec06                	sd	ra,24(sp)
    80202c14:	e822                	sd	s0,16(sp)
    80202c16:	1000                	addi	s0,sp,32
    80202c18:	fea43423          	sd	a0,-24(s0)
    80202c1c:	f7dff0ef          	jal	80202b98 <r_sie>
    80202c20:	872a                	mv	a4,a0
    80202c22:	fe843783          	ld	a5,-24(s0)
    80202c26:	8fd9                	or	a5,a5,a4
    80202c28:	853e                	mv	a0,a5
    80202c2a:	f8dff0ef          	jal	80202bb6 <w_sie>
    80202c2e:	0001                	nop
    80202c30:	60e2                	ld	ra,24(sp)
    80202c32:	6442                	ld	s0,16(sp)
    80202c34:	6105                	addi	sp,sp,32
    80202c36:	8082                	ret

0000000080202c38 <task_idle_loop>:
    80202c38:	1141                	addi	sp,sp,-16
    80202c3a:	e406                	sd	ra,8(sp)
    80202c3c:	e022                	sd	s0,0(sp)
    80202c3e:	0800                	addi	s0,sp,16
    80202c40:	10500073          	wfi
    80202c44:	bff5                	j	80202c40 <task_idle_loop+0x8>

0000000080202c46 <sched_task_count>:
    80202c46:	1141                	addi	sp,sp,-16
    80202c48:	e406                	sd	ra,8(sp)
    80202c4a:	e022                	sd	s0,0(sp)
    80202c4c:	0800                	addi	s0,sp,16
    80202c4e:	00010797          	auipc	a5,0x10
    80202c52:	d7278793          	addi	a5,a5,-654 # 802129c0 <_top>
    80202c56:	439c                	lw	a5,0(a5)
    80202c58:	853e                	mv	a0,a5
    80202c5a:	60a2                	ld	ra,8(sp)
    80202c5c:	6402                	ld	s0,0(sp)
    80202c5e:	0141                	addi	sp,sp,16
    80202c60:	8082                	ret

0000000080202c62 <sched_init>:
    80202c62:	1141                	addi	sp,sp,-16
    80202c64:	e406                	sd	ra,8(sp)
    80202c66:	e022                	sd	s0,0(sp)
    80202c68:	0800                	addi	s0,sp,16
    80202c6a:	4509                	li	a0,2
    80202c6c:	fa5ff0ef          	jal	80202c10 <trap_ie_enable>
    80202c70:	0001                	nop
    80202c72:	60a2                	ld	ra,8(sp)
    80202c74:	6402                	ld	s0,0(sp)
    80202c76:	0141                	addi	sp,sp,16
    80202c78:	8082                	ret

0000000080202c7a <schedule>:
    80202c7a:	1101                	addi	sp,sp,-32
    80202c7c:	ec06                	sd	ra,24(sp)
    80202c7e:	e822                	sd	s0,16(sp)
    80202c80:	1000                	addi	s0,sp,32
    80202c82:	00010797          	auipc	a5,0x10
    80202c86:	d3e78793          	addi	a5,a5,-706 # 802129c0 <_top>
    80202c8a:	439c                	lw	a5,0(a5)
    80202c8c:	00f04963          	bgtz	a5,80202c9e <schedule+0x24>
    80202c90:	00005517          	auipc	a0,0x5
    80202c94:	bf050513          	addi	a0,a0,-1040 # 80207880 <user_code_end+0xa10>
    80202c98:	867fe0ef          	jal	802014fe <panic>
    80202c9c:	a889                	j	80202cee <schedule+0x74>
    80202c9e:	0000c797          	auipc	a5,0xc
    80202ca2:	36278793          	addi	a5,a5,866 # 8020f000 <_current>
    80202ca6:	439c                	lw	a5,0(a5)
    80202ca8:	2785                	addiw	a5,a5,1
    80202caa:	0007871b          	sext.w	a4,a5
    80202cae:	00010797          	auipc	a5,0x10
    80202cb2:	d1278793          	addi	a5,a5,-750 # 802129c0 <_top>
    80202cb6:	439c                	lw	a5,0(a5)
    80202cb8:	02f767bb          	remw	a5,a4,a5
    80202cbc:	0007871b          	sext.w	a4,a5
    80202cc0:	0000c797          	auipc	a5,0xc
    80202cc4:	34078793          	addi	a5,a5,832 # 8020f000 <_current>
    80202cc8:	c398                	sw	a4,0(a5)
    80202cca:	0000c797          	auipc	a5,0xc
    80202cce:	33678793          	addi	a5,a5,822 # 8020f000 <_current>
    80202cd2:	439c                	lw	a5,0(a5)
    80202cd4:	00879713          	slli	a4,a5,0x8
    80202cd8:	0000f797          	auipc	a5,0xf
    80202cdc:	2e878793          	addi	a5,a5,744 # 80211fc0 <ctx_tasks>
    80202ce0:	97ba                	add	a5,a5,a4
    80202ce2:	fef43423          	sd	a5,-24(s0)
    80202ce6:	fe843503          	ld	a0,-24(s0)
    80202cea:	d42fd0ef          	jal	8020022c <switch_to>
    80202cee:	60e2                	ld	ra,24(sp)
    80202cf0:	6442                	ld	s0,16(sp)
    80202cf2:	6105                	addi	sp,sp,32
    80202cf4:	8082                	ret

0000000080202cf6 <task_create>:
    80202cf6:	1101                	addi	sp,sp,-32
    80202cf8:	ec06                	sd	ra,24(sp)
    80202cfa:	e822                	sd	s0,16(sp)
    80202cfc:	1000                	addi	s0,sp,32
    80202cfe:	fea43423          	sd	a0,-24(s0)
    80202d02:	00010797          	auipc	a5,0x10
    80202d06:	cbe78793          	addi	a5,a5,-834 # 802129c0 <_top>
    80202d0a:	4398                	lw	a4,0(a5)
    80202d0c:	47a5                	li	a5,9
    80202d0e:	06e7c963          	blt	a5,a4,80202d80 <task_create+0x8a>
    80202d12:	00010797          	auipc	a5,0x10
    80202d16:	cae78793          	addi	a5,a5,-850 # 802129c0 <_top>
    80202d1a:	439c                	lw	a5,0(a5)
    80202d1c:	0785                	addi	a5,a5,1
    80202d1e:	00a79713          	slli	a4,a5,0xa
    80202d22:	0000d797          	auipc	a5,0xd
    80202d26:	a9e78793          	addi	a5,a5,-1378 # 8020f7c0 <task_stack>
    80202d2a:	973e                	add	a4,a4,a5
    80202d2c:	00010797          	auipc	a5,0x10
    80202d30:	c9478793          	addi	a5,a5,-876 # 802129c0 <_top>
    80202d34:	439c                	lw	a5,0(a5)
    80202d36:	86ba                	mv	a3,a4
    80202d38:	0000f717          	auipc	a4,0xf
    80202d3c:	28870713          	addi	a4,a4,648 # 80211fc0 <ctx_tasks>
    80202d40:	07a2                	slli	a5,a5,0x8
    80202d42:	97ba                	add	a5,a5,a4
    80202d44:	e794                	sd	a3,8(a5)
    80202d46:	00010797          	auipc	a5,0x10
    80202d4a:	c7a78793          	addi	a5,a5,-902 # 802129c0 <_top>
    80202d4e:	439c                	lw	a5,0(a5)
    80202d50:	fe843703          	ld	a4,-24(s0)
    80202d54:	0000f697          	auipc	a3,0xf
    80202d58:	26c68693          	addi	a3,a3,620 # 80211fc0 <ctx_tasks>
    80202d5c:	07a2                	slli	a5,a5,0x8
    80202d5e:	97b6                	add	a5,a5,a3
    80202d60:	fff8                	sd	a4,248(a5)
    80202d62:	00010797          	auipc	a5,0x10
    80202d66:	c5e78793          	addi	a5,a5,-930 # 802129c0 <_top>
    80202d6a:	439c                	lw	a5,0(a5)
    80202d6c:	2785                	addiw	a5,a5,1
    80202d6e:	0007871b          	sext.w	a4,a5
    80202d72:	00010797          	auipc	a5,0x10
    80202d76:	c4e78793          	addi	a5,a5,-946 # 802129c0 <_top>
    80202d7a:	c398                	sw	a4,0(a5)
    80202d7c:	4781                	li	a5,0
    80202d7e:	a011                	j	80202d82 <task_create+0x8c>
    80202d80:	57fd                	li	a5,-1
    80202d82:	853e                	mv	a0,a5
    80202d84:	60e2                	ld	ra,24(sp)
    80202d86:	6442                	ld	s0,16(sp)
    80202d88:	6105                	addi	sp,sp,32
    80202d8a:	8082                	ret

0000000080202d8c <task_yield>:
    80202d8c:	1141                	addi	sp,sp,-16
    80202d8e:	e406                	sd	ra,8(sp)
    80202d90:	e022                	sd	s0,0(sp)
    80202d92:	0800                	addi	s0,sp,16
    80202d94:	e41ff0ef          	jal	80202bd4 <r_sip>
    80202d98:	87aa                	mv	a5,a0
    80202d9a:	0027e793          	ori	a5,a5,2
    80202d9e:	853e                	mv	a0,a5
    80202da0:	e53ff0ef          	jal	80202bf2 <w_sip>
    80202da4:	0001                	nop
    80202da6:	60a2                	ld	ra,8(sp)
    80202da8:	6402                	ld	s0,0(sp)
    80202daa:	0141                	addi	sp,sp,16
    80202dac:	8082                	ret

0000000080202dae <task_exit_to_idle>:
    80202dae:	1101                	addi	sp,sp,-32
    80202db0:	ec06                	sd	ra,24(sp)
    80202db2:	e822                	sd	s0,16(sp)
    80202db4:	1000                	addi	s0,sp,32
    80202db6:	fea43423          	sd	a0,-24(s0)
    80202dba:	87ae                	mv	a5,a1
    80202dbc:	fef42223          	sw	a5,-28(s0)
    80202dc0:	fe442703          	lw	a4,-28(s0)
    80202dc4:	fe843783          	ld	a5,-24(s0)
    80202dc8:	e7b8                	sd	a4,72(a5)
    80202dca:	00000717          	auipc	a4,0x0
    80202dce:	e6e70713          	addi	a4,a4,-402 # 80202c38 <task_idle_loop>
    80202dd2:	fe843783          	ld	a5,-24(s0)
    80202dd6:	fff8                	sd	a4,248(a5)
    80202dd8:	0001                	nop
    80202dda:	60e2                	ld	ra,24(sp)
    80202ddc:	6442                	ld	s0,16(sp)
    80202dde:	6105                	addi	sp,sp,32
    80202de0:	8082                	ret

0000000080202de2 <task_delay>:
    80202de2:	1101                	addi	sp,sp,-32
    80202de4:	ec06                	sd	ra,24(sp)
    80202de6:	e822                	sd	s0,16(sp)
    80202de8:	1000                	addi	s0,sp,32
    80202dea:	87aa                	mv	a5,a0
    80202dec:	fef42623          	sw	a5,-20(s0)
    80202df0:	fec42783          	lw	a5,-20(s0)
    80202df4:	0007871b          	sext.w	a4,a5
    80202df8:	67b1                	lui	a5,0xc
    80202dfa:	3507879b          	addiw	a5,a5,848 # c350 <STACK_SIZE+0xb350>
    80202dfe:	02f707bb          	mulw	a5,a4,a5
    80202e02:	2781                	sext.w	a5,a5
    80202e04:	fef42623          	sw	a5,-20(s0)
    80202e08:	0001                	nop
    80202e0a:	fec42783          	lw	a5,-20(s0)
    80202e0e:	2781                	sext.w	a5,a5
    80202e10:	fff7871b          	addiw	a4,a5,-1
    80202e14:	2701                	sext.w	a4,a4
    80202e16:	fee42623          	sw	a4,-20(s0)
    80202e1a:	fbe5                	bnez	a5,80202e0a <task_delay+0x28>
    80202e1c:	0001                	nop
    80202e1e:	0001                	nop
    80202e20:	60e2                	ld	ra,24(sp)
    80202e22:	6442                	ld	s0,16(sp)
    80202e24:	6105                	addi	sp,sp,32
    80202e26:	8082                	ret

0000000080202e28 <r_sstatus>:
    80202e28:	1101                	addi	sp,sp,-32
    80202e2a:	ec06                	sd	ra,24(sp)
    80202e2c:	e822                	sd	s0,16(sp)
    80202e2e:	1000                	addi	s0,sp,32
    80202e30:	100027f3          	csrr	a5,sstatus
    80202e34:	fef43423          	sd	a5,-24(s0)
    80202e38:	fe843783          	ld	a5,-24(s0)
    80202e3c:	853e                	mv	a0,a5
    80202e3e:	60e2                	ld	ra,24(sp)
    80202e40:	6442                	ld	s0,16(sp)
    80202e42:	6105                	addi	sp,sp,32
    80202e44:	8082                	ret

0000000080202e46 <w_sstatus>:
    80202e46:	1101                	addi	sp,sp,-32
    80202e48:	ec06                	sd	ra,24(sp)
    80202e4a:	e822                	sd	s0,16(sp)
    80202e4c:	1000                	addi	s0,sp,32
    80202e4e:	fea43423          	sd	a0,-24(s0)
    80202e52:	fe843783          	ld	a5,-24(s0)
    80202e56:	10079073          	csrw	sstatus,a5
    80202e5a:	0001                	nop
    80202e5c:	60e2                	ld	ra,24(sp)
    80202e5e:	6442                	ld	s0,16(sp)
    80202e60:	6105                	addi	sp,sp,32
    80202e62:	8082                	ret

0000000080202e64 <cpu_irq_disable>:
    80202e64:	1141                	addi	sp,sp,-16
    80202e66:	e406                	sd	ra,8(sp)
    80202e68:	e022                	sd	s0,0(sp)
    80202e6a:	0800                	addi	s0,sp,16
    80202e6c:	fbdff0ef          	jal	80202e28 <r_sstatus>
    80202e70:	87aa                	mv	a5,a0
    80202e72:	9bf5                	andi	a5,a5,-3
    80202e74:	853e                	mv	a0,a5
    80202e76:	fd1ff0ef          	jal	80202e46 <w_sstatus>
    80202e7a:	0001                	nop
    80202e7c:	60a2                	ld	ra,8(sp)
    80202e7e:	6402                	ld	s0,0(sp)
    80202e80:	0141                	addi	sp,sp,16
    80202e82:	8082                	ret

0000000080202e84 <cpu_irq_enable>:
    80202e84:	1141                	addi	sp,sp,-16
    80202e86:	e406                	sd	ra,8(sp)
    80202e88:	e022                	sd	s0,0(sp)
    80202e8a:	0800                	addi	s0,sp,16
    80202e8c:	f9dff0ef          	jal	80202e28 <r_sstatus>
    80202e90:	87aa                	mv	a5,a0
    80202e92:	0027e793          	ori	a5,a5,2
    80202e96:	853e                	mv	a0,a5
    80202e98:	fafff0ef          	jal	80202e46 <w_sstatus>
    80202e9c:	0001                	nop
    80202e9e:	60a2                	ld	ra,8(sp)
    80202ea0:	6402                	ld	s0,0(sp)
    80202ea2:	0141                	addi	sp,sp,16
    80202ea4:	8082                	ret

0000000080202ea6 <spin_lock>:
    80202ea6:	1141                	addi	sp,sp,-16
    80202ea8:	e406                	sd	ra,8(sp)
    80202eaa:	e022                	sd	s0,0(sp)
    80202eac:	0800                	addi	s0,sp,16
    80202eae:	fb7ff0ef          	jal	80202e64 <cpu_irq_disable>
    80202eb2:	4781                	li	a5,0
    80202eb4:	853e                	mv	a0,a5
    80202eb6:	60a2                	ld	ra,8(sp)
    80202eb8:	6402                	ld	s0,0(sp)
    80202eba:	0141                	addi	sp,sp,16
    80202ebc:	8082                	ret

0000000080202ebe <spin_unlock>:
    80202ebe:	1141                	addi	sp,sp,-16
    80202ec0:	e406                	sd	ra,8(sp)
    80202ec2:	e022                	sd	s0,0(sp)
    80202ec4:	0800                	addi	s0,sp,16
    80202ec6:	fbfff0ef          	jal	80202e84 <cpu_irq_enable>
    80202eca:	4781                	li	a5,0
    80202ecc:	853e                	mv	a0,a5
    80202ece:	60a2                	ld	ra,8(sp)
    80202ed0:	6402                	ld	s0,0(sp)
    80202ed2:	0141                	addi	sp,sp,16
    80202ed4:	8082                	ret

0000000080202ed6 <proc_init>:
    80202ed6:	1101                	addi	sp,sp,-32
    80202ed8:	ec06                	sd	ra,24(sp)
    80202eda:	e822                	sd	s0,16(sp)
    80202edc:	1000                	addi	s0,sp,32
    80202ede:	fe042623          	sw	zero,-20(s0)
    80202ee2:	a065                	j	80202f8a <proc_init+0xb4>
    80202ee4:	00010697          	auipc	a3,0x10
    80202ee8:	ae468693          	addi	a3,a3,-1308 # 802129c8 <procs>
    80202eec:	fec42703          	lw	a4,-20(s0)
    80202ef0:	87ba                	mv	a5,a4
    80202ef2:	0786                	slli	a5,a5,0x1
    80202ef4:	97ba                	add	a5,a5,a4
    80202ef6:	0792                	slli	a5,a5,0x4
    80202ef8:	97b6                	add	a5,a5,a3
    80202efa:	577d                	li	a4,-1
    80202efc:	c398                	sw	a4,0(a5)
    80202efe:	00010697          	auipc	a3,0x10
    80202f02:	aca68693          	addi	a3,a3,-1334 # 802129c8 <procs>
    80202f06:	fec42703          	lw	a4,-20(s0)
    80202f0a:	87ba                	mv	a5,a4
    80202f0c:	0786                	slli	a5,a5,0x1
    80202f0e:	97ba                	add	a5,a5,a4
    80202f10:	0792                	slli	a5,a5,0x4
    80202f12:	97b6                	add	a5,a5,a3
    80202f14:	0007a223          	sw	zero,4(a5)
    80202f18:	00010697          	auipc	a3,0x10
    80202f1c:	ab068693          	addi	a3,a3,-1360 # 802129c8 <procs>
    80202f20:	fec42703          	lw	a4,-20(s0)
    80202f24:	87ba                	mv	a5,a4
    80202f26:	0786                	slli	a5,a5,0x1
    80202f28:	97ba                	add	a5,a5,a4
    80202f2a:	0792                	slli	a5,a5,0x4
    80202f2c:	97b6                	add	a5,a5,a3
    80202f2e:	0007a423          	sw	zero,8(a5)
    80202f32:	00010697          	auipc	a3,0x10
    80202f36:	a9668693          	addi	a3,a3,-1386 # 802129c8 <procs>
    80202f3a:	fec42703          	lw	a4,-20(s0)
    80202f3e:	87ba                	mv	a5,a4
    80202f40:	0786                	slli	a5,a5,0x1
    80202f42:	97ba                	add	a5,a5,a4
    80202f44:	0792                	slli	a5,a5,0x4
    80202f46:	97b6                	add	a5,a5,a3
    80202f48:	00078623          	sb	zero,12(a5)
    80202f4c:	00010697          	auipc	a3,0x10
    80202f50:	a7c68693          	addi	a3,a3,-1412 # 802129c8 <procs>
    80202f54:	fec42703          	lw	a4,-20(s0)
    80202f58:	87ba                	mv	a5,a4
    80202f5a:	0786                	slli	a5,a5,0x1
    80202f5c:	97ba                	add	a5,a5,a4
    80202f5e:	0792                	slli	a5,a5,0x4
    80202f60:	97b6                	add	a5,a5,a3
    80202f62:	0207b023          	sd	zero,32(a5)
    80202f66:	00010697          	auipc	a3,0x10
    80202f6a:	a6268693          	addi	a3,a3,-1438 # 802129c8 <procs>
    80202f6e:	fec42703          	lw	a4,-20(s0)
    80202f72:	87ba                	mv	a5,a4
    80202f74:	0786                	slli	a5,a5,0x1
    80202f76:	97ba                	add	a5,a5,a4
    80202f78:	0792                	slli	a5,a5,0x4
    80202f7a:	97b6                	add	a5,a5,a3
    80202f7c:	577d                	li	a4,-1
    80202f7e:	d798                	sw	a4,40(a5)
    80202f80:	fec42783          	lw	a5,-20(s0)
    80202f84:	2785                	addiw	a5,a5,1
    80202f86:	fef42623          	sw	a5,-20(s0)
    80202f8a:	fec42783          	lw	a5,-20(s0)
    80202f8e:	0007871b          	sext.w	a4,a5
    80202f92:	47bd                	li	a5,15
    80202f94:	f4e7d8e3          	bge	a5,a4,80202ee4 <proc_init+0xe>
    80202f98:	00010797          	auipc	a5,0x10
    80202f9c:	a3078793          	addi	a5,a5,-1488 # 802129c8 <procs>
    80202fa0:	0007a023          	sw	zero,0(a5)
    80202fa4:	00010797          	auipc	a5,0x10
    80202fa8:	a2478793          	addi	a5,a5,-1500 # 802129c8 <procs>
    80202fac:	0007a223          	sw	zero,4(a5)
    80202fb0:	00010797          	auipc	a5,0x10
    80202fb4:	a1878793          	addi	a5,a5,-1512 # 802129c8 <procs>
    80202fb8:	4709                	li	a4,2
    80202fba:	c798                	sw	a4,8(a5)
    80202fbc:	00005797          	auipc	a5,0x5
    80202fc0:	8f478793          	addi	a5,a5,-1804 # 802078b0 <user_code_end+0xa40>
    80202fc4:	fef43023          	sd	a5,-32(s0)
    80202fc8:	fe042423          	sw	zero,-24(s0)
    80202fcc:	a035                	j	80202ff8 <proc_init+0x122>
    80202fce:	fe842783          	lw	a5,-24(s0)
    80202fd2:	fe043703          	ld	a4,-32(s0)
    80202fd6:	97ba                	add	a5,a5,a4
    80202fd8:	0007c703          	lbu	a4,0(a5)
    80202fdc:	00010697          	auipc	a3,0x10
    80202fe0:	9ec68693          	addi	a3,a3,-1556 # 802129c8 <procs>
    80202fe4:	fe842783          	lw	a5,-24(s0)
    80202fe8:	97b6                	add	a5,a5,a3
    80202fea:	00e78623          	sb	a4,12(a5)
    80202fee:	fe842783          	lw	a5,-24(s0)
    80202ff2:	2785                	addiw	a5,a5,1
    80202ff4:	fef42423          	sw	a5,-24(s0)
    80202ff8:	fe842783          	lw	a5,-24(s0)
    80202ffc:	fe043703          	ld	a4,-32(s0)
    80203000:	97ba                	add	a5,a5,a4
    80203002:	0007c783          	lbu	a5,0(a5)
    80203006:	cb81                	beqz	a5,80203016 <proc_init+0x140>
    80203008:	fe842783          	lw	a5,-24(s0)
    8020300c:	0007871b          	sext.w	a4,a5
    80203010:	47b9                	li	a5,14
    80203012:	fae7dee3          	bge	a5,a4,80202fce <proc_init+0xf8>
    80203016:	00010717          	auipc	a4,0x10
    8020301a:	9b270713          	addi	a4,a4,-1614 # 802129c8 <procs>
    8020301e:	fe842783          	lw	a5,-24(s0)
    80203022:	97ba                	add	a5,a5,a4
    80203024:	00078623          	sb	zero,12(a5)
    80203028:	0000c797          	auipc	a5,0xc
    8020302c:	fdc78793          	addi	a5,a5,-36 # 8020f004 <proc_top>
    80203030:	4705                	li	a4,1
    80203032:	c398                	sw	a4,0(a5)
    80203034:	0001                	nop
    80203036:	60e2                	ld	ra,24(sp)
    80203038:	6442                	ld	s0,16(sp)
    8020303a:	6105                	addi	sp,sp,32
    8020303c:	8082                	ret

000000008020303e <proc_alloc>:
    8020303e:	7179                	addi	sp,sp,-48
    80203040:	f406                	sd	ra,40(sp)
    80203042:	f022                	sd	s0,32(sp)
    80203044:	1800                	addi	s0,sp,48
    80203046:	fca43c23          	sd	a0,-40(s0)
    8020304a:	87ae                	mv	a5,a1
    8020304c:	fcf42a23          	sw	a5,-44(s0)
    80203050:	4785                	li	a5,1
    80203052:	fef42623          	sw	a5,-20(s0)
    80203056:	aabd                	j	802031d4 <proc_alloc+0x196>
    80203058:	00010697          	auipc	a3,0x10
    8020305c:	97068693          	addi	a3,a3,-1680 # 802129c8 <procs>
    80203060:	fec42703          	lw	a4,-20(s0)
    80203064:	87ba                	mv	a5,a4
    80203066:	0786                	slli	a5,a5,0x1
    80203068:	97ba                	add	a5,a5,a4
    8020306a:	0792                	slli	a5,a5,0x4
    8020306c:	97b6                	add	a5,a5,a3
    8020306e:	479c                	lw	a5,8(a5)
    80203070:	14079c63          	bnez	a5,802031c8 <proc_alloc+0x18a>
    80203074:	0000c797          	auipc	a5,0xc
    80203078:	f9078793          	addi	a5,a5,-112 # 8020f004 <proc_top>
    8020307c:	4398                	lw	a4,0(a5)
    8020307e:	0017079b          	addiw	a5,a4,1
    80203082:	0007869b          	sext.w	a3,a5
    80203086:	0000c797          	auipc	a5,0xc
    8020308a:	f7e78793          	addi	a5,a5,-130 # 8020f004 <proc_top>
    8020308e:	c394                	sw	a3,0(a5)
    80203090:	00010617          	auipc	a2,0x10
    80203094:	93860613          	addi	a2,a2,-1736 # 802129c8 <procs>
    80203098:	fec42683          	lw	a3,-20(s0)
    8020309c:	87b6                	mv	a5,a3
    8020309e:	0786                	slli	a5,a5,0x1
    802030a0:	97b6                	add	a5,a5,a3
    802030a2:	0792                	slli	a5,a5,0x4
    802030a4:	97b2                	add	a5,a5,a2
    802030a6:	c398                	sw	a4,0(a5)
    802030a8:	00010697          	auipc	a3,0x10
    802030ac:	92068693          	addi	a3,a3,-1760 # 802129c8 <procs>
    802030b0:	fec42703          	lw	a4,-20(s0)
    802030b4:	87ba                	mv	a5,a4
    802030b6:	0786                	slli	a5,a5,0x1
    802030b8:	97ba                	add	a5,a5,a4
    802030ba:	0792                	slli	a5,a5,0x4
    802030bc:	97b6                	add	a5,a5,a3
    802030be:	fd442703          	lw	a4,-44(s0)
    802030c2:	c3d8                	sw	a4,4(a5)
    802030c4:	00010697          	auipc	a3,0x10
    802030c8:	90468693          	addi	a3,a3,-1788 # 802129c8 <procs>
    802030cc:	fec42703          	lw	a4,-20(s0)
    802030d0:	87ba                	mv	a5,a4
    802030d2:	0786                	slli	a5,a5,0x1
    802030d4:	97ba                	add	a5,a5,a4
    802030d6:	0792                	slli	a5,a5,0x4
    802030d8:	97b6                	add	a5,a5,a3
    802030da:	4705                	li	a4,1
    802030dc:	c798                	sw	a4,8(a5)
    802030de:	00010697          	auipc	a3,0x10
    802030e2:	8ea68693          	addi	a3,a3,-1814 # 802129c8 <procs>
    802030e6:	fec42703          	lw	a4,-20(s0)
    802030ea:	87ba                	mv	a5,a4
    802030ec:	0786                	slli	a5,a5,0x1
    802030ee:	97ba                	add	a5,a5,a4
    802030f0:	0792                	slli	a5,a5,0x4
    802030f2:	97b6                	add	a5,a5,a3
    802030f4:	0207b023          	sd	zero,32(a5)
    802030f8:	00010697          	auipc	a3,0x10
    802030fc:	8d068693          	addi	a3,a3,-1840 # 802129c8 <procs>
    80203100:	fec42703          	lw	a4,-20(s0)
    80203104:	87ba                	mv	a5,a4
    80203106:	0786                	slli	a5,a5,0x1
    80203108:	97ba                	add	a5,a5,a4
    8020310a:	0792                	slli	a5,a5,0x4
    8020310c:	97b6                	add	a5,a5,a3
    8020310e:	577d                	li	a4,-1
    80203110:	d798                	sw	a4,40(a5)
    80203112:	00010697          	auipc	a3,0x10
    80203116:	8b668693          	addi	a3,a3,-1866 # 802129c8 <procs>
    8020311a:	fec42703          	lw	a4,-20(s0)
    8020311e:	87ba                	mv	a5,a4
    80203120:	0786                	slli	a5,a5,0x1
    80203122:	97ba                	add	a5,a5,a4
    80203124:	0792                	slli	a5,a5,0x4
    80203126:	97b6                	add	a5,a5,a3
    80203128:	00078623          	sb	zero,12(a5)
    8020312c:	fd843783          	ld	a5,-40(s0)
    80203130:	cfbd                	beqz	a5,802031ae <proc_alloc+0x170>
    80203132:	fe042423          	sw	zero,-24(s0)
    80203136:	a82d                	j	80203170 <proc_alloc+0x132>
    80203138:	fe842783          	lw	a5,-24(s0)
    8020313c:	fd843703          	ld	a4,-40(s0)
    80203140:	97ba                	add	a5,a5,a4
    80203142:	0007c683          	lbu	a3,0(a5)
    80203146:	00010597          	auipc	a1,0x10
    8020314a:	88258593          	addi	a1,a1,-1918 # 802129c8 <procs>
    8020314e:	fe842603          	lw	a2,-24(s0)
    80203152:	fec42703          	lw	a4,-20(s0)
    80203156:	87ba                	mv	a5,a4
    80203158:	0786                	slli	a5,a5,0x1
    8020315a:	97ba                	add	a5,a5,a4
    8020315c:	0792                	slli	a5,a5,0x4
    8020315e:	97ae                	add	a5,a5,a1
    80203160:	97b2                	add	a5,a5,a2
    80203162:	00d78623          	sb	a3,12(a5)
    80203166:	fe842783          	lw	a5,-24(s0)
    8020316a:	2785                	addiw	a5,a5,1
    8020316c:	fef42423          	sw	a5,-24(s0)
    80203170:	fe842783          	lw	a5,-24(s0)
    80203174:	fd843703          	ld	a4,-40(s0)
    80203178:	97ba                	add	a5,a5,a4
    8020317a:	0007c783          	lbu	a5,0(a5)
    8020317e:	cb81                	beqz	a5,8020318e <proc_alloc+0x150>
    80203180:	fe842783          	lw	a5,-24(s0)
    80203184:	0007871b          	sext.w	a4,a5
    80203188:	47b9                	li	a5,14
    8020318a:	fae7d7e3          	bge	a5,a4,80203138 <proc_alloc+0xfa>
    8020318e:	00010617          	auipc	a2,0x10
    80203192:	83a60613          	addi	a2,a2,-1990 # 802129c8 <procs>
    80203196:	fe842683          	lw	a3,-24(s0)
    8020319a:	fec42703          	lw	a4,-20(s0)
    8020319e:	87ba                	mv	a5,a4
    802031a0:	0786                	slli	a5,a5,0x1
    802031a2:	97ba                	add	a5,a5,a4
    802031a4:	0792                	slli	a5,a5,0x4
    802031a6:	97b2                	add	a5,a5,a2
    802031a8:	97b6                	add	a5,a5,a3
    802031aa:	00078623          	sb	zero,12(a5)
    802031ae:	00010697          	auipc	a3,0x10
    802031b2:	81a68693          	addi	a3,a3,-2022 # 802129c8 <procs>
    802031b6:	fec42703          	lw	a4,-20(s0)
    802031ba:	87ba                	mv	a5,a4
    802031bc:	0786                	slli	a5,a5,0x1
    802031be:	97ba                	add	a5,a5,a4
    802031c0:	0792                	slli	a5,a5,0x4
    802031c2:	97b6                	add	a5,a5,a3
    802031c4:	439c                	lw	a5,0(a5)
    802031c6:	a839                	j	802031e4 <proc_alloc+0x1a6>
    802031c8:	0001                	nop
    802031ca:	fec42783          	lw	a5,-20(s0)
    802031ce:	2785                	addiw	a5,a5,1
    802031d0:	fef42623          	sw	a5,-20(s0)
    802031d4:	fec42783          	lw	a5,-20(s0)
    802031d8:	0007871b          	sext.w	a4,a5
    802031dc:	47bd                	li	a5,15
    802031de:	e6e7dde3          	bge	a5,a4,80203058 <proc_alloc+0x1a>
    802031e2:	57fd                	li	a5,-1
    802031e4:	853e                	mv	a0,a5
    802031e6:	70a2                	ld	ra,40(sp)
    802031e8:	7402                	ld	s0,32(sp)
    802031ea:	6145                	addi	sp,sp,48
    802031ec:	8082                	ret

00000000802031ee <proc_set_name>:
    802031ee:	7179                	addi	sp,sp,-48
    802031f0:	f406                	sd	ra,40(sp)
    802031f2:	f022                	sd	s0,32(sp)
    802031f4:	1800                	addi	s0,sp,48
    802031f6:	87aa                	mv	a5,a0
    802031f8:	fcb43823          	sd	a1,-48(s0)
    802031fc:	fcf42e23          	sw	a5,-36(s0)
    80203200:	fe042623          	sw	zero,-20(s0)
    80203204:	a855                	j	802032b8 <proc_set_name+0xca>
    80203206:	0000f697          	auipc	a3,0xf
    8020320a:	7c268693          	addi	a3,a3,1986 # 802129c8 <procs>
    8020320e:	fec42703          	lw	a4,-20(s0)
    80203212:	87ba                	mv	a5,a4
    80203214:	0786                	slli	a5,a5,0x1
    80203216:	97ba                	add	a5,a5,a4
    80203218:	0792                	slli	a5,a5,0x4
    8020321a:	97b6                	add	a5,a5,a3
    8020321c:	439c                	lw	a5,0(a5)
    8020321e:	fdc42703          	lw	a4,-36(s0)
    80203222:	2701                	sext.w	a4,a4
    80203224:	08f71463          	bne	a4,a5,802032ac <proc_set_name+0xbe>
    80203228:	fe042423          	sw	zero,-24(s0)
    8020322c:	a82d                	j	80203266 <proc_set_name+0x78>
    8020322e:	fe842783          	lw	a5,-24(s0)
    80203232:	fd043703          	ld	a4,-48(s0)
    80203236:	97ba                	add	a5,a5,a4
    80203238:	0007c683          	lbu	a3,0(a5)
    8020323c:	0000f597          	auipc	a1,0xf
    80203240:	78c58593          	addi	a1,a1,1932 # 802129c8 <procs>
    80203244:	fe842603          	lw	a2,-24(s0)
    80203248:	fec42703          	lw	a4,-20(s0)
    8020324c:	87ba                	mv	a5,a4
    8020324e:	0786                	slli	a5,a5,0x1
    80203250:	97ba                	add	a5,a5,a4
    80203252:	0792                	slli	a5,a5,0x4
    80203254:	97ae                	add	a5,a5,a1
    80203256:	97b2                	add	a5,a5,a2
    80203258:	00d78623          	sb	a3,12(a5)
    8020325c:	fe842783          	lw	a5,-24(s0)
    80203260:	2785                	addiw	a5,a5,1
    80203262:	fef42423          	sw	a5,-24(s0)
    80203266:	fd043783          	ld	a5,-48(s0)
    8020326a:	c385                	beqz	a5,8020328a <proc_set_name+0x9c>
    8020326c:	fe842783          	lw	a5,-24(s0)
    80203270:	fd043703          	ld	a4,-48(s0)
    80203274:	97ba                	add	a5,a5,a4
    80203276:	0007c783          	lbu	a5,0(a5)
    8020327a:	cb81                	beqz	a5,8020328a <proc_set_name+0x9c>
    8020327c:	fe842783          	lw	a5,-24(s0)
    80203280:	0007871b          	sext.w	a4,a5
    80203284:	47b9                	li	a5,14
    80203286:	fae7d4e3          	bge	a5,a4,8020322e <proc_set_name+0x40>
    8020328a:	0000f617          	auipc	a2,0xf
    8020328e:	73e60613          	addi	a2,a2,1854 # 802129c8 <procs>
    80203292:	fe842683          	lw	a3,-24(s0)
    80203296:	fec42703          	lw	a4,-20(s0)
    8020329a:	87ba                	mv	a5,a4
    8020329c:	0786                	slli	a5,a5,0x1
    8020329e:	97ba                	add	a5,a5,a4
    802032a0:	0792                	slli	a5,a5,0x4
    802032a2:	97b2                	add	a5,a5,a2
    802032a4:	97b6                	add	a5,a5,a3
    802032a6:	00078623          	sb	zero,12(a5)
    802032aa:	a831                	j	802032c6 <proc_set_name+0xd8>
    802032ac:	0001                	nop
    802032ae:	fec42783          	lw	a5,-20(s0)
    802032b2:	2785                	addiw	a5,a5,1
    802032b4:	fef42623          	sw	a5,-20(s0)
    802032b8:	fec42783          	lw	a5,-20(s0)
    802032bc:	0007871b          	sext.w	a4,a5
    802032c0:	47bd                	li	a5,15
    802032c2:	f4e7d2e3          	bge	a5,a4,80203206 <proc_set_name+0x18>
    802032c6:	70a2                	ld	ra,40(sp)
    802032c8:	7402                	ld	s0,32(sp)
    802032ca:	6145                	addi	sp,sp,48
    802032cc:	8082                	ret

00000000802032ce <proc_set_state>:
    802032ce:	7179                	addi	sp,sp,-48
    802032d0:	f406                	sd	ra,40(sp)
    802032d2:	f022                	sd	s0,32(sp)
    802032d4:	1800                	addi	s0,sp,48
    802032d6:	87aa                	mv	a5,a0
    802032d8:	872e                	mv	a4,a1
    802032da:	fcf42e23          	sw	a5,-36(s0)
    802032de:	87ba                	mv	a5,a4
    802032e0:	fcf42c23          	sw	a5,-40(s0)
    802032e4:	fe042623          	sw	zero,-20(s0)
    802032e8:	a0b1                	j	80203334 <proc_set_state+0x66>
    802032ea:	0000f697          	auipc	a3,0xf
    802032ee:	6de68693          	addi	a3,a3,1758 # 802129c8 <procs>
    802032f2:	fec42703          	lw	a4,-20(s0)
    802032f6:	87ba                	mv	a5,a4
    802032f8:	0786                	slli	a5,a5,0x1
    802032fa:	97ba                	add	a5,a5,a4
    802032fc:	0792                	slli	a5,a5,0x4
    802032fe:	97b6                	add	a5,a5,a3
    80203300:	439c                	lw	a5,0(a5)
    80203302:	fdc42703          	lw	a4,-36(s0)
    80203306:	2701                	sext.w	a4,a4
    80203308:	02f71163          	bne	a4,a5,8020332a <proc_set_state+0x5c>
    8020330c:	0000f697          	auipc	a3,0xf
    80203310:	6bc68693          	addi	a3,a3,1724 # 802129c8 <procs>
    80203314:	fec42703          	lw	a4,-20(s0)
    80203318:	87ba                	mv	a5,a4
    8020331a:	0786                	slli	a5,a5,0x1
    8020331c:	97ba                	add	a5,a5,a4
    8020331e:	0792                	slli	a5,a5,0x4
    80203320:	97b6                	add	a5,a5,a3
    80203322:	fd842703          	lw	a4,-40(s0)
    80203326:	c798                	sw	a4,8(a5)
    80203328:	a829                	j	80203342 <proc_set_state+0x74>
    8020332a:	fec42783          	lw	a5,-20(s0)
    8020332e:	2785                	addiw	a5,a5,1
    80203330:	fef42623          	sw	a5,-20(s0)
    80203334:	fec42783          	lw	a5,-20(s0)
    80203338:	0007871b          	sext.w	a4,a5
    8020333c:	47bd                	li	a5,15
    8020333e:	fae7d6e3          	bge	a5,a4,802032ea <proc_set_state+0x1c>
    80203342:	70a2                	ld	ra,40(sp)
    80203344:	7402                	ld	s0,32(sp)
    80203346:	6145                	addi	sp,sp,48
    80203348:	8082                	ret

000000008020334a <proc_current_pid>:
    8020334a:	1141                	addi	sp,sp,-16
    8020334c:	e406                	sd	ra,8(sp)
    8020334e:	e022                	sd	s0,0(sp)
    80203350:	0800                	addi	s0,sp,16
    80203352:	4781                	li	a5,0
    80203354:	853e                	mv	a0,a5
    80203356:	60a2                	ld	ra,8(sp)
    80203358:	6402                	ld	s0,0(sp)
    8020335a:	0141                	addi	sp,sp,16
    8020335c:	8082                	ret

000000008020335e <proc_count>:
    8020335e:	1101                	addi	sp,sp,-32
    80203360:	ec06                	sd	ra,24(sp)
    80203362:	e822                	sd	s0,16(sp)
    80203364:	1000                	addi	s0,sp,32
    80203366:	fe042423          	sw	zero,-24(s0)
    8020336a:	fe042623          	sw	zero,-20(s0)
    8020336e:	a805                	j	8020339e <proc_count+0x40>
    80203370:	0000f697          	auipc	a3,0xf
    80203374:	65868693          	addi	a3,a3,1624 # 802129c8 <procs>
    80203378:	fec42703          	lw	a4,-20(s0)
    8020337c:	87ba                	mv	a5,a4
    8020337e:	0786                	slli	a5,a5,0x1
    80203380:	97ba                	add	a5,a5,a4
    80203382:	0792                	slli	a5,a5,0x4
    80203384:	97b6                	add	a5,a5,a3
    80203386:	479c                	lw	a5,8(a5)
    80203388:	c791                	beqz	a5,80203394 <proc_count+0x36>
    8020338a:	fe842783          	lw	a5,-24(s0)
    8020338e:	2785                	addiw	a5,a5,1
    80203390:	fef42423          	sw	a5,-24(s0)
    80203394:	fec42783          	lw	a5,-20(s0)
    80203398:	2785                	addiw	a5,a5,1
    8020339a:	fef42623          	sw	a5,-20(s0)
    8020339e:	fec42783          	lw	a5,-20(s0)
    802033a2:	0007871b          	sext.w	a4,a5
    802033a6:	47bd                	li	a5,15
    802033a8:	fce7d4e3          	bge	a5,a4,80203370 <proc_count+0x12>
    802033ac:	fe842783          	lw	a5,-24(s0)
    802033b0:	853e                	mv	a0,a5
    802033b2:	60e2                	ld	ra,24(sp)
    802033b4:	6442                	ld	s0,16(sp)
    802033b6:	6105                	addi	sp,sp,32
    802033b8:	8082                	ret

00000000802033ba <proc_list>:
    802033ba:	7179                	addi	sp,sp,-48
    802033bc:	f406                	sd	ra,40(sp)
    802033be:	f022                	sd	s0,32(sp)
    802033c0:	1800                	addi	s0,sp,48
    802033c2:	fca43c23          	sd	a0,-40(s0)
    802033c6:	87ae                	mv	a5,a1
    802033c8:	fcf42a23          	sw	a5,-44(s0)
    802033cc:	fe042423          	sw	zero,-24(s0)
    802033d0:	fe042623          	sw	zero,-20(s0)
    802033d4:	a295                	j	80203538 <proc_list+0x17e>
    802033d6:	0000f697          	auipc	a3,0xf
    802033da:	5f268693          	addi	a3,a3,1522 # 802129c8 <procs>
    802033de:	fec42703          	lw	a4,-20(s0)
    802033e2:	87ba                	mv	a5,a4
    802033e4:	0786                	slli	a5,a5,0x1
    802033e6:	97ba                	add	a5,a5,a4
    802033e8:	0792                	slli	a5,a5,0x4
    802033ea:	97b6                	add	a5,a5,a3
    802033ec:	479c                	lw	a5,8(a5)
    802033ee:	12078f63          	beqz	a5,8020352c <proc_list+0x172>
    802033f2:	fe842703          	lw	a4,-24(s0)
    802033f6:	87ba                	mv	a5,a4
    802033f8:	078e                	slli	a5,a5,0x3
    802033fa:	8f99                	sub	a5,a5,a4
    802033fc:	078a                	slli	a5,a5,0x2
    802033fe:	873e                	mv	a4,a5
    80203400:	fd843783          	ld	a5,-40(s0)
    80203404:	00e786b3          	add	a3,a5,a4
    80203408:	0000f617          	auipc	a2,0xf
    8020340c:	5c060613          	addi	a2,a2,1472 # 802129c8 <procs>
    80203410:	fec42703          	lw	a4,-20(s0)
    80203414:	87ba                	mv	a5,a4
    80203416:	0786                	slli	a5,a5,0x1
    80203418:	97ba                	add	a5,a5,a4
    8020341a:	0792                	slli	a5,a5,0x4
    8020341c:	97b2                	add	a5,a5,a2
    8020341e:	439c                	lw	a5,0(a5)
    80203420:	c29c                	sw	a5,0(a3)
    80203422:	fe842703          	lw	a4,-24(s0)
    80203426:	87ba                	mv	a5,a4
    80203428:	078e                	slli	a5,a5,0x3
    8020342a:	8f99                	sub	a5,a5,a4
    8020342c:	078a                	slli	a5,a5,0x2
    8020342e:	873e                	mv	a4,a5
    80203430:	fd843783          	ld	a5,-40(s0)
    80203434:	00e786b3          	add	a3,a5,a4
    80203438:	0000f617          	auipc	a2,0xf
    8020343c:	59060613          	addi	a2,a2,1424 # 802129c8 <procs>
    80203440:	fec42703          	lw	a4,-20(s0)
    80203444:	87ba                	mv	a5,a4
    80203446:	0786                	slli	a5,a5,0x1
    80203448:	97ba                	add	a5,a5,a4
    8020344a:	0792                	slli	a5,a5,0x4
    8020344c:	97b2                	add	a5,a5,a2
    8020344e:	43dc                	lw	a5,4(a5)
    80203450:	c2dc                	sw	a5,4(a3)
    80203452:	fe842703          	lw	a4,-24(s0)
    80203456:	87ba                	mv	a5,a4
    80203458:	078e                	slli	a5,a5,0x3
    8020345a:	8f99                	sub	a5,a5,a4
    8020345c:	078a                	slli	a5,a5,0x2
    8020345e:	873e                	mv	a4,a5
    80203460:	fd843783          	ld	a5,-40(s0)
    80203464:	00e786b3          	add	a3,a5,a4
    80203468:	0000f617          	auipc	a2,0xf
    8020346c:	56060613          	addi	a2,a2,1376 # 802129c8 <procs>
    80203470:	fec42703          	lw	a4,-20(s0)
    80203474:	87ba                	mv	a5,a4
    80203476:	0786                	slli	a5,a5,0x1
    80203478:	97ba                	add	a5,a5,a4
    8020347a:	0792                	slli	a5,a5,0x4
    8020347c:	97b2                	add	a5,a5,a2
    8020347e:	479c                	lw	a5,8(a5)
    80203480:	c69c                	sw	a5,8(a3)
    80203482:	fe042223          	sw	zero,-28(s0)
    80203486:	a0b1                	j	802034d2 <proc_list+0x118>
    80203488:	fe842703          	lw	a4,-24(s0)
    8020348c:	87ba                	mv	a5,a4
    8020348e:	078e                	slli	a5,a5,0x3
    80203490:	8f99                	sub	a5,a5,a4
    80203492:	078a                	slli	a5,a5,0x2
    80203494:	873e                	mv	a4,a5
    80203496:	fd843783          	ld	a5,-40(s0)
    8020349a:	00e786b3          	add	a3,a5,a4
    8020349e:	0000f597          	auipc	a1,0xf
    802034a2:	52a58593          	addi	a1,a1,1322 # 802129c8 <procs>
    802034a6:	fe442603          	lw	a2,-28(s0)
    802034aa:	fec42703          	lw	a4,-20(s0)
    802034ae:	87ba                	mv	a5,a4
    802034b0:	0786                	slli	a5,a5,0x1
    802034b2:	97ba                	add	a5,a5,a4
    802034b4:	0792                	slli	a5,a5,0x4
    802034b6:	97ae                	add	a5,a5,a1
    802034b8:	97b2                	add	a5,a5,a2
    802034ba:	00c7c703          	lbu	a4,12(a5)
    802034be:	fe442783          	lw	a5,-28(s0)
    802034c2:	97b6                	add	a5,a5,a3
    802034c4:	00e78623          	sb	a4,12(a5)
    802034c8:	fe442783          	lw	a5,-28(s0)
    802034cc:	2785                	addiw	a5,a5,1
    802034ce:	fef42223          	sw	a5,-28(s0)
    802034d2:	0000f617          	auipc	a2,0xf
    802034d6:	4f660613          	addi	a2,a2,1270 # 802129c8 <procs>
    802034da:	fe442683          	lw	a3,-28(s0)
    802034de:	fec42703          	lw	a4,-20(s0)
    802034e2:	87ba                	mv	a5,a4
    802034e4:	0786                	slli	a5,a5,0x1
    802034e6:	97ba                	add	a5,a5,a4
    802034e8:	0792                	slli	a5,a5,0x4
    802034ea:	97b2                	add	a5,a5,a2
    802034ec:	97b6                	add	a5,a5,a3
    802034ee:	00c7c783          	lbu	a5,12(a5)
    802034f2:	cb81                	beqz	a5,80203502 <proc_list+0x148>
    802034f4:	fe442783          	lw	a5,-28(s0)
    802034f8:	0007871b          	sext.w	a4,a5
    802034fc:	47b9                	li	a5,14
    802034fe:	f8e7d5e3          	bge	a5,a4,80203488 <proc_list+0xce>
    80203502:	fe842703          	lw	a4,-24(s0)
    80203506:	87ba                	mv	a5,a4
    80203508:	078e                	slli	a5,a5,0x3
    8020350a:	8f99                	sub	a5,a5,a4
    8020350c:	078a                	slli	a5,a5,0x2
    8020350e:	873e                	mv	a4,a5
    80203510:	fd843783          	ld	a5,-40(s0)
    80203514:	973e                	add	a4,a4,a5
    80203516:	fe442783          	lw	a5,-28(s0)
    8020351a:	97ba                	add	a5,a5,a4
    8020351c:	00078623          	sb	zero,12(a5)
    80203520:	fe842783          	lw	a5,-24(s0)
    80203524:	2785                	addiw	a5,a5,1
    80203526:	fef42423          	sw	a5,-24(s0)
    8020352a:	a011                	j	8020352e <proc_list+0x174>
    8020352c:	0001                	nop
    8020352e:	fec42783          	lw	a5,-20(s0)
    80203532:	2785                	addiw	a5,a5,1
    80203534:	fef42623          	sw	a5,-20(s0)
    80203538:	fec42783          	lw	a5,-20(s0)
    8020353c:	0007871b          	sext.w	a4,a5
    80203540:	47bd                	li	a5,15
    80203542:	00e7cb63          	blt	a5,a4,80203558 <proc_list+0x19e>
    80203546:	fe842783          	lw	a5,-24(s0)
    8020354a:	873e                	mv	a4,a5
    8020354c:	fd442783          	lw	a5,-44(s0)
    80203550:	2701                	sext.w	a4,a4
    80203552:	2781                	sext.w	a5,a5
    80203554:	e8f741e3          	blt	a4,a5,802033d6 <proc_list+0x1c>
    80203558:	fe842783          	lw	a5,-24(s0)
    8020355c:	853e                	mv	a0,a5
    8020355e:	70a2                	ld	ra,40(sp)
    80203560:	7402                	ld	s0,32(sp)
    80203562:	6145                	addi	sp,sp,48
    80203564:	8082                	ret

0000000080203566 <proc_mark_zombie>:
    80203566:	1101                	addi	sp,sp,-32
    80203568:	ec06                	sd	ra,24(sp)
    8020356a:	e822                	sd	s0,16(sp)
    8020356c:	1000                	addi	s0,sp,32
    8020356e:	87aa                	mv	a5,a0
    80203570:	fef42623          	sw	a5,-20(s0)
    80203574:	fec42783          	lw	a5,-20(s0)
    80203578:	458d                	li	a1,3
    8020357a:	853e                	mv	a0,a5
    8020357c:	d53ff0ef          	jal	802032ce <proc_set_state>
    80203580:	0001                	nop
    80203582:	60e2                	ld	ra,24(sp)
    80203584:	6442                	ld	s0,16(sp)
    80203586:	6105                	addi	sp,sp,32
    80203588:	8082                	ret

000000008020358a <spawn_trampoline>:
    8020358a:	1141                	addi	sp,sp,-16
    8020358c:	e406                	sd	ra,8(sp)
    8020358e:	e022                	sd	s0,0(sp)
    80203590:	0800                	addi	s0,sp,16
    80203592:	0000f797          	auipc	a5,0xf
    80203596:	73678793          	addi	a5,a5,1846 # 80212cc8 <spawn_entry>
    8020359a:	639c                	ld	a5,0(a5)
    8020359c:	c799                	beqz	a5,802035aa <spawn_trampoline+0x20>
    8020359e:	0000f797          	auipc	a5,0xf
    802035a2:	72a78793          	addi	a5,a5,1834 # 80212cc8 <spawn_entry>
    802035a6:	639c                	ld	a5,0(a5)
    802035a8:	9782                	jalr	a5
    802035aa:	0000f797          	auipc	a5,0xf
    802035ae:	72678793          	addi	a5,a5,1830 # 80212cd0 <spawn_pid>
    802035b2:	439c                	lw	a5,0(a5)
    802035b4:	853e                	mv	a0,a5
    802035b6:	fb1ff0ef          	jal	80203566 <proc_mark_zombie>
    802035ba:	10500073          	wfi
    802035be:	bff5                	j	802035ba <spawn_trampoline+0x30>

00000000802035c0 <proc_spawn>:
    802035c0:	7179                	addi	sp,sp,-48
    802035c2:	f406                	sd	ra,40(sp)
    802035c4:	f022                	sd	s0,32(sp)
    802035c6:	1800                	addi	s0,sp,48
    802035c8:	fca43c23          	sd	a0,-40(s0)
    802035cc:	fcb43823          	sd	a1,-48(s0)
    802035d0:	4581                	li	a1,0
    802035d2:	fd843503          	ld	a0,-40(s0)
    802035d6:	a69ff0ef          	jal	8020303e <proc_alloc>
    802035da:	87aa                	mv	a5,a0
    802035dc:	fef42623          	sw	a5,-20(s0)
    802035e0:	fec42783          	lw	a5,-20(s0)
    802035e4:	2781                	sext.w	a5,a5
    802035e6:	0007d463          	bgez	a5,802035ee <proc_spawn+0x2e>
    802035ea:	57fd                	li	a5,-1
    802035ec:	a0b9                	j	8020363a <proc_spawn+0x7a>
    802035ee:	0000f797          	auipc	a5,0xf
    802035f2:	6e278793          	addi	a5,a5,1762 # 80212cd0 <spawn_pid>
    802035f6:	fec42703          	lw	a4,-20(s0)
    802035fa:	c398                	sw	a4,0(a5)
    802035fc:	0000f797          	auipc	a5,0xf
    80203600:	6cc78793          	addi	a5,a5,1740 # 80212cc8 <spawn_entry>
    80203604:	fd043703          	ld	a4,-48(s0)
    80203608:	e398                	sd	a4,0(a5)
    8020360a:	00000517          	auipc	a0,0x0
    8020360e:	f8050513          	addi	a0,a0,-128 # 8020358a <spawn_trampoline>
    80203612:	ee4ff0ef          	jal	80202cf6 <task_create>
    80203616:	87aa                	mv	a5,a0
    80203618:	cb89                	beqz	a5,8020362a <proc_spawn+0x6a>
    8020361a:	fec42783          	lw	a5,-20(s0)
    8020361e:	4581                	li	a1,0
    80203620:	853e                	mv	a0,a5
    80203622:	cadff0ef          	jal	802032ce <proc_set_state>
    80203626:	57fd                	li	a5,-1
    80203628:	a809                	j	8020363a <proc_spawn+0x7a>
    8020362a:	fec42783          	lw	a5,-20(s0)
    8020362e:	4585                	li	a1,1
    80203630:	853e                	mv	a0,a5
    80203632:	c9dff0ef          	jal	802032ce <proc_set_state>
    80203636:	fec42783          	lw	a5,-20(s0)
    8020363a:	853e                	mv	a0,a5
    8020363c:	70a2                	ld	ra,40(sp)
    8020363e:	7402                	ld	s0,32(sp)
    80203640:	6145                	addi	sp,sp,48
    80203642:	8082                	ret

0000000080203644 <proc_run_binary>:
    80203644:	7139                	addi	sp,sp,-64
    80203646:	fc06                	sd	ra,56(sp)
    80203648:	f822                	sd	s0,48(sp)
    8020364a:	0080                	addi	s0,sp,64
    8020364c:	fca43c23          	sd	a0,-40(s0)
    80203650:	fcb43823          	sd	a1,-48(s0)
    80203654:	fcc43423          	sd	a2,-56(s0)
    80203658:	4581                	li	a1,0
    8020365a:	fd843503          	ld	a0,-40(s0)
    8020365e:	9e1ff0ef          	jal	8020303e <proc_alloc>
    80203662:	87aa                	mv	a5,a0
    80203664:	fef42623          	sw	a5,-20(s0)
    80203668:	fec42783          	lw	a5,-20(s0)
    8020366c:	2781                	sext.w	a5,a5
    8020366e:	0207cd63          	bltz	a5,802036a8 <proc_run_binary+0x64>
    80203672:	0000f797          	auipc	a5,0xf
    80203676:	65e78793          	addi	a5,a5,1630 # 80212cd0 <spawn_pid>
    8020367a:	fec42703          	lw	a4,-20(s0)
    8020367e:	c398                	sw	a4,0(a5)
    80203680:	fd043703          	ld	a4,-48(s0)
    80203684:	0000f797          	auipc	a5,0xf
    80203688:	64478793          	addi	a5,a5,1604 # 80212cc8 <spawn_entry>
    8020368c:	e398                	sd	a4,0(a5)
    8020368e:	00000517          	auipc	a0,0x0
    80203692:	efc50513          	addi	a0,a0,-260 # 8020358a <spawn_trampoline>
    80203696:	e60ff0ef          	jal	80202cf6 <task_create>
    8020369a:	fec42783          	lw	a5,-20(s0)
    8020369e:	4589                	li	a1,2
    802036a0:	853e                	mv	a0,a5
    802036a2:	c2dff0ef          	jal	802032ce <proc_set_state>
    802036a6:	a011                	j	802036aa <proc_run_binary+0x66>
    802036a8:	0001                	nop
    802036aa:	70e2                	ld	ra,56(sp)
    802036ac:	7442                	ld	s0,48(sp)
    802036ae:	6121                	addi	sp,sp,64
    802036b0:	8082                	ret

00000000802036b2 <proc_spawn_worker_demo>:
    802036b2:	1141                	addi	sp,sp,-16
    802036b4:	e406                	sd	ra,8(sp)
    802036b6:	e022                	sd	s0,0(sp)
    802036b8:	0800                	addi	s0,sp,16
    802036ba:	00000597          	auipc	a1,0x0
    802036be:	01e58593          	addi	a1,a1,30 # 802036d8 <worker_demo>
    802036c2:	00004517          	auipc	a0,0x4
    802036c6:	1f650513          	addi	a0,a0,502 # 802078b8 <user_code_end+0xa48>
    802036ca:	ef7ff0ef          	jal	802035c0 <proc_spawn>
    802036ce:	0001                	nop
    802036d0:	60a2                	ld	ra,8(sp)
    802036d2:	6402                	ld	s0,0(sp)
    802036d4:	0141                	addi	sp,sp,16
    802036d6:	8082                	ret

00000000802036d8 <worker_demo>:
    802036d8:	1101                	addi	sp,sp,-32
    802036da:	ec06                	sd	ra,24(sp)
    802036dc:	e822                	sd	s0,16(sp)
    802036de:	1000                	addi	s0,sp,32
    802036e0:	fe042623          	sw	zero,-20(s0)
    802036e4:	a81d                	j	8020371a <worker_demo+0x42>
    802036e6:	0000f797          	auipc	a5,0xf
    802036ea:	5ea78793          	addi	a5,a5,1514 # 80212cd0 <spawn_pid>
    802036ee:	439c                	lw	a5,0(a5)
    802036f0:	fec42703          	lw	a4,-20(s0)
    802036f4:	2705                	addiw	a4,a4,1
    802036f6:	2701                	sext.w	a4,a4
    802036f8:	863a                	mv	a2,a4
    802036fa:	85be                	mv	a1,a5
    802036fc:	00004517          	auipc	a0,0x4
    80203700:	1c450513          	addi	a0,a0,452 # 802078c0 <user_code_end+0xa50>
    80203704:	d33fd0ef          	jal	80201436 <printf>
    80203708:	7d000513          	li	a0,2000
    8020370c:	ed6ff0ef          	jal	80202de2 <task_delay>
    80203710:	fec42783          	lw	a5,-20(s0)
    80203714:	2785                	addiw	a5,a5,1
    80203716:	fef42623          	sw	a5,-20(s0)
    8020371a:	fec42783          	lw	a5,-20(s0)
    8020371e:	0007871b          	sext.w	a4,a5
    80203722:	4789                	li	a5,2
    80203724:	fce7d1e3          	bge	a5,a4,802036e6 <worker_demo+0xe>
    80203728:	0000f797          	auipc	a5,0xf
    8020372c:	5a878793          	addi	a5,a5,1448 # 80212cd0 <spawn_pid>
    80203730:	439c                	lw	a5,0(a5)
    80203732:	85be                	mv	a1,a5
    80203734:	00004517          	auipc	a0,0x4
    80203738:	1ac50513          	addi	a0,a0,428 # 802078e0 <user_code_end+0xa70>
    8020373c:	cfbfd0ef          	jal	80201436 <printf>
    80203740:	0001                	nop
    80203742:	60e2                	ld	ra,24(sp)
    80203744:	6442                	ld	s0,16(sp)
    80203746:	6105                	addi	sp,sp,32
    80203748:	8082                	ret

000000008020374a <r_tp>:
    8020374a:	1101                	addi	sp,sp,-32
    8020374c:	ec06                	sd	ra,24(sp)
    8020374e:	e822                	sd	s0,16(sp)
    80203750:	1000                	addi	s0,sp,32
    80203752:	8792                	mv	a5,tp
    80203754:	fef43423          	sd	a5,-24(s0)
    80203758:	fe843783          	ld	a5,-24(s0)
    8020375c:	853e                	mv	a0,a5
    8020375e:	60e2                	ld	ra,24(sp)
    80203760:	6442                	ld	s0,16(sp)
    80203762:	6105                	addi	sp,sp,32
    80203764:	8082                	ret

0000000080203766 <r_mhartid>:
    80203766:	1141                	addi	sp,sp,-16
    80203768:	e406                	sd	ra,8(sp)
    8020376a:	e022                	sd	s0,0(sp)
    8020376c:	0800                	addi	s0,sp,16
    8020376e:	fddff0ef          	jal	8020374a <r_tp>
    80203772:	87aa                	mv	a5,a0
    80203774:	853e                	mv	a0,a5
    80203776:	60a2                	ld	ra,8(sp)
    80203778:	6402                	ld	s0,0(sp)
    8020377a:	0141                	addi	sp,sp,16
    8020377c:	8082                	ret

000000008020377e <sys_open>:
    8020377e:	1101                	addi	sp,sp,-32
    80203780:	ec06                	sd	ra,24(sp)
    80203782:	e822                	sd	s0,16(sp)
    80203784:	1000                	addi	s0,sp,32
    80203786:	fea43423          	sd	a0,-24(s0)
    8020378a:	87ae                	mv	a5,a1
    8020378c:	fef42223          	sw	a5,-28(s0)
    80203790:	fe442783          	lw	a5,-28(s0)
    80203794:	85be                	mv	a1,a5
    80203796:	fe843503          	ld	a0,-24(s0)
    8020379a:	6c2010ef          	jal	80204e5c <fs_open>
    8020379e:	87aa                	mv	a5,a0
    802037a0:	853e                	mv	a0,a5
    802037a2:	60e2                	ld	ra,24(sp)
    802037a4:	6442                	ld	s0,16(sp)
    802037a6:	6105                	addi	sp,sp,32
    802037a8:	8082                	ret

00000000802037aa <sys_close>:
    802037aa:	1101                	addi	sp,sp,-32
    802037ac:	ec06                	sd	ra,24(sp)
    802037ae:	e822                	sd	s0,16(sp)
    802037b0:	1000                	addi	s0,sp,32
    802037b2:	87aa                	mv	a5,a0
    802037b4:	fef42623          	sw	a5,-20(s0)
    802037b8:	fec42783          	lw	a5,-20(s0)
    802037bc:	853e                	mv	a0,a5
    802037be:	32f010ef          	jal	802052ec <fs_close>
    802037c2:	87aa                	mv	a5,a0
    802037c4:	853e                	mv	a0,a5
    802037c6:	60e2                	ld	ra,24(sp)
    802037c8:	6442                	ld	s0,16(sp)
    802037ca:	6105                	addi	sp,sp,32
    802037cc:	8082                	ret

00000000802037ce <sys_write>:
    802037ce:	7179                	addi	sp,sp,-48
    802037d0:	f406                	sd	ra,40(sp)
    802037d2:	f022                	sd	s0,32(sp)
    802037d4:	1800                	addi	s0,sp,48
    802037d6:	87aa                	mv	a5,a0
    802037d8:	fcb43823          	sd	a1,-48(s0)
    802037dc:	8732                	mv	a4,a2
    802037de:	fcf42e23          	sw	a5,-36(s0)
    802037e2:	87ba                	mv	a5,a4
    802037e4:	fcf42c23          	sw	a5,-40(s0)
    802037e8:	fd043783          	ld	a5,-48(s0)
    802037ec:	c791                	beqz	a5,802037f8 <sys_write+0x2a>
    802037ee:	fd842783          	lw	a5,-40(s0)
    802037f2:	2781                	sext.w	a5,a5
    802037f4:	0007d463          	bgez	a5,802037fc <sys_write+0x2e>
    802037f8:	57fd                	li	a5,-1
    802037fa:	a885                	j	8020386a <sys_write+0x9c>
    802037fc:	fdc42783          	lw	a5,-36(s0)
    80203800:	0007871b          	sext.w	a4,a5
    80203804:	4785                	li	a5,1
    80203806:	00f70963          	beq	a4,a5,80203818 <sys_write+0x4a>
    8020380a:	fdc42783          	lw	a5,-36(s0)
    8020380e:	0007871b          	sext.w	a4,a5
    80203812:	4789                	li	a5,2
    80203814:	04f71063          	bne	a4,a5,80203854 <sys_write+0x86>
    80203818:	fe042623          	sw	zero,-20(s0)
    8020381c:	a005                	j	8020383c <sys_write+0x6e>
    8020381e:	fec42783          	lw	a5,-20(s0)
    80203822:	fd043703          	ld	a4,-48(s0)
    80203826:	97ba                	add	a5,a5,a4
    80203828:	0007c783          	lbu	a5,0(a5)
    8020382c:	853e                	mv	a0,a5
    8020382e:	9d8fd0ef          	jal	80200a06 <uart_putc>
    80203832:	fec42783          	lw	a5,-20(s0)
    80203836:	2785                	addiw	a5,a5,1
    80203838:	fef42623          	sw	a5,-20(s0)
    8020383c:	fec42783          	lw	a5,-20(s0)
    80203840:	873e                	mv	a4,a5
    80203842:	fd842783          	lw	a5,-40(s0)
    80203846:	2701                	sext.w	a4,a4
    80203848:	2781                	sext.w	a5,a5
    8020384a:	fcf74ae3          	blt	a4,a5,8020381e <sys_write+0x50>
    8020384e:	fec42783          	lw	a5,-20(s0)
    80203852:	a821                	j	8020386a <sys_write+0x9c>
    80203854:	fd842703          	lw	a4,-40(s0)
    80203858:	fdc42783          	lw	a5,-36(s0)
    8020385c:	863a                	mv	a2,a4
    8020385e:	fd043583          	ld	a1,-48(s0)
    80203862:	853e                	mv	a0,a5
    80203864:	08f010ef          	jal	802050f2 <fs_write>
    80203868:	87aa                	mv	a5,a0
    8020386a:	853e                	mv	a0,a5
    8020386c:	70a2                	ld	ra,40(sp)
    8020386e:	7402                	ld	s0,32(sp)
    80203870:	6145                	addi	sp,sp,48
    80203872:	8082                	ret

0000000080203874 <sys_read>:
    80203874:	1101                	addi	sp,sp,-32
    80203876:	ec06                	sd	ra,24(sp)
    80203878:	e822                	sd	s0,16(sp)
    8020387a:	1000                	addi	s0,sp,32
    8020387c:	87aa                	mv	a5,a0
    8020387e:	feb43023          	sd	a1,-32(s0)
    80203882:	8732                	mv	a4,a2
    80203884:	fef42623          	sw	a5,-20(s0)
    80203888:	87ba                	mv	a5,a4
    8020388a:	fef42423          	sw	a5,-24(s0)
    8020388e:	fe043783          	ld	a5,-32(s0)
    80203892:	c791                	beqz	a5,8020389e <sys_read+0x2a>
    80203894:	fe842783          	lw	a5,-24(s0)
    80203898:	2781                	sext.w	a5,a5
    8020389a:	00f04463          	bgtz	a5,802038a2 <sys_read+0x2e>
    8020389e:	57fd                	li	a5,-1
    802038a0:	a80d                	j	802038d2 <sys_read+0x5e>
    802038a2:	fec42783          	lw	a5,-20(s0)
    802038a6:	2781                	sext.w	a5,a5
    802038a8:	eb91                	bnez	a5,802038bc <sys_read+0x48>
    802038aa:	fe842783          	lw	a5,-24(s0)
    802038ae:	85be                	mv	a1,a5
    802038b0:	fe043503          	ld	a0,-32(s0)
    802038b4:	a68fd0ef          	jal	80200b1c <uart_read_buf>
    802038b8:	87aa                	mv	a5,a0
    802038ba:	a821                	j	802038d2 <sys_read+0x5e>
    802038bc:	fe842703          	lw	a4,-24(s0)
    802038c0:	fec42783          	lw	a5,-20(s0)
    802038c4:	863a                	mv	a2,a4
    802038c6:	fe043583          	ld	a1,-32(s0)
    802038ca:	853e                	mv	a0,a5
    802038cc:	70a010ef          	jal	80204fd6 <fs_read>
    802038d0:	87aa                	mv	a5,a0
    802038d2:	853e                	mv	a0,a5
    802038d4:	60e2                	ld	ra,24(sp)
    802038d6:	6442                	ld	s0,16(sp)
    802038d8:	6105                	addi	sp,sp,32
    802038da:	8082                	ret

00000000802038dc <sys_fork>:
    802038dc:	1141                	addi	sp,sp,-16
    802038de:	e406                	sd	ra,8(sp)
    802038e0:	e022                	sd	s0,0(sp)
    802038e2:	0800                	addi	s0,sp,16
    802038e4:	fda00793          	li	a5,-38
    802038e8:	853e                	mv	a0,a5
    802038ea:	60a2                	ld	ra,8(sp)
    802038ec:	6402                	ld	s0,0(sp)
    802038ee:	0141                	addi	sp,sp,16
    802038f0:	8082                	ret

00000000802038f2 <sys_gethid>:
    802038f2:	1101                	addi	sp,sp,-32
    802038f4:	ec06                	sd	ra,24(sp)
    802038f6:	e822                	sd	s0,16(sp)
    802038f8:	1000                	addi	s0,sp,32
    802038fa:	fea43423          	sd	a0,-24(s0)
    802038fe:	fe843783          	ld	a5,-24(s0)
    80203902:	e399                	bnez	a5,80203908 <sys_gethid+0x16>
    80203904:	57fd                	li	a5,-1
    80203906:	a811                	j	8020391a <sys_gethid+0x28>
    80203908:	e5fff0ef          	jal	80203766 <r_mhartid>
    8020390c:	87aa                	mv	a5,a0
    8020390e:	0007871b          	sext.w	a4,a5
    80203912:	fe843783          	ld	a5,-24(s0)
    80203916:	c398                	sw	a4,0(a5)
    80203918:	4781                	li	a5,0
    8020391a:	853e                	mv	a0,a5
    8020391c:	60e2                	ld	ra,24(sp)
    8020391e:	6442                	ld	s0,16(sp)
    80203920:	6105                	addi	sp,sp,32
    80203922:	8082                	ret

0000000080203924 <do_syscall>:
    80203924:	7179                	addi	sp,sp,-48
    80203926:	f406                	sd	ra,40(sp)
    80203928:	f022                	sd	s0,32(sp)
    8020392a:	1800                	addi	s0,sp,48
    8020392c:	fca43c23          	sd	a0,-40(s0)
    80203930:	fd843783          	ld	a5,-40(s0)
    80203934:	63dc                	ld	a5,128(a5)
    80203936:	fef42423          	sw	a5,-24(s0)
    8020393a:	fda00793          	li	a5,-38
    8020393e:	fef42623          	sw	a5,-20(s0)
    80203942:	fe842783          	lw	a5,-24(s0)
    80203946:	0007871b          	sext.w	a4,a5
    8020394a:	40100793          	li	a5,1025
    8020394e:	12f70463          	beq	a4,a5,80203a76 <do_syscall+0x152>
    80203952:	fe842783          	lw	a5,-24(s0)
    80203956:	0007871b          	sext.w	a4,a5
    8020395a:	40100793          	li	a5,1025
    8020395e:	1ee7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    80203962:	fe842783          	lw	a5,-24(s0)
    80203966:	0007871b          	sext.w	a4,a5
    8020396a:	40000793          	li	a5,1024
    8020396e:	0ef70463          	beq	a4,a5,80203a56 <do_syscall+0x132>
    80203972:	fe842783          	lw	a5,-24(s0)
    80203976:	0007871b          	sext.w	a4,a5
    8020397a:	40000793          	li	a5,1024
    8020397e:	1ce7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    80203982:	fe842783          	lw	a5,-24(s0)
    80203986:	0007871b          	sext.w	a4,a5
    8020398a:	3e900793          	li	a5,1001
    8020398e:	1af70d63          	beq	a4,a5,80203b48 <do_syscall+0x224>
    80203992:	fe842783          	lw	a5,-24(s0)
    80203996:	0007871b          	sext.w	a4,a5
    8020399a:	3e900793          	li	a5,1001
    8020399e:	1ae7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    802039a2:	fe842783          	lw	a5,-24(s0)
    802039a6:	0007871b          	sext.w	a4,a5
    802039aa:	3e800793          	li	a5,1000
    802039ae:	16f70263          	beq	a4,a5,80203b12 <do_syscall+0x1ee>
    802039b2:	fe842783          	lw	a5,-24(s0)
    802039b6:	0007871b          	sext.w	a4,a5
    802039ba:	3e800793          	li	a5,1000
    802039be:	18e7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    802039c2:	fe842783          	lw	a5,-24(s0)
    802039c6:	0007871b          	sext.w	a4,a5
    802039ca:	0d600793          	li	a5,214
    802039ce:	10f70e63          	beq	a4,a5,80203aea <do_syscall+0x1c6>
    802039d2:	fe842783          	lw	a5,-24(s0)
    802039d6:	0007871b          	sext.w	a4,a5
    802039da:	0d600793          	li	a5,214
    802039de:	16e7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    802039e2:	fe842783          	lw	a5,-24(s0)
    802039e6:	0007871b          	sext.w	a4,a5
    802039ea:	05d00793          	li	a5,93
    802039ee:	0ef70b63          	beq	a4,a5,80203ae4 <do_syscall+0x1c0>
    802039f2:	fe842783          	lw	a5,-24(s0)
    802039f6:	0007871b          	sext.w	a4,a5
    802039fa:	05d00793          	li	a5,93
    802039fe:	14e7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    80203a02:	fe842783          	lw	a5,-24(s0)
    80203a06:	0007871b          	sext.w	a4,a5
    80203a0a:	04000793          	li	a5,64
    80203a0e:	06f70f63          	beq	a4,a5,80203a8c <do_syscall+0x168>
    80203a12:	fe842783          	lw	a5,-24(s0)
    80203a16:	0007871b          	sext.w	a4,a5
    80203a1a:	04000793          	li	a5,64
    80203a1e:	12e7ea63          	bltu	a5,a4,80203b52 <do_syscall+0x22e>
    80203a22:	fe842783          	lw	a5,-24(s0)
    80203a26:	0007871b          	sext.w	a4,a5
    80203a2a:	4785                	li	a5,1
    80203a2c:	00f70b63          	beq	a4,a5,80203a42 <do_syscall+0x11e>
    80203a30:	fe842783          	lw	a5,-24(s0)
    80203a34:	0007871b          	sext.w	a4,a5
    80203a38:	03f00793          	li	a5,63
    80203a3c:	06f70e63          	beq	a4,a5,80203ab8 <do_syscall+0x194>
    80203a40:	aa09                	j	80203b52 <do_syscall+0x22e>
    80203a42:	fd843783          	ld	a5,-40(s0)
    80203a46:	67bc                	ld	a5,72(a5)
    80203a48:	853e                	mv	a0,a5
    80203a4a:	ea9ff0ef          	jal	802038f2 <sys_gethid>
    80203a4e:	87aa                	mv	a5,a0
    80203a50:	fef42623          	sw	a5,-20(s0)
    80203a54:	aa29                	j	80203b6e <do_syscall+0x24a>
    80203a56:	fd843783          	ld	a5,-40(s0)
    80203a5a:	67bc                	ld	a5,72(a5)
    80203a5c:	873e                	mv	a4,a5
    80203a5e:	fd843783          	ld	a5,-40(s0)
    80203a62:	6bbc                	ld	a5,80(a5)
    80203a64:	2781                	sext.w	a5,a5
    80203a66:	85be                	mv	a1,a5
    80203a68:	853a                	mv	a0,a4
    80203a6a:	d15ff0ef          	jal	8020377e <sys_open>
    80203a6e:	87aa                	mv	a5,a0
    80203a70:	fef42623          	sw	a5,-20(s0)
    80203a74:	a8ed                	j	80203b6e <do_syscall+0x24a>
    80203a76:	fd843783          	ld	a5,-40(s0)
    80203a7a:	67bc                	ld	a5,72(a5)
    80203a7c:	2781                	sext.w	a5,a5
    80203a7e:	853e                	mv	a0,a5
    80203a80:	d2bff0ef          	jal	802037aa <sys_close>
    80203a84:	87aa                	mv	a5,a0
    80203a86:	fef42623          	sw	a5,-20(s0)
    80203a8a:	a0d5                	j	80203b6e <do_syscall+0x24a>
    80203a8c:	fd843783          	ld	a5,-40(s0)
    80203a90:	67bc                	ld	a5,72(a5)
    80203a92:	0007871b          	sext.w	a4,a5
    80203a96:	fd843783          	ld	a5,-40(s0)
    80203a9a:	6bbc                	ld	a5,80(a5)
    80203a9c:	86be                	mv	a3,a5
    80203a9e:	fd843783          	ld	a5,-40(s0)
    80203aa2:	6fbc                	ld	a5,88(a5)
    80203aa4:	2781                	sext.w	a5,a5
    80203aa6:	863e                	mv	a2,a5
    80203aa8:	85b6                	mv	a1,a3
    80203aaa:	853a                	mv	a0,a4
    80203aac:	d23ff0ef          	jal	802037ce <sys_write>
    80203ab0:	87aa                	mv	a5,a0
    80203ab2:	fef42623          	sw	a5,-20(s0)
    80203ab6:	a865                	j	80203b6e <do_syscall+0x24a>
    80203ab8:	fd843783          	ld	a5,-40(s0)
    80203abc:	67bc                	ld	a5,72(a5)
    80203abe:	0007871b          	sext.w	a4,a5
    80203ac2:	fd843783          	ld	a5,-40(s0)
    80203ac6:	6bbc                	ld	a5,80(a5)
    80203ac8:	86be                	mv	a3,a5
    80203aca:	fd843783          	ld	a5,-40(s0)
    80203ace:	6fbc                	ld	a5,88(a5)
    80203ad0:	2781                	sext.w	a5,a5
    80203ad2:	863e                	mv	a2,a5
    80203ad4:	85b6                	mv	a1,a3
    80203ad6:	853a                	mv	a0,a4
    80203ad8:	d9dff0ef          	jal	80203874 <sys_read>
    80203adc:	87aa                	mv	a5,a0
    80203ade:	fef42623          	sw	a5,-20(s0)
    80203ae2:	a071                	j	80203b6e <do_syscall+0x24a>
    80203ae4:	fe042623          	sw	zero,-20(s0)
    80203ae8:	a059                	j	80203b6e <do_syscall+0x24a>
    80203aea:	df3ff0ef          	jal	802038dc <sys_fork>
    80203aee:	87aa                	mv	a5,a0
    80203af0:	fef42623          	sw	a5,-20(s0)
    80203af4:	00004617          	auipc	a2,0x4
    80203af8:	e0460613          	addi	a2,a2,-508 # 802078f8 <user_code_end+0xa88>
    80203afc:	00004597          	auipc	a1,0x4
    80203b00:	e0c58593          	addi	a1,a1,-500 # 80207908 <user_code_end+0xa98>
    80203b04:	00004517          	auipc	a0,0x4
    80203b08:	e1450513          	addi	a0,a0,-492 # 80207918 <user_code_end+0xaa8>
    80203b0c:	b73fd0ef          	jal	8020167e <osviz_event>
    80203b10:	a8b9                	j	80203b6e <do_syscall+0x24a>
    80203b12:	fd843783          	ld	a5,-40(s0)
    80203b16:	67bc                	ld	a5,72(a5)
    80203b18:	c78d                	beqz	a5,80203b42 <do_syscall+0x21e>
    80203b1a:	fd843783          	ld	a5,-40(s0)
    80203b1e:	6bbc                	ld	a5,80(a5)
    80203b20:	c38d                	beqz	a5,80203b42 <do_syscall+0x21e>
    80203b22:	fd843783          	ld	a5,-40(s0)
    80203b26:	67bc                	ld	a5,72(a5)
    80203b28:	873e                	mv	a4,a5
    80203b2a:	fd843783          	ld	a5,-40(s0)
    80203b2e:	6bbc                	ld	a5,80(a5)
    80203b30:	86be                	mv	a3,a5
    80203b32:	fd843783          	ld	a5,-40(s0)
    80203b36:	6fbc                	ld	a5,88(a5)
    80203b38:	863e                	mv	a2,a5
    80203b3a:	85b6                	mv	a1,a3
    80203b3c:	853a                	mv	a0,a4
    80203b3e:	b41fd0ef          	jal	8020167e <osviz_event>
    80203b42:	fe042623          	sw	zero,-20(s0)
    80203b46:	a025                	j	80203b6e <do_syscall+0x24a>
    80203b48:	be1fd0ef          	jal	80201728 <osviz_snapshot>
    80203b4c:	fe042623          	sw	zero,-20(s0)
    80203b50:	a839                	j	80203b6e <do_syscall+0x24a>
    80203b52:	fe842783          	lw	a5,-24(s0)
    80203b56:	85be                	mv	a1,a5
    80203b58:	00004517          	auipc	a0,0x4
    80203b5c:	dc850513          	addi	a0,a0,-568 # 80207920 <user_code_end+0xab0>
    80203b60:	8d7fd0ef          	jal	80201436 <printf>
    80203b64:	fda00793          	li	a5,-38
    80203b68:	fef42623          	sw	a5,-20(s0)
    80203b6c:	0001                	nop
    80203b6e:	fec42703          	lw	a4,-20(s0)
    80203b72:	fd843783          	ld	a5,-40(s0)
    80203b76:	e7b8                	sd	a4,72(a5)
    80203b78:	0001                	nop
    80203b7a:	70a2                	ld	ra,40(sp)
    80203b7c:	7402                	ld	s0,32(sp)
    80203b7e:	6145                	addi	sp,sp,48
    80203b80:	8082                	ret

0000000080203b82 <load_vaddr>:
    80203b82:	1101                	addi	sp,sp,-32
    80203b84:	ec06                	sd	ra,24(sp)
    80203b86:	e822                	sd	s0,16(sp)
    80203b88:	1000                	addi	s0,sp,32
    80203b8a:	fea43423          	sd	a0,-24(s0)
    80203b8e:	feb43023          	sd	a1,-32(s0)
    80203b92:	fe043783          	ld	a5,-32(s0)
    80203b96:	853e                	mv	a0,a5
    80203b98:	60e2                	ld	ra,24(sp)
    80203b9a:	6442                	ld	s0,16(sp)
    80203b9c:	6105                	addi	sp,sp,32
    80203b9e:	8082                	ret

0000000080203ba0 <context_save_shell>:
    80203ba0:	7119                	addi	sp,sp,-128
    80203ba2:	fc86                	sd	ra,120(sp)
    80203ba4:	f8a2                	sd	s0,112(sp)
    80203ba6:	f4a6                	sd	s1,104(sp)
    80203ba8:	f0ca                	sd	s2,96(sp)
    80203baa:	ecce                	sd	s3,88(sp)
    80203bac:	e8d2                	sd	s4,80(sp)
    80203bae:	e4d6                	sd	s5,72(sp)
    80203bb0:	e0da                	sd	s6,64(sp)
    80203bb2:	fc5e                	sd	s7,56(sp)
    80203bb4:	f862                	sd	s8,48(sp)
    80203bb6:	f466                	sd	s9,40(sp)
    80203bb8:	f06a                	sd	s10,32(sp)
    80203bba:	ec6e                	sd	s11,24(sp)
    80203bbc:	0100                	addi	s0,sp,128
    80203bbe:	f8a43423          	sd	a0,-120(s0)
    80203bc2:	f8b43023          	sd	a1,-128(s0)
    80203bc6:	8706                	mv	a4,ra
    80203bc8:	f8843783          	ld	a5,-120(s0)
    80203bcc:	e398                	sd	a4,0(a5)
    80203bce:	870a                	mv	a4,sp
    80203bd0:	f8843783          	ld	a5,-120(s0)
    80203bd4:	e798                	sd	a4,8(a5)
    80203bd6:	870e                	mv	a4,gp
    80203bd8:	f8843783          	ld	a5,-120(s0)
    80203bdc:	eb98                	sd	a4,16(a5)
    80203bde:	8712                	mv	a4,tp
    80203be0:	f8843783          	ld	a5,-120(s0)
    80203be4:	ef98                	sd	a4,24(a5)
    80203be6:	8722                	mv	a4,s0
    80203be8:	f8843783          	ld	a5,-120(s0)
    80203bec:	ff98                	sd	a4,56(a5)
    80203bee:	8726                	mv	a4,s1
    80203bf0:	f8843783          	ld	a5,-120(s0)
    80203bf4:	e3b8                	sd	a4,64(a5)
    80203bf6:	874a                	mv	a4,s2
    80203bf8:	f8843783          	ld	a5,-120(s0)
    80203bfc:	e7d8                	sd	a4,136(a5)
    80203bfe:	874e                	mv	a4,s3
    80203c00:	f8843783          	ld	a5,-120(s0)
    80203c04:	ebd8                	sd	a4,144(a5)
    80203c06:	8752                	mv	a4,s4
    80203c08:	f8843783          	ld	a5,-120(s0)
    80203c0c:	efd8                	sd	a4,152(a5)
    80203c0e:	8756                	mv	a4,s5
    80203c10:	f8843783          	ld	a5,-120(s0)
    80203c14:	f3d8                	sd	a4,160(a5)
    80203c16:	875a                	mv	a4,s6
    80203c18:	f8843783          	ld	a5,-120(s0)
    80203c1c:	f7d8                	sd	a4,168(a5)
    80203c1e:	875e                	mv	a4,s7
    80203c20:	f8843783          	ld	a5,-120(s0)
    80203c24:	fbd8                	sd	a4,176(a5)
    80203c26:	8762                	mv	a4,s8
    80203c28:	f8843783          	ld	a5,-120(s0)
    80203c2c:	ffd8                	sd	a4,184(a5)
    80203c2e:	8766                	mv	a4,s9
    80203c30:	f8843783          	ld	a5,-120(s0)
    80203c34:	e3f8                	sd	a4,192(a5)
    80203c36:	876a                	mv	a4,s10
    80203c38:	f8843783          	ld	a5,-120(s0)
    80203c3c:	e7f8                	sd	a4,200(a5)
    80203c3e:	876e                	mv	a4,s11
    80203c40:	f8843783          	ld	a5,-120(s0)
    80203c44:	ebf8                	sd	a4,208(a5)
    80203c46:	f8843783          	ld	a5,-120(s0)
    80203c4a:	f8043703          	ld	a4,-128(s0)
    80203c4e:	fff8                	sd	a4,248(a5)
    80203c50:	0001                	nop
    80203c52:	70e6                	ld	ra,120(sp)
    80203c54:	7446                	ld	s0,112(sp)
    80203c56:	74a6                	ld	s1,104(sp)
    80203c58:	7906                	ld	s2,96(sp)
    80203c5a:	69e6                	ld	s3,88(sp)
    80203c5c:	6a46                	ld	s4,80(sp)
    80203c5e:	6aa6                	ld	s5,72(sp)
    80203c60:	6b06                	ld	s6,64(sp)
    80203c62:	7be2                	ld	s7,56(sp)
    80203c64:	7c42                	ld	s8,48(sp)
    80203c66:	7ca2                	ld	s9,40(sp)
    80203c68:	7d02                	ld	s10,32(sp)
    80203c6a:	6de2                	ld	s11,24(sp)
    80203c6c:	6109                	addi	sp,sp,128
    80203c6e:	8082                	ret

0000000080203c70 <prog_exec>:
    80203c70:	711d                	addi	sp,sp,-96
    80203c72:	ec86                	sd	ra,88(sp)
    80203c74:	e8a2                	sd	s0,80(sp)
    80203c76:	1080                	addi	s0,sp,96
    80203c78:	faa43423          	sd	a0,-88(s0)
    80203c7c:	6611                	lui	a2,0x4
    80203c7e:	0000f597          	auipc	a1,0xf
    80203c82:	25a58593          	addi	a1,a1,602 # 80212ed8 <file_buf>
    80203c86:	fa843503          	ld	a0,-88(s0)
    80203c8a:	6a8010ef          	jal	80205332 <fs_read_file>
    80203c8e:	87aa                	mv	a5,a0
    80203c90:	fcf42e23          	sw	a5,-36(s0)
    80203c94:	fdc42783          	lw	a5,-36(s0)
    80203c98:	0007871b          	sext.w	a4,a5
    80203c9c:	03f00793          	li	a5,63
    80203ca0:	00e7ca63          	blt	a5,a4,80203cb4 <prog_exec+0x44>
    80203ca4:	00004517          	auipc	a0,0x4
    80203ca8:	c9450513          	addi	a0,a0,-876 # 80207938 <user_code_end+0xac8>
    80203cac:	d99fc0ef          	jal	80200a44 <uart_puts>
    80203cb0:	57fd                	li	a5,-1
    80203cb2:	a4d1                	j	80203f76 <prog_exec+0x306>
    80203cb4:	0000f797          	auipc	a5,0xf
    80203cb8:	22478793          	addi	a5,a5,548 # 80212ed8 <file_buf>
    80203cbc:	fcf43823          	sd	a5,-48(s0)
    80203cc0:	fd043783          	ld	a5,-48(s0)
    80203cc4:	4398                	lw	a4,0(a5)
    80203cc6:	464c47b7          	lui	a5,0x464c4
    80203cca:	57f78793          	addi	a5,a5,1407 # 464c457f <_heap_size+0x3e5dd157>
    80203cce:	00f70a63          	beq	a4,a5,80203ce2 <prog_exec+0x72>
    80203cd2:	00004517          	auipc	a0,0x4
    80203cd6:	c8e50513          	addi	a0,a0,-882 # 80207960 <user_code_end+0xaf0>
    80203cda:	d6bfc0ef          	jal	80200a44 <uart_puts>
    80203cde:	57fd                	li	a5,-1
    80203ce0:	ac59                	j	80203f76 <prog_exec+0x306>
    80203ce2:	fd043783          	ld	a5,-48(s0)
    80203ce6:	0047c783          	lbu	a5,4(a5)
    80203cea:	873e                	mv	a4,a5
    80203cec:	4789                	li	a5,2
    80203cee:	00f71c63          	bne	a4,a5,80203d06 <prog_exec+0x96>
    80203cf2:	fd043783          	ld	a5,-48(s0)
    80203cf6:	0127d783          	lhu	a5,18(a5)
    80203cfa:	0007871b          	sext.w	a4,a5
    80203cfe:	0f300793          	li	a5,243
    80203d02:	00f70a63          	beq	a4,a5,80203d16 <prog_exec+0xa6>
    80203d06:	00004517          	auipc	a0,0x4
    80203d0a:	c7250513          	addi	a0,a0,-910 # 80207978 <user_code_end+0xb08>
    80203d0e:	d37fc0ef          	jal	80200a44 <uart_puts>
    80203d12:	57fd                	li	a5,-1
    80203d14:	a48d                	j	80203f76 <prog_exec+0x306>
    80203d16:	fd043783          	ld	a5,-48(s0)
    80203d1a:	7398                	ld	a4,32(a5)
    80203d1c:	0000f797          	auipc	a5,0xf
    80203d20:	1bc78793          	addi	a5,a5,444 # 80212ed8 <file_buf>
    80203d24:	97ba                	add	a5,a5,a4
    80203d26:	fcf43423          	sd	a5,-56(s0)
    80203d2a:	fe042623          	sw	zero,-20(s0)
    80203d2e:	a261                	j	80203eb6 <prog_exec+0x246>
    80203d30:	fec42703          	lw	a4,-20(s0)
    80203d34:	87ba                	mv	a5,a4
    80203d36:	078e                	slli	a5,a5,0x3
    80203d38:	8f99                	sub	a5,a5,a4
    80203d3a:	078e                	slli	a5,a5,0x3
    80203d3c:	873e                	mv	a4,a5
    80203d3e:	fc843783          	ld	a5,-56(s0)
    80203d42:	97ba                	add	a5,a5,a4
    80203d44:	4398                	lw	a4,0(a5)
    80203d46:	4785                	li	a5,1
    80203d48:	16f71163          	bne	a4,a5,80203eaa <prog_exec+0x23a>
    80203d4c:	fec42703          	lw	a4,-20(s0)
    80203d50:	87ba                	mv	a5,a4
    80203d52:	078e                	slli	a5,a5,0x3
    80203d54:	8f99                	sub	a5,a5,a4
    80203d56:	078e                	slli	a5,a5,0x3
    80203d58:	873e                	mv	a4,a5
    80203d5a:	fc843783          	ld	a5,-56(s0)
    80203d5e:	97ba                	add	a5,a5,a4
    80203d60:	7394                	ld	a3,32(a5)
    80203d62:	fec42703          	lw	a4,-20(s0)
    80203d66:	87ba                	mv	a5,a4
    80203d68:	078e                	slli	a5,a5,0x3
    80203d6a:	8f99                	sub	a5,a5,a4
    80203d6c:	078e                	slli	a5,a5,0x3
    80203d6e:	873e                	mv	a4,a5
    80203d70:	fc843783          	ld	a5,-56(s0)
    80203d74:	97ba                	add	a5,a5,a4
    80203d76:	779c                	ld	a5,40(a5)
    80203d78:	00d7fa63          	bgeu	a5,a3,80203d8c <prog_exec+0x11c>
    80203d7c:	00004517          	auipc	a0,0x4
    80203d80:	c1c50513          	addi	a0,a0,-996 # 80207998 <user_code_end+0xb28>
    80203d84:	cc1fc0ef          	jal	80200a44 <uart_puts>
    80203d88:	57fd                	li	a5,-1
    80203d8a:	a2f5                	j	80203f76 <prog_exec+0x306>
    80203d8c:	fec42703          	lw	a4,-20(s0)
    80203d90:	87ba                	mv	a5,a4
    80203d92:	078e                	slli	a5,a5,0x3
    80203d94:	8f99                	sub	a5,a5,a4
    80203d96:	078e                	slli	a5,a5,0x3
    80203d98:	873e                	mv	a4,a5
    80203d9a:	fc843783          	ld	a5,-56(s0)
    80203d9e:	97ba                	add	a5,a5,a4
    80203da0:	6b9c                	ld	a5,16(a5)
    80203da2:	85be                	mv	a1,a5
    80203da4:	0000f517          	auipc	a0,0xf
    80203da8:	13450513          	addi	a0,a0,308 # 80212ed8 <file_buf>
    80203dac:	dd7ff0ef          	jal	80203b82 <load_vaddr>
    80203db0:	faa43c23          	sd	a0,-72(s0)
    80203db4:	fec42703          	lw	a4,-20(s0)
    80203db8:	87ba                	mv	a5,a4
    80203dba:	078e                	slli	a5,a5,0x3
    80203dbc:	8f99                	sub	a5,a5,a4
    80203dbe:	078e                	slli	a5,a5,0x3
    80203dc0:	873e                	mv	a4,a5
    80203dc2:	fc843783          	ld	a5,-56(s0)
    80203dc6:	97ba                	add	a5,a5,a4
    80203dc8:	679c                	ld	a5,8(a5)
    80203dca:	faf43823          	sd	a5,-80(s0)
    80203dce:	fec42703          	lw	a4,-20(s0)
    80203dd2:	87ba                	mv	a5,a4
    80203dd4:	078e                	slli	a5,a5,0x3
    80203dd6:	8f99                	sub	a5,a5,a4
    80203dd8:	078e                	slli	a5,a5,0x3
    80203dda:	873e                	mv	a4,a5
    80203ddc:	fc843783          	ld	a5,-56(s0)
    80203de0:	97ba                	add	a5,a5,a4
    80203de2:	7398                	ld	a4,32(a5)
    80203de4:	fb043783          	ld	a5,-80(s0)
    80203de8:	973e                	add	a4,a4,a5
    80203dea:	fdc42783          	lw	a5,-36(s0)
    80203dee:	00e7fa63          	bgeu	a5,a4,80203e02 <prog_exec+0x192>
    80203df2:	00004517          	auipc	a0,0x4
    80203df6:	bbe50513          	addi	a0,a0,-1090 # 802079b0 <user_code_end+0xb40>
    80203dfa:	c4bfc0ef          	jal	80200a44 <uart_puts>
    80203dfe:	57fd                	li	a5,-1
    80203e00:	aa9d                	j	80203f76 <prog_exec+0x306>
    80203e02:	fe043023          	sd	zero,-32(s0)
    80203e06:	a80d                	j	80203e38 <prog_exec+0x1c8>
    80203e08:	fb043703          	ld	a4,-80(s0)
    80203e0c:	fe043783          	ld	a5,-32(s0)
    80203e10:	973e                	add	a4,a4,a5
    80203e12:	fb843683          	ld	a3,-72(s0)
    80203e16:	fe043783          	ld	a5,-32(s0)
    80203e1a:	97b6                	add	a5,a5,a3
    80203e1c:	0000f697          	auipc	a3,0xf
    80203e20:	0bc68693          	addi	a3,a3,188 # 80212ed8 <file_buf>
    80203e24:	9736                	add	a4,a4,a3
    80203e26:	00074703          	lbu	a4,0(a4)
    80203e2a:	00e78023          	sb	a4,0(a5)
    80203e2e:	fe043783          	ld	a5,-32(s0)
    80203e32:	0785                	addi	a5,a5,1
    80203e34:	fef43023          	sd	a5,-32(s0)
    80203e38:	fec42703          	lw	a4,-20(s0)
    80203e3c:	87ba                	mv	a5,a4
    80203e3e:	078e                	slli	a5,a5,0x3
    80203e40:	8f99                	sub	a5,a5,a4
    80203e42:	078e                	slli	a5,a5,0x3
    80203e44:	873e                	mv	a4,a5
    80203e46:	fc843783          	ld	a5,-56(s0)
    80203e4a:	97ba                	add	a5,a5,a4
    80203e4c:	739c                	ld	a5,32(a5)
    80203e4e:	fe043703          	ld	a4,-32(s0)
    80203e52:	faf76be3          	bltu	a4,a5,80203e08 <prog_exec+0x198>
    80203e56:	fec42703          	lw	a4,-20(s0)
    80203e5a:	87ba                	mv	a5,a4
    80203e5c:	078e                	slli	a5,a5,0x3
    80203e5e:	8f99                	sub	a5,a5,a4
    80203e60:	078e                	slli	a5,a5,0x3
    80203e62:	873e                	mv	a4,a5
    80203e64:	fc843783          	ld	a5,-56(s0)
    80203e68:	97ba                	add	a5,a5,a4
    80203e6a:	739c                	ld	a5,32(a5)
    80203e6c:	fef43023          	sd	a5,-32(s0)
    80203e70:	a829                	j	80203e8a <prog_exec+0x21a>
    80203e72:	fb843703          	ld	a4,-72(s0)
    80203e76:	fe043783          	ld	a5,-32(s0)
    80203e7a:	97ba                	add	a5,a5,a4
    80203e7c:	00078023          	sb	zero,0(a5)
    80203e80:	fe043783          	ld	a5,-32(s0)
    80203e84:	0785                	addi	a5,a5,1
    80203e86:	fef43023          	sd	a5,-32(s0)
    80203e8a:	fec42703          	lw	a4,-20(s0)
    80203e8e:	87ba                	mv	a5,a4
    80203e90:	078e                	slli	a5,a5,0x3
    80203e92:	8f99                	sub	a5,a5,a4
    80203e94:	078e                	slli	a5,a5,0x3
    80203e96:	873e                	mv	a4,a5
    80203e98:	fc843783          	ld	a5,-56(s0)
    80203e9c:	97ba                	add	a5,a5,a4
    80203e9e:	779c                	ld	a5,40(a5)
    80203ea0:	fe043703          	ld	a4,-32(s0)
    80203ea4:	fcf767e3          	bltu	a4,a5,80203e72 <prog_exec+0x202>
    80203ea8:	a011                	j	80203eac <prog_exec+0x23c>
    80203eaa:	0001                	nop
    80203eac:	fec42783          	lw	a5,-20(s0)
    80203eb0:	2785                	addiw	a5,a5,1
    80203eb2:	fef42623          	sw	a5,-20(s0)
    80203eb6:	fd043783          	ld	a5,-48(s0)
    80203eba:	0387d783          	lhu	a5,56(a5)
    80203ebe:	2781                	sext.w	a5,a5
    80203ec0:	fec42703          	lw	a4,-20(s0)
    80203ec4:	2701                	sext.w	a4,a4
    80203ec6:	e6f745e3          	blt	a4,a5,80203d30 <prog_exec+0xc0>
    80203eca:	0000100f          	fence.i
    80203ece:	fd043783          	ld	a5,-48(s0)
    80203ed2:	6f9c                	ld	a5,24(a5)
    80203ed4:	fcf43023          	sd	a5,-64(s0)
    80203ed8:	fe042623          	sw	zero,-20(s0)
    80203edc:	a00d                	j	80203efe <prog_exec+0x28e>
    80203ede:	fec42783          	lw	a5,-20(s0)
    80203ee2:	00379713          	slli	a4,a5,0x3
    80203ee6:	0000f797          	auipc	a5,0xf
    80203eea:	df278793          	addi	a5,a5,-526 # 80212cd8 <user_cxt>
    80203eee:	97ba                	add	a5,a5,a4
    80203ef0:	0007b023          	sd	zero,0(a5)
    80203ef4:	fec42783          	lw	a5,-20(s0)
    80203ef8:	2785                	addiw	a5,a5,1
    80203efa:	fef42623          	sw	a5,-20(s0)
    80203efe:	fec42783          	lw	a5,-20(s0)
    80203f02:	0007871b          	sext.w	a4,a5
    80203f06:	47fd                	li	a5,31
    80203f08:	fce7dbe3          	bge	a5,a4,80203ede <prog_exec+0x26e>
    80203f0c:	0000f797          	auipc	a5,0xf
    80203f10:	dcc78793          	addi	a5,a5,-564 # 80212cd8 <user_cxt>
    80203f14:	fc043703          	ld	a4,-64(s0)
    80203f18:	fff8                	sd	a4,248(a5)
    80203f1a:	0000f797          	auipc	a5,0xf
    80203f1e:	dbe78793          	addi	a5,a5,-578 # 80212cd8 <user_cxt>
    80203f22:	08039737          	lui	a4,0x8039
    80203f26:	0712                	slli	a4,a4,0x4
    80203f28:	e798                	sd	a4,8(a5)
    80203f2a:	0000b797          	auipc	a5,0xb
    80203f2e:	16678793          	addi	a5,a5,358 # 8020f090 <prog_exec_active>
    80203f32:	4705                	li	a4,1
    80203f34:	c398                	sw	a4,0(a5)
    80203f36:	0000b797          	auipc	a5,0xb
    80203f3a:	15e78793          	addi	a5,a5,350 # 8020f094 <prog_exec_restore_shell>
    80203f3e:	0007a023          	sw	zero,0(a5)
    80203f42:	00000797          	auipc	a5,0x0
    80203f46:	03e78793          	addi	a5,a5,62 # 80203f80 <prog_exec_done>
    80203f4a:	85be                	mv	a1,a5
    80203f4c:	0000f517          	auipc	a0,0xf
    80203f50:	e8c50513          	addi	a0,a0,-372 # 80212dd8 <shell_save_cxt>
    80203f54:	c4dff0ef          	jal	80203ba0 <context_save_shell>
    80203f58:	8706                	mv	a4,ra
    80203f5a:	0000f797          	auipc	a5,0xf
    80203f5e:	e7e78793          	addi	a5,a5,-386 # 80212dd8 <shell_save_cxt>
    80203f62:	e398                	sd	a4,0(a5)
    80203f64:	d73fd0ef          	jal	80201cd6 <trap_use_kernel_cxt>
    80203f68:	0000f517          	auipc	a0,0xf
    80203f6c:	d7050513          	addi	a0,a0,-656 # 80212cd8 <user_cxt>
    80203f70:	abcfc0ef          	jal	8020022c <switch_to>
    80203f74:	57fd                	li	a5,-1
    80203f76:	853e                	mv	a0,a5
    80203f78:	60e6                	ld	ra,88(sp)
    80203f7a:	6446                	ld	s0,80(sp)
    80203f7c:	6125                	addi	sp,sp,96
    80203f7e:	8082                	ret

0000000080203f80 <prog_exec_done>:
    80203f80:	0000b797          	auipc	a5,0xb
    80203f84:	10078793          	addi	a5,a5,256 # 8020f080 <kernel_gp_value>
    80203f88:	639c                	ld	a5,0(a5)
    80203f8a:	81be                	mv	gp,a5
    80203f8c:	8082                	ret
    80203f8e:	0001                	nop

0000000080203f90 <prog_is_elf_path>:
    80203f90:	7179                	addi	sp,sp,-48
    80203f92:	f406                	sd	ra,40(sp)
    80203f94:	f022                	sd	s0,32(sp)
    80203f96:	1800                	addi	s0,sp,48
    80203f98:	fca43c23          	sd	a0,-40(s0)
    80203f9c:	fe040793          	addi	a5,s0,-32
    80203fa0:	4621                	li	a2,8
    80203fa2:	85be                	mv	a1,a5
    80203fa4:	fd843503          	ld	a0,-40(s0)
    80203fa8:	38a010ef          	jal	80205332 <fs_read_file>
    80203fac:	87aa                	mv	a5,a0
    80203fae:	fef42623          	sw	a5,-20(s0)
    80203fb2:	fec42783          	lw	a5,-20(s0)
    80203fb6:	0007871b          	sext.w	a4,a5
    80203fba:	478d                	li	a5,3
    80203fbc:	00e7c463          	blt	a5,a4,80203fc4 <prog_is_elf_path+0x34>
    80203fc0:	4781                	li	a5,0
    80203fc2:	a839                	j	80203fe0 <prog_is_elf_path+0x50>
    80203fc4:	fe040793          	addi	a5,s0,-32
    80203fc8:	4398                	lw	a4,0(a5)
    80203fca:	464c47b7          	lui	a5,0x464c4
    80203fce:	57f78793          	addi	a5,a5,1407 # 464c457f <_heap_size+0x3e5dd157>
    80203fd2:	40f707b3          	sub	a5,a4,a5
    80203fd6:	0017b793          	seqz	a5,a5
    80203fda:	0ff7f793          	zext.b	a5,a5
    80203fde:	2781                	sext.w	a5,a5
    80203fe0:	853e                	mv	a0,a5
    80203fe2:	70a2                	ld	ra,40(sp)
    80203fe4:	7402                	ld	s0,32(sp)
    80203fe6:	6145                	addi	sp,sp,48
    80203fe8:	8082                	ret

0000000080203fea <str_len>:
    80203fea:	7179                	addi	sp,sp,-48
    80203fec:	f406                	sd	ra,40(sp)
    80203fee:	f022                	sd	s0,32(sp)
    80203ff0:	1800                	addi	s0,sp,48
    80203ff2:	fca43c23          	sd	a0,-40(s0)
    80203ff6:	fe042623          	sw	zero,-20(s0)
    80203ffa:	a031                	j	80204006 <str_len+0x1c>
    80203ffc:	fec42783          	lw	a5,-20(s0)
    80204000:	2785                	addiw	a5,a5,1
    80204002:	fef42623          	sw	a5,-20(s0)
    80204006:	fd843783          	ld	a5,-40(s0)
    8020400a:	cb89                	beqz	a5,8020401c <str_len+0x32>
    8020400c:	fec42783          	lw	a5,-20(s0)
    80204010:	fd843703          	ld	a4,-40(s0)
    80204014:	97ba                	add	a5,a5,a4
    80204016:	0007c783          	lbu	a5,0(a5)
    8020401a:	f3ed                	bnez	a5,80203ffc <str_len+0x12>
    8020401c:	fec42783          	lw	a5,-20(s0)
    80204020:	853e                	mv	a0,a5
    80204022:	70a2                	ld	ra,40(sp)
    80204024:	7402                	ld	s0,32(sp)
    80204026:	6145                	addi	sp,sp,48
    80204028:	8082                	ret

000000008020402a <str_eq>:
    8020402a:	1101                	addi	sp,sp,-32
    8020402c:	ec06                	sd	ra,24(sp)
    8020402e:	e822                	sd	s0,16(sp)
    80204030:	1000                	addi	s0,sp,32
    80204032:	fea43423          	sd	a0,-24(s0)
    80204036:	feb43023          	sd	a1,-32(s0)
    8020403a:	a03d                	j	80204068 <str_eq+0x3e>
    8020403c:	fe843783          	ld	a5,-24(s0)
    80204040:	0007c703          	lbu	a4,0(a5)
    80204044:	fe043783          	ld	a5,-32(s0)
    80204048:	0007c783          	lbu	a5,0(a5)
    8020404c:	00f70463          	beq	a4,a5,80204054 <str_eq+0x2a>
    80204050:	4781                	li	a5,0
    80204052:	a0b1                	j	8020409e <str_eq+0x74>
    80204054:	fe843783          	ld	a5,-24(s0)
    80204058:	0785                	addi	a5,a5,1
    8020405a:	fef43423          	sd	a5,-24(s0)
    8020405e:	fe043783          	ld	a5,-32(s0)
    80204062:	0785                	addi	a5,a5,1
    80204064:	fef43023          	sd	a5,-32(s0)
    80204068:	fe843783          	ld	a5,-24(s0)
    8020406c:	0007c783          	lbu	a5,0(a5)
    80204070:	c791                	beqz	a5,8020407c <str_eq+0x52>
    80204072:	fe043783          	ld	a5,-32(s0)
    80204076:	0007c783          	lbu	a5,0(a5)
    8020407a:	f3e9                	bnez	a5,8020403c <str_eq+0x12>
    8020407c:	fe843783          	ld	a5,-24(s0)
    80204080:	0007c703          	lbu	a4,0(a5)
    80204084:	fe043783          	ld	a5,-32(s0)
    80204088:	0007c783          	lbu	a5,0(a5)
    8020408c:	2701                	sext.w	a4,a4
    8020408e:	2781                	sext.w	a5,a5
    80204090:	40f707b3          	sub	a5,a4,a5
    80204094:	0017b793          	seqz	a5,a5
    80204098:	0ff7f793          	zext.b	a5,a5
    8020409c:	2781                	sext.w	a5,a5
    8020409e:	853e                	mv	a0,a5
    802040a0:	60e2                	ld	ra,24(sp)
    802040a2:	6442                	ld	s0,16(sp)
    802040a4:	6105                	addi	sp,sp,32
    802040a6:	8082                	ret

00000000802040a8 <str_prefix>:
    802040a8:	1101                	addi	sp,sp,-32
    802040aa:	ec06                	sd	ra,24(sp)
    802040ac:	e822                	sd	s0,16(sp)
    802040ae:	1000                	addi	s0,sp,32
    802040b0:	fea43423          	sd	a0,-24(s0)
    802040b4:	feb43023          	sd	a1,-32(s0)
    802040b8:	a03d                	j	802040e6 <str_prefix+0x3e>
    802040ba:	fe843783          	ld	a5,-24(s0)
    802040be:	0007c703          	lbu	a4,0(a5)
    802040c2:	fe043783          	ld	a5,-32(s0)
    802040c6:	0007c783          	lbu	a5,0(a5)
    802040ca:	00f70463          	beq	a4,a5,802040d2 <str_prefix+0x2a>
    802040ce:	4781                	li	a5,0
    802040d0:	a00d                	j	802040f2 <str_prefix+0x4a>
    802040d2:	fe843783          	ld	a5,-24(s0)
    802040d6:	0785                	addi	a5,a5,1
    802040d8:	fef43423          	sd	a5,-24(s0)
    802040dc:	fe043783          	ld	a5,-32(s0)
    802040e0:	0785                	addi	a5,a5,1
    802040e2:	fef43023          	sd	a5,-32(s0)
    802040e6:	fe043783          	ld	a5,-32(s0)
    802040ea:	0007c783          	lbu	a5,0(a5)
    802040ee:	f7f1                	bnez	a5,802040ba <str_prefix+0x12>
    802040f0:	4785                	li	a5,1
    802040f2:	853e                	mv	a0,a5
    802040f4:	60e2                	ld	ra,24(sp)
    802040f6:	6442                	ld	s0,16(sp)
    802040f8:	6105                	addi	sp,sp,32
    802040fa:	8082                	ret

00000000802040fc <path_copy>:
    802040fc:	7139                	addi	sp,sp,-64
    802040fe:	fc06                	sd	ra,56(sp)
    80204100:	f822                	sd	s0,48(sp)
    80204102:	0080                	addi	s0,sp,64
    80204104:	fca43c23          	sd	a0,-40(s0)
    80204108:	87ae                	mv	a5,a1
    8020410a:	fcc43423          	sd	a2,-56(s0)
    8020410e:	fcf42a23          	sw	a5,-44(s0)
    80204112:	fe042623          	sw	zero,-20(s0)
    80204116:	a025                	j	8020413e <path_copy+0x42>
    80204118:	fec42783          	lw	a5,-20(s0)
    8020411c:	fc843703          	ld	a4,-56(s0)
    80204120:	973e                	add	a4,a4,a5
    80204122:	fec42783          	lw	a5,-20(s0)
    80204126:	fd843683          	ld	a3,-40(s0)
    8020412a:	97b6                	add	a5,a5,a3
    8020412c:	00074703          	lbu	a4,0(a4) # 8039000 <_heap_size+0x151bd8>
    80204130:	00e78023          	sb	a4,0(a5)
    80204134:	fec42783          	lw	a5,-20(s0)
    80204138:	2785                	addiw	a5,a5,1
    8020413a:	fef42623          	sw	a5,-20(s0)
    8020413e:	fc843783          	ld	a5,-56(s0)
    80204142:	c395                	beqz	a5,80204166 <path_copy+0x6a>
    80204144:	fec42783          	lw	a5,-20(s0)
    80204148:	fc843703          	ld	a4,-56(s0)
    8020414c:	97ba                	add	a5,a5,a4
    8020414e:	0007c783          	lbu	a5,0(a5)
    80204152:	cb91                	beqz	a5,80204166 <path_copy+0x6a>
    80204154:	fd442783          	lw	a5,-44(s0)
    80204158:	37fd                	addiw	a5,a5,-1
    8020415a:	2781                	sext.w	a5,a5
    8020415c:	fec42703          	lw	a4,-20(s0)
    80204160:	2701                	sext.w	a4,a4
    80204162:	faf74be3          	blt	a4,a5,80204118 <path_copy+0x1c>
    80204166:	fec42783          	lw	a5,-20(s0)
    8020416a:	fd843703          	ld	a4,-40(s0)
    8020416e:	97ba                	add	a5,a5,a4
    80204170:	00078023          	sb	zero,0(a5)
    80204174:	0001                	nop
    80204176:	70e2                	ld	ra,56(sp)
    80204178:	7442                	ld	s0,48(sp)
    8020417a:	6121                	addi	sp,sp,64
    8020417c:	8082                	ret

000000008020417e <path_normalize>:
    8020417e:	7171                	addi	sp,sp,-176
    80204180:	f506                	sd	ra,168(sp)
    80204182:	f122                	sd	s0,160(sp)
    80204184:	ed26                	sd	s1,152(sp)
    80204186:	1900                	addi	s0,sp,176
    80204188:	81010113          	addi	sp,sp,-2032
    8020418c:	77fd                	lui	a5,0xfffff
    8020418e:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204190:	97a2                	add	a5,a5,s0
    80204192:	78a7bc23          	sd	a0,1944(a5)
    80204196:	77fd                	lui	a5,0xfffff
    80204198:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020419a:	97a2                	add	a5,a5,s0
    8020419c:	78b7b823          	sd	a1,1936(a5)
    802041a0:	8732                	mv	a4,a2
    802041a2:	77fd                	lui	a5,0xfffff
    802041a4:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802041a6:	97a2                	add	a5,a5,s0
    802041a8:	78e7a623          	sw	a4,1932(a5)
    802041ac:	fc042e23          	sw	zero,-36(s0)
    802041b0:	fc042c23          	sw	zero,-40(s0)
    802041b4:	77fd                	lui	a5,0xfffff
    802041b6:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802041b8:	97a2                	add	a5,a5,s0
    802041ba:	7987b783          	ld	a5,1944(a5)
    802041be:	cf99                	beqz	a5,802041dc <path_normalize+0x5e>
    802041c0:	77fd                	lui	a5,0xfffff
    802041c2:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802041c4:	97a2                	add	a5,a5,s0
    802041c6:	7907b783          	ld	a5,1936(a5)
    802041ca:	cb89                	beqz	a5,802041dc <path_normalize+0x5e>
    802041cc:	77fd                	lui	a5,0xfffff
    802041ce:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802041d0:	97a2                	add	a5,a5,s0
    802041d2:	78c7a783          	lw	a5,1932(a5)
    802041d6:	2781                	sext.w	a5,a5
    802041d8:	00f04463          	bgtz	a5,802041e0 <path_normalize+0x62>
    802041dc:	57fd                	li	a5,-1
    802041de:	ae35                	j	8020451a <path_normalize+0x39c>
    802041e0:	77fd                	lui	a5,0xfffff
    802041e2:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802041e4:	97a2                	add	a5,a5,s0
    802041e6:	7987b783          	ld	a5,1944(a5)
    802041ea:	0007c783          	lbu	a5,0(a5)
    802041ee:	873e                	mv	a4,a5
    802041f0:	02f00793          	li	a5,47
    802041f4:	00f71563          	bne	a4,a5,802041fe <path_normalize+0x80>
    802041f8:	4785                	li	a5,1
    802041fa:	fcf42c23          	sw	a5,-40(s0)
    802041fe:	77fd                	lui	a5,0xfffff
    80204200:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204202:	97a2                	add	a5,a5,s0
    80204204:	7987b783          	ld	a5,1944(a5)
    80204208:	fcf43423          	sd	a5,-56(s0)
    8020420c:	aa25                	j	80204344 <path_normalize+0x1c6>
    8020420e:	fc042223          	sw	zero,-60(s0)
    80204212:	a031                	j	8020421e <path_normalize+0xa0>
    80204214:	fc843783          	ld	a5,-56(s0)
    80204218:	0785                	addi	a5,a5,1
    8020421a:	fcf43423          	sd	a5,-56(s0)
    8020421e:	fc843783          	ld	a5,-56(s0)
    80204222:	0007c783          	lbu	a5,0(a5)
    80204226:	873e                	mv	a4,a5
    80204228:	02f00793          	li	a5,47
    8020422c:	fef704e3          	beq	a4,a5,80204214 <path_normalize+0x96>
    80204230:	fc843783          	ld	a5,-56(s0)
    80204234:	0007c783          	lbu	a5,0(a5)
    80204238:	10078d63          	beqz	a5,80204352 <path_normalize+0x1d4>
    8020423c:	a02d                	j	80204266 <path_normalize+0xe8>
    8020423e:	fc843703          	ld	a4,-56(s0)
    80204242:	00170793          	addi	a5,a4,1
    80204246:	fcf43423          	sd	a5,-56(s0)
    8020424a:	fc442783          	lw	a5,-60(s0)
    8020424e:	0017869b          	addiw	a3,a5,1
    80204252:	fcd42223          	sw	a3,-60(s0)
    80204256:	00074703          	lbu	a4,0(a4)
    8020425a:	76fd                	lui	a3,0xfffff
    8020425c:	1681                	addi	a3,a3,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020425e:	96a2                	add	a3,a3,s0
    80204260:	97b6                	add	a5,a5,a3
    80204262:	7ae78023          	sb	a4,1952(a5)
    80204266:	fc843783          	ld	a5,-56(s0)
    8020426a:	0007c783          	lbu	a5,0(a5)
    8020426e:	c395                	beqz	a5,80204292 <path_normalize+0x114>
    80204270:	fc843783          	ld	a5,-56(s0)
    80204274:	0007c783          	lbu	a5,0(a5)
    80204278:	873e                	mv	a4,a5
    8020427a:	02f00793          	li	a5,47
    8020427e:	00f70a63          	beq	a4,a5,80204292 <path_normalize+0x114>
    80204282:	fc442783          	lw	a5,-60(s0)
    80204286:	0007871b          	sext.w	a4,a5
    8020428a:	03e00793          	li	a5,62
    8020428e:	fae7d8e3          	bge	a5,a4,8020423e <path_normalize+0xc0>
    80204292:	77fd                	lui	a5,0xfffff
    80204294:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204296:	00878733          	add	a4,a5,s0
    8020429a:	fc442783          	lw	a5,-60(s0)
    8020429e:	97ba                	add	a5,a5,a4
    802042a0:	7a078023          	sb	zero,1952(a5)
    802042a4:	77fd                	lui	a5,0xfffff
    802042a6:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802042a8:	97a2                	add	a5,a5,s0
    802042aa:	7a07c783          	lbu	a5,1952(a5)
    802042ae:	cbc1                	beqz	a5,8020433e <path_normalize+0x1c0>
    802042b0:	77fd                	lui	a5,0xfffff
    802042b2:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    802042b6:	1781                	addi	a5,a5,-32
    802042b8:	97a2                	add	a5,a5,s0
    802042ba:	00003597          	auipc	a1,0x3
    802042be:	71658593          	addi	a1,a1,1814 # 802079d0 <user_code_end+0xb60>
    802042c2:	853e                	mv	a0,a5
    802042c4:	d67ff0ef          	jal	8020402a <str_eq>
    802042c8:	87aa                	mv	a5,a0
    802042ca:	ebb5                	bnez	a5,8020433e <path_normalize+0x1c0>
    802042cc:	77fd                	lui	a5,0xfffff
    802042ce:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    802042d2:	1781                	addi	a5,a5,-32
    802042d4:	97a2                	add	a5,a5,s0
    802042d6:	00003597          	auipc	a1,0x3
    802042da:	70258593          	addi	a1,a1,1794 # 802079d8 <user_code_end+0xb68>
    802042de:	853e                	mv	a0,a5
    802042e0:	d4bff0ef          	jal	8020402a <str_eq>
    802042e4:	87aa                	mv	a5,a0
    802042e6:	cf81                	beqz	a5,802042fe <path_normalize+0x180>
    802042e8:	fdc42783          	lw	a5,-36(s0)
    802042ec:	2781                	sext.w	a5,a5
    802042ee:	04f05a63          	blez	a5,80204342 <path_normalize+0x1c4>
    802042f2:	fdc42783          	lw	a5,-36(s0)
    802042f6:	37fd                	addiw	a5,a5,-1
    802042f8:	fcf42e23          	sw	a5,-36(s0)
    802042fc:	a099                	j	80204342 <path_normalize+0x1c4>
    802042fe:	fdc42783          	lw	a5,-36(s0)
    80204302:	0007871b          	sext.w	a4,a5
    80204306:	47fd                	li	a5,31
    80204308:	02e7ce63          	blt	a5,a4,80204344 <path_normalize+0x1c6>
    8020430c:	fdc42783          	lw	a5,-36(s0)
    80204310:	0017871b          	addiw	a4,a5,1
    80204314:	fce42e23          	sw	a4,-36(s0)
    80204318:	777d                	lui	a4,0xfffff
    8020431a:	7e070713          	addi	a4,a4,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    8020431e:	1701                	addi	a4,a4,-32
    80204320:	9722                	add	a4,a4,s0
    80204322:	079a                	slli	a5,a5,0x6
    80204324:	973e                	add	a4,a4,a5
    80204326:	77fd                	lui	a5,0xfffff
    80204328:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    8020432c:	1781                	addi	a5,a5,-32
    8020432e:	97a2                	add	a5,a5,s0
    80204330:	863e                	mv	a2,a5
    80204332:	04000593          	li	a1,64
    80204336:	853a                	mv	a0,a4
    80204338:	dc5ff0ef          	jal	802040fc <path_copy>
    8020433c:	a021                	j	80204344 <path_normalize+0x1c6>
    8020433e:	0001                	nop
    80204340:	a011                	j	80204344 <path_normalize+0x1c6>
    80204342:	0001                	nop
    80204344:	fc843783          	ld	a5,-56(s0)
    80204348:	0007c783          	lbu	a5,0(a5)
    8020434c:	ec0791e3          	bnez	a5,8020420e <path_normalize+0x90>
    80204350:	a011                	j	80204354 <path_normalize+0x1d6>
    80204352:	0001                	nop
    80204354:	fd842783          	lw	a5,-40(s0)
    80204358:	2781                	sext.w	a5,a5
    8020435a:	10078a63          	beqz	a5,8020446e <path_normalize+0x2f0>
    8020435e:	fdc42783          	lw	a5,-36(s0)
    80204362:	2781                	sext.w	a5,a5
    80204364:	e785                	bnez	a5,8020438c <path_normalize+0x20e>
    80204366:	77fd                	lui	a5,0xfffff
    80204368:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020436a:	97a2                	add	a5,a5,s0
    8020436c:	78c7a703          	lw	a4,1932(a5)
    80204370:	77fd                	lui	a5,0xfffff
    80204372:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204374:	97a2                	add	a5,a5,s0
    80204376:	00003617          	auipc	a2,0x3
    8020437a:	66a60613          	addi	a2,a2,1642 # 802079e0 <user_code_end+0xb70>
    8020437e:	85ba                	mv	a1,a4
    80204380:	7907b503          	ld	a0,1936(a5)
    80204384:	d79ff0ef          	jal	802040fc <path_copy>
    80204388:	4781                	li	a5,0
    8020438a:	aa41                	j	8020451a <path_normalize+0x39c>
    8020438c:	77fd                	lui	a5,0xfffff
    8020438e:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204390:	97a2                	add	a5,a5,s0
    80204392:	7907b783          	ld	a5,1936(a5)
    80204396:	00078023          	sb	zero,0(a5)
    8020439a:	fc042a23          	sw	zero,-44(s0)
    8020439e:	a86d                	j	80204458 <path_normalize+0x2da>
    802043a0:	77fd                	lui	a5,0xfffff
    802043a2:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802043a4:	97a2                	add	a5,a5,s0
    802043a6:	7907b783          	ld	a5,1936(a5)
    802043aa:	0007c783          	lbu	a5,0(a5)
    802043ae:	ef8d                	bnez	a5,802043e8 <path_normalize+0x26a>
    802043b0:	77fd                	lui	a5,0xfffff
    802043b2:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802043b4:	97a2                	add	a5,a5,s0
    802043b6:	78c7a583          	lw	a1,1932(a5)
    802043ba:	77fd                	lui	a5,0xfffff
    802043bc:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    802043c0:	1781                	addi	a5,a5,-32
    802043c2:	00878733          	add	a4,a5,s0
    802043c6:	fd442783          	lw	a5,-44(s0)
    802043ca:	079a                	slli	a5,a5,0x6
    802043cc:	973e                	add	a4,a4,a5
    802043ce:	77fd                	lui	a5,0xfffff
    802043d0:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802043d2:	97a2                	add	a5,a5,s0
    802043d4:	86ba                	mv	a3,a4
    802043d6:	00003617          	auipc	a2,0x3
    802043da:	61260613          	addi	a2,a2,1554 # 802079e8 <user_code_end+0xb78>
    802043de:	7907b503          	ld	a0,1936(a5)
    802043e2:	8acfd0ef          	jal	8020148e <snprintf>
    802043e6:	a0a5                	j	8020444e <path_normalize+0x2d0>
    802043e8:	77fd                	lui	a5,0xfffff
    802043ea:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802043ec:	97a2                	add	a5,a5,s0
    802043ee:	7907b503          	ld	a0,1936(a5)
    802043f2:	bf9ff0ef          	jal	80203fea <str_len>
    802043f6:	87aa                	mv	a5,a0
    802043f8:	873e                	mv	a4,a5
    802043fa:	77fd                	lui	a5,0xfffff
    802043fc:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802043fe:	97a2                	add	a5,a5,s0
    80204400:	7907b783          	ld	a5,1936(a5)
    80204404:	00e784b3          	add	s1,a5,a4
    80204408:	77fd                	lui	a5,0xfffff
    8020440a:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020440c:	97a2                	add	a5,a5,s0
    8020440e:	7907b503          	ld	a0,1936(a5)
    80204412:	bd9ff0ef          	jal	80203fea <str_len>
    80204416:	87aa                	mv	a5,a0
    80204418:	873e                	mv	a4,a5
    8020441a:	77fd                	lui	a5,0xfffff
    8020441c:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020441e:	97a2                	add	a5,a5,s0
    80204420:	78c7a783          	lw	a5,1932(a5)
    80204424:	9f99                	subw	a5,a5,a4
    80204426:	2781                	sext.w	a5,a5
    80204428:	85be                	mv	a1,a5
    8020442a:	77fd                	lui	a5,0xfffff
    8020442c:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    80204430:	1781                	addi	a5,a5,-32
    80204432:	00878733          	add	a4,a5,s0
    80204436:	fd442783          	lw	a5,-44(s0)
    8020443a:	079a                	slli	a5,a5,0x6
    8020443c:	97ba                	add	a5,a5,a4
    8020443e:	86be                	mv	a3,a5
    80204440:	00003617          	auipc	a2,0x3
    80204444:	5a860613          	addi	a2,a2,1448 # 802079e8 <user_code_end+0xb78>
    80204448:	8526                	mv	a0,s1
    8020444a:	844fd0ef          	jal	8020148e <snprintf>
    8020444e:	fd442783          	lw	a5,-44(s0)
    80204452:	2785                	addiw	a5,a5,1
    80204454:	fcf42a23          	sw	a5,-44(s0)
    80204458:	fd442783          	lw	a5,-44(s0)
    8020445c:	873e                	mv	a4,a5
    8020445e:	fdc42783          	lw	a5,-36(s0)
    80204462:	2701                	sext.w	a4,a4
    80204464:	2781                	sext.w	a5,a5
    80204466:	f2f74de3          	blt	a4,a5,802043a0 <path_normalize+0x222>
    8020446a:	4781                	li	a5,0
    8020446c:	a07d                	j	8020451a <path_normalize+0x39c>
    8020446e:	77fd                	lui	a5,0xfffff
    80204470:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204472:	97a2                	add	a5,a5,s0
    80204474:	78c7a703          	lw	a4,1932(a5)
    80204478:	77fd                	lui	a5,0xfffff
    8020447a:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020447c:	97a2                	add	a5,a5,s0
    8020447e:	0000b617          	auipc	a2,0xb
    80204482:	b8a60613          	addi	a2,a2,-1142 # 8020f008 <cwd>
    80204486:	85ba                	mv	a1,a4
    80204488:	7907b503          	ld	a0,1936(a5)
    8020448c:	c71ff0ef          	jal	802040fc <path_copy>
    80204490:	fc042a23          	sw	zero,-44(s0)
    80204494:	a88d                	j	80204506 <path_normalize+0x388>
    80204496:	77fd                	lui	a5,0xfffff
    80204498:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    8020449a:	97a2                	add	a5,a5,s0
    8020449c:	7907b503          	ld	a0,1936(a5)
    802044a0:	b4bff0ef          	jal	80203fea <str_len>
    802044a4:	87aa                	mv	a5,a0
    802044a6:	873e                	mv	a4,a5
    802044a8:	77fd                	lui	a5,0xfffff
    802044aa:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802044ac:	97a2                	add	a5,a5,s0
    802044ae:	7907b783          	ld	a5,1936(a5)
    802044b2:	00e784b3          	add	s1,a5,a4
    802044b6:	77fd                	lui	a5,0xfffff
    802044b8:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802044ba:	97a2                	add	a5,a5,s0
    802044bc:	7907b503          	ld	a0,1936(a5)
    802044c0:	b2bff0ef          	jal	80203fea <str_len>
    802044c4:	87aa                	mv	a5,a0
    802044c6:	873e                	mv	a4,a5
    802044c8:	77fd                	lui	a5,0xfffff
    802044ca:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    802044cc:	97a2                	add	a5,a5,s0
    802044ce:	78c7a783          	lw	a5,1932(a5)
    802044d2:	9f99                	subw	a5,a5,a4
    802044d4:	2781                	sext.w	a5,a5
    802044d6:	85be                	mv	a1,a5
    802044d8:	77fd                	lui	a5,0xfffff
    802044da:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    802044de:	1781                	addi	a5,a5,-32
    802044e0:	00878733          	add	a4,a5,s0
    802044e4:	fd442783          	lw	a5,-44(s0)
    802044e8:	079a                	slli	a5,a5,0x6
    802044ea:	97ba                	add	a5,a5,a4
    802044ec:	86be                	mv	a3,a5
    802044ee:	00003617          	auipc	a2,0x3
    802044f2:	4fa60613          	addi	a2,a2,1274 # 802079e8 <user_code_end+0xb78>
    802044f6:	8526                	mv	a0,s1
    802044f8:	f97fc0ef          	jal	8020148e <snprintf>
    802044fc:	fd442783          	lw	a5,-44(s0)
    80204500:	2785                	addiw	a5,a5,1
    80204502:	fcf42a23          	sw	a5,-44(s0)
    80204506:	fd442783          	lw	a5,-44(s0)
    8020450a:	873e                	mv	a4,a5
    8020450c:	fdc42783          	lw	a5,-36(s0)
    80204510:	2701                	sext.w	a4,a4
    80204512:	2781                	sext.w	a5,a5
    80204514:	f8f741e3          	blt	a4,a5,80204496 <path_normalize+0x318>
    80204518:	4781                	li	a5,0
    8020451a:	853e                	mv	a0,a5
    8020451c:	7f010113          	addi	sp,sp,2032
    80204520:	70aa                	ld	ra,168(sp)
    80204522:	740a                	ld	s0,160(sp)
    80204524:	64ea                	ld	s1,152(sp)
    80204526:	614d                	addi	sp,sp,176
    80204528:	8082                	ret

000000008020452a <lookup_path>:
    8020452a:	7175                	addi	sp,sp,-144
    8020452c:	e506                	sd	ra,136(sp)
    8020452e:	e122                	sd	s0,128(sp)
    80204530:	0900                	addi	s0,sp,144
    80204532:	f6a43c23          	sd	a0,-136(s0)
    80204536:	f8840793          	addi	a5,s0,-120
    8020453a:	06000613          	li	a2,96
    8020453e:	85be                	mv	a1,a5
    80204540:	f7843503          	ld	a0,-136(s0)
    80204544:	c3bff0ef          	jal	8020417e <path_normalize>
    80204548:	87aa                	mv	a5,a0
    8020454a:	0007d463          	bgez	a5,80204552 <lookup_path+0x28>
    8020454e:	4781                	li	a5,0
    80204550:	a061                	j	802045d8 <lookup_path+0xae>
    80204552:	fe042623          	sw	zero,-20(s0)
    80204556:	a885                	j	802045c6 <lookup_path+0x9c>
    80204558:	00013717          	auipc	a4,0x13
    8020455c:	98070713          	addi	a4,a4,-1664 # 80216ed8 <nodes>
    80204560:	fec42683          	lw	a3,-20(s0)
    80204564:	6791                	lui	a5,0x4
    80204566:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020456a:	02f687b3          	mul	a5,a3,a5
    8020456e:	97ba                	add	a5,a5,a4
    80204570:	6711                	lui	a4,0x4
    80204572:	97ba                	add	a5,a5,a4
    80204574:	57fc                	lw	a5,108(a5)
    80204576:	c3b1                	beqz	a5,802045ba <lookup_path+0x90>
    80204578:	fec42703          	lw	a4,-20(s0)
    8020457c:	6791                	lui	a5,0x4
    8020457e:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204582:	02f70733          	mul	a4,a4,a5
    80204586:	00013797          	auipc	a5,0x13
    8020458a:	95278793          	addi	a5,a5,-1710 # 80216ed8 <nodes>
    8020458e:	97ba                	add	a5,a5,a4
    80204590:	f8840713          	addi	a4,s0,-120
    80204594:	85ba                	mv	a1,a4
    80204596:	853e                	mv	a0,a5
    80204598:	a93ff0ef          	jal	8020402a <str_eq>
    8020459c:	87aa                	mv	a5,a0
    8020459e:	cf99                	beqz	a5,802045bc <lookup_path+0x92>
    802045a0:	fec42703          	lw	a4,-20(s0)
    802045a4:	6791                	lui	a5,0x4
    802045a6:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802045aa:	02f70733          	mul	a4,a4,a5
    802045ae:	00013797          	auipc	a5,0x13
    802045b2:	92a78793          	addi	a5,a5,-1750 # 80216ed8 <nodes>
    802045b6:	97ba                	add	a5,a5,a4
    802045b8:	a005                	j	802045d8 <lookup_path+0xae>
    802045ba:	0001                	nop
    802045bc:	fec42783          	lw	a5,-20(s0)
    802045c0:	2785                	addiw	a5,a5,1
    802045c2:	fef42623          	sw	a5,-20(s0)
    802045c6:	fec42783          	lw	a5,-20(s0)
    802045ca:	0007871b          	sext.w	a4,a5
    802045ce:	03f00793          	li	a5,63
    802045d2:	f8e7d3e3          	bge	a5,a4,80204558 <lookup_path+0x2e>
    802045d6:	4781                	li	a5,0
    802045d8:	853e                	mv	a0,a5
    802045da:	60aa                	ld	ra,136(sp)
    802045dc:	640a                	ld	s0,128(sp)
    802045de:	6149                	addi	sp,sp,144
    802045e0:	8082                	ret

00000000802045e2 <alloc_node>:
    802045e2:	1101                	addi	sp,sp,-32
    802045e4:	ec06                	sd	ra,24(sp)
    802045e6:	e822                	sd	s0,16(sp)
    802045e8:	1000                	addi	s0,sp,32
    802045ea:	fe042623          	sw	zero,-20(s0)
    802045ee:	a099                	j	80204634 <alloc_node+0x52>
    802045f0:	00013717          	auipc	a4,0x13
    802045f4:	8e870713          	addi	a4,a4,-1816 # 80216ed8 <nodes>
    802045f8:	fec42683          	lw	a3,-20(s0)
    802045fc:	6791                	lui	a5,0x4
    802045fe:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204602:	02f687b3          	mul	a5,a3,a5
    80204606:	97ba                	add	a5,a5,a4
    80204608:	6711                	lui	a4,0x4
    8020460a:	97ba                	add	a5,a5,a4
    8020460c:	57fc                	lw	a5,108(a5)
    8020460e:	ef91                	bnez	a5,8020462a <alloc_node+0x48>
    80204610:	fec42703          	lw	a4,-20(s0)
    80204614:	6791                	lui	a5,0x4
    80204616:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020461a:	02f70733          	mul	a4,a4,a5
    8020461e:	00013797          	auipc	a5,0x13
    80204622:	8ba78793          	addi	a5,a5,-1862 # 80216ed8 <nodes>
    80204626:	97ba                	add	a5,a5,a4
    80204628:	a839                	j	80204646 <alloc_node+0x64>
    8020462a:	fec42783          	lw	a5,-20(s0)
    8020462e:	2785                	addiw	a5,a5,1
    80204630:	fef42623          	sw	a5,-20(s0)
    80204634:	fec42783          	lw	a5,-20(s0)
    80204638:	0007871b          	sext.w	a4,a5
    8020463c:	03f00793          	li	a5,63
    80204640:	fae7d8e3          	bge	a5,a4,802045f0 <alloc_node+0xe>
    80204644:	4781                	li	a5,0
    80204646:	853e                	mv	a0,a5
    80204648:	60e2                	ld	ra,24(sp)
    8020464a:	6442                	ld	s0,16(sp)
    8020464c:	6105                	addi	sp,sp,32
    8020464e:	8082                	ret

0000000080204650 <parent_path>:
    80204650:	7139                	addi	sp,sp,-64
    80204652:	fc06                	sd	ra,56(sp)
    80204654:	f822                	sd	s0,48(sp)
    80204656:	0080                	addi	s0,sp,64
    80204658:	fca43c23          	sd	a0,-40(s0)
    8020465c:	fcb43823          	sd	a1,-48(s0)
    80204660:	87b2                	mv	a5,a2
    80204662:	fcf42623          	sw	a5,-52(s0)
    80204666:	fd843503          	ld	a0,-40(s0)
    8020466a:	981ff0ef          	jal	80203fea <str_len>
    8020466e:	87aa                	mv	a5,a0
    80204670:	fef42623          	sw	a5,-20(s0)
    80204674:	a031                	j	80204680 <parent_path+0x30>
    80204676:	fec42783          	lw	a5,-20(s0)
    8020467a:	37fd                	addiw	a5,a5,-1
    8020467c:	fef42623          	sw	a5,-20(s0)
    80204680:	fec42783          	lw	a5,-20(s0)
    80204684:	2781                	sext.w	a5,a5
    80204686:	02f05563          	blez	a5,802046b0 <parent_path+0x60>
    8020468a:	fec42783          	lw	a5,-20(s0)
    8020468e:	17fd                	addi	a5,a5,-1
    80204690:	fd843703          	ld	a4,-40(s0)
    80204694:	97ba                	add	a5,a5,a4
    80204696:	0007c783          	lbu	a5,0(a5)
    8020469a:	873e                	mv	a4,a5
    8020469c:	02f00793          	li	a5,47
    802046a0:	fcf70be3          	beq	a4,a5,80204676 <parent_path+0x26>
    802046a4:	a031                	j	802046b0 <parent_path+0x60>
    802046a6:	fec42783          	lw	a5,-20(s0)
    802046aa:	37fd                	addiw	a5,a5,-1
    802046ac:	fef42623          	sw	a5,-20(s0)
    802046b0:	fec42783          	lw	a5,-20(s0)
    802046b4:	2781                	sext.w	a5,a5
    802046b6:	00f05f63          	blez	a5,802046d4 <parent_path+0x84>
    802046ba:	fec42783          	lw	a5,-20(s0)
    802046be:	17fd                	addi	a5,a5,-1
    802046c0:	fd843703          	ld	a4,-40(s0)
    802046c4:	97ba                	add	a5,a5,a4
    802046c6:	0007c783          	lbu	a5,0(a5)
    802046ca:	873e                	mv	a4,a5
    802046cc:	02f00793          	li	a5,47
    802046d0:	fcf71be3          	bne	a4,a5,802046a6 <parent_path+0x56>
    802046d4:	fec42783          	lw	a5,-20(s0)
    802046d8:	2781                	sext.w	a5,a5
    802046da:	00f04f63          	bgtz	a5,802046f8 <parent_path+0xa8>
    802046de:	fcc42783          	lw	a5,-52(s0)
    802046e2:	00003617          	auipc	a2,0x3
    802046e6:	2fe60613          	addi	a2,a2,766 # 802079e0 <user_code_end+0xb70>
    802046ea:	85be                	mv	a1,a5
    802046ec:	fd043503          	ld	a0,-48(s0)
    802046f0:	a0dff0ef          	jal	802040fc <path_copy>
    802046f4:	4781                	li	a5,0
    802046f6:	a861                	j	8020478e <parent_path+0x13e>
    802046f8:	fec42783          	lw	a5,-20(s0)
    802046fc:	0007871b          	sext.w	a4,a5
    80204700:	4785                	li	a5,1
    80204702:	00f71f63          	bne	a4,a5,80204720 <parent_path+0xd0>
    80204706:	fcc42783          	lw	a5,-52(s0)
    8020470a:	00003617          	auipc	a2,0x3
    8020470e:	2d660613          	addi	a2,a2,726 # 802079e0 <user_code_end+0xb70>
    80204712:	85be                	mv	a1,a5
    80204714:	fd043503          	ld	a0,-48(s0)
    80204718:	9e5ff0ef          	jal	802040fc <path_copy>
    8020471c:	4781                	li	a5,0
    8020471e:	a885                	j	8020478e <parent_path+0x13e>
    80204720:	fec42783          	lw	a5,-20(s0)
    80204724:	37fd                	addiw	a5,a5,-1
    80204726:	fef42423          	sw	a5,-24(s0)
    8020472a:	fe842783          	lw	a5,-24(s0)
    8020472e:	873e                	mv	a4,a5
    80204730:	fcc42783          	lw	a5,-52(s0)
    80204734:	2701                	sext.w	a4,a4
    80204736:	2781                	sext.w	a5,a5
    80204738:	00f74463          	blt	a4,a5,80204740 <parent_path+0xf0>
    8020473c:	57fd                	li	a5,-1
    8020473e:	a881                	j	8020478e <parent_path+0x13e>
    80204740:	fe042623          	sw	zero,-20(s0)
    80204744:	a025                	j	8020476c <parent_path+0x11c>
    80204746:	fec42783          	lw	a5,-20(s0)
    8020474a:	fd843703          	ld	a4,-40(s0)
    8020474e:	973e                	add	a4,a4,a5
    80204750:	fec42783          	lw	a5,-20(s0)
    80204754:	fd043683          	ld	a3,-48(s0)
    80204758:	97b6                	add	a5,a5,a3
    8020475a:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    8020475e:	00e78023          	sb	a4,0(a5)
    80204762:	fec42783          	lw	a5,-20(s0)
    80204766:	2785                	addiw	a5,a5,1
    80204768:	fef42623          	sw	a5,-20(s0)
    8020476c:	fec42783          	lw	a5,-20(s0)
    80204770:	873e                	mv	a4,a5
    80204772:	fe842783          	lw	a5,-24(s0)
    80204776:	2701                	sext.w	a4,a4
    80204778:	2781                	sext.w	a5,a5
    8020477a:	fcf746e3          	blt	a4,a5,80204746 <parent_path+0xf6>
    8020477e:	fe842783          	lw	a5,-24(s0)
    80204782:	fd043703          	ld	a4,-48(s0)
    80204786:	97ba                	add	a5,a5,a4
    80204788:	00078023          	sb	zero,0(a5)
    8020478c:	4781                	li	a5,0
    8020478e:	853e                	mv	a0,a5
    80204790:	70e2                	ld	ra,56(sp)
    80204792:	7442                	ld	s0,48(sp)
    80204794:	6121                	addi	sp,sp,64
    80204796:	8082                	ret

0000000080204798 <fs_mkdir>:
    80204798:	7151                	addi	sp,sp,-240
    8020479a:	f586                	sd	ra,232(sp)
    8020479c:	f1a2                	sd	s0,224(sp)
    8020479e:	1980                	addi	s0,sp,240
    802047a0:	f0a43c23          	sd	a0,-232(s0)
    802047a4:	f8040793          	addi	a5,s0,-128
    802047a8:	06000613          	li	a2,96
    802047ac:	85be                	mv	a1,a5
    802047ae:	f1843503          	ld	a0,-232(s0)
    802047b2:	9cdff0ef          	jal	8020417e <path_normalize>
    802047b6:	87aa                	mv	a5,a0
    802047b8:	0007d463          	bgez	a5,802047c0 <fs_mkdir+0x28>
    802047bc:	57fd                	li	a5,-1
    802047be:	a23d                	j	802048ec <fs_mkdir+0x154>
    802047c0:	f8040793          	addi	a5,s0,-128
    802047c4:	853e                	mv	a0,a5
    802047c6:	d65ff0ef          	jal	8020452a <lookup_path>
    802047ca:	87aa                	mv	a5,a0
    802047cc:	c399                	beqz	a5,802047d2 <fs_mkdir+0x3a>
    802047ce:	4781                	li	a5,0
    802047d0:	aa31                	j	802048ec <fs_mkdir+0x154>
    802047d2:	f8040793          	addi	a5,s0,-128
    802047d6:	00003597          	auipc	a1,0x3
    802047da:	20a58593          	addi	a1,a1,522 # 802079e0 <user_code_end+0xb70>
    802047de:	853e                	mv	a0,a5
    802047e0:	84bff0ef          	jal	8020402a <str_eq>
    802047e4:	87aa                	mv	a5,a0
    802047e6:	c7ad                	beqz	a5,80204850 <fs_mkdir+0xb8>
    802047e8:	dfbff0ef          	jal	802045e2 <alloc_node>
    802047ec:	fea43023          	sd	a0,-32(s0)
    802047f0:	fe043783          	ld	a5,-32(s0)
    802047f4:	e399                	bnez	a5,802047fa <fs_mkdir+0x62>
    802047f6:	57fd                	li	a5,-1
    802047f8:	a8d5                	j	802048ec <fs_mkdir+0x154>
    802047fa:	fe043783          	ld	a5,-32(s0)
    802047fe:	00003617          	auipc	a2,0x3
    80204802:	1e260613          	addi	a2,a2,482 # 802079e0 <user_code_end+0xb70>
    80204806:	06000593          	li	a1,96
    8020480a:	853e                	mv	a0,a5
    8020480c:	8f1ff0ef          	jal	802040fc <path_copy>
    80204810:	fe043703          	ld	a4,-32(s0)
    80204814:	6791                	lui	a5,0x4
    80204816:	97ba                	add	a5,a5,a4
    80204818:	4705                	li	a4,1
    8020481a:	d3f8                	sw	a4,100(a5)
    8020481c:	fe043703          	ld	a4,-32(s0)
    80204820:	6791                	lui	a5,0x4
    80204822:	97ba                	add	a5,a5,a4
    80204824:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80204828:	fe043703          	ld	a4,-32(s0)
    8020482c:	6791                	lui	a5,0x4
    8020482e:	97ba                	add	a5,a5,a4
    80204830:	0607a423          	sw	zero,104(a5) # 4068 <STACK_SIZE+0x3068>
    80204834:	fe043703          	ld	a4,-32(s0)
    80204838:	6791                	lui	a5,0x4
    8020483a:	97ba                	add	a5,a5,a4
    8020483c:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    80204840:	fe043703          	ld	a4,-32(s0)
    80204844:	6791                	lui	a5,0x4
    80204846:	97ba                	add	a5,a5,a4
    80204848:	4705                	li	a4,1
    8020484a:	d7f8                	sw	a4,108(a5)
    8020484c:	4781                	li	a5,0
    8020484e:	a879                	j	802048ec <fs_mkdir+0x154>
    80204850:	f2040713          	addi	a4,s0,-224
    80204854:	f8040793          	addi	a5,s0,-128
    80204858:	06000613          	li	a2,96
    8020485c:	85ba                	mv	a1,a4
    8020485e:	853e                	mv	a0,a5
    80204860:	df1ff0ef          	jal	80204650 <parent_path>
    80204864:	f2040793          	addi	a5,s0,-224
    80204868:	853e                	mv	a0,a5
    8020486a:	cc1ff0ef          	jal	8020452a <lookup_path>
    8020486e:	fea43423          	sd	a0,-24(s0)
    80204872:	fe843783          	ld	a5,-24(s0)
    80204876:	c799                	beqz	a5,80204884 <fs_mkdir+0xec>
    80204878:	fe843703          	ld	a4,-24(s0)
    8020487c:	6791                	lui	a5,0x4
    8020487e:	97ba                	add	a5,a5,a4
    80204880:	53fc                	lw	a5,100(a5)
    80204882:	e399                	bnez	a5,80204888 <fs_mkdir+0xf0>
    80204884:	57fd                	li	a5,-1
    80204886:	a09d                	j	802048ec <fs_mkdir+0x154>
    80204888:	d5bff0ef          	jal	802045e2 <alloc_node>
    8020488c:	fea43023          	sd	a0,-32(s0)
    80204890:	fe043783          	ld	a5,-32(s0)
    80204894:	e399                	bnez	a5,8020489a <fs_mkdir+0x102>
    80204896:	57fd                	li	a5,-1
    80204898:	a891                	j	802048ec <fs_mkdir+0x154>
    8020489a:	fe043783          	ld	a5,-32(s0)
    8020489e:	f8040713          	addi	a4,s0,-128
    802048a2:	863a                	mv	a2,a4
    802048a4:	06000593          	li	a1,96
    802048a8:	853e                	mv	a0,a5
    802048aa:	853ff0ef          	jal	802040fc <path_copy>
    802048ae:	fe043703          	ld	a4,-32(s0)
    802048b2:	6791                	lui	a5,0x4
    802048b4:	97ba                	add	a5,a5,a4
    802048b6:	4705                	li	a4,1
    802048b8:	d3f8                	sw	a4,100(a5)
    802048ba:	fe043703          	ld	a4,-32(s0)
    802048be:	6791                	lui	a5,0x4
    802048c0:	97ba                	add	a5,a5,a4
    802048c2:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802048c6:	fe043703          	ld	a4,-32(s0)
    802048ca:	6791                	lui	a5,0x4
    802048cc:	97ba                	add	a5,a5,a4
    802048ce:	0607a423          	sw	zero,104(a5) # 4068 <STACK_SIZE+0x3068>
    802048d2:	fe043703          	ld	a4,-32(s0)
    802048d6:	6791                	lui	a5,0x4
    802048d8:	97ba                	add	a5,a5,a4
    802048da:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    802048de:	fe043703          	ld	a4,-32(s0)
    802048e2:	6791                	lui	a5,0x4
    802048e4:	97ba                	add	a5,a5,a4
    802048e6:	4705                	li	a4,1
    802048e8:	d7f8                	sw	a4,108(a5)
    802048ea:	4781                	li	a5,0
    802048ec:	853e                	mv	a0,a5
    802048ee:	70ae                	ld	ra,232(sp)
    802048f0:	740e                	ld	s0,224(sp)
    802048f2:	616d                	addi	sp,sp,240
    802048f4:	8082                	ret

00000000802048f6 <fs_create>:
    802048f6:	7151                	addi	sp,sp,-240
    802048f8:	f586                	sd	ra,232(sp)
    802048fa:	f1a2                	sd	s0,224(sp)
    802048fc:	1980                	addi	s0,sp,240
    802048fe:	f0a43c23          	sd	a0,-232(s0)
    80204902:	87ae                	mv	a5,a1
    80204904:	f0f42a23          	sw	a5,-236(s0)
    80204908:	f8040793          	addi	a5,s0,-128
    8020490c:	06000613          	li	a2,96
    80204910:	85be                	mv	a1,a5
    80204912:	f1843503          	ld	a0,-232(s0)
    80204916:	869ff0ef          	jal	8020417e <path_normalize>
    8020491a:	87aa                	mv	a5,a0
    8020491c:	0007d463          	bgez	a5,80204924 <fs_create+0x2e>
    80204920:	57fd                	li	a5,-1
    80204922:	a0dd                	j	80204a08 <fs_create+0x112>
    80204924:	f8040793          	addi	a5,s0,-128
    80204928:	853e                	mv	a0,a5
    8020492a:	c01ff0ef          	jal	8020452a <lookup_path>
    8020492e:	87aa                	mv	a5,a0
    80204930:	cb8d                	beqz	a5,80204962 <fs_create+0x6c>
    80204932:	f8040793          	addi	a5,s0,-128
    80204936:	853e                	mv	a0,a5
    80204938:	bf3ff0ef          	jal	8020452a <lookup_path>
    8020493c:	fea43023          	sd	a0,-32(s0)
    80204940:	fe043703          	ld	a4,-32(s0)
    80204944:	6791                	lui	a5,0x4
    80204946:	97ba                	add	a5,a5,a4
    80204948:	53fc                	lw	a5,100(a5)
    8020494a:	c399                	beqz	a5,80204950 <fs_create+0x5a>
    8020494c:	57fd                	li	a5,-1
    8020494e:	a86d                	j	80204a08 <fs_create+0x112>
    80204950:	fe043703          	ld	a4,-32(s0)
    80204954:	6791                	lui	a5,0x4
    80204956:	97ba                	add	a5,a5,a4
    80204958:	f1442703          	lw	a4,-236(s0)
    8020495c:	d7b8                	sw	a4,104(a5)
    8020495e:	4781                	li	a5,0
    80204960:	a065                	j	80204a08 <fs_create+0x112>
    80204962:	f2040713          	addi	a4,s0,-224
    80204966:	f8040793          	addi	a5,s0,-128
    8020496a:	06000613          	li	a2,96
    8020496e:	85ba                	mv	a1,a4
    80204970:	853e                	mv	a0,a5
    80204972:	cdfff0ef          	jal	80204650 <parent_path>
    80204976:	f2040793          	addi	a5,s0,-224
    8020497a:	853e                	mv	a0,a5
    8020497c:	bafff0ef          	jal	8020452a <lookup_path>
    80204980:	fea43423          	sd	a0,-24(s0)
    80204984:	fe843783          	ld	a5,-24(s0)
    80204988:	c799                	beqz	a5,80204996 <fs_create+0xa0>
    8020498a:	fe843703          	ld	a4,-24(s0)
    8020498e:	6791                	lui	a5,0x4
    80204990:	97ba                	add	a5,a5,a4
    80204992:	53fc                	lw	a5,100(a5)
    80204994:	e399                	bnez	a5,8020499a <fs_create+0xa4>
    80204996:	57fd                	li	a5,-1
    80204998:	a885                	j	80204a08 <fs_create+0x112>
    8020499a:	c49ff0ef          	jal	802045e2 <alloc_node>
    8020499e:	fea43023          	sd	a0,-32(s0)
    802049a2:	fe043783          	ld	a5,-32(s0)
    802049a6:	e399                	bnez	a5,802049ac <fs_create+0xb6>
    802049a8:	57fd                	li	a5,-1
    802049aa:	a8b9                	j	80204a08 <fs_create+0x112>
    802049ac:	fe043783          	ld	a5,-32(s0)
    802049b0:	f8040713          	addi	a4,s0,-128
    802049b4:	863a                	mv	a2,a4
    802049b6:	06000593          	li	a1,96
    802049ba:	853e                	mv	a0,a5
    802049bc:	f40ff0ef          	jal	802040fc <path_copy>
    802049c0:	fe043703          	ld	a4,-32(s0)
    802049c4:	6791                	lui	a5,0x4
    802049c6:	97ba                	add	a5,a5,a4
    802049c8:	0607a223          	sw	zero,100(a5) # 4064 <STACK_SIZE+0x3064>
    802049cc:	fe043703          	ld	a4,-32(s0)
    802049d0:	6791                	lui	a5,0x4
    802049d2:	97ba                	add	a5,a5,a4
    802049d4:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802049d8:	fe043783          	ld	a5,-32(s0)
    802049dc:	06078023          	sb	zero,96(a5)
    802049e0:	fe043703          	ld	a4,-32(s0)
    802049e4:	6791                	lui	a5,0x4
    802049e6:	97ba                	add	a5,a5,a4
    802049e8:	f1442703          	lw	a4,-236(s0)
    802049ec:	d7b8                	sw	a4,104(a5)
    802049ee:	fe043703          	ld	a4,-32(s0)
    802049f2:	6791                	lui	a5,0x4
    802049f4:	97ba                	add	a5,a5,a4
    802049f6:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    802049fa:	fe043703          	ld	a4,-32(s0)
    802049fe:	6791                	lui	a5,0x4
    80204a00:	97ba                	add	a5,a5,a4
    80204a02:	4705                	li	a4,1
    80204a04:	d7f8                	sw	a4,108(a5)
    80204a06:	4781                	li	a5,0
    80204a08:	853e                	mv	a0,a5
    80204a0a:	70ae                	ld	ra,232(sp)
    80204a0c:	740e                	ld	s0,224(sp)
    80204a0e:	616d                	addi	sp,sp,240
    80204a10:	8082                	ret

0000000080204a12 <fs_unlink>:
    80204a12:	7175                	addi	sp,sp,-144
    80204a14:	e506                	sd	ra,136(sp)
    80204a16:	e122                	sd	s0,128(sp)
    80204a18:	0900                	addi	s0,sp,144
    80204a1a:	f6a43c23          	sd	a0,-136(s0)
    80204a1e:	f8840793          	addi	a5,s0,-120
    80204a22:	06000613          	li	a2,96
    80204a26:	85be                	mv	a1,a5
    80204a28:	f7843503          	ld	a0,-136(s0)
    80204a2c:	f52ff0ef          	jal	8020417e <path_normalize>
    80204a30:	87aa                	mv	a5,a0
    80204a32:	0007d463          	bgez	a5,80204a3a <fs_unlink+0x28>
    80204a36:	57fd                	li	a5,-1
    80204a38:	a815                	j	80204a6c <fs_unlink+0x5a>
    80204a3a:	f8840793          	addi	a5,s0,-120
    80204a3e:	853e                	mv	a0,a5
    80204a40:	aebff0ef          	jal	8020452a <lookup_path>
    80204a44:	fea43423          	sd	a0,-24(s0)
    80204a48:	fe843783          	ld	a5,-24(s0)
    80204a4c:	c799                	beqz	a5,80204a5a <fs_unlink+0x48>
    80204a4e:	fe843703          	ld	a4,-24(s0)
    80204a52:	6791                	lui	a5,0x4
    80204a54:	97ba                	add	a5,a5,a4
    80204a56:	53fc                	lw	a5,100(a5)
    80204a58:	c399                	beqz	a5,80204a5e <fs_unlink+0x4c>
    80204a5a:	57fd                	li	a5,-1
    80204a5c:	a801                	j	80204a6c <fs_unlink+0x5a>
    80204a5e:	fe843703          	ld	a4,-24(s0)
    80204a62:	6791                	lui	a5,0x4
    80204a64:	97ba                	add	a5,a5,a4
    80204a66:	0607a623          	sw	zero,108(a5) # 406c <STACK_SIZE+0x306c>
    80204a6a:	4781                	li	a5,0
    80204a6c:	853e                	mv	a0,a5
    80204a6e:	60aa                	ld	ra,136(sp)
    80204a70:	640a                	ld	s0,128(sp)
    80204a72:	6149                	addi	sp,sp,144
    80204a74:	8082                	ret

0000000080204a76 <fs_exists>:
    80204a76:	1101                	addi	sp,sp,-32
    80204a78:	ec06                	sd	ra,24(sp)
    80204a7a:	e822                	sd	s0,16(sp)
    80204a7c:	1000                	addi	s0,sp,32
    80204a7e:	fea43423          	sd	a0,-24(s0)
    80204a82:	fe843503          	ld	a0,-24(s0)
    80204a86:	aa5ff0ef          	jal	8020452a <lookup_path>
    80204a8a:	87aa                	mv	a5,a0
    80204a8c:	00f037b3          	snez	a5,a5
    80204a90:	0ff7f793          	zext.b	a5,a5
    80204a94:	2781                	sext.w	a5,a5
    80204a96:	853e                	mv	a0,a5
    80204a98:	60e2                	ld	ra,24(sp)
    80204a9a:	6442                	ld	s0,16(sp)
    80204a9c:	6105                	addi	sp,sp,32
    80204a9e:	8082                	ret

0000000080204aa0 <fs_is_dir>:
    80204aa0:	7179                	addi	sp,sp,-48
    80204aa2:	f406                	sd	ra,40(sp)
    80204aa4:	f022                	sd	s0,32(sp)
    80204aa6:	1800                	addi	s0,sp,48
    80204aa8:	fca43c23          	sd	a0,-40(s0)
    80204aac:	fd843503          	ld	a0,-40(s0)
    80204ab0:	a7bff0ef          	jal	8020452a <lookup_path>
    80204ab4:	fea43423          	sd	a0,-24(s0)
    80204ab8:	fe843783          	ld	a5,-24(s0)
    80204abc:	cb89                	beqz	a5,80204ace <fs_is_dir+0x2e>
    80204abe:	fe843703          	ld	a4,-24(s0)
    80204ac2:	6791                	lui	a5,0x4
    80204ac4:	97ba                	add	a5,a5,a4
    80204ac6:	53fc                	lw	a5,100(a5)
    80204ac8:	c399                	beqz	a5,80204ace <fs_is_dir+0x2e>
    80204aca:	4785                	li	a5,1
    80204acc:	a011                	j	80204ad0 <fs_is_dir+0x30>
    80204ace:	4781                	li	a5,0
    80204ad0:	853e                	mv	a0,a5
    80204ad2:	70a2                	ld	ra,40(sp)
    80204ad4:	7402                	ld	s0,32(sp)
    80204ad6:	6145                	addi	sp,sp,48
    80204ad8:	8082                	ret

0000000080204ada <fs_is_executable>:
    80204ada:	7179                	addi	sp,sp,-48
    80204adc:	f406                	sd	ra,40(sp)
    80204ade:	f022                	sd	s0,32(sp)
    80204ae0:	1800                	addi	s0,sp,48
    80204ae2:	fca43c23          	sd	a0,-40(s0)
    80204ae6:	fd843503          	ld	a0,-40(s0)
    80204aea:	a41ff0ef          	jal	8020452a <lookup_path>
    80204aee:	fea43423          	sd	a0,-24(s0)
    80204af2:	fe843783          	ld	a5,-24(s0)
    80204af6:	cf99                	beqz	a5,80204b14 <fs_is_executable+0x3a>
    80204af8:	fe843703          	ld	a4,-24(s0)
    80204afc:	6791                	lui	a5,0x4
    80204afe:	97ba                	add	a5,a5,a4
    80204b00:	53fc                	lw	a5,100(a5)
    80204b02:	eb89                	bnez	a5,80204b14 <fs_is_executable+0x3a>
    80204b04:	fe843703          	ld	a4,-24(s0)
    80204b08:	6791                	lui	a5,0x4
    80204b0a:	97ba                	add	a5,a5,a4
    80204b0c:	57bc                	lw	a5,104(a5)
    80204b0e:	c399                	beqz	a5,80204b14 <fs_is_executable+0x3a>
    80204b10:	4785                	li	a5,1
    80204b12:	a011                	j	80204b16 <fs_is_executable+0x3c>
    80204b14:	4781                	li	a5,0
    80204b16:	853e                	mv	a0,a5
    80204b18:	70a2                	ld	ra,40(sp)
    80204b1a:	7402                	ld	s0,32(sp)
    80204b1c:	6145                	addi	sp,sp,48
    80204b1e:	8082                	ret

0000000080204b20 <fs_getcwd>:
    80204b20:	1141                	addi	sp,sp,-16
    80204b22:	e406                	sd	ra,8(sp)
    80204b24:	e022                	sd	s0,0(sp)
    80204b26:	0800                	addi	s0,sp,16
    80204b28:	0000a797          	auipc	a5,0xa
    80204b2c:	4e078793          	addi	a5,a5,1248 # 8020f008 <cwd>
    80204b30:	853e                	mv	a0,a5
    80204b32:	60a2                	ld	ra,8(sp)
    80204b34:	6402                	ld	s0,0(sp)
    80204b36:	0141                	addi	sp,sp,16
    80204b38:	8082                	ret

0000000080204b3a <fs_chdir>:
    80204b3a:	7175                	addi	sp,sp,-144
    80204b3c:	e506                	sd	ra,136(sp)
    80204b3e:	e122                	sd	s0,128(sp)
    80204b40:	0900                	addi	s0,sp,144
    80204b42:	f6a43c23          	sd	a0,-136(s0)
    80204b46:	f8840793          	addi	a5,s0,-120
    80204b4a:	06000613          	li	a2,96
    80204b4e:	85be                	mv	a1,a5
    80204b50:	f7843503          	ld	a0,-136(s0)
    80204b54:	e2aff0ef          	jal	8020417e <path_normalize>
    80204b58:	87aa                	mv	a5,a0
    80204b5a:	0007d463          	bgez	a5,80204b62 <fs_chdir+0x28>
    80204b5e:	57fd                	li	a5,-1
    80204b60:	a83d                	j	80204b9e <fs_chdir+0x64>
    80204b62:	f8840793          	addi	a5,s0,-120
    80204b66:	853e                	mv	a0,a5
    80204b68:	9c3ff0ef          	jal	8020452a <lookup_path>
    80204b6c:	fea43423          	sd	a0,-24(s0)
    80204b70:	fe843783          	ld	a5,-24(s0)
    80204b74:	c799                	beqz	a5,80204b82 <fs_chdir+0x48>
    80204b76:	fe843703          	ld	a4,-24(s0)
    80204b7a:	6791                	lui	a5,0x4
    80204b7c:	97ba                	add	a5,a5,a4
    80204b7e:	53fc                	lw	a5,100(a5)
    80204b80:	e399                	bnez	a5,80204b86 <fs_chdir+0x4c>
    80204b82:	57fd                	li	a5,-1
    80204b84:	a829                	j	80204b9e <fs_chdir+0x64>
    80204b86:	f8840793          	addi	a5,s0,-120
    80204b8a:	863e                	mv	a2,a5
    80204b8c:	06000593          	li	a1,96
    80204b90:	0000a517          	auipc	a0,0xa
    80204b94:	47850513          	addi	a0,a0,1144 # 8020f008 <cwd>
    80204b98:	d64ff0ef          	jal	802040fc <path_copy>
    80204b9c:	4781                	li	a5,0
    80204b9e:	853e                	mv	a0,a5
    80204ba0:	60aa                	ld	ra,136(sp)
    80204ba2:	640a                	ld	s0,128(sp)
    80204ba4:	6149                	addi	sp,sp,144
    80204ba6:	8082                	ret

0000000080204ba8 <fs_listdir>:
    80204ba8:	714d                	addi	sp,sp,-336
    80204baa:	e686                	sd	ra,328(sp)
    80204bac:	e2a2                	sd	s0,320(sp)
    80204bae:	fe26                	sd	s1,312(sp)
    80204bb0:	0a80                	addi	s0,sp,336
    80204bb2:	eaa43c23          	sd	a0,-328(s0)
    80204bb6:	eab43823          	sd	a1,-336(s0)
    80204bba:	fc042c23          	sw	zero,-40(s0)
    80204bbe:	f6840793          	addi	a5,s0,-152
    80204bc2:	06000613          	li	a2,96
    80204bc6:	85be                	mv	a1,a5
    80204bc8:	eb843503          	ld	a0,-328(s0)
    80204bcc:	db2ff0ef          	jal	8020417e <path_normalize>
    80204bd0:	87aa                	mv	a5,a0
    80204bd2:	0007d463          	bgez	a5,80204bda <fs_listdir+0x32>
    80204bd6:	57fd                	li	a5,-1
    80204bd8:	aca5                	j	80204e50 <fs_listdir+0x2a8>
    80204bda:	f6840793          	addi	a5,s0,-152
    80204bde:	853e                	mv	a0,a5
    80204be0:	94bff0ef          	jal	8020452a <lookup_path>
    80204be4:	87aa                	mv	a5,a0
    80204be6:	cb81                	beqz	a5,80204bf6 <fs_listdir+0x4e>
    80204be8:	f6840793          	addi	a5,s0,-152
    80204bec:	853e                	mv	a0,a5
    80204bee:	eb3ff0ef          	jal	80204aa0 <fs_is_dir>
    80204bf2:	87aa                	mv	a5,a0
    80204bf4:	e399                	bnez	a5,80204bfa <fs_listdir+0x52>
    80204bf6:	57fd                	li	a5,-1
    80204bf8:	aca1                	j	80204e50 <fs_listdir+0x2a8>
    80204bfa:	f6840713          	addi	a4,s0,-152
    80204bfe:	f0840793          	addi	a5,s0,-248
    80204c02:	86ba                	mv	a3,a4
    80204c04:	00003617          	auipc	a2,0x3
    80204c08:	dec60613          	addi	a2,a2,-532 # 802079f0 <user_code_end+0xb80>
    80204c0c:	06000593          	li	a1,96
    80204c10:	853e                	mv	a0,a5
    80204c12:	87dfc0ef          	jal	8020148e <snprintf>
    80204c16:	f6840793          	addi	a5,s0,-152
    80204c1a:	00003597          	auipc	a1,0x3
    80204c1e:	dc658593          	addi	a1,a1,-570 # 802079e0 <user_code_end+0xb70>
    80204c22:	853e                	mv	a0,a5
    80204c24:	c06ff0ef          	jal	8020402a <str_eq>
    80204c28:	87aa                	mv	a5,a0
    80204c2a:	cf81                	beqz	a5,80204c42 <fs_listdir+0x9a>
    80204c2c:	f0840793          	addi	a5,s0,-248
    80204c30:	00003617          	auipc	a2,0x3
    80204c34:	db060613          	addi	a2,a2,-592 # 802079e0 <user_code_end+0xb70>
    80204c38:	06000593          	li	a1,96
    80204c3c:	853e                	mv	a0,a5
    80204c3e:	cbeff0ef          	jal	802040fc <path_copy>
    80204c42:	fc042e23          	sw	zero,-36(s0)
    80204c46:	aadd                	j	80204e3c <fs_listdir+0x294>
    80204c48:	00012717          	auipc	a4,0x12
    80204c4c:	29070713          	addi	a4,a4,656 # 80216ed8 <nodes>
    80204c50:	fdc42683          	lw	a3,-36(s0)
    80204c54:	6791                	lui	a5,0x4
    80204c56:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204c5a:	02f687b3          	mul	a5,a3,a5
    80204c5e:	97ba                	add	a5,a5,a4
    80204c60:	6711                	lui	a4,0x4
    80204c62:	97ba                	add	a5,a5,a4
    80204c64:	57fc                	lw	a5,108(a5)
    80204c66:	1a078d63          	beqz	a5,80204e20 <fs_listdir+0x278>
    80204c6a:	fdc42703          	lw	a4,-36(s0)
    80204c6e:	6791                	lui	a5,0x4
    80204c70:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204c74:	02f70733          	mul	a4,a4,a5
    80204c78:	00012797          	auipc	a5,0x12
    80204c7c:	26078793          	addi	a5,a5,608 # 80216ed8 <nodes>
    80204c80:	97ba                	add	a5,a5,a4
    80204c82:	f6840713          	addi	a4,s0,-152
    80204c86:	85ba                	mv	a1,a4
    80204c88:	853e                	mv	a0,a5
    80204c8a:	ba0ff0ef          	jal	8020402a <str_eq>
    80204c8e:	87aa                	mv	a5,a0
    80204c90:	18079a63          	bnez	a5,80204e24 <fs_listdir+0x27c>
    80204c94:	f6840793          	addi	a5,s0,-152
    80204c98:	00003597          	auipc	a1,0x3
    80204c9c:	d4858593          	addi	a1,a1,-696 # 802079e0 <user_code_end+0xb70>
    80204ca0:	853e                	mv	a0,a5
    80204ca2:	b88ff0ef          	jal	8020402a <str_eq>
    80204ca6:	87aa                	mv	a5,a0
    80204ca8:	efa9                	bnez	a5,80204d02 <fs_listdir+0x15a>
    80204caa:	fdc42703          	lw	a4,-36(s0)
    80204cae:	6791                	lui	a5,0x4
    80204cb0:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204cb4:	02f70733          	mul	a4,a4,a5
    80204cb8:	00012797          	auipc	a5,0x12
    80204cbc:	22078793          	addi	a5,a5,544 # 80216ed8 <nodes>
    80204cc0:	97ba                	add	a5,a5,a4
    80204cc2:	f0840713          	addi	a4,s0,-248
    80204cc6:	85ba                	mv	a1,a4
    80204cc8:	853e                	mv	a0,a5
    80204cca:	bdeff0ef          	jal	802040a8 <str_prefix>
    80204cce:	87aa                	mv	a5,a0
    80204cd0:	14078c63          	beqz	a5,80204e28 <fs_listdir+0x280>
    80204cd4:	fdc42703          	lw	a4,-36(s0)
    80204cd8:	6791                	lui	a5,0x4
    80204cda:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204cde:	02f70733          	mul	a4,a4,a5
    80204ce2:	00012797          	auipc	a5,0x12
    80204ce6:	1f678793          	addi	a5,a5,502 # 80216ed8 <nodes>
    80204cea:	00f704b3          	add	s1,a4,a5
    80204cee:	f0840793          	addi	a5,s0,-248
    80204cf2:	853e                	mv	a0,a5
    80204cf4:	af6ff0ef          	jal	80203fea <str_len>
    80204cf8:	87aa                	mv	a5,a0
    80204cfa:	97a6                	add	a5,a5,s1
    80204cfc:	fcf43823          	sd	a5,-48(s0)
    80204d00:	a099                	j	80204d46 <fs_listdir+0x19e>
    80204d02:	00012717          	auipc	a4,0x12
    80204d06:	1d670713          	addi	a4,a4,470 # 80216ed8 <nodes>
    80204d0a:	fdc42683          	lw	a3,-36(s0)
    80204d0e:	6791                	lui	a5,0x4
    80204d10:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204d14:	02f687b3          	mul	a5,a3,a5
    80204d18:	97ba                	add	a5,a5,a4
    80204d1a:	0007c783          	lbu	a5,0(a5)
    80204d1e:	873e                	mv	a4,a5
    80204d20:	02f00793          	li	a5,47
    80204d24:	10f71463          	bne	a4,a5,80204e2c <fs_listdir+0x284>
    80204d28:	fdc42703          	lw	a4,-36(s0)
    80204d2c:	6791                	lui	a5,0x4
    80204d2e:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204d32:	02f70733          	mul	a4,a4,a5
    80204d36:	00012797          	auipc	a5,0x12
    80204d3a:	1a278793          	addi	a5,a5,418 # 80216ed8 <nodes>
    80204d3e:	97ba                	add	a5,a5,a4
    80204d40:	0785                	addi	a5,a5,1
    80204d42:	fcf43823          	sd	a5,-48(s0)
    80204d46:	fc042423          	sw	zero,-56(s0)
    80204d4a:	fc042623          	sw	zero,-52(s0)
    80204d4e:	a03d                	j	80204d7c <fs_listdir+0x1d4>
    80204d50:	fcc42783          	lw	a5,-52(s0)
    80204d54:	fd043703          	ld	a4,-48(s0)
    80204d58:	97ba                	add	a5,a5,a4
    80204d5a:	0007c783          	lbu	a5,0(a5)
    80204d5e:	873e                	mv	a4,a5
    80204d60:	02f00793          	li	a5,47
    80204d64:	00f71763          	bne	a4,a5,80204d72 <fs_listdir+0x1ca>
    80204d68:	fc842783          	lw	a5,-56(s0)
    80204d6c:	2785                	addiw	a5,a5,1
    80204d6e:	fcf42423          	sw	a5,-56(s0)
    80204d72:	fcc42783          	lw	a5,-52(s0)
    80204d76:	2785                	addiw	a5,a5,1
    80204d78:	fcf42623          	sw	a5,-52(s0)
    80204d7c:	fcc42783          	lw	a5,-52(s0)
    80204d80:	fd043703          	ld	a4,-48(s0)
    80204d84:	97ba                	add	a5,a5,a4
    80204d86:	0007c783          	lbu	a5,0(a5)
    80204d8a:	f3f9                	bnez	a5,80204d50 <fs_listdir+0x1a8>
    80204d8c:	fc842783          	lw	a5,-56(s0)
    80204d90:	2781                	sext.w	a5,a5
    80204d92:	08f04f63          	bgtz	a5,80204e30 <fs_listdir+0x288>
    80204d96:	ec840793          	addi	a5,s0,-312
    80204d9a:	fd043603          	ld	a2,-48(s0)
    80204d9e:	04000593          	li	a1,64
    80204da2:	853e                	mv	a0,a5
    80204da4:	b58ff0ef          	jal	802040fc <path_copy>
    80204da8:	eb043783          	ld	a5,-336(s0)
    80204dac:	c7a5                	beqz	a5,80204e14 <fs_listdir+0x26c>
    80204dae:	00012717          	auipc	a4,0x12
    80204db2:	12a70713          	addi	a4,a4,298 # 80216ed8 <nodes>
    80204db6:	fdc42683          	lw	a3,-36(s0)
    80204dba:	6791                	lui	a5,0x4
    80204dbc:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204dc0:	02f687b3          	mul	a5,a3,a5
    80204dc4:	97ba                	add	a5,a5,a4
    80204dc6:	6711                	lui	a4,0x4
    80204dc8:	97ba                	add	a5,a5,a4
    80204dca:	53ac                	lw	a1,96(a5)
    80204dcc:	00012717          	auipc	a4,0x12
    80204dd0:	10c70713          	addi	a4,a4,268 # 80216ed8 <nodes>
    80204dd4:	fdc42683          	lw	a3,-36(s0)
    80204dd8:	6791                	lui	a5,0x4
    80204dda:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204dde:	02f687b3          	mul	a5,a3,a5
    80204de2:	97ba                	add	a5,a5,a4
    80204de4:	6711                	lui	a4,0x4
    80204de6:	97ba                	add	a5,a5,a4
    80204de8:	53f0                	lw	a2,100(a5)
    80204dea:	00012717          	auipc	a4,0x12
    80204dee:	0ee70713          	addi	a4,a4,238 # 80216ed8 <nodes>
    80204df2:	fdc42683          	lw	a3,-36(s0)
    80204df6:	6791                	lui	a5,0x4
    80204df8:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204dfc:	02f687b3          	mul	a5,a3,a5
    80204e00:	97ba                	add	a5,a5,a4
    80204e02:	6711                	lui	a4,0x4
    80204e04:	97ba                	add	a5,a5,a4
    80204e06:	57b4                	lw	a3,104(a5)
    80204e08:	ec840713          	addi	a4,s0,-312
    80204e0c:	eb043783          	ld	a5,-336(s0)
    80204e10:	853a                	mv	a0,a4
    80204e12:	9782                	jalr	a5
    80204e14:	fd842783          	lw	a5,-40(s0)
    80204e18:	2785                	addiw	a5,a5,1
    80204e1a:	fcf42c23          	sw	a5,-40(s0)
    80204e1e:	a811                	j	80204e32 <fs_listdir+0x28a>
    80204e20:	0001                	nop
    80204e22:	a801                	j	80204e32 <fs_listdir+0x28a>
    80204e24:	0001                	nop
    80204e26:	a031                	j	80204e32 <fs_listdir+0x28a>
    80204e28:	0001                	nop
    80204e2a:	a021                	j	80204e32 <fs_listdir+0x28a>
    80204e2c:	0001                	nop
    80204e2e:	a011                	j	80204e32 <fs_listdir+0x28a>
    80204e30:	0001                	nop
    80204e32:	fdc42783          	lw	a5,-36(s0)
    80204e36:	2785                	addiw	a5,a5,1
    80204e38:	fcf42e23          	sw	a5,-36(s0)
    80204e3c:	fdc42783          	lw	a5,-36(s0)
    80204e40:	0007871b          	sext.w	a4,a5
    80204e44:	03f00793          	li	a5,63
    80204e48:	e0e7d0e3          	bge	a5,a4,80204c48 <fs_listdir+0xa0>
    80204e4c:	fd842783          	lw	a5,-40(s0)
    80204e50:	853e                	mv	a0,a5
    80204e52:	60b6                	ld	ra,328(sp)
    80204e54:	6416                	ld	s0,320(sp)
    80204e56:	74f2                	ld	s1,312(sp)
    80204e58:	6171                	addi	sp,sp,336
    80204e5a:	8082                	ret

0000000080204e5c <fs_open>:
    80204e5c:	7175                	addi	sp,sp,-144
    80204e5e:	e506                	sd	ra,136(sp)
    80204e60:	e122                	sd	s0,128(sp)
    80204e62:	0900                	addi	s0,sp,144
    80204e64:	f6a43c23          	sd	a0,-136(s0)
    80204e68:	87ae                	mv	a5,a1
    80204e6a:	f6f42a23          	sw	a5,-140(s0)
    80204e6e:	f8840793          	addi	a5,s0,-120
    80204e72:	06000613          	li	a2,96
    80204e76:	85be                	mv	a1,a5
    80204e78:	f7843503          	ld	a0,-136(s0)
    80204e7c:	b02ff0ef          	jal	8020417e <path_normalize>
    80204e80:	87aa                	mv	a5,a0
    80204e82:	0007d463          	bgez	a5,80204e8a <fs_open+0x2e>
    80204e86:	57fd                	li	a5,-1
    80204e88:	a0c9                	j	80204f4a <fs_open+0xee>
    80204e8a:	f8840793          	addi	a5,s0,-120
    80204e8e:	853e                	mv	a0,a5
    80204e90:	e9aff0ef          	jal	8020452a <lookup_path>
    80204e94:	fea43423          	sd	a0,-24(s0)
    80204e98:	fe843783          	ld	a5,-24(s0)
    80204e9c:	eb95                	bnez	a5,80204ed0 <fs_open+0x74>
    80204e9e:	f7442783          	lw	a5,-140(s0)
    80204ea2:	8b91                	andi	a5,a5,4
    80204ea4:	2781                	sext.w	a5,a5
    80204ea6:	c39d                	beqz	a5,80204ecc <fs_open+0x70>
    80204ea8:	4581                	li	a1,0
    80204eaa:	f7843503          	ld	a0,-136(s0)
    80204eae:	a49ff0ef          	jal	802048f6 <fs_create>
    80204eb2:	87aa                	mv	a5,a0
    80204eb4:	0007d463          	bgez	a5,80204ebc <fs_open+0x60>
    80204eb8:	57fd                	li	a5,-1
    80204eba:	a841                	j	80204f4a <fs_open+0xee>
    80204ebc:	f8840793          	addi	a5,s0,-120
    80204ec0:	853e                	mv	a0,a5
    80204ec2:	e68ff0ef          	jal	8020452a <lookup_path>
    80204ec6:	fea43423          	sd	a0,-24(s0)
    80204eca:	a019                	j	80204ed0 <fs_open+0x74>
    80204ecc:	57fd                	li	a5,-1
    80204ece:	a8b5                	j	80204f4a <fs_open+0xee>
    80204ed0:	fe843703          	ld	a4,-24(s0)
    80204ed4:	6791                	lui	a5,0x4
    80204ed6:	97ba                	add	a5,a5,a4
    80204ed8:	53fc                	lw	a5,100(a5)
    80204eda:	c399                	beqz	a5,80204ee0 <fs_open+0x84>
    80204edc:	57fd                	li	a5,-1
    80204ede:	a0b5                	j	80204f4a <fs_open+0xee>
    80204ee0:	f7442783          	lw	a5,-140(s0)
    80204ee4:	8ba1                	andi	a5,a5,8
    80204ee6:	2781                	sext.w	a5,a5
    80204ee8:	c799                	beqz	a5,80204ef6 <fs_open+0x9a>
    80204eea:	fe843703          	ld	a4,-24(s0)
    80204eee:	6791                	lui	a5,0x4
    80204ef0:	97ba                	add	a5,a5,a4
    80204ef2:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80204ef6:	f7442783          	lw	a5,-140(s0)
    80204efa:	8bc1                	andi	a5,a5,16
    80204efc:	2781                	sext.w	a5,a5
    80204efe:	cf81                	beqz	a5,80204f16 <fs_open+0xba>
    80204f00:	fe843703          	ld	a4,-24(s0)
    80204f04:	6791                	lui	a5,0x4
    80204f06:	97ba                	add	a5,a5,a4
    80204f08:	53b8                	lw	a4,96(a5)
    80204f0a:	fe843683          	ld	a3,-24(s0)
    80204f0e:	6791                	lui	a5,0x4
    80204f10:	97b6                	add	a5,a5,a3
    80204f12:	dbb8                	sw	a4,112(a5)
    80204f14:	a039                	j	80204f22 <fs_open+0xc6>
    80204f16:	fe843703          	ld	a4,-24(s0)
    80204f1a:	6791                	lui	a5,0x4
    80204f1c:	97ba                	add	a5,a5,a4
    80204f1e:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    80204f22:	fe843703          	ld	a4,-24(s0)
    80204f26:	00012797          	auipc	a5,0x12
    80204f2a:	fb278793          	addi	a5,a5,-78 # 80216ed8 <nodes>
    80204f2e:	40f707b3          	sub	a5,a4,a5
    80204f32:	4027d713          	srai	a4,a5,0x2
    80204f36:	00003797          	auipc	a5,0x3
    80204f3a:	ada78793          	addi	a5,a5,-1318 # 80207a10 <user_code_end+0xba0>
    80204f3e:	639c                	ld	a5,0(a5)
    80204f40:	02f707b3          	mul	a5,a4,a5
    80204f44:	2781                	sext.w	a5,a5
    80204f46:	278d                	addiw	a5,a5,3
    80204f48:	2781                	sext.w	a5,a5
    80204f4a:	853e                	mv	a0,a5
    80204f4c:	60aa                	ld	ra,136(sp)
    80204f4e:	640a                	ld	s0,128(sp)
    80204f50:	6149                	addi	sp,sp,144
    80204f52:	8082                	ret

0000000080204f54 <fs_size>:
    80204f54:	7179                	addi	sp,sp,-48
    80204f56:	f406                	sd	ra,40(sp)
    80204f58:	f022                	sd	s0,32(sp)
    80204f5a:	1800                	addi	s0,sp,48
    80204f5c:	87aa                	mv	a5,a0
    80204f5e:	fcf42e23          	sw	a5,-36(s0)
    80204f62:	fdc42783          	lw	a5,-36(s0)
    80204f66:	37f5                	addiw	a5,a5,-3
    80204f68:	fef42623          	sw	a5,-20(s0)
    80204f6c:	fdc42783          	lw	a5,-36(s0)
    80204f70:	0007871b          	sext.w	a4,a5
    80204f74:	4789                	li	a5,2
    80204f76:	02e7da63          	bge	a5,a4,80204faa <fs_size+0x56>
    80204f7a:	fec42783          	lw	a5,-20(s0)
    80204f7e:	0007871b          	sext.w	a4,a5
    80204f82:	03f00793          	li	a5,63
    80204f86:	02e7c263          	blt	a5,a4,80204faa <fs_size+0x56>
    80204f8a:	00012717          	auipc	a4,0x12
    80204f8e:	f4e70713          	addi	a4,a4,-178 # 80216ed8 <nodes>
    80204f92:	fec42683          	lw	a3,-20(s0)
    80204f96:	6791                	lui	a5,0x4
    80204f98:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204f9c:	02f687b3          	mul	a5,a3,a5
    80204fa0:	97ba                	add	a5,a5,a4
    80204fa2:	6711                	lui	a4,0x4
    80204fa4:	97ba                	add	a5,a5,a4
    80204fa6:	57fc                	lw	a5,108(a5)
    80204fa8:	e399                	bnez	a5,80204fae <fs_size+0x5a>
    80204faa:	57fd                	li	a5,-1
    80204fac:	a005                	j	80204fcc <fs_size+0x78>
    80204fae:	00012717          	auipc	a4,0x12
    80204fb2:	f2a70713          	addi	a4,a4,-214 # 80216ed8 <nodes>
    80204fb6:	fec42683          	lw	a3,-20(s0)
    80204fba:	6791                	lui	a5,0x4
    80204fbc:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204fc0:	02f687b3          	mul	a5,a3,a5
    80204fc4:	97ba                	add	a5,a5,a4
    80204fc6:	6711                	lui	a4,0x4
    80204fc8:	97ba                	add	a5,a5,a4
    80204fca:	53bc                	lw	a5,96(a5)
    80204fcc:	853e                	mv	a0,a5
    80204fce:	70a2                	ld	ra,40(sp)
    80204fd0:	7402                	ld	s0,32(sp)
    80204fd2:	6145                	addi	sp,sp,48
    80204fd4:	8082                	ret

0000000080204fd6 <fs_read>:
    80204fd6:	7179                	addi	sp,sp,-48
    80204fd8:	f406                	sd	ra,40(sp)
    80204fda:	f022                	sd	s0,32(sp)
    80204fdc:	1800                	addi	s0,sp,48
    80204fde:	87aa                	mv	a5,a0
    80204fe0:	fcb43823          	sd	a1,-48(s0)
    80204fe4:	8732                	mv	a4,a2
    80204fe6:	fcf42e23          	sw	a5,-36(s0)
    80204fea:	87ba                	mv	a5,a4
    80204fec:	fcf42c23          	sw	a5,-40(s0)
    80204ff0:	fdc42783          	lw	a5,-36(s0)
    80204ff4:	37f5                	addiw	a5,a5,-3
    80204ff6:	fef42423          	sw	a5,-24(s0)
    80204ffa:	fe042623          	sw	zero,-20(s0)
    80204ffe:	fd043783          	ld	a5,-48(s0)
    80205002:	c7a9                	beqz	a5,8020504c <fs_read+0x76>
    80205004:	fd842783          	lw	a5,-40(s0)
    80205008:	2781                	sext.w	a5,a5
    8020500a:	04f05163          	blez	a5,8020504c <fs_read+0x76>
    8020500e:	fdc42783          	lw	a5,-36(s0)
    80205012:	0007871b          	sext.w	a4,a5
    80205016:	4789                	li	a5,2
    80205018:	02e7da63          	bge	a5,a4,8020504c <fs_read+0x76>
    8020501c:	fe842783          	lw	a5,-24(s0)
    80205020:	0007871b          	sext.w	a4,a5
    80205024:	03f00793          	li	a5,63
    80205028:	02e7c263          	blt	a5,a4,8020504c <fs_read+0x76>
    8020502c:	00012717          	auipc	a4,0x12
    80205030:	eac70713          	addi	a4,a4,-340 # 80216ed8 <nodes>
    80205034:	fe842683          	lw	a3,-24(s0)
    80205038:	6791                	lui	a5,0x4
    8020503a:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020503e:	02f687b3          	mul	a5,a3,a5
    80205042:	97ba                	add	a5,a5,a4
    80205044:	6711                	lui	a4,0x4
    80205046:	97ba                	add	a5,a5,a4
    80205048:	57fc                	lw	a5,108(a5)
    8020504a:	e399                	bnez	a5,80205050 <fs_read+0x7a>
    8020504c:	57fd                	li	a5,-1
    8020504e:	a869                	j	802050e8 <fs_read+0x112>
    80205050:	fe842703          	lw	a4,-24(s0)
    80205054:	6791                	lui	a5,0x4
    80205056:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020505a:	02f70733          	mul	a4,a4,a5
    8020505e:	00012797          	auipc	a5,0x12
    80205062:	e7a78793          	addi	a5,a5,-390 # 80216ed8 <nodes>
    80205066:	97ba                	add	a5,a5,a4
    80205068:	fef43023          	sd	a5,-32(s0)
    8020506c:	fe043703          	ld	a4,-32(s0)
    80205070:	6791                	lui	a5,0x4
    80205072:	97ba                	add	a5,a5,a4
    80205074:	53fc                	lw	a5,100(a5)
    80205076:	c3b1                	beqz	a5,802050ba <fs_read+0xe4>
    80205078:	57fd                	li	a5,-1
    8020507a:	a0bd                	j	802050e8 <fs_read+0x112>
    8020507c:	fe043703          	ld	a4,-32(s0)
    80205080:	6791                	lui	a5,0x4
    80205082:	97ba                	add	a5,a5,a4
    80205084:	5bbc                	lw	a5,112(a5)
    80205086:	0017871b          	addiw	a4,a5,1 # 4001 <STACK_SIZE+0x3001>
    8020508a:	0007069b          	sext.w	a3,a4
    8020508e:	fe043603          	ld	a2,-32(s0)
    80205092:	6711                	lui	a4,0x4
    80205094:	9732                	add	a4,a4,a2
    80205096:	db34                	sw	a3,112(a4)
    80205098:	fec42703          	lw	a4,-20(s0)
    8020509c:	0017069b          	addiw	a3,a4,1 # 4001 <STACK_SIZE+0x3001>
    802050a0:	fed42623          	sw	a3,-20(s0)
    802050a4:	86ba                	mv	a3,a4
    802050a6:	fd043703          	ld	a4,-48(s0)
    802050aa:	9736                	add	a4,a4,a3
    802050ac:	fe043683          	ld	a3,-32(s0)
    802050b0:	97b6                	add	a5,a5,a3
    802050b2:	0607c783          	lbu	a5,96(a5)
    802050b6:	00f70023          	sb	a5,0(a4)
    802050ba:	fec42783          	lw	a5,-20(s0)
    802050be:	873e                	mv	a4,a5
    802050c0:	fd842783          	lw	a5,-40(s0)
    802050c4:	2701                	sext.w	a4,a4
    802050c6:	2781                	sext.w	a5,a5
    802050c8:	00f75e63          	bge	a4,a5,802050e4 <fs_read+0x10e>
    802050cc:	fe043703          	ld	a4,-32(s0)
    802050d0:	6791                	lui	a5,0x4
    802050d2:	97ba                	add	a5,a5,a4
    802050d4:	5bb8                	lw	a4,112(a5)
    802050d6:	fe043683          	ld	a3,-32(s0)
    802050da:	6791                	lui	a5,0x4
    802050dc:	97b6                	add	a5,a5,a3
    802050de:	53bc                	lw	a5,96(a5)
    802050e0:	f8f74ee3          	blt	a4,a5,8020507c <fs_read+0xa6>
    802050e4:	fec42783          	lw	a5,-20(s0)
    802050e8:	853e                	mv	a0,a5
    802050ea:	70a2                	ld	ra,40(sp)
    802050ec:	7402                	ld	s0,32(sp)
    802050ee:	6145                	addi	sp,sp,48
    802050f0:	8082                	ret

00000000802050f2 <fs_write>:
    802050f2:	7179                	addi	sp,sp,-48
    802050f4:	f406                	sd	ra,40(sp)
    802050f6:	f022                	sd	s0,32(sp)
    802050f8:	1800                	addi	s0,sp,48
    802050fa:	87aa                	mv	a5,a0
    802050fc:	fcb43823          	sd	a1,-48(s0)
    80205100:	8732                	mv	a4,a2
    80205102:	fcf42e23          	sw	a5,-36(s0)
    80205106:	87ba                	mv	a5,a4
    80205108:	fcf42c23          	sw	a5,-40(s0)
    8020510c:	fdc42783          	lw	a5,-36(s0)
    80205110:	37f5                	addiw	a5,a5,-3 # 3ffd <STACK_SIZE+0x2ffd>
    80205112:	fef42423          	sw	a5,-24(s0)
    80205116:	fd043783          	ld	a5,-48(s0)
    8020511a:	c7a9                	beqz	a5,80205164 <fs_write+0x72>
    8020511c:	fd842783          	lw	a5,-40(s0)
    80205120:	2781                	sext.w	a5,a5
    80205122:	0407c163          	bltz	a5,80205164 <fs_write+0x72>
    80205126:	fdc42783          	lw	a5,-36(s0)
    8020512a:	0007871b          	sext.w	a4,a5
    8020512e:	4789                	li	a5,2
    80205130:	02e7da63          	bge	a5,a4,80205164 <fs_write+0x72>
    80205134:	fe842783          	lw	a5,-24(s0)
    80205138:	0007871b          	sext.w	a4,a5
    8020513c:	03f00793          	li	a5,63
    80205140:	02e7c263          	blt	a5,a4,80205164 <fs_write+0x72>
    80205144:	00012717          	auipc	a4,0x12
    80205148:	d9470713          	addi	a4,a4,-620 # 80216ed8 <nodes>
    8020514c:	fe842683          	lw	a3,-24(s0)
    80205150:	6791                	lui	a5,0x4
    80205152:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205156:	02f687b3          	mul	a5,a3,a5
    8020515a:	97ba                	add	a5,a5,a4
    8020515c:	6711                	lui	a4,0x4
    8020515e:	97ba                	add	a5,a5,a4
    80205160:	57fc                	lw	a5,108(a5)
    80205162:	e399                	bnez	a5,80205168 <fs_write+0x76>
    80205164:	57fd                	li	a5,-1
    80205166:	a07d                	j	80205214 <fs_write+0x122>
    80205168:	fe842703          	lw	a4,-24(s0)
    8020516c:	6791                	lui	a5,0x4
    8020516e:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205172:	02f70733          	mul	a4,a4,a5
    80205176:	00012797          	auipc	a5,0x12
    8020517a:	d6278793          	addi	a5,a5,-670 # 80216ed8 <nodes>
    8020517e:	97ba                	add	a5,a5,a4
    80205180:	fef43023          	sd	a5,-32(s0)
    80205184:	fe043703          	ld	a4,-32(s0)
    80205188:	6791                	lui	a5,0x4
    8020518a:	97ba                	add	a5,a5,a4
    8020518c:	53fc                	lw	a5,100(a5)
    8020518e:	c399                	beqz	a5,80205194 <fs_write+0xa2>
    80205190:	57fd                	li	a5,-1
    80205192:	a049                	j	80205214 <fs_write+0x122>
    80205194:	fe042623          	sw	zero,-20(s0)
    80205198:	a081                	j	802051d8 <fs_write+0xe6>
    8020519a:	fec42783          	lw	a5,-20(s0)
    8020519e:	fd043703          	ld	a4,-48(s0)
    802051a2:	973e                	add	a4,a4,a5
    802051a4:	fe043683          	ld	a3,-32(s0)
    802051a8:	6791                	lui	a5,0x4
    802051aa:	97b6                	add	a5,a5,a3
    802051ac:	53bc                	lw	a5,96(a5)
    802051ae:	0017869b          	addiw	a3,a5,1 # 4001 <STACK_SIZE+0x3001>
    802051b2:	0006861b          	sext.w	a2,a3
    802051b6:	fe043583          	ld	a1,-32(s0)
    802051ba:	6691                	lui	a3,0x4
    802051bc:	96ae                	add	a3,a3,a1
    802051be:	d2b0                	sw	a2,96(a3)
    802051c0:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    802051c4:	fe043683          	ld	a3,-32(s0)
    802051c8:	97b6                	add	a5,a5,a3
    802051ca:	06e78023          	sb	a4,96(a5)
    802051ce:	fec42783          	lw	a5,-20(s0)
    802051d2:	2785                	addiw	a5,a5,1
    802051d4:	fef42623          	sw	a5,-20(s0)
    802051d8:	fec42783          	lw	a5,-20(s0)
    802051dc:	873e                	mv	a4,a5
    802051de:	fd842783          	lw	a5,-40(s0)
    802051e2:	2701                	sext.w	a4,a4
    802051e4:	2781                	sext.w	a5,a5
    802051e6:	00f75b63          	bge	a4,a5,802051fc <fs_write+0x10a>
    802051ea:	fe043703          	ld	a4,-32(s0)
    802051ee:	6791                	lui	a5,0x4
    802051f0:	97ba                	add	a5,a5,a4
    802051f2:	53b8                	lw	a4,96(a5)
    802051f4:	6791                	lui	a5,0x4
    802051f6:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    802051f8:	fae7d1e3          	bge	a5,a4,8020519a <fs_write+0xa8>
    802051fc:	fe043703          	ld	a4,-32(s0)
    80205200:	6791                	lui	a5,0x4
    80205202:	97ba                	add	a5,a5,a4
    80205204:	53bc                	lw	a5,96(a5)
    80205206:	fe043703          	ld	a4,-32(s0)
    8020520a:	97ba                	add	a5,a5,a4
    8020520c:	06078023          	sb	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80205210:	fec42783          	lw	a5,-20(s0)
    80205214:	853e                	mv	a0,a5
    80205216:	70a2                	ld	ra,40(sp)
    80205218:	7402                	ld	s0,32(sp)
    8020521a:	6145                	addi	sp,sp,48
    8020521c:	8082                	ret

000000008020521e <fs_truncate>:
    8020521e:	7179                	addi	sp,sp,-48
    80205220:	f406                	sd	ra,40(sp)
    80205222:	f022                	sd	s0,32(sp)
    80205224:	1800                	addi	s0,sp,48
    80205226:	87aa                	mv	a5,a0
    80205228:	872e                	mv	a4,a1
    8020522a:	fcf42e23          	sw	a5,-36(s0)
    8020522e:	87ba                	mv	a5,a4
    80205230:	fcf42c23          	sw	a5,-40(s0)
    80205234:	fdc42783          	lw	a5,-36(s0)
    80205238:	37f5                	addiw	a5,a5,-3
    8020523a:	fef42623          	sw	a5,-20(s0)
    8020523e:	fdc42783          	lw	a5,-36(s0)
    80205242:	0007871b          	sext.w	a4,a5
    80205246:	4789                	li	a5,2
    80205248:	02e7da63          	bge	a5,a4,8020527c <fs_truncate+0x5e>
    8020524c:	fec42783          	lw	a5,-20(s0)
    80205250:	0007871b          	sext.w	a4,a5
    80205254:	03f00793          	li	a5,63
    80205258:	02e7c263          	blt	a5,a4,8020527c <fs_truncate+0x5e>
    8020525c:	00012717          	auipc	a4,0x12
    80205260:	c7c70713          	addi	a4,a4,-900 # 80216ed8 <nodes>
    80205264:	fec42683          	lw	a3,-20(s0)
    80205268:	6791                	lui	a5,0x4
    8020526a:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020526e:	02f687b3          	mul	a5,a3,a5
    80205272:	97ba                	add	a5,a5,a4
    80205274:	6711                	lui	a4,0x4
    80205276:	97ba                	add	a5,a5,a4
    80205278:	57fc                	lw	a5,108(a5)
    8020527a:	e399                	bnez	a5,80205280 <fs_truncate+0x62>
    8020527c:	57fd                	li	a5,-1
    8020527e:	a095                	j	802052e2 <fs_truncate+0xc4>
    80205280:	fd842783          	lw	a5,-40(s0)
    80205284:	2781                	sext.w	a5,a5
    80205286:	0007c963          	bltz	a5,80205298 <fs_truncate+0x7a>
    8020528a:	fd842783          	lw	a5,-40(s0)
    8020528e:	0007871b          	sext.w	a4,a5
    80205292:	6791                	lui	a5,0x4
    80205294:	00f74463          	blt	a4,a5,8020529c <fs_truncate+0x7e>
    80205298:	57fd                	li	a5,-1
    8020529a:	a0a1                	j	802052e2 <fs_truncate+0xc4>
    8020529c:	00012717          	auipc	a4,0x12
    802052a0:	c3c70713          	addi	a4,a4,-964 # 80216ed8 <nodes>
    802052a4:	fec42683          	lw	a3,-20(s0)
    802052a8:	6791                	lui	a5,0x4
    802052aa:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802052ae:	02f687b3          	mul	a5,a3,a5
    802052b2:	97ba                	add	a5,a5,a4
    802052b4:	6711                	lui	a4,0x4
    802052b6:	97ba                	add	a5,a5,a4
    802052b8:	fd842703          	lw	a4,-40(s0)
    802052bc:	d3b8                	sw	a4,96(a5)
    802052be:	00012697          	auipc	a3,0x12
    802052c2:	c1a68693          	addi	a3,a3,-998 # 80216ed8 <nodes>
    802052c6:	fd842703          	lw	a4,-40(s0)
    802052ca:	fec42603          	lw	a2,-20(s0)
    802052ce:	6791                	lui	a5,0x4
    802052d0:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802052d4:	02f607b3          	mul	a5,a2,a5
    802052d8:	97b6                	add	a5,a5,a3
    802052da:	97ba                	add	a5,a5,a4
    802052dc:	06078023          	sb	zero,96(a5)
    802052e0:	4781                	li	a5,0
    802052e2:	853e                	mv	a0,a5
    802052e4:	70a2                	ld	ra,40(sp)
    802052e6:	7402                	ld	s0,32(sp)
    802052e8:	6145                	addi	sp,sp,48
    802052ea:	8082                	ret

00000000802052ec <fs_close>:
    802052ec:	7179                	addi	sp,sp,-48
    802052ee:	f406                	sd	ra,40(sp)
    802052f0:	f022                	sd	s0,32(sp)
    802052f2:	1800                	addi	s0,sp,48
    802052f4:	87aa                	mv	a5,a0
    802052f6:	fcf42e23          	sw	a5,-36(s0)
    802052fa:	fdc42783          	lw	a5,-36(s0)
    802052fe:	37f5                	addiw	a5,a5,-3
    80205300:	fef42623          	sw	a5,-20(s0)
    80205304:	fdc42783          	lw	a5,-36(s0)
    80205308:	0007871b          	sext.w	a4,a5
    8020530c:	4789                	li	a5,2
    8020530e:	00e7da63          	bge	a5,a4,80205322 <fs_close+0x36>
    80205312:	fec42783          	lw	a5,-20(s0)
    80205316:	0007871b          	sext.w	a4,a5
    8020531a:	03f00793          	li	a5,63
    8020531e:	00e7d463          	bge	a5,a4,80205326 <fs_close+0x3a>
    80205322:	57fd                	li	a5,-1
    80205324:	a011                	j	80205328 <fs_close+0x3c>
    80205326:	4781                	li	a5,0
    80205328:	853e                	mv	a0,a5
    8020532a:	70a2                	ld	ra,40(sp)
    8020532c:	7402                	ld	s0,32(sp)
    8020532e:	6145                	addi	sp,sp,48
    80205330:	8082                	ret

0000000080205332 <fs_read_file>:
    80205332:	7139                	addi	sp,sp,-64
    80205334:	fc06                	sd	ra,56(sp)
    80205336:	f822                	sd	s0,48(sp)
    80205338:	0080                	addi	s0,sp,64
    8020533a:	fca43c23          	sd	a0,-40(s0)
    8020533e:	fcb43823          	sd	a1,-48(s0)
    80205342:	87b2                	mv	a5,a2
    80205344:	fcf42623          	sw	a5,-52(s0)
    80205348:	4581                	li	a1,0
    8020534a:	fd843503          	ld	a0,-40(s0)
    8020534e:	b0fff0ef          	jal	80204e5c <fs_open>
    80205352:	87aa                	mv	a5,a0
    80205354:	fef42623          	sw	a5,-20(s0)
    80205358:	fec42783          	lw	a5,-20(s0)
    8020535c:	2781                	sext.w	a5,a5
    8020535e:	0007d463          	bgez	a5,80205366 <fs_read_file+0x34>
    80205362:	57fd                	li	a5,-1
    80205364:	a02d                	j	8020538e <fs_read_file+0x5c>
    80205366:	fcc42703          	lw	a4,-52(s0)
    8020536a:	fec42783          	lw	a5,-20(s0)
    8020536e:	863a                	mv	a2,a4
    80205370:	fd043583          	ld	a1,-48(s0)
    80205374:	853e                	mv	a0,a5
    80205376:	c61ff0ef          	jal	80204fd6 <fs_read>
    8020537a:	87aa                	mv	a5,a0
    8020537c:	fef42423          	sw	a5,-24(s0)
    80205380:	fec42783          	lw	a5,-20(s0)
    80205384:	853e                	mv	a0,a5
    80205386:	f67ff0ef          	jal	802052ec <fs_close>
    8020538a:	fe842783          	lw	a5,-24(s0)
    8020538e:	853e                	mv	a0,a5
    80205390:	70e2                	ld	ra,56(sp)
    80205392:	7442                	ld	s0,48(sp)
    80205394:	6121                	addi	sp,sp,64
    80205396:	8082                	ret

0000000080205398 <fs_write_file>:
    80205398:	7139                	addi	sp,sp,-64
    8020539a:	fc06                	sd	ra,56(sp)
    8020539c:	f822                	sd	s0,48(sp)
    8020539e:	0080                	addi	s0,sp,64
    802053a0:	fca43c23          	sd	a0,-40(s0)
    802053a4:	fcb43823          	sd	a1,-48(s0)
    802053a8:	87b2                	mv	a5,a2
    802053aa:	8736                	mv	a4,a3
    802053ac:	fcf42623          	sw	a5,-52(s0)
    802053b0:	87ba                	mv	a5,a4
    802053b2:	fcf42423          	sw	a5,-56(s0)
    802053b6:	4795                	li	a5,5
    802053b8:	fef42623          	sw	a5,-20(s0)
    802053bc:	fc842783          	lw	a5,-56(s0)
    802053c0:	2781                	sext.w	a5,a5
    802053c2:	c799                	beqz	a5,802053d0 <fs_write_file+0x38>
    802053c4:	fec42783          	lw	a5,-20(s0)
    802053c8:	0087e793          	ori	a5,a5,8
    802053cc:	fef42623          	sw	a5,-20(s0)
    802053d0:	fec42783          	lw	a5,-20(s0)
    802053d4:	85be                	mv	a1,a5
    802053d6:	fd843503          	ld	a0,-40(s0)
    802053da:	a83ff0ef          	jal	80204e5c <fs_open>
    802053de:	87aa                	mv	a5,a0
    802053e0:	fef42423          	sw	a5,-24(s0)
    802053e4:	fe842783          	lw	a5,-24(s0)
    802053e8:	2781                	sext.w	a5,a5
    802053ea:	0007d463          	bgez	a5,802053f2 <fs_write_file+0x5a>
    802053ee:	57fd                	li	a5,-1
    802053f0:	a83d                	j	8020542e <fs_write_file+0x96>
    802053f2:	fc842783          	lw	a5,-56(s0)
    802053f6:	2781                	sext.w	a5,a5
    802053f8:	c799                	beqz	a5,80205406 <fs_write_file+0x6e>
    802053fa:	fe842783          	lw	a5,-24(s0)
    802053fe:	4581                	li	a1,0
    80205400:	853e                	mv	a0,a5
    80205402:	e1dff0ef          	jal	8020521e <fs_truncate>
    80205406:	fcc42703          	lw	a4,-52(s0)
    8020540a:	fe842783          	lw	a5,-24(s0)
    8020540e:	863a                	mv	a2,a4
    80205410:	fd043583          	ld	a1,-48(s0)
    80205414:	853e                	mv	a0,a5
    80205416:	cddff0ef          	jal	802050f2 <fs_write>
    8020541a:	87aa                	mv	a5,a0
    8020541c:	fef42223          	sw	a5,-28(s0)
    80205420:	fe842783          	lw	a5,-24(s0)
    80205424:	853e                	mv	a0,a5
    80205426:	ec7ff0ef          	jal	802052ec <fs_close>
    8020542a:	fe442783          	lw	a5,-28(s0)
    8020542e:	853e                	mv	a0,a5
    80205430:	70e2                	ld	ra,56(sp)
    80205432:	7442                	ld	s0,48(sp)
    80205434:	6121                	addi	sp,sp,64
    80205436:	8082                	ret

0000000080205438 <fs_seed_file>:
    80205438:	7135                	addi	sp,sp,-160
    8020543a:	ed06                	sd	ra,152(sp)
    8020543c:	e922                	sd	s0,144(sp)
    8020543e:	1100                	addi	s0,sp,160
    80205440:	f6a43c23          	sd	a0,-136(s0)
    80205444:	f6b43823          	sd	a1,-144(s0)
    80205448:	87b2                	mv	a5,a2
    8020544a:	f6f42623          	sw	a5,-148(s0)
    8020544e:	87b6                	mv	a5,a3
    80205450:	f6f42423          	sw	a5,-152(s0)
    80205454:	87ba                	mv	a5,a4
    80205456:	f6f42223          	sw	a5,-156(s0)
    8020545a:	f8040793          	addi	a5,s0,-128
    8020545e:	06000613          	li	a2,96
    80205462:	85be                	mv	a1,a5
    80205464:	f7843503          	ld	a0,-136(s0)
    80205468:	d17fe0ef          	jal	8020417e <path_normalize>
    8020546c:	87aa                	mv	a5,a0
    8020546e:	1407cd63          	bltz	a5,802055c8 <fs_seed_file+0x190>
    80205472:	f8040793          	addi	a5,s0,-128
    80205476:	853e                	mv	a0,a5
    80205478:	8b2ff0ef          	jal	8020452a <lookup_path>
    8020547c:	fea43423          	sd	a0,-24(s0)
    80205480:	fe843783          	ld	a5,-24(s0)
    80205484:	eb95                	bnez	a5,802054b8 <fs_seed_file+0x80>
    80205486:	f6842783          	lw	a5,-152(s0)
    8020548a:	2781                	sext.w	a5,a5
    8020548c:	c799                	beqz	a5,8020549a <fs_seed_file+0x62>
    8020548e:	f8040793          	addi	a5,s0,-128
    80205492:	853e                	mv	a0,a5
    80205494:	b04ff0ef          	jal	80204798 <fs_mkdir>
    80205498:	a809                	j	802054aa <fs_seed_file+0x72>
    8020549a:	f6442703          	lw	a4,-156(s0)
    8020549e:	f8040793          	addi	a5,s0,-128
    802054a2:	85ba                	mv	a1,a4
    802054a4:	853e                	mv	a0,a5
    802054a6:	c50ff0ef          	jal	802048f6 <fs_create>
    802054aa:	f8040793          	addi	a5,s0,-128
    802054ae:	853e                	mv	a0,a5
    802054b0:	87aff0ef          	jal	8020452a <lookup_path>
    802054b4:	fea43423          	sd	a0,-24(s0)
    802054b8:	fe843783          	ld	a5,-24(s0)
    802054bc:	10078863          	beqz	a5,802055cc <fs_seed_file+0x194>
    802054c0:	f6842783          	lw	a5,-152(s0)
    802054c4:	2781                	sext.w	a5,a5
    802054c6:	cb81                	beqz	a5,802054d6 <fs_seed_file+0x9e>
    802054c8:	fe843703          	ld	a4,-24(s0)
    802054cc:	6791                	lui	a5,0x4
    802054ce:	97ba                	add	a5,a5,a4
    802054d0:	4705                	li	a4,1
    802054d2:	d3f8                	sw	a4,100(a5)
    802054d4:	a8ed                	j	802055ce <fs_seed_file+0x196>
    802054d6:	fe843703          	ld	a4,-24(s0)
    802054da:	6791                	lui	a5,0x4
    802054dc:	97ba                	add	a5,a5,a4
    802054de:	0607a223          	sw	zero,100(a5) # 4064 <STACK_SIZE+0x3064>
    802054e2:	fe843703          	ld	a4,-24(s0)
    802054e6:	6791                	lui	a5,0x4
    802054e8:	97ba                	add	a5,a5,a4
    802054ea:	f6442703          	lw	a4,-156(s0)
    802054ee:	d7b8                	sw	a4,104(a5)
    802054f0:	f6c42783          	lw	a5,-148(s0)
    802054f4:	2781                	sext.w	a5,a5
    802054f6:	0607d063          	bgez	a5,80205556 <fs_seed_file+0x11e>
    802054fa:	fe042223          	sw	zero,-28(s0)
    802054fe:	a025                	j	80205526 <fs_seed_file+0xee>
    80205500:	fe442783          	lw	a5,-28(s0)
    80205504:	f7043703          	ld	a4,-144(s0)
    80205508:	97ba                	add	a5,a5,a4
    8020550a:	0007c703          	lbu	a4,0(a5) # 4000 <STACK_SIZE+0x3000>
    8020550e:	fe843683          	ld	a3,-24(s0)
    80205512:	fe442783          	lw	a5,-28(s0)
    80205516:	97b6                	add	a5,a5,a3
    80205518:	06e78023          	sb	a4,96(a5)
    8020551c:	fe442783          	lw	a5,-28(s0)
    80205520:	2785                	addiw	a5,a5,1
    80205522:	fef42223          	sw	a5,-28(s0)
    80205526:	fe442783          	lw	a5,-28(s0)
    8020552a:	f7043703          	ld	a4,-144(s0)
    8020552e:	97ba                	add	a5,a5,a4
    80205530:	0007c783          	lbu	a5,0(a5)
    80205534:	cb89                	beqz	a5,80205546 <fs_seed_file+0x10e>
    80205536:	fe442783          	lw	a5,-28(s0)
    8020553a:	0007871b          	sext.w	a4,a5
    8020553e:	6791                	lui	a5,0x4
    80205540:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    80205542:	fae7dfe3          	bge	a5,a4,80205500 <fs_seed_file+0xc8>
    80205546:	fe843703          	ld	a4,-24(s0)
    8020554a:	6791                	lui	a5,0x4
    8020554c:	97ba                	add	a5,a5,a4
    8020554e:	fe442703          	lw	a4,-28(s0)
    80205552:	d3b8                	sw	a4,96(a5)
    80205554:	a8b9                	j	802055b2 <fs_seed_file+0x17a>
    80205556:	fe042223          	sw	zero,-28(s0)
    8020555a:	a025                	j	80205582 <fs_seed_file+0x14a>
    8020555c:	fe442783          	lw	a5,-28(s0)
    80205560:	f7043703          	ld	a4,-144(s0)
    80205564:	97ba                	add	a5,a5,a4
    80205566:	0007c703          	lbu	a4,0(a5) # 4000 <STACK_SIZE+0x3000>
    8020556a:	fe843683          	ld	a3,-24(s0)
    8020556e:	fe442783          	lw	a5,-28(s0)
    80205572:	97b6                	add	a5,a5,a3
    80205574:	06e78023          	sb	a4,96(a5)
    80205578:	fe442783          	lw	a5,-28(s0)
    8020557c:	2785                	addiw	a5,a5,1
    8020557e:	fef42223          	sw	a5,-28(s0)
    80205582:	fe442783          	lw	a5,-28(s0)
    80205586:	873e                	mv	a4,a5
    80205588:	f6c42783          	lw	a5,-148(s0)
    8020558c:	2701                	sext.w	a4,a4
    8020558e:	2781                	sext.w	a5,a5
    80205590:	00f75a63          	bge	a4,a5,802055a4 <fs_seed_file+0x16c>
    80205594:	fe442783          	lw	a5,-28(s0)
    80205598:	0007871b          	sext.w	a4,a5
    8020559c:	6791                	lui	a5,0x4
    8020559e:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    802055a0:	fae7dee3          	bge	a5,a4,8020555c <fs_seed_file+0x124>
    802055a4:	fe843703          	ld	a4,-24(s0)
    802055a8:	6791                	lui	a5,0x4
    802055aa:	97ba                	add	a5,a5,a4
    802055ac:	fe442703          	lw	a4,-28(s0)
    802055b0:	d3b8                	sw	a4,96(a5)
    802055b2:	fe843703          	ld	a4,-24(s0)
    802055b6:	6791                	lui	a5,0x4
    802055b8:	97ba                	add	a5,a5,a4
    802055ba:	53bc                	lw	a5,96(a5)
    802055bc:	fe843703          	ld	a4,-24(s0)
    802055c0:	97ba                	add	a5,a5,a4
    802055c2:	06078023          	sb	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802055c6:	a021                	j	802055ce <fs_seed_file+0x196>
    802055c8:	0001                	nop
    802055ca:	a011                	j	802055ce <fs_seed_file+0x196>
    802055cc:	0001                	nop
    802055ce:	60ea                	ld	ra,152(sp)
    802055d0:	644a                	ld	s0,144(sp)
    802055d2:	610d                	addi	sp,sp,160
    802055d4:	8082                	ret

00000000802055d6 <fs_init>:
    802055d6:	1101                	addi	sp,sp,-32
    802055d8:	ec06                	sd	ra,24(sp)
    802055da:	e822                	sd	s0,16(sp)
    802055dc:	1000                	addi	s0,sp,32
    802055de:	fe042623          	sw	zero,-20(s0)
    802055e2:	a035                	j	8020560e <fs_init+0x38>
    802055e4:	00012717          	auipc	a4,0x12
    802055e8:	8f470713          	addi	a4,a4,-1804 # 80216ed8 <nodes>
    802055ec:	fec42683          	lw	a3,-20(s0)
    802055f0:	6791                	lui	a5,0x4
    802055f2:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802055f6:	02f687b3          	mul	a5,a3,a5
    802055fa:	97ba                	add	a5,a5,a4
    802055fc:	6711                	lui	a4,0x4
    802055fe:	97ba                	add	a5,a5,a4
    80205600:	0607a623          	sw	zero,108(a5)
    80205604:	fec42783          	lw	a5,-20(s0)
    80205608:	2785                	addiw	a5,a5,1
    8020560a:	fef42623          	sw	a5,-20(s0)
    8020560e:	fec42783          	lw	a5,-20(s0)
    80205612:	0007871b          	sext.w	a4,a5
    80205616:	03f00793          	li	a5,63
    8020561a:	fce7d5e3          	bge	a5,a4,802055e4 <fs_init+0xe>
    8020561e:	00002517          	auipc	a0,0x2
    80205622:	3c250513          	addi	a0,a0,962 # 802079e0 <user_code_end+0xb70>
    80205626:	972ff0ef          	jal	80204798 <fs_mkdir>
    8020562a:	00002517          	auipc	a0,0x2
    8020562e:	3ce50513          	addi	a0,a0,974 # 802079f8 <user_code_end+0xb88>
    80205632:	966ff0ef          	jal	80204798 <fs_mkdir>
    80205636:	00002517          	auipc	a0,0x2
    8020563a:	3ca50513          	addi	a0,a0,970 # 80207a00 <user_code_end+0xb90>
    8020563e:	95aff0ef          	jal	80204798 <fs_mkdir>
    80205642:	00002617          	auipc	a2,0x2
    80205646:	3be60613          	addi	a2,a2,958 # 80207a00 <user_code_end+0xb90>
    8020564a:	06000593          	li	a1,96
    8020564e:	0000a517          	auipc	a0,0xa
    80205652:	9ba50513          	addi	a0,a0,-1606 # 8020f008 <cwd>
    80205656:	aa7fe0ef          	jal	802040fc <path_copy>
    8020565a:	00e000ef          	jal	80205668 <fs_load_home>
    8020565e:	0001                	nop
    80205660:	60e2                	ld	ra,24(sp)
    80205662:	6442                	ld	s0,16(sp)
    80205664:	6105                	addi	sp,sp,32
    80205666:	8082                	ret

0000000080205668 <fs_load_home>:
    80205668:	1141                	addi	sp,sp,-16
    8020566a:	e406                	sd	ra,8(sp)
    8020566c:	e022                	sd	s0,0(sp)
    8020566e:	0800                	addi	s0,sp,16
    80205670:	4705                	li	a4,1
    80205672:	4681                	li	a3,0
    80205674:	6789                	lui	a5,0x2
    80205676:	1c878613          	addi	a2,a5,456 # 21c8 <STACK_SIZE+0x11c8>
    8020567a:	00003597          	auipc	a1,0x3
    8020567e:	abe58593          	addi	a1,a1,-1346 # 80208138 <home_bin_file_rw.2>
    80205682:	00002517          	auipc	a0,0x2
    80205686:	39650513          	addi	a0,a0,918 # 80207a18 <user_code_end+0xba8>
    8020568a:	dafff0ef          	jal	80205438 <fs_seed_file>
    8020568e:	4701                	li	a4,0
    80205690:	4681                	li	a3,0
    80205692:	3fb00613          	li	a2,1019
    80205696:	00002597          	auipc	a1,0x2
    8020569a:	39a58593          	addi	a1,a1,922 # 80207a30 <user_code_end+0xbc0>
    8020569e:	00002517          	auipc	a0,0x2
    802056a2:	79250513          	addi	a0,a0,1938 # 80207e30 <user_code_end+0xfc0>
    802056a6:	d93ff0ef          	jal	80205438 <fs_seed_file>
    802056aa:	4701                	li	a4,0
    802056ac:	4681                	li	a3,0
    802056ae:	07600613          	li	a2,118
    802056b2:	00002597          	auipc	a1,0x2
    802056b6:	79658593          	addi	a1,a1,1942 # 80207e48 <user_code_end+0xfd8>
    802056ba:	00003517          	auipc	a0,0x3
    802056be:	80650513          	addi	a0,a0,-2042 # 80207ec0 <user_code_end+0x1050>
    802056c2:	d77ff0ef          	jal	80205438 <fs_seed_file>
    802056c6:	4701                	li	a4,0
    802056c8:	4681                	li	a3,0
    802056ca:	05300613          	li	a2,83
    802056ce:	00003597          	auipc	a1,0x3
    802056d2:	80a58593          	addi	a1,a1,-2038 # 80207ed8 <user_code_end+0x1068>
    802056d6:	00003517          	auipc	a0,0x3
    802056da:	85a50513          	addi	a0,a0,-1958 # 80207f30 <user_code_end+0x10c0>
    802056de:	d5bff0ef          	jal	80205438 <fs_seed_file>
    802056e2:	4705                	li	a4,1
    802056e4:	4681                	li	a3,0
    802056e6:	6789                	lui	a5,0x2
    802056e8:	d0078613          	addi	a2,a5,-768 # 1d00 <STACK_SIZE+0xd00>
    802056ec:	00005597          	auipc	a1,0x5
    802056f0:	c1458593          	addi	a1,a1,-1004 # 8020a300 <home_bin_hi.1>
    802056f4:	00003517          	auipc	a0,0x3
    802056f8:	85450513          	addi	a0,a0,-1964 # 80207f48 <user_code_end+0x10d8>
    802056fc:	d3dff0ef          	jal	80205438 <fs_seed_file>
    80205700:	4701                	li	a4,0
    80205702:	4681                	li	a3,0
    80205704:	18000613          	li	a2,384
    80205708:	00003597          	auipc	a1,0x3
    8020570c:	85058593          	addi	a1,a1,-1968 # 80207f58 <user_code_end+0x10e8>
    80205710:	00003517          	auipc	a0,0x3
    80205714:	9d050513          	addi	a0,a0,-1584 # 802080e0 <user_code_end+0x1270>
    80205718:	d21ff0ef          	jal	80205438 <fs_seed_file>
    8020571c:	4705                	li	a4,1
    8020571e:	4681                	li	a3,0
    80205720:	6789                	lui	a5,0x2
    80205722:	a8878613          	addi	a2,a5,-1400 # 1a88 <STACK_SIZE+0xa88>
    80205726:	00007597          	auipc	a1,0x7
    8020572a:	8da58593          	addi	a1,a1,-1830 # 8020c000 <home_bin_spin.0>
    8020572e:	00003517          	auipc	a0,0x3
    80205732:	9c250513          	addi	a0,a0,-1598 # 802080f0 <user_code_end+0x1280>
    80205736:	d03ff0ef          	jal	80205438 <fs_seed_file>
    8020573a:	4701                	li	a4,0
    8020573c:	4681                	li	a3,0
    8020573e:	4679                	li	a2,30
    80205740:	00003597          	auipc	a1,0x3
    80205744:	9c058593          	addi	a1,a1,-1600 # 80208100 <user_code_end+0x1290>
    80205748:	00003517          	auipc	a0,0x3
    8020574c:	9d850513          	addi	a0,a0,-1576 # 80208120 <user_code_end+0x12b0>
    80205750:	ce9ff0ef          	jal	80205438 <fs_seed_file>
    80205754:	0001                	nop
    80205756:	60a2                	ld	ra,8(sp)
    80205758:	6402                	ld	s0,0(sp)
    8020575a:	0141                	addi	sp,sp,16
    8020575c:	8082                	ret

000000008020575e <demo_task0_once>:
    8020575e:	1141                	addi	sp,sp,-16
    80205760:	e406                	sd	ra,8(sp)
    80205762:	e022                	sd	s0,0(sp)
    80205764:	0800                	addi	s0,sp,16
    80205766:	00008517          	auipc	a0,0x8
    8020576a:	32250513          	addi	a0,a0,802 # 8020da88 <home_bin_spin.0+0x1a88>
    8020576e:	ad6fb0ef          	jal	80200a44 <uart_puts>
    80205772:	0001                	nop
    80205774:	60a2                	ld	ra,8(sp)
    80205776:	6402                	ld	s0,0(sp)
    80205778:	0141                	addi	sp,sp,16
    8020577a:	8082                	ret

000000008020577c <demo_task1_once>:
    8020577c:	1141                	addi	sp,sp,-16
    8020577e:	e406                	sd	ra,8(sp)
    80205780:	e022                	sd	s0,0(sp)
    80205782:	0800                	addi	s0,sp,16
    80205784:	00008517          	auipc	a0,0x8
    80205788:	32450513          	addi	a0,a0,804 # 8020daa8 <home_bin_spin.0+0x1aa8>
    8020578c:	ab8fb0ef          	jal	80200a44 <uart_puts>
    80205790:	0001                	nop
    80205792:	60a2                	ld	ra,8(sp)
    80205794:	6402                	ld	s0,0(sp)
    80205796:	0141                	addi	sp,sp,16
    80205798:	8082                	ret

000000008020579a <demo_run_tasks>:
    8020579a:	1141                	addi	sp,sp,-16
    8020579c:	e406                	sd	ra,8(sp)
    8020579e:	e022                	sd	s0,0(sp)
    802057a0:	0800                	addi	s0,sp,16
    802057a2:	00008517          	auipc	a0,0x8
    802057a6:	32650513          	addi	a0,a0,806 # 8020dac8 <home_bin_spin.0+0x1ac8>
    802057aa:	a9afb0ef          	jal	80200a44 <uart_puts>
    802057ae:	fb1ff0ef          	jal	8020575e <demo_task0_once>
    802057b2:	fcbff0ef          	jal	8020577c <demo_task1_once>
    802057b6:	00008517          	auipc	a0,0x8
    802057ba:	35250513          	addi	a0,a0,850 # 8020db08 <home_bin_spin.0+0x1b08>
    802057be:	a86fb0ef          	jal	80200a44 <uart_puts>
    802057c2:	0001                	nop
    802057c4:	60a2                	ld	ra,8(sp)
    802057c6:	6402                	ld	s0,0(sp)
    802057c8:	0141                	addi	sp,sp,16
    802057ca:	8082                	ret

00000000802057cc <os_main>:
    802057cc:	1141                	addi	sp,sp,-16
    802057ce:	e406                	sd	ra,8(sp)
    802057d0:	e022                	sd	s0,0(sp)
    802057d2:	0800                	addi	s0,sp,16
    802057d4:	0001                	nop
    802057d6:	60a2                	ld	ra,8(sp)
    802057d8:	6402                	ld	s0,0(sp)
    802057da:	0141                	addi	sp,sp,16
    802057dc:	8082                	ret

00000000802057de <str_eq>:
    802057de:	1101                	addi	sp,sp,-32
    802057e0:	ec06                	sd	ra,24(sp)
    802057e2:	e822                	sd	s0,16(sp)
    802057e4:	1000                	addi	s0,sp,32
    802057e6:	fea43423          	sd	a0,-24(s0)
    802057ea:	feb43023          	sd	a1,-32(s0)
    802057ee:	a03d                	j	8020581c <str_eq+0x3e>
    802057f0:	fe843783          	ld	a5,-24(s0)
    802057f4:	0007c703          	lbu	a4,0(a5)
    802057f8:	fe043783          	ld	a5,-32(s0)
    802057fc:	0007c783          	lbu	a5,0(a5)
    80205800:	00f70463          	beq	a4,a5,80205808 <str_eq+0x2a>
    80205804:	4781                	li	a5,0
    80205806:	a0b1                	j	80205852 <str_eq+0x74>
    80205808:	fe843783          	ld	a5,-24(s0)
    8020580c:	0785                	addi	a5,a5,1
    8020580e:	fef43423          	sd	a5,-24(s0)
    80205812:	fe043783          	ld	a5,-32(s0)
    80205816:	0785                	addi	a5,a5,1
    80205818:	fef43023          	sd	a5,-32(s0)
    8020581c:	fe843783          	ld	a5,-24(s0)
    80205820:	0007c783          	lbu	a5,0(a5)
    80205824:	c791                	beqz	a5,80205830 <str_eq+0x52>
    80205826:	fe043783          	ld	a5,-32(s0)
    8020582a:	0007c783          	lbu	a5,0(a5)
    8020582e:	f3e9                	bnez	a5,802057f0 <str_eq+0x12>
    80205830:	fe843783          	ld	a5,-24(s0)
    80205834:	0007c703          	lbu	a4,0(a5)
    80205838:	fe043783          	ld	a5,-32(s0)
    8020583c:	0007c783          	lbu	a5,0(a5)
    80205840:	2701                	sext.w	a4,a4
    80205842:	2781                	sext.w	a5,a5
    80205844:	40f707b3          	sub	a5,a4,a5
    80205848:	0017b793          	seqz	a5,a5
    8020584c:	0ff7f793          	zext.b	a5,a5
    80205850:	2781                	sext.w	a5,a5
    80205852:	853e                	mv	a0,a5
    80205854:	60e2                	ld	ra,24(sp)
    80205856:	6442                	ld	s0,16(sp)
    80205858:	6105                	addi	sp,sp,32
    8020585a:	8082                	ret

000000008020585c <str_prefix>:
    8020585c:	1101                	addi	sp,sp,-32
    8020585e:	ec06                	sd	ra,24(sp)
    80205860:	e822                	sd	s0,16(sp)
    80205862:	1000                	addi	s0,sp,32
    80205864:	fea43423          	sd	a0,-24(s0)
    80205868:	feb43023          	sd	a1,-32(s0)
    8020586c:	a03d                	j	8020589a <str_prefix+0x3e>
    8020586e:	fe843783          	ld	a5,-24(s0)
    80205872:	0007c703          	lbu	a4,0(a5)
    80205876:	fe043783          	ld	a5,-32(s0)
    8020587a:	0007c783          	lbu	a5,0(a5)
    8020587e:	00f70463          	beq	a4,a5,80205886 <str_prefix+0x2a>
    80205882:	4781                	li	a5,0
    80205884:	a00d                	j	802058a6 <str_prefix+0x4a>
    80205886:	fe843783          	ld	a5,-24(s0)
    8020588a:	0785                	addi	a5,a5,1
    8020588c:	fef43423          	sd	a5,-24(s0)
    80205890:	fe043783          	ld	a5,-32(s0)
    80205894:	0785                	addi	a5,a5,1
    80205896:	fef43023          	sd	a5,-32(s0)
    8020589a:	fe043783          	ld	a5,-32(s0)
    8020589e:	0007c783          	lbu	a5,0(a5)
    802058a2:	f7f1                	bnez	a5,8020586e <str_prefix+0x12>
    802058a4:	4785                	li	a5,1
    802058a6:	853e                	mv	a0,a5
    802058a8:	60e2                	ld	ra,24(sp)
    802058aa:	6442                	ld	s0,16(sp)
    802058ac:	6105                	addi	sp,sp,32
    802058ae:	8082                	ret

00000000802058b0 <trim_line>:
    802058b0:	7179                	addi	sp,sp,-48
    802058b2:	f406                	sd	ra,40(sp)
    802058b4:	f022                	sd	s0,32(sp)
    802058b6:	1800                	addi	s0,sp,48
    802058b8:	fca43c23          	sd	a0,-40(s0)
    802058bc:	fe042623          	sw	zero,-20(s0)
    802058c0:	fe042423          	sw	zero,-24(s0)
    802058c4:	a031                	j	802058d0 <trim_line+0x20>
    802058c6:	fec42783          	lw	a5,-20(s0)
    802058ca:	2785                	addiw	a5,a5,1
    802058cc:	fef42623          	sw	a5,-20(s0)
    802058d0:	fec42783          	lw	a5,-20(s0)
    802058d4:	fd843703          	ld	a4,-40(s0)
    802058d8:	97ba                	add	a5,a5,a4
    802058da:	0007c783          	lbu	a5,0(a5)
    802058de:	f7e5                	bnez	a5,802058c6 <trim_line+0x16>
    802058e0:	a831                	j	802058fc <trim_line+0x4c>
    802058e2:	fec42783          	lw	a5,-20(s0)
    802058e6:	17fd                	addi	a5,a5,-1
    802058e8:	fd843703          	ld	a4,-40(s0)
    802058ec:	97ba                	add	a5,a5,a4
    802058ee:	00078023          	sb	zero,0(a5)
    802058f2:	fec42783          	lw	a5,-20(s0)
    802058f6:	37fd                	addiw	a5,a5,-1
    802058f8:	fef42623          	sw	a5,-20(s0)
    802058fc:	fec42783          	lw	a5,-20(s0)
    80205900:	2781                	sext.w	a5,a5
    80205902:	06f05963          	blez	a5,80205974 <trim_line+0xc4>
    80205906:	fec42783          	lw	a5,-20(s0)
    8020590a:	17fd                	addi	a5,a5,-1
    8020590c:	fd843703          	ld	a4,-40(s0)
    80205910:	97ba                	add	a5,a5,a4
    80205912:	0007c783          	lbu	a5,0(a5)
    80205916:	873e                	mv	a4,a5
    80205918:	47a9                	li	a5,10
    8020591a:	fcf704e3          	beq	a4,a5,802058e2 <trim_line+0x32>
    8020591e:	fec42783          	lw	a5,-20(s0)
    80205922:	17fd                	addi	a5,a5,-1
    80205924:	fd843703          	ld	a4,-40(s0)
    80205928:	97ba                	add	a5,a5,a4
    8020592a:	0007c783          	lbu	a5,0(a5)
    8020592e:	873e                	mv	a4,a5
    80205930:	47b5                	li	a5,13
    80205932:	faf708e3          	beq	a4,a5,802058e2 <trim_line+0x32>
    80205936:	fec42783          	lw	a5,-20(s0)
    8020593a:	17fd                	addi	a5,a5,-1
    8020593c:	fd843703          	ld	a4,-40(s0)
    80205940:	97ba                	add	a5,a5,a4
    80205942:	0007c783          	lbu	a5,0(a5)
    80205946:	873e                	mv	a4,a5
    80205948:	02000793          	li	a5,32
    8020594c:	f8f70be3          	beq	a4,a5,802058e2 <trim_line+0x32>
    80205950:	fec42783          	lw	a5,-20(s0)
    80205954:	17fd                	addi	a5,a5,-1
    80205956:	fd843703          	ld	a4,-40(s0)
    8020595a:	97ba                	add	a5,a5,a4
    8020595c:	0007c783          	lbu	a5,0(a5)
    80205960:	873e                	mv	a4,a5
    80205962:	47a5                	li	a5,9
    80205964:	f6f70fe3          	beq	a4,a5,802058e2 <trim_line+0x32>
    80205968:	a031                	j	80205974 <trim_line+0xc4>
    8020596a:	fe842783          	lw	a5,-24(s0)
    8020596e:	2785                	addiw	a5,a5,1
    80205970:	fef42423          	sw	a5,-24(s0)
    80205974:	fe842783          	lw	a5,-24(s0)
    80205978:	fd843703          	ld	a4,-40(s0)
    8020597c:	97ba                	add	a5,a5,a4
    8020597e:	0007c783          	lbu	a5,0(a5)
    80205982:	873e                	mv	a4,a5
    80205984:	02000793          	li	a5,32
    80205988:	fef701e3          	beq	a4,a5,8020596a <trim_line+0xba>
    8020598c:	fe842783          	lw	a5,-24(s0)
    80205990:	fd843703          	ld	a4,-40(s0)
    80205994:	97ba                	add	a5,a5,a4
    80205996:	0007c783          	lbu	a5,0(a5)
    8020599a:	873e                	mv	a4,a5
    8020599c:	47a5                	li	a5,9
    8020599e:	fcf706e3          	beq	a4,a5,8020596a <trim_line+0xba>
    802059a2:	fe842783          	lw	a5,-24(s0)
    802059a6:	2781                	sext.w	a5,a5
    802059a8:	04f05c63          	blez	a5,80205a00 <trim_line+0x150>
    802059ac:	fe042223          	sw	zero,-28(s0)
    802059b0:	a80d                	j	802059e2 <trim_line+0x132>
    802059b2:	fe842783          	lw	a5,-24(s0)
    802059b6:	0017871b          	addiw	a4,a5,1
    802059ba:	fee42423          	sw	a4,-24(s0)
    802059be:	873e                	mv	a4,a5
    802059c0:	fd843783          	ld	a5,-40(s0)
    802059c4:	973e                	add	a4,a4,a5
    802059c6:	fe442783          	lw	a5,-28(s0)
    802059ca:	0017869b          	addiw	a3,a5,1
    802059ce:	fed42223          	sw	a3,-28(s0)
    802059d2:	86be                	mv	a3,a5
    802059d4:	fd843783          	ld	a5,-40(s0)
    802059d8:	97b6                	add	a5,a5,a3
    802059da:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    802059de:	00e78023          	sb	a4,0(a5)
    802059e2:	fe842783          	lw	a5,-24(s0)
    802059e6:	fd843703          	ld	a4,-40(s0)
    802059ea:	97ba                	add	a5,a5,a4
    802059ec:	0007c783          	lbu	a5,0(a5)
    802059f0:	f3e9                	bnez	a5,802059b2 <trim_line+0x102>
    802059f2:	fe442783          	lw	a5,-28(s0)
    802059f6:	fd843703          	ld	a4,-40(s0)
    802059fa:	97ba                	add	a5,a5,a4
    802059fc:	00078023          	sb	zero,0(a5)
    80205a00:	0001                	nop
    80205a02:	70a2                	ld	ra,40(sp)
    80205a04:	7402                	ld	s0,32(sp)
    80205a06:	6145                	addi	sp,sp,48
    80205a08:	8082                	ret

0000000080205a0a <skip_word>:
    80205a0a:	1101                	addi	sp,sp,-32
    80205a0c:	ec06                	sd	ra,24(sp)
    80205a0e:	e822                	sd	s0,16(sp)
    80205a10:	1000                	addi	s0,sp,32
    80205a12:	fea43423          	sd	a0,-24(s0)
    80205a16:	a031                	j	80205a22 <skip_word+0x18>
    80205a18:	fe843783          	ld	a5,-24(s0)
    80205a1c:	0785                	addi	a5,a5,1
    80205a1e:	fef43423          	sd	a5,-24(s0)
    80205a22:	fe843783          	ld	a5,-24(s0)
    80205a26:	0007c783          	lbu	a5,0(a5)
    80205a2a:	cb85                	beqz	a5,80205a5a <skip_word+0x50>
    80205a2c:	fe843783          	ld	a5,-24(s0)
    80205a30:	0007c783          	lbu	a5,0(a5)
    80205a34:	873e                	mv	a4,a5
    80205a36:	02000793          	li	a5,32
    80205a3a:	02f70063          	beq	a4,a5,80205a5a <skip_word+0x50>
    80205a3e:	fe843783          	ld	a5,-24(s0)
    80205a42:	0007c783          	lbu	a5,0(a5)
    80205a46:	873e                	mv	a4,a5
    80205a48:	47a5                	li	a5,9
    80205a4a:	fcf717e3          	bne	a4,a5,80205a18 <skip_word+0xe>
    80205a4e:	a031                	j	80205a5a <skip_word+0x50>
    80205a50:	fe843783          	ld	a5,-24(s0)
    80205a54:	0785                	addi	a5,a5,1
    80205a56:	fef43423          	sd	a5,-24(s0)
    80205a5a:	fe843783          	ld	a5,-24(s0)
    80205a5e:	0007c783          	lbu	a5,0(a5)
    80205a62:	873e                	mv	a4,a5
    80205a64:	02000793          	li	a5,32
    80205a68:	fef704e3          	beq	a4,a5,80205a50 <skip_word+0x46>
    80205a6c:	fe843783          	ld	a5,-24(s0)
    80205a70:	0007c783          	lbu	a5,0(a5)
    80205a74:	873e                	mv	a4,a5
    80205a76:	47a5                	li	a5,9
    80205a78:	fcf70ce3          	beq	a4,a5,80205a50 <skip_word+0x46>
    80205a7c:	fe843783          	ld	a5,-24(s0)
    80205a80:	853e                	mv	a0,a5
    80205a82:	60e2                	ld	ra,24(sp)
    80205a84:	6442                	ld	s0,16(sp)
    80205a86:	6105                	addi	sp,sp,32
    80205a88:	8082                	ret

0000000080205a8a <find_redirect>:
    80205a8a:	7139                	addi	sp,sp,-64
    80205a8c:	fc06                	sd	ra,56(sp)
    80205a8e:	f822                	sd	s0,48(sp)
    80205a90:	0080                	addi	s0,sp,64
    80205a92:	fca43c23          	sd	a0,-40(s0)
    80205a96:	fcb43823          	sd	a1,-48(s0)
    80205a9a:	fcc43423          	sd	a2,-56(s0)
    80205a9e:	fd843783          	ld	a5,-40(s0)
    80205aa2:	fef43423          	sd	a5,-24(s0)
    80205aa6:	fd043783          	ld	a5,-48(s0)
    80205aaa:	0007b023          	sd	zero,0(a5)
    80205aae:	fc843783          	ld	a5,-56(s0)
    80205ab2:	0007a023          	sw	zero,0(a5)
    80205ab6:	a055                	j	80205b5a <find_redirect+0xd0>
    80205ab8:	fe843783          	ld	a5,-24(s0)
    80205abc:	0007c783          	lbu	a5,0(a5)
    80205ac0:	873e                	mv	a4,a5
    80205ac2:	03e00793          	li	a5,62
    80205ac6:	04f71463          	bne	a4,a5,80205b0e <find_redirect+0x84>
    80205aca:	fe843783          	ld	a5,-24(s0)
    80205ace:	0785                	addi	a5,a5,1
    80205ad0:	0007c783          	lbu	a5,0(a5)
    80205ad4:	873e                	mv	a4,a5
    80205ad6:	03e00793          	li	a5,62
    80205ada:	02f71a63          	bne	a4,a5,80205b0e <find_redirect+0x84>
    80205ade:	fe843783          	ld	a5,-24(s0)
    80205ae2:	00078023          	sb	zero,0(a5)
    80205ae6:	fc843783          	ld	a5,-56(s0)
    80205aea:	4705                	li	a4,1
    80205aec:	c398                	sw	a4,0(a5)
    80205aee:	fe843783          	ld	a5,-24(s0)
    80205af2:	00278713          	addi	a4,a5,2
    80205af6:	fd043783          	ld	a5,-48(s0)
    80205afa:	e398                	sd	a4,0(a5)
    80205afc:	fd043783          	ld	a5,-48(s0)
    80205b00:	639c                	ld	a5,0(a5)
    80205b02:	853e                	mv	a0,a5
    80205b04:	dadff0ef          	jal	802058b0 <trim_line>
    80205b08:	fe843783          	ld	a5,-24(s0)
    80205b0c:	a8a9                	j	80205b66 <find_redirect+0xdc>
    80205b0e:	fe843783          	ld	a5,-24(s0)
    80205b12:	0007c783          	lbu	a5,0(a5)
    80205b16:	873e                	mv	a4,a5
    80205b18:	03e00793          	li	a5,62
    80205b1c:	02f71a63          	bne	a4,a5,80205b50 <find_redirect+0xc6>
    80205b20:	fe843783          	ld	a5,-24(s0)
    80205b24:	00078023          	sb	zero,0(a5)
    80205b28:	fc843783          	ld	a5,-56(s0)
    80205b2c:	0007a023          	sw	zero,0(a5)
    80205b30:	fe843783          	ld	a5,-24(s0)
    80205b34:	00178713          	addi	a4,a5,1
    80205b38:	fd043783          	ld	a5,-48(s0)
    80205b3c:	e398                	sd	a4,0(a5)
    80205b3e:	fd043783          	ld	a5,-48(s0)
    80205b42:	639c                	ld	a5,0(a5)
    80205b44:	853e                	mv	a0,a5
    80205b46:	d6bff0ef          	jal	802058b0 <trim_line>
    80205b4a:	fe843783          	ld	a5,-24(s0)
    80205b4e:	a821                	j	80205b66 <find_redirect+0xdc>
    80205b50:	fe843783          	ld	a5,-24(s0)
    80205b54:	0785                	addi	a5,a5,1
    80205b56:	fef43423          	sd	a5,-24(s0)
    80205b5a:	fe843783          	ld	a5,-24(s0)
    80205b5e:	0007c783          	lbu	a5,0(a5)
    80205b62:	fbb9                	bnez	a5,80205ab8 <find_redirect+0x2e>
    80205b64:	4781                	li	a5,0
    80205b66:	853e                	mv	a0,a5
    80205b68:	70e2                	ld	ra,56(sp)
    80205b6a:	7442                	ld	s0,48(sp)
    80205b6c:	6121                	addi	sp,sp,64
    80205b6e:	8082                	ret

0000000080205b70 <is_poweroff_cmd>:
    80205b70:	1101                	addi	sp,sp,-32
    80205b72:	ec06                	sd	ra,24(sp)
    80205b74:	e822                	sd	s0,16(sp)
    80205b76:	1000                	addi	s0,sp,32
    80205b78:	fea43423          	sd	a0,-24(s0)
    80205b7c:	00008597          	auipc	a1,0x8
    80205b80:	fa458593          	addi	a1,a1,-92 # 8020db20 <home_bin_spin.0+0x1b20>
    80205b84:	fe843503          	ld	a0,-24(s0)
    80205b88:	c57ff0ef          	jal	802057de <str_eq>
    80205b8c:	87aa                	mv	a5,a0
    80205b8e:	e78d                	bnez	a5,80205bb8 <is_poweroff_cmd+0x48>
    80205b90:	00008597          	auipc	a1,0x8
    80205b94:	fa058593          	addi	a1,a1,-96 # 8020db30 <home_bin_spin.0+0x1b30>
    80205b98:	fe843503          	ld	a0,-24(s0)
    80205b9c:	c43ff0ef          	jal	802057de <str_eq>
    80205ba0:	87aa                	mv	a5,a0
    80205ba2:	eb99                	bnez	a5,80205bb8 <is_poweroff_cmd+0x48>
    80205ba4:	00008597          	auipc	a1,0x8
    80205ba8:	f9458593          	addi	a1,a1,-108 # 8020db38 <home_bin_spin.0+0x1b38>
    80205bac:	fe843503          	ld	a0,-24(s0)
    80205bb0:	c2fff0ef          	jal	802057de <str_eq>
    80205bb4:	87aa                	mv	a5,a0
    80205bb6:	c399                	beqz	a5,80205bbc <is_poweroff_cmd+0x4c>
    80205bb8:	4785                	li	a5,1
    80205bba:	a011                	j	80205bbe <is_poweroff_cmd+0x4e>
    80205bbc:	4781                	li	a5,0
    80205bbe:	853e                	mv	a0,a5
    80205bc0:	60e2                	ld	ra,24(sp)
    80205bc2:	6442                	ld	s0,16(sp)
    80205bc4:	6105                	addi	sp,sp,32
    80205bc6:	8082                	ret

0000000080205bc8 <put_dec>:
    80205bc8:	7139                	addi	sp,sp,-64
    80205bca:	fc06                	sd	ra,56(sp)
    80205bcc:	f822                	sd	s0,48(sp)
    80205bce:	0080                	addi	s0,sp,64
    80205bd0:	87aa                	mv	a5,a0
    80205bd2:	fcf42623          	sw	a5,-52(s0)
    80205bd6:	fe042623          	sw	zero,-20(s0)
    80205bda:	fe042423          	sw	zero,-24(s0)
    80205bde:	fcc42783          	lw	a5,-52(s0)
    80205be2:	2781                	sext.w	a5,a5
    80205be4:	0007db63          	bgez	a5,80205bfa <put_dec+0x32>
    80205be8:	4785                	li	a5,1
    80205bea:	fef42423          	sw	a5,-24(s0)
    80205bee:	fcc42783          	lw	a5,-52(s0)
    80205bf2:	40f007bb          	negw	a5,a5
    80205bf6:	fcf42623          	sw	a5,-52(s0)
    80205bfa:	fcc42783          	lw	a5,-52(s0)
    80205bfe:	2781                	sext.w	a5,a5
    80205c00:	e3c5                	bnez	a5,80205ca0 <put_dec+0xd8>
    80205c02:	fec42783          	lw	a5,-20(s0)
    80205c06:	0017871b          	addiw	a4,a5,1
    80205c0a:	fee42623          	sw	a4,-20(s0)
    80205c0e:	17c1                	addi	a5,a5,-16
    80205c10:	97a2                	add	a5,a5,s0
    80205c12:	03000713          	li	a4,48
    80205c16:	fee78423          	sb	a4,-24(a5)
    80205c1a:	a841                	j	80205caa <put_dec+0xe2>
    80205c1c:	fcc42783          	lw	a5,-52(s0)
    80205c20:	873e                	mv	a4,a5
    80205c22:	0007069b          	sext.w	a3,a4
    80205c26:	666667b7          	lui	a5,0x66666
    80205c2a:	66778793          	addi	a5,a5,1639 # 66666667 <_heap_size+0x5e77f23f>
    80205c2e:	02f687b3          	mul	a5,a3,a5
    80205c32:	9381                	srli	a5,a5,0x20
    80205c34:	4027d79b          	sraiw	a5,a5,0x2
    80205c38:	86be                	mv	a3,a5
    80205c3a:	41f7579b          	sraiw	a5,a4,0x1f
    80205c3e:	40f687bb          	subw	a5,a3,a5
    80205c42:	86be                	mv	a3,a5
    80205c44:	87b6                	mv	a5,a3
    80205c46:	0027979b          	slliw	a5,a5,0x2
    80205c4a:	9fb5                	addw	a5,a5,a3
    80205c4c:	0017979b          	slliw	a5,a5,0x1
    80205c50:	40f707bb          	subw	a5,a4,a5
    80205c54:	2781                	sext.w	a5,a5
    80205c56:	0ff7f713          	zext.b	a4,a5
    80205c5a:	fec42783          	lw	a5,-20(s0)
    80205c5e:	0017869b          	addiw	a3,a5,1
    80205c62:	fed42623          	sw	a3,-20(s0)
    80205c66:	0307071b          	addiw	a4,a4,48
    80205c6a:	0ff77713          	zext.b	a4,a4
    80205c6e:	17c1                	addi	a5,a5,-16
    80205c70:	97a2                	add	a5,a5,s0
    80205c72:	fee78423          	sb	a4,-24(a5)
    80205c76:	fcc42783          	lw	a5,-52(s0)
    80205c7a:	86be                	mv	a3,a5
    80205c7c:	0006871b          	sext.w	a4,a3
    80205c80:	666667b7          	lui	a5,0x66666
    80205c84:	66778793          	addi	a5,a5,1639 # 66666667 <_heap_size+0x5e77f23f>
    80205c88:	02f707b3          	mul	a5,a4,a5
    80205c8c:	9381                	srli	a5,a5,0x20
    80205c8e:	4027d79b          	sraiw	a5,a5,0x2
    80205c92:	873e                	mv	a4,a5
    80205c94:	41f6d79b          	sraiw	a5,a3,0x1f
    80205c98:	40f707bb          	subw	a5,a4,a5
    80205c9c:	fcf42623          	sw	a5,-52(s0)
    80205ca0:	fcc42783          	lw	a5,-52(s0)
    80205ca4:	2781                	sext.w	a5,a5
    80205ca6:	f6f04be3          	bgtz	a5,80205c1c <put_dec+0x54>
    80205caa:	fe842783          	lw	a5,-24(s0)
    80205cae:	2781                	sext.w	a5,a5
    80205cb0:	c785                	beqz	a5,80205cd8 <put_dec+0x110>
    80205cb2:	02d00513          	li	a0,45
    80205cb6:	d51fa0ef          	jal	80200a06 <uart_putc>
    80205cba:	a839                	j	80205cd8 <put_dec+0x110>
    80205cbc:	fec42783          	lw	a5,-20(s0)
    80205cc0:	37fd                	addiw	a5,a5,-1
    80205cc2:	fef42623          	sw	a5,-20(s0)
    80205cc6:	fec42783          	lw	a5,-20(s0)
    80205cca:	17c1                	addi	a5,a5,-16
    80205ccc:	97a2                	add	a5,a5,s0
    80205cce:	fe87c783          	lbu	a5,-24(a5)
    80205cd2:	853e                	mv	a0,a5
    80205cd4:	d33fa0ef          	jal	80200a06 <uart_putc>
    80205cd8:	fec42783          	lw	a5,-20(s0)
    80205cdc:	2781                	sext.w	a5,a5
    80205cde:	fcf04fe3          	bgtz	a5,80205cbc <put_dec+0xf4>
    80205ce2:	0001                	nop
    80205ce4:	0001                	nop
    80205ce6:	70e2                	ld	ra,56(sp)
    80205ce8:	7442                	ld	s0,48(sp)
    80205cea:	6121                	addi	sp,sp,64
    80205cec:	8082                	ret

0000000080205cee <cmd_ps>:
    80205cee:	7141                	addi	sp,sp,-496
    80205cf0:	f786                	sd	ra,488(sp)
    80205cf2:	f3a2                	sd	s0,480(sp)
    80205cf4:	1b80                	addi	s0,sp,496
    80205cf6:	87aa                	mv	a5,a0
    80205cf8:	e0f42e23          	sw	a5,-484(s0)
    80205cfc:	e2040793          	addi	a5,s0,-480
    80205d00:	45c1                	li	a1,16
    80205d02:	853e                	mv	a0,a5
    80205d04:	eb6fd0ef          	jal	802033ba <proc_list>
    80205d08:	87aa                	mv	a5,a0
    80205d0a:	fef42223          	sw	a5,-28(s0)
    80205d0e:	00008517          	auipc	a0,0x8
    80205d12:	e3a50513          	addi	a0,a0,-454 # 8020db48 <home_bin_spin.0+0x1b48>
    80205d16:	d2ffa0ef          	jal	80200a44 <uart_puts>
    80205d1a:	fe042423          	sw	zero,-24(s0)
    80205d1e:	a0ed                	j	80205e08 <cmd_ps+0x11a>
    80205d20:	fe842703          	lw	a4,-24(s0)
    80205d24:	87ba                	mv	a5,a4
    80205d26:	078e                	slli	a5,a5,0x3
    80205d28:	8f99                	sub	a5,a5,a4
    80205d2a:	078a                	slli	a5,a5,0x2
    80205d2c:	17c1                	addi	a5,a5,-16
    80205d2e:	97a2                	add	a5,a5,s0
    80205d30:	e387a783          	lw	a5,-456(a5)
    80205d34:	470d                	li	a4,3
    80205d36:	02e78563          	beq	a5,a4,80205d60 <cmd_ps+0x72>
    80205d3a:	470d                	li	a4,3
    80205d3c:	02f76763          	bltu	a4,a5,80205d6a <cmd_ps+0x7c>
    80205d40:	4705                	li	a4,1
    80205d42:	00e78a63          	beq	a5,a4,80205d56 <cmd_ps+0x68>
    80205d46:	4709                	li	a4,2
    80205d48:	02e79163          	bne	a5,a4,80205d6a <cmd_ps+0x7c>
    80205d4c:	05200793          	li	a5,82
    80205d50:	fef407a3          	sb	a5,-17(s0)
    80205d54:	a005                	j	80205d74 <cmd_ps+0x86>
    80205d56:	05300793          	li	a5,83
    80205d5a:	fef407a3          	sb	a5,-17(s0)
    80205d5e:	a819                	j	80205d74 <cmd_ps+0x86>
    80205d60:	05a00793          	li	a5,90
    80205d64:	fef407a3          	sb	a5,-17(s0)
    80205d68:	a031                	j	80205d74 <cmd_ps+0x86>
    80205d6a:	03f00793          	li	a5,63
    80205d6e:	fef407a3          	sb	a5,-17(s0)
    80205d72:	0001                	nop
    80205d74:	00008517          	auipc	a0,0x8
    80205d78:	df450513          	addi	a0,a0,-524 # 8020db68 <home_bin_spin.0+0x1b68>
    80205d7c:	cc9fa0ef          	jal	80200a44 <uart_puts>
    80205d80:	fe842703          	lw	a4,-24(s0)
    80205d84:	87ba                	mv	a5,a4
    80205d86:	078e                	slli	a5,a5,0x3
    80205d88:	8f99                	sub	a5,a5,a4
    80205d8a:	078a                	slli	a5,a5,0x2
    80205d8c:	17c1                	addi	a5,a5,-16
    80205d8e:	97a2                	add	a5,a5,s0
    80205d90:	e307a783          	lw	a5,-464(a5)
    80205d94:	853e                	mv	a0,a5
    80205d96:	e33ff0ef          	jal	80205bc8 <put_dec>
    80205d9a:	02000513          	li	a0,32
    80205d9e:	c69fa0ef          	jal	80200a06 <uart_putc>
    80205da2:	fe842703          	lw	a4,-24(s0)
    80205da6:	87ba                	mv	a5,a4
    80205da8:	078e                	slli	a5,a5,0x3
    80205daa:	8f99                	sub	a5,a5,a4
    80205dac:	078a                	slli	a5,a5,0x2
    80205dae:	17c1                	addi	a5,a5,-16
    80205db0:	97a2                	add	a5,a5,s0
    80205db2:	e347a783          	lw	a5,-460(a5)
    80205db6:	853e                	mv	a0,a5
    80205db8:	e11ff0ef          	jal	80205bc8 <put_dec>
    80205dbc:	00008517          	auipc	a0,0x8
    80205dc0:	db450513          	addi	a0,a0,-588 # 8020db70 <home_bin_spin.0+0x1b70>
    80205dc4:	c81fa0ef          	jal	80200a44 <uart_puts>
    80205dc8:	fef44783          	lbu	a5,-17(s0)
    80205dcc:	853e                	mv	a0,a5
    80205dce:	c39fa0ef          	jal	80200a06 <uart_putc>
    80205dd2:	00008517          	auipc	a0,0x8
    80205dd6:	da650513          	addi	a0,a0,-602 # 8020db78 <home_bin_spin.0+0x1b78>
    80205dda:	c6bfa0ef          	jal	80200a44 <uart_puts>
    80205dde:	e2040693          	addi	a3,s0,-480
    80205de2:	fe842703          	lw	a4,-24(s0)
    80205de6:	87ba                	mv	a5,a4
    80205de8:	078e                	slli	a5,a5,0x3
    80205dea:	8f99                	sub	a5,a5,a4
    80205dec:	078a                	slli	a5,a5,0x2
    80205dee:	97b6                	add	a5,a5,a3
    80205df0:	07b1                	addi	a5,a5,12
    80205df2:	853e                	mv	a0,a5
    80205df4:	c51fa0ef          	jal	80200a44 <uart_puts>
    80205df8:	4529                	li	a0,10
    80205dfa:	c0dfa0ef          	jal	80200a06 <uart_putc>
    80205dfe:	fe842783          	lw	a5,-24(s0)
    80205e02:	2785                	addiw	a5,a5,1
    80205e04:	fef42423          	sw	a5,-24(s0)
    80205e08:	fe842783          	lw	a5,-24(s0)
    80205e0c:	873e                	mv	a4,a5
    80205e0e:	fe442783          	lw	a5,-28(s0)
    80205e12:	2701                	sext.w	a4,a4
    80205e14:	2781                	sext.w	a5,a5
    80205e16:	f0f745e3          	blt	a4,a5,80205d20 <cmd_ps+0x32>
    80205e1a:	e1c42783          	lw	a5,-484(s0)
    80205e1e:	2781                	sext.w	a5,a5
    80205e20:	c799                	beqz	a5,80205e2e <cmd_ps+0x140>
    80205e22:	00008517          	auipc	a0,0x8
    80205e26:	d5e50513          	addi	a0,a0,-674 # 8020db80 <home_bin_spin.0+0x1b80>
    80205e2a:	c1bfa0ef          	jal	80200a44 <uart_puts>
    80205e2e:	0001                	nop
    80205e30:	70be                	ld	ra,488(sp)
    80205e32:	741e                	ld	s0,480(sp)
    80205e34:	617d                	addi	sp,sp,496
    80205e36:	8082                	ret

0000000080205e38 <ls_emit>:
    80205e38:	7179                	addi	sp,sp,-48
    80205e3a:	f406                	sd	ra,40(sp)
    80205e3c:	f022                	sd	s0,32(sp)
    80205e3e:	1800                	addi	s0,sp,48
    80205e40:	fea43423          	sd	a0,-24(s0)
    80205e44:	87ae                	mv	a5,a1
    80205e46:	8736                	mv	a4,a3
    80205e48:	fef42223          	sw	a5,-28(s0)
    80205e4c:	87b2                	mv	a5,a2
    80205e4e:	fef42023          	sw	a5,-32(s0)
    80205e52:	87ba                	mv	a5,a4
    80205e54:	fcf42e23          	sw	a5,-36(s0)
    80205e58:	00008517          	auipc	a0,0x8
    80205e5c:	d2050513          	addi	a0,a0,-736 # 8020db78 <home_bin_spin.0+0x1b78>
    80205e60:	be5fa0ef          	jal	80200a44 <uart_puts>
    80205e64:	fe042783          	lw	a5,-32(s0)
    80205e68:	2781                	sext.w	a5,a5
    80205e6a:	c791                	beqz	a5,80205e76 <ls_emit+0x3e>
    80205e6c:	06400513          	li	a0,100
    80205e70:	b97fa0ef          	jal	80200a06 <uart_putc>
    80205e74:	a831                	j	80205e90 <ls_emit+0x58>
    80205e76:	fdc42783          	lw	a5,-36(s0)
    80205e7a:	2781                	sext.w	a5,a5
    80205e7c:	c791                	beqz	a5,80205e88 <ls_emit+0x50>
    80205e7e:	07800513          	li	a0,120
    80205e82:	b85fa0ef          	jal	80200a06 <uart_putc>
    80205e86:	a029                	j	80205e90 <ls_emit+0x58>
    80205e88:	02d00513          	li	a0,45
    80205e8c:	b7bfa0ef          	jal	80200a06 <uart_putc>
    80205e90:	02000513          	li	a0,32
    80205e94:	b73fa0ef          	jal	80200a06 <uart_putc>
    80205e98:	fe843503          	ld	a0,-24(s0)
    80205e9c:	ba9fa0ef          	jal	80200a44 <uart_puts>
    80205ea0:	fe042783          	lw	a5,-32(s0)
    80205ea4:	2781                	sext.w	a5,a5
    80205ea6:	e395                	bnez	a5,80205eca <ls_emit+0x92>
    80205ea8:	00008517          	auipc	a0,0x8
    80205eac:	ce850513          	addi	a0,a0,-792 # 8020db90 <home_bin_spin.0+0x1b90>
    80205eb0:	b95fa0ef          	jal	80200a44 <uart_puts>
    80205eb4:	fe442783          	lw	a5,-28(s0)
    80205eb8:	853e                	mv	a0,a5
    80205eba:	d0fff0ef          	jal	80205bc8 <put_dec>
    80205ebe:	00008517          	auipc	a0,0x8
    80205ec2:	cda50513          	addi	a0,a0,-806 # 8020db98 <home_bin_spin.0+0x1b98>
    80205ec6:	b7ffa0ef          	jal	80200a44 <uart_puts>
    80205eca:	4529                	li	a0,10
    80205ecc:	b3bfa0ef          	jal	80200a06 <uart_putc>
    80205ed0:	0001                	nop
    80205ed2:	70a2                	ld	ra,40(sp)
    80205ed4:	7402                	ld	s0,32(sp)
    80205ed6:	6145                	addi	sp,sp,48
    80205ed8:	8082                	ret

0000000080205eda <cmd_ls>:
    80205eda:	7179                	addi	sp,sp,-48
    80205edc:	f406                	sd	ra,40(sp)
    80205ede:	f022                	sd	s0,32(sp)
    80205ee0:	1800                	addi	s0,sp,48
    80205ee2:	fca43c23          	sd	a0,-40(s0)
    80205ee6:	fd843783          	ld	a5,-40(s0)
    80205eea:	c791                	beqz	a5,80205ef6 <cmd_ls+0x1c>
    80205eec:	fd843783          	ld	a5,-40(s0)
    80205ef0:	0007c783          	lbu	a5,0(a5)
    80205ef4:	e791                	bnez	a5,80205f00 <cmd_ls+0x26>
    80205ef6:	c2bfe0ef          	jal	80204b20 <fs_getcwd>
    80205efa:	fea43423          	sd	a0,-24(s0)
    80205efe:	a029                	j	80205f08 <cmd_ls+0x2e>
    80205f00:	fd843783          	ld	a5,-40(s0)
    80205f04:	fef43423          	sd	a5,-24(s0)
    80205f08:	fe843503          	ld	a0,-24(s0)
    80205f0c:	b39fa0ef          	jal	80200a44 <uart_puts>
    80205f10:	00008517          	auipc	a0,0x8
    80205f14:	c9050513          	addi	a0,a0,-880 # 8020dba0 <home_bin_spin.0+0x1ba0>
    80205f18:	b2dfa0ef          	jal	80200a44 <uart_puts>
    80205f1c:	00000597          	auipc	a1,0x0
    80205f20:	f1c58593          	addi	a1,a1,-228 # 80205e38 <ls_emit>
    80205f24:	fe843503          	ld	a0,-24(s0)
    80205f28:	c81fe0ef          	jal	80204ba8 <fs_listdir>
    80205f2c:	87aa                	mv	a5,a0
    80205f2e:	ef89                	bnez	a5,80205f48 <cmd_ls+0x6e>
    80205f30:	fe843503          	ld	a0,-24(s0)
    80205f34:	b6dfe0ef          	jal	80204aa0 <fs_is_dir>
    80205f38:	87aa                	mv	a5,a0
    80205f3a:	e799                	bnez	a5,80205f48 <cmd_ls+0x6e>
    80205f3c:	00008517          	auipc	a0,0x8
    80205f40:	c6c50513          	addi	a0,a0,-916 # 8020dba8 <home_bin_spin.0+0x1ba8>
    80205f44:	b01fa0ef          	jal	80200a44 <uart_puts>
    80205f48:	0001                	nop
    80205f4a:	70a2                	ld	ra,40(sp)
    80205f4c:	7402                	ld	s0,32(sp)
    80205f4e:	6145                	addi	sp,sp,48
    80205f50:	8082                	ret

0000000080205f52 <cmd_pwd>:
    80205f52:	1141                	addi	sp,sp,-16
    80205f54:	e406                	sd	ra,8(sp)
    80205f56:	e022                	sd	s0,0(sp)
    80205f58:	0800                	addi	s0,sp,16
    80205f5a:	bc7fe0ef          	jal	80204b20 <fs_getcwd>
    80205f5e:	87aa                	mv	a5,a0
    80205f60:	853e                	mv	a0,a5
    80205f62:	ae3fa0ef          	jal	80200a44 <uart_puts>
    80205f66:	4529                	li	a0,10
    80205f68:	a9ffa0ef          	jal	80200a06 <uart_putc>
    80205f6c:	0001                	nop
    80205f6e:	60a2                	ld	ra,8(sp)
    80205f70:	6402                	ld	s0,0(sp)
    80205f72:	0141                	addi	sp,sp,16
    80205f74:	8082                	ret

0000000080205f76 <cmd_cd>:
    80205f76:	7179                	addi	sp,sp,-48
    80205f78:	f406                	sd	ra,40(sp)
    80205f7a:	f022                	sd	s0,32(sp)
    80205f7c:	1800                	addi	s0,sp,48
    80205f7e:	fca43c23          	sd	a0,-40(s0)
    80205f82:	fd843783          	ld	a5,-40(s0)
    80205f86:	cb99                	beqz	a5,80205f9c <cmd_cd+0x26>
    80205f88:	fd843783          	ld	a5,-40(s0)
    80205f8c:	0007c783          	lbu	a5,0(a5)
    80205f90:	c791                	beqz	a5,80205f9c <cmd_cd+0x26>
    80205f92:	fd843783          	ld	a5,-40(s0)
    80205f96:	fef43423          	sd	a5,-24(s0)
    80205f9a:	a039                	j	80205fa8 <cmd_cd+0x32>
    80205f9c:	00008797          	auipc	a5,0x8
    80205fa0:	c2478793          	addi	a5,a5,-988 # 8020dbc0 <home_bin_spin.0+0x1bc0>
    80205fa4:	fef43423          	sd	a5,-24(s0)
    80205fa8:	fe843503          	ld	a0,-24(s0)
    80205fac:	b8ffe0ef          	jal	80204b3a <fs_chdir>
    80205fb0:	87aa                	mv	a5,a0
    80205fb2:	0007d863          	bgez	a5,80205fc2 <cmd_cd+0x4c>
    80205fb6:	00008517          	auipc	a0,0x8
    80205fba:	c1a50513          	addi	a0,a0,-998 # 8020dbd0 <home_bin_spin.0+0x1bd0>
    80205fbe:	a87fa0ef          	jal	80200a44 <uart_puts>
    80205fc2:	0001                	nop
    80205fc4:	70a2                	ld	ra,40(sp)
    80205fc6:	7402                	ld	s0,32(sp)
    80205fc8:	6145                	addi	sp,sp,48
    80205fca:	8082                	ret

0000000080205fcc <cmd_cat>:
    80205fcc:	7169                	addi	sp,sp,-304
    80205fce:	f606                	sd	ra,296(sp)
    80205fd0:	f222                	sd	s0,288(sp)
    80205fd2:	1a00                	addi	s0,sp,304
    80205fd4:	eca43c23          	sd	a0,-296(s0)
    80205fd8:	4581                	li	a1,0
    80205fda:	ed843503          	ld	a0,-296(s0)
    80205fde:	e7ffe0ef          	jal	80204e5c <fs_open>
    80205fe2:	87aa                	mv	a5,a0
    80205fe4:	fef42623          	sw	a5,-20(s0)
    80205fe8:	fec42783          	lw	a5,-20(s0)
    80205fec:	2781                	sext.w	a5,a5
    80205fee:	0007db63          	bgez	a5,80206004 <cmd_cat+0x38>
    80205ff2:	ed843583          	ld	a1,-296(s0)
    80205ff6:	00008517          	auipc	a0,0x8
    80205ffa:	bf250513          	addi	a0,a0,-1038 # 8020dbe8 <home_bin_spin.0+0x1be8>
    80205ffe:	c38fb0ef          	jal	80201436 <printf>
    80206002:	a88d                	j	80206074 <cmd_cat+0xa8>
    80206004:	ee840713          	addi	a4,s0,-280
    80206008:	fec42783          	lw	a5,-20(s0)
    8020600c:	0ff00613          	li	a2,255
    80206010:	85ba                	mv	a1,a4
    80206012:	853e                	mv	a0,a5
    80206014:	fc3fe0ef          	jal	80204fd6 <fs_read>
    80206018:	87aa                	mv	a5,a0
    8020601a:	fef42423          	sw	a5,-24(s0)
    8020601e:	fec42783          	lw	a5,-20(s0)
    80206022:	853e                	mv	a0,a5
    80206024:	ac8ff0ef          	jal	802052ec <fs_close>
    80206028:	fe842783          	lw	a5,-24(s0)
    8020602c:	2781                	sext.w	a5,a5
    8020602e:	00f04963          	bgtz	a5,80206040 <cmd_cat+0x74>
    80206032:	00008517          	auipc	a0,0x8
    80206036:	bce50513          	addi	a0,a0,-1074 # 8020dc00 <home_bin_spin.0+0x1c00>
    8020603a:	a0bfa0ef          	jal	80200a44 <uart_puts>
    8020603e:	a81d                	j	80206074 <cmd_cat+0xa8>
    80206040:	fe842783          	lw	a5,-24(s0)
    80206044:	17c1                	addi	a5,a5,-16
    80206046:	97a2                	add	a5,a5,s0
    80206048:	ee078c23          	sb	zero,-264(a5)
    8020604c:	ee840793          	addi	a5,s0,-280
    80206050:	853e                	mv	a0,a5
    80206052:	9f3fa0ef          	jal	80200a44 <uart_puts>
    80206056:	fe842783          	lw	a5,-24(s0)
    8020605a:	37fd                	addiw	a5,a5,-1
    8020605c:	2781                	sext.w	a5,a5
    8020605e:	17c1                	addi	a5,a5,-16
    80206060:	97a2                	add	a5,a5,s0
    80206062:	ef87c783          	lbu	a5,-264(a5)
    80206066:	873e                	mv	a4,a5
    80206068:	47a9                	li	a5,10
    8020606a:	00f70563          	beq	a4,a5,80206074 <cmd_cat+0xa8>
    8020606e:	4529                	li	a0,10
    80206070:	997fa0ef          	jal	80200a06 <uart_putc>
    80206074:	70b2                	ld	ra,296(sp)
    80206076:	7412                	ld	s0,288(sp)
    80206078:	6155                	addi	sp,sp,304
    8020607a:	8082                	ret

000000008020607c <cmd_echo>:
    8020607c:	7129                	addi	sp,sp,-320
    8020607e:	fe06                	sd	ra,312(sp)
    80206080:	fa22                	sd	s0,304(sp)
    80206082:	0280                	addi	s0,sp,320
    80206084:	eca43c23          	sd	a0,-296(s0)
    80206088:	ecb43823          	sd	a1,-304(s0)
    8020608c:	87b2                	mv	a5,a2
    8020608e:	ecf42623          	sw	a5,-308(s0)
    80206092:	ed043783          	ld	a5,-304(s0)
    80206096:	12078c63          	beqz	a5,802061ce <cmd_echo+0x152>
    8020609a:	ed043783          	ld	a5,-304(s0)
    8020609e:	0007c783          	lbu	a5,0(a5)
    802060a2:	12078663          	beqz	a5,802061ce <cmd_echo+0x152>
    802060a6:	ecc42783          	lw	a5,-308(s0)
    802060aa:	2781                	sext.w	a5,a5
    802060ac:	c7d9                	beqz	a5,8020613a <cmd_echo+0xbe>
    802060ae:	45d5                	li	a1,21
    802060b0:	ed043503          	ld	a0,-304(s0)
    802060b4:	da9fe0ef          	jal	80204e5c <fs_open>
    802060b8:	87aa                	mv	a5,a0
    802060ba:	fef42023          	sw	a5,-32(s0)
    802060be:	fe042783          	lw	a5,-32(s0)
    802060c2:	2781                	sext.w	a5,a5
    802060c4:	0007d963          	bgez	a5,802060d6 <cmd_echo+0x5a>
    802060c8:	00008517          	auipc	a0,0x8
    802060cc:	b4850513          	addi	a0,a0,-1208 # 8020dc10 <home_bin_spin.0+0x1c10>
    802060d0:	975fa0ef          	jal	80200a44 <uart_puts>
    802060d4:	aa21                	j	802061ec <cmd_echo+0x170>
    802060d6:	ed843783          	ld	a5,-296(s0)
    802060da:	c3a1                	beqz	a5,8020611a <cmd_echo+0x9e>
    802060dc:	ed843783          	ld	a5,-296(s0)
    802060e0:	0007c783          	lbu	a5,0(a5)
    802060e4:	cb9d                	beqz	a5,8020611a <cmd_echo+0x9e>
    802060e6:	fe042623          	sw	zero,-20(s0)
    802060ea:	a031                	j	802060f6 <cmd_echo+0x7a>
    802060ec:	fec42783          	lw	a5,-20(s0)
    802060f0:	2785                	addiw	a5,a5,1
    802060f2:	fef42623          	sw	a5,-20(s0)
    802060f6:	fec42783          	lw	a5,-20(s0)
    802060fa:	ed843703          	ld	a4,-296(s0)
    802060fe:	97ba                	add	a5,a5,a4
    80206100:	0007c783          	lbu	a5,0(a5)
    80206104:	f7e5                	bnez	a5,802060ec <cmd_echo+0x70>
    80206106:	fec42703          	lw	a4,-20(s0)
    8020610a:	fe042783          	lw	a5,-32(s0)
    8020610e:	863a                	mv	a2,a4
    80206110:	ed843583          	ld	a1,-296(s0)
    80206114:	853e                	mv	a0,a5
    80206116:	fddfe0ef          	jal	802050f2 <fs_write>
    8020611a:	fe042783          	lw	a5,-32(s0)
    8020611e:	4605                	li	a2,1
    80206120:	00008597          	auipc	a1,0x8
    80206124:	b0858593          	addi	a1,a1,-1272 # 8020dc28 <home_bin_spin.0+0x1c28>
    80206128:	853e                	mv	a0,a5
    8020612a:	fc9fe0ef          	jal	802050f2 <fs_write>
    8020612e:	fe042783          	lw	a5,-32(s0)
    80206132:	853e                	mv	a0,a5
    80206134:	9b8ff0ef          	jal	802052ec <fs_close>
    80206138:	a855                	j	802061ec <cmd_echo+0x170>
    8020613a:	fe042423          	sw	zero,-24(s0)
    8020613e:	fe042223          	sw	zero,-28(s0)
    80206142:	ed843783          	ld	a5,-296(s0)
    80206146:	cfa9                	beqz	a5,802061a0 <cmd_echo+0x124>
    80206148:	ed843783          	ld	a5,-296(s0)
    8020614c:	0007c783          	lbu	a5,0(a5)
    80206150:	cba1                	beqz	a5,802061a0 <cmd_echo+0x124>
    80206152:	a03d                	j	80206180 <cmd_echo+0x104>
    80206154:	fe442783          	lw	a5,-28(s0)
    80206158:	0017871b          	addiw	a4,a5,1
    8020615c:	fee42223          	sw	a4,-28(s0)
    80206160:	873e                	mv	a4,a5
    80206162:	ed843783          	ld	a5,-296(s0)
    80206166:	973e                	add	a4,a4,a5
    80206168:	fe842783          	lw	a5,-24(s0)
    8020616c:	0017869b          	addiw	a3,a5,1
    80206170:	fed42423          	sw	a3,-24(s0)
    80206174:	00074703          	lbu	a4,0(a4)
    80206178:	17c1                	addi	a5,a5,-16
    8020617a:	97a2                	add	a5,a5,s0
    8020617c:	eee78823          	sb	a4,-272(a5)
    80206180:	fe442783          	lw	a5,-28(s0)
    80206184:	ed843703          	ld	a4,-296(s0)
    80206188:	97ba                	add	a5,a5,a4
    8020618a:	0007c783          	lbu	a5,0(a5)
    8020618e:	cb89                	beqz	a5,802061a0 <cmd_echo+0x124>
    80206190:	fe842783          	lw	a5,-24(s0)
    80206194:	0007871b          	sext.w	a4,a5
    80206198:	0fd00793          	li	a5,253
    8020619c:	fae7dce3          	bge	a5,a4,80206154 <cmd_echo+0xd8>
    802061a0:	fe842783          	lw	a5,-24(s0)
    802061a4:	0017871b          	addiw	a4,a5,1
    802061a8:	fee42423          	sw	a4,-24(s0)
    802061ac:	17c1                	addi	a5,a5,-16
    802061ae:	97a2                	add	a5,a5,s0
    802061b0:	4729                	li	a4,10
    802061b2:	eee78823          	sb	a4,-272(a5)
    802061b6:	fe842703          	lw	a4,-24(s0)
    802061ba:	ee040793          	addi	a5,s0,-288
    802061be:	4685                	li	a3,1
    802061c0:	863a                	mv	a2,a4
    802061c2:	85be                	mv	a1,a5
    802061c4:	ed043503          	ld	a0,-304(s0)
    802061c8:	9d0ff0ef          	jal	80205398 <fs_write_file>
    802061cc:	a005                	j	802061ec <cmd_echo+0x170>
    802061ce:	ed843783          	ld	a5,-296(s0)
    802061d2:	cf89                	beqz	a5,802061ec <cmd_echo+0x170>
    802061d4:	ed843783          	ld	a5,-296(s0)
    802061d8:	0007c783          	lbu	a5,0(a5)
    802061dc:	cb81                	beqz	a5,802061ec <cmd_echo+0x170>
    802061de:	ed843503          	ld	a0,-296(s0)
    802061e2:	863fa0ef          	jal	80200a44 <uart_puts>
    802061e6:	4529                	li	a0,10
    802061e8:	81ffa0ef          	jal	80200a06 <uart_putc>
    802061ec:	70f2                	ld	ra,312(sp)
    802061ee:	7452                	ld	s0,304(sp)
    802061f0:	6131                	addi	sp,sp,320
    802061f2:	8082                	ret

00000000802061f4 <cmd_touch>:
    802061f4:	1101                	addi	sp,sp,-32
    802061f6:	ec06                	sd	ra,24(sp)
    802061f8:	e822                	sd	s0,16(sp)
    802061fa:	1000                	addi	s0,sp,32
    802061fc:	fea43423          	sd	a0,-24(s0)
    80206200:	4581                	li	a1,0
    80206202:	fe843503          	ld	a0,-24(s0)
    80206206:	ef0fe0ef          	jal	802048f6 <fs_create>
    8020620a:	87aa                	mv	a5,a0
    8020620c:	0007de63          	bgez	a5,80206228 <cmd_touch+0x34>
    80206210:	fe843503          	ld	a0,-24(s0)
    80206214:	863fe0ef          	jal	80204a76 <fs_exists>
    80206218:	87aa                	mv	a5,a0
    8020621a:	e799                	bnez	a5,80206228 <cmd_touch+0x34>
    8020621c:	00008517          	auipc	a0,0x8
    80206220:	a1450513          	addi	a0,a0,-1516 # 8020dc30 <home_bin_spin.0+0x1c30>
    80206224:	821fa0ef          	jal	80200a44 <uart_puts>
    80206228:	0001                	nop
    8020622a:	60e2                	ld	ra,24(sp)
    8020622c:	6442                	ld	s0,16(sp)
    8020622e:	6105                	addi	sp,sp,32
    80206230:	8082                	ret

0000000080206232 <login_session>:
    80206232:	7175                	addi	sp,sp,-144
    80206234:	e506                	sd	ra,136(sp)
    80206236:	e122                	sd	s0,128(sp)
    80206238:	0900                	addi	s0,sp,144
    8020623a:	f7040793          	addi	a5,s0,-144
    8020623e:	08000613          	li	a2,128
    80206242:	85be                	mv	a1,a5
    80206244:	00008517          	auipc	a0,0x8
    80206248:	9fc50513          	addi	a0,a0,-1540 # 8020dc40 <home_bin_spin.0+0x1c40>
    8020624c:	addfa0ef          	jal	80200d28 <uart_prompt_and_read_line>
    80206250:	87aa                	mv	a5,a0
    80206252:	04f05763          	blez	a5,802062a0 <login_session+0x6e>
    80206256:	f7040793          	addi	a5,s0,-144
    8020625a:	853e                	mv	a0,a5
    8020625c:	e54ff0ef          	jal	802058b0 <trim_line>
    80206260:	f7044783          	lbu	a5,-144(s0)
    80206264:	c3a1                	beqz	a5,802062a4 <login_session+0x72>
    80206266:	f7040793          	addi	a5,s0,-144
    8020626a:	853e                	mv	a0,a5
    8020626c:	905ff0ef          	jal	80205b70 <is_poweroff_cmd>
    80206270:	87aa                	mv	a5,a0
    80206272:	c399                	beqz	a5,80206278 <login_session+0x46>
    80206274:	c4dfa0ef          	jal	80200ec0 <machine_poweroff>
    80206278:	f7040793          	addi	a5,s0,-144
    8020627c:	00008597          	auipc	a1,0x8
    80206280:	9cc58593          	addi	a1,a1,-1588 # 8020dc48 <home_bin_spin.0+0x1c48>
    80206284:	853e                	mv	a0,a5
    80206286:	d58ff0ef          	jal	802057de <str_eq>
    8020628a:	87aa                	mv	a5,a0
    8020628c:	c399                	beqz	a5,80206292 <login_session+0x60>
    8020628e:	4781                	li	a5,0
    80206290:	a821                	j	802062a8 <login_session+0x76>
    80206292:	00008517          	auipc	a0,0x8
    80206296:	9be50513          	addi	a0,a0,-1602 # 8020dc50 <home_bin_spin.0+0x1c50>
    8020629a:	faafa0ef          	jal	80200a44 <uart_puts>
    8020629e:	bf71                	j	8020623a <login_session+0x8>
    802062a0:	0001                	nop
    802062a2:	bf61                	j	8020623a <login_session+0x8>
    802062a4:	0001                	nop
    802062a6:	bf51                	j	8020623a <login_session+0x8>
    802062a8:	853e                	mv	a0,a5
    802062aa:	60aa                	ld	ra,136(sp)
    802062ac:	640a                	ld	s0,128(sp)
    802062ae:	6149                	addi	sp,sp,144
    802062b0:	8082                	ret

00000000802062b2 <print_help>:
    802062b2:	1141                	addi	sp,sp,-16
    802062b4:	e406                	sd	ra,8(sp)
    802062b6:	e022                	sd	s0,0(sp)
    802062b8:	0800                	addi	s0,sp,16
    802062ba:	00008517          	auipc	a0,0x8
    802062be:	9b650513          	addi	a0,a0,-1610 # 8020dc70 <home_bin_spin.0+0x1c70>
    802062c2:	f82fa0ef          	jal	80200a44 <uart_puts>
    802062c6:	00008517          	auipc	a0,0x8
    802062ca:	9ca50513          	addi	a0,a0,-1590 # 8020dc90 <home_bin_spin.0+0x1c90>
    802062ce:	f76fa0ef          	jal	80200a44 <uart_puts>
    802062d2:	00008517          	auipc	a0,0x8
    802062d6:	9ee50513          	addi	a0,a0,-1554 # 8020dcc0 <home_bin_spin.0+0x1cc0>
    802062da:	f6afa0ef          	jal	80200a44 <uart_puts>
    802062de:	00008517          	auipc	a0,0x8
    802062e2:	a1250513          	addi	a0,a0,-1518 # 8020dcf0 <home_bin_spin.0+0x1cf0>
    802062e6:	f5efa0ef          	jal	80200a44 <uart_puts>
    802062ea:	00008517          	auipc	a0,0x8
    802062ee:	a3e50513          	addi	a0,a0,-1474 # 8020dd28 <home_bin_spin.0+0x1d28>
    802062f2:	f52fa0ef          	jal	80200a44 <uart_puts>
    802062f6:	00008517          	auipc	a0,0x8
    802062fa:	a5250513          	addi	a0,a0,-1454 # 8020dd48 <home_bin_spin.0+0x1d48>
    802062fe:	f46fa0ef          	jal	80200a44 <uart_puts>
    80206302:	0001                	nop
    80206304:	60a2                	ld	ra,8(sp)
    80206306:	6402                	ld	s0,0(sp)
    80206308:	0141                	addi	sp,sp,16
    8020630a:	8082                	ret

000000008020630c <shell_loop>:
    8020630c:	716d                	addi	sp,sp,-272
    8020630e:	e606                	sd	ra,264(sp)
    80206310:	e222                	sd	s0,256(sp)
    80206312:	0a00                	addi	s0,sp,272
    80206314:	00008517          	auipc	a0,0x8
    80206318:	a7450513          	addi	a0,a0,-1420 # 8020dd88 <home_bin_spin.0+0x1d88>
    8020631c:	f28fa0ef          	jal	80200a44 <uart_puts>
    80206320:	00008517          	auipc	a0,0x8
    80206324:	8a050513          	addi	a0,a0,-1888 # 8020dbc0 <home_bin_spin.0+0x1bc0>
    80206328:	813fe0ef          	jal	80204b3a <fs_chdir>
    8020632c:	f87ff0ef          	jal	802062b2 <print_help>
    80206330:	ff0fe0ef          	jal	80204b20 <fs_getcwd>
    80206334:	872a                	mv	a4,a0
    80206336:	f0840793          	addi	a5,s0,-248
    8020633a:	86ba                	mv	a3,a4
    8020633c:	00008617          	auipc	a2,0x8
    80206340:	a6460613          	addi	a2,a2,-1436 # 8020dda0 <home_bin_spin.0+0x1da0>
    80206344:	06000593          	li	a1,96
    80206348:	853e                	mv	a0,a5
    8020634a:	944fb0ef          	jal	8020148e <snprintf>
    8020634e:	f6840713          	addi	a4,s0,-152
    80206352:	f0840793          	addi	a5,s0,-248
    80206356:	08000613          	li	a2,128
    8020635a:	85ba                	mv	a1,a4
    8020635c:	853e                	mv	a0,a5
    8020635e:	9cbfa0ef          	jal	80200d28 <uart_prompt_and_read_line>
    80206362:	87aa                	mv	a5,a0
    80206364:	3a07cd63          	bltz	a5,8020671e <shell_loop+0x412>
    80206368:	f6840793          	addi	a5,s0,-152
    8020636c:	853e                	mv	a0,a5
    8020636e:	d42ff0ef          	jal	802058b0 <trim_line>
    80206372:	f6844783          	lbu	a5,-152(s0)
    80206376:	3a078663          	beqz	a5,80206722 <shell_loop+0x416>
    8020637a:	f6840793          	addi	a5,s0,-152
    8020637e:	00008597          	auipc	a1,0x8
    80206382:	a3258593          	addi	a1,a1,-1486 # 8020ddb0 <home_bin_spin.0+0x1db0>
    80206386:	853e                	mv	a0,a5
    80206388:	c56ff0ef          	jal	802057de <str_eq>
    8020638c:	87aa                	mv	a5,a0
    8020638e:	ef81                	bnez	a5,802063a6 <shell_loop+0x9a>
    80206390:	f6840793          	addi	a5,s0,-152
    80206394:	00008597          	auipc	a1,0x8
    80206398:	a2458593          	addi	a1,a1,-1500 # 8020ddb8 <home_bin_spin.0+0x1db8>
    8020639c:	853e                	mv	a0,a5
    8020639e:	c40ff0ef          	jal	802057de <str_eq>
    802063a2:	87aa                	mv	a5,a0
    802063a4:	c781                	beqz	a5,802063ac <shell_loop+0xa0>
    802063a6:	f0dff0ef          	jal	802062b2 <print_help>
    802063aa:	aead                	j	80206724 <shell_loop+0x418>
    802063ac:	f6840793          	addi	a5,s0,-152
    802063b0:	00008597          	auipc	a1,0x8
    802063b4:	a1058593          	addi	a1,a1,-1520 # 8020ddc0 <home_bin_spin.0+0x1dc0>
    802063b8:	853e                	mv	a0,a5
    802063ba:	c24ff0ef          	jal	802057de <str_eq>
    802063be:	87aa                	mv	a5,a0
    802063c0:	ef81                	bnez	a5,802063d8 <shell_loop+0xcc>
    802063c2:	f6840793          	addi	a5,s0,-152
    802063c6:	00008597          	auipc	a1,0x8
    802063ca:	a0258593          	addi	a1,a1,-1534 # 8020ddc8 <home_bin_spin.0+0x1dc8>
    802063ce:	853e                	mv	a0,a5
    802063d0:	c0eff0ef          	jal	802057de <str_eq>
    802063d4:	87aa                	mv	a5,a0
    802063d6:	cb81                	beqz	a5,802063e6 <shell_loop+0xda>
    802063d8:	00008517          	auipc	a0,0x8
    802063dc:	9f850513          	addi	a0,a0,-1544 # 8020ddd0 <home_bin_spin.0+0x1dd0>
    802063e0:	e64fa0ef          	jal	80200a44 <uart_puts>
    802063e4:	a689                	j	80206726 <shell_loop+0x41a>
    802063e6:	f6840793          	addi	a5,s0,-152
    802063ea:	853e                	mv	a0,a5
    802063ec:	f84ff0ef          	jal	80205b70 <is_poweroff_cmd>
    802063f0:	87aa                	mv	a5,a0
    802063f2:	c399                	beqz	a5,802063f8 <shell_loop+0xec>
    802063f4:	acdfa0ef          	jal	80200ec0 <machine_poweroff>
    802063f8:	f6840793          	addi	a5,s0,-152
    802063fc:	00008597          	auipc	a1,0x8
    80206400:	9e458593          	addi	a1,a1,-1564 # 8020dde0 <home_bin_spin.0+0x1de0>
    80206404:	853e                	mv	a0,a5
    80206406:	bd8ff0ef          	jal	802057de <str_eq>
    8020640a:	87aa                	mv	a5,a0
    8020640c:	c781                	beqz	a5,80206414 <shell_loop+0x108>
    8020640e:	b45ff0ef          	jal	80205f52 <cmd_pwd>
    80206412:	bf39                	j	80206330 <shell_loop+0x24>
    80206414:	f6840793          	addi	a5,s0,-152
    80206418:	00008597          	auipc	a1,0x8
    8020641c:	9d058593          	addi	a1,a1,-1584 # 8020dde8 <home_bin_spin.0+0x1de8>
    80206420:	853e                	mv	a0,a5
    80206422:	c3aff0ef          	jal	8020585c <str_prefix>
    80206426:	87aa                	mv	a5,a0
    80206428:	cf81                	beqz	a5,80206440 <shell_loop+0x134>
    8020642a:	f6840793          	addi	a5,s0,-152
    8020642e:	0789                	addi	a5,a5,2
    80206430:	853e                	mv	a0,a5
    80206432:	dd8ff0ef          	jal	80205a0a <skip_word>
    80206436:	87aa                	mv	a5,a0
    80206438:	853e                	mv	a0,a5
    8020643a:	b3dff0ef          	jal	80205f76 <cmd_cd>
    8020643e:	bdcd                	j	80206330 <shell_loop+0x24>
    80206440:	f6840793          	addi	a5,s0,-152
    80206444:	00008597          	auipc	a1,0x8
    80206448:	9ac58593          	addi	a1,a1,-1620 # 8020ddf0 <home_bin_spin.0+0x1df0>
    8020644c:	853e                	mv	a0,a5
    8020644e:	b90ff0ef          	jal	802057de <str_eq>
    80206452:	87aa                	mv	a5,a0
    80206454:	cb81                	beqz	a5,80206464 <shell_loop+0x158>
    80206456:	00007517          	auipc	a0,0x7
    8020645a:	76a50513          	addi	a0,a0,1898 # 8020dbc0 <home_bin_spin.0+0x1bc0>
    8020645e:	b19ff0ef          	jal	80205f76 <cmd_cd>
    80206462:	b5f9                	j	80206330 <shell_loop+0x24>
    80206464:	f6840793          	addi	a5,s0,-152
    80206468:	00008597          	auipc	a1,0x8
    8020646c:	99058593          	addi	a1,a1,-1648 # 8020ddf8 <home_bin_spin.0+0x1df8>
    80206470:	853e                	mv	a0,a5
    80206472:	beaff0ef          	jal	8020585c <str_prefix>
    80206476:	87aa                	mv	a5,a0
    80206478:	cf81                	beqz	a5,80206490 <shell_loop+0x184>
    8020647a:	f6840793          	addi	a5,s0,-152
    8020647e:	0789                	addi	a5,a5,2
    80206480:	853e                	mv	a0,a5
    80206482:	d88ff0ef          	jal	80205a0a <skip_word>
    80206486:	87aa                	mv	a5,a0
    80206488:	853e                	mv	a0,a5
    8020648a:	a51ff0ef          	jal	80205eda <cmd_ls>
    8020648e:	b54d                	j	80206330 <shell_loop+0x24>
    80206490:	f6840793          	addi	a5,s0,-152
    80206494:	00008597          	auipc	a1,0x8
    80206498:	96c58593          	addi	a1,a1,-1684 # 8020de00 <home_bin_spin.0+0x1e00>
    8020649c:	853e                	mv	a0,a5
    8020649e:	b40ff0ef          	jal	802057de <str_eq>
    802064a2:	87aa                	mv	a5,a0
    802064a4:	c789                	beqz	a5,802064ae <shell_loop+0x1a2>
    802064a6:	4501                	li	a0,0
    802064a8:	a33ff0ef          	jal	80205eda <cmd_ls>
    802064ac:	b551                	j	80206330 <shell_loop+0x24>
    802064ae:	f6840793          	addi	a5,s0,-152
    802064b2:	00008597          	auipc	a1,0x8
    802064b6:	95658593          	addi	a1,a1,-1706 # 8020de08 <home_bin_spin.0+0x1e08>
    802064ba:	853e                	mv	a0,a5
    802064bc:	ba0ff0ef          	jal	8020585c <str_prefix>
    802064c0:	87aa                	mv	a5,a0
    802064c2:	cf81                	beqz	a5,802064da <shell_loop+0x1ce>
    802064c4:	f6840793          	addi	a5,s0,-152
    802064c8:	078d                	addi	a5,a5,3
    802064ca:	853e                	mv	a0,a5
    802064cc:	d3eff0ef          	jal	80205a0a <skip_word>
    802064d0:	87aa                	mv	a5,a0
    802064d2:	853e                	mv	a0,a5
    802064d4:	af9ff0ef          	jal	80205fcc <cmd_cat>
    802064d8:	bda1                	j	80206330 <shell_loop+0x24>
    802064da:	f6840793          	addi	a5,s0,-152
    802064de:	00008597          	auipc	a1,0x8
    802064e2:	93258593          	addi	a1,a1,-1742 # 8020de10 <home_bin_spin.0+0x1e10>
    802064e6:	853e                	mv	a0,a5
    802064e8:	b74ff0ef          	jal	8020585c <str_prefix>
    802064ec:	87aa                	mv	a5,a0
    802064ee:	cf81                	beqz	a5,80206506 <shell_loop+0x1fa>
    802064f0:	f6840793          	addi	a5,s0,-152
    802064f4:	0795                	addi	a5,a5,5
    802064f6:	853e                	mv	a0,a5
    802064f8:	d12ff0ef          	jal	80205a0a <skip_word>
    802064fc:	87aa                	mv	a5,a0
    802064fe:	853e                	mv	a0,a5
    80206500:	cf5ff0ef          	jal	802061f4 <cmd_touch>
    80206504:	b535                	j	80206330 <shell_loop+0x24>
    80206506:	f6840793          	addi	a5,s0,-152
    8020650a:	00008597          	auipc	a1,0x8
    8020650e:	90e58593          	addi	a1,a1,-1778 # 8020de18 <home_bin_spin.0+0x1e18>
    80206512:	853e                	mv	a0,a5
    80206514:	b48ff0ef          	jal	8020585c <str_prefix>
    80206518:	87aa                	mv	a5,a0
    8020651a:	cf81                	beqz	a5,80206532 <shell_loop+0x226>
    8020651c:	f6840793          	addi	a5,s0,-152
    80206520:	0789                	addi	a5,a5,2
    80206522:	853e                	mv	a0,a5
    80206524:	ce6ff0ef          	jal	80205a0a <skip_word>
    80206528:	87aa                	mv	a5,a0
    8020652a:	853e                	mv	a0,a5
    8020652c:	67a000ef          	jal	80206ba6 <vi_edit>
    80206530:	b501                	j	80206330 <shell_loop+0x24>
    80206532:	f6840793          	addi	a5,s0,-152
    80206536:	00008597          	auipc	a1,0x8
    8020653a:	8ea58593          	addi	a1,a1,-1814 # 8020de20 <home_bin_spin.0+0x1e20>
    8020653e:	853e                	mv	a0,a5
    80206540:	b1cff0ef          	jal	8020585c <str_prefix>
    80206544:	87aa                	mv	a5,a0
    80206546:	cbb9                	beqz	a5,8020659c <shell_loop+0x290>
    80206548:	f0043023          	sd	zero,-256(s0)
    8020654c:	ee042e23          	sw	zero,-260(s0)
    80206550:	f6840793          	addi	a5,s0,-152
    80206554:	0795                	addi	a5,a5,5
    80206556:	fef43423          	sd	a5,-24(s0)
    8020655a:	efc40713          	addi	a4,s0,-260
    8020655e:	f0040793          	addi	a5,s0,-256
    80206562:	863a                	mv	a2,a4
    80206564:	85be                	mv	a1,a5
    80206566:	fe843503          	ld	a0,-24(s0)
    8020656a:	d20ff0ef          	jal	80205a8a <find_redirect>
    8020656e:	fe843503          	ld	a0,-24(s0)
    80206572:	b3eff0ef          	jal	802058b0 <trim_line>
    80206576:	f0043783          	ld	a5,-256(s0)
    8020657a:	c791                	beqz	a5,80206586 <shell_loop+0x27a>
    8020657c:	f0043783          	ld	a5,-256(s0)
    80206580:	853e                	mv	a0,a5
    80206582:	b2eff0ef          	jal	802058b0 <trim_line>
    80206586:	f0043783          	ld	a5,-256(s0)
    8020658a:	efc42703          	lw	a4,-260(s0)
    8020658e:	863a                	mv	a2,a4
    80206590:	85be                	mv	a1,a5
    80206592:	fe843503          	ld	a0,-24(s0)
    80206596:	ae7ff0ef          	jal	8020607c <cmd_echo>
    8020659a:	bb59                	j	80206330 <shell_loop+0x24>
    8020659c:	f6840793          	addi	a5,s0,-152
    802065a0:	00008597          	auipc	a1,0x8
    802065a4:	88858593          	addi	a1,a1,-1912 # 8020de28 <home_bin_spin.0+0x1e28>
    802065a8:	853e                	mv	a0,a5
    802065aa:	ab2ff0ef          	jal	8020585c <str_prefix>
    802065ae:	87aa                	mv	a5,a0
    802065b0:	cf81                	beqz	a5,802065c8 <shell_loop+0x2bc>
    802065b2:	f6840793          	addi	a5,s0,-152
    802065b6:	0789                	addi	a5,a5,2
    802065b8:	853e                	mv	a0,a5
    802065ba:	c50ff0ef          	jal	80205a0a <skip_word>
    802065be:	87aa                	mv	a5,a0
    802065c0:	853e                	mv	a0,a5
    802065c2:	290000ef          	jal	80206852 <script_run>
    802065c6:	b3ad                	j	80206330 <shell_loop+0x24>
    802065c8:	f6840793          	addi	a5,s0,-152
    802065cc:	00008597          	auipc	a1,0x8
    802065d0:	86458593          	addi	a1,a1,-1948 # 8020de30 <home_bin_spin.0+0x1e30>
    802065d4:	853e                	mv	a0,a5
    802065d6:	a86ff0ef          	jal	8020585c <str_prefix>
    802065da:	87aa                	mv	a5,a0
    802065dc:	e39d                	bnez	a5,80206602 <shell_loop+0x2f6>
    802065de:	f6844783          	lbu	a5,-152(s0)
    802065e2:	873e                	mv	a4,a5
    802065e4:	02f00793          	li	a5,47
    802065e8:	04f71563          	bne	a4,a5,80206632 <shell_loop+0x326>
    802065ec:	f6840793          	addi	a5,s0,-152
    802065f0:	00008597          	auipc	a1,0x8
    802065f4:	84858593          	addi	a1,a1,-1976 # 8020de38 <home_bin_spin.0+0x1e38>
    802065f8:	853e                	mv	a0,a5
    802065fa:	a62ff0ef          	jal	8020585c <str_prefix>
    802065fe:	87aa                	mv	a5,a0
    80206600:	eb8d                	bnez	a5,80206632 <shell_loop+0x326>
    80206602:	f6840793          	addi	a5,s0,-152
    80206606:	00008597          	auipc	a1,0x8
    8020660a:	82a58593          	addi	a1,a1,-2006 # 8020de30 <home_bin_spin.0+0x1e30>
    8020660e:	853e                	mv	a0,a5
    80206610:	a4cff0ef          	jal	8020585c <str_prefix>
    80206614:	87aa                	mv	a5,a0
    80206616:	cb81                	beqz	a5,80206626 <shell_loop+0x31a>
    80206618:	f6840793          	addi	a5,s0,-152
    8020661c:	0789                	addi	a5,a5,2
    8020661e:	853e                	mv	a0,a5
    80206620:	e50fd0ef          	jal	80203c70 <prog_exec>
    80206624:	a201                	j	80206724 <shell_loop+0x418>
    80206626:	f6840793          	addi	a5,s0,-152
    8020662a:	853e                	mv	a0,a5
    8020662c:	e44fd0ef          	jal	80203c70 <prog_exec>
    80206630:	a8d5                	j	80206724 <shell_loop+0x418>
    80206632:	f6840793          	addi	a5,s0,-152
    80206636:	00008597          	auipc	a1,0x8
    8020663a:	80a58593          	addi	a1,a1,-2038 # 8020de40 <home_bin_spin.0+0x1e40>
    8020663e:	853e                	mv	a0,a5
    80206640:	99eff0ef          	jal	802057de <str_eq>
    80206644:	87aa                	mv	a5,a0
    80206646:	c789                	beqz	a5,80206650 <shell_loop+0x344>
    80206648:	4501                	li	a0,0
    8020664a:	ea4ff0ef          	jal	80205cee <cmd_ps>
    8020664e:	b1cd                	j	80206330 <shell_loop+0x24>
    80206650:	f6840793          	addi	a5,s0,-152
    80206654:	00007597          	auipc	a1,0x7
    80206658:	7f458593          	addi	a1,a1,2036 # 8020de48 <home_bin_spin.0+0x1e48>
    8020665c:	853e                	mv	a0,a5
    8020665e:	980ff0ef          	jal	802057de <str_eq>
    80206662:	87aa                	mv	a5,a0
    80206664:	c789                	beqz	a5,8020666e <shell_loop+0x362>
    80206666:	4505                	li	a0,1
    80206668:	e86ff0ef          	jal	80205cee <cmd_ps>
    8020666c:	b1d1                	j	80206330 <shell_loop+0x24>
    8020666e:	f6840793          	addi	a5,s0,-152
    80206672:	00007597          	auipc	a1,0x7
    80206676:	7de58593          	addi	a1,a1,2014 # 8020de50 <home_bin_spin.0+0x1e50>
    8020667a:	853e                	mv	a0,a5
    8020667c:	962ff0ef          	jal	802057de <str_eq>
    80206680:	87aa                	mv	a5,a0
    80206682:	ef81                	bnez	a5,8020669a <shell_loop+0x38e>
    80206684:	f6840793          	addi	a5,s0,-152
    80206688:	00007597          	auipc	a1,0x7
    8020668c:	7d858593          	addi	a1,a1,2008 # 8020de60 <home_bin_spin.0+0x1e60>
    80206690:	853e                	mv	a0,a5
    80206692:	94cff0ef          	jal	802057de <str_eq>
    80206696:	87aa                	mv	a5,a0
    80206698:	cb91                	beqz	a5,802066ac <shell_loop+0x3a0>
    8020669a:	818fd0ef          	jal	802036b2 <proc_spawn_worker_demo>
    8020669e:	00007517          	auipc	a0,0x7
    802066a2:	7ca50513          	addi	a0,a0,1994 # 8020de68 <home_bin_spin.0+0x1e68>
    802066a6:	b9efa0ef          	jal	80200a44 <uart_puts>
    802066aa:	a8ad                	j	80206724 <shell_loop+0x418>
    802066ac:	f6840793          	addi	a5,s0,-152
    802066b0:	00007597          	auipc	a1,0x7
    802066b4:	7d858593          	addi	a1,a1,2008 # 8020de88 <home_bin_spin.0+0x1e88>
    802066b8:	853e                	mv	a0,a5
    802066ba:	924ff0ef          	jal	802057de <str_eq>
    802066be:	87aa                	mv	a5,a0
    802066c0:	ef81                	bnez	a5,802066d8 <shell_loop+0x3cc>
    802066c2:	f6840793          	addi	a5,s0,-152
    802066c6:	00007597          	auipc	a1,0x7
    802066ca:	7d258593          	addi	a1,a1,2002 # 8020de98 <home_bin_spin.0+0x1e98>
    802066ce:	853e                	mv	a0,a5
    802066d0:	90eff0ef          	jal	802057de <str_eq>
    802066d4:	87aa                	mv	a5,a0
    802066d6:	c781                	beqz	a5,802066de <shell_loop+0x3d2>
    802066d8:	8c2ff0ef          	jal	8020579a <demo_run_tasks>
    802066dc:	a0a1                	j	80206724 <shell_loop+0x418>
    802066de:	f6840793          	addi	a5,s0,-152
    802066e2:	00007597          	auipc	a1,0x7
    802066e6:	7be58593          	addi	a1,a1,1982 # 8020dea0 <home_bin_spin.0+0x1ea0>
    802066ea:	853e                	mv	a0,a5
    802066ec:	8f2ff0ef          	jal	802057de <str_eq>
    802066f0:	87aa                	mv	a5,a0
    802066f2:	ef81                	bnez	a5,8020670a <shell_loop+0x3fe>
    802066f4:	f6840793          	addi	a5,s0,-152
    802066f8:	00007597          	auipc	a1,0x7
    802066fc:	7b858593          	addi	a1,a1,1976 # 8020deb0 <home_bin_spin.0+0x1eb0>
    80206700:	853e                	mv	a0,a5
    80206702:	8dcff0ef          	jal	802057de <str_eq>
    80206706:	87aa                	mv	a5,a0
    80206708:	c781                	beqz	a5,80206710 <shell_loop+0x404>
    8020670a:	81efb0ef          	jal	80201728 <osviz_snapshot>
    8020670e:	a819                	j	80206724 <shell_loop+0x418>
    80206710:	00007517          	auipc	a0,0x7
    80206714:	7b050513          	addi	a0,a0,1968 # 8020dec0 <home_bin_spin.0+0x1ec0>
    80206718:	b2cfa0ef          	jal	80200a44 <uart_puts>
    8020671c:	b911                	j	80206330 <shell_loop+0x24>
    8020671e:	0001                	nop
    80206720:	b901                	j	80206330 <shell_loop+0x24>
    80206722:	0001                	nop
    80206724:	b131                	j	80206330 <shell_loop+0x24>
    80206726:	60b2                	ld	ra,264(sp)
    80206728:	6412                	ld	s0,256(sp)
    8020672a:	6151                	addi	sp,sp,272
    8020672c:	8082                	ret

000000008020672e <console_run>:
    8020672e:	1141                	addi	sp,sp,-16
    80206730:	e406                	sd	ra,8(sp)
    80206732:	e022                	sd	s0,0(sp)
    80206734:	0800                	addi	s0,sp,16
    80206736:	00007517          	auipc	a0,0x7
    8020673a:	7aa50513          	addi	a0,a0,1962 # 8020dee0 <home_bin_spin.0+0x1ee0>
    8020673e:	b06fa0ef          	jal	80200a44 <uart_puts>
    80206742:	af1ff0ef          	jal	80206232 <login_session>
    80206746:	bc7ff0ef          	jal	8020630c <shell_loop>
    8020674a:	0001                	nop
    8020674c:	b7ed                	j	80206736 <console_run+0x8>

000000008020674e <skip_space>:
    8020674e:	1101                	addi	sp,sp,-32
    80206750:	ec06                	sd	ra,24(sp)
    80206752:	e822                	sd	s0,16(sp)
    80206754:	1000                	addi	s0,sp,32
    80206756:	fea43423          	sd	a0,-24(s0)
    8020675a:	a809                	j	8020676c <skip_space+0x1e>
    8020675c:	fe843783          	ld	a5,-24(s0)
    80206760:	639c                	ld	a5,0(a5)
    80206762:	00178713          	addi	a4,a5,1
    80206766:	fe843783          	ld	a5,-24(s0)
    8020676a:	e398                	sd	a4,0(a5)
    8020676c:	fe843783          	ld	a5,-24(s0)
    80206770:	639c                	ld	a5,0(a5)
    80206772:	0007c783          	lbu	a5,0(a5)
    80206776:	873e                	mv	a4,a5
    80206778:	02000793          	li	a5,32
    8020677c:	fef700e3          	beq	a4,a5,8020675c <skip_space+0xe>
    80206780:	fe843783          	ld	a5,-24(s0)
    80206784:	639c                	ld	a5,0(a5)
    80206786:	0007c783          	lbu	a5,0(a5)
    8020678a:	873e                	mv	a4,a5
    8020678c:	47a5                	li	a5,9
    8020678e:	fcf707e3          	beq	a4,a5,8020675c <skip_space+0xe>
    80206792:	0001                	nop
    80206794:	0001                	nop
    80206796:	60e2                	ld	ra,24(sp)
    80206798:	6442                	ld	s0,16(sp)
    8020679a:	6105                	addi	sp,sp,32
    8020679c:	8082                	ret

000000008020679e <line_eq>:
    8020679e:	1101                	addi	sp,sp,-32
    802067a0:	ec06                	sd	ra,24(sp)
    802067a2:	e822                	sd	s0,16(sp)
    802067a4:	1000                	addi	s0,sp,32
    802067a6:	fea43423          	sd	a0,-24(s0)
    802067aa:	feb43023          	sd	a1,-32(s0)
    802067ae:	a03d                	j	802067dc <line_eq+0x3e>
    802067b0:	fe843783          	ld	a5,-24(s0)
    802067b4:	0007c703          	lbu	a4,0(a5)
    802067b8:	fe043783          	ld	a5,-32(s0)
    802067bc:	0007c783          	lbu	a5,0(a5)
    802067c0:	00f70463          	beq	a4,a5,802067c8 <line_eq+0x2a>
    802067c4:	4781                	li	a5,0
    802067c6:	a889                	j	80206818 <line_eq+0x7a>
    802067c8:	fe843783          	ld	a5,-24(s0)
    802067cc:	0785                	addi	a5,a5,1
    802067ce:	fef43423          	sd	a5,-24(s0)
    802067d2:	fe043783          	ld	a5,-32(s0)
    802067d6:	0785                	addi	a5,a5,1
    802067d8:	fef43023          	sd	a5,-32(s0)
    802067dc:	fe043783          	ld	a5,-32(s0)
    802067e0:	0007c783          	lbu	a5,0(a5)
    802067e4:	f7f1                	bnez	a5,802067b0 <line_eq+0x12>
    802067e6:	fe843783          	ld	a5,-24(s0)
    802067ea:	0007c783          	lbu	a5,0(a5)
    802067ee:	c395                	beqz	a5,80206812 <line_eq+0x74>
    802067f0:	fe843783          	ld	a5,-24(s0)
    802067f4:	0007c783          	lbu	a5,0(a5)
    802067f8:	873e                	mv	a4,a5
    802067fa:	02000793          	li	a5,32
    802067fe:	00f70a63          	beq	a4,a5,80206812 <line_eq+0x74>
    80206802:	fe843783          	ld	a5,-24(s0)
    80206806:	0007c783          	lbu	a5,0(a5)
    8020680a:	873e                	mv	a4,a5
    8020680c:	47a5                	li	a5,9
    8020680e:	00f71463          	bne	a4,a5,80206816 <line_eq+0x78>
    80206812:	4785                	li	a5,1
    80206814:	a011                	j	80206818 <line_eq+0x7a>
    80206816:	4781                	li	a5,0
    80206818:	853e                	mv	a0,a5
    8020681a:	60e2                	ld	ra,24(sp)
    8020681c:	6442                	ld	s0,16(sp)
    8020681e:	6105                	addi	sp,sp,32
    80206820:	8082                	ret

0000000080206822 <run_echo>:
    80206822:	1101                	addi	sp,sp,-32
    80206824:	ec06                	sd	ra,24(sp)
    80206826:	e822                	sd	s0,16(sp)
    80206828:	1000                	addi	s0,sp,32
    8020682a:	fea43423          	sd	a0,-24(s0)
    8020682e:	fe840793          	addi	a5,s0,-24
    80206832:	853e                	mv	a0,a5
    80206834:	f1bff0ef          	jal	8020674e <skip_space>
    80206838:	fe843783          	ld	a5,-24(s0)
    8020683c:	853e                	mv	a0,a5
    8020683e:	a06fa0ef          	jal	80200a44 <uart_puts>
    80206842:	4529                	li	a0,10
    80206844:	9c2fa0ef          	jal	80200a06 <uart_putc>
    80206848:	0001                	nop
    8020684a:	60e2                	ld	ra,24(sp)
    8020684c:	6442                	ld	s0,16(sp)
    8020684e:	6105                	addi	sp,sp,32
    80206850:	8082                	ret

0000000080206852 <script_run>:
    80206852:	7139                	addi	sp,sp,-64
    80206854:	fc06                	sd	ra,56(sp)
    80206856:	f822                	sd	s0,48(sp)
    80206858:	0080                	addi	s0,sp,64
    8020685a:	72f1                	lui	t0,0xffffc
    8020685c:	9116                	add	sp,sp,t0
    8020685e:	77f1                	lui	a5,0xffffc
    80206860:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206862:	97a2                	add	a5,a5,s0
    80206864:	fca7bc23          	sd	a0,-40(a5)
    80206868:	fe042223          	sw	zero,-28(s0)
    8020686c:	77f1                	lui	a5,0xffffc
    8020686e:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206870:	97a2                	add	a5,a5,s0
    80206872:	4581                	li	a1,0
    80206874:	fd87b503          	ld	a0,-40(a5)
    80206878:	de4fe0ef          	jal	80204e5c <fs_open>
    8020687c:	87aa                	mv	a5,a0
    8020687e:	fcf42a23          	sw	a5,-44(s0)
    80206882:	fd442783          	lw	a5,-44(s0)
    80206886:	2781                	sext.w	a5,a5
    80206888:	0007df63          	bgez	a5,802068a6 <script_run+0x54>
    8020688c:	77f1                	lui	a5,0xffffc
    8020688e:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206890:	97a2                	add	a5,a5,s0
    80206892:	fd87b583          	ld	a1,-40(a5)
    80206896:	00007517          	auipc	a0,0x7
    8020689a:	66250513          	addi	a0,a0,1634 # 8020def8 <home_bin_spin.0+0x1ef8>
    8020689e:	b99fa0ef          	jal	80201436 <printf>
    802068a2:	57fd                	li	a5,-1
    802068a4:	a2f5                	j	80206a90 <script_run+0x23e>
    802068a6:	77f1                	lui	a5,0xffffc
    802068a8:	1781                	addi	a5,a5,-32 # ffffffffffffbfe0 <_memory_end+0xffffffff77dfbfe0>
    802068aa:	17c1                	addi	a5,a5,-16
    802068ac:	008786b3          	add	a3,a5,s0
    802068b0:	fd442703          	lw	a4,-44(s0)
    802068b4:	6791                	lui	a5,0x4
    802068b6:	fff78613          	addi	a2,a5,-1 # 3fff <STACK_SIZE+0x2fff>
    802068ba:	85b6                	mv	a1,a3
    802068bc:	853a                	mv	a0,a4
    802068be:	f18fe0ef          	jal	80204fd6 <fs_read>
    802068c2:	87aa                	mv	a5,a0
    802068c4:	fcf42823          	sw	a5,-48(s0)
    802068c8:	fd442783          	lw	a5,-44(s0)
    802068cc:	853e                	mv	a0,a5
    802068ce:	a1ffe0ef          	jal	802052ec <fs_close>
    802068d2:	fd042783          	lw	a5,-48(s0)
    802068d6:	2781                	sext.w	a5,a5
    802068d8:	00f04f63          	bgtz	a5,802068f6 <script_run+0xa4>
    802068dc:	77f1                	lui	a5,0xffffc
    802068de:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802068e0:	97a2                	add	a5,a5,s0
    802068e2:	fd87b583          	ld	a1,-40(a5)
    802068e6:	00007517          	auipc	a0,0x7
    802068ea:	63250513          	addi	a0,a0,1586 # 8020df18 <home_bin_spin.0+0x1f18>
    802068ee:	b49fa0ef          	jal	80201436 <printf>
    802068f2:	57fd                	li	a5,-1
    802068f4:	aa71                	j	80206a90 <script_run+0x23e>
    802068f6:	77f1                	lui	a5,0xffffc
    802068f8:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802068fa:	00878733          	add	a4,a5,s0
    802068fe:	fd042783          	lw	a5,-48(s0)
    80206902:	97ba                	add	a5,a5,a4
    80206904:	fe078023          	sb	zero,-32(a5)
    80206908:	77f1                	lui	a5,0xffffc
    8020690a:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020690c:	97a2                	add	a5,a5,s0
    8020690e:	fd87b583          	ld	a1,-40(a5)
    80206912:	00007517          	auipc	a0,0x7
    80206916:	61650513          	addi	a0,a0,1558 # 8020df28 <home_bin_spin.0+0x1f28>
    8020691a:	b1dfa0ef          	jal	80201436 <printf>
    8020691e:	fe042423          	sw	zero,-24(s0)
    80206922:	fe042623          	sw	zero,-20(s0)
    80206926:	aa3d                	j	80206a64 <script_run+0x212>
    80206928:	fec42783          	lw	a5,-20(s0)
    8020692c:	873e                	mv	a4,a5
    8020692e:	fd042783          	lw	a5,-48(s0)
    80206932:	2701                	sext.w	a4,a4
    80206934:	2781                	sext.w	a5,a5
    80206936:	00f75f63          	bge	a4,a5,80206954 <script_run+0x102>
    8020693a:	77f1                	lui	a5,0xffffc
    8020693c:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020693e:	00878733          	add	a4,a5,s0
    80206942:	fec42783          	lw	a5,-20(s0)
    80206946:	97ba                	add	a5,a5,a4
    80206948:	fe07c783          	lbu	a5,-32(a5)
    8020694c:	873e                	mv	a4,a5
    8020694e:	47a9                	li	a5,10
    80206950:	10f71463          	bne	a4,a5,80206a58 <script_run+0x206>
    80206954:	77f1                	lui	a5,0xffffc
    80206956:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206958:	00878733          	add	a4,a5,s0
    8020695c:	fec42783          	lw	a5,-20(s0)
    80206960:	97ba                	add	a5,a5,a4
    80206962:	fe078023          	sb	zero,-32(a5)
    80206966:	77f1                	lui	a5,0xffffc
    80206968:	1781                	addi	a5,a5,-32 # ffffffffffffbfe0 <_memory_end+0xffffffff77dfbfe0>
    8020696a:	17c1                	addi	a5,a5,-16
    8020696c:	00878733          	add	a4,a5,s0
    80206970:	fe842783          	lw	a5,-24(s0)
    80206974:	97ba                	add	a5,a5,a4
    80206976:	fcf43c23          	sd	a5,-40(s0)
    8020697a:	a031                	j	80206986 <script_run+0x134>
    8020697c:	fd843783          	ld	a5,-40(s0)
    80206980:	0785                	addi	a5,a5,1
    80206982:	fcf43c23          	sd	a5,-40(s0)
    80206986:	fd843783          	ld	a5,-40(s0)
    8020698a:	0007c783          	lbu	a5,0(a5)
    8020698e:	873e                	mv	a4,a5
    80206990:	02000793          	li	a5,32
    80206994:	fef704e3          	beq	a4,a5,8020697c <script_run+0x12a>
    80206998:	fd843783          	ld	a5,-40(s0)
    8020699c:	0007c783          	lbu	a5,0(a5)
    802069a0:	873e                	mv	a4,a5
    802069a2:	47a5                	li	a5,9
    802069a4:	fcf70ce3          	beq	a4,a5,8020697c <script_run+0x12a>
    802069a8:	fd843783          	ld	a5,-40(s0)
    802069ac:	0007c783          	lbu	a5,0(a5)
    802069b0:	cb91                	beqz	a5,802069c4 <script_run+0x172>
    802069b2:	fd843783          	ld	a5,-40(s0)
    802069b6:	0007c783          	lbu	a5,0(a5)
    802069ba:	873e                	mv	a4,a5
    802069bc:	02300793          	li	a5,35
    802069c0:	00f71863          	bne	a4,a5,802069d0 <script_run+0x17e>
    802069c4:	fec42783          	lw	a5,-20(s0)
    802069c8:	2785                	addiw	a5,a5,1
    802069ca:	fef42423          	sw	a5,-24(s0)
    802069ce:	a071                	j	80206a5a <script_run+0x208>
    802069d0:	fd843783          	ld	a5,-40(s0)
    802069d4:	0007c783          	lbu	a5,0(a5)
    802069d8:	873e                	mv	a4,a5
    802069da:	02300793          	li	a5,35
    802069de:	02f70563          	beq	a4,a5,80206a08 <script_run+0x1b6>
    802069e2:	fd843783          	ld	a5,-40(s0)
    802069e6:	0007c783          	lbu	a5,0(a5)
    802069ea:	873e                	mv	a4,a5
    802069ec:	02f00793          	li	a5,47
    802069f0:	02f71263          	bne	a4,a5,80206a14 <script_run+0x1c2>
    802069f4:	fd843783          	ld	a5,-40(s0)
    802069f8:	0785                	addi	a5,a5,1
    802069fa:	0007c783          	lbu	a5,0(a5)
    802069fe:	873e                	mv	a4,a5
    80206a00:	02f00793          	li	a5,47
    80206a04:	00f71863          	bne	a4,a5,80206a14 <script_run+0x1c2>
    80206a08:	fec42783          	lw	a5,-20(s0)
    80206a0c:	2785                	addiw	a5,a5,1
    80206a0e:	fef42423          	sw	a5,-24(s0)
    80206a12:	a0a1                	j	80206a5a <script_run+0x208>
    80206a14:	00007597          	auipc	a1,0x7
    80206a18:	52c58593          	addi	a1,a1,1324 # 8020df40 <home_bin_spin.0+0x1f40>
    80206a1c:	fd843503          	ld	a0,-40(s0)
    80206a20:	d7fff0ef          	jal	8020679e <line_eq>
    80206a24:	87aa                	mv	a5,a0
    80206a26:	cb81                	beqz	a5,80206a36 <script_run+0x1e4>
    80206a28:	fd843783          	ld	a5,-40(s0)
    80206a2c:	0791                	addi	a5,a5,4
    80206a2e:	853e                	mv	a0,a5
    80206a30:	df3ff0ef          	jal	80206822 <run_echo>
    80206a34:	a821                	j	80206a4c <script_run+0x1fa>
    80206a36:	fd843583          	ld	a1,-40(s0)
    80206a3a:	00007517          	auipc	a0,0x7
    80206a3e:	50e50513          	addi	a0,a0,1294 # 8020df48 <home_bin_spin.0+0x1f48>
    80206a42:	9f5fa0ef          	jal	80201436 <printf>
    80206a46:	57fd                	li	a5,-1
    80206a48:	fef42223          	sw	a5,-28(s0)
    80206a4c:	fec42783          	lw	a5,-20(s0)
    80206a50:	2785                	addiw	a5,a5,1
    80206a52:	fef42423          	sw	a5,-24(s0)
    80206a56:	a011                	j	80206a5a <script_run+0x208>
    80206a58:	0001                	nop
    80206a5a:	fec42783          	lw	a5,-20(s0)
    80206a5e:	2785                	addiw	a5,a5,1
    80206a60:	fef42623          	sw	a5,-20(s0)
    80206a64:	fec42783          	lw	a5,-20(s0)
    80206a68:	873e                	mv	a4,a5
    80206a6a:	fd042783          	lw	a5,-48(s0)
    80206a6e:	2701                	sext.w	a4,a4
    80206a70:	2781                	sext.w	a5,a5
    80206a72:	eae7dbe3          	bge	a5,a4,80206928 <script_run+0xd6>
    80206a76:	77f1                	lui	a5,0xffffc
    80206a78:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206a7a:	97a2                	add	a5,a5,s0
    80206a7c:	fd87b583          	ld	a1,-40(a5)
    80206a80:	00007517          	auipc	a0,0x7
    80206a84:	4e050513          	addi	a0,a0,1248 # 8020df60 <home_bin_spin.0+0x1f60>
    80206a88:	9affa0ef          	jal	80201436 <printf>
    80206a8c:	fe442783          	lw	a5,-28(s0)
    80206a90:	853e                	mv	a0,a5
    80206a92:	6291                	lui	t0,0x4
    80206a94:	9116                	add	sp,sp,t0
    80206a96:	70e2                	ld	ra,56(sp)
    80206a98:	7442                	ld	s0,48(sp)
    80206a9a:	6121                	addi	sp,sp,64
    80206a9c:	8082                	ret

0000000080206a9e <str_eq>:
    80206a9e:	1101                	addi	sp,sp,-32
    80206aa0:	ec06                	sd	ra,24(sp)
    80206aa2:	e822                	sd	s0,16(sp)
    80206aa4:	1000                	addi	s0,sp,32
    80206aa6:	fea43423          	sd	a0,-24(s0)
    80206aaa:	feb43023          	sd	a1,-32(s0)
    80206aae:	a03d                	j	80206adc <str_eq+0x3e>
    80206ab0:	fe843783          	ld	a5,-24(s0)
    80206ab4:	0007c703          	lbu	a4,0(a5)
    80206ab8:	fe043783          	ld	a5,-32(s0)
    80206abc:	0007c783          	lbu	a5,0(a5)
    80206ac0:	00f70463          	beq	a4,a5,80206ac8 <str_eq+0x2a>
    80206ac4:	4781                	li	a5,0
    80206ac6:	a0b1                	j	80206b12 <str_eq+0x74>
    80206ac8:	fe843783          	ld	a5,-24(s0)
    80206acc:	0785                	addi	a5,a5,1
    80206ace:	fef43423          	sd	a5,-24(s0)
    80206ad2:	fe043783          	ld	a5,-32(s0)
    80206ad6:	0785                	addi	a5,a5,1
    80206ad8:	fef43023          	sd	a5,-32(s0)
    80206adc:	fe843783          	ld	a5,-24(s0)
    80206ae0:	0007c783          	lbu	a5,0(a5)
    80206ae4:	c791                	beqz	a5,80206af0 <str_eq+0x52>
    80206ae6:	fe043783          	ld	a5,-32(s0)
    80206aea:	0007c783          	lbu	a5,0(a5)
    80206aee:	f3e9                	bnez	a5,80206ab0 <str_eq+0x12>
    80206af0:	fe843783          	ld	a5,-24(s0)
    80206af4:	0007c703          	lbu	a4,0(a5)
    80206af8:	fe043783          	ld	a5,-32(s0)
    80206afc:	0007c783          	lbu	a5,0(a5)
    80206b00:	2701                	sext.w	a4,a4
    80206b02:	2781                	sext.w	a5,a5
    80206b04:	40f707b3          	sub	a5,a4,a5
    80206b08:	0017b793          	seqz	a5,a5
    80206b0c:	0ff7f793          	zext.b	a5,a5
    80206b10:	2781                	sext.w	a5,a5
    80206b12:	853e                	mv	a0,a5
    80206b14:	60e2                	ld	ra,24(sp)
    80206b16:	6442                	ld	s0,16(sp)
    80206b18:	6105                	addi	sp,sp,32
    80206b1a:	8082                	ret

0000000080206b1c <trim_eol>:
    80206b1c:	7179                	addi	sp,sp,-48
    80206b1e:	f406                	sd	ra,40(sp)
    80206b20:	f022                	sd	s0,32(sp)
    80206b22:	1800                	addi	s0,sp,48
    80206b24:	fca43c23          	sd	a0,-40(s0)
    80206b28:	fe042623          	sw	zero,-20(s0)
    80206b2c:	a031                	j	80206b38 <trim_eol+0x1c>
    80206b2e:	fec42783          	lw	a5,-20(s0)
    80206b32:	2785                	addiw	a5,a5,1
    80206b34:	fef42623          	sw	a5,-20(s0)
    80206b38:	fec42783          	lw	a5,-20(s0)
    80206b3c:	fd843703          	ld	a4,-40(s0)
    80206b40:	97ba                	add	a5,a5,a4
    80206b42:	0007c783          	lbu	a5,0(a5)
    80206b46:	f7e5                	bnez	a5,80206b2e <trim_eol+0x12>
    80206b48:	a829                	j	80206b62 <trim_eol+0x46>
    80206b4a:	fec42783          	lw	a5,-20(s0)
    80206b4e:	37fd                	addiw	a5,a5,-1
    80206b50:	fef42623          	sw	a5,-20(s0)
    80206b54:	fec42783          	lw	a5,-20(s0)
    80206b58:	fd843703          	ld	a4,-40(s0)
    80206b5c:	97ba                	add	a5,a5,a4
    80206b5e:	00078023          	sb	zero,0(a5)
    80206b62:	fec42783          	lw	a5,-20(s0)
    80206b66:	2781                	sext.w	a5,a5
    80206b68:	02f05a63          	blez	a5,80206b9c <trim_eol+0x80>
    80206b6c:	fec42783          	lw	a5,-20(s0)
    80206b70:	17fd                	addi	a5,a5,-1
    80206b72:	fd843703          	ld	a4,-40(s0)
    80206b76:	97ba                	add	a5,a5,a4
    80206b78:	0007c783          	lbu	a5,0(a5)
    80206b7c:	873e                	mv	a4,a5
    80206b7e:	47a9                	li	a5,10
    80206b80:	fcf705e3          	beq	a4,a5,80206b4a <trim_eol+0x2e>
    80206b84:	fec42783          	lw	a5,-20(s0)
    80206b88:	17fd                	addi	a5,a5,-1
    80206b8a:	fd843703          	ld	a4,-40(s0)
    80206b8e:	97ba                	add	a5,a5,a4
    80206b90:	0007c783          	lbu	a5,0(a5)
    80206b94:	873e                	mv	a4,a5
    80206b96:	47b5                	li	a5,13
    80206b98:	faf709e3          	beq	a4,a5,80206b4a <trim_eol+0x2e>
    80206b9c:	0001                	nop
    80206b9e:	70a2                	ld	ra,40(sp)
    80206ba0:	7402                	ld	s0,32(sp)
    80206ba2:	6145                	addi	sp,sp,48
    80206ba4:	8082                	ret

0000000080206ba6 <vi_edit>:
    80206ba6:	7171                	addi	sp,sp,-176
    80206ba8:	f506                	sd	ra,168(sp)
    80206baa:	f122                	sd	s0,160(sp)
    80206bac:	1900                	addi	s0,sp,176
    80206bae:	72f1                	lui	t0,0xffffc
    80206bb0:	9116                	add	sp,sp,t0
    80206bb2:	77f1                	lui	a5,0xffffc
    80206bb4:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206bb6:	97a2                	add	a5,a5,s0
    80206bb8:	f6a7b423          	sd	a0,-152(a5)
    80206bbc:	fe042623          	sw	zero,-20(s0)
    80206bc0:	77f1                	lui	a5,0xffffc
    80206bc2:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    80206bc4:	17c1                	addi	a5,a5,-16
    80206bc6:	008786b3          	add	a3,a5,s0
    80206bca:	77f1                	lui	a5,0xffffc
    80206bcc:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206bce:	97a2                	add	a5,a5,s0
    80206bd0:	6711                	lui	a4,0x4
    80206bd2:	fff70613          	addi	a2,a4,-1 # 3fff <STACK_SIZE+0x2fff>
    80206bd6:	85b6                	mv	a1,a3
    80206bd8:	f687b503          	ld	a0,-152(a5)
    80206bdc:	f56fe0ef          	jal	80205332 <fs_read_file>
    80206be0:	87aa                	mv	a5,a0
    80206be2:	fef42623          	sw	a5,-20(s0)
    80206be6:	fec42783          	lw	a5,-20(s0)
    80206bea:	2781                	sext.w	a5,a5
    80206bec:	0007d463          	bgez	a5,80206bf4 <vi_edit+0x4e>
    80206bf0:	fe042623          	sw	zero,-20(s0)
    80206bf4:	77f1                	lui	a5,0xffffc
    80206bf6:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206bf8:	00878733          	add	a4,a5,s0
    80206bfc:	fec42783          	lw	a5,-20(s0)
    80206c00:	97ba                	add	a5,a5,a4
    80206c02:	fe078c23          	sb	zero,-8(a5)
    80206c06:	00007517          	auipc	a0,0x7
    80206c0a:	37250513          	addi	a0,a0,882 # 8020df78 <home_bin_spin.0+0x1f78>
    80206c0e:	e37f90ef          	jal	80200a44 <uart_puts>
    80206c12:	77f1                	lui	a5,0xffffc
    80206c14:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206c16:	97a2                	add	a5,a5,s0
    80206c18:	f687b503          	ld	a0,-152(a5)
    80206c1c:	e29f90ef          	jal	80200a44 <uart_puts>
    80206c20:	00007517          	auipc	a0,0x7
    80206c24:	36050513          	addi	a0,a0,864 # 8020df80 <home_bin_spin.0+0x1f80>
    80206c28:	e1df90ef          	jal	80200a44 <uart_puts>
    80206c2c:	fec42783          	lw	a5,-20(s0)
    80206c30:	2781                	sext.w	a5,a5
    80206c32:	04f05b63          	blez	a5,80206c88 <vi_edit+0xe2>
    80206c36:	00007517          	auipc	a0,0x7
    80206c3a:	35250513          	addi	a0,a0,850 # 8020df88 <home_bin_spin.0+0x1f88>
    80206c3e:	e07f90ef          	jal	80200a44 <uart_puts>
    80206c42:	77f1                	lui	a5,0xffffc
    80206c44:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    80206c46:	17c1                	addi	a5,a5,-16
    80206c48:	97a2                	add	a5,a5,s0
    80206c4a:	853e                	mv	a0,a5
    80206c4c:	df9f90ef          	jal	80200a44 <uart_puts>
    80206c50:	fec42783          	lw	a5,-20(s0)
    80206c54:	2781                	sext.w	a5,a5
    80206c56:	cf99                	beqz	a5,80206c74 <vi_edit+0xce>
    80206c58:	fec42783          	lw	a5,-20(s0)
    80206c5c:	37fd                	addiw	a5,a5,-1
    80206c5e:	2781                	sext.w	a5,a5
    80206c60:	7771                	lui	a4,0xffffc
    80206c62:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206c64:	9722                	add	a4,a4,s0
    80206c66:	97ba                	add	a5,a5,a4
    80206c68:	ff87c783          	lbu	a5,-8(a5)
    80206c6c:	873e                	mv	a4,a5
    80206c6e:	47a9                	li	a5,10
    80206c70:	00f70563          	beq	a4,a5,80206c7a <vi_edit+0xd4>
    80206c74:	4529                	li	a0,10
    80206c76:	d91f90ef          	jal	80200a06 <uart_putc>
    80206c7a:	00007517          	auipc	a0,0x7
    80206c7e:	32650513          	addi	a0,a0,806 # 8020dfa0 <home_bin_spin.0+0x1fa0>
    80206c82:	dc3f90ef          	jal	80200a44 <uart_puts>
    80206c86:	a039                	j	80206c94 <vi_edit+0xee>
    80206c88:	00007517          	auipc	a0,0x7
    80206c8c:	32850513          	addi	a0,a0,808 # 8020dfb0 <home_bin_spin.0+0x1fb0>
    80206c90:	db5f90ef          	jal	80200a44 <uart_puts>
    80206c94:	00007517          	auipc	a0,0x7
    80206c98:	32c50513          	addi	a0,a0,812 # 8020dfc0 <home_bin_spin.0+0x1fc0>
    80206c9c:	da9f90ef          	jal	80200a44 <uart_puts>
    80206ca0:	00007517          	auipc	a0,0x7
    80206ca4:	34050513          	addi	a0,a0,832 # 8020dfe0 <home_bin_spin.0+0x1fe0>
    80206ca8:	d9df90ef          	jal	80200a44 <uart_puts>
    80206cac:	fe042623          	sw	zero,-20(s0)
    80206cb0:	77f1                	lui	a5,0xffffc
    80206cb2:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206cb4:	97a2                	add	a5,a5,s0
    80206cb6:	fe078c23          	sb	zero,-8(a5)
    80206cba:	77f1                	lui	a5,0xffffc
    80206cbc:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80206cc0:	17c1                	addi	a5,a5,-16
    80206cc2:	97a2                	add	a5,a5,s0
    80206cc4:	08000613          	li	a2,128
    80206cc8:	85be                	mv	a1,a5
    80206cca:	00007517          	auipc	a0,0x7
    80206cce:	35e50513          	addi	a0,a0,862 # 8020e028 <home_bin_spin.0+0x2028>
    80206cd2:	856fa0ef          	jal	80200d28 <uart_prompt_and_read_line>
    80206cd6:	87aa                	mv	a5,a0
    80206cd8:	0c07ce63          	bltz	a5,80206db4 <vi_edit+0x20e>
    80206cdc:	77f1                	lui	a5,0xffffc
    80206cde:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80206ce2:	17c1                	addi	a5,a5,-16
    80206ce4:	97a2                	add	a5,a5,s0
    80206ce6:	853e                	mv	a0,a5
    80206ce8:	e35ff0ef          	jal	80206b1c <trim_eol>
    80206cec:	77f1                	lui	a5,0xffffc
    80206cee:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80206cf2:	17c1                	addi	a5,a5,-16
    80206cf4:	97a2                	add	a5,a5,s0
    80206cf6:	00007597          	auipc	a1,0x7
    80206cfa:	33a58593          	addi	a1,a1,826 # 8020e030 <home_bin_spin.0+0x2030>
    80206cfe:	853e                	mv	a0,a5
    80206d00:	d9fff0ef          	jal	80206a9e <str_eq>
    80206d04:	87aa                	mv	a5,a0
    80206d06:	c399                	beqz	a5,80206d0c <vi_edit+0x166>
    80206d08:	57fd                	li	a5,-1
    80206d0a:	a8d5                	j	80206dfe <vi_edit+0x258>
    80206d0c:	77f1                	lui	a5,0xffffc
    80206d0e:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80206d12:	17c1                	addi	a5,a5,-16
    80206d14:	97a2                	add	a5,a5,s0
    80206d16:	00007597          	auipc	a1,0x7
    80206d1a:	32258593          	addi	a1,a1,802 # 8020e038 <home_bin_spin.0+0x2038>
    80206d1e:	853e                	mv	a0,a5
    80206d20:	d7fff0ef          	jal	80206a9e <str_eq>
    80206d24:	87aa                	mv	a5,a0
    80206d26:	ebc9                	bnez	a5,80206db8 <vi_edit+0x212>
    80206d28:	fe042423          	sw	zero,-24(s0)
    80206d2c:	a81d                	j	80206d62 <vi_edit+0x1bc>
    80206d2e:	fec42783          	lw	a5,-20(s0)
    80206d32:	0017871b          	addiw	a4,a5,1
    80206d36:	fee42623          	sw	a4,-20(s0)
    80206d3a:	7771                	lui	a4,0xffffc
    80206d3c:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206d3e:	008706b3          	add	a3,a4,s0
    80206d42:	fe842703          	lw	a4,-24(s0)
    80206d46:	9736                	add	a4,a4,a3
    80206d48:	f7874703          	lbu	a4,-136(a4)
    80206d4c:	76f1                	lui	a3,0xffffc
    80206d4e:	16c1                	addi	a3,a3,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206d50:	96a2                	add	a3,a3,s0
    80206d52:	97b6                	add	a5,a5,a3
    80206d54:	fee78c23          	sb	a4,-8(a5)
    80206d58:	fe842783          	lw	a5,-24(s0)
    80206d5c:	2785                	addiw	a5,a5,1
    80206d5e:	fef42423          	sw	a5,-24(s0)
    80206d62:	77f1                	lui	a5,0xffffc
    80206d64:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206d66:	00878733          	add	a4,a5,s0
    80206d6a:	fe842783          	lw	a5,-24(s0)
    80206d6e:	97ba                	add	a5,a5,a4
    80206d70:	f787c783          	lbu	a5,-136(a5)
    80206d74:	cb89                	beqz	a5,80206d86 <vi_edit+0x1e0>
    80206d76:	fec42783          	lw	a5,-20(s0)
    80206d7a:	0007871b          	sext.w	a4,a5
    80206d7e:	6791                	lui	a5,0x4
    80206d80:	17f5                	addi	a5,a5,-3 # 3ffd <STACK_SIZE+0x2ffd>
    80206d82:	fae7d6e3          	bge	a5,a4,80206d2e <vi_edit+0x188>
    80206d86:	fec42783          	lw	a5,-20(s0)
    80206d8a:	0017871b          	addiw	a4,a5,1
    80206d8e:	fee42623          	sw	a4,-20(s0)
    80206d92:	7771                	lui	a4,0xffffc
    80206d94:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206d96:	9722                	add	a4,a4,s0
    80206d98:	97ba                	add	a5,a5,a4
    80206d9a:	4729                	li	a4,10
    80206d9c:	fee78c23          	sb	a4,-8(a5)
    80206da0:	77f1                	lui	a5,0xffffc
    80206da2:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206da4:	00878733          	add	a4,a5,s0
    80206da8:	fec42783          	lw	a5,-20(s0)
    80206dac:	97ba                	add	a5,a5,a4
    80206dae:	fe078c23          	sb	zero,-8(a5)
    80206db2:	b721                	j	80206cba <vi_edit+0x114>
    80206db4:	0001                	nop
    80206db6:	b711                	j	80206cba <vi_edit+0x114>
    80206db8:	0001                	nop
    80206dba:	fec42603          	lw	a2,-20(s0)
    80206dbe:	77f1                	lui	a5,0xffffc
    80206dc0:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    80206dc2:	17c1                	addi	a5,a5,-16
    80206dc4:	00878733          	add	a4,a5,s0
    80206dc8:	77f1                	lui	a5,0xffffc
    80206dca:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80206dcc:	97a2                	add	a5,a5,s0
    80206dce:	4685                	li	a3,1
    80206dd0:	85ba                	mv	a1,a4
    80206dd2:	f687b503          	ld	a0,-152(a5)
    80206dd6:	dc2fe0ef          	jal	80205398 <fs_write_file>
    80206dda:	87aa                	mv	a5,a0
    80206ddc:	0007da63          	bgez	a5,80206df0 <vi_edit+0x24a>
    80206de0:	00007517          	auipc	a0,0x7
    80206de4:	26050513          	addi	a0,a0,608 # 8020e040 <home_bin_spin.0+0x2040>
    80206de8:	c5df90ef          	jal	80200a44 <uart_puts>
    80206dec:	57fd                	li	a5,-1
    80206dee:	a801                	j	80206dfe <vi_edit+0x258>
    80206df0:	00007517          	auipc	a0,0x7
    80206df4:	26850513          	addi	a0,a0,616 # 8020e058 <home_bin_spin.0+0x2058>
    80206df8:	c4df90ef          	jal	80200a44 <uart_puts>
    80206dfc:	4781                	li	a5,0
    80206dfe:	853e                	mv	a0,a5
    80206e00:	6291                	lui	t0,0x4
    80206e02:	9116                	add	sp,sp,t0
    80206e04:	70aa                	ld	ra,168(sp)
    80206e06:	740a                	ld	s0,160(sp)
    80206e08:	614d                	addi	sp,sp,176
    80206e0a:	8082                	ret

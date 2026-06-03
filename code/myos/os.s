
out/os:     file format elf64-littleriscv


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
    80200020:	0011a317          	auipc	t1,0x11a
    80200024:	a1830313          	addi	t1,t1,-1512 # 80319a38 <_bss_end>
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
    8020004e:	58c0006f          	j	802005da <start_kernel>

0000000080200052 <park>:
    80200052:	10500073          	wfi
    80200056:	bff5                	j	80200052 <park>

0000000080200058 <trap_vector>:
    80200058:	140f9ff3          	csrrw	t6,sscratch,t6
    8020005c:	14002e73          	csrr	t3,sscratch
    80200060:	0000fe97          	auipc	t4,0xf
    80200064:	034e8e93          	addi	t4,t4,52 # 8020f094 <kernel_trap_busy>
    80200068:	000ea383          	lw	t2,0(t4)
    8020006c:	02038a63          	beqz	t2,802000a0 <trap_vector+0x48>
    80200070:	142022f3          	csrr	t0,scause
    80200074:	0202d663          	bgez	t0,802000a0 <trap_vector+0x48>
    80200078:	7ff2f293          	andi	t0,t0,2047
    8020007c:	00500393          	li	t2,5
    80200080:	02729063          	bne	t0,t2,802000a0 <trap_vector+0x48>
    80200084:	ff010113          	addi	sp,sp,-16
    80200088:	00113023          	sd	ra,0(sp)
    8020008c:	176020ef          	jal	80202202 <trap_nested_timer_ack>
    80200090:	00013083          	ld	ra,0(sp)
    80200094:	01010113          	addi	sp,sp,16
    80200098:	140f9ff3          	csrrw	t6,sscratch,t6
    8020009c:	10200073          	sret
    802000a0:	0000f297          	auipc	t0,0xf
    802000a4:	51028293          	addi	t0,t0,1296 # 8020f5b0 <kernel_trap_cxt>
    802000a8:	14029073          	csrw	sscratch,t0
    802000ac:	14102ef3          	csrr	t4,sepc
    802000b0:	00008297          	auipc	t0,0x8
    802000b4:	91828293          	addi	t0,t0,-1768 # 802079c8 <user_code_start>
    802000b8:	0002b283          	ld	t0,0(t0)
    802000bc:	025ee663          	bltu	t4,t0,802000e8 <trap_vector+0x90>
    802000c0:	00008297          	auipc	t0,0x8
    802000c4:	91028293          	addi	t0,t0,-1776 # 802079d0 <user_code_end>
    802000c8:	0002b283          	ld	t0,0(t0)
    802000cc:	005efe63          	bgeu	t4,t0,802000e8 <trap_vector+0x90>
    802000d0:	0000f297          	auipc	t0,0xf
    802000d4:	fd028293          	addi	t0,t0,-48 # 8020f0a0 <user_trap_save_cxt>
    802000d8:	0002bf83          	ld	t6,0(t0)
    802000dc:	000f9663          	bnez	t6,802000e8 <trap_vector+0x90>
    802000e0:	0000ff97          	auipc	t6,0xf
    802000e4:	4d0f8f93          	addi	t6,t6,1232 # 8020f5b0 <kernel_trap_cxt>
    802000e8:	001fb023          	sd	ra,0(t6)
    802000ec:	002fb423          	sd	sp,8(t6)
    802000f0:	003fb823          	sd	gp,16(t6)
    802000f4:	004fbc23          	sd	tp,24(t6)
    802000f8:	025fb023          	sd	t0,32(t6)
    802000fc:	026fb423          	sd	t1,40(t6)
    80200100:	027fb823          	sd	t2,48(t6)
    80200104:	028fbc23          	sd	s0,56(t6)
    80200108:	049fb023          	sd	s1,64(t6)
    8020010c:	04afb423          	sd	a0,72(t6)
    80200110:	04bfb823          	sd	a1,80(t6)
    80200114:	04cfbc23          	sd	a2,88(t6)
    80200118:	06dfb023          	sd	a3,96(t6)
    8020011c:	06efb423          	sd	a4,104(t6)
    80200120:	06ffb823          	sd	a5,112(t6)
    80200124:	070fbc23          	sd	a6,120(t6)
    80200128:	091fb023          	sd	a7,128(t6)
    8020012c:	092fb423          	sd	s2,136(t6)
    80200130:	093fb823          	sd	s3,144(t6)
    80200134:	094fbc23          	sd	s4,152(t6)
    80200138:	0b5fb023          	sd	s5,160(t6)
    8020013c:	0b6fb423          	sd	s6,168(t6)
    80200140:	0b7fb823          	sd	s7,176(t6)
    80200144:	0b8fbc23          	sd	s8,184(t6)
    80200148:	0d9fb023          	sd	s9,192(t6)
    8020014c:	0dafb423          	sd	s10,200(t6)
    80200150:	0dbfb823          	sd	s11,208(t6)
    80200154:	0dcfbc23          	sd	t3,216(t6)
    80200158:	0fdfb023          	sd	t4,224(t6)
    8020015c:	0fefb423          	sd	t5,232(t6)
    80200160:	000f8f13          	mv	t5,t6
    80200164:	0fcf3823          	sd	t3,240(t5)
    80200168:	14102573          	csrr	a0,sepc
    8020016c:	0eaf3c23          	sd	a0,248(t5)
    80200170:	14102573          	csrr	a0,sepc
    80200174:	142025f3          	csrr	a1,scause
    80200178:	000f0613          	mv	a2,t5
    8020017c:	14102ef3          	csrr	t4,sepc
    80200180:	00008297          	auipc	t0,0x8
    80200184:	84828293          	addi	t0,t0,-1976 # 802079c8 <user_code_start>
    80200188:	0002b283          	ld	t0,0(t0)
    8020018c:	025ee063          	bltu	t4,t0,802001ac <trap_vector+0x154>
    80200190:	00008297          	auipc	t0,0x8
    80200194:	84028293          	addi	t0,t0,-1984 # 802079d0 <user_code_end>
    80200198:	0002b283          	ld	t0,0(t0)
    8020019c:	005ef863          	bgeu	t4,t0,802001ac <trap_vector+0x154>
    802001a0:	00008e17          	auipc	t3,0x8
    802001a4:	820e0e13          	addi	t3,t3,-2016 # 802079c0 <kernel_trap_sp>
    802001a8:	000e3103          	ld	sp,0(t3)
    802001ac:	ff010113          	addi	sp,sp,-16
    802001b0:	00113023          	sd	ra,0(sp)
    802001b4:	01e13423          	sd	t5,8(sp)
    802001b8:	0000fe97          	auipc	t4,0xf
    802001bc:	edce8e93          	addi	t4,t4,-292 # 8020f094 <kernel_trap_busy>
    802001c0:	00100393          	li	t2,1
    802001c4:	007ea023          	sw	t2,0(t4)
    802001c8:	0b0020ef          	jal	80202278 <trap_handler>
    802001cc:	0000fe97          	auipc	t4,0xf
    802001d0:	ec8e8e93          	addi	t4,t4,-312 # 8020f094 <kernel_trap_busy>
    802001d4:	000ea023          	sw	zero,0(t4)
    802001d8:	00813f03          	ld	t5,8(sp)
    802001dc:	00013083          	ld	ra,0(sp)
    802001e0:	01010113          	addi	sp,sp,16
    802001e4:	14151073          	csrw	sepc,a0
    802001e8:	ff010113          	addi	sp,sp,-16
    802001ec:	00113023          	sd	ra,0(sp)
    802001f0:	00a13423          	sd	a0,8(sp)
    802001f4:	460020ef          	jal	80202654 <trap_diag_post_handler>
    802001f8:	00813503          	ld	a0,8(sp)
    802001fc:	00013083          	ld	ra,0(sp)
    80200200:	01010113          	addi	sp,sp,16
    80200204:	0000fe97          	auipc	t4,0xf
    80200208:	ea4e8e93          	addi	t4,t4,-348 # 8020f0a8 <proc_user_exit_pending>
    8020020c:	000eae83          	lw	t4,0(t4)
    80200210:	020e8863          	beqz	t4,80200240 <trap_vector+0x1e8>
    80200214:	ff010113          	addi	sp,sp,-16
    80200218:	00113023          	sd	ra,0(sp)
    8020021c:	578020ef          	jal	80202794 <trap_diag_user_exit_branch>
    80200220:	00013083          	ld	ra,0(sp)
    80200224:	01010113          	addi	sp,sp,16
    80200228:	0000f297          	auipc	t0,0xf
    8020022c:	e7828293          	addi	t0,t0,-392 # 8020f0a0 <user_trap_save_cxt>
    80200230:	0002bf83          	ld	t6,0(t0)
    80200234:	10000293          	li	t0,256
    80200238:	1002a073          	csrs	sstatus,t0
    8020023c:	0080006f          	j	80200244 <trap_vector+0x1ec>
    80200240:	000f0f93          	mv	t6,t5
    80200244:	fe010113          	addi	sp,sp,-32
    80200248:	00113023          	sd	ra,0(sp)
    8020024c:	01f13423          	sd	t6,8(sp)
    80200250:	14102573          	csrr	a0,sepc
    80200254:	000f8593          	mv	a1,t6
    80200258:	4ba020ef          	jal	80202712 <trap_diag_trap_return>
    8020025c:	00813f83          	ld	t6,8(sp)
    80200260:	00013083          	ld	ra,0(sp)
    80200264:	02010113          	addi	sp,sp,32
    80200268:	0000f297          	auipc	t0,0xf
    8020026c:	34828293          	addi	t0,t0,840 # 8020f5b0 <kernel_trap_cxt>
    80200270:	14029073          	csrw	sscratch,t0
    80200274:	000fb083          	ld	ra,0(t6)
    80200278:	008fb103          	ld	sp,8(t6)
    8020027c:	010fb183          	ld	gp,16(t6)
    80200280:	018fb203          	ld	tp,24(t6)
    80200284:	020fb283          	ld	t0,32(t6)
    80200288:	028fb303          	ld	t1,40(t6)
    8020028c:	030fb383          	ld	t2,48(t6)
    80200290:	038fb403          	ld	s0,56(t6)
    80200294:	040fb483          	ld	s1,64(t6)
    80200298:	048fb503          	ld	a0,72(t6)
    8020029c:	050fb583          	ld	a1,80(t6)
    802002a0:	058fb603          	ld	a2,88(t6)
    802002a4:	060fb683          	ld	a3,96(t6)
    802002a8:	068fb703          	ld	a4,104(t6)
    802002ac:	070fb783          	ld	a5,112(t6)
    802002b0:	078fb803          	ld	a6,120(t6)
    802002b4:	080fb883          	ld	a7,128(t6)
    802002b8:	088fb903          	ld	s2,136(t6)
    802002bc:	090fb983          	ld	s3,144(t6)
    802002c0:	098fba03          	ld	s4,152(t6)
    802002c4:	0a0fba83          	ld	s5,160(t6)
    802002c8:	0a8fbb03          	ld	s6,168(t6)
    802002cc:	0b0fbb83          	ld	s7,176(t6)
    802002d0:	0b8fbc03          	ld	s8,184(t6)
    802002d4:	0c0fbc83          	ld	s9,192(t6)
    802002d8:	0c8fbd03          	ld	s10,200(t6)
    802002dc:	0d0fbd83          	ld	s11,208(t6)
    802002e0:	0d8fbe03          	ld	t3,216(t6)
    802002e4:	0e0fbe83          	ld	t4,224(t6)
    802002e8:	0e8fbf03          	ld	t5,232(t6)
    802002ec:	0f0fbf83          	ld	t6,240(t6)
    802002f0:	0000fe97          	auipc	t4,0xf
    802002f4:	db8e8e93          	addi	t4,t4,-584 # 8020f0a8 <proc_user_exit_pending>
    802002f8:	000eae83          	lw	t4,0(t4)
    802002fc:	000e8863          	beqz	t4,8020030c <trap_vector+0x2b4>
    80200300:	0000fe97          	auipc	t4,0xf
    80200304:	da8e8e93          	addi	t4,t4,-600 # 8020f0a8 <proc_user_exit_pending>
    80200308:	000ea023          	sw	zero,0(t4)
    8020030c:	0000fe97          	auipc	t4,0xf
    80200310:	d74e8e93          	addi	t4,t4,-652 # 8020f080 <trap_reenable_irq>
    80200314:	000eae83          	lw	t4,0(t4)
    80200318:	000e8863          	beqz	t4,80200328 <trap_vector+0x2d0>
    8020031c:	000ea023          	sw	zero,0(t4)
    80200320:	00200293          	li	t0,2
    80200324:	1002a073          	csrs	sstatus,t0
    80200328:	10200073          	sret

000000008020032c <switch_to>:
    8020032c:	0f853583          	ld	a1,248(a0)
    80200330:	14159073          	csrw	sepc,a1
    80200334:	00050f93          	mv	t6,a0
    80200338:	000fb083          	ld	ra,0(t6)
    8020033c:	008fb103          	ld	sp,8(t6)
    80200340:	010fb183          	ld	gp,16(t6)
    80200344:	018fb203          	ld	tp,24(t6)
    80200348:	020fb283          	ld	t0,32(t6)
    8020034c:	028fb303          	ld	t1,40(t6)
    80200350:	030fb383          	ld	t2,48(t6)
    80200354:	038fb403          	ld	s0,56(t6)
    80200358:	040fb483          	ld	s1,64(t6)
    8020035c:	048fb503          	ld	a0,72(t6)
    80200360:	050fb583          	ld	a1,80(t6)
    80200364:	058fb603          	ld	a2,88(t6)
    80200368:	060fb683          	ld	a3,96(t6)
    8020036c:	068fb703          	ld	a4,104(t6)
    80200370:	070fb783          	ld	a5,112(t6)
    80200374:	078fb803          	ld	a6,120(t6)
    80200378:	080fb883          	ld	a7,128(t6)
    8020037c:	088fb903          	ld	s2,136(t6)
    80200380:	090fb983          	ld	s3,144(t6)
    80200384:	098fba03          	ld	s4,152(t6)
    80200388:	0a0fba83          	ld	s5,160(t6)
    8020038c:	0a8fbb03          	ld	s6,168(t6)
    80200390:	0b0fbb83          	ld	s7,176(t6)
    80200394:	0b8fbc03          	ld	s8,184(t6)
    80200398:	0c0fbc83          	ld	s9,192(t6)
    8020039c:	0c8fbd03          	ld	s10,200(t6)
    802003a0:	0d0fbd83          	ld	s11,208(t6)
    802003a4:	0d8fbe03          	ld	t3,216(t6)
    802003a8:	0e0fbe83          	ld	t4,224(t6)
    802003ac:	0e8fbf03          	ld	t5,232(t6)
    802003b0:	0f0fbf83          	ld	t6,240(t6)
    802003b4:	10000293          	li	t0,256
    802003b8:	1002b073          	csrc	sstatus,t0
    802003bc:	10200073          	sret

00000000802003c0 <gethid>:
    802003c0:	4885                	li	a7,1
    802003c2:	00000073          	ecall
    802003c6:	8082                	ret

00000000802003c8 <write>:
    802003c8:	04000893          	li	a7,64
    802003cc:	00000073          	ecall
    802003d0:	8082                	ret

00000000802003d2 <read>:
    802003d2:	03f00893          	li	a7,63
    802003d6:	00000073          	ecall
    802003da:	8082                	ret

00000000802003dc <exit>:
    802003dc:	05d00893          	li	a7,93
    802003e0:	00000073          	ecall
    802003e4:	8082                	ret

00000000802003e6 <fork>:
    802003e6:	0d600893          	li	a7,214
    802003ea:	00000073          	ecall
    802003ee:	8082                	ret

00000000802003f0 <r_sstatus>:
    802003f0:	1101                	addi	sp,sp,-32
    802003f2:	ec06                	sd	ra,24(sp)
    802003f4:	e822                	sd	s0,16(sp)
    802003f6:	1000                	addi	s0,sp,32
    802003f8:	100027f3          	csrr	a5,sstatus
    802003fc:	fef43423          	sd	a5,-24(s0)
    80200400:	fe843783          	ld	a5,-24(s0)
    80200404:	853e                	mv	a0,a5
    80200406:	60e2                	ld	ra,24(sp)
    80200408:	6442                	ld	s0,16(sp)
    8020040a:	6105                	addi	sp,sp,32
    8020040c:	8082                	ret

000000008020040e <w_sstatus>:
    8020040e:	1101                	addi	sp,sp,-32
    80200410:	ec06                	sd	ra,24(sp)
    80200412:	e822                	sd	s0,16(sp)
    80200414:	1000                	addi	s0,sp,32
    80200416:	fea43423          	sd	a0,-24(s0)
    8020041a:	fe843783          	ld	a5,-24(s0)
    8020041e:	10079073          	csrw	sstatus,a5
    80200422:	0001                	nop
    80200424:	60e2                	ld	ra,24(sp)
    80200426:	6442                	ld	s0,16(sp)
    80200428:	6105                	addi	sp,sp,32
    8020042a:	8082                	ret

000000008020042c <r_stvec>:
    8020042c:	1101                	addi	sp,sp,-32
    8020042e:	ec06                	sd	ra,24(sp)
    80200430:	e822                	sd	s0,16(sp)
    80200432:	1000                	addi	s0,sp,32
    80200434:	105027f3          	csrr	a5,stvec
    80200438:	fef43423          	sd	a5,-24(s0)
    8020043c:	fe843783          	ld	a5,-24(s0)
    80200440:	853e                	mv	a0,a5
    80200442:	60e2                	ld	ra,24(sp)
    80200444:	6442                	ld	s0,16(sp)
    80200446:	6105                	addi	sp,sp,32
    80200448:	8082                	ret

000000008020044a <trap_vec_read>:
    8020044a:	1141                	addi	sp,sp,-16
    8020044c:	e406                	sd	ra,8(sp)
    8020044e:	e022                	sd	s0,0(sp)
    80200450:	0800                	addi	s0,sp,16
    80200452:	fdbff0ef          	jal	8020042c <r_stvec>
    80200456:	87aa                	mv	a5,a0
    80200458:	853e                	mv	a0,a5
    8020045a:	60a2                	ld	ra,8(sp)
    8020045c:	6402                	ld	s0,0(sp)
    8020045e:	0141                	addi	sp,sp,16
    80200460:	8082                	ret

0000000080200462 <cpu_irq_enable>:
    80200462:	1141                	addi	sp,sp,-16
    80200464:	e406                	sd	ra,8(sp)
    80200466:	e022                	sd	s0,0(sp)
    80200468:	0800                	addi	s0,sp,16
    8020046a:	f87ff0ef          	jal	802003f0 <r_sstatus>
    8020046e:	87aa                	mv	a5,a0
    80200470:	0027e793          	ori	a5,a5,2
    80200474:	853e                	mv	a0,a5
    80200476:	f99ff0ef          	jal	8020040e <w_sstatus>
    8020047a:	0001                	nop
    8020047c:	60a2                	ld	ra,8(sp)
    8020047e:	6402                	ld	s0,0(sp)
    80200480:	0141                	addi	sp,sp,16
    80200482:	8082                	ret

0000000080200484 <clear_bss>:
    80200484:	1101                	addi	sp,sp,-32
    80200486:	ec06                	sd	ra,24(sp)
    80200488:	e822                	sd	s0,16(sp)
    8020048a:	1000                	addi	s0,sp,32
    8020048c:	0000f797          	auipc	a5,0xf
    80200490:	be478793          	addi	a5,a5,-1052 # 8020f070 <boot_hartid>
    80200494:	fef43423          	sd	a5,-24(s0)
    80200498:	a811                	j	802004ac <clear_bss+0x28>
    8020049a:	fe843783          	ld	a5,-24(s0)
    8020049e:	00078023          	sb	zero,0(a5)
    802004a2:	fe843783          	ld	a5,-24(s0)
    802004a6:	0785                	addi	a5,a5,1
    802004a8:	fef43423          	sd	a5,-24(s0)
    802004ac:	fe843703          	ld	a4,-24(s0)
    802004b0:	00119797          	auipc	a5,0x119
    802004b4:	58878793          	addi	a5,a5,1416 # 80319a38 <_bss_end>
    802004b8:	fef761e3          	bltu	a4,a5,8020049a <clear_bss+0x16>
    802004bc:	0001                	nop
    802004be:	0001                	nop
    802004c0:	60e2                	ld	ra,24(sp)
    802004c2:	6442                	ld	s0,16(sp)
    802004c4:	6105                	addi	sp,sp,32
    802004c6:	8082                	ret

00000000802004c8 <osviz_log_boot_progress>:
    802004c8:	7135                	addi	sp,sp,-160
    802004ca:	ed06                	sd	ra,152(sp)
    802004cc:	e922                	sd	s0,144(sp)
    802004ce:	1100                	addi	s0,sp,160
    802004d0:	00007797          	auipc	a5,0x7
    802004d4:	4e878793          	addi	a5,a5,1256 # 802079b8 <BSS_END>
    802004d8:	6398                	ld	a4,0(a5)
    802004da:	00007797          	auipc	a5,0x7
    802004de:	4d678793          	addi	a5,a5,1238 # 802079b0 <BSS_START>
    802004e2:	639c                	ld	a5,0(a5)
    802004e4:	40f707b3          	sub	a5,a4,a5
    802004e8:	fef43423          	sd	a5,-24(s0)
    802004ec:	00007617          	auipc	a2,0x7
    802004f0:	4ec60613          	addi	a2,a2,1260 # 802079d8 <user_code_end+0x8>
    802004f4:	00007597          	auipc	a1,0x7
    802004f8:	51c58593          	addi	a1,a1,1308 # 80207a10 <user_code_end+0x40>
    802004fc:	00007517          	auipc	a0,0x7
    80200500:	51c50513          	addi	a0,a0,1308 # 80207a18 <user_code_end+0x48>
    80200504:	378000ef          	jal	8020087c <osviz_event>
    80200508:	0000f797          	auipc	a5,0xf
    8020050c:	b6878793          	addi	a5,a5,-1176 # 8020f070 <boot_hartid>
    80200510:	639c                	ld	a5,0(a5)
    80200512:	0007869b          	sext.w	a3,a5
    80200516:	0000f797          	auipc	a5,0xf
    8020051a:	b6278793          	addi	a5,a5,-1182 # 8020f078 <boot_dtb>
    8020051e:	6398                	ld	a4,0(a5)
    80200520:	f6840793          	addi	a5,s0,-152
    80200524:	00007617          	auipc	a2,0x7
    80200528:	4fc60613          	addi	a2,a2,1276 # 80207a20 <user_code_end+0x50>
    8020052c:	08000593          	li	a1,128
    80200530:	853e                	mv	a0,a5
    80200532:	3dd000ef          	jal	8020110e <snprintf>
    80200536:	f6840793          	addi	a5,s0,-152
    8020053a:	863e                	mv	a2,a5
    8020053c:	00007597          	auipc	a1,0x7
    80200540:	4fc58593          	addi	a1,a1,1276 # 80207a38 <user_code_end+0x68>
    80200544:	00007517          	auipc	a0,0x7
    80200548:	4d450513          	addi	a0,a0,1236 # 80207a18 <user_code_end+0x48>
    8020054c:	330000ef          	jal	8020087c <osviz_event>
    80200550:	00007797          	auipc	a5,0x7
    80200554:	46078793          	addi	a5,a5,1120 # 802079b0 <BSS_START>
    80200558:	6394                	ld	a3,0(a5)
    8020055a:	00007797          	auipc	a5,0x7
    8020055e:	45e78793          	addi	a5,a5,1118 # 802079b8 <BSS_END>
    80200562:	6398                	ld	a4,0(a5)
    80200564:	fe843783          	ld	a5,-24(s0)
    80200568:	2781                	sext.w	a5,a5
    8020056a:	f6840513          	addi	a0,s0,-152
    8020056e:	00007617          	auipc	a2,0x7
    80200572:	4da60613          	addi	a2,a2,1242 # 80207a48 <user_code_end+0x78>
    80200576:	08000593          	li	a1,128
    8020057a:	395000ef          	jal	8020110e <snprintf>
    8020057e:	f6840793          	addi	a5,s0,-152
    80200582:	863e                	mv	a2,a5
    80200584:	00007597          	auipc	a1,0x7
    80200588:	4fc58593          	addi	a1,a1,1276 # 80207a80 <user_code_end+0xb0>
    8020058c:	00007517          	auipc	a0,0x7
    80200590:	48c50513          	addi	a0,a0,1164 # 80207a18 <user_code_end+0x48>
    80200594:	2e8000ef          	jal	8020087c <osviz_event>
    80200598:	00007617          	auipc	a2,0x7
    8020059c:	4f860613          	addi	a2,a2,1272 # 80207a90 <user_code_end+0xc0>
    802005a0:	00007597          	auipc	a1,0x7
    802005a4:	50058593          	addi	a1,a1,1280 # 80207aa0 <user_code_end+0xd0>
    802005a8:	00007517          	auipc	a0,0x7
    802005ac:	47050513          	addi	a0,a0,1136 # 80207a18 <user_code_end+0x48>
    802005b0:	2cc000ef          	jal	8020087c <osviz_event>
    802005b4:	00007617          	auipc	a2,0x7
    802005b8:	4fc60613          	addi	a2,a2,1276 # 80207ab0 <user_code_end+0xe0>
    802005bc:	00007597          	auipc	a1,0x7
    802005c0:	52458593          	addi	a1,a1,1316 # 80207ae0 <user_code_end+0x110>
    802005c4:	00007517          	auipc	a0,0x7
    802005c8:	45450513          	addi	a0,a0,1108 # 80207a18 <user_code_end+0x48>
    802005cc:	2b0000ef          	jal	8020087c <osviz_event>
    802005d0:	0001                	nop
    802005d2:	60ea                	ld	ra,152(sp)
    802005d4:	644a                	ld	s0,144(sp)
    802005d6:	610d                	addi	sp,sp,160
    802005d8:	8082                	ret

00000000802005da <start_kernel>:
    802005da:	715d                	addi	sp,sp,-80
    802005dc:	e486                	sd	ra,72(sp)
    802005de:	e0a2                	sd	s0,64(sp)
    802005e0:	0880                	addi	s0,sp,80
    802005e2:	5f5000ef          	jal	802013d6 <uart_init>
    802005e6:	3c3010ef          	jal	802021a8 <trap_init>
    802005ea:	200000ef          	jal	802007ea <osviz_init>
    802005ee:	40c000ef          	jal	802009fa <osviz_boot_banner>
    802005f2:	ed7ff0ef          	jal	802004c8 <osviz_log_boot_progress>
    802005f6:	4601                	li	a2,0
    802005f8:	00007597          	auipc	a1,0x7
    802005fc:	4f858593          	addi	a1,a1,1272 # 80207af0 <user_code_end+0x120>
    80200600:	00007517          	auipc	a0,0x7
    80200604:	41850513          	addi	a0,a0,1048 # 80207a18 <user_code_end+0x48>
    80200608:	274000ef          	jal	8020087c <osviz_event>
    8020060c:	1a9050ef          	jal	80205fb4 <fs_init>
    80200610:	786020ef          	jal	80202d96 <proc_init>
    80200614:	0de030ef          	jal	802036f2 <proc_user_init>
    80200618:	2ac020ef          	jal	802028c4 <page_init>
    8020061c:	4601                	li	a2,0
    8020061e:	00007597          	auipc	a1,0x7
    80200622:	4e258593          	addi	a1,a1,1250 # 80207b00 <user_code_end+0x130>
    80200626:	00007517          	auipc	a0,0x7
    8020062a:	3f250513          	addi	a0,a0,1010 # 80207a18 <user_code_end+0x48>
    8020062e:	24e000ef          	jal	8020087c <osviz_event>
    80200632:	e19ff0ef          	jal	8020044a <trap_vec_read>
    80200636:	872a                	mv	a4,a0
    80200638:	fb040793          	addi	a5,s0,-80
    8020063c:	86ba                	mv	a3,a4
    8020063e:	00007617          	auipc	a2,0x7
    80200642:	4d260613          	addi	a2,a2,1234 # 80207b10 <user_code_end+0x140>
    80200646:	04000593          	li	a1,64
    8020064a:	853e                	mv	a0,a5
    8020064c:	2c3000ef          	jal	8020110e <snprintf>
    80200650:	fb040793          	addi	a5,s0,-80
    80200654:	863e                	mv	a2,a5
    80200656:	00007597          	auipc	a1,0x7
    8020065a:	4ca58593          	addi	a1,a1,1226 # 80207b20 <user_code_end+0x150>
    8020065e:	00007517          	auipc	a0,0x7
    80200662:	3ba50513          	addi	a0,a0,954 # 80207a18 <user_code_end+0x48>
    80200666:	216000ef          	jal	8020087c <osviz_event>
    8020066a:	316010ef          	jal	80201980 <plic_init>
    8020066e:	4601                	li	a2,0
    80200670:	00007597          	auipc	a1,0x7
    80200674:	4c058593          	addi	a1,a1,1216 # 80207b30 <user_code_end+0x160>
    80200678:	00007517          	auipc	a0,0x7
    8020067c:	3a050513          	addi	a0,a0,928 # 80207a18 <user_code_end+0x48>
    80200680:	1fc000ef          	jal	8020087c <osviz_event>
    80200684:	59b000ef          	jal	8020141e <uart_irq_enable>
    80200688:	4d8010ef          	jal	80201b60 <timer_init>
    8020068c:	00007617          	auipc	a2,0x7
    80200690:	4b460613          	addi	a2,a2,1204 # 80207b40 <user_code_end+0x170>
    80200694:	00007597          	auipc	a1,0x7
    80200698:	4bc58593          	addi	a1,a1,1212 # 80207b50 <user_code_end+0x180>
    8020069c:	00007517          	auipc	a0,0x7
    802006a0:	37c50513          	addi	a0,a0,892 # 80207a18 <user_code_end+0x48>
    802006a4:	1d8000ef          	jal	8020087c <osviz_event>
    802006a8:	38d030ef          	jal	80204234 <sched_init>
    802006ac:	4601                	li	a2,0
    802006ae:	00007597          	auipc	a1,0x7
    802006b2:	4b258593          	addi	a1,a1,1202 # 80207b60 <user_code_end+0x190>
    802006b6:	00007517          	auipc	a0,0x7
    802006ba:	36250513          	addi	a0,a0,866 # 80207a18 <user_code_end+0x48>
    802006be:	1be000ef          	jal	8020087c <osviz_event>
    802006c2:	639060ef          	jal	802074fa <os_main>
    802006c6:	00007617          	auipc	a2,0x7
    802006ca:	4aa60613          	addi	a2,a2,1194 # 80207b70 <user_code_end+0x1a0>
    802006ce:	00007597          	auipc	a1,0x7
    802006d2:	4b258593          	addi	a1,a1,1202 # 80207b80 <user_code_end+0x1b0>
    802006d6:	00007517          	auipc	a0,0x7
    802006da:	34250513          	addi	a0,a0,834 # 80207a18 <user_code_end+0x48>
    802006de:	19e000ef          	jal	8020087c <osviz_event>
    802006e2:	00007617          	auipc	a2,0x7
    802006e6:	4ae60613          	addi	a2,a2,1198 # 80207b90 <user_code_end+0x1c0>
    802006ea:	00007597          	auipc	a1,0x7
    802006ee:	4b658593          	addi	a1,a1,1206 # 80207ba0 <user_code_end+0x1d0>
    802006f2:	00007517          	auipc	a0,0x7
    802006f6:	32650513          	addi	a0,a0,806 # 80207a18 <user_code_end+0x48>
    802006fa:	182000ef          	jal	8020087c <osviz_event>
    802006fe:	d65ff0ef          	jal	80200462 <cpu_irq_enable>
    80200702:	00007517          	auipc	a0,0x7
    80200706:	4ae50513          	addi	a0,a0,1198 # 80207bb0 <user_code_end+0x1e0>
    8020070a:	599000ef          	jal	802014a2 <uart_puts>
    8020070e:	00007517          	auipc	a0,0x7
    80200712:	4b250513          	addi	a0,a0,1202 # 80207bc0 <user_code_end+0x1f0>
    80200716:	58d000ef          	jal	802014a2 <uart_puts>
    8020071a:	691000ef          	jal	802015aa <uart_rx_flush_deep>
    8020071e:	1ff060ef          	jal	8020711c <console_run>
    80200722:	0001                	nop
    80200724:	60a6                	ld	ra,72(sp)
    80200726:	6406                	ld	s0,64(sp)
    80200728:	6161                	addi	sp,sp,80
    8020072a:	8082                	ret

000000008020072c <r_tp>:
    8020072c:	1101                	addi	sp,sp,-32
    8020072e:	ec06                	sd	ra,24(sp)
    80200730:	e822                	sd	s0,16(sp)
    80200732:	1000                	addi	s0,sp,32
    80200734:	8792                	mv	a5,tp
    80200736:	fef43423          	sd	a5,-24(s0)
    8020073a:	fe843783          	ld	a5,-24(s0)
    8020073e:	853e                	mv	a0,a5
    80200740:	60e2                	ld	ra,24(sp)
    80200742:	6442                	ld	s0,16(sp)
    80200744:	6105                	addi	sp,sp,32
    80200746:	8082                	ret

0000000080200748 <r_mhartid>:
    80200748:	1141                	addi	sp,sp,-16
    8020074a:	e406                	sd	ra,8(sp)
    8020074c:	e022                	sd	s0,0(sp)
    8020074e:	0800                	addi	s0,sp,16
    80200750:	fddff0ef          	jal	8020072c <r_tp>
    80200754:	87aa                	mv	a5,a0
    80200756:	853e                	mv	a0,a5
    80200758:	60a2                	ld	ra,8(sp)
    8020075a:	6402                	ld	s0,0(sp)
    8020075c:	0141                	addi	sp,sp,16
    8020075e:	8082                	ret

0000000080200760 <r_sstatus>:
    80200760:	1101                	addi	sp,sp,-32
    80200762:	ec06                	sd	ra,24(sp)
    80200764:	e822                	sd	s0,16(sp)
    80200766:	1000                	addi	s0,sp,32
    80200768:	100027f3          	csrr	a5,sstatus
    8020076c:	fef43423          	sd	a5,-24(s0)
    80200770:	fe843783          	ld	a5,-24(s0)
    80200774:	853e                	mv	a0,a5
    80200776:	60e2                	ld	ra,24(sp)
    80200778:	6442                	ld	s0,16(sp)
    8020077a:	6105                	addi	sp,sp,32
    8020077c:	8082                	ret

000000008020077e <r_stvec>:
    8020077e:	1101                	addi	sp,sp,-32
    80200780:	ec06                	sd	ra,24(sp)
    80200782:	e822                	sd	s0,16(sp)
    80200784:	1000                	addi	s0,sp,32
    80200786:	105027f3          	csrr	a5,stvec
    8020078a:	fef43423          	sd	a5,-24(s0)
    8020078e:	fe843783          	ld	a5,-24(s0)
    80200792:	853e                	mv	a0,a5
    80200794:	60e2                	ld	ra,24(sp)
    80200796:	6442                	ld	s0,16(sp)
    80200798:	6105                	addi	sp,sp,32
    8020079a:	8082                	ret

000000008020079c <r_priv_mode_bits>:
    8020079c:	1141                	addi	sp,sp,-16
    8020079e:	e406                	sd	ra,8(sp)
    802007a0:	e022                	sd	s0,0(sp)
    802007a2:	0800                	addi	s0,sp,16
    802007a4:	fbdff0ef          	jal	80200760 <r_sstatus>
    802007a8:	87aa                	mv	a5,a0
    802007aa:	853e                	mv	a0,a5
    802007ac:	60a2                	ld	ra,8(sp)
    802007ae:	6402                	ld	s0,0(sp)
    802007b0:	0141                	addi	sp,sp,16
    802007b2:	8082                	ret

00000000802007b4 <trap_vec_read>:
    802007b4:	1141                	addi	sp,sp,-16
    802007b6:	e406                	sd	ra,8(sp)
    802007b8:	e022                	sd	s0,0(sp)
    802007ba:	0800                	addi	s0,sp,16
    802007bc:	fc3ff0ef          	jal	8020077e <r_stvec>
    802007c0:	87aa                	mv	a5,a0
    802007c2:	853e                	mv	a0,a5
    802007c4:	60a2                	ld	ra,8(sp)
    802007c6:	6402                	ld	s0,0(sp)
    802007c8:	0141                	addi	sp,sp,16
    802007ca:	8082                	ret

00000000802007cc <r_time>:
    802007cc:	1101                	addi	sp,sp,-32
    802007ce:	ec06                	sd	ra,24(sp)
    802007d0:	e822                	sd	s0,16(sp)
    802007d2:	1000                	addi	s0,sp,32
    802007d4:	c01027f3          	rdtime	a5
    802007d8:	fef43423          	sd	a5,-24(s0)
    802007dc:	fe843783          	ld	a5,-24(s0)
    802007e0:	853e                	mv	a0,a5
    802007e2:	60e2                	ld	ra,24(sp)
    802007e4:	6442                	ld	s0,16(sp)
    802007e6:	6105                	addi	sp,sp,32
    802007e8:	8082                	ret

00000000802007ea <osviz_init>:
    802007ea:	1141                	addi	sp,sp,-16
    802007ec:	e406                	sd	ra,8(sp)
    802007ee:	e022                	sd	s0,0(sp)
    802007f0:	0800                	addi	s0,sp,16
    802007f2:	fdbff0ef          	jal	802007cc <r_time>
    802007f6:	872a                	mv	a4,a0
    802007f8:	0000f797          	auipc	a5,0xf
    802007fc:	8b878793          	addi	a5,a5,-1864 # 8020f0b0 <boot_mtime>
    80200800:	e398                	sd	a4,0(a5)
    80200802:	0001                	nop
    80200804:	60a2                	ld	ra,8(sp)
    80200806:	6402                	ld	s0,0(sp)
    80200808:	0141                	addi	sp,sp,16
    8020080a:	8082                	ret

000000008020080c <osviz_millis>:
    8020080c:	1101                	addi	sp,sp,-32
    8020080e:	ec06                	sd	ra,24(sp)
    80200810:	e822                	sd	s0,16(sp)
    80200812:	1000                	addi	s0,sp,32
    80200814:	fb9ff0ef          	jal	802007cc <r_time>
    80200818:	fea43423          	sd	a0,-24(s0)
    8020081c:	0000f797          	auipc	a5,0xf
    80200820:	89478793          	addi	a5,a5,-1900 # 8020f0b0 <boot_mtime>
    80200824:	639c                	ld	a5,0(a5)
    80200826:	fe843703          	ld	a4,-24(s0)
    8020082a:	00f77463          	bgeu	a4,a5,80200832 <osviz_millis+0x26>
    8020082e:	4781                	li	a5,0
    80200830:	a089                	j	80200872 <osviz_millis+0x66>
    80200832:	fe843783          	ld	a5,-24(s0)
    80200836:	0007871b          	sext.w	a4,a5
    8020083a:	0000f797          	auipc	a5,0xf
    8020083e:	87678793          	addi	a5,a5,-1930 # 8020f0b0 <boot_mtime>
    80200842:	639c                	ld	a5,0(a5)
    80200844:	2781                	sext.w	a5,a5
    80200846:	40f707bb          	subw	a5,a4,a5
    8020084a:	fef42223          	sw	a5,-28(s0)
    8020084e:	fe442783          	lw	a5,-28(s0)
    80200852:	02079713          	slli	a4,a5,0x20
    80200856:	9301                	srli	a4,a4,0x20
    80200858:	00007797          	auipc	a5,0x7
    8020085c:	5d878793          	addi	a5,a5,1496 # 80207e30 <user_code_end+0x460>
    80200860:	639c                	ld	a5,0(a5)
    80200862:	02f707b3          	mul	a5,a4,a5
    80200866:	9381                	srli	a5,a5,0x20
    80200868:	00d7d79b          	srliw	a5,a5,0xd
    8020086c:	2781                	sext.w	a5,a5
    8020086e:	1782                	slli	a5,a5,0x20
    80200870:	9381                	srli	a5,a5,0x20
    80200872:	853e                	mv	a0,a5
    80200874:	60e2                	ld	ra,24(sp)
    80200876:	6442                	ld	s0,16(sp)
    80200878:	6105                	addi	sp,sp,32
    8020087a:	8082                	ret

000000008020087c <osviz_event>:
    8020087c:	7139                	addi	sp,sp,-64
    8020087e:	fc06                	sd	ra,56(sp)
    80200880:	f822                	sd	s0,48(sp)
    80200882:	0080                	addi	s0,sp,64
    80200884:	fca43c23          	sd	a0,-40(s0)
    80200888:	fcb43823          	sd	a1,-48(s0)
    8020088c:	fcc43423          	sd	a2,-56(s0)
    80200890:	eb9ff0ef          	jal	80200748 <r_mhartid>
    80200894:	fea43423          	sd	a0,-24(s0)
    80200898:	f75ff0ef          	jal	8020080c <osviz_millis>
    8020089c:	fea43023          	sd	a0,-32(s0)
    802008a0:	fd843783          	ld	a5,-40(s0)
    802008a4:	c781                	beqz	a5,802008ac <osviz_event+0x30>
    802008a6:	fd043783          	ld	a5,-48(s0)
    802008aa:	e399                	bnez	a5,802008b0 <osviz_event+0x34>
    802008ac:	57fd                	li	a5,-1
    802008ae:	a0bd                	j	8020091c <osviz_event+0xa0>
    802008b0:	fc843783          	ld	a5,-56(s0)
    802008b4:	cf95                	beqz	a5,802008f0 <osviz_event+0x74>
    802008b6:	fc843783          	ld	a5,-56(s0)
    802008ba:	0007c783          	lbu	a5,0(a5)
    802008be:	cb8d                	beqz	a5,802008f0 <osviz_event+0x74>
    802008c0:	fe043783          	ld	a5,-32(s0)
    802008c4:	0007861b          	sext.w	a2,a5
    802008c8:	fe843783          	ld	a5,-24(s0)
    802008cc:	2781                	sext.w	a5,a5
    802008ce:	fc843803          	ld	a6,-56(s0)
    802008d2:	fd043703          	ld	a4,-48(s0)
    802008d6:	fd843683          	ld	a3,-40(s0)
    802008da:	00007597          	auipc	a1,0x7
    802008de:	31658593          	addi	a1,a1,790 # 80207bf0 <user_code_end+0x220>
    802008e2:	00007517          	auipc	a0,0x7
    802008e6:	31650513          	addi	a0,a0,790 # 80207bf8 <user_code_end+0x228>
    802008ea:	7cc000ef          	jal	802010b6 <printf>
    802008ee:	a035                	j	8020091a <osviz_event+0x9e>
    802008f0:	fe043783          	ld	a5,-32(s0)
    802008f4:	0007861b          	sext.w	a2,a5
    802008f8:	fe843783          	ld	a5,-24(s0)
    802008fc:	2781                	sext.w	a5,a5
    802008fe:	fd043703          	ld	a4,-48(s0)
    80200902:	fd843683          	ld	a3,-40(s0)
    80200906:	00007597          	auipc	a1,0x7
    8020090a:	2ea58593          	addi	a1,a1,746 # 80207bf0 <user_code_end+0x220>
    8020090e:	00007517          	auipc	a0,0x7
    80200912:	33250513          	addi	a0,a0,818 # 80207c40 <user_code_end+0x270>
    80200916:	7a0000ef          	jal	802010b6 <printf>
    8020091a:	4781                	li	a5,0
    8020091c:	853e                	mv	a0,a5
    8020091e:	70e2                	ld	ra,56(sp)
    80200920:	7442                	ld	s0,48(sp)
    80200922:	6121                	addi	sp,sp,64
    80200924:	8082                	ret

0000000080200926 <osviz_snapshot>:
    80200926:	7105                	addi	sp,sp,-480
    80200928:	ef86                	sd	ra,472(sp)
    8020092a:	eba2                	sd	s0,464(sp)
    8020092c:	e7a6                	sd	s1,456(sp)
    8020092e:	e3ca                	sd	s2,448(sp)
    80200930:	1380                	addi	s0,sp,480
    80200932:	e83ff0ef          	jal	802007b4 <trap_vec_read>
    80200936:	fca43c23          	sd	a0,-40(s0)
    8020093a:	e63ff0ef          	jal	8020079c <r_priv_mode_bits>
    8020093e:	fca43823          	sd	a0,-48(s0)
    80200942:	fd843483          	ld	s1,-40(s0)
    80200946:	fd043903          	ld	s2,-48(s0)
    8020094a:	dffff0ef          	jal	80200748 <r_mhartid>
    8020094e:	87aa                	mv	a5,a0
    80200950:	0007871b          	sext.w	a4,a5
    80200954:	0000f797          	auipc	a5,0xf
    80200958:	b4c78793          	addi	a5,a5,-1204 # 8020f4a0 <g_irq_stats>
    8020095c:	439c                	lw	a5,0(a5)
    8020095e:	86be                	mv	a3,a5
    80200960:	0000f797          	auipc	a5,0xf
    80200964:	b4078793          	addi	a5,a5,-1216 # 8020f4a0 <g_irq_stats>
    80200968:	43dc                	lw	a5,4(a5)
    8020096a:	863e                	mv	a2,a5
    8020096c:	0000f797          	auipc	a5,0xf
    80200970:	b3478793          	addi	a5,a5,-1228 # 8020f4a0 <g_irq_stats>
    80200974:	479c                	lw	a5,8(a5)
    80200976:	85be                	mv	a1,a5
    80200978:	0000f797          	auipc	a5,0xf
    8020097c:	b2878793          	addi	a5,a5,-1240 # 8020f4a0 <g_irq_stats>
    80200980:	47dc                	lw	a5,12(a5)
    80200982:	883e                	mv	a6,a5
    80200984:	0000f797          	auipc	a5,0xf
    80200988:	b1c78793          	addi	a5,a5,-1252 # 8020f4a0 <g_irq_stats>
    8020098c:	4b9c                	lw	a5,16(a5)
    8020098e:	88be                	mv	a7,a5
    80200990:	0000f797          	auipc	a5,0xf
    80200994:	b1078793          	addi	a5,a5,-1264 # 8020f4a0 <g_irq_stats>
    80200998:	4bdc                	lw	a5,20(a5)
    8020099a:	e5040513          	addi	a0,s0,-432
    8020099e:	f43e                	sd	a5,40(sp)
    802009a0:	f046                	sd	a7,32(sp)
    802009a2:	ec42                	sd	a6,24(sp)
    802009a4:	e82e                	sd	a1,16(sp)
    802009a6:	e432                	sd	a2,8(sp)
    802009a8:	e036                	sd	a3,0(sp)
    802009aa:	88ba                	mv	a7,a4
    802009ac:	884a                	mv	a6,s2
    802009ae:	87a6                	mv	a5,s1
    802009b0:	00007717          	auipc	a4,0x7
    802009b4:	2c870713          	addi	a4,a4,712 # 80207c78 <user_code_end+0x2a8>
    802009b8:	00007697          	auipc	a3,0x7
    802009bc:	2d068693          	addi	a3,a3,720 # 80207c88 <user_code_end+0x2b8>
    802009c0:	00007617          	auipc	a2,0x7
    802009c4:	2d060613          	addi	a2,a2,720 # 80207c90 <user_code_end+0x2c0>
    802009c8:	18000593          	li	a1,384
    802009cc:	742000ef          	jal	8020110e <snprintf>
    802009d0:	e5040793          	addi	a5,s0,-432
    802009d4:	863e                	mv	a2,a5
    802009d6:	00007597          	auipc	a1,0x7
    802009da:	38258593          	addi	a1,a1,898 # 80207d58 <user_code_end+0x388>
    802009de:	00007517          	auipc	a0,0x7
    802009e2:	38a50513          	addi	a0,a0,906 # 80207d68 <user_code_end+0x398>
    802009e6:	6d0000ef          	jal	802010b6 <printf>
    802009ea:	4781                	li	a5,0
    802009ec:	853e                	mv	a0,a5
    802009ee:	60fe                	ld	ra,472(sp)
    802009f0:	645e                	ld	s0,464(sp)
    802009f2:	64be                	ld	s1,456(sp)
    802009f4:	691e                	ld	s2,448(sp)
    802009f6:	613d                	addi	sp,sp,480
    802009f8:	8082                	ret

00000000802009fa <osviz_boot_banner>:
    802009fa:	1141                	addi	sp,sp,-16
    802009fc:	e406                	sd	ra,8(sp)
    802009fe:	e022                	sd	s0,0(sp)
    80200a00:	0800                	addi	s0,sp,16
    80200a02:	00007517          	auipc	a0,0x7
    80200a06:	36e50513          	addi	a0,a0,878 # 80207d70 <user_code_end+0x3a0>
    80200a0a:	6ac000ef          	jal	802010b6 <printf>
    80200a0e:	00007517          	auipc	a0,0x7
    80200a12:	36a50513          	addi	a0,a0,874 # 80207d78 <user_code_end+0x3a8>
    80200a16:	6a0000ef          	jal	802010b6 <printf>
    80200a1a:	00007617          	auipc	a2,0x7
    80200a1e:	25e60613          	addi	a2,a2,606 # 80207c78 <user_code_end+0x2a8>
    80200a22:	00007597          	auipc	a1,0x7
    80200a26:	26658593          	addi	a1,a1,614 # 80207c88 <user_code_end+0x2b8>
    80200a2a:	00007517          	auipc	a0,0x7
    80200a2e:	37e50513          	addi	a0,a0,894 # 80207da8 <user_code_end+0x3d8>
    80200a32:	684000ef          	jal	802010b6 <printf>
    80200a36:	00007517          	auipc	a0,0x7
    80200a3a:	3a250513          	addi	a0,a0,930 # 80207dd8 <user_code_end+0x408>
    80200a3e:	678000ef          	jal	802010b6 <printf>
    80200a42:	00007517          	auipc	a0,0x7
    80200a46:	33650513          	addi	a0,a0,822 # 80207d78 <user_code_end+0x3a8>
    80200a4a:	66c000ef          	jal	802010b6 <printf>
    80200a4e:	00007617          	auipc	a2,0x7
    80200a52:	3ba60613          	addi	a2,a2,954 # 80207e08 <user_code_end+0x438>
    80200a56:	00007597          	auipc	a1,0x7
    80200a5a:	3ca58593          	addi	a1,a1,970 # 80207e20 <user_code_end+0x450>
    80200a5e:	00007517          	auipc	a0,0x7
    80200a62:	3ca50513          	addi	a0,a0,970 # 80207e28 <user_code_end+0x458>
    80200a66:	e17ff0ef          	jal	8020087c <osviz_event>
    80200a6a:	0001                	nop
    80200a6c:	60a2                	ld	ra,8(sp)
    80200a6e:	6402                	ld	s0,0(sp)
    80200a70:	0141                	addi	sp,sp,16
    80200a72:	8082                	ret

0000000080200a74 <r_sstatus>:
    80200a74:	1101                	addi	sp,sp,-32
    80200a76:	ec06                	sd	ra,24(sp)
    80200a78:	e822                	sd	s0,16(sp)
    80200a7a:	1000                	addi	s0,sp,32
    80200a7c:	100027f3          	csrr	a5,sstatus
    80200a80:	fef43423          	sd	a5,-24(s0)
    80200a84:	fe843783          	ld	a5,-24(s0)
    80200a88:	853e                	mv	a0,a5
    80200a8a:	60e2                	ld	ra,24(sp)
    80200a8c:	6442                	ld	s0,16(sp)
    80200a8e:	6105                	addi	sp,sp,32
    80200a90:	8082                	ret

0000000080200a92 <w_sstatus>:
    80200a92:	1101                	addi	sp,sp,-32
    80200a94:	ec06                	sd	ra,24(sp)
    80200a96:	e822                	sd	s0,16(sp)
    80200a98:	1000                	addi	s0,sp,32
    80200a9a:	fea43423          	sd	a0,-24(s0)
    80200a9e:	fe843783          	ld	a5,-24(s0)
    80200aa2:	10079073          	csrw	sstatus,a5
    80200aa6:	0001                	nop
    80200aa8:	60e2                	ld	ra,24(sp)
    80200aaa:	6442                	ld	s0,16(sp)
    80200aac:	6105                	addi	sp,sp,32
    80200aae:	8082                	ret

0000000080200ab0 <w_sie>:
    80200ab0:	1101                	addi	sp,sp,-32
    80200ab2:	ec06                	sd	ra,24(sp)
    80200ab4:	e822                	sd	s0,16(sp)
    80200ab6:	1000                	addi	s0,sp,32
    80200ab8:	fea43423          	sd	a0,-24(s0)
    80200abc:	fe843783          	ld	a5,-24(s0)
    80200ac0:	10479073          	csrw	sie,a5
    80200ac4:	0001                	nop
    80200ac6:	60e2                	ld	ra,24(sp)
    80200ac8:	6442                	ld	s0,16(sp)
    80200aca:	6105                	addi	sp,sp,32
    80200acc:	8082                	ret

0000000080200ace <cpu_irq_disable>:
    80200ace:	1141                	addi	sp,sp,-16
    80200ad0:	e406                	sd	ra,8(sp)
    80200ad2:	e022                	sd	s0,0(sp)
    80200ad4:	0800                	addi	s0,sp,16
    80200ad6:	f9fff0ef          	jal	80200a74 <r_sstatus>
    80200ada:	87aa                	mv	a5,a0
    80200adc:	9bf5                	andi	a5,a5,-3
    80200ade:	853e                	mv	a0,a5
    80200ae0:	fb3ff0ef          	jal	80200a92 <w_sstatus>
    80200ae4:	0001                	nop
    80200ae6:	60a2                	ld	ra,8(sp)
    80200ae8:	6402                	ld	s0,0(sp)
    80200aea:	0141                	addi	sp,sp,16
    80200aec:	8082                	ret

0000000080200aee <sbi_shutdown>:
    80200aee:	1141                	addi	sp,sp,-16
    80200af0:	e406                	sd	ra,8(sp)
    80200af2:	e022                	sd	s0,0(sp)
    80200af4:	0800                	addi	s0,sp,16
    80200af6:	48a1                	li	a7,8
    80200af8:	00000073          	ecall
    80200afc:	0001                	nop
    80200afe:	60a2                	ld	ra,8(sp)
    80200b00:	6402                	ld	s0,0(sp)
    80200b02:	0141                	addi	sp,sp,16
    80200b04:	8082                	ret

0000000080200b06 <qemu_test_poweroff>:
    80200b06:	1141                	addi	sp,sp,-16
    80200b08:	e406                	sd	ra,8(sp)
    80200b0a:	e022                	sd	s0,0(sp)
    80200b0c:	0800                	addi	s0,sp,16
    80200b0e:	001007b7          	lui	a5,0x100
    80200b12:	6715                	lui	a4,0x5
    80200b14:	55570713          	addi	a4,a4,1365 # 5555 <STACK_SIZE+0x4555>
    80200b18:	c398                	sw	a4,0(a5)
    80200b1a:	0001                	nop
    80200b1c:	60a2                	ld	ra,8(sp)
    80200b1e:	6402                	ld	s0,0(sp)
    80200b20:	0141                	addi	sp,sp,16
    80200b22:	8082                	ret

0000000080200b24 <shutdown_quiesce>:
    80200b24:	1141                	addi	sp,sp,-16
    80200b26:	e406                	sd	ra,8(sp)
    80200b28:	e022                	sd	s0,0(sp)
    80200b2a:	0800                	addi	s0,sp,16
    80200b2c:	fa3ff0ef          	jal	80200ace <cpu_irq_disable>
    80200b30:	4501                	li	a0,0
    80200b32:	f7fff0ef          	jal	80200ab0 <w_sie>
    80200b36:	0001                	nop
    80200b38:	60a2                	ld	ra,8(sp)
    80200b3a:	6402                	ld	s0,0(sp)
    80200b3c:	0141                	addi	sp,sp,16
    80200b3e:	8082                	ret

0000000080200b40 <machine_poweroff>:
    80200b40:	1141                	addi	sp,sp,-16
    80200b42:	e406                	sd	ra,8(sp)
    80200b44:	e022                	sd	s0,0(sp)
    80200b46:	0800                	addi	s0,sp,16
    80200b48:	fddff0ef          	jal	80200b24 <shutdown_quiesce>
    80200b4c:	00007517          	auipc	a0,0x7
    80200b50:	2ec50513          	addi	a0,a0,748 # 80207e38 <user_code_end+0x468>
    80200b54:	14f000ef          	jal	802014a2 <uart_puts>
    80200b58:	00007617          	auipc	a2,0x7
    80200b5c:	2f860613          	addi	a2,a2,760 # 80207e50 <user_code_end+0x480>
    80200b60:	00007597          	auipc	a1,0x7
    80200b64:	30858593          	addi	a1,a1,776 # 80207e68 <user_code_end+0x498>
    80200b68:	00007517          	auipc	a0,0x7
    80200b6c:	31050513          	addi	a0,a0,784 # 80207e78 <user_code_end+0x4a8>
    80200b70:	d0dff0ef          	jal	8020087c <osviz_event>
    80200b74:	f7bff0ef          	jal	80200aee <sbi_shutdown>
    80200b78:	00007517          	auipc	a0,0x7
    80200b7c:	30850513          	addi	a0,a0,776 # 80207e80 <user_code_end+0x4b0>
    80200b80:	123000ef          	jal	802014a2 <uart_puts>
    80200b84:	f83ff0ef          	jal	80200b06 <qemu_test_poweroff>
    80200b88:	00007517          	auipc	a0,0x7
    80200b8c:	33050513          	addi	a0,a0,816 # 80207eb8 <user_code_end+0x4e8>
    80200b90:	113000ef          	jal	802014a2 <uart_puts>
    80200b94:	10500073          	wfi
    80200b98:	bff5                	j	80200b94 <machine_poweroff+0x54>

0000000080200b9a <_vsnprintf>:
    80200b9a:	7119                	addi	sp,sp,-128
    80200b9c:	fc86                	sd	ra,120(sp)
    80200b9e:	f8a2                	sd	s0,112(sp)
    80200ba0:	0100                	addi	s0,sp,128
    80200ba2:	f8a43c23          	sd	a0,-104(s0)
    80200ba6:	f8b43823          	sd	a1,-112(s0)
    80200baa:	f8c43423          	sd	a2,-120(s0)
    80200bae:	f8d43023          	sd	a3,-128(s0)
    80200bb2:	fe042623          	sw	zero,-20(s0)
    80200bb6:	fe042423          	sw	zero,-24(s0)
    80200bba:	fe043023          	sd	zero,-32(s0)
    80200bbe:	a939                	j	80200fdc <_vsnprintf+0x442>
    80200bc0:	fec42783          	lw	a5,-20(s0)
    80200bc4:	2781                	sext.w	a5,a5
    80200bc6:	3a078e63          	beqz	a5,80200f82 <_vsnprintf+0x3e8>
    80200bca:	f8843783          	ld	a5,-120(s0)
    80200bce:	0007c783          	lbu	a5,0(a5) # 100000 <STACK_SIZE+0xff000>
    80200bd2:	2781                	sext.w	a5,a5
    80200bd4:	07800713          	li	a4,120
    80200bd8:	0ae78c63          	beq	a5,a4,80200c90 <_vsnprintf+0xf6>
    80200bdc:	07800713          	li	a4,120
    80200be0:	3ef74863          	blt	a4,a5,80200fd0 <_vsnprintf+0x436>
    80200be4:	07300713          	li	a4,115
    80200be8:	2ee78863          	beq	a5,a4,80200ed8 <_vsnprintf+0x33e>
    80200bec:	07300713          	li	a4,115
    80200bf0:	3ef74063          	blt	a4,a5,80200fd0 <_vsnprintf+0x436>
    80200bf4:	07000713          	li	a4,112
    80200bf8:	02e78b63          	beq	a5,a4,80200c2e <_vsnprintf+0x94>
    80200bfc:	07000713          	li	a4,112
    80200c00:	3cf74863          	blt	a4,a5,80200fd0 <_vsnprintf+0x436>
    80200c04:	06c00713          	li	a4,108
    80200c08:	00e78f63          	beq	a5,a4,80200c26 <_vsnprintf+0x8c>
    80200c0c:	06c00713          	li	a4,108
    80200c10:	3cf74063          	blt	a4,a5,80200fd0 <_vsnprintf+0x436>
    80200c14:	06300713          	li	a4,99
    80200c18:	32e78263          	beq	a5,a4,80200f3c <_vsnprintf+0x3a2>
    80200c1c:	06400713          	li	a4,100
    80200c20:	14e78863          	beq	a5,a4,80200d70 <_vsnprintf+0x1d6>
    80200c24:	a675                	j	80200fd0 <_vsnprintf+0x436>
    80200c26:	4785                	li	a5,1
    80200c28:	fef42423          	sw	a5,-24(s0)
    80200c2c:	a65d                	j	80200fd2 <_vsnprintf+0x438>
    80200c2e:	4785                	li	a5,1
    80200c30:	fef42423          	sw	a5,-24(s0)
    80200c34:	f9843783          	ld	a5,-104(s0)
    80200c38:	c385                	beqz	a5,80200c58 <_vsnprintf+0xbe>
    80200c3a:	fe043703          	ld	a4,-32(s0)
    80200c3e:	f9043783          	ld	a5,-112(s0)
    80200c42:	00f77b63          	bgeu	a4,a5,80200c58 <_vsnprintf+0xbe>
    80200c46:	f9843703          	ld	a4,-104(s0)
    80200c4a:	fe043783          	ld	a5,-32(s0)
    80200c4e:	97ba                	add	a5,a5,a4
    80200c50:	03000713          	li	a4,48
    80200c54:	00e78023          	sb	a4,0(a5)
    80200c58:	fe043783          	ld	a5,-32(s0)
    80200c5c:	0785                	addi	a5,a5,1
    80200c5e:	fef43023          	sd	a5,-32(s0)
    80200c62:	f9843783          	ld	a5,-104(s0)
    80200c66:	c385                	beqz	a5,80200c86 <_vsnprintf+0xec>
    80200c68:	fe043703          	ld	a4,-32(s0)
    80200c6c:	f9043783          	ld	a5,-112(s0)
    80200c70:	00f77b63          	bgeu	a4,a5,80200c86 <_vsnprintf+0xec>
    80200c74:	f9843703          	ld	a4,-104(s0)
    80200c78:	fe043783          	ld	a5,-32(s0)
    80200c7c:	97ba                	add	a5,a5,a4
    80200c7e:	07800713          	li	a4,120
    80200c82:	00e78023          	sb	a4,0(a5)
    80200c86:	fe043783          	ld	a5,-32(s0)
    80200c8a:	0785                	addi	a5,a5,1
    80200c8c:	fef43023          	sd	a5,-32(s0)
    80200c90:	fe842783          	lw	a5,-24(s0)
    80200c94:	2781                	sext.w	a5,a5
    80200c96:	cb99                	beqz	a5,80200cac <_vsnprintf+0x112>
    80200c98:	f8043783          	ld	a5,-128(s0)
    80200c9c:	00878713          	addi	a4,a5,8
    80200ca0:	f8e43023          	sd	a4,-128(s0)
    80200ca4:	639c                	ld	a5,0(a5)
    80200ca6:	fcf43c23          	sd	a5,-40(s0)
    80200caa:	a811                	j	80200cbe <_vsnprintf+0x124>
    80200cac:	f8043783          	ld	a5,-128(s0)
    80200cb0:	00878713          	addi	a4,a5,8
    80200cb4:	f8e43023          	sd	a4,-128(s0)
    80200cb8:	439c                	lw	a5,0(a5)
    80200cba:	fcf43c23          	sd	a5,-40(s0)
    80200cbe:	fe842783          	lw	a5,-24(s0)
    80200cc2:	2781                	sext.w	a5,a5
    80200cc4:	c789                	beqz	a5,80200cce <_vsnprintf+0x134>
    80200cc6:	47bd                	li	a5,15
    80200cc8:	fcf42a23          	sw	a5,-44(s0)
    80200ccc:	a021                	j	80200cd4 <_vsnprintf+0x13a>
    80200cce:	479d                	li	a5,7
    80200cd0:	fcf42a23          	sw	a5,-44(s0)
    80200cd4:	fd442783          	lw	a5,-44(s0)
    80200cd8:	fcf42823          	sw	a5,-48(s0)
    80200cdc:	a041                	j	80200d5c <_vsnprintf+0x1c2>
    80200cde:	fd042783          	lw	a5,-48(s0)
    80200ce2:	0027979b          	slliw	a5,a5,0x2
    80200ce6:	2781                	sext.w	a5,a5
    80200ce8:	fd843703          	ld	a4,-40(s0)
    80200cec:	40f757b3          	sra	a5,a4,a5
    80200cf0:	2781                	sext.w	a5,a5
    80200cf2:	8bbd                	andi	a5,a5,15
    80200cf4:	faf42223          	sw	a5,-92(s0)
    80200cf8:	f9843783          	ld	a5,-104(s0)
    80200cfc:	c7b1                	beqz	a5,80200d48 <_vsnprintf+0x1ae>
    80200cfe:	fe043703          	ld	a4,-32(s0)
    80200d02:	f9043783          	ld	a5,-112(s0)
    80200d06:	04f77163          	bgeu	a4,a5,80200d48 <_vsnprintf+0x1ae>
    80200d0a:	fa442783          	lw	a5,-92(s0)
    80200d0e:	0007871b          	sext.w	a4,a5
    80200d12:	47a5                	li	a5,9
    80200d14:	00e7cb63          	blt	a5,a4,80200d2a <_vsnprintf+0x190>
    80200d18:	fa442783          	lw	a5,-92(s0)
    80200d1c:	0ff7f793          	zext.b	a5,a5
    80200d20:	0307879b          	addiw	a5,a5,48
    80200d24:	0ff7f793          	zext.b	a5,a5
    80200d28:	a809                	j	80200d3a <_vsnprintf+0x1a0>
    80200d2a:	fa442783          	lw	a5,-92(s0)
    80200d2e:	0ff7f793          	zext.b	a5,a5
    80200d32:	0577879b          	addiw	a5,a5,87
    80200d36:	0ff7f793          	zext.b	a5,a5
    80200d3a:	f9843683          	ld	a3,-104(s0)
    80200d3e:	fe043703          	ld	a4,-32(s0)
    80200d42:	9736                	add	a4,a4,a3
    80200d44:	00f70023          	sb	a5,0(a4)
    80200d48:	fe043783          	ld	a5,-32(s0)
    80200d4c:	0785                	addi	a5,a5,1
    80200d4e:	fef43023          	sd	a5,-32(s0)
    80200d52:	fd042783          	lw	a5,-48(s0)
    80200d56:	37fd                	addiw	a5,a5,-1
    80200d58:	fcf42823          	sw	a5,-48(s0)
    80200d5c:	fd042783          	lw	a5,-48(s0)
    80200d60:	2781                	sext.w	a5,a5
    80200d62:	f607dee3          	bgez	a5,80200cde <_vsnprintf+0x144>
    80200d66:	fe042423          	sw	zero,-24(s0)
    80200d6a:	fe042623          	sw	zero,-20(s0)
    80200d6e:	a495                	j	80200fd2 <_vsnprintf+0x438>
    80200d70:	fe842783          	lw	a5,-24(s0)
    80200d74:	2781                	sext.w	a5,a5
    80200d76:	cb99                	beqz	a5,80200d8c <_vsnprintf+0x1f2>
    80200d78:	f8043783          	ld	a5,-128(s0)
    80200d7c:	00878713          	addi	a4,a5,8
    80200d80:	f8e43023          	sd	a4,-128(s0)
    80200d84:	639c                	ld	a5,0(a5)
    80200d86:	fcf43423          	sd	a5,-56(s0)
    80200d8a:	a811                	j	80200d9e <_vsnprintf+0x204>
    80200d8c:	f8043783          	ld	a5,-128(s0)
    80200d90:	00878713          	addi	a4,a5,8
    80200d94:	f8e43023          	sd	a4,-128(s0)
    80200d98:	439c                	lw	a5,0(a5)
    80200d9a:	fcf43423          	sd	a5,-56(s0)
    80200d9e:	fc843783          	ld	a5,-56(s0)
    80200da2:	0207df63          	bgez	a5,80200de0 <_vsnprintf+0x246>
    80200da6:	fc843783          	ld	a5,-56(s0)
    80200daa:	40f007b3          	neg	a5,a5
    80200dae:	fcf43423          	sd	a5,-56(s0)
    80200db2:	f9843783          	ld	a5,-104(s0)
    80200db6:	c385                	beqz	a5,80200dd6 <_vsnprintf+0x23c>
    80200db8:	fe043703          	ld	a4,-32(s0)
    80200dbc:	f9043783          	ld	a5,-112(s0)
    80200dc0:	00f77b63          	bgeu	a4,a5,80200dd6 <_vsnprintf+0x23c>
    80200dc4:	f9843703          	ld	a4,-104(s0)
    80200dc8:	fe043783          	ld	a5,-32(s0)
    80200dcc:	97ba                	add	a5,a5,a4
    80200dce:	02d00713          	li	a4,45
    80200dd2:	00e78023          	sb	a4,0(a5)
    80200dd6:	fe043783          	ld	a5,-32(s0)
    80200dda:	0785                	addi	a5,a5,1
    80200ddc:	fef43023          	sd	a5,-32(s0)
    80200de0:	4785                	li	a5,1
    80200de2:	fcf43023          	sd	a5,-64(s0)
    80200de6:	fc843783          	ld	a5,-56(s0)
    80200dea:	faf43c23          	sd	a5,-72(s0)
    80200dee:	a031                	j	80200dfa <_vsnprintf+0x260>
    80200df0:	fc043783          	ld	a5,-64(s0)
    80200df4:	0785                	addi	a5,a5,1
    80200df6:	fcf43023          	sd	a5,-64(s0)
    80200dfa:	fb843783          	ld	a5,-72(s0)
    80200dfe:	00007717          	auipc	a4,0x7
    80200e02:	11270713          	addi	a4,a4,274 # 80207f10 <user_code_end+0x540>
    80200e06:	6318                	ld	a4,0(a4)
    80200e08:	02e79733          	mulh	a4,a5,a4
    80200e0c:	8709                	srai	a4,a4,0x2
    80200e0e:	97fd                	srai	a5,a5,0x3f
    80200e10:	40f707b3          	sub	a5,a4,a5
    80200e14:	faf43c23          	sd	a5,-72(s0)
    80200e18:	fb843783          	ld	a5,-72(s0)
    80200e1c:	fbf1                	bnez	a5,80200df0 <_vsnprintf+0x256>
    80200e1e:	fc043783          	ld	a5,-64(s0)
    80200e22:	2781                	sext.w	a5,a5
    80200e24:	37fd                	addiw	a5,a5,-1
    80200e26:	2781                	sext.w	a5,a5
    80200e28:	faf42a23          	sw	a5,-76(s0)
    80200e2c:	a069                	j	80200eb6 <_vsnprintf+0x31c>
    80200e2e:	f9843783          	ld	a5,-104(s0)
    80200e32:	cfb1                	beqz	a5,80200e8e <_vsnprintf+0x2f4>
    80200e34:	fb442703          	lw	a4,-76(s0)
    80200e38:	fe043783          	ld	a5,-32(s0)
    80200e3c:	97ba                	add	a5,a5,a4
    80200e3e:	f9043703          	ld	a4,-112(s0)
    80200e42:	04e7f663          	bgeu	a5,a4,80200e8e <_vsnprintf+0x2f4>
    80200e46:	fc843703          	ld	a4,-56(s0)
    80200e4a:	00007797          	auipc	a5,0x7
    80200e4e:	0c678793          	addi	a5,a5,198 # 80207f10 <user_code_end+0x540>
    80200e52:	639c                	ld	a5,0(a5)
    80200e54:	02f717b3          	mulh	a5,a4,a5
    80200e58:	4027d693          	srai	a3,a5,0x2
    80200e5c:	43f75793          	srai	a5,a4,0x3f
    80200e60:	8e9d                	sub	a3,a3,a5
    80200e62:	87b6                	mv	a5,a3
    80200e64:	078a                	slli	a5,a5,0x2
    80200e66:	97b6                	add	a5,a5,a3
    80200e68:	0786                	slli	a5,a5,0x1
    80200e6a:	40f706b3          	sub	a3,a4,a5
    80200e6e:	0ff6f713          	zext.b	a4,a3
    80200e72:	fb442683          	lw	a3,-76(s0)
    80200e76:	fe043783          	ld	a5,-32(s0)
    80200e7a:	97b6                	add	a5,a5,a3
    80200e7c:	f9843683          	ld	a3,-104(s0)
    80200e80:	97b6                	add	a5,a5,a3
    80200e82:	0307071b          	addiw	a4,a4,48
    80200e86:	0ff77713          	zext.b	a4,a4
    80200e8a:	00e78023          	sb	a4,0(a5)
    80200e8e:	fc843783          	ld	a5,-56(s0)
    80200e92:	00007717          	auipc	a4,0x7
    80200e96:	07e70713          	addi	a4,a4,126 # 80207f10 <user_code_end+0x540>
    80200e9a:	6318                	ld	a4,0(a4)
    80200e9c:	02e79733          	mulh	a4,a5,a4
    80200ea0:	8709                	srai	a4,a4,0x2
    80200ea2:	97fd                	srai	a5,a5,0x3f
    80200ea4:	40f707b3          	sub	a5,a4,a5
    80200ea8:	fcf43423          	sd	a5,-56(s0)
    80200eac:	fb442783          	lw	a5,-76(s0)
    80200eb0:	37fd                	addiw	a5,a5,-1
    80200eb2:	faf42a23          	sw	a5,-76(s0)
    80200eb6:	fb442783          	lw	a5,-76(s0)
    80200eba:	2781                	sext.w	a5,a5
    80200ebc:	f607d9e3          	bgez	a5,80200e2e <_vsnprintf+0x294>
    80200ec0:	fc043783          	ld	a5,-64(s0)
    80200ec4:	fe043703          	ld	a4,-32(s0)
    80200ec8:	97ba                	add	a5,a5,a4
    80200eca:	fef43023          	sd	a5,-32(s0)
    80200ece:	fe042423          	sw	zero,-24(s0)
    80200ed2:	fe042623          	sw	zero,-20(s0)
    80200ed6:	a8f5                	j	80200fd2 <_vsnprintf+0x438>
    80200ed8:	f8043783          	ld	a5,-128(s0)
    80200edc:	00878713          	addi	a4,a5,8
    80200ee0:	f8e43023          	sd	a4,-128(s0)
    80200ee4:	639c                	ld	a5,0(a5)
    80200ee6:	faf43423          	sd	a5,-88(s0)
    80200eea:	a83d                	j	80200f28 <_vsnprintf+0x38e>
    80200eec:	f9843783          	ld	a5,-104(s0)
    80200ef0:	c395                	beqz	a5,80200f14 <_vsnprintf+0x37a>
    80200ef2:	fe043703          	ld	a4,-32(s0)
    80200ef6:	f9043783          	ld	a5,-112(s0)
    80200efa:	00f77d63          	bgeu	a4,a5,80200f14 <_vsnprintf+0x37a>
    80200efe:	f9843703          	ld	a4,-104(s0)
    80200f02:	fe043783          	ld	a5,-32(s0)
    80200f06:	97ba                	add	a5,a5,a4
    80200f08:	fa843703          	ld	a4,-88(s0)
    80200f0c:	00074703          	lbu	a4,0(a4)
    80200f10:	00e78023          	sb	a4,0(a5)
    80200f14:	fe043783          	ld	a5,-32(s0)
    80200f18:	0785                	addi	a5,a5,1
    80200f1a:	fef43023          	sd	a5,-32(s0)
    80200f1e:	fa843783          	ld	a5,-88(s0)
    80200f22:	0785                	addi	a5,a5,1
    80200f24:	faf43423          	sd	a5,-88(s0)
    80200f28:	fa843783          	ld	a5,-88(s0)
    80200f2c:	0007c783          	lbu	a5,0(a5)
    80200f30:	ffd5                	bnez	a5,80200eec <_vsnprintf+0x352>
    80200f32:	fe042423          	sw	zero,-24(s0)
    80200f36:	fe042623          	sw	zero,-20(s0)
    80200f3a:	a861                	j	80200fd2 <_vsnprintf+0x438>
    80200f3c:	f9843783          	ld	a5,-104(s0)
    80200f40:	c79d                	beqz	a5,80200f6e <_vsnprintf+0x3d4>
    80200f42:	fe043703          	ld	a4,-32(s0)
    80200f46:	f9043783          	ld	a5,-112(s0)
    80200f4a:	02f77263          	bgeu	a4,a5,80200f6e <_vsnprintf+0x3d4>
    80200f4e:	f8043783          	ld	a5,-128(s0)
    80200f52:	00878713          	addi	a4,a5,8
    80200f56:	f8e43023          	sd	a4,-128(s0)
    80200f5a:	4394                	lw	a3,0(a5)
    80200f5c:	f9843703          	ld	a4,-104(s0)
    80200f60:	fe043783          	ld	a5,-32(s0)
    80200f64:	97ba                	add	a5,a5,a4
    80200f66:	0ff6f713          	zext.b	a4,a3
    80200f6a:	00e78023          	sb	a4,0(a5)
    80200f6e:	fe043783          	ld	a5,-32(s0)
    80200f72:	0785                	addi	a5,a5,1
    80200f74:	fef43023          	sd	a5,-32(s0)
    80200f78:	fe042423          	sw	zero,-24(s0)
    80200f7c:	fe042623          	sw	zero,-20(s0)
    80200f80:	a889                	j	80200fd2 <_vsnprintf+0x438>
    80200f82:	f8843783          	ld	a5,-120(s0)
    80200f86:	0007c783          	lbu	a5,0(a5)
    80200f8a:	873e                	mv	a4,a5
    80200f8c:	02500793          	li	a5,37
    80200f90:	00f71663          	bne	a4,a5,80200f9c <_vsnprintf+0x402>
    80200f94:	4785                	li	a5,1
    80200f96:	fef42623          	sw	a5,-20(s0)
    80200f9a:	a825                	j	80200fd2 <_vsnprintf+0x438>
    80200f9c:	f9843783          	ld	a5,-104(s0)
    80200fa0:	c395                	beqz	a5,80200fc4 <_vsnprintf+0x42a>
    80200fa2:	fe043703          	ld	a4,-32(s0)
    80200fa6:	f9043783          	ld	a5,-112(s0)
    80200faa:	00f77d63          	bgeu	a4,a5,80200fc4 <_vsnprintf+0x42a>
    80200fae:	f9843703          	ld	a4,-104(s0)
    80200fb2:	fe043783          	ld	a5,-32(s0)
    80200fb6:	97ba                	add	a5,a5,a4
    80200fb8:	f8843703          	ld	a4,-120(s0)
    80200fbc:	00074703          	lbu	a4,0(a4)
    80200fc0:	00e78023          	sb	a4,0(a5)
    80200fc4:	fe043783          	ld	a5,-32(s0)
    80200fc8:	0785                	addi	a5,a5,1
    80200fca:	fef43023          	sd	a5,-32(s0)
    80200fce:	a011                	j	80200fd2 <_vsnprintf+0x438>
    80200fd0:	0001                	nop
    80200fd2:	f8843783          	ld	a5,-120(s0)
    80200fd6:	0785                	addi	a5,a5,1
    80200fd8:	f8f43423          	sd	a5,-120(s0)
    80200fdc:	f8843783          	ld	a5,-120(s0)
    80200fe0:	0007c783          	lbu	a5,0(a5)
    80200fe4:	bc079ee3          	bnez	a5,80200bc0 <_vsnprintf+0x26>
    80200fe8:	f9843783          	ld	a5,-104(s0)
    80200fec:	cf99                	beqz	a5,8020100a <_vsnprintf+0x470>
    80200fee:	fe043703          	ld	a4,-32(s0)
    80200ff2:	f9043783          	ld	a5,-112(s0)
    80200ff6:	00f77a63          	bgeu	a4,a5,8020100a <_vsnprintf+0x470>
    80200ffa:	f9843703          	ld	a4,-104(s0)
    80200ffe:	fe043783          	ld	a5,-32(s0)
    80201002:	97ba                	add	a5,a5,a4
    80201004:	00078023          	sb	zero,0(a5)
    80201008:	a839                	j	80201026 <_vsnprintf+0x48c>
    8020100a:	f9843783          	ld	a5,-104(s0)
    8020100e:	cf81                	beqz	a5,80201026 <_vsnprintf+0x48c>
    80201010:	f9043783          	ld	a5,-112(s0)
    80201014:	cb89                	beqz	a5,80201026 <_vsnprintf+0x48c>
    80201016:	f9043783          	ld	a5,-112(s0)
    8020101a:	17fd                	addi	a5,a5,-1
    8020101c:	f9843703          	ld	a4,-104(s0)
    80201020:	97ba                	add	a5,a5,a4
    80201022:	00078023          	sb	zero,0(a5)
    80201026:	fe043783          	ld	a5,-32(s0)
    8020102a:	2781                	sext.w	a5,a5
    8020102c:	853e                	mv	a0,a5
    8020102e:	70e6                	ld	ra,120(sp)
    80201030:	7446                	ld	s0,112(sp)
    80201032:	6109                	addi	sp,sp,128
    80201034:	8082                	ret

0000000080201036 <_vprintf>:
    80201036:	7179                	addi	sp,sp,-48
    80201038:	f406                	sd	ra,40(sp)
    8020103a:	f022                	sd	s0,32(sp)
    8020103c:	1800                	addi	s0,sp,48
    8020103e:	fca43c23          	sd	a0,-40(s0)
    80201042:	fcb43823          	sd	a1,-48(s0)
    80201046:	fd043683          	ld	a3,-48(s0)
    8020104a:	fd843603          	ld	a2,-40(s0)
    8020104e:	55fd                	li	a1,-1
    80201050:	4501                	li	a0,0
    80201052:	b49ff0ef          	jal	80200b9a <_vsnprintf>
    80201056:	87aa                	mv	a5,a0
    80201058:	fef42623          	sw	a5,-20(s0)
    8020105c:	fec42783          	lw	a5,-20(s0)
    80201060:	2785                	addiw	a5,a5,1
    80201062:	2781                	sext.w	a5,a5
    80201064:	873e                	mv	a4,a5
    80201066:	3e700793          	li	a5,999
    8020106a:	00e7fa63          	bgeu	a5,a4,8020107e <_vprintf+0x48>
    8020106e:	00007517          	auipc	a0,0x7
    80201072:	e6a50513          	addi	a0,a0,-406 # 80207ed8 <user_code_end+0x508>
    80201076:	42c000ef          	jal	802014a2 <uart_puts>
    8020107a:	0001                	nop
    8020107c:	bffd                	j	8020107a <_vprintf+0x44>
    8020107e:	fec42783          	lw	a5,-20(s0)
    80201082:	2785                	addiw	a5,a5,1
    80201084:	2781                	sext.w	a5,a5
    80201086:	fd043683          	ld	a3,-48(s0)
    8020108a:	fd843603          	ld	a2,-40(s0)
    8020108e:	85be                	mv	a1,a5
    80201090:	0000e517          	auipc	a0,0xe
    80201094:	02850513          	addi	a0,a0,40 # 8020f0b8 <out_buf>
    80201098:	b03ff0ef          	jal	80200b9a <_vsnprintf>
    8020109c:	0000e517          	auipc	a0,0xe
    802010a0:	01c50513          	addi	a0,a0,28 # 8020f0b8 <out_buf>
    802010a4:	3fe000ef          	jal	802014a2 <uart_puts>
    802010a8:	fec42783          	lw	a5,-20(s0)
    802010ac:	853e                	mv	a0,a5
    802010ae:	70a2                	ld	ra,40(sp)
    802010b0:	7402                	ld	s0,32(sp)
    802010b2:	6145                	addi	sp,sp,48
    802010b4:	8082                	ret

00000000802010b6 <printf>:
    802010b6:	7159                	addi	sp,sp,-112
    802010b8:	f406                	sd	ra,40(sp)
    802010ba:	f022                	sd	s0,32(sp)
    802010bc:	1800                	addi	s0,sp,48
    802010be:	fca43c23          	sd	a0,-40(s0)
    802010c2:	e40c                	sd	a1,8(s0)
    802010c4:	e810                	sd	a2,16(s0)
    802010c6:	ec14                	sd	a3,24(s0)
    802010c8:	f018                	sd	a4,32(s0)
    802010ca:	f41c                	sd	a5,40(s0)
    802010cc:	03043823          	sd	a6,48(s0)
    802010d0:	03143c23          	sd	a7,56(s0)
    802010d4:	fe042623          	sw	zero,-20(s0)
    802010d8:	04040793          	addi	a5,s0,64
    802010dc:	fcf43823          	sd	a5,-48(s0)
    802010e0:	fd043783          	ld	a5,-48(s0)
    802010e4:	fc878793          	addi	a5,a5,-56
    802010e8:	fef43023          	sd	a5,-32(s0)
    802010ec:	fe043783          	ld	a5,-32(s0)
    802010f0:	85be                	mv	a1,a5
    802010f2:	fd843503          	ld	a0,-40(s0)
    802010f6:	f41ff0ef          	jal	80201036 <_vprintf>
    802010fa:	87aa                	mv	a5,a0
    802010fc:	fef42623          	sw	a5,-20(s0)
    80201100:	fec42783          	lw	a5,-20(s0)
    80201104:	853e                	mv	a0,a5
    80201106:	70a2                	ld	ra,40(sp)
    80201108:	7402                	ld	s0,32(sp)
    8020110a:	6165                	addi	sp,sp,112
    8020110c:	8082                	ret

000000008020110e <snprintf>:
    8020110e:	7159                	addi	sp,sp,-112
    80201110:	fc06                	sd	ra,56(sp)
    80201112:	f822                	sd	s0,48(sp)
    80201114:	0080                	addi	s0,sp,64
    80201116:	fca43c23          	sd	a0,-40(s0)
    8020111a:	fcb43823          	sd	a1,-48(s0)
    8020111e:	fcc43423          	sd	a2,-56(s0)
    80201122:	e414                	sd	a3,8(s0)
    80201124:	e818                	sd	a4,16(s0)
    80201126:	ec1c                	sd	a5,24(s0)
    80201128:	03043023          	sd	a6,32(s0)
    8020112c:	03143423          	sd	a7,40(s0)
    80201130:	fd843783          	ld	a5,-40(s0)
    80201134:	c781                	beqz	a5,8020113c <snprintf+0x2e>
    80201136:	fd043783          	ld	a5,-48(s0)
    8020113a:	e399                	bnez	a5,80201140 <snprintf+0x32>
    8020113c:	4781                	li	a5,0
    8020113e:	a81d                	j	80201174 <snprintf+0x66>
    80201140:	03040793          	addi	a5,s0,48
    80201144:	fcf43023          	sd	a5,-64(s0)
    80201148:	fc043783          	ld	a5,-64(s0)
    8020114c:	fd878793          	addi	a5,a5,-40
    80201150:	fef43023          	sd	a5,-32(s0)
    80201154:	fe043783          	ld	a5,-32(s0)
    80201158:	86be                	mv	a3,a5
    8020115a:	fc843603          	ld	a2,-56(s0)
    8020115e:	fd043583          	ld	a1,-48(s0)
    80201162:	fd843503          	ld	a0,-40(s0)
    80201166:	a35ff0ef          	jal	80200b9a <_vsnprintf>
    8020116a:	87aa                	mv	a5,a0
    8020116c:	fef42623          	sw	a5,-20(s0)
    80201170:	fec42783          	lw	a5,-20(s0)
    80201174:	853e                	mv	a0,a5
    80201176:	70e2                	ld	ra,56(sp)
    80201178:	7442                	ld	s0,48(sp)
    8020117a:	6165                	addi	sp,sp,112
    8020117c:	8082                	ret

000000008020117e <panic>:
    8020117e:	1101                	addi	sp,sp,-32
    80201180:	ec06                	sd	ra,24(sp)
    80201182:	e822                	sd	s0,16(sp)
    80201184:	1000                	addi	s0,sp,32
    80201186:	fea43423          	sd	a0,-24(s0)
    8020118a:	00007517          	auipc	a0,0x7
    8020118e:	d7650513          	addi	a0,a0,-650 # 80207f00 <user_code_end+0x530>
    80201192:	f25ff0ef          	jal	802010b6 <printf>
    80201196:	fe843503          	ld	a0,-24(s0)
    8020119a:	f1dff0ef          	jal	802010b6 <printf>
    8020119e:	00007517          	auipc	a0,0x7
    802011a2:	d6a50513          	addi	a0,a0,-662 # 80207f08 <user_code_end+0x538>
    802011a6:	f11ff0ef          	jal	802010b6 <printf>
    802011aa:	0001                	nop
    802011ac:	bffd                	j	802011aa <panic+0x2c>

00000000802011ae <stats_inc_timer>:
    802011ae:	1141                	addi	sp,sp,-16
    802011b0:	e406                	sd	ra,8(sp)
    802011b2:	e022                	sd	s0,0(sp)
    802011b4:	0800                	addi	s0,sp,16
    802011b6:	0000e797          	auipc	a5,0xe
    802011ba:	2ea78793          	addi	a5,a5,746 # 8020f4a0 <g_irq_stats>
    802011be:	439c                	lw	a5,0(a5)
    802011c0:	2785                	addiw	a5,a5,1
    802011c2:	0007871b          	sext.w	a4,a5
    802011c6:	0000e797          	auipc	a5,0xe
    802011ca:	2da78793          	addi	a5,a5,730 # 8020f4a0 <g_irq_stats>
    802011ce:	c398                	sw	a4,0(a5)
    802011d0:	0001                	nop
    802011d2:	60a2                	ld	ra,8(sp)
    802011d4:	6402                	ld	s0,0(sp)
    802011d6:	0141                	addi	sp,sp,16
    802011d8:	8082                	ret

00000000802011da <stats_inc_uart_rx>:
    802011da:	1141                	addi	sp,sp,-16
    802011dc:	e406                	sd	ra,8(sp)
    802011de:	e022                	sd	s0,0(sp)
    802011e0:	0800                	addi	s0,sp,16
    802011e2:	0000e797          	auipc	a5,0xe
    802011e6:	2be78793          	addi	a5,a5,702 # 8020f4a0 <g_irq_stats>
    802011ea:	43dc                	lw	a5,4(a5)
    802011ec:	2785                	addiw	a5,a5,1
    802011ee:	0007871b          	sext.w	a4,a5
    802011f2:	0000e797          	auipc	a5,0xe
    802011f6:	2ae78793          	addi	a5,a5,686 # 8020f4a0 <g_irq_stats>
    802011fa:	c3d8                	sw	a4,4(a5)
    802011fc:	0001                	nop
    802011fe:	60a2                	ld	ra,8(sp)
    80201200:	6402                	ld	s0,0(sp)
    80201202:	0141                	addi	sp,sp,16
    80201204:	8082                	ret

0000000080201206 <stats_inc_sw_irq>:
    80201206:	1141                	addi	sp,sp,-16
    80201208:	e406                	sd	ra,8(sp)
    8020120a:	e022                	sd	s0,0(sp)
    8020120c:	0800                	addi	s0,sp,16
    8020120e:	0000e797          	auipc	a5,0xe
    80201212:	29278793          	addi	a5,a5,658 # 8020f4a0 <g_irq_stats>
    80201216:	479c                	lw	a5,8(a5)
    80201218:	2785                	addiw	a5,a5,1
    8020121a:	0007871b          	sext.w	a4,a5
    8020121e:	0000e797          	auipc	a5,0xe
    80201222:	28278793          	addi	a5,a5,642 # 8020f4a0 <g_irq_stats>
    80201226:	c798                	sw	a4,8(a5)
    80201228:	0001                	nop
    8020122a:	60a2                	ld	ra,8(sp)
    8020122c:	6402                	ld	s0,0(sp)
    8020122e:	0141                	addi	sp,sp,16
    80201230:	8082                	ret

0000000080201232 <stats_inc_ext_irq>:
    80201232:	1141                	addi	sp,sp,-16
    80201234:	e406                	sd	ra,8(sp)
    80201236:	e022                	sd	s0,0(sp)
    80201238:	0800                	addi	s0,sp,16
    8020123a:	0000e797          	auipc	a5,0xe
    8020123e:	26678793          	addi	a5,a5,614 # 8020f4a0 <g_irq_stats>
    80201242:	47dc                	lw	a5,12(a5)
    80201244:	2785                	addiw	a5,a5,1
    80201246:	0007871b          	sext.w	a4,a5
    8020124a:	0000e797          	auipc	a5,0xe
    8020124e:	25678793          	addi	a5,a5,598 # 8020f4a0 <g_irq_stats>
    80201252:	c7d8                	sw	a4,12(a5)
    80201254:	0001                	nop
    80201256:	60a2                	ld	ra,8(sp)
    80201258:	6402                	ld	s0,0(sp)
    8020125a:	0141                	addi	sp,sp,16
    8020125c:	8082                	ret

000000008020125e <stats_inc_ecall>:
    8020125e:	1141                	addi	sp,sp,-16
    80201260:	e406                	sd	ra,8(sp)
    80201262:	e022                	sd	s0,0(sp)
    80201264:	0800                	addi	s0,sp,16
    80201266:	0000e797          	auipc	a5,0xe
    8020126a:	23a78793          	addi	a5,a5,570 # 8020f4a0 <g_irq_stats>
    8020126e:	4b9c                	lw	a5,16(a5)
    80201270:	2785                	addiw	a5,a5,1
    80201272:	0007871b          	sext.w	a4,a5
    80201276:	0000e797          	auipc	a5,0xe
    8020127a:	22a78793          	addi	a5,a5,554 # 8020f4a0 <g_irq_stats>
    8020127e:	cb98                	sw	a4,16(a5)
    80201280:	0001                	nop
    80201282:	60a2                	ld	ra,8(sp)
    80201284:	6402                	ld	s0,0(sp)
    80201286:	0141                	addi	sp,sp,16
    80201288:	8082                	ret

000000008020128a <stats_inc_page_fault>:
    8020128a:	1141                	addi	sp,sp,-16
    8020128c:	e406                	sd	ra,8(sp)
    8020128e:	e022                	sd	s0,0(sp)
    80201290:	0800                	addi	s0,sp,16
    80201292:	0000e797          	auipc	a5,0xe
    80201296:	20e78793          	addi	a5,a5,526 # 8020f4a0 <g_irq_stats>
    8020129a:	4bdc                	lw	a5,20(a5)
    8020129c:	2785                	addiw	a5,a5,1
    8020129e:	0007871b          	sext.w	a4,a5
    802012a2:	0000e797          	auipc	a5,0xe
    802012a6:	1fe78793          	addi	a5,a5,510 # 8020f4a0 <g_irq_stats>
    802012aa:	cbd8                	sw	a4,20(a5)
    802012ac:	0001                	nop
    802012ae:	60a2                	ld	ra,8(sp)
    802012b0:	6402                	ld	s0,0(sp)
    802012b2:	0141                	addi	sp,sp,16
    802012b4:	8082                	ret

00000000802012b6 <r_sstatus>:
    802012b6:	1101                	addi	sp,sp,-32
    802012b8:	ec06                	sd	ra,24(sp)
    802012ba:	e822                	sd	s0,16(sp)
    802012bc:	1000                	addi	s0,sp,32
    802012be:	100027f3          	csrr	a5,sstatus
    802012c2:	fef43423          	sd	a5,-24(s0)
    802012c6:	fe843783          	ld	a5,-24(s0)
    802012ca:	853e                	mv	a0,a5
    802012cc:	60e2                	ld	ra,24(sp)
    802012ce:	6442                	ld	s0,16(sp)
    802012d0:	6105                	addi	sp,sp,32
    802012d2:	8082                	ret

00000000802012d4 <w_sstatus>:
    802012d4:	1101                	addi	sp,sp,-32
    802012d6:	ec06                	sd	ra,24(sp)
    802012d8:	e822                	sd	s0,16(sp)
    802012da:	1000                	addi	s0,sp,32
    802012dc:	fea43423          	sd	a0,-24(s0)
    802012e0:	fe843783          	ld	a5,-24(s0)
    802012e4:	10079073          	csrw	sstatus,a5
    802012e8:	0001                	nop
    802012ea:	60e2                	ld	ra,24(sp)
    802012ec:	6442                	ld	s0,16(sp)
    802012ee:	6105                	addi	sp,sp,32
    802012f0:	8082                	ret

00000000802012f2 <cpu_irq_disable>:
    802012f2:	1141                	addi	sp,sp,-16
    802012f4:	e406                	sd	ra,8(sp)
    802012f6:	e022                	sd	s0,0(sp)
    802012f8:	0800                	addi	s0,sp,16
    802012fa:	fbdff0ef          	jal	802012b6 <r_sstatus>
    802012fe:	87aa                	mv	a5,a0
    80201300:	9bf5                	andi	a5,a5,-3
    80201302:	853e                	mv	a0,a5
    80201304:	fd1ff0ef          	jal	802012d4 <w_sstatus>
    80201308:	0001                	nop
    8020130a:	60a2                	ld	ra,8(sp)
    8020130c:	6402                	ld	s0,0(sp)
    8020130e:	0141                	addi	sp,sp,16
    80201310:	8082                	ret

0000000080201312 <cpu_irq_enable>:
    80201312:	1141                	addi	sp,sp,-16
    80201314:	e406                	sd	ra,8(sp)
    80201316:	e022                	sd	s0,0(sp)
    80201318:	0800                	addi	s0,sp,16
    8020131a:	f9dff0ef          	jal	802012b6 <r_sstatus>
    8020131e:	87aa                	mv	a5,a0
    80201320:	0027e793          	ori	a5,a5,2
    80201324:	853e                	mv	a0,a5
    80201326:	fafff0ef          	jal	802012d4 <w_sstatus>
    8020132a:	0001                	nop
    8020132c:	60a2                	ld	ra,8(sp)
    8020132e:	6402                	ld	s0,0(sp)
    80201330:	0141                	addi	sp,sp,16
    80201332:	8082                	ret

0000000080201334 <uart_read_reg>:
    80201334:	1101                	addi	sp,sp,-32
    80201336:	ec06                	sd	ra,24(sp)
    80201338:	e822                	sd	s0,16(sp)
    8020133a:	1000                	addi	s0,sp,32
    8020133c:	87aa                	mv	a5,a0
    8020133e:	fef42623          	sw	a5,-20(s0)
    80201342:	fec42703          	lw	a4,-20(s0)
    80201346:	100007b7          	lui	a5,0x10000
    8020134a:	97ba                	add	a5,a5,a4
    8020134c:	0007c783          	lbu	a5,0(a5) # 10000000 <_heap_size+0x8119a38>
    80201350:	0ff7f793          	zext.b	a5,a5
    80201354:	853e                	mv	a0,a5
    80201356:	60e2                	ld	ra,24(sp)
    80201358:	6442                	ld	s0,16(sp)
    8020135a:	6105                	addi	sp,sp,32
    8020135c:	8082                	ret

000000008020135e <uart_write_reg>:
    8020135e:	1101                	addi	sp,sp,-32
    80201360:	ec06                	sd	ra,24(sp)
    80201362:	e822                	sd	s0,16(sp)
    80201364:	1000                	addi	s0,sp,32
    80201366:	87aa                	mv	a5,a0
    80201368:	872e                	mv	a4,a1
    8020136a:	fef42623          	sw	a5,-20(s0)
    8020136e:	87ba                	mv	a5,a4
    80201370:	fef405a3          	sb	a5,-21(s0)
    80201374:	fec42703          	lw	a4,-20(s0)
    80201378:	100007b7          	lui	a5,0x10000
    8020137c:	97ba                	add	a5,a5,a4
    8020137e:	873e                	mv	a4,a5
    80201380:	feb44783          	lbu	a5,-21(s0)
    80201384:	00f70023          	sb	a5,0(a4)
    80201388:	0001                	nop
    8020138a:	60e2                	ld	ra,24(sp)
    8020138c:	6442                	ld	s0,16(sp)
    8020138e:	6105                	addi	sp,sp,32
    80201390:	8082                	ret

0000000080201392 <uart_irq_save>:
    80201392:	1101                	addi	sp,sp,-32
    80201394:	ec06                	sd	ra,24(sp)
    80201396:	e822                	sd	s0,16(sp)
    80201398:	1000                	addi	s0,sp,32
    8020139a:	f1dff0ef          	jal	802012b6 <r_sstatus>
    8020139e:	fea43423          	sd	a0,-24(s0)
    802013a2:	f51ff0ef          	jal	802012f2 <cpu_irq_disable>
    802013a6:	fe843783          	ld	a5,-24(s0)
    802013aa:	853e                	mv	a0,a5
    802013ac:	60e2                	ld	ra,24(sp)
    802013ae:	6442                	ld	s0,16(sp)
    802013b0:	6105                	addi	sp,sp,32
    802013b2:	8082                	ret

00000000802013b4 <uart_irq_restore>:
    802013b4:	1101                	addi	sp,sp,-32
    802013b6:	ec06                	sd	ra,24(sp)
    802013b8:	e822                	sd	s0,16(sp)
    802013ba:	1000                	addi	s0,sp,32
    802013bc:	fea43423          	sd	a0,-24(s0)
    802013c0:	fe843783          	ld	a5,-24(s0)
    802013c4:	8b89                	andi	a5,a5,2
    802013c6:	c399                	beqz	a5,802013cc <uart_irq_restore+0x18>
    802013c8:	f4bff0ef          	jal	80201312 <cpu_irq_enable>
    802013cc:	0001                	nop
    802013ce:	60e2                	ld	ra,24(sp)
    802013d0:	6442                	ld	s0,16(sp)
    802013d2:	6105                	addi	sp,sp,32
    802013d4:	8082                	ret

00000000802013d6 <uart_init>:
    802013d6:	1141                	addi	sp,sp,-16
    802013d8:	e406                	sd	ra,8(sp)
    802013da:	e022                	sd	s0,0(sp)
    802013dc:	0800                	addi	s0,sp,16
    802013de:	4581                	li	a1,0
    802013e0:	4505                	li	a0,1
    802013e2:	f7dff0ef          	jal	8020135e <uart_write_reg>
    802013e6:	08000593          	li	a1,128
    802013ea:	450d                	li	a0,3
    802013ec:	f73ff0ef          	jal	8020135e <uart_write_reg>
    802013f0:	458d                	li	a1,3
    802013f2:	4501                	li	a0,0
    802013f4:	f6bff0ef          	jal	8020135e <uart_write_reg>
    802013f8:	4581                	li	a1,0
    802013fa:	4505                	li	a0,1
    802013fc:	f63ff0ef          	jal	8020135e <uart_write_reg>
    80201400:	458d                	li	a1,3
    80201402:	450d                	li	a0,3
    80201404:	f5bff0ef          	jal	8020135e <uart_write_reg>
    80201408:	459d                	li	a1,7
    8020140a:	4509                	li	a0,2
    8020140c:	f53ff0ef          	jal	8020135e <uart_write_reg>
    80201410:	14e000ef          	jal	8020155e <uart_rx_flush>
    80201414:	0001                	nop
    80201416:	60a2                	ld	ra,8(sp)
    80201418:	6402                	ld	s0,0(sp)
    8020141a:	0141                	addi	sp,sp,16
    8020141c:	8082                	ret

000000008020141e <uart_irq_enable>:
    8020141e:	1141                	addi	sp,sp,-16
    80201420:	e406                	sd	ra,8(sp)
    80201422:	e022                	sd	s0,0(sp)
    80201424:	0800                	addi	s0,sp,16
    80201426:	4581                	li	a1,0
    80201428:	4505                	li	a0,1
    8020142a:	f35ff0ef          	jal	8020135e <uart_write_reg>
    8020142e:	00007617          	auipc	a2,0x7
    80201432:	aea60613          	addi	a2,a2,-1302 # 80207f18 <user_code_end+0x548>
    80201436:	00007597          	auipc	a1,0x7
    8020143a:	b0258593          	addi	a1,a1,-1278 # 80207f38 <user_code_end+0x568>
    8020143e:	00007517          	auipc	a0,0x7
    80201442:	b0a50513          	addi	a0,a0,-1270 # 80207f48 <user_code_end+0x578>
    80201446:	c36ff0ef          	jal	8020087c <osviz_event>
    8020144a:	0001                	nop
    8020144c:	60a2                	ld	ra,8(sp)
    8020144e:	6402                	ld	s0,0(sp)
    80201450:	0141                	addi	sp,sp,16
    80201452:	8082                	ret

0000000080201454 <uart_putc>:
    80201454:	7179                	addi	sp,sp,-48
    80201456:	f406                	sd	ra,40(sp)
    80201458:	f022                	sd	s0,32(sp)
    8020145a:	1800                	addi	s0,sp,48
    8020145c:	87aa                	mv	a5,a0
    8020145e:	fcf40fa3          	sb	a5,-33(s0)
    80201462:	f31ff0ef          	jal	80201392 <uart_irq_save>
    80201466:	fea43423          	sd	a0,-24(s0)
    8020146a:	0001                	nop
    8020146c:	4515                	li	a0,5
    8020146e:	ec7ff0ef          	jal	80201334 <uart_read_reg>
    80201472:	87aa                	mv	a5,a0
    80201474:	2781                	sext.w	a5,a5
    80201476:	0207f793          	andi	a5,a5,32
    8020147a:	2781                	sext.w	a5,a5
    8020147c:	dbe5                	beqz	a5,8020146c <uart_putc+0x18>
    8020147e:	fdf44783          	lbu	a5,-33(s0)
    80201482:	85be                	mv	a1,a5
    80201484:	4501                	li	a0,0
    80201486:	ed9ff0ef          	jal	8020135e <uart_write_reg>
    8020148a:	fe843503          	ld	a0,-24(s0)
    8020148e:	f27ff0ef          	jal	802013b4 <uart_irq_restore>
    80201492:	fdf44783          	lbu	a5,-33(s0)
    80201496:	2781                	sext.w	a5,a5
    80201498:	853e                	mv	a0,a5
    8020149a:	70a2                	ld	ra,40(sp)
    8020149c:	7402                	ld	s0,32(sp)
    8020149e:	6145                	addi	sp,sp,48
    802014a0:	8082                	ret

00000000802014a2 <uart_puts>:
    802014a2:	1101                	addi	sp,sp,-32
    802014a4:	ec06                	sd	ra,24(sp)
    802014a6:	e822                	sd	s0,16(sp)
    802014a8:	1000                	addi	s0,sp,32
    802014aa:	fea43423          	sd	a0,-24(s0)
    802014ae:	a821                	j	802014c6 <uart_puts+0x24>
    802014b0:	fe843783          	ld	a5,-24(s0)
    802014b4:	00178713          	addi	a4,a5,1 # 10000001 <_heap_size+0x8119a39>
    802014b8:	fee43423          	sd	a4,-24(s0)
    802014bc:	0007c783          	lbu	a5,0(a5)
    802014c0:	853e                	mv	a0,a5
    802014c2:	f93ff0ef          	jal	80201454 <uart_putc>
    802014c6:	fe843783          	ld	a5,-24(s0)
    802014ca:	0007c783          	lbu	a5,0(a5)
    802014ce:	f3ed                	bnez	a5,802014b0 <uart_puts+0xe>
    802014d0:	0001                	nop
    802014d2:	0001                	nop
    802014d4:	60e2                	ld	ra,24(sp)
    802014d6:	6442                	ld	s0,16(sp)
    802014d8:	6105                	addi	sp,sp,32
    802014da:	8082                	ret

00000000802014dc <uart_try_getc>:
    802014dc:	1101                	addi	sp,sp,-32
    802014de:	ec06                	sd	ra,24(sp)
    802014e0:	e822                	sd	s0,16(sp)
    802014e2:	1000                	addi	s0,sp,32
    802014e4:	4515                	li	a0,5
    802014e6:	e4fff0ef          	jal	80201334 <uart_read_reg>
    802014ea:	87aa                	mv	a5,a0
    802014ec:	2781                	sext.w	a5,a5
    802014ee:	8b85                	andi	a5,a5,1
    802014f0:	2781                	sext.w	a5,a5
    802014f2:	e399                	bnez	a5,802014f8 <uart_try_getc+0x1c>
    802014f4:	57fd                	li	a5,-1
    802014f6:	a00d                	j	80201518 <uart_try_getc+0x3c>
    802014f8:	4501                	li	a0,0
    802014fa:	e3bff0ef          	jal	80201334 <uart_read_reg>
    802014fe:	87aa                	mv	a5,a0
    80201500:	fef42623          	sw	a5,-20(s0)
    80201504:	fec42783          	lw	a5,-20(s0)
    80201508:	2781                	sext.w	a5,a5
    8020150a:	e399                	bnez	a5,80201510 <uart_try_getc+0x34>
    8020150c:	57fd                	li	a5,-1
    8020150e:	a029                	j	80201518 <uart_try_getc+0x3c>
    80201510:	ccbff0ef          	jal	802011da <stats_inc_uart_rx>
    80201514:	fec42783          	lw	a5,-20(s0)
    80201518:	853e                	mv	a0,a5
    8020151a:	60e2                	ld	ra,24(sp)
    8020151c:	6442                	ld	s0,16(sp)
    8020151e:	6105                	addi	sp,sp,32
    80201520:	8082                	ret

0000000080201522 <uart_getc>:
    80201522:	1101                	addi	sp,sp,-32
    80201524:	ec06                	sd	ra,24(sp)
    80201526:	e822                	sd	s0,16(sp)
    80201528:	1000                	addi	s0,sp,32
    8020152a:	e69ff0ef          	jal	80201392 <uart_irq_save>
    8020152e:	fea43423          	sd	a0,-24(s0)
    80201532:	0001                	nop
    80201534:	fa9ff0ef          	jal	802014dc <uart_try_getc>
    80201538:	87aa                	mv	a5,a0
    8020153a:	fef42223          	sw	a5,-28(s0)
    8020153e:	fe442783          	lw	a5,-28(s0)
    80201542:	2781                	sext.w	a5,a5
    80201544:	fe07c8e3          	bltz	a5,80201534 <uart_getc+0x12>
    80201548:	fe843503          	ld	a0,-24(s0)
    8020154c:	e69ff0ef          	jal	802013b4 <uart_irq_restore>
    80201550:	fe442783          	lw	a5,-28(s0)
    80201554:	853e                	mv	a0,a5
    80201556:	60e2                	ld	ra,24(sp)
    80201558:	6442                	ld	s0,16(sp)
    8020155a:	6105                	addi	sp,sp,32
    8020155c:	8082                	ret

000000008020155e <uart_rx_flush>:
    8020155e:	1101                	addi	sp,sp,-32
    80201560:	ec06                	sd	ra,24(sp)
    80201562:	e822                	sd	s0,16(sp)
    80201564:	1000                	addi	s0,sp,32
    80201566:	fe042623          	sw	zero,-20(s0)
    8020156a:	a00d                	j	8020158c <uart_rx_flush+0x2e>
    8020156c:	4501                	li	a0,0
    8020156e:	dc7ff0ef          	jal	80201334 <uart_read_reg>
    80201572:	fec42783          	lw	a5,-20(s0)
    80201576:	2785                	addiw	a5,a5,1
    80201578:	fef42623          	sw	a5,-20(s0)
    8020157c:	fec42783          	lw	a5,-20(s0)
    80201580:	0007871b          	sext.w	a4,a5
    80201584:	0ff00793          	li	a5,255
    80201588:	00e7cb63          	blt	a5,a4,8020159e <uart_rx_flush+0x40>
    8020158c:	4515                	li	a0,5
    8020158e:	da7ff0ef          	jal	80201334 <uart_read_reg>
    80201592:	87aa                	mv	a5,a0
    80201594:	2781                	sext.w	a5,a5
    80201596:	8b85                	andi	a5,a5,1
    80201598:	2781                	sext.w	a5,a5
    8020159a:	fbe9                	bnez	a5,8020156c <uart_rx_flush+0xe>
    8020159c:	a011                	j	802015a0 <uart_rx_flush+0x42>
    8020159e:	0001                	nop
    802015a0:	0001                	nop
    802015a2:	60e2                	ld	ra,24(sp)
    802015a4:	6442                	ld	s0,16(sp)
    802015a6:	6105                	addi	sp,sp,32
    802015a8:	8082                	ret

00000000802015aa <uart_rx_flush_deep>:
    802015aa:	1101                	addi	sp,sp,-32
    802015ac:	ec06                	sd	ra,24(sp)
    802015ae:	e822                	sd	s0,16(sp)
    802015b0:	1000                	addi	s0,sp,32
    802015b2:	fe042623          	sw	zero,-20(s0)
    802015b6:	a801                	j	802015c6 <uart_rx_flush_deep+0x1c>
    802015b8:	fa7ff0ef          	jal	8020155e <uart_rx_flush>
    802015bc:	fec42783          	lw	a5,-20(s0)
    802015c0:	2785                	addiw	a5,a5,1
    802015c2:	fef42623          	sw	a5,-20(s0)
    802015c6:	fec42783          	lw	a5,-20(s0)
    802015ca:	0007871b          	sext.w	a4,a5
    802015ce:	479d                	li	a5,7
    802015d0:	fee7d4e3          	bge	a5,a4,802015b8 <uart_rx_flush_deep+0xe>
    802015d4:	0001                	nop
    802015d6:	0001                	nop
    802015d8:	60e2                	ld	ra,24(sp)
    802015da:	6442                	ld	s0,16(sp)
    802015dc:	6105                	addi	sp,sp,32
    802015de:	8082                	ret

00000000802015e0 <uart_rx_drain_quiet>:
    802015e0:	7179                	addi	sp,sp,-48
    802015e2:	f406                	sd	ra,40(sp)
    802015e4:	f022                	sd	s0,32(sp)
    802015e6:	1800                	addi	s0,sp,48
    802015e8:	87aa                	mv	a5,a0
    802015ea:	872e                	mv	a4,a1
    802015ec:	fcf42e23          	sw	a5,-36(s0)
    802015f0:	87ba                	mv	a5,a4
    802015f2:	fcf42c23          	sw	a5,-40(s0)
    802015f6:	fe042623          	sw	zero,-20(s0)
    802015fa:	fe042423          	sw	zero,-24(s0)
    802015fe:	fadff0ef          	jal	802015aa <uart_rx_flush_deep>
    80201602:	a091                	j	80201646 <uart_rx_drain_quiet+0x66>
    80201604:	4515                	li	a0,5
    80201606:	d2fff0ef          	jal	80201334 <uart_read_reg>
    8020160a:	87aa                	mv	a5,a0
    8020160c:	2781                	sext.w	a5,a5
    8020160e:	8b85                	andi	a5,a5,1
    80201610:	2781                	sext.w	a5,a5
    80201612:	c799                	beqz	a5,80201620 <uart_rx_drain_quiet+0x40>
    80201614:	4501                	li	a0,0
    80201616:	d1fff0ef          	jal	80201334 <uart_read_reg>
    8020161a:	fe042623          	sw	zero,-20(s0)
    8020161e:	a839                	j	8020163c <uart_rx_drain_quiet+0x5c>
    80201620:	fec42783          	lw	a5,-20(s0)
    80201624:	2785                	addiw	a5,a5,1
    80201626:	fef42623          	sw	a5,-20(s0)
    8020162a:	fec42783          	lw	a5,-20(s0)
    8020162e:	873e                	mv	a4,a5
    80201630:	fdc42783          	lw	a5,-36(s0)
    80201634:	2701                	sext.w	a4,a4
    80201636:	2781                	sext.w	a5,a5
    80201638:	02f77163          	bgeu	a4,a5,8020165a <uart_rx_drain_quiet+0x7a>
    8020163c:	fe842783          	lw	a5,-24(s0)
    80201640:	2785                	addiw	a5,a5,1
    80201642:	fef42423          	sw	a5,-24(s0)
    80201646:	fe842783          	lw	a5,-24(s0)
    8020164a:	873e                	mv	a4,a5
    8020164c:	fd842783          	lw	a5,-40(s0)
    80201650:	2701                	sext.w	a4,a4
    80201652:	2781                	sext.w	a5,a5
    80201654:	faf768e3          	bltu	a4,a5,80201604 <uart_rx_drain_quiet+0x24>
    80201658:	a011                	j	8020165c <uart_rx_drain_quiet+0x7c>
    8020165a:	0001                	nop
    8020165c:	70a2                	ld	ra,40(sp)
    8020165e:	7402                	ld	s0,32(sp)
    80201660:	6145                	addi	sp,sp,48
    80201662:	8082                	ret

0000000080201664 <uart_read_buf>:
    80201664:	7179                	addi	sp,sp,-48
    80201666:	f406                	sd	ra,40(sp)
    80201668:	f022                	sd	s0,32(sp)
    8020166a:	1800                	addi	s0,sp,48
    8020166c:	fca43c23          	sd	a0,-40(s0)
    80201670:	87ae                	mv	a5,a1
    80201672:	fcf42a23          	sw	a5,-44(s0)
    80201676:	fe042623          	sw	zero,-20(s0)
    8020167a:	fd843783          	ld	a5,-40(s0)
    8020167e:	c791                	beqz	a5,8020168a <uart_read_buf+0x26>
    80201680:	fd442783          	lw	a5,-44(s0)
    80201684:	2781                	sext.w	a5,a5
    80201686:	02f04e63          	bgtz	a5,802016c2 <uart_read_buf+0x5e>
    8020168a:	4781                	li	a5,0
    8020168c:	a881                	j	802016dc <uart_read_buf+0x78>
    8020168e:	e4fff0ef          	jal	802014dc <uart_try_getc>
    80201692:	87aa                	mv	a5,a0
    80201694:	fef42423          	sw	a5,-24(s0)
    80201698:	fe842783          	lw	a5,-24(s0)
    8020169c:	2781                	sext.w	a5,a5
    8020169e:	0207cc63          	bltz	a5,802016d6 <uart_read_buf+0x72>
    802016a2:	fec42783          	lw	a5,-20(s0)
    802016a6:	0017871b          	addiw	a4,a5,1
    802016aa:	fee42623          	sw	a4,-20(s0)
    802016ae:	873e                	mv	a4,a5
    802016b0:	fd843783          	ld	a5,-40(s0)
    802016b4:	97ba                	add	a5,a5,a4
    802016b6:	fe842703          	lw	a4,-24(s0)
    802016ba:	0ff77713          	zext.b	a4,a4
    802016be:	00e78023          	sb	a4,0(a5)
    802016c2:	fec42783          	lw	a5,-20(s0)
    802016c6:	873e                	mv	a4,a5
    802016c8:	fd442783          	lw	a5,-44(s0)
    802016cc:	2701                	sext.w	a4,a4
    802016ce:	2781                	sext.w	a5,a5
    802016d0:	faf74fe3          	blt	a4,a5,8020168e <uart_read_buf+0x2a>
    802016d4:	a011                	j	802016d8 <uart_read_buf+0x74>
    802016d6:	0001                	nop
    802016d8:	fec42783          	lw	a5,-20(s0)
    802016dc:	853e                	mv	a0,a5
    802016de:	70a2                	ld	ra,40(sp)
    802016e0:	7402                	ld	s0,32(sp)
    802016e2:	6145                	addi	sp,sp,48
    802016e4:	8082                	ret

00000000802016e6 <uart_read_line>:
    802016e6:	7139                	addi	sp,sp,-64
    802016e8:	fc06                	sd	ra,56(sp)
    802016ea:	f822                	sd	s0,48(sp)
    802016ec:	0080                	addi	s0,sp,64
    802016ee:	fca43423          	sd	a0,-56(s0)
    802016f2:	87ae                	mv	a5,a1
    802016f4:	fcf42223          	sw	a5,-60(s0)
    802016f8:	fe042623          	sw	zero,-20(s0)
    802016fc:	c97ff0ef          	jal	80201392 <uart_irq_save>
    80201700:	fea43023          	sd	a0,-32(s0)
    80201704:	fc442783          	lw	a5,-60(s0)
    80201708:	0007871b          	sext.w	a4,a5
    8020170c:	4785                	li	a5,1
    8020170e:	0ee7cf63          	blt	a5,a4,8020180c <uart_read_line+0x126>
    80201712:	fe043503          	ld	a0,-32(s0)
    80201716:	c9fff0ef          	jal	802013b4 <uart_irq_restore>
    8020171a:	4781                	li	a5,0
    8020171c:	a235                	j	80201848 <uart_read_line+0x162>
    8020171e:	e05ff0ef          	jal	80201522 <uart_getc>
    80201722:	87aa                	mv	a5,a0
    80201724:	fcf42e23          	sw	a5,-36(s0)
    80201728:	fdc42783          	lw	a5,-36(s0)
    8020172c:	0007871b          	sext.w	a4,a5
    80201730:	47b5                	li	a5,13
    80201732:	00f70963          	beq	a4,a5,80201744 <uart_read_line+0x5e>
    80201736:	fdc42783          	lw	a5,-36(s0)
    8020173a:	0007871b          	sext.w	a4,a5
    8020173e:	47a9                	li	a5,10
    80201740:	02f71563          	bne	a4,a5,8020176a <uart_read_line+0x84>
    80201744:	fdc42783          	lw	a5,-36(s0)
    80201748:	0007871b          	sext.w	a4,a5
    8020174c:	47b5                	li	a5,13
    8020174e:	0cf71963          	bne	a4,a5,80201820 <uart_read_line+0x13a>
    80201752:	4515                	li	a0,5
    80201754:	be1ff0ef          	jal	80201334 <uart_read_reg>
    80201758:	87aa                	mv	a5,a0
    8020175a:	2781                	sext.w	a5,a5
    8020175c:	8b85                	andi	a5,a5,1
    8020175e:	2781                	sext.w	a5,a5
    80201760:	c3e1                	beqz	a5,80201820 <uart_read_line+0x13a>
    80201762:	4501                	li	a0,0
    80201764:	bd1ff0ef          	jal	80201334 <uart_read_reg>
    80201768:	a865                	j	80201820 <uart_read_line+0x13a>
    8020176a:	fdc42783          	lw	a5,-36(s0)
    8020176e:	0007871b          	sext.w	a4,a5
    80201772:	478d                	li	a5,3
    80201774:	08f70963          	beq	a4,a5,80201806 <uart_read_line+0x120>
    80201778:	fdc42783          	lw	a5,-36(s0)
    8020177c:	0007871b          	sext.w	a4,a5
    80201780:	47a1                	li	a5,8
    80201782:	00f70a63          	beq	a4,a5,80201796 <uart_read_line+0xb0>
    80201786:	fdc42783          	lw	a5,-36(s0)
    8020178a:	0007871b          	sext.w	a4,a5
    8020178e:	07f00793          	li	a5,127
    80201792:	02f71363          	bne	a4,a5,802017b8 <uart_read_line+0xd2>
    80201796:	fec42783          	lw	a5,-20(s0)
    8020179a:	2781                	sext.w	a5,a5
    8020179c:	06f05763          	blez	a5,8020180a <uart_read_line+0x124>
    802017a0:	fec42783          	lw	a5,-20(s0)
    802017a4:	37fd                	addiw	a5,a5,-1
    802017a6:	fef42623          	sw	a5,-20(s0)
    802017aa:	00006517          	auipc	a0,0x6
    802017ae:	7a650513          	addi	a0,a0,1958 # 80207f50 <user_code_end+0x580>
    802017b2:	cf1ff0ef          	jal	802014a2 <uart_puts>
    802017b6:	a891                	j	8020180a <uart_read_line+0x124>
    802017b8:	fdc42783          	lw	a5,-36(s0)
    802017bc:	0007871b          	sext.w	a4,a5
    802017c0:	47fd                	li	a5,31
    802017c2:	04e7d563          	bge	a5,a4,8020180c <uart_read_line+0x126>
    802017c6:	fdc42783          	lw	a5,-36(s0)
    802017ca:	0007871b          	sext.w	a4,a5
    802017ce:	07e00793          	li	a5,126
    802017d2:	02e7cd63          	blt	a5,a4,8020180c <uart_read_line+0x126>
    802017d6:	fec42783          	lw	a5,-20(s0)
    802017da:	0017871b          	addiw	a4,a5,1
    802017de:	fee42623          	sw	a4,-20(s0)
    802017e2:	873e                	mv	a4,a5
    802017e4:	fc843783          	ld	a5,-56(s0)
    802017e8:	97ba                	add	a5,a5,a4
    802017ea:	fdc42703          	lw	a4,-36(s0)
    802017ee:	0ff77713          	zext.b	a4,a4
    802017f2:	00e78023          	sb	a4,0(a5)
    802017f6:	fdc42783          	lw	a5,-36(s0)
    802017fa:	0ff7f793          	zext.b	a5,a5
    802017fe:	853e                	mv	a0,a5
    80201800:	c55ff0ef          	jal	80201454 <uart_putc>
    80201804:	a021                	j	8020180c <uart_read_line+0x126>
    80201806:	0001                	nop
    80201808:	a011                	j	8020180c <uart_read_line+0x126>
    8020180a:	0001                	nop
    8020180c:	fc442783          	lw	a5,-60(s0)
    80201810:	37fd                	addiw	a5,a5,-1
    80201812:	2781                	sext.w	a5,a5
    80201814:	fec42703          	lw	a4,-20(s0)
    80201818:	2701                	sext.w	a4,a4
    8020181a:	f0f742e3          	blt	a4,a5,8020171e <uart_read_line+0x38>
    8020181e:	a011                	j	80201822 <uart_read_line+0x13c>
    80201820:	0001                	nop
    80201822:	fec42783          	lw	a5,-20(s0)
    80201826:	fc843703          	ld	a4,-56(s0)
    8020182a:	97ba                	add	a5,a5,a4
    8020182c:	00078023          	sb	zero,0(a5)
    80201830:	00006517          	auipc	a0,0x6
    80201834:	72850513          	addi	a0,a0,1832 # 80207f58 <user_code_end+0x588>
    80201838:	c6bff0ef          	jal	802014a2 <uart_puts>
    8020183c:	fe043503          	ld	a0,-32(s0)
    80201840:	b75ff0ef          	jal	802013b4 <uart_irq_restore>
    80201844:	fec42783          	lw	a5,-20(s0)
    80201848:	853e                	mv	a0,a5
    8020184a:	70e2                	ld	ra,56(sp)
    8020184c:	7442                	ld	s0,48(sp)
    8020184e:	6121                	addi	sp,sp,64
    80201850:	8082                	ret

0000000080201852 <uart_prompt_and_read_line>:
    80201852:	7139                	addi	sp,sp,-64
    80201854:	fc06                	sd	ra,56(sp)
    80201856:	f822                	sd	s0,48(sp)
    80201858:	0080                	addi	s0,sp,64
    8020185a:	fca43c23          	sd	a0,-40(s0)
    8020185e:	fcb43823          	sd	a1,-48(s0)
    80201862:	87b2                	mv	a5,a2
    80201864:	fcf42623          	sw	a5,-52(s0)
    80201868:	b2bff0ef          	jal	80201392 <uart_irq_save>
    8020186c:	fea43423          	sd	a0,-24(s0)
    80201870:	fd843783          	ld	a5,-40(s0)
    80201874:	c789                	beqz	a5,8020187e <uart_prompt_and_read_line+0x2c>
    80201876:	fd843503          	ld	a0,-40(s0)
    8020187a:	c29ff0ef          	jal	802014a2 <uart_puts>
    8020187e:	ce1ff0ef          	jal	8020155e <uart_rx_flush>
    80201882:	fcc42783          	lw	a5,-52(s0)
    80201886:	85be                	mv	a1,a5
    80201888:	fd043503          	ld	a0,-48(s0)
    8020188c:	e5bff0ef          	jal	802016e6 <uart_read_line>
    80201890:	87aa                	mv	a5,a0
    80201892:	fef42223          	sw	a5,-28(s0)
    80201896:	fe843503          	ld	a0,-24(s0)
    8020189a:	b1bff0ef          	jal	802013b4 <uart_irq_restore>
    8020189e:	fe442783          	lw	a5,-28(s0)
    802018a2:	853e                	mv	a0,a5
    802018a4:	70e2                	ld	ra,56(sp)
    802018a6:	7442                	ld	s0,48(sp)
    802018a8:	6121                	addi	sp,sp,64
    802018aa:	8082                	ret

00000000802018ac <uart_hw_test>:
    802018ac:	1101                	addi	sp,sp,-32
    802018ae:	ec06                	sd	ra,24(sp)
    802018b0:	e822                	sd	s0,16(sp)
    802018b2:	1000                	addi	s0,sp,32
    802018b4:	00006517          	auipc	a0,0x6
    802018b8:	6ac50513          	addi	a0,a0,1708 # 80207f60 <user_code_end+0x590>
    802018bc:	be7ff0ef          	jal	802014a2 <uart_puts>
    802018c0:	c1dff0ef          	jal	802014dc <uart_try_getc>
    802018c4:	87aa                	mv	a5,a0
    802018c6:	fef42623          	sw	a5,-20(s0)
    802018ca:	fec42783          	lw	a5,-20(s0)
    802018ce:	2781                	sext.w	a5,a5
    802018d0:	0207c663          	bltz	a5,802018fc <uart_hw_test+0x50>
    802018d4:	00006517          	auipc	a0,0x6
    802018d8:	6bc50513          	addi	a0,a0,1724 # 80207f90 <user_code_end+0x5c0>
    802018dc:	bc7ff0ef          	jal	802014a2 <uart_puts>
    802018e0:	fec42783          	lw	a5,-20(s0)
    802018e4:	0ff7f793          	zext.b	a5,a5
    802018e8:	853e                	mv	a0,a5
    802018ea:	b6bff0ef          	jal	80201454 <uart_putc>
    802018ee:	00006517          	auipc	a0,0x6
    802018f2:	66a50513          	addi	a0,a0,1642 # 80207f58 <user_code_end+0x588>
    802018f6:	badff0ef          	jal	802014a2 <uart_puts>
    802018fa:	b7d9                	j	802018c0 <uart_hw_test+0x14>
    802018fc:	0001                	nop
    802018fe:	b7c9                	j	802018c0 <uart_hw_test+0x14>

0000000080201900 <r_tp>:
    80201900:	1101                	addi	sp,sp,-32
    80201902:	ec06                	sd	ra,24(sp)
    80201904:	e822                	sd	s0,16(sp)
    80201906:	1000                	addi	s0,sp,32
    80201908:	8792                	mv	a5,tp
    8020190a:	fef43423          	sd	a5,-24(s0)
    8020190e:	fe843783          	ld	a5,-24(s0)
    80201912:	853e                	mv	a0,a5
    80201914:	60e2                	ld	ra,24(sp)
    80201916:	6442                	ld	s0,16(sp)
    80201918:	6105                	addi	sp,sp,32
    8020191a:	8082                	ret

000000008020191c <r_sie>:
    8020191c:	1101                	addi	sp,sp,-32
    8020191e:	ec06                	sd	ra,24(sp)
    80201920:	e822                	sd	s0,16(sp)
    80201922:	1000                	addi	s0,sp,32
    80201924:	104027f3          	csrr	a5,sie
    80201928:	fef43423          	sd	a5,-24(s0)
    8020192c:	fe843783          	ld	a5,-24(s0)
    80201930:	853e                	mv	a0,a5
    80201932:	60e2                	ld	ra,24(sp)
    80201934:	6442                	ld	s0,16(sp)
    80201936:	6105                	addi	sp,sp,32
    80201938:	8082                	ret

000000008020193a <w_sie>:
    8020193a:	1101                	addi	sp,sp,-32
    8020193c:	ec06                	sd	ra,24(sp)
    8020193e:	e822                	sd	s0,16(sp)
    80201940:	1000                	addi	s0,sp,32
    80201942:	fea43423          	sd	a0,-24(s0)
    80201946:	fe843783          	ld	a5,-24(s0)
    8020194a:	10479073          	csrw	sie,a5
    8020194e:	0001                	nop
    80201950:	60e2                	ld	ra,24(sp)
    80201952:	6442                	ld	s0,16(sp)
    80201954:	6105                	addi	sp,sp,32
    80201956:	8082                	ret

0000000080201958 <trap_ie_enable>:
    80201958:	1101                	addi	sp,sp,-32
    8020195a:	ec06                	sd	ra,24(sp)
    8020195c:	e822                	sd	s0,16(sp)
    8020195e:	1000                	addi	s0,sp,32
    80201960:	fea43423          	sd	a0,-24(s0)
    80201964:	fb9ff0ef          	jal	8020191c <r_sie>
    80201968:	872a                	mv	a4,a0
    8020196a:	fe843783          	ld	a5,-24(s0)
    8020196e:	8fd9                	or	a5,a5,a4
    80201970:	853e                	mv	a0,a5
    80201972:	fc9ff0ef          	jal	8020193a <w_sie>
    80201976:	0001                	nop
    80201978:	60e2                	ld	ra,24(sp)
    8020197a:	6442                	ld	s0,16(sp)
    8020197c:	6105                	addi	sp,sp,32
    8020197e:	8082                	ret

0000000080201980 <plic_init>:
    80201980:	1101                	addi	sp,sp,-32
    80201982:	ec06                	sd	ra,24(sp)
    80201984:	e822                	sd	s0,16(sp)
    80201986:	1000                	addi	s0,sp,32
    80201988:	f79ff0ef          	jal	80201900 <r_tp>
    8020198c:	87aa                	mv	a5,a0
    8020198e:	fef42623          	sw	a5,-20(s0)
    80201992:	fec42783          	lw	a5,-20(s0)
    80201996:	0017979b          	slliw	a5,a5,0x1
    8020199a:	2781                	sext.w	a5,a5
    8020199c:	2785                	addiw	a5,a5,1
    8020199e:	2781                	sext.w	a5,a5
    802019a0:	00c7979b          	slliw	a5,a5,0xc
    802019a4:	2781                	sext.w	a5,a5
    802019a6:	873e                	mv	a4,a5
    802019a8:	0c2007b7          	lui	a5,0xc200
    802019ac:	97ba                	add	a5,a5,a4
    802019ae:	0007a023          	sw	zero,0(a5) # c200000 <_heap_size+0x4319a38>
    802019b2:	20000513          	li	a0,512
    802019b6:	fa3ff0ef          	jal	80201958 <trap_ie_enable>
    802019ba:	0001                	nop
    802019bc:	60e2                	ld	ra,24(sp)
    802019be:	6442                	ld	s0,16(sp)
    802019c0:	6105                	addi	sp,sp,32
    802019c2:	8082                	ret

00000000802019c4 <plic_uart_enable>:
    802019c4:	1101                	addi	sp,sp,-32
    802019c6:	ec06                	sd	ra,24(sp)
    802019c8:	e822                	sd	s0,16(sp)
    802019ca:	1000                	addi	s0,sp,32
    802019cc:	f35ff0ef          	jal	80201900 <r_tp>
    802019d0:	87aa                	mv	a5,a0
    802019d2:	fef42623          	sw	a5,-20(s0)
    802019d6:	0c0007b7          	lui	a5,0xc000
    802019da:	02878793          	addi	a5,a5,40 # c000028 <_heap_size+0x4119a60>
    802019de:	4705                	li	a4,1
    802019e0:	c398                	sw	a4,0(a5)
    802019e2:	fec42783          	lw	a5,-20(s0)
    802019e6:	0017979b          	slliw	a5,a5,0x1
    802019ea:	2781                	sext.w	a5,a5
    802019ec:	2785                	addiw	a5,a5,1
    802019ee:	2781                	sext.w	a5,a5
    802019f0:	0077979b          	slliw	a5,a5,0x7
    802019f4:	2781                	sext.w	a5,a5
    802019f6:	873e                	mv	a4,a5
    802019f8:	0c0027b7          	lui	a5,0xc002
    802019fc:	97ba                	add	a5,a5,a4
    802019fe:	873e                	mv	a4,a5
    80201a00:	40000793          	li	a5,1024
    80201a04:	c31c                	sw	a5,0(a4)
    80201a06:	0001                	nop
    80201a08:	60e2                	ld	ra,24(sp)
    80201a0a:	6442                	ld	s0,16(sp)
    80201a0c:	6105                	addi	sp,sp,32
    80201a0e:	8082                	ret

0000000080201a10 <plic_claim>:
    80201a10:	1101                	addi	sp,sp,-32
    80201a12:	ec06                	sd	ra,24(sp)
    80201a14:	e822                	sd	s0,16(sp)
    80201a16:	1000                	addi	s0,sp,32
    80201a18:	ee9ff0ef          	jal	80201900 <r_tp>
    80201a1c:	87aa                	mv	a5,a0
    80201a1e:	fef42623          	sw	a5,-20(s0)
    80201a22:	fec42783          	lw	a5,-20(s0)
    80201a26:	0017979b          	slliw	a5,a5,0x1
    80201a2a:	2781                	sext.w	a5,a5
    80201a2c:	2785                	addiw	a5,a5,1 # c002001 <_heap_size+0x411ba39>
    80201a2e:	2781                	sext.w	a5,a5
    80201a30:	00c7979b          	slliw	a5,a5,0xc
    80201a34:	2781                	sext.w	a5,a5
    80201a36:	873e                	mv	a4,a5
    80201a38:	0c2007b7          	lui	a5,0xc200
    80201a3c:	0791                	addi	a5,a5,4 # c200004 <_heap_size+0x4319a3c>
    80201a3e:	97ba                	add	a5,a5,a4
    80201a40:	439c                	lw	a5,0(a5)
    80201a42:	853e                	mv	a0,a5
    80201a44:	60e2                	ld	ra,24(sp)
    80201a46:	6442                	ld	s0,16(sp)
    80201a48:	6105                	addi	sp,sp,32
    80201a4a:	8082                	ret

0000000080201a4c <plic_complete>:
    80201a4c:	7179                	addi	sp,sp,-48
    80201a4e:	f406                	sd	ra,40(sp)
    80201a50:	f022                	sd	s0,32(sp)
    80201a52:	1800                	addi	s0,sp,48
    80201a54:	87aa                	mv	a5,a0
    80201a56:	fcf42e23          	sw	a5,-36(s0)
    80201a5a:	ea7ff0ef          	jal	80201900 <r_tp>
    80201a5e:	87aa                	mv	a5,a0
    80201a60:	fef42623          	sw	a5,-20(s0)
    80201a64:	fec42783          	lw	a5,-20(s0)
    80201a68:	0017979b          	slliw	a5,a5,0x1
    80201a6c:	2781                	sext.w	a5,a5
    80201a6e:	2785                	addiw	a5,a5,1
    80201a70:	2781                	sext.w	a5,a5
    80201a72:	00c7979b          	slliw	a5,a5,0xc
    80201a76:	2781                	sext.w	a5,a5
    80201a78:	873e                	mv	a4,a5
    80201a7a:	0c2007b7          	lui	a5,0xc200
    80201a7e:	0791                	addi	a5,a5,4 # c200004 <_heap_size+0x4319a3c>
    80201a80:	97ba                	add	a5,a5,a4
    80201a82:	873e                	mv	a4,a5
    80201a84:	fdc42783          	lw	a5,-36(s0)
    80201a88:	c31c                	sw	a5,0(a4)
    80201a8a:	0001                	nop
    80201a8c:	70a2                	ld	ra,40(sp)
    80201a8e:	7402                	ld	s0,32(sp)
    80201a90:	6145                	addi	sp,sp,48
    80201a92:	8082                	ret

0000000080201a94 <r_sie>:
    80201a94:	1101                	addi	sp,sp,-32
    80201a96:	ec06                	sd	ra,24(sp)
    80201a98:	e822                	sd	s0,16(sp)
    80201a9a:	1000                	addi	s0,sp,32
    80201a9c:	104027f3          	csrr	a5,sie
    80201aa0:	fef43423          	sd	a5,-24(s0)
    80201aa4:	fe843783          	ld	a5,-24(s0)
    80201aa8:	853e                	mv	a0,a5
    80201aaa:	60e2                	ld	ra,24(sp)
    80201aac:	6442                	ld	s0,16(sp)
    80201aae:	6105                	addi	sp,sp,32
    80201ab0:	8082                	ret

0000000080201ab2 <w_sie>:
    80201ab2:	1101                	addi	sp,sp,-32
    80201ab4:	ec06                	sd	ra,24(sp)
    80201ab6:	e822                	sd	s0,16(sp)
    80201ab8:	1000                	addi	s0,sp,32
    80201aba:	fea43423          	sd	a0,-24(s0)
    80201abe:	fe843783          	ld	a5,-24(s0)
    80201ac2:	10479073          	csrw	sie,a5
    80201ac6:	0001                	nop
    80201ac8:	60e2                	ld	ra,24(sp)
    80201aca:	6442                	ld	s0,16(sp)
    80201acc:	6105                	addi	sp,sp,32
    80201ace:	8082                	ret

0000000080201ad0 <trap_ie_enable>:
    80201ad0:	1101                	addi	sp,sp,-32
    80201ad2:	ec06                	sd	ra,24(sp)
    80201ad4:	e822                	sd	s0,16(sp)
    80201ad6:	1000                	addi	s0,sp,32
    80201ad8:	fea43423          	sd	a0,-24(s0)
    80201adc:	fb9ff0ef          	jal	80201a94 <r_sie>
    80201ae0:	872a                	mv	a4,a0
    80201ae2:	fe843783          	ld	a5,-24(s0)
    80201ae6:	8fd9                	or	a5,a5,a4
    80201ae8:	853e                	mv	a0,a5
    80201aea:	fc9ff0ef          	jal	80201ab2 <w_sie>
    80201aee:	0001                	nop
    80201af0:	60e2                	ld	ra,24(sp)
    80201af2:	6442                	ld	s0,16(sp)
    80201af4:	6105                	addi	sp,sp,32
    80201af6:	8082                	ret

0000000080201af8 <r_time>:
    80201af8:	1101                	addi	sp,sp,-32
    80201afa:	ec06                	sd	ra,24(sp)
    80201afc:	e822                	sd	s0,16(sp)
    80201afe:	1000                	addi	s0,sp,32
    80201b00:	c01027f3          	rdtime	a5
    80201b04:	fef43423          	sd	a5,-24(s0)
    80201b08:	fe843783          	ld	a5,-24(s0)
    80201b0c:	853e                	mv	a0,a5
    80201b0e:	60e2                	ld	ra,24(sp)
    80201b10:	6442                	ld	s0,16(sp)
    80201b12:	6105                	addi	sp,sp,32
    80201b14:	8082                	ret

0000000080201b16 <sbi_set_timer>:
    80201b16:	1101                	addi	sp,sp,-32
    80201b18:	ec06                	sd	ra,24(sp)
    80201b1a:	e822                	sd	s0,16(sp)
    80201b1c:	1000                	addi	s0,sp,32
    80201b1e:	fea43423          	sd	a0,-24(s0)
    80201b22:	fe843503          	ld	a0,-24(s0)
    80201b26:	4881                	li	a7,0
    80201b28:	00000073          	ecall
    80201b2c:	0001                	nop
    80201b2e:	60e2                	ld	ra,24(sp)
    80201b30:	6442                	ld	s0,16(sp)
    80201b32:	6105                	addi	sp,sp,32
    80201b34:	8082                	ret

0000000080201b36 <timer_load>:
    80201b36:	1101                	addi	sp,sp,-32
    80201b38:	ec06                	sd	ra,24(sp)
    80201b3a:	e822                	sd	s0,16(sp)
    80201b3c:	1000                	addi	s0,sp,32
    80201b3e:	87aa                	mv	a5,a0
    80201b40:	fef42623          	sw	a5,-20(s0)
    80201b44:	fb5ff0ef          	jal	80201af8 <r_time>
    80201b48:	872a                	mv	a4,a0
    80201b4a:	fec42783          	lw	a5,-20(s0)
    80201b4e:	97ba                	add	a5,a5,a4
    80201b50:	853e                	mv	a0,a5
    80201b52:	fc5ff0ef          	jal	80201b16 <sbi_set_timer>
    80201b56:	0001                	nop
    80201b58:	60e2                	ld	ra,24(sp)
    80201b5a:	6442                	ld	s0,16(sp)
    80201b5c:	6105                	addi	sp,sp,32
    80201b5e:	8082                	ret

0000000080201b60 <timer_init>:
    80201b60:	1101                	addi	sp,sp,-32
    80201b62:	ec06                	sd	ra,24(sp)
    80201b64:	e822                	sd	s0,16(sp)
    80201b66:	1000                	addi	s0,sp,32
    80201b68:	0000e797          	auipc	a5,0xe
    80201b6c:	95878793          	addi	a5,a5,-1704 # 8020f4c0 <timer_list>
    80201b70:	fef43423          	sd	a5,-24(s0)
    80201b74:	fe042223          	sw	zero,-28(s0)
    80201b78:	a01d                	j	80201b9e <timer_init+0x3e>
    80201b7a:	fe843783          	ld	a5,-24(s0)
    80201b7e:	0007b023          	sd	zero,0(a5)
    80201b82:	fe843783          	ld	a5,-24(s0)
    80201b86:	0007b423          	sd	zero,8(a5)
    80201b8a:	fe843783          	ld	a5,-24(s0)
    80201b8e:	07e1                	addi	a5,a5,24
    80201b90:	fef43423          	sd	a5,-24(s0)
    80201b94:	fe442783          	lw	a5,-28(s0)
    80201b98:	2785                	addiw	a5,a5,1
    80201b9a:	fef42223          	sw	a5,-28(s0)
    80201b9e:	fe442783          	lw	a5,-28(s0)
    80201ba2:	0007871b          	sext.w	a4,a5
    80201ba6:	47a5                	li	a5,9
    80201ba8:	fce7d9e3          	bge	a5,a4,80201b7a <timer_init+0x1a>
    80201bac:	67e1                	lui	a5,0x18
    80201bae:	6a078513          	addi	a0,a5,1696 # 186a0 <STACK_SIZE+0x176a0>
    80201bb2:	f85ff0ef          	jal	80201b36 <timer_load>
    80201bb6:	02000513          	li	a0,32
    80201bba:	f17ff0ef          	jal	80201ad0 <trap_ie_enable>
    80201bbe:	0001                	nop
    80201bc0:	60e2                	ld	ra,24(sp)
    80201bc2:	6442                	ld	s0,16(sp)
    80201bc4:	6105                	addi	sp,sp,32
    80201bc6:	8082                	ret

0000000080201bc8 <timer_create>:
    80201bc8:	7139                	addi	sp,sp,-64
    80201bca:	fc06                	sd	ra,56(sp)
    80201bcc:	f822                	sd	s0,48(sp)
    80201bce:	0080                	addi	s0,sp,64
    80201bd0:	fca43c23          	sd	a0,-40(s0)
    80201bd4:	fcb43823          	sd	a1,-48(s0)
    80201bd8:	87b2                	mv	a5,a2
    80201bda:	fcf42623          	sw	a5,-52(s0)
    80201bde:	fd843783          	ld	a5,-40(s0)
    80201be2:	c789                	beqz	a5,80201bec <timer_create+0x24>
    80201be4:	fcc42783          	lw	a5,-52(s0)
    80201be8:	2781                	sext.w	a5,a5
    80201bea:	e399                	bnez	a5,80201bf0 <timer_create+0x28>
    80201bec:	4781                	li	a5,0
    80201bee:	a071                	j	80201c7a <timer_create+0xb2>
    80201bf0:	168010ef          	jal	80202d58 <spin_lock>
    80201bf4:	0000e797          	auipc	a5,0xe
    80201bf8:	8cc78793          	addi	a5,a5,-1844 # 8020f4c0 <timer_list>
    80201bfc:	fef43423          	sd	a5,-24(s0)
    80201c00:	fe042223          	sw	zero,-28(s0)
    80201c04:	a839                	j	80201c22 <timer_create+0x5a>
    80201c06:	fe843783          	ld	a5,-24(s0)
    80201c0a:	639c                	ld	a5,0(a5)
    80201c0c:	c39d                	beqz	a5,80201c32 <timer_create+0x6a>
    80201c0e:	fe843783          	ld	a5,-24(s0)
    80201c12:	07e1                	addi	a5,a5,24
    80201c14:	fef43423          	sd	a5,-24(s0)
    80201c18:	fe442783          	lw	a5,-28(s0)
    80201c1c:	2785                	addiw	a5,a5,1
    80201c1e:	fef42223          	sw	a5,-28(s0)
    80201c22:	fe442783          	lw	a5,-28(s0)
    80201c26:	0007871b          	sext.w	a4,a5
    80201c2a:	47a5                	li	a5,9
    80201c2c:	fce7dde3          	bge	a5,a4,80201c06 <timer_create+0x3e>
    80201c30:	a011                	j	80201c34 <timer_create+0x6c>
    80201c32:	0001                	nop
    80201c34:	fe843783          	ld	a5,-24(s0)
    80201c38:	639c                	ld	a5,0(a5)
    80201c3a:	c789                	beqz	a5,80201c44 <timer_create+0x7c>
    80201c3c:	134010ef          	jal	80202d70 <spin_unlock>
    80201c40:	4781                	li	a5,0
    80201c42:	a825                	j	80201c7a <timer_create+0xb2>
    80201c44:	fe843783          	ld	a5,-24(s0)
    80201c48:	fd843703          	ld	a4,-40(s0)
    80201c4c:	e398                	sd	a4,0(a5)
    80201c4e:	fe843783          	ld	a5,-24(s0)
    80201c52:	fd043703          	ld	a4,-48(s0)
    80201c56:	e798                	sd	a4,8(a5)
    80201c58:	0000e797          	auipc	a5,0xe
    80201c5c:	86078793          	addi	a5,a5,-1952 # 8020f4b8 <_tick>
    80201c60:	439c                	lw	a5,0(a5)
    80201c62:	fcc42703          	lw	a4,-52(s0)
    80201c66:	9fb9                	addw	a5,a5,a4
    80201c68:	0007871b          	sext.w	a4,a5
    80201c6c:	fe843783          	ld	a5,-24(s0)
    80201c70:	cb98                	sw	a4,16(a5)
    80201c72:	0fe010ef          	jal	80202d70 <spin_unlock>
    80201c76:	fe843783          	ld	a5,-24(s0)
    80201c7a:	853e                	mv	a0,a5
    80201c7c:	70e2                	ld	ra,56(sp)
    80201c7e:	7442                	ld	s0,48(sp)
    80201c80:	6121                	addi	sp,sp,64
    80201c82:	8082                	ret

0000000080201c84 <timer_delete>:
    80201c84:	7179                	addi	sp,sp,-48
    80201c86:	f406                	sd	ra,40(sp)
    80201c88:	f022                	sd	s0,32(sp)
    80201c8a:	1800                	addi	s0,sp,48
    80201c8c:	fca43c23          	sd	a0,-40(s0)
    80201c90:	0c8010ef          	jal	80202d58 <spin_lock>
    80201c94:	0000e797          	auipc	a5,0xe
    80201c98:	82c78793          	addi	a5,a5,-2004 # 8020f4c0 <timer_list>
    80201c9c:	fef43423          	sd	a5,-24(s0)
    80201ca0:	fe042223          	sw	zero,-28(s0)
    80201ca4:	a815                	j	80201cd8 <timer_delete+0x54>
    80201ca6:	fe843703          	ld	a4,-24(s0)
    80201caa:	fd843783          	ld	a5,-40(s0)
    80201cae:	00f71b63          	bne	a4,a5,80201cc4 <timer_delete+0x40>
    80201cb2:	fe843783          	ld	a5,-24(s0)
    80201cb6:	0007b023          	sd	zero,0(a5)
    80201cba:	fe843783          	ld	a5,-24(s0)
    80201cbe:	0007b423          	sd	zero,8(a5)
    80201cc2:	a015                	j	80201ce6 <timer_delete+0x62>
    80201cc4:	fe843783          	ld	a5,-24(s0)
    80201cc8:	07e1                	addi	a5,a5,24
    80201cca:	fef43423          	sd	a5,-24(s0)
    80201cce:	fe442783          	lw	a5,-28(s0)
    80201cd2:	2785                	addiw	a5,a5,1
    80201cd4:	fef42223          	sw	a5,-28(s0)
    80201cd8:	fe442783          	lw	a5,-28(s0)
    80201cdc:	0007871b          	sext.w	a4,a5
    80201ce0:	47a5                	li	a5,9
    80201ce2:	fce7d2e3          	bge	a5,a4,80201ca6 <timer_delete+0x22>
    80201ce6:	08a010ef          	jal	80202d70 <spin_unlock>
    80201cea:	0001                	nop
    80201cec:	70a2                	ld	ra,40(sp)
    80201cee:	7402                	ld	s0,32(sp)
    80201cf0:	6145                	addi	sp,sp,48
    80201cf2:	8082                	ret

0000000080201cf4 <timer_check>:
    80201cf4:	1101                	addi	sp,sp,-32
    80201cf6:	ec06                	sd	ra,24(sp)
    80201cf8:	e822                	sd	s0,16(sp)
    80201cfa:	1000                	addi	s0,sp,32
    80201cfc:	0000d797          	auipc	a5,0xd
    80201d00:	7c478793          	addi	a5,a5,1988 # 8020f4c0 <timer_list>
    80201d04:	fef43423          	sd	a5,-24(s0)
    80201d08:	fe042223          	sw	zero,-28(s0)
    80201d0c:	a891                	j	80201d60 <timer_check+0x6c>
    80201d0e:	fe843783          	ld	a5,-24(s0)
    80201d12:	639c                	ld	a5,0(a5)
    80201d14:	cf85                	beqz	a5,80201d4c <timer_check+0x58>
    80201d16:	fe843783          	ld	a5,-24(s0)
    80201d1a:	4b98                	lw	a4,16(a5)
    80201d1c:	0000d797          	auipc	a5,0xd
    80201d20:	79c78793          	addi	a5,a5,1948 # 8020f4b8 <_tick>
    80201d24:	439c                	lw	a5,0(a5)
    80201d26:	02e7e363          	bltu	a5,a4,80201d4c <timer_check+0x58>
    80201d2a:	fe843783          	ld	a5,-24(s0)
    80201d2e:	639c                	ld	a5,0(a5)
    80201d30:	fe843703          	ld	a4,-24(s0)
    80201d34:	6718                	ld	a4,8(a4)
    80201d36:	853a                	mv	a0,a4
    80201d38:	9782                	jalr	a5
    80201d3a:	fe843783          	ld	a5,-24(s0)
    80201d3e:	0007b023          	sd	zero,0(a5)
    80201d42:	fe843783          	ld	a5,-24(s0)
    80201d46:	0007b423          	sd	zero,8(a5)
    80201d4a:	a01d                	j	80201d70 <timer_check+0x7c>
    80201d4c:	fe843783          	ld	a5,-24(s0)
    80201d50:	07e1                	addi	a5,a5,24
    80201d52:	fef43423          	sd	a5,-24(s0)
    80201d56:	fe442783          	lw	a5,-28(s0)
    80201d5a:	2785                	addiw	a5,a5,1
    80201d5c:	fef42223          	sw	a5,-28(s0)
    80201d60:	fe442783          	lw	a5,-28(s0)
    80201d64:	0007871b          	sext.w	a4,a5
    80201d68:	47a5                	li	a5,9
    80201d6a:	fae7d2e3          	bge	a5,a4,80201d0e <timer_check+0x1a>
    80201d6e:	0001                	nop
    80201d70:	0001                	nop
    80201d72:	60e2                	ld	ra,24(sp)
    80201d74:	6442                	ld	s0,16(sp)
    80201d76:	6105                	addi	sp,sp,32
    80201d78:	8082                	ret

0000000080201d7a <timer_handler>:
    80201d7a:	1141                	addi	sp,sp,-16
    80201d7c:	e406                	sd	ra,8(sp)
    80201d7e:	e022                	sd	s0,0(sp)
    80201d80:	0800                	addi	s0,sp,16
    80201d82:	0000d797          	auipc	a5,0xd
    80201d86:	73678793          	addi	a5,a5,1846 # 8020f4b8 <_tick>
    80201d8a:	439c                	lw	a5,0(a5)
    80201d8c:	2785                	addiw	a5,a5,1
    80201d8e:	0007871b          	sext.w	a4,a5
    80201d92:	0000d797          	auipc	a5,0xd
    80201d96:	72678793          	addi	a5,a5,1830 # 8020f4b8 <_tick>
    80201d9a:	c398                	sw	a4,0(a5)
    80201d9c:	c12ff0ef          	jal	802011ae <stats_inc_timer>
    80201da0:	f55ff0ef          	jal	80201cf4 <timer_check>
    80201da4:	67e1                	lui	a5,0x18
    80201da6:	6a078513          	addi	a0,a5,1696 # 186a0 <STACK_SIZE+0x176a0>
    80201daa:	d8dff0ef          	jal	80201b36 <timer_load>
    80201dae:	0001                	nop
    80201db0:	60a2                	ld	ra,8(sp)
    80201db2:	6402                	ld	s0,0(sp)
    80201db4:	0141                	addi	sp,sp,16
    80201db6:	8082                	ret

0000000080201db8 <r_sstatus>:
    80201db8:	1101                	addi	sp,sp,-32
    80201dba:	ec06                	sd	ra,24(sp)
    80201dbc:	e822                	sd	s0,16(sp)
    80201dbe:	1000                	addi	s0,sp,32
    80201dc0:	100027f3          	csrr	a5,sstatus
    80201dc4:	fef43423          	sd	a5,-24(s0)
    80201dc8:	fe843783          	ld	a5,-24(s0)
    80201dcc:	853e                	mv	a0,a5
    80201dce:	60e2                	ld	ra,24(sp)
    80201dd0:	6442                	ld	s0,16(sp)
    80201dd2:	6105                	addi	sp,sp,32
    80201dd4:	8082                	ret

0000000080201dd6 <w_sstatus>:
    80201dd6:	1101                	addi	sp,sp,-32
    80201dd8:	ec06                	sd	ra,24(sp)
    80201dda:	e822                	sd	s0,16(sp)
    80201ddc:	1000                	addi	s0,sp,32
    80201dde:	fea43423          	sd	a0,-24(s0)
    80201de2:	fe843783          	ld	a5,-24(s0)
    80201de6:	10079073          	csrw	sstatus,a5
    80201dea:	0001                	nop
    80201dec:	60e2                	ld	ra,24(sp)
    80201dee:	6442                	ld	s0,16(sp)
    80201df0:	6105                	addi	sp,sp,32
    80201df2:	8082                	ret

0000000080201df4 <w_sscratch>:
    80201df4:	1101                	addi	sp,sp,-32
    80201df6:	ec06                	sd	ra,24(sp)
    80201df8:	e822                	sd	s0,16(sp)
    80201dfa:	1000                	addi	s0,sp,32
    80201dfc:	fea43423          	sd	a0,-24(s0)
    80201e00:	fe843783          	ld	a5,-24(s0)
    80201e04:	14079073          	csrw	sscratch,a5
    80201e08:	0001                	nop
    80201e0a:	60e2                	ld	ra,24(sp)
    80201e0c:	6442                	ld	s0,16(sp)
    80201e0e:	6105                	addi	sp,sp,32
    80201e10:	8082                	ret

0000000080201e12 <w_stvec>:
    80201e12:	1101                	addi	sp,sp,-32
    80201e14:	ec06                	sd	ra,24(sp)
    80201e16:	e822                	sd	s0,16(sp)
    80201e18:	1000                	addi	s0,sp,32
    80201e1a:	fea43423          	sd	a0,-24(s0)
    80201e1e:	fe843783          	ld	a5,-24(s0)
    80201e22:	10579073          	csrw	stvec,a5
    80201e26:	0001                	nop
    80201e28:	60e2                	ld	ra,24(sp)
    80201e2a:	6442                	ld	s0,16(sp)
    80201e2c:	6105                	addi	sp,sp,32
    80201e2e:	8082                	ret

0000000080201e30 <r_sip>:
    80201e30:	1101                	addi	sp,sp,-32
    80201e32:	ec06                	sd	ra,24(sp)
    80201e34:	e822                	sd	s0,16(sp)
    80201e36:	1000                	addi	s0,sp,32
    80201e38:	144027f3          	csrr	a5,sip
    80201e3c:	fef43423          	sd	a5,-24(s0)
    80201e40:	fe843783          	ld	a5,-24(s0)
    80201e44:	853e                	mv	a0,a5
    80201e46:	60e2                	ld	ra,24(sp)
    80201e48:	6442                	ld	s0,16(sp)
    80201e4a:	6105                	addi	sp,sp,32
    80201e4c:	8082                	ret

0000000080201e4e <w_sip>:
    80201e4e:	1101                	addi	sp,sp,-32
    80201e50:	ec06                	sd	ra,24(sp)
    80201e52:	e822                	sd	s0,16(sp)
    80201e54:	1000                	addi	s0,sp,32
    80201e56:	fea43423          	sd	a0,-24(s0)
    80201e5a:	fe843783          	ld	a5,-24(s0)
    80201e5e:	14479073          	csrw	sip,a5
    80201e62:	0001                	nop
    80201e64:	60e2                	ld	ra,24(sp)
    80201e66:	6442                	ld	s0,16(sp)
    80201e68:	6105                	addi	sp,sp,32
    80201e6a:	8082                	ret

0000000080201e6c <trap_vec_init>:
    80201e6c:	1101                	addi	sp,sp,-32
    80201e6e:	ec06                	sd	ra,24(sp)
    80201e70:	e822                	sd	s0,16(sp)
    80201e72:	1000                	addi	s0,sp,32
    80201e74:	fea43423          	sd	a0,-24(s0)
    80201e78:	fe843503          	ld	a0,-24(s0)
    80201e7c:	f97ff0ef          	jal	80201e12 <w_stvec>
    80201e80:	0001                	nop
    80201e82:	60e2                	ld	ra,24(sp)
    80201e84:	6442                	ld	s0,16(sp)
    80201e86:	6105                	addi	sp,sp,32
    80201e88:	8082                	ret

0000000080201e8a <trap_scratch_init>:
    80201e8a:	1101                	addi	sp,sp,-32
    80201e8c:	ec06                	sd	ra,24(sp)
    80201e8e:	e822                	sd	s0,16(sp)
    80201e90:	1000                	addi	s0,sp,32
    80201e92:	fea43423          	sd	a0,-24(s0)
    80201e96:	fe843503          	ld	a0,-24(s0)
    80201e9a:	f5bff0ef          	jal	80201df4 <w_sscratch>
    80201e9e:	0001                	nop
    80201ea0:	60e2                	ld	ra,24(sp)
    80201ea2:	6442                	ld	s0,16(sp)
    80201ea4:	6105                	addi	sp,sp,32
    80201ea6:	8082                	ret

0000000080201ea8 <cpu_irq_disable>:
    80201ea8:	1141                	addi	sp,sp,-16
    80201eaa:	e406                	sd	ra,8(sp)
    80201eac:	e022                	sd	s0,0(sp)
    80201eae:	0800                	addi	s0,sp,16
    80201eb0:	f09ff0ef          	jal	80201db8 <r_sstatus>
    80201eb4:	87aa                	mv	a5,a0
    80201eb6:	9bf5                	andi	a5,a5,-3
    80201eb8:	853e                	mv	a0,a5
    80201eba:	f1dff0ef          	jal	80201dd6 <w_sstatus>
    80201ebe:	0001                	nop
    80201ec0:	60a2                	ld	ra,8(sp)
    80201ec2:	6402                	ld	s0,0(sp)
    80201ec4:	0141                	addi	sp,sp,16
    80201ec6:	8082                	ret

0000000080201ec8 <epc_in_user>:
    80201ec8:	1101                	addi	sp,sp,-32
    80201eca:	ec06                	sd	ra,24(sp)
    80201ecc:	e822                	sd	s0,16(sp)
    80201ece:	1000                	addi	s0,sp,32
    80201ed0:	fea43423          	sd	a0,-24(s0)
    80201ed4:	fe843703          	ld	a4,-24(s0)
    80201ed8:	010077b7          	lui	a5,0x1007
    80201edc:	079e                	slli	a5,a5,0x7
    80201ede:	00f76b63          	bltu	a4,a5,80201ef4 <epc_in_user+0x2c>
    80201ee2:	fe843703          	ld	a4,-24(s0)
    80201ee6:	20100793          	li	a5,513
    80201eea:	07da                	slli	a5,a5,0x16
    80201eec:	00f77463          	bgeu	a4,a5,80201ef4 <epc_in_user+0x2c>
    80201ef0:	4785                	li	a5,1
    80201ef2:	a011                	j	80201ef6 <epc_in_user+0x2e>
    80201ef4:	4781                	li	a5,0
    80201ef6:	853e                	mv	a0,a5
    80201ef8:	60e2                	ld	ra,24(sp)
    80201efa:	6442                	ld	s0,16(sp)
    80201efc:	6105                	addi	sp,sp,32
    80201efe:	8082                	ret

0000000080201f00 <task_stack_lo>:
    80201f00:	1141                	addi	sp,sp,-16
    80201f02:	e406                	sd	ra,8(sp)
    80201f04:	e022                	sd	s0,0(sp)
    80201f06:	0800                	addi	s0,sp,16
    80201f08:	00013797          	auipc	a5,0x13
    80201f0c:	c2878793          	addi	a5,a5,-984 # 80214b30 <task_stack>
    80201f10:	853e                	mv	a0,a5
    80201f12:	60a2                	ld	ra,8(sp)
    80201f14:	6402                	ld	s0,0(sp)
    80201f16:	0141                	addi	sp,sp,16
    80201f18:	8082                	ret

0000000080201f1a <task_stack_hi>:
    80201f1a:	1141                	addi	sp,sp,-16
    80201f1c:	e406                	sd	ra,8(sp)
    80201f1e:	e022                	sd	s0,0(sp)
    80201f20:	0800                	addi	s0,sp,16
    80201f22:	fdfff0ef          	jal	80201f00 <task_stack_lo>
    80201f26:	872a                	mv	a4,a0
    80201f28:	678d                	lui	a5,0x3
    80201f2a:	80078793          	addi	a5,a5,-2048 # 2800 <STACK_SIZE+0x1800>
    80201f2e:	97ba                	add	a5,a5,a4
    80201f30:	853e                	mv	a0,a5
    80201f32:	60a2                	ld	ra,8(sp)
    80201f34:	6402                	ld	s0,0(sp)
    80201f36:	0141                	addi	sp,sp,16
    80201f38:	8082                	ret

0000000080201f3a <pc_in_task_stack>:
    80201f3a:	1101                	addi	sp,sp,-32
    80201f3c:	ec06                	sd	ra,24(sp)
    80201f3e:	e822                	sd	s0,16(sp)
    80201f40:	1000                	addi	s0,sp,32
    80201f42:	fea43423          	sd	a0,-24(s0)
    80201f46:	fbbff0ef          	jal	80201f00 <task_stack_lo>
    80201f4a:	872a                	mv	a4,a0
    80201f4c:	fe843783          	ld	a5,-24(s0)
    80201f50:	00e7eb63          	bltu	a5,a4,80201f66 <pc_in_task_stack+0x2c>
    80201f54:	fc7ff0ef          	jal	80201f1a <task_stack_hi>
    80201f58:	872a                	mv	a4,a0
    80201f5a:	fe843783          	ld	a5,-24(s0)
    80201f5e:	00e7f463          	bgeu	a5,a4,80201f66 <pc_in_task_stack+0x2c>
    80201f62:	4785                	li	a5,1
    80201f64:	a011                	j	80201f68 <pc_in_task_stack+0x2e>
    80201f66:	4781                	li	a5,0
    80201f68:	853e                	mv	a0,a5
    80201f6a:	60e2                	ld	ra,24(sp)
    80201f6c:	6442                	ld	s0,16(sp)
    80201f6e:	6105                	addi	sp,sp,32
    80201f70:	8082                	ret

0000000080201f72 <trap_check_return_pc>:
    80201f72:	1101                	addi	sp,sp,-32
    80201f74:	ec06                	sd	ra,24(sp)
    80201f76:	e822                	sd	s0,16(sp)
    80201f78:	1000                	addi	s0,sp,32
    80201f7a:	fea43423          	sd	a0,-24(s0)
    80201f7e:	feb43023          	sd	a1,-32(s0)
    80201f82:	fe843503          	ld	a0,-24(s0)
    80201f86:	fb5ff0ef          	jal	80201f3a <pc_in_task_stack>
    80201f8a:	87aa                	mv	a5,a0
    80201f8c:	cb95                	beqz	a5,80201fc0 <trap_check_return_pc+0x4e>
    80201f8e:	fe843783          	ld	a5,-24(s0)
    80201f92:	fe043703          	ld	a4,-32(s0)
    80201f96:	863a                	mv	a2,a4
    80201f98:	85be                	mv	a1,a5
    80201f9a:	00006517          	auipc	a0,0x6
    80201f9e:	ffe50513          	addi	a0,a0,-2 # 80207f98 <user_code_end+0x5c8>
    80201fa2:	914ff0ef          	jal	802010b6 <printf>
    80201fa6:	00006517          	auipc	a0,0x6
    80201faa:	02a50513          	addi	a0,a0,42 # 80207fd0 <user_code_end+0x600>
    80201fae:	62a000ef          	jal	802025d8 <trap_diag_print_csrs>
    80201fb2:	00006517          	auipc	a0,0x6
    80201fb6:	02e50513          	addi	a0,a0,46 # 80207fe0 <user_code_end+0x610>
    80201fba:	9c4ff0ef          	jal	8020117e <panic>
    80201fbe:	a011                	j	80201fc2 <trap_check_return_pc+0x50>
    80201fc0:	0001                	nop
    80201fc2:	60e2                	ld	ra,24(sp)
    80201fc4:	6442                	ld	s0,16(sp)
    80201fc6:	6105                	addi	sp,sp,32
    80201fc8:	8082                	ret

0000000080201fca <handle_sync_exception>:
    80201fca:	7119                	addi	sp,sp,-128
    80201fcc:	fc86                	sd	ra,120(sp)
    80201fce:	f8a2                	sd	s0,112(sp)
    80201fd0:	0100                	addi	s0,sp,128
    80201fd2:	f8a43c23          	sd	a0,-104(s0)
    80201fd6:	f8b43823          	sd	a1,-112(s0)
    80201fda:	f8c43423          	sd	a2,-120(s0)
    80201fde:	f8d43023          	sd	a3,-128(s0)
    80201fe2:	f9843703          	ld	a4,-104(s0)
    80201fe6:	47bd                	li	a5,15
    80201fe8:	0ef70663          	beq	a4,a5,802020d4 <handle_sync_exception+0x10a>
    80201fec:	f9843703          	ld	a4,-104(s0)
    80201ff0:	47bd                	li	a5,15
    80201ff2:	14e7e263          	bltu	a5,a4,80202136 <handle_sync_exception+0x16c>
    80201ff6:	f9843703          	ld	a4,-104(s0)
    80201ffa:	47a5                	li	a5,9
    80201ffc:	00e7e863          	bltu	a5,a4,8020200c <handle_sync_exception+0x42>
    80202000:	f9843703          	ld	a4,-104(s0)
    80202004:	47a1                	li	a5,8
    80202006:	00f77b63          	bgeu	a4,a5,8020201c <handle_sync_exception+0x52>
    8020200a:	a235                	j	80202136 <handle_sync_exception+0x16c>
    8020200c:	f9843783          	ld	a5,-104(s0)
    80202010:	ff478713          	addi	a4,a5,-12
    80202014:	4785                	li	a5,1
    80202016:	12e7e063          	bltu	a5,a4,80202136 <handle_sync_exception+0x16c>
    8020201a:	a86d                	j	802020d4 <handle_sync_exception+0x10a>
    8020201c:	a42ff0ef          	jal	8020125e <stats_inc_ecall>
    80202020:	f8843783          	ld	a5,-120(s0)
    80202024:	63d8                	ld	a4,128(a5)
    80202026:	05d00793          	li	a5,93
    8020202a:	08f71863          	bne	a4,a5,802020ba <handle_sync_exception+0xf0>
    8020202e:	682010ef          	jal	802036b0 <proc_current_pid>
    80202032:	87aa                	mv	a5,a0
    80202034:	fef42623          	sw	a5,-20(s0)
    80202038:	fec42783          	lw	a5,-20(s0)
    8020203c:	2781                	sext.w	a5,a5
    8020203e:	04f05363          	blez	a5,80202084 <handle_sync_exception+0xba>
    80202042:	f8843783          	ld	a5,-120(s0)
    80202046:	67bc                	ld	a5,72(a5)
    80202048:	0007871b          	sext.w	a4,a5
    8020204c:	fec42783          	lw	a5,-20(s0)
    80202050:	85ba                	mv	a1,a4
    80202052:	853e                	mv	a0,a5
    80202054:	523010ef          	jal	80203d76 <proc_user_exit>
    80202058:	00002717          	auipc	a4,0x2
    8020205c:	bf670713          	addi	a4,a4,-1034 # 80203c4e <user_exit_trampoline>
    80202060:	f8043783          	ld	a5,-128(s0)
    80202064:	e398                	sd	a4,0(a5)
    80202066:	00006617          	auipc	a2,0x6
    8020206a:	f9260613          	addi	a2,a2,-110 # 80207ff8 <user_code_end+0x628>
    8020206e:	00006597          	auipc	a1,0x6
    80202072:	f9a58593          	addi	a1,a1,-102 # 80208008 <user_code_end+0x638>
    80202076:	00006517          	auipc	a0,0x6
    8020207a:	f9a50513          	addi	a0,a0,-102 # 80208010 <user_code_end+0x640>
    8020207e:	ffefe0ef          	jal	8020087c <osviz_event>
    80202082:	aa31                	j	8020219e <handle_sync_exception+0x1d4>
    80202084:	f8843783          	ld	a5,-120(s0)
    80202088:	67bc                	ld	a5,72(a5)
    8020208a:	2781                	sext.w	a5,a5
    8020208c:	85be                	mv	a1,a5
    8020208e:	f8843503          	ld	a0,-120(s0)
    80202092:	2ee020ef          	jal	80204380 <task_exit_to_idle>
    80202096:	4601                	li	a2,0
    80202098:	00006597          	auipc	a1,0x6
    8020209c:	f7058593          	addi	a1,a1,-144 # 80208008 <user_code_end+0x638>
    802020a0:	00006517          	auipc	a0,0x6
    802020a4:	f7050513          	addi	a0,a0,-144 # 80208010 <user_code_end+0x640>
    802020a8:	fd4fe0ef          	jal	8020087c <osviz_event>
    802020ac:	f8843783          	ld	a5,-120(s0)
    802020b0:	7ff8                	ld	a4,248(a5)
    802020b2:	f8043783          	ld	a5,-128(s0)
    802020b6:	e398                	sd	a4,0(a5)
    802020b8:	a0dd                	j	8020219e <handle_sync_exception+0x1d4>
    802020ba:	f8843503          	ld	a0,-120(s0)
    802020be:	5c8020ef          	jal	80204686 <do_syscall>
    802020c2:	f8043783          	ld	a5,-128(s0)
    802020c6:	639c                	ld	a5,0(a5)
    802020c8:	00478713          	addi	a4,a5,4
    802020cc:	f8043783          	ld	a5,-128(s0)
    802020d0:	e398                	sd	a4,0(a5)
    802020d2:	a0f1                	j	8020219e <handle_sync_exception+0x1d4>
    802020d4:	9b6ff0ef          	jal	8020128a <stats_inc_page_fault>
    802020d8:	f9043683          	ld	a3,-112(s0)
    802020dc:	f9843703          	ld	a4,-104(s0)
    802020e0:	fa840793          	addi	a5,s0,-88
    802020e4:	00006617          	auipc	a2,0x6
    802020e8:	f3460613          	addi	a2,a2,-204 # 80208018 <user_code_end+0x648>
    802020ec:	04000593          	li	a1,64
    802020f0:	853e                	mv	a0,a5
    802020f2:	81cff0ef          	jal	8020110e <snprintf>
    802020f6:	fa840793          	addi	a5,s0,-88
    802020fa:	863e                	mv	a2,a5
    802020fc:	00006597          	auipc	a1,0x6
    80202100:	f3c58593          	addi	a1,a1,-196 # 80208038 <user_code_end+0x668>
    80202104:	00006517          	auipc	a0,0x6
    80202108:	f4450513          	addi	a0,a0,-188 # 80208048 <user_code_end+0x678>
    8020210c:	f70fe0ef          	jal	8020087c <osviz_event>
    80202110:	f9043783          	ld	a5,-112(s0)
    80202114:	f9843703          	ld	a4,-104(s0)
    80202118:	863a                	mv	a2,a4
    8020211a:	85be                	mv	a1,a5
    8020211c:	00006517          	auipc	a0,0x6
    80202120:	f3450513          	addi	a0,a0,-204 # 80208050 <user_code_end+0x680>
    80202124:	f93fe0ef          	jal	802010b6 <printf>
    80202128:	00006517          	auipc	a0,0x6
    8020212c:	f5050513          	addi	a0,a0,-176 # 80208078 <user_code_end+0x6a8>
    80202130:	84eff0ef          	jal	8020117e <panic>
    80202134:	a0ad                	j	8020219e <handle_sync_exception+0x1d4>
    80202136:	f9843703          	ld	a4,-104(s0)
    8020213a:	fa840793          	addi	a5,s0,-88
    8020213e:	86ba                	mv	a3,a4
    80202140:	00006617          	auipc	a2,0x6
    80202144:	f6060613          	addi	a2,a2,-160 # 802080a0 <user_code_end+0x6d0>
    80202148:	04000593          	li	a1,64
    8020214c:	853e                	mv	a0,a5
    8020214e:	fc1fe0ef          	jal	8020110e <snprintf>
    80202152:	fa840793          	addi	a5,s0,-88
    80202156:	863e                	mv	a2,a5
    80202158:	00006597          	auipc	a1,0x6
    8020215c:	f5858593          	addi	a1,a1,-168 # 802080b0 <user_code_end+0x6e0>
    80202160:	00006517          	auipc	a0,0x6
    80202164:	ee850513          	addi	a0,a0,-280 # 80208048 <user_code_end+0x678>
    80202168:	f14fe0ef          	jal	8020087c <osviz_event>
    8020216c:	f9843783          	ld	a5,-104(s0)
    80202170:	f9043703          	ld	a4,-112(s0)
    80202174:	863a                	mv	a2,a4
    80202176:	85be                	mv	a1,a5
    80202178:	00006517          	auipc	a0,0x6
    8020217c:	f4850513          	addi	a0,a0,-184 # 802080c0 <user_code_end+0x6f0>
    80202180:	f37fe0ef          	jal	802010b6 <printf>
    80202184:	00006517          	auipc	a0,0x6
    80202188:	f6450513          	addi	a0,a0,-156 # 802080e8 <user_code_end+0x718>
    8020218c:	44c000ef          	jal	802025d8 <trap_diag_print_csrs>
    80202190:	00006517          	auipc	a0,0x6
    80202194:	f6850513          	addi	a0,a0,-152 # 802080f8 <user_code_end+0x728>
    80202198:	fe7fe0ef          	jal	8020117e <panic>
    8020219c:	0001                	nop
    8020219e:	0001                	nop
    802021a0:	70e6                	ld	ra,120(sp)
    802021a2:	7446                	ld	s0,112(sp)
    802021a4:	6109                	addi	sp,sp,128
    802021a6:	8082                	ret

00000000802021a8 <trap_init>:
    802021a8:	1141                	addi	sp,sp,-16
    802021aa:	e406                	sd	ra,8(sp)
    802021ac:	e022                	sd	s0,0(sp)
    802021ae:	0800                	addi	s0,sp,16
    802021b0:	870e                	mv	a4,gp
    802021b2:	0000d797          	auipc	a5,0xd
    802021b6:	ed678793          	addi	a5,a5,-298 # 8020f088 <kernel_gp_value>
    802021ba:	e398                	sd	a4,0(a5)
    802021bc:	ffffe797          	auipc	a5,0xffffe
    802021c0:	e9c78793          	addi	a5,a5,-356 # 80200058 <trap_vector>
    802021c4:	853e                	mv	a0,a5
    802021c6:	ca7ff0ef          	jal	80201e6c <trap_vec_init>
    802021ca:	0000d797          	auipc	a5,0xd
    802021ce:	3e678793          	addi	a5,a5,998 # 8020f5b0 <kernel_trap_cxt>
    802021d2:	853e                	mv	a0,a5
    802021d4:	cb7ff0ef          	jal	80201e8a <trap_scratch_init>
    802021d8:	0001                	nop
    802021da:	60a2                	ld	ra,8(sp)
    802021dc:	6402                	ld	s0,0(sp)
    802021de:	0141                	addi	sp,sp,16
    802021e0:	8082                	ret

00000000802021e2 <trap_use_kernel_cxt>:
    802021e2:	1141                	addi	sp,sp,-16
    802021e4:	e406                	sd	ra,8(sp)
    802021e6:	e022                	sd	s0,0(sp)
    802021e8:	0800                	addi	s0,sp,16
    802021ea:	0000d797          	auipc	a5,0xd
    802021ee:	3c678793          	addi	a5,a5,966 # 8020f5b0 <kernel_trap_cxt>
    802021f2:	853e                	mv	a0,a5
    802021f4:	c97ff0ef          	jal	80201e8a <trap_scratch_init>
    802021f8:	0001                	nop
    802021fa:	60a2                	ld	ra,8(sp)
    802021fc:	6402                	ld	s0,0(sp)
    802021fe:	0141                	addi	sp,sp,16
    80202200:	8082                	ret

0000000080202202 <trap_nested_timer_ack>:
    80202202:	1141                	addi	sp,sp,-16
    80202204:	e406                	sd	ra,8(sp)
    80202206:	e022                	sd	s0,0(sp)
    80202208:	0800                	addi	s0,sp,16
    8020220a:	b71ff0ef          	jal	80201d7a <timer_handler>
    8020220e:	0001                	nop
    80202210:	60a2                	ld	ra,8(sp)
    80202212:	6402                	ld	s0,0(sp)
    80202214:	0141                	addi	sp,sp,16
    80202216:	8082                	ret

0000000080202218 <external_interrupt_handler>:
    80202218:	1101                	addi	sp,sp,-32
    8020221a:	ec06                	sd	ra,24(sp)
    8020221c:	e822                	sd	s0,16(sp)
    8020221e:	1000                	addi	s0,sp,32
    80202220:	ff0ff0ef          	jal	80201a10 <plic_claim>
    80202224:	87aa                	mv	a5,a0
    80202226:	fef42623          	sw	a5,-20(s0)
    8020222a:	808ff0ef          	jal	80201232 <stats_inc_ext_irq>
    8020222e:	fec42783          	lw	a5,-20(s0)
    80202232:	0007871b          	sext.w	a4,a5
    80202236:	47a9                	li	a5,10
    80202238:	00f71563          	bne	a4,a5,80202242 <external_interrupt_handler+0x2a>
    8020223c:	b22ff0ef          	jal	8020155e <uart_rx_flush>
    80202240:	a831                	j	8020225c <external_interrupt_handler+0x44>
    80202242:	fec42783          	lw	a5,-20(s0)
    80202246:	2781                	sext.w	a5,a5
    80202248:	cb91                	beqz	a5,8020225c <external_interrupt_handler+0x44>
    8020224a:	fec42783          	lw	a5,-20(s0)
    8020224e:	85be                	mv	a1,a5
    80202250:	00006517          	auipc	a0,0x6
    80202254:	ec050513          	addi	a0,a0,-320 # 80208110 <user_code_end+0x740>
    80202258:	e5ffe0ef          	jal	802010b6 <printf>
    8020225c:	fec42783          	lw	a5,-20(s0)
    80202260:	2781                	sext.w	a5,a5
    80202262:	c791                	beqz	a5,8020226e <external_interrupt_handler+0x56>
    80202264:	fec42783          	lw	a5,-20(s0)
    80202268:	853e                	mv	a0,a5
    8020226a:	fe2ff0ef          	jal	80201a4c <plic_complete>
    8020226e:	0001                	nop
    80202270:	60e2                	ld	ra,24(sp)
    80202272:	6442                	ld	s0,16(sp)
    80202274:	6105                	addi	sp,sp,32
    80202276:	8082                	ret

0000000080202278 <trap_handler>:
    80202278:	715d                	addi	sp,sp,-80
    8020227a:	e486                	sd	ra,72(sp)
    8020227c:	e0a2                	sd	s0,64(sp)
    8020227e:	0880                	addi	s0,sp,80
    80202280:	fca43423          	sd	a0,-56(s0)
    80202284:	fcb43023          	sd	a1,-64(s0)
    80202288:	fac43c23          	sd	a2,-72(s0)
    8020228c:	fc843783          	ld	a5,-56(s0)
    80202290:	fcf43c23          	sd	a5,-40(s0)
    80202294:	fc043703          	ld	a4,-64(s0)
    80202298:	57fd                	li	a5,-1
    8020229a:	8385                	srli	a5,a5,0x1
    8020229c:	8ff9                	and	a5,a5,a4
    8020229e:	fef43423          	sd	a5,-24(s0)
    802022a2:	b17ff0ef          	jal	80201db8 <r_sstatus>
    802022a6:	87aa                	mv	a5,a0
    802022a8:	8b89                	andi	a5,a5,2
    802022aa:	fef43023          	sd	a5,-32(s0)
    802022ae:	0000d797          	auipc	a5,0xd
    802022b2:	dda78793          	addi	a5,a5,-550 # 8020f088 <kernel_gp_value>
    802022b6:	639c                	ld	a5,0(a5)
    802022b8:	81be                	mv	gp,a5
    802022ba:	befff0ef          	jal	80201ea8 <cpu_irq_disable>
    802022be:	0000d797          	auipc	a5,0xd
    802022c2:	dd278793          	addi	a5,a5,-558 # 8020f090 <kernel_trap_depth>
    802022c6:	439c                	lw	a5,0(a5)
    802022c8:	2781                	sext.w	a5,a5
    802022ca:	2785                	addiw	a5,a5,1
    802022cc:	0007871b          	sext.w	a4,a5
    802022d0:	0000d797          	auipc	a5,0xd
    802022d4:	dc078793          	addi	a5,a5,-576 # 8020f090 <kernel_trap_depth>
    802022d8:	c398                	sw	a4,0(a5)
    802022da:	0000d797          	auipc	a5,0xd
    802022de:	db678793          	addi	a5,a5,-586 # 8020f090 <kernel_trap_depth>
    802022e2:	439c                	lw	a5,0(a5)
    802022e4:	0007871b          	sext.w	a4,a5
    802022e8:	4785                	li	a5,1
    802022ea:	02e7d463          	bge	a5,a4,80202312 <trap_handler+0x9a>
    802022ee:	0000d797          	auipc	a5,0xd
    802022f2:	da278793          	addi	a5,a5,-606 # 8020f090 <kernel_trap_depth>
    802022f6:	439c                	lw	a5,0(a5)
    802022f8:	2781                	sext.w	a5,a5
    802022fa:	fc843703          	ld	a4,-56(s0)
    802022fe:	fc043683          	ld	a3,-64(s0)
    80202302:	863a                	mv	a2,a4
    80202304:	85be                	mv	a1,a5
    80202306:	00006517          	auipc	a0,0x6
    8020230a:	e2a50513          	addi	a0,a0,-470 # 80208130 <user_code_end+0x760>
    8020230e:	da9fe0ef          	jal	802010b6 <printf>
    80202312:	fb843603          	ld	a2,-72(s0)
    80202316:	fc043583          	ld	a1,-64(s0)
    8020231a:	fc843503          	ld	a0,-56(s0)
    8020231e:	318000ef          	jal	80202636 <trap_diag_trap_enter>
    80202322:	fc043783          	ld	a5,-64(s0)
    80202326:	0607d163          	bgez	a5,80202388 <trap_handler+0x110>
    8020232a:	fe843703          	ld	a4,-24(s0)
    8020232e:	47a5                	li	a5,9
    80202330:	02f70f63          	beq	a4,a5,8020236e <trap_handler+0xf6>
    80202334:	fe843703          	ld	a4,-24(s0)
    80202338:	47a5                	li	a5,9
    8020233a:	02e7ed63          	bltu	a5,a4,80202374 <trap_handler+0xfc>
    8020233e:	fe843703          	ld	a4,-24(s0)
    80202342:	4785                	li	a5,1
    80202344:	00f70863          	beq	a4,a5,80202354 <trap_handler+0xdc>
    80202348:	fe843703          	ld	a4,-24(s0)
    8020234c:	4795                	li	a5,5
    8020234e:	00f70d63          	beq	a4,a5,80202368 <trap_handler+0xf0>
    80202352:	a00d                	j	80202374 <trap_handler+0xfc>
    80202354:	eb3fe0ef          	jal	80201206 <stats_inc_sw_irq>
    80202358:	ad9ff0ef          	jal	80201e30 <r_sip>
    8020235c:	87aa                	mv	a5,a0
    8020235e:	9bf5                	andi	a5,a5,-3
    80202360:	853e                	mv	a0,a5
    80202362:	aedff0ef          	jal	80201e4e <w_sip>
    80202366:	a825                	j	8020239e <trap_handler+0x126>
    80202368:	a13ff0ef          	jal	80201d7a <timer_handler>
    8020236c:	a80d                	j	8020239e <trap_handler+0x126>
    8020236e:	eabff0ef          	jal	80202218 <external_interrupt_handler>
    80202372:	a035                	j	8020239e <trap_handler+0x126>
    80202374:	fe843783          	ld	a5,-24(s0)
    80202378:	85be                	mv	a1,a5
    8020237a:	00006517          	auipc	a0,0x6
    8020237e:	de650513          	addi	a0,a0,-538 # 80208160 <user_code_end+0x790>
    80202382:	d35fe0ef          	jal	802010b6 <printf>
    80202386:	a821                	j	8020239e <trap_handler+0x126>
    80202388:	fd840793          	addi	a5,s0,-40
    8020238c:	86be                	mv	a3,a5
    8020238e:	fb843603          	ld	a2,-72(s0)
    80202392:	fc843583          	ld	a1,-56(s0)
    80202396:	fe843503          	ld	a0,-24(s0)
    8020239a:	c31ff0ef          	jal	80201fca <handle_sync_exception>
    8020239e:	0000d797          	auipc	a5,0xd
    802023a2:	ce278793          	addi	a5,a5,-798 # 8020f080 <trap_reenable_irq>
    802023a6:	0007a023          	sw	zero,0(a5)
    802023aa:	fe043783          	ld	a5,-32(s0)
    802023ae:	c785                	beqz	a5,802023d6 <trap_handler+0x15e>
    802023b0:	0000d797          	auipc	a5,0xd
    802023b4:	cf878793          	addi	a5,a5,-776 # 8020f0a8 <proc_user_exit_pending>
    802023b8:	439c                	lw	a5,0(a5)
    802023ba:	eb81                	bnez	a5,802023ca <trap_handler+0x152>
    802023bc:	fd843783          	ld	a5,-40(s0)
    802023c0:	853e                	mv	a0,a5
    802023c2:	b07ff0ef          	jal	80201ec8 <epc_in_user>
    802023c6:	87aa                	mv	a5,a0
    802023c8:	c799                	beqz	a5,802023d6 <trap_handler+0x15e>
    802023ca:	0000d797          	auipc	a5,0xd
    802023ce:	cb678793          	addi	a5,a5,-842 # 8020f080 <trap_reenable_irq>
    802023d2:	4705                	li	a4,1
    802023d4:	c398                	sw	a4,0(a5)
    802023d6:	fd843783          	ld	a5,-40(s0)
    802023da:	853e                	mv	a0,a5
    802023dc:	278000ef          	jal	80202654 <trap_diag_post_handler>
    802023e0:	fd843783          	ld	a5,-40(s0)
    802023e4:	fc843583          	ld	a1,-56(s0)
    802023e8:	853e                	mv	a0,a5
    802023ea:	b89ff0ef          	jal	80201f72 <trap_check_return_pc>
    802023ee:	0000d797          	auipc	a5,0xd
    802023f2:	ca278793          	addi	a5,a5,-862 # 8020f090 <kernel_trap_depth>
    802023f6:	439c                	lw	a5,0(a5)
    802023f8:	2781                	sext.w	a5,a5
    802023fa:	37fd                	addiw	a5,a5,-1
    802023fc:	0007871b          	sext.w	a4,a5
    80202400:	0000d797          	auipc	a5,0xd
    80202404:	c9078793          	addi	a5,a5,-880 # 8020f090 <kernel_trap_depth>
    80202408:	c398                	sw	a4,0(a5)
    8020240a:	fd843783          	ld	a5,-40(s0)
    8020240e:	853e                	mv	a0,a5
    80202410:	60a6                	ld	ra,72(sp)
    80202412:	6406                	ld	s0,64(sp)
    80202414:	6161                	addi	sp,sp,80
    80202416:	8082                	ret

0000000080202418 <r_sstatus>:
    80202418:	1101                	addi	sp,sp,-32
    8020241a:	ec06                	sd	ra,24(sp)
    8020241c:	e822                	sd	s0,16(sp)
    8020241e:	1000                	addi	s0,sp,32
    80202420:	100027f3          	csrr	a5,sstatus
    80202424:	fef43423          	sd	a5,-24(s0)
    80202428:	fe843783          	ld	a5,-24(s0)
    8020242c:	853e                	mv	a0,a5
    8020242e:	60e2                	ld	ra,24(sp)
    80202430:	6442                	ld	s0,16(sp)
    80202432:	6105                	addi	sp,sp,32
    80202434:	8082                	ret

0000000080202436 <r_sepc>:
    80202436:	1101                	addi	sp,sp,-32
    80202438:	ec06                	sd	ra,24(sp)
    8020243a:	e822                	sd	s0,16(sp)
    8020243c:	1000                	addi	s0,sp,32
    8020243e:	141027f3          	csrr	a5,sepc
    80202442:	fef43423          	sd	a5,-24(s0)
    80202446:	fe843783          	ld	a5,-24(s0)
    8020244a:	853e                	mv	a0,a5
    8020244c:	60e2                	ld	ra,24(sp)
    8020244e:	6442                	ld	s0,16(sp)
    80202450:	6105                	addi	sp,sp,32
    80202452:	8082                	ret

0000000080202454 <r_sscratch>:
    80202454:	1101                	addi	sp,sp,-32
    80202456:	ec06                	sd	ra,24(sp)
    80202458:	e822                	sd	s0,16(sp)
    8020245a:	1000                	addi	s0,sp,32
    8020245c:	140027f3          	csrr	a5,sscratch
    80202460:	fef43423          	sd	a5,-24(s0)
    80202464:	fe843783          	ld	a5,-24(s0)
    80202468:	853e                	mv	a0,a5
    8020246a:	60e2                	ld	ra,24(sp)
    8020246c:	6442                	ld	s0,16(sp)
    8020246e:	6105                	addi	sp,sp,32
    80202470:	8082                	ret

0000000080202472 <r_stval>:
    80202472:	1101                	addi	sp,sp,-32
    80202474:	ec06                	sd	ra,24(sp)
    80202476:	e822                	sd	s0,16(sp)
    80202478:	1000                	addi	s0,sp,32
    8020247a:	143027f3          	csrr	a5,stval
    8020247e:	fef43423          	sd	a5,-24(s0)
    80202482:	fe843783          	ld	a5,-24(s0)
    80202486:	853e                	mv	a0,a5
    80202488:	60e2                	ld	ra,24(sp)
    8020248a:	6442                	ld	s0,16(sp)
    8020248c:	6105                	addi	sp,sp,32
    8020248e:	8082                	ret

0000000080202490 <r_scause>:
    80202490:	1101                	addi	sp,sp,-32
    80202492:	ec06                	sd	ra,24(sp)
    80202494:	e822                	sd	s0,16(sp)
    80202496:	1000                	addi	s0,sp,32
    80202498:	142027f3          	csrr	a5,scause
    8020249c:	fef43423          	sd	a5,-24(s0)
    802024a0:	fe843783          	ld	a5,-24(s0)
    802024a4:	853e                	mv	a0,a5
    802024a6:	60e2                	ld	ra,24(sp)
    802024a8:	6442                	ld	s0,16(sp)
    802024aa:	6105                	addi	sp,sp,32
    802024ac:	8082                	ret

00000000802024ae <epc_in_user>:
    802024ae:	1101                	addi	sp,sp,-32
    802024b0:	ec06                	sd	ra,24(sp)
    802024b2:	e822                	sd	s0,16(sp)
    802024b4:	1000                	addi	s0,sp,32
    802024b6:	fea43423          	sd	a0,-24(s0)
    802024ba:	fe843703          	ld	a4,-24(s0)
    802024be:	010077b7          	lui	a5,0x1007
    802024c2:	079e                	slli	a5,a5,0x7
    802024c4:	00f76b63          	bltu	a4,a5,802024da <epc_in_user+0x2c>
    802024c8:	fe843703          	ld	a4,-24(s0)
    802024cc:	20100793          	li	a5,513
    802024d0:	07da                	slli	a5,a5,0x16
    802024d2:	00f77463          	bgeu	a4,a5,802024da <epc_in_user+0x2c>
    802024d6:	4785                	li	a5,1
    802024d8:	a011                	j	802024dc <epc_in_user+0x2e>
    802024da:	4781                	li	a5,0
    802024dc:	853e                	mv	a0,a5
    802024de:	60e2                	ld	ra,24(sp)
    802024e0:	6442                	ld	s0,16(sp)
    802024e2:	6105                	addi	sp,sp,32
    802024e4:	8082                	ret

00000000802024e6 <frame_name>:
    802024e6:	7179                	addi	sp,sp,-48
    802024e8:	f406                	sd	ra,40(sp)
    802024ea:	f022                	sd	s0,32(sp)
    802024ec:	1800                	addi	s0,sp,48
    802024ee:	fca43c23          	sd	a0,-40(s0)
    802024f2:	fd843783          	ld	a5,-40(s0)
    802024f6:	fef43423          	sd	a5,-24(s0)
    802024fa:	0000d797          	auipc	a5,0xd
    802024fe:	ba678793          	addi	a5,a5,-1114 # 8020f0a0 <user_trap_save_cxt>
    80202502:	639c                	ld	a5,0(a5)
    80202504:	c385                	beqz	a5,80202524 <frame_name+0x3e>
    80202506:	0000d797          	auipc	a5,0xd
    8020250a:	b9a78793          	addi	a5,a5,-1126 # 8020f0a0 <user_trap_save_cxt>
    8020250e:	639c                	ld	a5,0(a5)
    80202510:	873e                	mv	a4,a5
    80202512:	fe843783          	ld	a5,-24(s0)
    80202516:	00e79763          	bne	a5,a4,80202524 <frame_name+0x3e>
    8020251a:	00006797          	auipc	a5,0x6
    8020251e:	c6678793          	addi	a5,a5,-922 # 80208180 <user_code_end+0x7b0>
    80202522:	a83d                	j	80202560 <frame_name+0x7a>
    80202524:	0000d797          	auipc	a5,0xd
    80202528:	08c78793          	addi	a5,a5,140 # 8020f5b0 <kernel_trap_cxt>
    8020252c:	fe843703          	ld	a4,-24(s0)
    80202530:	00f71763          	bne	a4,a5,8020253e <frame_name+0x58>
    80202534:	00006797          	auipc	a5,0x6
    80202538:	c5c78793          	addi	a5,a5,-932 # 80208190 <user_code_end+0x7c0>
    8020253c:	a015                	j	80202560 <frame_name+0x7a>
    8020253e:	0000d797          	auipc	a5,0xd
    80202542:	49a78793          	addi	a5,a5,1178 # 8020f9d8 <kernel_user_exit_cxt>
    80202546:	fe843703          	ld	a4,-24(s0)
    8020254a:	00f71763          	bne	a4,a5,80202558 <frame_name+0x72>
    8020254e:	00006797          	auipc	a5,0x6
    80202552:	c5278793          	addi	a5,a5,-942 # 802081a0 <user_code_end+0x7d0>
    80202556:	a029                	j	80202560 <frame_name+0x7a>
    80202558:	00006797          	auipc	a5,0x6
    8020255c:	c5878793          	addi	a5,a5,-936 # 802081b0 <user_code_end+0x7e0>
    80202560:	853e                	mv	a0,a5
    80202562:	70a2                	ld	ra,40(sp)
    80202564:	7402                	ld	s0,32(sp)
    80202566:	6145                	addi	sp,sp,48
    80202568:	8082                	ret

000000008020256a <trap_diag_interesting>:
    8020256a:	7179                	addi	sp,sp,-48
    8020256c:	f406                	sd	ra,40(sp)
    8020256e:	f022                	sd	s0,32(sp)
    80202570:	1800                	addi	s0,sp,48
    80202572:	fea43423          	sd	a0,-24(s0)
    80202576:	feb43023          	sd	a1,-32(s0)
    8020257a:	fcc43c23          	sd	a2,-40(s0)
    8020257e:	fe043783          	ld	a5,-32(s0)
    80202582:	0007c463          	bltz	a5,8020258a <trap_diag_interesting+0x20>
    80202586:	4785                	li	a5,1
    80202588:	a099                	j	802025ce <trap_diag_interesting+0x64>
    8020258a:	fe843503          	ld	a0,-24(s0)
    8020258e:	f21ff0ef          	jal	802024ae <epc_in_user>
    80202592:	87aa                	mv	a5,a0
    80202594:	c399                	beqz	a5,8020259a <trap_diag_interesting+0x30>
    80202596:	4785                	li	a5,1
    80202598:	a81d                	j	802025ce <trap_diag_interesting+0x64>
    8020259a:	0000d797          	auipc	a5,0xd
    8020259e:	b0678793          	addi	a5,a5,-1274 # 8020f0a0 <user_trap_save_cxt>
    802025a2:	639c                	ld	a5,0(a5)
    802025a4:	cf81                	beqz	a5,802025bc <trap_diag_interesting+0x52>
    802025a6:	fd843783          	ld	a5,-40(s0)
    802025aa:	0000d717          	auipc	a4,0xd
    802025ae:	af670713          	addi	a4,a4,-1290 # 8020f0a0 <user_trap_save_cxt>
    802025b2:	6318                	ld	a4,0(a4)
    802025b4:	00e79463          	bne	a5,a4,802025bc <trap_diag_interesting+0x52>
    802025b8:	4785                	li	a5,1
    802025ba:	a811                	j	802025ce <trap_diag_interesting+0x64>
    802025bc:	0000d797          	auipc	a5,0xd
    802025c0:	aec78793          	addi	a5,a5,-1300 # 8020f0a8 <proc_user_exit_pending>
    802025c4:	439c                	lw	a5,0(a5)
    802025c6:	c399                	beqz	a5,802025cc <trap_diag_interesting+0x62>
    802025c8:	4785                	li	a5,1
    802025ca:	a011                	j	802025ce <trap_diag_interesting+0x64>
    802025cc:	4781                	li	a5,0
    802025ce:	853e                	mv	a0,a5
    802025d0:	70a2                	ld	ra,40(sp)
    802025d2:	7402                	ld	s0,32(sp)
    802025d4:	6145                	addi	sp,sp,48
    802025d6:	8082                	ret

00000000802025d8 <trap_diag_print_csrs>:
    802025d8:	7139                	addi	sp,sp,-64
    802025da:	fc06                	sd	ra,56(sp)
    802025dc:	f822                	sd	s0,48(sp)
    802025de:	f426                	sd	s1,40(sp)
    802025e0:	f04a                	sd	s2,32(sp)
    802025e2:	ec4e                	sd	s3,24(sp)
    802025e4:	e852                	sd	s4,16(sp)
    802025e6:	0080                	addi	s0,sp,64
    802025e8:	fca43423          	sd	a0,-56(s0)
    802025ec:	ea5ff0ef          	jal	80202490 <r_scause>
    802025f0:	84aa                	mv	s1,a0
    802025f2:	e81ff0ef          	jal	80202472 <r_stval>
    802025f6:	892a                	mv	s2,a0
    802025f8:	e3fff0ef          	jal	80202436 <r_sepc>
    802025fc:	89aa                	mv	s3,a0
    802025fe:	e1bff0ef          	jal	80202418 <r_sstatus>
    80202602:	8a2a                	mv	s4,a0
    80202604:	e51ff0ef          	jal	80202454 <r_sscratch>
    80202608:	87aa                	mv	a5,a0
    8020260a:	883e                	mv	a6,a5
    8020260c:	87d2                	mv	a5,s4
    8020260e:	874e                	mv	a4,s3
    80202610:	86ca                	mv	a3,s2
    80202612:	8626                	mv	a2,s1
    80202614:	fc843583          	ld	a1,-56(s0)
    80202618:	00006517          	auipc	a0,0x6
    8020261c:	ba050513          	addi	a0,a0,-1120 # 802081b8 <user_code_end+0x7e8>
    80202620:	a97fe0ef          	jal	802010b6 <printf>
    80202624:	0001                	nop
    80202626:	70e2                	ld	ra,56(sp)
    80202628:	7442                	ld	s0,48(sp)
    8020262a:	74a2                	ld	s1,40(sp)
    8020262c:	7902                	ld	s2,32(sp)
    8020262e:	69e2                	ld	s3,24(sp)
    80202630:	6a42                	ld	s4,16(sp)
    80202632:	6121                	addi	sp,sp,64
    80202634:	8082                	ret

0000000080202636 <trap_diag_trap_enter>:
    80202636:	7179                	addi	sp,sp,-48
    80202638:	f406                	sd	ra,40(sp)
    8020263a:	f022                	sd	s0,32(sp)
    8020263c:	1800                	addi	s0,sp,48
    8020263e:	fea43423          	sd	a0,-24(s0)
    80202642:	feb43023          	sd	a1,-32(s0)
    80202646:	fcc43c23          	sd	a2,-40(s0)
    8020264a:	0001                	nop
    8020264c:	70a2                	ld	ra,40(sp)
    8020264e:	7402                	ld	s0,32(sp)
    80202650:	6145                	addi	sp,sp,48
    80202652:	8082                	ret

0000000080202654 <trap_diag_post_handler>:
    80202654:	1101                	addi	sp,sp,-32
    80202656:	ec06                	sd	ra,24(sp)
    80202658:	e822                	sd	s0,16(sp)
    8020265a:	1000                	addi	s0,sp,32
    8020265c:	fea43423          	sd	a0,-24(s0)
    80202660:	0001                	nop
    80202662:	60e2                	ld	ra,24(sp)
    80202664:	6442                	ld	s0,16(sp)
    80202666:	6105                	addi	sp,sp,32
    80202668:	8082                	ret

000000008020266a <trap_diag_put_hex>:
    8020266a:	7139                	addi	sp,sp,-64
    8020266c:	fc06                	sd	ra,56(sp)
    8020266e:	f822                	sd	s0,48(sp)
    80202670:	0080                	addi	s0,sp,64
    80202672:	fca43423          	sd	a0,-56(s0)
    80202676:	fe042623          	sw	zero,-20(s0)
    8020267a:	fc843783          	ld	a5,-56(s0)
    8020267e:	e3b1                	bnez	a5,802026c2 <trap_diag_put_hex+0x58>
    80202680:	00006517          	auipc	a0,0x6
    80202684:	b9050513          	addi	a0,a0,-1136 # 80208210 <user_code_end+0x840>
    80202688:	e1bfe0ef          	jal	802014a2 <uart_puts>
    8020268c:	a8bd                	j	8020270a <trap_diag_put_hex+0xa0>
    8020268e:	fc843783          	ld	a5,-56(s0)
    80202692:	00f7f713          	andi	a4,a5,15
    80202696:	fec42783          	lw	a5,-20(s0)
    8020269a:	0017869b          	addiw	a3,a5,1
    8020269e:	fed42623          	sw	a3,-20(s0)
    802026a2:	00006697          	auipc	a3,0x6
    802026a6:	b7e68693          	addi	a3,a3,-1154 # 80208220 <user_code_end+0x850>
    802026aa:	9736                	add	a4,a4,a3
    802026ac:	00074703          	lbu	a4,0(a4)
    802026b0:	17c1                	addi	a5,a5,-16
    802026b2:	97a2                	add	a5,a5,s0
    802026b4:	fee78423          	sb	a4,-24(a5)
    802026b8:	fc843783          	ld	a5,-56(s0)
    802026bc:	8391                	srli	a5,a5,0x4
    802026be:	fcf43423          	sd	a5,-56(s0)
    802026c2:	fc843783          	ld	a5,-56(s0)
    802026c6:	cb81                	beqz	a5,802026d6 <trap_diag_put_hex+0x6c>
    802026c8:	fec42783          	lw	a5,-20(s0)
    802026cc:	0007871b          	sext.w	a4,a5
    802026d0:	47cd                	li	a5,19
    802026d2:	fae7dee3          	bge	a5,a4,8020268e <trap_diag_put_hex+0x24>
    802026d6:	00006517          	auipc	a0,0x6
    802026da:	b4250513          	addi	a0,a0,-1214 # 80208218 <user_code_end+0x848>
    802026de:	dc5fe0ef          	jal	802014a2 <uart_puts>
    802026e2:	a839                	j	80202700 <trap_diag_put_hex+0x96>
    802026e4:	fec42783          	lw	a5,-20(s0)
    802026e8:	37fd                	addiw	a5,a5,-1
    802026ea:	fef42623          	sw	a5,-20(s0)
    802026ee:	fec42783          	lw	a5,-20(s0)
    802026f2:	17c1                	addi	a5,a5,-16
    802026f4:	97a2                	add	a5,a5,s0
    802026f6:	fe87c783          	lbu	a5,-24(a5)
    802026fa:	853e                	mv	a0,a5
    802026fc:	d59fe0ef          	jal	80201454 <uart_putc>
    80202700:	fec42783          	lw	a5,-20(s0)
    80202704:	2781                	sext.w	a5,a5
    80202706:	fcf04fe3          	bgtz	a5,802026e4 <trap_diag_put_hex+0x7a>
    8020270a:	70e2                	ld	ra,56(sp)
    8020270c:	7442                	ld	s0,48(sp)
    8020270e:	6121                	addi	sp,sp,64
    80202710:	8082                	ret

0000000080202712 <trap_diag_trap_return>:
    80202712:	1101                	addi	sp,sp,-32
    80202714:	ec06                	sd	ra,24(sp)
    80202716:	e822                	sd	s0,16(sp)
    80202718:	1000                	addi	s0,sp,32
    8020271a:	fea43423          	sd	a0,-24(s0)
    8020271e:	feb43023          	sd	a1,-32(s0)
    80202722:	fe843503          	ld	a0,-24(s0)
    80202726:	d89ff0ef          	jal	802024ae <epc_in_user>
    8020272a:	87aa                	mv	a5,a0
    8020272c:	e799                	bnez	a5,8020273a <trap_diag_trap_return+0x28>
    8020272e:	0000d797          	auipc	a5,0xd
    80202732:	97a78793          	addi	a5,a5,-1670 # 8020f0a8 <proc_user_exit_pending>
    80202736:	439c                	lw	a5,0(a5)
    80202738:	cba9                	beqz	a5,8020278a <trap_diag_trap_return+0x78>
    8020273a:	00006517          	auipc	a0,0x6
    8020273e:	afe50513          	addi	a0,a0,-1282 # 80208238 <user_code_end+0x868>
    80202742:	d61fe0ef          	jal	802014a2 <uart_puts>
    80202746:	fe843503          	ld	a0,-24(s0)
    8020274a:	f21ff0ef          	jal	8020266a <trap_diag_put_hex>
    8020274e:	00006517          	auipc	a0,0x6
    80202752:	b0a50513          	addi	a0,a0,-1270 # 80208258 <user_code_end+0x888>
    80202756:	d4dfe0ef          	jal	802014a2 <uart_puts>
    8020275a:	fe043503          	ld	a0,-32(s0)
    8020275e:	d89ff0ef          	jal	802024e6 <frame_name>
    80202762:	87aa                	mv	a5,a0
    80202764:	853e                	mv	a0,a5
    80202766:	d3dfe0ef          	jal	802014a2 <uart_puts>
    8020276a:	00006517          	auipc	a0,0x6
    8020276e:	afe50513          	addi	a0,a0,-1282 # 80208268 <user_code_end+0x898>
    80202772:	d31fe0ef          	jal	802014a2 <uart_puts>
    80202776:	cdfff0ef          	jal	80202454 <r_sscratch>
    8020277a:	87aa                	mv	a5,a0
    8020277c:	853e                	mv	a0,a5
    8020277e:	eedff0ef          	jal	8020266a <trap_diag_put_hex>
    80202782:	4529                	li	a0,10
    80202784:	cd1fe0ef          	jal	80201454 <uart_putc>
    80202788:	a011                	j	8020278c <trap_diag_trap_return+0x7a>
    8020278a:	0001                	nop
    8020278c:	60e2                	ld	ra,24(sp)
    8020278e:	6442                	ld	s0,16(sp)
    80202790:	6105                	addi	sp,sp,32
    80202792:	8082                	ret

0000000080202794 <trap_diag_user_exit_branch>:
    80202794:	1141                	addi	sp,sp,-16
    80202796:	e406                	sd	ra,8(sp)
    80202798:	e022                	sd	s0,0(sp)
    8020279a:	0800                	addi	s0,sp,16
    8020279c:	0000d797          	auipc	a5,0xd
    802027a0:	8fc78793          	addi	a5,a5,-1796 # 8020f098 <trap_diag_user_exit_count>
    802027a4:	639c                	ld	a5,0(a5)
    802027a6:	00178713          	addi	a4,a5,1
    802027aa:	0000d797          	auipc	a5,0xd
    802027ae:	8ee78793          	addi	a5,a5,-1810 # 8020f098 <trap_diag_user_exit_count>
    802027b2:	e398                	sd	a4,0(a5)
    802027b4:	00006517          	auipc	a0,0x6
    802027b8:	ac450513          	addi	a0,a0,-1340 # 80208278 <user_code_end+0x8a8>
    802027bc:	ce7fe0ef          	jal	802014a2 <uart_puts>
    802027c0:	0000d797          	auipc	a5,0xd
    802027c4:	8d878793          	addi	a5,a5,-1832 # 8020f098 <trap_diag_user_exit_count>
    802027c8:	639c                	ld	a5,0(a5)
    802027ca:	853e                	mv	a0,a5
    802027cc:	e9fff0ef          	jal	8020266a <trap_diag_put_hex>
    802027d0:	00006517          	auipc	a0,0x6
    802027d4:	ac850513          	addi	a0,a0,-1336 # 80208298 <user_code_end+0x8c8>
    802027d8:	ccbfe0ef          	jal	802014a2 <uart_puts>
    802027dc:	0001                	nop
    802027de:	60a2                	ld	ra,8(sp)
    802027e0:	6402                	ld	s0,0(sp)
    802027e2:	0141                	addi	sp,sp,16
    802027e4:	8082                	ret

00000000802027e6 <_clear>:
    802027e6:	1101                	addi	sp,sp,-32
    802027e8:	ec06                	sd	ra,24(sp)
    802027ea:	e822                	sd	s0,16(sp)
    802027ec:	1000                	addi	s0,sp,32
    802027ee:	fea43423          	sd	a0,-24(s0)
    802027f2:	fe843783          	ld	a5,-24(s0)
    802027f6:	00078023          	sb	zero,0(a5)
    802027fa:	0001                	nop
    802027fc:	60e2                	ld	ra,24(sp)
    802027fe:	6442                	ld	s0,16(sp)
    80202800:	6105                	addi	sp,sp,32
    80202802:	8082                	ret

0000000080202804 <_is_free>:
    80202804:	1101                	addi	sp,sp,-32
    80202806:	ec06                	sd	ra,24(sp)
    80202808:	e822                	sd	s0,16(sp)
    8020280a:	1000                	addi	s0,sp,32
    8020280c:	fea43423          	sd	a0,-24(s0)
    80202810:	fe843783          	ld	a5,-24(s0)
    80202814:	0007c783          	lbu	a5,0(a5)
    80202818:	2781                	sext.w	a5,a5
    8020281a:	8b85                	andi	a5,a5,1
    8020281c:	2781                	sext.w	a5,a5
    8020281e:	c399                	beqz	a5,80202824 <_is_free+0x20>
    80202820:	4781                	li	a5,0
    80202822:	a011                	j	80202826 <_is_free+0x22>
    80202824:	4785                	li	a5,1
    80202826:	853e                	mv	a0,a5
    80202828:	60e2                	ld	ra,24(sp)
    8020282a:	6442                	ld	s0,16(sp)
    8020282c:	6105                	addi	sp,sp,32
    8020282e:	8082                	ret

0000000080202830 <_set_flag>:
    80202830:	1101                	addi	sp,sp,-32
    80202832:	ec06                	sd	ra,24(sp)
    80202834:	e822                	sd	s0,16(sp)
    80202836:	1000                	addi	s0,sp,32
    80202838:	fea43423          	sd	a0,-24(s0)
    8020283c:	87ae                	mv	a5,a1
    8020283e:	fef403a3          	sb	a5,-25(s0)
    80202842:	fe843783          	ld	a5,-24(s0)
    80202846:	0007c783          	lbu	a5,0(a5)
    8020284a:	fe744703          	lbu	a4,-25(s0)
    8020284e:	8fd9                	or	a5,a5,a4
    80202850:	0ff7f713          	zext.b	a4,a5
    80202854:	fe843783          	ld	a5,-24(s0)
    80202858:	00e78023          	sb	a4,0(a5)
    8020285c:	0001                	nop
    8020285e:	60e2                	ld	ra,24(sp)
    80202860:	6442                	ld	s0,16(sp)
    80202862:	6105                	addi	sp,sp,32
    80202864:	8082                	ret

0000000080202866 <_is_last>:
    80202866:	1101                	addi	sp,sp,-32
    80202868:	ec06                	sd	ra,24(sp)
    8020286a:	e822                	sd	s0,16(sp)
    8020286c:	1000                	addi	s0,sp,32
    8020286e:	fea43423          	sd	a0,-24(s0)
    80202872:	fe843783          	ld	a5,-24(s0)
    80202876:	0007c783          	lbu	a5,0(a5)
    8020287a:	2781                	sext.w	a5,a5
    8020287c:	8b89                	andi	a5,a5,2
    8020287e:	2781                	sext.w	a5,a5
    80202880:	c399                	beqz	a5,80202886 <_is_last+0x20>
    80202882:	4785                	li	a5,1
    80202884:	a011                	j	80202888 <_is_last+0x22>
    80202886:	4781                	li	a5,0
    80202888:	853e                	mv	a0,a5
    8020288a:	60e2                	ld	ra,24(sp)
    8020288c:	6442                	ld	s0,16(sp)
    8020288e:	6105                	addi	sp,sp,32
    80202890:	8082                	ret

0000000080202892 <_align_page>:
    80202892:	7179                	addi	sp,sp,-48
    80202894:	f406                	sd	ra,40(sp)
    80202896:	f022                	sd	s0,32(sp)
    80202898:	1800                	addi	s0,sp,48
    8020289a:	fca43c23          	sd	a0,-40(s0)
    8020289e:	6785                	lui	a5,0x1
    802028a0:	17fd                	addi	a5,a5,-1 # fff <STACK_SIZE-0x1>
    802028a2:	fef43423          	sd	a5,-24(s0)
    802028a6:	fd843703          	ld	a4,-40(s0)
    802028aa:	fe843783          	ld	a5,-24(s0)
    802028ae:	973e                	add	a4,a4,a5
    802028b0:	fe843783          	ld	a5,-24(s0)
    802028b4:	fff7c793          	not	a5,a5
    802028b8:	8ff9                	and	a5,a5,a4
    802028ba:	853e                	mv	a0,a5
    802028bc:	70a2                	ld	ra,40(sp)
    802028be:	7402                	ld	s0,32(sp)
    802028c0:	6145                	addi	sp,sp,48
    802028c2:	8082                	ret

00000000802028c4 <page_init>:
    802028c4:	7179                	addi	sp,sp,-48
    802028c6:	f406                	sd	ra,40(sp)
    802028c8:	f022                	sd	s0,32(sp)
    802028ca:	1800                	addi	s0,sp,48
    802028cc:	00005797          	auipc	a5,0x5
    802028d0:	0a478793          	addi	a5,a5,164 # 80207970 <_text_end>
    802028d4:	639c                	ld	a5,0(a5)
    802028d6:	853e                	mv	a0,a5
    802028d8:	fbbff0ef          	jal	80202892 <_align_page>
    802028dc:	fca43c23          	sd	a0,-40(s0)
    802028e0:	47a1                	li	a5,8
    802028e2:	fcf42a23          	sw	a5,-44(s0)
    802028e6:	00005797          	auipc	a5,0x5
    802028ea:	08a78793          	addi	a5,a5,138 # 80207970 <_text_end>
    802028ee:	6398                	ld	a4,0(a5)
    802028f0:	fd843783          	ld	a5,-40(s0)
    802028f4:	8f1d                	sub	a4,a4,a5
    802028f6:	00005797          	auipc	a5,0x5
    802028fa:	08278793          	addi	a5,a5,130 # 80207978 <HEAP_SIZE>
    802028fe:	639c                	ld	a5,0(a5)
    80202900:	97ba                	add	a5,a5,a4
    80202902:	83b1                	srli	a5,a5,0xc
    80202904:	2781                	sext.w	a5,a5
    80202906:	fd442703          	lw	a4,-44(s0)
    8020290a:	9f99                	subw	a5,a5,a4
    8020290c:	0007871b          	sext.w	a4,a5
    80202910:	0000d797          	auipc	a5,0xd
    80202914:	db078793          	addi	a5,a5,-592 # 8020f6c0 <_num_pages>
    80202918:	c398                	sw	a4,0(a5)
    8020291a:	00005797          	auipc	a5,0x5
    8020291e:	05678793          	addi	a5,a5,86 # 80207970 <_text_end>
    80202922:	638c                	ld	a1,0(a5)
    80202924:	00005797          	auipc	a5,0x5
    80202928:	05478793          	addi	a5,a5,84 # 80207978 <HEAP_SIZE>
    8020292c:	6394                	ld	a3,0(a5)
    8020292e:	0000d797          	auipc	a5,0xd
    80202932:	d9278793          	addi	a5,a5,-622 # 8020f6c0 <_num_pages>
    80202936:	439c                	lw	a5,0(a5)
    80202938:	fd442703          	lw	a4,-44(s0)
    8020293c:	fd843603          	ld	a2,-40(s0)
    80202940:	00006517          	auipc	a0,0x6
    80202944:	96050513          	addi	a0,a0,-1696 # 802082a0 <user_code_end+0x8d0>
    80202948:	f6efe0ef          	jal	802010b6 <printf>
    8020294c:	00005797          	auipc	a5,0x5
    80202950:	02478793          	addi	a5,a5,36 # 80207970 <_text_end>
    80202954:	639c                	ld	a5,0(a5)
    80202956:	fef43423          	sd	a5,-24(s0)
    8020295a:	fe042223          	sw	zero,-28(s0)
    8020295e:	a839                	j	8020297c <page_init+0xb8>
    80202960:	fe843503          	ld	a0,-24(s0)
    80202964:	e83ff0ef          	jal	802027e6 <_clear>
    80202968:	fe843783          	ld	a5,-24(s0)
    8020296c:	0785                	addi	a5,a5,1
    8020296e:	fef43423          	sd	a5,-24(s0)
    80202972:	fe442783          	lw	a5,-28(s0)
    80202976:	2785                	addiw	a5,a5,1
    80202978:	fef42223          	sw	a5,-28(s0)
    8020297c:	fe442703          	lw	a4,-28(s0)
    80202980:	0000d797          	auipc	a5,0xd
    80202984:	d4078793          	addi	a5,a5,-704 # 8020f6c0 <_num_pages>
    80202988:	439c                	lw	a5,0(a5)
    8020298a:	fcf76be3          	bltu	a4,a5,80202960 <page_init+0x9c>
    8020298e:	fd442783          	lw	a5,-44(s0)
    80202992:	00c7979b          	slliw	a5,a5,0xc
    80202996:	2781                	sext.w	a5,a5
    80202998:	02079713          	slli	a4,a5,0x20
    8020299c:	9301                	srli	a4,a4,0x20
    8020299e:	fd843783          	ld	a5,-40(s0)
    802029a2:	973e                	add	a4,a4,a5
    802029a4:	0000d797          	auipc	a5,0xd
    802029a8:	d0c78793          	addi	a5,a5,-756 # 8020f6b0 <_alloc_start>
    802029ac:	e398                	sd	a4,0(a5)
    802029ae:	0000d797          	auipc	a5,0xd
    802029b2:	d1278793          	addi	a5,a5,-750 # 8020f6c0 <_num_pages>
    802029b6:	439c                	lw	a5,0(a5)
    802029b8:	00c7979b          	slliw	a5,a5,0xc
    802029bc:	2781                	sext.w	a5,a5
    802029be:	02079713          	slli	a4,a5,0x20
    802029c2:	9301                	srli	a4,a4,0x20
    802029c4:	0000d797          	auipc	a5,0xd
    802029c8:	cec78793          	addi	a5,a5,-788 # 8020f6b0 <_alloc_start>
    802029cc:	639c                	ld	a5,0(a5)
    802029ce:	973e                	add	a4,a4,a5
    802029d0:	0000d797          	auipc	a5,0xd
    802029d4:	ce878793          	addi	a5,a5,-792 # 8020f6b8 <_alloc_end>
    802029d8:	e398                	sd	a4,0(a5)
    802029da:	00005797          	auipc	a5,0x5
    802029de:	fa678793          	addi	a5,a5,-90 # 80207980 <TEXT_START>
    802029e2:	6398                	ld	a4,0(a5)
    802029e4:	00005797          	auipc	a5,0x5
    802029e8:	fa478793          	addi	a5,a5,-92 # 80207988 <TEXT_END>
    802029ec:	639c                	ld	a5,0(a5)
    802029ee:	863e                	mv	a2,a5
    802029f0:	85ba                	mv	a1,a4
    802029f2:	00006517          	auipc	a0,0x6
    802029f6:	92e50513          	addi	a0,a0,-1746 # 80208320 <user_code_end+0x950>
    802029fa:	ebcfe0ef          	jal	802010b6 <printf>
    802029fe:	00005797          	auipc	a5,0x5
    80202a02:	fa278793          	addi	a5,a5,-94 # 802079a0 <RODATA_START>
    80202a06:	6398                	ld	a4,0(a5)
    80202a08:	00005797          	auipc	a5,0x5
    80202a0c:	fa078793          	addi	a5,a5,-96 # 802079a8 <RODATA_END>
    80202a10:	639c                	ld	a5,0(a5)
    80202a12:	863e                	mv	a2,a5
    80202a14:	85ba                	mv	a1,a4
    80202a16:	00006517          	auipc	a0,0x6
    80202a1a:	92250513          	addi	a0,a0,-1758 # 80208338 <user_code_end+0x968>
    80202a1e:	e98fe0ef          	jal	802010b6 <printf>
    80202a22:	00005797          	auipc	a5,0x5
    80202a26:	f6e78793          	addi	a5,a5,-146 # 80207990 <DATA_START>
    80202a2a:	6398                	ld	a4,0(a5)
    80202a2c:	00005797          	auipc	a5,0x5
    80202a30:	f6c78793          	addi	a5,a5,-148 # 80207998 <DATA_END>
    80202a34:	639c                	ld	a5,0(a5)
    80202a36:	863e                	mv	a2,a5
    80202a38:	85ba                	mv	a1,a4
    80202a3a:	00006517          	auipc	a0,0x6
    80202a3e:	91650513          	addi	a0,a0,-1770 # 80208350 <user_code_end+0x980>
    80202a42:	e74fe0ef          	jal	802010b6 <printf>
    80202a46:	00005797          	auipc	a5,0x5
    80202a4a:	f6a78793          	addi	a5,a5,-150 # 802079b0 <BSS_START>
    80202a4e:	6398                	ld	a4,0(a5)
    80202a50:	00005797          	auipc	a5,0x5
    80202a54:	f6878793          	addi	a5,a5,-152 # 802079b8 <BSS_END>
    80202a58:	639c                	ld	a5,0(a5)
    80202a5a:	863e                	mv	a2,a5
    80202a5c:	85ba                	mv	a1,a4
    80202a5e:	00006517          	auipc	a0,0x6
    80202a62:	90a50513          	addi	a0,a0,-1782 # 80208368 <user_code_end+0x998>
    80202a66:	e50fe0ef          	jal	802010b6 <printf>
    80202a6a:	0000d797          	auipc	a5,0xd
    80202a6e:	c4678793          	addi	a5,a5,-954 # 8020f6b0 <_alloc_start>
    80202a72:	6398                	ld	a4,0(a5)
    80202a74:	0000d797          	auipc	a5,0xd
    80202a78:	c4478793          	addi	a5,a5,-956 # 8020f6b8 <_alloc_end>
    80202a7c:	639c                	ld	a5,0(a5)
    80202a7e:	863e                	mv	a2,a5
    80202a80:	85ba                	mv	a1,a4
    80202a82:	00006517          	auipc	a0,0x6
    80202a86:	8fe50513          	addi	a0,a0,-1794 # 80208380 <user_code_end+0x9b0>
    80202a8a:	e2cfe0ef          	jal	802010b6 <printf>
    80202a8e:	0001                	nop
    80202a90:	70a2                	ld	ra,40(sp)
    80202a92:	7402                	ld	s0,32(sp)
    80202a94:	6145                	addi	sp,sp,48
    80202a96:	8082                	ret

0000000080202a98 <page_alloc>:
    80202a98:	711d                	addi	sp,sp,-96
    80202a9a:	ec86                	sd	ra,88(sp)
    80202a9c:	e8a2                	sd	s0,80(sp)
    80202a9e:	1080                	addi	s0,sp,96
    80202aa0:	87aa                	mv	a5,a0
    80202aa2:	faf42623          	sw	a5,-84(s0)
    80202aa6:	fe042623          	sw	zero,-20(s0)
    80202aaa:	00005797          	auipc	a5,0x5
    80202aae:	ec678793          	addi	a5,a5,-314 # 80207970 <_text_end>
    80202ab2:	639c                	ld	a5,0(a5)
    80202ab4:	fef43023          	sd	a5,-32(s0)
    80202ab8:	fc042e23          	sw	zero,-36(s0)
    80202abc:	a8ed                	j	80202bb6 <page_alloc+0x11e>
    80202abe:	fe043503          	ld	a0,-32(s0)
    80202ac2:	d43ff0ef          	jal	80202804 <_is_free>
    80202ac6:	87aa                	mv	a5,a0
    80202ac8:	cfe9                	beqz	a5,80202ba2 <page_alloc+0x10a>
    80202aca:	4785                	li	a5,1
    80202acc:	fef42623          	sw	a5,-20(s0)
    80202ad0:	fe043783          	ld	a5,-32(s0)
    80202ad4:	0785                	addi	a5,a5,1
    80202ad6:	fcf43823          	sd	a5,-48(s0)
    80202ada:	fdc42783          	lw	a5,-36(s0)
    80202ade:	2785                	addiw	a5,a5,1
    80202ae0:	fcf42623          	sw	a5,-52(s0)
    80202ae4:	a025                	j	80202b0c <page_alloc+0x74>
    80202ae6:	fd043503          	ld	a0,-48(s0)
    80202aea:	d1bff0ef          	jal	80202804 <_is_free>
    80202aee:	87aa                	mv	a5,a0
    80202af0:	e781                	bnez	a5,80202af8 <page_alloc+0x60>
    80202af2:	fe042623          	sw	zero,-20(s0)
    80202af6:	a03d                	j	80202b24 <page_alloc+0x8c>
    80202af8:	fd043783          	ld	a5,-48(s0)
    80202afc:	0785                	addi	a5,a5,1
    80202afe:	fcf43823          	sd	a5,-48(s0)
    80202b02:	fcc42783          	lw	a5,-52(s0)
    80202b06:	2785                	addiw	a5,a5,1
    80202b08:	fcf42623          	sw	a5,-52(s0)
    80202b0c:	fdc42783          	lw	a5,-36(s0)
    80202b10:	873e                	mv	a4,a5
    80202b12:	fac42783          	lw	a5,-84(s0)
    80202b16:	9fb9                	addw	a5,a5,a4
    80202b18:	2781                	sext.w	a5,a5
    80202b1a:	fcc42703          	lw	a4,-52(s0)
    80202b1e:	2701                	sext.w	a4,a4
    80202b20:	fcf743e3          	blt	a4,a5,80202ae6 <page_alloc+0x4e>
    80202b24:	fec42783          	lw	a5,-20(s0)
    80202b28:	2781                	sext.w	a5,a5
    80202b2a:	cfa5                	beqz	a5,80202ba2 <page_alloc+0x10a>
    80202b2c:	fe043783          	ld	a5,-32(s0)
    80202b30:	fcf43023          	sd	a5,-64(s0)
    80202b34:	fdc42783          	lw	a5,-36(s0)
    80202b38:	faf42e23          	sw	a5,-68(s0)
    80202b3c:	a005                	j	80202b5c <page_alloc+0xc4>
    80202b3e:	4585                	li	a1,1
    80202b40:	fc043503          	ld	a0,-64(s0)
    80202b44:	cedff0ef          	jal	80202830 <_set_flag>
    80202b48:	fc043783          	ld	a5,-64(s0)
    80202b4c:	0785                	addi	a5,a5,1
    80202b4e:	fcf43023          	sd	a5,-64(s0)
    80202b52:	fbc42783          	lw	a5,-68(s0)
    80202b56:	2785                	addiw	a5,a5,1
    80202b58:	faf42e23          	sw	a5,-68(s0)
    80202b5c:	fdc42783          	lw	a5,-36(s0)
    80202b60:	873e                	mv	a4,a5
    80202b62:	fac42783          	lw	a5,-84(s0)
    80202b66:	9fb9                	addw	a5,a5,a4
    80202b68:	2781                	sext.w	a5,a5
    80202b6a:	fbc42703          	lw	a4,-68(s0)
    80202b6e:	2701                	sext.w	a4,a4
    80202b70:	fcf747e3          	blt	a4,a5,80202b3e <page_alloc+0xa6>
    80202b74:	fc043783          	ld	a5,-64(s0)
    80202b78:	17fd                	addi	a5,a5,-1
    80202b7a:	fcf43023          	sd	a5,-64(s0)
    80202b7e:	4589                	li	a1,2
    80202b80:	fc043503          	ld	a0,-64(s0)
    80202b84:	cadff0ef          	jal	80202830 <_set_flag>
    80202b88:	fdc42783          	lw	a5,-36(s0)
    80202b8c:	00c7979b          	slliw	a5,a5,0xc
    80202b90:	2781                	sext.w	a5,a5
    80202b92:	873e                	mv	a4,a5
    80202b94:	0000d797          	auipc	a5,0xd
    80202b98:	b1c78793          	addi	a5,a5,-1252 # 8020f6b0 <_alloc_start>
    80202b9c:	639c                	ld	a5,0(a5)
    80202b9e:	97ba                	add	a5,a5,a4
    80202ba0:	a81d                	j	80202bd6 <page_alloc+0x13e>
    80202ba2:	fe043783          	ld	a5,-32(s0)
    80202ba6:	0785                	addi	a5,a5,1
    80202ba8:	fef43023          	sd	a5,-32(s0)
    80202bac:	fdc42783          	lw	a5,-36(s0)
    80202bb0:	2785                	addiw	a5,a5,1
    80202bb2:	fcf42e23          	sw	a5,-36(s0)
    80202bb6:	0000d797          	auipc	a5,0xd
    80202bba:	b0a78793          	addi	a5,a5,-1270 # 8020f6c0 <_num_pages>
    80202bbe:	4398                	lw	a4,0(a5)
    80202bc0:	fac42783          	lw	a5,-84(s0)
    80202bc4:	40f707bb          	subw	a5,a4,a5
    80202bc8:	0007871b          	sext.w	a4,a5
    80202bcc:	fdc42783          	lw	a5,-36(s0)
    80202bd0:	eef777e3          	bgeu	a4,a5,80202abe <page_alloc+0x26>
    80202bd4:	4781                	li	a5,0
    80202bd6:	853e                	mv	a0,a5
    80202bd8:	60e6                	ld	ra,88(sp)
    80202bda:	6446                	ld	s0,80(sp)
    80202bdc:	6125                	addi	sp,sp,96
    80202bde:	8082                	ret

0000000080202be0 <page_free>:
    80202be0:	7179                	addi	sp,sp,-48
    80202be2:	f406                	sd	ra,40(sp)
    80202be4:	f022                	sd	s0,32(sp)
    80202be6:	1800                	addi	s0,sp,48
    80202be8:	fca43c23          	sd	a0,-40(s0)
    80202bec:	fd843783          	ld	a5,-40(s0)
    80202bf0:	cfa5                	beqz	a5,80202c68 <page_free+0x88>
    80202bf2:	fd843703          	ld	a4,-40(s0)
    80202bf6:	0000d797          	auipc	a5,0xd
    80202bfa:	ac278793          	addi	a5,a5,-1342 # 8020f6b8 <_alloc_end>
    80202bfe:	639c                	ld	a5,0(a5)
    80202c00:	06f77463          	bgeu	a4,a5,80202c68 <page_free+0x88>
    80202c04:	00005797          	auipc	a5,0x5
    80202c08:	d6c78793          	addi	a5,a5,-660 # 80207970 <_text_end>
    80202c0c:	639c                	ld	a5,0(a5)
    80202c0e:	fef43423          	sd	a5,-24(s0)
    80202c12:	fd843703          	ld	a4,-40(s0)
    80202c16:	0000d797          	auipc	a5,0xd
    80202c1a:	a9a78793          	addi	a5,a5,-1382 # 8020f6b0 <_alloc_start>
    80202c1e:	639c                	ld	a5,0(a5)
    80202c20:	40f707b3          	sub	a5,a4,a5
    80202c24:	83b1                	srli	a5,a5,0xc
    80202c26:	fe843703          	ld	a4,-24(s0)
    80202c2a:	97ba                	add	a5,a5,a4
    80202c2c:	fef43423          	sd	a5,-24(s0)
    80202c30:	a02d                	j	80202c5a <page_free+0x7a>
    80202c32:	fe843503          	ld	a0,-24(s0)
    80202c36:	c31ff0ef          	jal	80202866 <_is_last>
    80202c3a:	87aa                	mv	a5,a0
    80202c3c:	c791                	beqz	a5,80202c48 <page_free+0x68>
    80202c3e:	fe843503          	ld	a0,-24(s0)
    80202c42:	ba5ff0ef          	jal	802027e6 <_clear>
    80202c46:	a015                	j	80202c6a <page_free+0x8a>
    80202c48:	fe843503          	ld	a0,-24(s0)
    80202c4c:	b9bff0ef          	jal	802027e6 <_clear>
    80202c50:	fe843783          	ld	a5,-24(s0)
    80202c54:	0785                	addi	a5,a5,1
    80202c56:	fef43423          	sd	a5,-24(s0)
    80202c5a:	fe843503          	ld	a0,-24(s0)
    80202c5e:	ba7ff0ef          	jal	80202804 <_is_free>
    80202c62:	87aa                	mv	a5,a0
    80202c64:	d7f9                	beqz	a5,80202c32 <page_free+0x52>
    80202c66:	a011                	j	80202c6a <page_free+0x8a>
    80202c68:	0001                	nop
    80202c6a:	70a2                	ld	ra,40(sp)
    80202c6c:	7402                	ld	s0,32(sp)
    80202c6e:	6145                	addi	sp,sp,48
    80202c70:	8082                	ret

0000000080202c72 <page_test>:
    80202c72:	7179                	addi	sp,sp,-48
    80202c74:	f406                	sd	ra,40(sp)
    80202c76:	f022                	sd	s0,32(sp)
    80202c78:	1800                	addi	s0,sp,48
    80202c7a:	4509                	li	a0,2
    80202c7c:	e1dff0ef          	jal	80202a98 <page_alloc>
    80202c80:	fea43423          	sd	a0,-24(s0)
    80202c84:	fe843583          	ld	a1,-24(s0)
    80202c88:	00005517          	auipc	a0,0x5
    80202c8c:	71050513          	addi	a0,a0,1808 # 80208398 <user_code_end+0x9c8>
    80202c90:	c26fe0ef          	jal	802010b6 <printf>
    80202c94:	451d                	li	a0,7
    80202c96:	e03ff0ef          	jal	80202a98 <page_alloc>
    80202c9a:	fea43023          	sd	a0,-32(s0)
    80202c9e:	fe043583          	ld	a1,-32(s0)
    80202ca2:	00005517          	auipc	a0,0x5
    80202ca6:	6fe50513          	addi	a0,a0,1790 # 802083a0 <user_code_end+0x9d0>
    80202caa:	c0cfe0ef          	jal	802010b6 <printf>
    80202cae:	fe043503          	ld	a0,-32(s0)
    80202cb2:	f2fff0ef          	jal	80202be0 <page_free>
    80202cb6:	4511                	li	a0,4
    80202cb8:	de1ff0ef          	jal	80202a98 <page_alloc>
    80202cbc:	fca43c23          	sd	a0,-40(s0)
    80202cc0:	fd843583          	ld	a1,-40(s0)
    80202cc4:	00005517          	auipc	a0,0x5
    80202cc8:	6ec50513          	addi	a0,a0,1772 # 802083b0 <user_code_end+0x9e0>
    80202ccc:	beafe0ef          	jal	802010b6 <printf>
    80202cd0:	0001                	nop
    80202cd2:	70a2                	ld	ra,40(sp)
    80202cd4:	7402                	ld	s0,32(sp)
    80202cd6:	6145                	addi	sp,sp,48
    80202cd8:	8082                	ret

0000000080202cda <r_sstatus>:
    80202cda:	1101                	addi	sp,sp,-32
    80202cdc:	ec06                	sd	ra,24(sp)
    80202cde:	e822                	sd	s0,16(sp)
    80202ce0:	1000                	addi	s0,sp,32
    80202ce2:	100027f3          	csrr	a5,sstatus
    80202ce6:	fef43423          	sd	a5,-24(s0)
    80202cea:	fe843783          	ld	a5,-24(s0)
    80202cee:	853e                	mv	a0,a5
    80202cf0:	60e2                	ld	ra,24(sp)
    80202cf2:	6442                	ld	s0,16(sp)
    80202cf4:	6105                	addi	sp,sp,32
    80202cf6:	8082                	ret

0000000080202cf8 <w_sstatus>:
    80202cf8:	1101                	addi	sp,sp,-32
    80202cfa:	ec06                	sd	ra,24(sp)
    80202cfc:	e822                	sd	s0,16(sp)
    80202cfe:	1000                	addi	s0,sp,32
    80202d00:	fea43423          	sd	a0,-24(s0)
    80202d04:	fe843783          	ld	a5,-24(s0)
    80202d08:	10079073          	csrw	sstatus,a5
    80202d0c:	0001                	nop
    80202d0e:	60e2                	ld	ra,24(sp)
    80202d10:	6442                	ld	s0,16(sp)
    80202d12:	6105                	addi	sp,sp,32
    80202d14:	8082                	ret

0000000080202d16 <cpu_irq_disable>:
    80202d16:	1141                	addi	sp,sp,-16
    80202d18:	e406                	sd	ra,8(sp)
    80202d1a:	e022                	sd	s0,0(sp)
    80202d1c:	0800                	addi	s0,sp,16
    80202d1e:	fbdff0ef          	jal	80202cda <r_sstatus>
    80202d22:	87aa                	mv	a5,a0
    80202d24:	9bf5                	andi	a5,a5,-3
    80202d26:	853e                	mv	a0,a5
    80202d28:	fd1ff0ef          	jal	80202cf8 <w_sstatus>
    80202d2c:	0001                	nop
    80202d2e:	60a2                	ld	ra,8(sp)
    80202d30:	6402                	ld	s0,0(sp)
    80202d32:	0141                	addi	sp,sp,16
    80202d34:	8082                	ret

0000000080202d36 <cpu_irq_enable>:
    80202d36:	1141                	addi	sp,sp,-16
    80202d38:	e406                	sd	ra,8(sp)
    80202d3a:	e022                	sd	s0,0(sp)
    80202d3c:	0800                	addi	s0,sp,16
    80202d3e:	f9dff0ef          	jal	80202cda <r_sstatus>
    80202d42:	87aa                	mv	a5,a0
    80202d44:	0027e793          	ori	a5,a5,2
    80202d48:	853e                	mv	a0,a5
    80202d4a:	fafff0ef          	jal	80202cf8 <w_sstatus>
    80202d4e:	0001                	nop
    80202d50:	60a2                	ld	ra,8(sp)
    80202d52:	6402                	ld	s0,0(sp)
    80202d54:	0141                	addi	sp,sp,16
    80202d56:	8082                	ret

0000000080202d58 <spin_lock>:
    80202d58:	1141                	addi	sp,sp,-16
    80202d5a:	e406                	sd	ra,8(sp)
    80202d5c:	e022                	sd	s0,0(sp)
    80202d5e:	0800                	addi	s0,sp,16
    80202d60:	fb7ff0ef          	jal	80202d16 <cpu_irq_disable>
    80202d64:	4781                	li	a5,0
    80202d66:	853e                	mv	a0,a5
    80202d68:	60a2                	ld	ra,8(sp)
    80202d6a:	6402                	ld	s0,0(sp)
    80202d6c:	0141                	addi	sp,sp,16
    80202d6e:	8082                	ret

0000000080202d70 <spin_unlock>:
    80202d70:	1141                	addi	sp,sp,-16
    80202d72:	e406                	sd	ra,8(sp)
    80202d74:	e022                	sd	s0,0(sp)
    80202d76:	0800                	addi	s0,sp,16
    80202d78:	0000c797          	auipc	a5,0xc
    80202d7c:	31878793          	addi	a5,a5,792 # 8020f090 <kernel_trap_depth>
    80202d80:	439c                	lw	a5,0(a5)
    80202d82:	2781                	sext.w	a5,a5
    80202d84:	e399                	bnez	a5,80202d8a <spin_unlock+0x1a>
    80202d86:	fb1ff0ef          	jal	80202d36 <cpu_irq_enable>
    80202d8a:	4781                	li	a5,0
    80202d8c:	853e                	mv	a0,a5
    80202d8e:	60a2                	ld	ra,8(sp)
    80202d90:	6402                	ld	s0,0(sp)
    80202d92:	0141                	addi	sp,sp,16
    80202d94:	8082                	ret

0000000080202d96 <proc_init>:
    80202d96:	1101                	addi	sp,sp,-32
    80202d98:	ec06                	sd	ra,24(sp)
    80202d9a:	e822                	sd	s0,16(sp)
    80202d9c:	1000                	addi	s0,sp,32
    80202d9e:	fe042623          	sw	zero,-20(s0)
    80202da2:	a065                	j	80202e4a <proc_init+0xb4>
    80202da4:	0000d697          	auipc	a3,0xd
    80202da8:	92468693          	addi	a3,a3,-1756 # 8020f6c8 <procs>
    80202dac:	fec42703          	lw	a4,-20(s0)
    80202db0:	87ba                	mv	a5,a4
    80202db2:	0786                	slli	a5,a5,0x1
    80202db4:	97ba                	add	a5,a5,a4
    80202db6:	0792                	slli	a5,a5,0x4
    80202db8:	97b6                	add	a5,a5,a3
    80202dba:	577d                	li	a4,-1
    80202dbc:	c398                	sw	a4,0(a5)
    80202dbe:	0000d697          	auipc	a3,0xd
    80202dc2:	90a68693          	addi	a3,a3,-1782 # 8020f6c8 <procs>
    80202dc6:	fec42703          	lw	a4,-20(s0)
    80202dca:	87ba                	mv	a5,a4
    80202dcc:	0786                	slli	a5,a5,0x1
    80202dce:	97ba                	add	a5,a5,a4
    80202dd0:	0792                	slli	a5,a5,0x4
    80202dd2:	97b6                	add	a5,a5,a3
    80202dd4:	0007a223          	sw	zero,4(a5)
    80202dd8:	0000d697          	auipc	a3,0xd
    80202ddc:	8f068693          	addi	a3,a3,-1808 # 8020f6c8 <procs>
    80202de0:	fec42703          	lw	a4,-20(s0)
    80202de4:	87ba                	mv	a5,a4
    80202de6:	0786                	slli	a5,a5,0x1
    80202de8:	97ba                	add	a5,a5,a4
    80202dea:	0792                	slli	a5,a5,0x4
    80202dec:	97b6                	add	a5,a5,a3
    80202dee:	0007a423          	sw	zero,8(a5)
    80202df2:	0000d697          	auipc	a3,0xd
    80202df6:	8d668693          	addi	a3,a3,-1834 # 8020f6c8 <procs>
    80202dfa:	fec42703          	lw	a4,-20(s0)
    80202dfe:	87ba                	mv	a5,a4
    80202e00:	0786                	slli	a5,a5,0x1
    80202e02:	97ba                	add	a5,a5,a4
    80202e04:	0792                	slli	a5,a5,0x4
    80202e06:	97b6                	add	a5,a5,a3
    80202e08:	00078623          	sb	zero,12(a5)
    80202e0c:	0000d697          	auipc	a3,0xd
    80202e10:	8bc68693          	addi	a3,a3,-1860 # 8020f6c8 <procs>
    80202e14:	fec42703          	lw	a4,-20(s0)
    80202e18:	87ba                	mv	a5,a4
    80202e1a:	0786                	slli	a5,a5,0x1
    80202e1c:	97ba                	add	a5,a5,a4
    80202e1e:	0792                	slli	a5,a5,0x4
    80202e20:	97b6                	add	a5,a5,a3
    80202e22:	0207b023          	sd	zero,32(a5)
    80202e26:	0000d697          	auipc	a3,0xd
    80202e2a:	8a268693          	addi	a3,a3,-1886 # 8020f6c8 <procs>
    80202e2e:	fec42703          	lw	a4,-20(s0)
    80202e32:	87ba                	mv	a5,a4
    80202e34:	0786                	slli	a5,a5,0x1
    80202e36:	97ba                	add	a5,a5,a4
    80202e38:	0792                	slli	a5,a5,0x4
    80202e3a:	97b6                	add	a5,a5,a3
    80202e3c:	577d                	li	a4,-1
    80202e3e:	d798                	sw	a4,40(a5)
    80202e40:	fec42783          	lw	a5,-20(s0)
    80202e44:	2785                	addiw	a5,a5,1
    80202e46:	fef42623          	sw	a5,-20(s0)
    80202e4a:	fec42783          	lw	a5,-20(s0)
    80202e4e:	0007871b          	sext.w	a4,a5
    80202e52:	47bd                	li	a5,15
    80202e54:	f4e7d8e3          	bge	a5,a4,80202da4 <proc_init+0xe>
    80202e58:	0000d797          	auipc	a5,0xd
    80202e5c:	87078793          	addi	a5,a5,-1936 # 8020f6c8 <procs>
    80202e60:	0007a023          	sw	zero,0(a5)
    80202e64:	0000d797          	auipc	a5,0xd
    80202e68:	86478793          	addi	a5,a5,-1948 # 8020f6c8 <procs>
    80202e6c:	0007a223          	sw	zero,4(a5)
    80202e70:	0000d797          	auipc	a5,0xd
    80202e74:	85878793          	addi	a5,a5,-1960 # 8020f6c8 <procs>
    80202e78:	4709                	li	a4,2
    80202e7a:	c798                	sw	a4,8(a5)
    80202e7c:	00005797          	auipc	a5,0x5
    80202e80:	54478793          	addi	a5,a5,1348 # 802083c0 <user_code_end+0x9f0>
    80202e84:	fef43023          	sd	a5,-32(s0)
    80202e88:	fe042423          	sw	zero,-24(s0)
    80202e8c:	a035                	j	80202eb8 <proc_init+0x122>
    80202e8e:	fe842783          	lw	a5,-24(s0)
    80202e92:	fe043703          	ld	a4,-32(s0)
    80202e96:	97ba                	add	a5,a5,a4
    80202e98:	0007c703          	lbu	a4,0(a5)
    80202e9c:	0000d697          	auipc	a3,0xd
    80202ea0:	82c68693          	addi	a3,a3,-2004 # 8020f6c8 <procs>
    80202ea4:	fe842783          	lw	a5,-24(s0)
    80202ea8:	97b6                	add	a5,a5,a3
    80202eaa:	00e78623          	sb	a4,12(a5)
    80202eae:	fe842783          	lw	a5,-24(s0)
    80202eb2:	2785                	addiw	a5,a5,1
    80202eb4:	fef42423          	sw	a5,-24(s0)
    80202eb8:	fe842783          	lw	a5,-24(s0)
    80202ebc:	fe043703          	ld	a4,-32(s0)
    80202ec0:	97ba                	add	a5,a5,a4
    80202ec2:	0007c783          	lbu	a5,0(a5)
    80202ec6:	cb81                	beqz	a5,80202ed6 <proc_init+0x140>
    80202ec8:	fe842783          	lw	a5,-24(s0)
    80202ecc:	0007871b          	sext.w	a4,a5
    80202ed0:	47b9                	li	a5,14
    80202ed2:	fae7dee3          	bge	a5,a4,80202e8e <proc_init+0xf8>
    80202ed6:	0000c717          	auipc	a4,0xc
    80202eda:	7f270713          	addi	a4,a4,2034 # 8020f6c8 <procs>
    80202ede:	fe842783          	lw	a5,-24(s0)
    80202ee2:	97ba                	add	a5,a5,a4
    80202ee4:	00078623          	sb	zero,12(a5)
    80202ee8:	0000c797          	auipc	a5,0xc
    80202eec:	11878793          	addi	a5,a5,280 # 8020f000 <proc_top>
    80202ef0:	4705                	li	a4,1
    80202ef2:	c398                	sw	a4,0(a5)
    80202ef4:	0001                	nop
    80202ef6:	60e2                	ld	ra,24(sp)
    80202ef8:	6442                	ld	s0,16(sp)
    80202efa:	6105                	addi	sp,sp,32
    80202efc:	8082                	ret

0000000080202efe <proc_alloc>:
    80202efe:	7179                	addi	sp,sp,-48
    80202f00:	f406                	sd	ra,40(sp)
    80202f02:	f022                	sd	s0,32(sp)
    80202f04:	1800                	addi	s0,sp,48
    80202f06:	fca43c23          	sd	a0,-40(s0)
    80202f0a:	87ae                	mv	a5,a1
    80202f0c:	fcf42a23          	sw	a5,-44(s0)
    80202f10:	4785                	li	a5,1
    80202f12:	fef42623          	sw	a5,-20(s0)
    80202f16:	aabd                	j	80203094 <proc_alloc+0x196>
    80202f18:	0000c697          	auipc	a3,0xc
    80202f1c:	7b068693          	addi	a3,a3,1968 # 8020f6c8 <procs>
    80202f20:	fec42703          	lw	a4,-20(s0)
    80202f24:	87ba                	mv	a5,a4
    80202f26:	0786                	slli	a5,a5,0x1
    80202f28:	97ba                	add	a5,a5,a4
    80202f2a:	0792                	slli	a5,a5,0x4
    80202f2c:	97b6                	add	a5,a5,a3
    80202f2e:	479c                	lw	a5,8(a5)
    80202f30:	14079c63          	bnez	a5,80203088 <proc_alloc+0x18a>
    80202f34:	0000c797          	auipc	a5,0xc
    80202f38:	0cc78793          	addi	a5,a5,204 # 8020f000 <proc_top>
    80202f3c:	4398                	lw	a4,0(a5)
    80202f3e:	0017079b          	addiw	a5,a4,1
    80202f42:	0007869b          	sext.w	a3,a5
    80202f46:	0000c797          	auipc	a5,0xc
    80202f4a:	0ba78793          	addi	a5,a5,186 # 8020f000 <proc_top>
    80202f4e:	c394                	sw	a3,0(a5)
    80202f50:	0000c617          	auipc	a2,0xc
    80202f54:	77860613          	addi	a2,a2,1912 # 8020f6c8 <procs>
    80202f58:	fec42683          	lw	a3,-20(s0)
    80202f5c:	87b6                	mv	a5,a3
    80202f5e:	0786                	slli	a5,a5,0x1
    80202f60:	97b6                	add	a5,a5,a3
    80202f62:	0792                	slli	a5,a5,0x4
    80202f64:	97b2                	add	a5,a5,a2
    80202f66:	c398                	sw	a4,0(a5)
    80202f68:	0000c697          	auipc	a3,0xc
    80202f6c:	76068693          	addi	a3,a3,1888 # 8020f6c8 <procs>
    80202f70:	fec42703          	lw	a4,-20(s0)
    80202f74:	87ba                	mv	a5,a4
    80202f76:	0786                	slli	a5,a5,0x1
    80202f78:	97ba                	add	a5,a5,a4
    80202f7a:	0792                	slli	a5,a5,0x4
    80202f7c:	97b6                	add	a5,a5,a3
    80202f7e:	fd442703          	lw	a4,-44(s0)
    80202f82:	c3d8                	sw	a4,4(a5)
    80202f84:	0000c697          	auipc	a3,0xc
    80202f88:	74468693          	addi	a3,a3,1860 # 8020f6c8 <procs>
    80202f8c:	fec42703          	lw	a4,-20(s0)
    80202f90:	87ba                	mv	a5,a4
    80202f92:	0786                	slli	a5,a5,0x1
    80202f94:	97ba                	add	a5,a5,a4
    80202f96:	0792                	slli	a5,a5,0x4
    80202f98:	97b6                	add	a5,a5,a3
    80202f9a:	4705                	li	a4,1
    80202f9c:	c798                	sw	a4,8(a5)
    80202f9e:	0000c697          	auipc	a3,0xc
    80202fa2:	72a68693          	addi	a3,a3,1834 # 8020f6c8 <procs>
    80202fa6:	fec42703          	lw	a4,-20(s0)
    80202faa:	87ba                	mv	a5,a4
    80202fac:	0786                	slli	a5,a5,0x1
    80202fae:	97ba                	add	a5,a5,a4
    80202fb0:	0792                	slli	a5,a5,0x4
    80202fb2:	97b6                	add	a5,a5,a3
    80202fb4:	0207b023          	sd	zero,32(a5)
    80202fb8:	0000c697          	auipc	a3,0xc
    80202fbc:	71068693          	addi	a3,a3,1808 # 8020f6c8 <procs>
    80202fc0:	fec42703          	lw	a4,-20(s0)
    80202fc4:	87ba                	mv	a5,a4
    80202fc6:	0786                	slli	a5,a5,0x1
    80202fc8:	97ba                	add	a5,a5,a4
    80202fca:	0792                	slli	a5,a5,0x4
    80202fcc:	97b6                	add	a5,a5,a3
    80202fce:	577d                	li	a4,-1
    80202fd0:	d798                	sw	a4,40(a5)
    80202fd2:	0000c697          	auipc	a3,0xc
    80202fd6:	6f668693          	addi	a3,a3,1782 # 8020f6c8 <procs>
    80202fda:	fec42703          	lw	a4,-20(s0)
    80202fde:	87ba                	mv	a5,a4
    80202fe0:	0786                	slli	a5,a5,0x1
    80202fe2:	97ba                	add	a5,a5,a4
    80202fe4:	0792                	slli	a5,a5,0x4
    80202fe6:	97b6                	add	a5,a5,a3
    80202fe8:	00078623          	sb	zero,12(a5)
    80202fec:	fd843783          	ld	a5,-40(s0)
    80202ff0:	cfbd                	beqz	a5,8020306e <proc_alloc+0x170>
    80202ff2:	fe042423          	sw	zero,-24(s0)
    80202ff6:	a82d                	j	80203030 <proc_alloc+0x132>
    80202ff8:	fe842783          	lw	a5,-24(s0)
    80202ffc:	fd843703          	ld	a4,-40(s0)
    80203000:	97ba                	add	a5,a5,a4
    80203002:	0007c683          	lbu	a3,0(a5)
    80203006:	0000c597          	auipc	a1,0xc
    8020300a:	6c258593          	addi	a1,a1,1730 # 8020f6c8 <procs>
    8020300e:	fe842603          	lw	a2,-24(s0)
    80203012:	fec42703          	lw	a4,-20(s0)
    80203016:	87ba                	mv	a5,a4
    80203018:	0786                	slli	a5,a5,0x1
    8020301a:	97ba                	add	a5,a5,a4
    8020301c:	0792                	slli	a5,a5,0x4
    8020301e:	97ae                	add	a5,a5,a1
    80203020:	97b2                	add	a5,a5,a2
    80203022:	00d78623          	sb	a3,12(a5)
    80203026:	fe842783          	lw	a5,-24(s0)
    8020302a:	2785                	addiw	a5,a5,1
    8020302c:	fef42423          	sw	a5,-24(s0)
    80203030:	fe842783          	lw	a5,-24(s0)
    80203034:	fd843703          	ld	a4,-40(s0)
    80203038:	97ba                	add	a5,a5,a4
    8020303a:	0007c783          	lbu	a5,0(a5)
    8020303e:	cb81                	beqz	a5,8020304e <proc_alloc+0x150>
    80203040:	fe842783          	lw	a5,-24(s0)
    80203044:	0007871b          	sext.w	a4,a5
    80203048:	47b9                	li	a5,14
    8020304a:	fae7d7e3          	bge	a5,a4,80202ff8 <proc_alloc+0xfa>
    8020304e:	0000c617          	auipc	a2,0xc
    80203052:	67a60613          	addi	a2,a2,1658 # 8020f6c8 <procs>
    80203056:	fe842683          	lw	a3,-24(s0)
    8020305a:	fec42703          	lw	a4,-20(s0)
    8020305e:	87ba                	mv	a5,a4
    80203060:	0786                	slli	a5,a5,0x1
    80203062:	97ba                	add	a5,a5,a4
    80203064:	0792                	slli	a5,a5,0x4
    80203066:	97b2                	add	a5,a5,a2
    80203068:	97b6                	add	a5,a5,a3
    8020306a:	00078623          	sb	zero,12(a5)
    8020306e:	0000c697          	auipc	a3,0xc
    80203072:	65a68693          	addi	a3,a3,1626 # 8020f6c8 <procs>
    80203076:	fec42703          	lw	a4,-20(s0)
    8020307a:	87ba                	mv	a5,a4
    8020307c:	0786                	slli	a5,a5,0x1
    8020307e:	97ba                	add	a5,a5,a4
    80203080:	0792                	slli	a5,a5,0x4
    80203082:	97b6                	add	a5,a5,a3
    80203084:	439c                	lw	a5,0(a5)
    80203086:	a839                	j	802030a4 <proc_alloc+0x1a6>
    80203088:	0001                	nop
    8020308a:	fec42783          	lw	a5,-20(s0)
    8020308e:	2785                	addiw	a5,a5,1
    80203090:	fef42623          	sw	a5,-20(s0)
    80203094:	fec42783          	lw	a5,-20(s0)
    80203098:	0007871b          	sext.w	a4,a5
    8020309c:	47bd                	li	a5,15
    8020309e:	e6e7dde3          	bge	a5,a4,80202f18 <proc_alloc+0x1a>
    802030a2:	57fd                	li	a5,-1
    802030a4:	853e                	mv	a0,a5
    802030a6:	70a2                	ld	ra,40(sp)
    802030a8:	7402                	ld	s0,32(sp)
    802030aa:	6145                	addi	sp,sp,48
    802030ac:	8082                	ret

00000000802030ae <proc_set_name>:
    802030ae:	7179                	addi	sp,sp,-48
    802030b0:	f406                	sd	ra,40(sp)
    802030b2:	f022                	sd	s0,32(sp)
    802030b4:	1800                	addi	s0,sp,48
    802030b6:	87aa                	mv	a5,a0
    802030b8:	fcb43823          	sd	a1,-48(s0)
    802030bc:	fcf42e23          	sw	a5,-36(s0)
    802030c0:	fe042623          	sw	zero,-20(s0)
    802030c4:	a855                	j	80203178 <proc_set_name+0xca>
    802030c6:	0000c697          	auipc	a3,0xc
    802030ca:	60268693          	addi	a3,a3,1538 # 8020f6c8 <procs>
    802030ce:	fec42703          	lw	a4,-20(s0)
    802030d2:	87ba                	mv	a5,a4
    802030d4:	0786                	slli	a5,a5,0x1
    802030d6:	97ba                	add	a5,a5,a4
    802030d8:	0792                	slli	a5,a5,0x4
    802030da:	97b6                	add	a5,a5,a3
    802030dc:	439c                	lw	a5,0(a5)
    802030de:	fdc42703          	lw	a4,-36(s0)
    802030e2:	2701                	sext.w	a4,a4
    802030e4:	08f71463          	bne	a4,a5,8020316c <proc_set_name+0xbe>
    802030e8:	fe042423          	sw	zero,-24(s0)
    802030ec:	a82d                	j	80203126 <proc_set_name+0x78>
    802030ee:	fe842783          	lw	a5,-24(s0)
    802030f2:	fd043703          	ld	a4,-48(s0)
    802030f6:	97ba                	add	a5,a5,a4
    802030f8:	0007c683          	lbu	a3,0(a5)
    802030fc:	0000c597          	auipc	a1,0xc
    80203100:	5cc58593          	addi	a1,a1,1484 # 8020f6c8 <procs>
    80203104:	fe842603          	lw	a2,-24(s0)
    80203108:	fec42703          	lw	a4,-20(s0)
    8020310c:	87ba                	mv	a5,a4
    8020310e:	0786                	slli	a5,a5,0x1
    80203110:	97ba                	add	a5,a5,a4
    80203112:	0792                	slli	a5,a5,0x4
    80203114:	97ae                	add	a5,a5,a1
    80203116:	97b2                	add	a5,a5,a2
    80203118:	00d78623          	sb	a3,12(a5)
    8020311c:	fe842783          	lw	a5,-24(s0)
    80203120:	2785                	addiw	a5,a5,1
    80203122:	fef42423          	sw	a5,-24(s0)
    80203126:	fd043783          	ld	a5,-48(s0)
    8020312a:	c385                	beqz	a5,8020314a <proc_set_name+0x9c>
    8020312c:	fe842783          	lw	a5,-24(s0)
    80203130:	fd043703          	ld	a4,-48(s0)
    80203134:	97ba                	add	a5,a5,a4
    80203136:	0007c783          	lbu	a5,0(a5)
    8020313a:	cb81                	beqz	a5,8020314a <proc_set_name+0x9c>
    8020313c:	fe842783          	lw	a5,-24(s0)
    80203140:	0007871b          	sext.w	a4,a5
    80203144:	47b9                	li	a5,14
    80203146:	fae7d4e3          	bge	a5,a4,802030ee <proc_set_name+0x40>
    8020314a:	0000c617          	auipc	a2,0xc
    8020314e:	57e60613          	addi	a2,a2,1406 # 8020f6c8 <procs>
    80203152:	fe842683          	lw	a3,-24(s0)
    80203156:	fec42703          	lw	a4,-20(s0)
    8020315a:	87ba                	mv	a5,a4
    8020315c:	0786                	slli	a5,a5,0x1
    8020315e:	97ba                	add	a5,a5,a4
    80203160:	0792                	slli	a5,a5,0x4
    80203162:	97b2                	add	a5,a5,a2
    80203164:	97b6                	add	a5,a5,a3
    80203166:	00078623          	sb	zero,12(a5)
    8020316a:	a831                	j	80203186 <proc_set_name+0xd8>
    8020316c:	0001                	nop
    8020316e:	fec42783          	lw	a5,-20(s0)
    80203172:	2785                	addiw	a5,a5,1
    80203174:	fef42623          	sw	a5,-20(s0)
    80203178:	fec42783          	lw	a5,-20(s0)
    8020317c:	0007871b          	sext.w	a4,a5
    80203180:	47bd                	li	a5,15
    80203182:	f4e7d2e3          	bge	a5,a4,802030c6 <proc_set_name+0x18>
    80203186:	70a2                	ld	ra,40(sp)
    80203188:	7402                	ld	s0,32(sp)
    8020318a:	6145                	addi	sp,sp,48
    8020318c:	8082                	ret

000000008020318e <proc_set_state>:
    8020318e:	7179                	addi	sp,sp,-48
    80203190:	f406                	sd	ra,40(sp)
    80203192:	f022                	sd	s0,32(sp)
    80203194:	1800                	addi	s0,sp,48
    80203196:	87aa                	mv	a5,a0
    80203198:	872e                	mv	a4,a1
    8020319a:	fcf42e23          	sw	a5,-36(s0)
    8020319e:	87ba                	mv	a5,a4
    802031a0:	fcf42c23          	sw	a5,-40(s0)
    802031a4:	fe042623          	sw	zero,-20(s0)
    802031a8:	a0b1                	j	802031f4 <proc_set_state+0x66>
    802031aa:	0000c697          	auipc	a3,0xc
    802031ae:	51e68693          	addi	a3,a3,1310 # 8020f6c8 <procs>
    802031b2:	fec42703          	lw	a4,-20(s0)
    802031b6:	87ba                	mv	a5,a4
    802031b8:	0786                	slli	a5,a5,0x1
    802031ba:	97ba                	add	a5,a5,a4
    802031bc:	0792                	slli	a5,a5,0x4
    802031be:	97b6                	add	a5,a5,a3
    802031c0:	439c                	lw	a5,0(a5)
    802031c2:	fdc42703          	lw	a4,-36(s0)
    802031c6:	2701                	sext.w	a4,a4
    802031c8:	02f71163          	bne	a4,a5,802031ea <proc_set_state+0x5c>
    802031cc:	0000c697          	auipc	a3,0xc
    802031d0:	4fc68693          	addi	a3,a3,1276 # 8020f6c8 <procs>
    802031d4:	fec42703          	lw	a4,-20(s0)
    802031d8:	87ba                	mv	a5,a4
    802031da:	0786                	slli	a5,a5,0x1
    802031dc:	97ba                	add	a5,a5,a4
    802031de:	0792                	slli	a5,a5,0x4
    802031e0:	97b6                	add	a5,a5,a3
    802031e2:	fd842703          	lw	a4,-40(s0)
    802031e6:	c798                	sw	a4,8(a5)
    802031e8:	a829                	j	80203202 <proc_set_state+0x74>
    802031ea:	fec42783          	lw	a5,-20(s0)
    802031ee:	2785                	addiw	a5,a5,1
    802031f0:	fef42623          	sw	a5,-20(s0)
    802031f4:	fec42783          	lw	a5,-20(s0)
    802031f8:	0007871b          	sext.w	a4,a5
    802031fc:	47bd                	li	a5,15
    802031fe:	fae7d6e3          	bge	a5,a4,802031aa <proc_set_state+0x1c>
    80203202:	70a2                	ld	ra,40(sp)
    80203204:	7402                	ld	s0,32(sp)
    80203206:	6145                	addi	sp,sp,48
    80203208:	8082                	ret

000000008020320a <proc_slot_by_pid>:
    8020320a:	7179                	addi	sp,sp,-48
    8020320c:	f406                	sd	ra,40(sp)
    8020320e:	f022                	sd	s0,32(sp)
    80203210:	1800                	addi	s0,sp,48
    80203212:	87aa                	mv	a5,a0
    80203214:	fcf42e23          	sw	a5,-36(s0)
    80203218:	fe042623          	sw	zero,-20(s0)
    8020321c:	a0b9                	j	8020326a <proc_slot_by_pid+0x60>
    8020321e:	0000c697          	auipc	a3,0xc
    80203222:	4aa68693          	addi	a3,a3,1194 # 8020f6c8 <procs>
    80203226:	fec42703          	lw	a4,-20(s0)
    8020322a:	87ba                	mv	a5,a4
    8020322c:	0786                	slli	a5,a5,0x1
    8020322e:	97ba                	add	a5,a5,a4
    80203230:	0792                	slli	a5,a5,0x4
    80203232:	97b6                	add	a5,a5,a3
    80203234:	439c                	lw	a5,0(a5)
    80203236:	fdc42703          	lw	a4,-36(s0)
    8020323a:	2701                	sext.w	a4,a4
    8020323c:	02f71263          	bne	a4,a5,80203260 <proc_slot_by_pid+0x56>
    80203240:	0000c697          	auipc	a3,0xc
    80203244:	48868693          	addi	a3,a3,1160 # 8020f6c8 <procs>
    80203248:	fec42703          	lw	a4,-20(s0)
    8020324c:	87ba                	mv	a5,a4
    8020324e:	0786                	slli	a5,a5,0x1
    80203250:	97ba                	add	a5,a5,a4
    80203252:	0792                	slli	a5,a5,0x4
    80203254:	97b6                	add	a5,a5,a3
    80203256:	479c                	lw	a5,8(a5)
    80203258:	c781                	beqz	a5,80203260 <proc_slot_by_pid+0x56>
    8020325a:	fec42783          	lw	a5,-20(s0)
    8020325e:	a831                	j	8020327a <proc_slot_by_pid+0x70>
    80203260:	fec42783          	lw	a5,-20(s0)
    80203264:	2785                	addiw	a5,a5,1
    80203266:	fef42623          	sw	a5,-20(s0)
    8020326a:	fec42783          	lw	a5,-20(s0)
    8020326e:	0007871b          	sext.w	a4,a5
    80203272:	47bd                	li	a5,15
    80203274:	fae7d5e3          	bge	a5,a4,8020321e <proc_slot_by_pid+0x14>
    80203278:	57fd                	li	a5,-1
    8020327a:	853e                	mv	a0,a5
    8020327c:	70a2                	ld	ra,40(sp)
    8020327e:	7402                	ld	s0,32(sp)
    80203280:	6145                	addi	sp,sp,48
    80203282:	8082                	ret

0000000080203284 <proc_count>:
    80203284:	1101                	addi	sp,sp,-32
    80203286:	ec06                	sd	ra,24(sp)
    80203288:	e822                	sd	s0,16(sp)
    8020328a:	1000                	addi	s0,sp,32
    8020328c:	fe042423          	sw	zero,-24(s0)
    80203290:	fe042623          	sw	zero,-20(s0)
    80203294:	a805                	j	802032c4 <proc_count+0x40>
    80203296:	0000c697          	auipc	a3,0xc
    8020329a:	43268693          	addi	a3,a3,1074 # 8020f6c8 <procs>
    8020329e:	fec42703          	lw	a4,-20(s0)
    802032a2:	87ba                	mv	a5,a4
    802032a4:	0786                	slli	a5,a5,0x1
    802032a6:	97ba                	add	a5,a5,a4
    802032a8:	0792                	slli	a5,a5,0x4
    802032aa:	97b6                	add	a5,a5,a3
    802032ac:	479c                	lw	a5,8(a5)
    802032ae:	c791                	beqz	a5,802032ba <proc_count+0x36>
    802032b0:	fe842783          	lw	a5,-24(s0)
    802032b4:	2785                	addiw	a5,a5,1
    802032b6:	fef42423          	sw	a5,-24(s0)
    802032ba:	fec42783          	lw	a5,-20(s0)
    802032be:	2785                	addiw	a5,a5,1
    802032c0:	fef42623          	sw	a5,-20(s0)
    802032c4:	fec42783          	lw	a5,-20(s0)
    802032c8:	0007871b          	sext.w	a4,a5
    802032cc:	47bd                	li	a5,15
    802032ce:	fce7d4e3          	bge	a5,a4,80203296 <proc_count+0x12>
    802032d2:	fe842783          	lw	a5,-24(s0)
    802032d6:	853e                	mv	a0,a5
    802032d8:	60e2                	ld	ra,24(sp)
    802032da:	6442                	ld	s0,16(sp)
    802032dc:	6105                	addi	sp,sp,32
    802032de:	8082                	ret

00000000802032e0 <proc_list>:
    802032e0:	7179                	addi	sp,sp,-48
    802032e2:	f406                	sd	ra,40(sp)
    802032e4:	f022                	sd	s0,32(sp)
    802032e6:	1800                	addi	s0,sp,48
    802032e8:	fca43c23          	sd	a0,-40(s0)
    802032ec:	87ae                	mv	a5,a1
    802032ee:	fcf42a23          	sw	a5,-44(s0)
    802032f2:	fe042423          	sw	zero,-24(s0)
    802032f6:	fe042623          	sw	zero,-20(s0)
    802032fa:	a295                	j	8020345e <proc_list+0x17e>
    802032fc:	0000c697          	auipc	a3,0xc
    80203300:	3cc68693          	addi	a3,a3,972 # 8020f6c8 <procs>
    80203304:	fec42703          	lw	a4,-20(s0)
    80203308:	87ba                	mv	a5,a4
    8020330a:	0786                	slli	a5,a5,0x1
    8020330c:	97ba                	add	a5,a5,a4
    8020330e:	0792                	slli	a5,a5,0x4
    80203310:	97b6                	add	a5,a5,a3
    80203312:	479c                	lw	a5,8(a5)
    80203314:	12078f63          	beqz	a5,80203452 <proc_list+0x172>
    80203318:	fe842703          	lw	a4,-24(s0)
    8020331c:	87ba                	mv	a5,a4
    8020331e:	078e                	slli	a5,a5,0x3
    80203320:	8f99                	sub	a5,a5,a4
    80203322:	078a                	slli	a5,a5,0x2
    80203324:	873e                	mv	a4,a5
    80203326:	fd843783          	ld	a5,-40(s0)
    8020332a:	00e786b3          	add	a3,a5,a4
    8020332e:	0000c617          	auipc	a2,0xc
    80203332:	39a60613          	addi	a2,a2,922 # 8020f6c8 <procs>
    80203336:	fec42703          	lw	a4,-20(s0)
    8020333a:	87ba                	mv	a5,a4
    8020333c:	0786                	slli	a5,a5,0x1
    8020333e:	97ba                	add	a5,a5,a4
    80203340:	0792                	slli	a5,a5,0x4
    80203342:	97b2                	add	a5,a5,a2
    80203344:	439c                	lw	a5,0(a5)
    80203346:	c29c                	sw	a5,0(a3)
    80203348:	fe842703          	lw	a4,-24(s0)
    8020334c:	87ba                	mv	a5,a4
    8020334e:	078e                	slli	a5,a5,0x3
    80203350:	8f99                	sub	a5,a5,a4
    80203352:	078a                	slli	a5,a5,0x2
    80203354:	873e                	mv	a4,a5
    80203356:	fd843783          	ld	a5,-40(s0)
    8020335a:	00e786b3          	add	a3,a5,a4
    8020335e:	0000c617          	auipc	a2,0xc
    80203362:	36a60613          	addi	a2,a2,874 # 8020f6c8 <procs>
    80203366:	fec42703          	lw	a4,-20(s0)
    8020336a:	87ba                	mv	a5,a4
    8020336c:	0786                	slli	a5,a5,0x1
    8020336e:	97ba                	add	a5,a5,a4
    80203370:	0792                	slli	a5,a5,0x4
    80203372:	97b2                	add	a5,a5,a2
    80203374:	43dc                	lw	a5,4(a5)
    80203376:	c2dc                	sw	a5,4(a3)
    80203378:	fe842703          	lw	a4,-24(s0)
    8020337c:	87ba                	mv	a5,a4
    8020337e:	078e                	slli	a5,a5,0x3
    80203380:	8f99                	sub	a5,a5,a4
    80203382:	078a                	slli	a5,a5,0x2
    80203384:	873e                	mv	a4,a5
    80203386:	fd843783          	ld	a5,-40(s0)
    8020338a:	00e786b3          	add	a3,a5,a4
    8020338e:	0000c617          	auipc	a2,0xc
    80203392:	33a60613          	addi	a2,a2,826 # 8020f6c8 <procs>
    80203396:	fec42703          	lw	a4,-20(s0)
    8020339a:	87ba                	mv	a5,a4
    8020339c:	0786                	slli	a5,a5,0x1
    8020339e:	97ba                	add	a5,a5,a4
    802033a0:	0792                	slli	a5,a5,0x4
    802033a2:	97b2                	add	a5,a5,a2
    802033a4:	479c                	lw	a5,8(a5)
    802033a6:	c69c                	sw	a5,8(a3)
    802033a8:	fe042223          	sw	zero,-28(s0)
    802033ac:	a0b1                	j	802033f8 <proc_list+0x118>
    802033ae:	fe842703          	lw	a4,-24(s0)
    802033b2:	87ba                	mv	a5,a4
    802033b4:	078e                	slli	a5,a5,0x3
    802033b6:	8f99                	sub	a5,a5,a4
    802033b8:	078a                	slli	a5,a5,0x2
    802033ba:	873e                	mv	a4,a5
    802033bc:	fd843783          	ld	a5,-40(s0)
    802033c0:	00e786b3          	add	a3,a5,a4
    802033c4:	0000c597          	auipc	a1,0xc
    802033c8:	30458593          	addi	a1,a1,772 # 8020f6c8 <procs>
    802033cc:	fe442603          	lw	a2,-28(s0)
    802033d0:	fec42703          	lw	a4,-20(s0)
    802033d4:	87ba                	mv	a5,a4
    802033d6:	0786                	slli	a5,a5,0x1
    802033d8:	97ba                	add	a5,a5,a4
    802033da:	0792                	slli	a5,a5,0x4
    802033dc:	97ae                	add	a5,a5,a1
    802033de:	97b2                	add	a5,a5,a2
    802033e0:	00c7c703          	lbu	a4,12(a5)
    802033e4:	fe442783          	lw	a5,-28(s0)
    802033e8:	97b6                	add	a5,a5,a3
    802033ea:	00e78623          	sb	a4,12(a5)
    802033ee:	fe442783          	lw	a5,-28(s0)
    802033f2:	2785                	addiw	a5,a5,1
    802033f4:	fef42223          	sw	a5,-28(s0)
    802033f8:	0000c617          	auipc	a2,0xc
    802033fc:	2d060613          	addi	a2,a2,720 # 8020f6c8 <procs>
    80203400:	fe442683          	lw	a3,-28(s0)
    80203404:	fec42703          	lw	a4,-20(s0)
    80203408:	87ba                	mv	a5,a4
    8020340a:	0786                	slli	a5,a5,0x1
    8020340c:	97ba                	add	a5,a5,a4
    8020340e:	0792                	slli	a5,a5,0x4
    80203410:	97b2                	add	a5,a5,a2
    80203412:	97b6                	add	a5,a5,a3
    80203414:	00c7c783          	lbu	a5,12(a5)
    80203418:	cb81                	beqz	a5,80203428 <proc_list+0x148>
    8020341a:	fe442783          	lw	a5,-28(s0)
    8020341e:	0007871b          	sext.w	a4,a5
    80203422:	47b9                	li	a5,14
    80203424:	f8e7d5e3          	bge	a5,a4,802033ae <proc_list+0xce>
    80203428:	fe842703          	lw	a4,-24(s0)
    8020342c:	87ba                	mv	a5,a4
    8020342e:	078e                	slli	a5,a5,0x3
    80203430:	8f99                	sub	a5,a5,a4
    80203432:	078a                	slli	a5,a5,0x2
    80203434:	873e                	mv	a4,a5
    80203436:	fd843783          	ld	a5,-40(s0)
    8020343a:	973e                	add	a4,a4,a5
    8020343c:	fe442783          	lw	a5,-28(s0)
    80203440:	97ba                	add	a5,a5,a4
    80203442:	00078623          	sb	zero,12(a5)
    80203446:	fe842783          	lw	a5,-24(s0)
    8020344a:	2785                	addiw	a5,a5,1
    8020344c:	fef42423          	sw	a5,-24(s0)
    80203450:	a011                	j	80203454 <proc_list+0x174>
    80203452:	0001                	nop
    80203454:	fec42783          	lw	a5,-20(s0)
    80203458:	2785                	addiw	a5,a5,1
    8020345a:	fef42623          	sw	a5,-20(s0)
    8020345e:	fec42783          	lw	a5,-20(s0)
    80203462:	0007871b          	sext.w	a4,a5
    80203466:	47bd                	li	a5,15
    80203468:	00e7cb63          	blt	a5,a4,8020347e <proc_list+0x19e>
    8020346c:	fe842783          	lw	a5,-24(s0)
    80203470:	873e                	mv	a4,a5
    80203472:	fd442783          	lw	a5,-44(s0)
    80203476:	2701                	sext.w	a4,a4
    80203478:	2781                	sext.w	a5,a5
    8020347a:	e8f741e3          	blt	a4,a5,802032fc <proc_list+0x1c>
    8020347e:	fe842783          	lw	a5,-24(s0)
    80203482:	853e                	mv	a0,a5
    80203484:	70a2                	ld	ra,40(sp)
    80203486:	7402                	ld	s0,32(sp)
    80203488:	6145                	addi	sp,sp,48
    8020348a:	8082                	ret

000000008020348c <proc_mark_zombie>:
    8020348c:	1101                	addi	sp,sp,-32
    8020348e:	ec06                	sd	ra,24(sp)
    80203490:	e822                	sd	s0,16(sp)
    80203492:	1000                	addi	s0,sp,32
    80203494:	87aa                	mv	a5,a0
    80203496:	fef42623          	sw	a5,-20(s0)
    8020349a:	fec42783          	lw	a5,-20(s0)
    8020349e:	458d                	li	a1,3
    802034a0:	853e                	mv	a0,a5
    802034a2:	cedff0ef          	jal	8020318e <proc_set_state>
    802034a6:	0001                	nop
    802034a8:	60e2                	ld	ra,24(sp)
    802034aa:	6442                	ld	s0,16(sp)
    802034ac:	6105                	addi	sp,sp,32
    802034ae:	8082                	ret

00000000802034b0 <spawn_trampoline>:
    802034b0:	1141                	addi	sp,sp,-16
    802034b2:	e406                	sd	ra,8(sp)
    802034b4:	e022                	sd	s0,0(sp)
    802034b6:	0800                	addi	s0,sp,16
    802034b8:	0000c797          	auipc	a5,0xc
    802034bc:	51078793          	addi	a5,a5,1296 # 8020f9c8 <spawn_entry>
    802034c0:	639c                	ld	a5,0(a5)
    802034c2:	c799                	beqz	a5,802034d0 <spawn_trampoline+0x20>
    802034c4:	0000c797          	auipc	a5,0xc
    802034c8:	50478793          	addi	a5,a5,1284 # 8020f9c8 <spawn_entry>
    802034cc:	639c                	ld	a5,0(a5)
    802034ce:	9782                	jalr	a5
    802034d0:	0000c797          	auipc	a5,0xc
    802034d4:	50078793          	addi	a5,a5,1280 # 8020f9d0 <spawn_pid>
    802034d8:	439c                	lw	a5,0(a5)
    802034da:	853e                	mv	a0,a5
    802034dc:	fb1ff0ef          	jal	8020348c <proc_mark_zombie>
    802034e0:	10500073          	wfi
    802034e4:	bff5                	j	802034e0 <spawn_trampoline+0x30>

00000000802034e6 <proc_spawn>:
    802034e6:	7179                	addi	sp,sp,-48
    802034e8:	f406                	sd	ra,40(sp)
    802034ea:	f022                	sd	s0,32(sp)
    802034ec:	1800                	addi	s0,sp,48
    802034ee:	fca43c23          	sd	a0,-40(s0)
    802034f2:	fcb43823          	sd	a1,-48(s0)
    802034f6:	4581                	li	a1,0
    802034f8:	fd843503          	ld	a0,-40(s0)
    802034fc:	a03ff0ef          	jal	80202efe <proc_alloc>
    80203500:	87aa                	mv	a5,a0
    80203502:	fef42623          	sw	a5,-20(s0)
    80203506:	fec42783          	lw	a5,-20(s0)
    8020350a:	2781                	sext.w	a5,a5
    8020350c:	0007d463          	bgez	a5,80203514 <proc_spawn+0x2e>
    80203510:	57fd                	li	a5,-1
    80203512:	a0b9                	j	80203560 <proc_spawn+0x7a>
    80203514:	0000c797          	auipc	a5,0xc
    80203518:	4bc78793          	addi	a5,a5,1212 # 8020f9d0 <spawn_pid>
    8020351c:	fec42703          	lw	a4,-20(s0)
    80203520:	c398                	sw	a4,0(a5)
    80203522:	0000c797          	auipc	a5,0xc
    80203526:	4a678793          	addi	a5,a5,1190 # 8020f9c8 <spawn_entry>
    8020352a:	fd043703          	ld	a4,-48(s0)
    8020352e:	e398                	sd	a4,0(a5)
    80203530:	00000517          	auipc	a0,0x0
    80203534:	f8050513          	addi	a0,a0,-128 # 802034b0 <spawn_trampoline>
    80203538:	591000ef          	jal	802042c8 <task_create>
    8020353c:	87aa                	mv	a5,a0
    8020353e:	cb89                	beqz	a5,80203550 <proc_spawn+0x6a>
    80203540:	fec42783          	lw	a5,-20(s0)
    80203544:	4581                	li	a1,0
    80203546:	853e                	mv	a0,a5
    80203548:	c47ff0ef          	jal	8020318e <proc_set_state>
    8020354c:	57fd                	li	a5,-1
    8020354e:	a809                	j	80203560 <proc_spawn+0x7a>
    80203550:	fec42783          	lw	a5,-20(s0)
    80203554:	4585                	li	a1,1
    80203556:	853e                	mv	a0,a5
    80203558:	c37ff0ef          	jal	8020318e <proc_set_state>
    8020355c:	fec42783          	lw	a5,-20(s0)
    80203560:	853e                	mv	a0,a5
    80203562:	70a2                	ld	ra,40(sp)
    80203564:	7402                	ld	s0,32(sp)
    80203566:	6145                	addi	sp,sp,48
    80203568:	8082                	ret

000000008020356a <proc_run_binary>:
    8020356a:	7139                	addi	sp,sp,-64
    8020356c:	fc06                	sd	ra,56(sp)
    8020356e:	f822                	sd	s0,48(sp)
    80203570:	0080                	addi	s0,sp,64
    80203572:	fca43c23          	sd	a0,-40(s0)
    80203576:	fcb43823          	sd	a1,-48(s0)
    8020357a:	fcc43423          	sd	a2,-56(s0)
    8020357e:	4581                	li	a1,0
    80203580:	fd843503          	ld	a0,-40(s0)
    80203584:	97bff0ef          	jal	80202efe <proc_alloc>
    80203588:	87aa                	mv	a5,a0
    8020358a:	fef42623          	sw	a5,-20(s0)
    8020358e:	fec42783          	lw	a5,-20(s0)
    80203592:	2781                	sext.w	a5,a5
    80203594:	0207cd63          	bltz	a5,802035ce <proc_run_binary+0x64>
    80203598:	0000c797          	auipc	a5,0xc
    8020359c:	43878793          	addi	a5,a5,1080 # 8020f9d0 <spawn_pid>
    802035a0:	fec42703          	lw	a4,-20(s0)
    802035a4:	c398                	sw	a4,0(a5)
    802035a6:	fd043703          	ld	a4,-48(s0)
    802035aa:	0000c797          	auipc	a5,0xc
    802035ae:	41e78793          	addi	a5,a5,1054 # 8020f9c8 <spawn_entry>
    802035b2:	e398                	sd	a4,0(a5)
    802035b4:	00000517          	auipc	a0,0x0
    802035b8:	efc50513          	addi	a0,a0,-260 # 802034b0 <spawn_trampoline>
    802035bc:	50d000ef          	jal	802042c8 <task_create>
    802035c0:	fec42783          	lw	a5,-20(s0)
    802035c4:	4589                	li	a1,2
    802035c6:	853e                	mv	a0,a5
    802035c8:	bc7ff0ef          	jal	8020318e <proc_set_state>
    802035cc:	a011                	j	802035d0 <proc_run_binary+0x66>
    802035ce:	0001                	nop
    802035d0:	70e2                	ld	ra,56(sp)
    802035d2:	7442                	ld	s0,48(sp)
    802035d4:	6121                	addi	sp,sp,64
    802035d6:	8082                	ret

00000000802035d8 <proc_spawn_worker_demo>:
    802035d8:	1141                	addi	sp,sp,-16
    802035da:	e406                	sd	ra,8(sp)
    802035dc:	e022                	sd	s0,0(sp)
    802035de:	0800                	addi	s0,sp,16
    802035e0:	00000597          	auipc	a1,0x0
    802035e4:	01e58593          	addi	a1,a1,30 # 802035fe <worker_demo>
    802035e8:	00005517          	auipc	a0,0x5
    802035ec:	de050513          	addi	a0,a0,-544 # 802083c8 <user_code_end+0x9f8>
    802035f0:	ef7ff0ef          	jal	802034e6 <proc_spawn>
    802035f4:	0001                	nop
    802035f6:	60a2                	ld	ra,8(sp)
    802035f8:	6402                	ld	s0,0(sp)
    802035fa:	0141                	addi	sp,sp,16
    802035fc:	8082                	ret

00000000802035fe <worker_demo>:
    802035fe:	1101                	addi	sp,sp,-32
    80203600:	ec06                	sd	ra,24(sp)
    80203602:	e822                	sd	s0,16(sp)
    80203604:	1000                	addi	s0,sp,32
    80203606:	fe042623          	sw	zero,-20(s0)
    8020360a:	a81d                	j	80203640 <worker_demo+0x42>
    8020360c:	0000c797          	auipc	a5,0xc
    80203610:	3c478793          	addi	a5,a5,964 # 8020f9d0 <spawn_pid>
    80203614:	439c                	lw	a5,0(a5)
    80203616:	fec42703          	lw	a4,-20(s0)
    8020361a:	2705                	addiw	a4,a4,1
    8020361c:	2701                	sext.w	a4,a4
    8020361e:	863a                	mv	a2,a4
    80203620:	85be                	mv	a1,a5
    80203622:	00005517          	auipc	a0,0x5
    80203626:	dae50513          	addi	a0,a0,-594 # 802083d0 <user_code_end+0xa00>
    8020362a:	a8dfd0ef          	jal	802010b6 <printf>
    8020362e:	7d000513          	li	a0,2000
    80203632:	583000ef          	jal	802043b4 <task_delay>
    80203636:	fec42783          	lw	a5,-20(s0)
    8020363a:	2785                	addiw	a5,a5,1
    8020363c:	fef42623          	sw	a5,-20(s0)
    80203640:	fec42783          	lw	a5,-20(s0)
    80203644:	0007871b          	sext.w	a4,a5
    80203648:	4789                	li	a5,2
    8020364a:	fce7d1e3          	bge	a5,a4,8020360c <worker_demo+0xe>
    8020364e:	0000c797          	auipc	a5,0xc
    80203652:	38278793          	addi	a5,a5,898 # 8020f9d0 <spawn_pid>
    80203656:	439c                	lw	a5,0(a5)
    80203658:	85be                	mv	a1,a5
    8020365a:	00005517          	auipc	a0,0x5
    8020365e:	d9650513          	addi	a0,a0,-618 # 802083f0 <user_code_end+0xa20>
    80203662:	a55fd0ef          	jal	802010b6 <printf>
    80203666:	0001                	nop
    80203668:	60e2                	ld	ra,24(sp)
    8020366a:	6442                	ld	s0,16(sp)
    8020366c:	6105                	addi	sp,sp,32
    8020366e:	8082                	ret

0000000080203670 <pid_to_slot>:
    80203670:	1101                	addi	sp,sp,-32
    80203672:	ec06                	sd	ra,24(sp)
    80203674:	e822                	sd	s0,16(sp)
    80203676:	1000                	addi	s0,sp,32
    80203678:	87aa                	mv	a5,a0
    8020367a:	fef42623          	sw	a5,-20(s0)
    8020367e:	fec42783          	lw	a5,-20(s0)
    80203682:	853e                	mv	a0,a5
    80203684:	b87ff0ef          	jal	8020320a <proc_slot_by_pid>
    80203688:	87aa                	mv	a5,a0
    8020368a:	853e                	mv	a0,a5
    8020368c:	60e2                	ld	ra,24(sp)
    8020368e:	6442                	ld	s0,16(sp)
    80203690:	6105                	addi	sp,sp,32
    80203692:	8082                	ret

0000000080203694 <proc_user_trap_frame>:
    80203694:	1141                	addi	sp,sp,-16
    80203696:	e406                	sd	ra,8(sp)
    80203698:	e022                	sd	s0,0(sp)
    8020369a:	0800                	addi	s0,sp,16
    8020369c:	0000c797          	auipc	a5,0xc
    802036a0:	a0478793          	addi	a5,a5,-1532 # 8020f0a0 <user_trap_save_cxt>
    802036a4:	639c                	ld	a5,0(a5)
    802036a6:	853e                	mv	a0,a5
    802036a8:	60a2                	ld	ra,8(sp)
    802036aa:	6402                	ld	s0,0(sp)
    802036ac:	0141                	addi	sp,sp,16
    802036ae:	8082                	ret

00000000802036b0 <proc_current_pid>:
    802036b0:	1141                	addi	sp,sp,-16
    802036b2:	e406                	sd	ra,8(sp)
    802036b4:	e022                	sd	s0,0(sp)
    802036b6:	0800                	addi	s0,sp,16
    802036b8:	0000c797          	auipc	a5,0xc
    802036bc:	95078793          	addi	a5,a5,-1712 # 8020f008 <current_pid>
    802036c0:	439c                	lw	a5,0(a5)
    802036c2:	853e                	mv	a0,a5
    802036c4:	60a2                	ld	ra,8(sp)
    802036c6:	6402                	ld	s0,0(sp)
    802036c8:	0141                	addi	sp,sp,16
    802036ca:	8082                	ret

00000000802036cc <proc_set_current_pid>:
    802036cc:	1101                	addi	sp,sp,-32
    802036ce:	ec06                	sd	ra,24(sp)
    802036d0:	e822                	sd	s0,16(sp)
    802036d2:	1000                	addi	s0,sp,32
    802036d4:	87aa                	mv	a5,a0
    802036d6:	fef42623          	sw	a5,-20(s0)
    802036da:	0000c797          	auipc	a5,0xc
    802036de:	92e78793          	addi	a5,a5,-1746 # 8020f008 <current_pid>
    802036e2:	fec42703          	lw	a4,-20(s0)
    802036e6:	c398                	sw	a4,0(a5)
    802036e8:	0001                	nop
    802036ea:	60e2                	ld	ra,24(sp)
    802036ec:	6442                	ld	s0,16(sp)
    802036ee:	6105                	addi	sp,sp,32
    802036f0:	8082                	ret

00000000802036f2 <proc_user_init>:
    802036f2:	1101                	addi	sp,sp,-32
    802036f4:	ec06                	sd	ra,24(sp)
    802036f6:	e822                	sd	s0,16(sp)
    802036f8:	1000                	addi	s0,sp,32
    802036fa:	fe042623          	sw	zero,-20(s0)
    802036fe:	a005                	j	8020371e <proc_user_init+0x2c>
    80203700:	00011717          	auipc	a4,0x11
    80203704:	3d870713          	addi	a4,a4,984 # 80214ad8 <exit_status>
    80203708:	fec42783          	lw	a5,-20(s0)
    8020370c:	078a                	slli	a5,a5,0x2
    8020370e:	97ba                	add	a5,a5,a4
    80203710:	0007a023          	sw	zero,0(a5)
    80203714:	fec42783          	lw	a5,-20(s0)
    80203718:	2785                	addiw	a5,a5,1
    8020371a:	fef42623          	sw	a5,-20(s0)
    8020371e:	fec42783          	lw	a5,-20(s0)
    80203722:	0007871b          	sext.w	a4,a5
    80203726:	47bd                	li	a5,15
    80203728:	fce7dce3          	bge	a5,a4,80203700 <proc_user_init+0xe>
    8020372c:	0000c797          	auipc	a5,0xc
    80203730:	8d878793          	addi	a5,a5,-1832 # 8020f004 <fork_child_pending>
    80203734:	577d                	li	a4,-1
    80203736:	c398                	sw	a4,0(a5)
    80203738:	0000c797          	auipc	a5,0xc
    8020373c:	97078793          	addi	a5,a5,-1680 # 8020f0a8 <proc_user_exit_pending>
    80203740:	0007a023          	sw	zero,0(a5)
    80203744:	0000c797          	auipc	a5,0xc
    80203748:	95c78793          	addi	a5,a5,-1700 # 8020f0a0 <user_trap_save_cxt>
    8020374c:	0007b023          	sd	zero,0(a5)
    80203750:	0000c797          	auipc	a5,0xc
    80203754:	8b878793          	addi	a5,a5,-1864 # 8020f008 <current_pid>
    80203758:	4705                	li	a4,1
    8020375a:	c398                	sw	a4,0(a5)
    8020375c:	4505                	li	a0,1
    8020375e:	aadff0ef          	jal	8020320a <proc_slot_by_pid>
    80203762:	87aa                	mv	a5,a0
    80203764:	0007d963          	bgez	a5,80203776 <proc_user_init+0x84>
    80203768:	4581                	li	a1,0
    8020376a:	00005517          	auipc	a0,0x5
    8020376e:	c9e50513          	addi	a0,a0,-866 # 80208408 <user_code_end+0xa38>
    80203772:	f8cff0ef          	jal	80202efe <proc_alloc>
    80203776:	0001                	nop
    80203778:	60e2                	ld	ra,24(sp)
    8020377a:	6442                	ld	s0,16(sp)
    8020377c:	6105                	addi	sp,sp,32
    8020377e:	8082                	ret

0000000080203780 <uctx_for_pid>:
    80203780:	7179                	addi	sp,sp,-48
    80203782:	f406                	sd	ra,40(sp)
    80203784:	f022                	sd	s0,32(sp)
    80203786:	1800                	addi	s0,sp,48
    80203788:	87aa                	mv	a5,a0
    8020378a:	fcf42e23          	sw	a5,-36(s0)
    8020378e:	fdc42783          	lw	a5,-36(s0)
    80203792:	853e                	mv	a0,a5
    80203794:	eddff0ef          	jal	80203670 <pid_to_slot>
    80203798:	87aa                	mv	a5,a0
    8020379a:	fef42623          	sw	a5,-20(s0)
    8020379e:	fec42783          	lw	a5,-20(s0)
    802037a2:	2781                	sext.w	a5,a5
    802037a4:	0007d463          	bgez	a5,802037ac <uctx_for_pid+0x2c>
    802037a8:	4781                	li	a5,0
    802037aa:	a811                	j	802037be <uctx_for_pid+0x3e>
    802037ac:	fec42783          	lw	a5,-20(s0)
    802037b0:	00879713          	slli	a4,a5,0x8
    802037b4:	00010797          	auipc	a5,0x10
    802037b8:	32478793          	addi	a5,a5,804 # 80213ad8 <uctx_table>
    802037bc:	97ba                	add	a5,a5,a4
    802037be:	853e                	mv	a0,a5
    802037c0:	70a2                	ld	ra,40(sp)
    802037c2:	7402                	ld	s0,32(sp)
    802037c4:	6145                	addi	sp,sp,48
    802037c6:	8082                	ret

00000000802037c8 <uctx_clear>:
    802037c8:	7179                	addi	sp,sp,-48
    802037ca:	f406                	sd	ra,40(sp)
    802037cc:	f022                	sd	s0,32(sp)
    802037ce:	1800                	addi	s0,sp,48
    802037d0:	fca43c23          	sd	a0,-40(s0)
    802037d4:	fe042623          	sw	zero,-20(s0)
    802037d8:	a831                	j	802037f4 <uctx_clear+0x2c>
    802037da:	fec42783          	lw	a5,-20(s0)
    802037de:	078e                	slli	a5,a5,0x3
    802037e0:	fd843703          	ld	a4,-40(s0)
    802037e4:	97ba                	add	a5,a5,a4
    802037e6:	0007b023          	sd	zero,0(a5)
    802037ea:	fec42783          	lw	a5,-20(s0)
    802037ee:	2785                	addiw	a5,a5,1
    802037f0:	fef42623          	sw	a5,-20(s0)
    802037f4:	fec42783          	lw	a5,-20(s0)
    802037f8:	0007871b          	sext.w	a4,a5
    802037fc:	47fd                	li	a5,31
    802037fe:	fce7dee3          	bge	a5,a4,802037da <uctx_clear+0x12>
    80203802:	0001                	nop
    80203804:	0001                	nop
    80203806:	70a2                	ld	ra,40(sp)
    80203808:	7402                	ld	s0,32(sp)
    8020380a:	6145                	addi	sp,sp,48
    8020380c:	8082                	ret

000000008020380e <uctx_copy>:
    8020380e:	7179                	addi	sp,sp,-48
    80203810:	f406                	sd	ra,40(sp)
    80203812:	f022                	sd	s0,32(sp)
    80203814:	1800                	addi	s0,sp,48
    80203816:	fca43c23          	sd	a0,-40(s0)
    8020381a:	fcb43823          	sd	a1,-48(s0)
    8020381e:	02000793          	li	a5,32
    80203822:	fef42423          	sw	a5,-24(s0)
    80203826:	fe042623          	sw	zero,-20(s0)
    8020382a:	a025                	j	80203852 <uctx_copy+0x44>
    8020382c:	fec42783          	lw	a5,-20(s0)
    80203830:	078e                	slli	a5,a5,0x3
    80203832:	fd043703          	ld	a4,-48(s0)
    80203836:	973e                	add	a4,a4,a5
    80203838:	fec42783          	lw	a5,-20(s0)
    8020383c:	078e                	slli	a5,a5,0x3
    8020383e:	fd843683          	ld	a3,-40(s0)
    80203842:	97b6                	add	a5,a5,a3
    80203844:	6318                	ld	a4,0(a4)
    80203846:	e398                	sd	a4,0(a5)
    80203848:	fec42783          	lw	a5,-20(s0)
    8020384c:	2785                	addiw	a5,a5,1
    8020384e:	fef42623          	sw	a5,-20(s0)
    80203852:	fec42783          	lw	a5,-20(s0)
    80203856:	873e                	mv	a4,a5
    80203858:	fe842783          	lw	a5,-24(s0)
    8020385c:	2701                	sext.w	a4,a4
    8020385e:	2781                	sext.w	a5,a5
    80203860:	fcf746e3          	blt	a4,a5,8020382c <uctx_copy+0x1e>
    80203864:	0001                	nop
    80203866:	0001                	nop
    80203868:	70a2                	ld	ra,40(sp)
    8020386a:	7402                	ld	s0,32(sp)
    8020386c:	6145                	addi	sp,sp,48
    8020386e:	8082                	ret

0000000080203870 <user_mem_copy>:
    80203870:	7179                	addi	sp,sp,-48
    80203872:	f406                	sd	ra,40(sp)
    80203874:	f022                	sd	s0,32(sp)
    80203876:	1800                	addi	s0,sp,48
    80203878:	87aa                	mv	a5,a0
    8020387a:	872e                	mv	a4,a1
    8020387c:	fcf42e23          	sw	a5,-36(s0)
    80203880:	87ba                	mv	a5,a4
    80203882:	fcf42c23          	sw	a5,-40(s0)
    80203886:	010077b7          	lui	a5,0x1007
    8020388a:	079e                	slli	a5,a5,0x7
    8020388c:	fef43423          	sd	a5,-24(s0)
    80203890:	010077b7          	lui	a5,0x1007
    80203894:	079e                	slli	a5,a5,0x7
    80203896:	fef43023          	sd	a5,-32(s0)
    8020389a:	0001                	nop
    8020389c:	70a2                	ld	ra,40(sp)
    8020389e:	7402                	ld	s0,32(sp)
    802038a0:	6145                	addi	sp,sp,48
    802038a2:	8082                	ret

00000000802038a4 <proc_load_elf>:
    802038a4:	7175                	addi	sp,sp,-144
    802038a6:	e506                	sd	ra,136(sp)
    802038a8:	e122                	sd	s0,128(sp)
    802038aa:	0900                	addi	s0,sp,144
    802038ac:	87aa                	mv	a5,a0
    802038ae:	f6b43823          	sd	a1,-144(s0)
    802038b2:	f6f42e23          	sw	a5,-132(s0)
    802038b6:	6611                	lui	a2,0x4
    802038b8:	0000c597          	auipc	a1,0xc
    802038bc:	22058593          	addi	a1,a1,544 # 8020fad8 <file_buf>
    802038c0:	f7043503          	ld	a0,-144(s0)
    802038c4:	44c020ef          	jal	80205d10 <fs_read_file>
    802038c8:	87aa                	mv	a5,a0
    802038ca:	fcf42823          	sw	a5,-48(s0)
    802038ce:	fd042783          	lw	a5,-48(s0)
    802038d2:	0007871b          	sext.w	a4,a5
    802038d6:	03f00793          	li	a5,63
    802038da:	00e7c463          	blt	a5,a4,802038e2 <proc_load_elf+0x3e>
    802038de:	57fd                	li	a5,-1
    802038e0:	a695                	j	80203c44 <proc_load_elf+0x3a0>
    802038e2:	0000c797          	auipc	a5,0xc
    802038e6:	1f678793          	addi	a5,a5,502 # 8020fad8 <file_buf>
    802038ea:	fcf43423          	sd	a5,-56(s0)
    802038ee:	fc843783          	ld	a5,-56(s0)
    802038f2:	4398                	lw	a4,0(a5)
    802038f4:	464c47b7          	lui	a5,0x464c4
    802038f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_heap_size+0x3e5ddfb7>
    802038fc:	00f70463          	beq	a4,a5,80203904 <proc_load_elf+0x60>
    80203900:	57fd                	li	a5,-1
    80203902:	a689                	j	80203c44 <proc_load_elf+0x3a0>
    80203904:	fc843783          	ld	a5,-56(s0)
    80203908:	0047c783          	lbu	a5,4(a5)
    8020390c:	873e                	mv	a4,a5
    8020390e:	4789                	li	a5,2
    80203910:	00f71c63          	bne	a4,a5,80203928 <proc_load_elf+0x84>
    80203914:	fc843783          	ld	a5,-56(s0)
    80203918:	0127d783          	lhu	a5,18(a5)
    8020391c:	0007871b          	sext.w	a4,a5
    80203920:	0f300793          	li	a5,243
    80203924:	00f70463          	beq	a4,a5,8020392c <proc_load_elf+0x88>
    80203928:	57fd                	li	a5,-1
    8020392a:	ae29                	j	80203c44 <proc_load_elf+0x3a0>
    8020392c:	fc843783          	ld	a5,-56(s0)
    80203930:	7398                	ld	a4,32(a5)
    80203932:	0000c797          	auipc	a5,0xc
    80203936:	1a678793          	addi	a5,a5,422 # 8020fad8 <file_buf>
    8020393a:	97ba                	add	a5,a5,a4
    8020393c:	fcf43023          	sd	a5,-64(s0)
    80203940:	fe042623          	sw	zero,-20(s0)
    80203944:	a28d                	j	80203aa6 <proc_load_elf+0x202>
    80203946:	fec42703          	lw	a4,-20(s0)
    8020394a:	87ba                	mv	a5,a4
    8020394c:	078e                	slli	a5,a5,0x3
    8020394e:	8f99                	sub	a5,a5,a4
    80203950:	078e                	slli	a5,a5,0x3
    80203952:	873e                	mv	a4,a5
    80203954:	fc043783          	ld	a5,-64(s0)
    80203958:	97ba                	add	a5,a5,a4
    8020395a:	4398                	lw	a4,0(a5)
    8020395c:	4785                	li	a5,1
    8020395e:	12f71e63          	bne	a4,a5,80203a9a <proc_load_elf+0x1f6>
    80203962:	fec42703          	lw	a4,-20(s0)
    80203966:	87ba                	mv	a5,a4
    80203968:	078e                	slli	a5,a5,0x3
    8020396a:	8f99                	sub	a5,a5,a4
    8020396c:	078e                	slli	a5,a5,0x3
    8020396e:	873e                	mv	a4,a5
    80203970:	fc043783          	ld	a5,-64(s0)
    80203974:	97ba                	add	a5,a5,a4
    80203976:	7394                	ld	a3,32(a5)
    80203978:	fec42703          	lw	a4,-20(s0)
    8020397c:	87ba                	mv	a5,a4
    8020397e:	078e                	slli	a5,a5,0x3
    80203980:	8f99                	sub	a5,a5,a4
    80203982:	078e                	slli	a5,a5,0x3
    80203984:	873e                	mv	a4,a5
    80203986:	fc043783          	ld	a5,-64(s0)
    8020398a:	97ba                	add	a5,a5,a4
    8020398c:	779c                	ld	a5,40(a5)
    8020398e:	00d7f463          	bgeu	a5,a3,80203996 <proc_load_elf+0xf2>
    80203992:	57fd                	li	a5,-1
    80203994:	ac45                	j	80203c44 <proc_load_elf+0x3a0>
    80203996:	fec42703          	lw	a4,-20(s0)
    8020399a:	87ba                	mv	a5,a4
    8020399c:	078e                	slli	a5,a5,0x3
    8020399e:	8f99                	sub	a5,a5,a4
    802039a0:	078e                	slli	a5,a5,0x3
    802039a2:	873e                	mv	a4,a5
    802039a4:	fc043783          	ld	a5,-64(s0)
    802039a8:	97ba                	add	a5,a5,a4
    802039aa:	6b9c                	ld	a5,16(a5)
    802039ac:	f8f43c23          	sd	a5,-104(s0)
    802039b0:	fec42703          	lw	a4,-20(s0)
    802039b4:	87ba                	mv	a5,a4
    802039b6:	078e                	slli	a5,a5,0x3
    802039b8:	8f99                	sub	a5,a5,a4
    802039ba:	078e                	slli	a5,a5,0x3
    802039bc:	873e                	mv	a4,a5
    802039be:	fc043783          	ld	a5,-64(s0)
    802039c2:	97ba                	add	a5,a5,a4
    802039c4:	679c                	ld	a5,8(a5)
    802039c6:	f8f43823          	sd	a5,-112(s0)
    802039ca:	fec42703          	lw	a4,-20(s0)
    802039ce:	87ba                	mv	a5,a4
    802039d0:	078e                	slli	a5,a5,0x3
    802039d2:	8f99                	sub	a5,a5,a4
    802039d4:	078e                	slli	a5,a5,0x3
    802039d6:	873e                	mv	a4,a5
    802039d8:	fc043783          	ld	a5,-64(s0)
    802039dc:	97ba                	add	a5,a5,a4
    802039de:	7398                	ld	a4,32(a5)
    802039e0:	f9043783          	ld	a5,-112(s0)
    802039e4:	973e                	add	a4,a4,a5
    802039e6:	fd042783          	lw	a5,-48(s0)
    802039ea:	00e7f463          	bgeu	a5,a4,802039f2 <proc_load_elf+0x14e>
    802039ee:	57fd                	li	a5,-1
    802039f0:	ac91                	j	80203c44 <proc_load_elf+0x3a0>
    802039f2:	fe043023          	sd	zero,-32(s0)
    802039f6:	a80d                	j	80203a28 <proc_load_elf+0x184>
    802039f8:	f9043703          	ld	a4,-112(s0)
    802039fc:	fe043783          	ld	a5,-32(s0)
    80203a00:	973e                	add	a4,a4,a5
    80203a02:	f9843683          	ld	a3,-104(s0)
    80203a06:	fe043783          	ld	a5,-32(s0)
    80203a0a:	97b6                	add	a5,a5,a3
    80203a0c:	0000c697          	auipc	a3,0xc
    80203a10:	0cc68693          	addi	a3,a3,204 # 8020fad8 <file_buf>
    80203a14:	9736                	add	a4,a4,a3
    80203a16:	00074703          	lbu	a4,0(a4)
    80203a1a:	00e78023          	sb	a4,0(a5)
    80203a1e:	fe043783          	ld	a5,-32(s0)
    80203a22:	0785                	addi	a5,a5,1
    80203a24:	fef43023          	sd	a5,-32(s0)
    80203a28:	fec42703          	lw	a4,-20(s0)
    80203a2c:	87ba                	mv	a5,a4
    80203a2e:	078e                	slli	a5,a5,0x3
    80203a30:	8f99                	sub	a5,a5,a4
    80203a32:	078e                	slli	a5,a5,0x3
    80203a34:	873e                	mv	a4,a5
    80203a36:	fc043783          	ld	a5,-64(s0)
    80203a3a:	97ba                	add	a5,a5,a4
    80203a3c:	739c                	ld	a5,32(a5)
    80203a3e:	fe043703          	ld	a4,-32(s0)
    80203a42:	faf76be3          	bltu	a4,a5,802039f8 <proc_load_elf+0x154>
    80203a46:	fec42703          	lw	a4,-20(s0)
    80203a4a:	87ba                	mv	a5,a4
    80203a4c:	078e                	slli	a5,a5,0x3
    80203a4e:	8f99                	sub	a5,a5,a4
    80203a50:	078e                	slli	a5,a5,0x3
    80203a52:	873e                	mv	a4,a5
    80203a54:	fc043783          	ld	a5,-64(s0)
    80203a58:	97ba                	add	a5,a5,a4
    80203a5a:	739c                	ld	a5,32(a5)
    80203a5c:	fef43023          	sd	a5,-32(s0)
    80203a60:	a829                	j	80203a7a <proc_load_elf+0x1d6>
    80203a62:	f9843703          	ld	a4,-104(s0)
    80203a66:	fe043783          	ld	a5,-32(s0)
    80203a6a:	97ba                	add	a5,a5,a4
    80203a6c:	00078023          	sb	zero,0(a5)
    80203a70:	fe043783          	ld	a5,-32(s0)
    80203a74:	0785                	addi	a5,a5,1
    80203a76:	fef43023          	sd	a5,-32(s0)
    80203a7a:	fec42703          	lw	a4,-20(s0)
    80203a7e:	87ba                	mv	a5,a4
    80203a80:	078e                	slli	a5,a5,0x3
    80203a82:	8f99                	sub	a5,a5,a4
    80203a84:	078e                	slli	a5,a5,0x3
    80203a86:	873e                	mv	a4,a5
    80203a88:	fc043783          	ld	a5,-64(s0)
    80203a8c:	97ba                	add	a5,a5,a4
    80203a8e:	779c                	ld	a5,40(a5)
    80203a90:	fe043703          	ld	a4,-32(s0)
    80203a94:	fcf767e3          	bltu	a4,a5,80203a62 <proc_load_elf+0x1be>
    80203a98:	a011                	j	80203a9c <proc_load_elf+0x1f8>
    80203a9a:	0001                	nop
    80203a9c:	fec42783          	lw	a5,-20(s0)
    80203aa0:	2785                	addiw	a5,a5,1
    80203aa2:	fef42623          	sw	a5,-20(s0)
    80203aa6:	fc843783          	ld	a5,-56(s0)
    80203aaa:	0387d783          	lhu	a5,56(a5)
    80203aae:	2781                	sext.w	a5,a5
    80203ab0:	fec42703          	lw	a4,-20(s0)
    80203ab4:	2701                	sext.w	a4,a4
    80203ab6:	e8f748e3          	blt	a4,a5,80203946 <proc_load_elf+0xa2>
    80203aba:	0000100f          	fence.i
    80203abe:	fc843783          	ld	a5,-56(s0)
    80203ac2:	6f9c                	ld	a5,24(a5)
    80203ac4:	faf43c23          	sd	a5,-72(s0)
    80203ac8:	f7c42783          	lw	a5,-132(s0)
    80203acc:	853e                	mv	a0,a5
    80203ace:	cb3ff0ef          	jal	80203780 <uctx_for_pid>
    80203ad2:	faa43823          	sd	a0,-80(s0)
    80203ad6:	fb043783          	ld	a5,-80(s0)
    80203ada:	e399                	bnez	a5,80203ae0 <proc_load_elf+0x23c>
    80203adc:	57fd                	li	a5,-1
    80203ade:	a29d                	j	80203c44 <proc_load_elf+0x3a0>
    80203ae0:	fb043503          	ld	a0,-80(s0)
    80203ae4:	ce5ff0ef          	jal	802037c8 <uctx_clear>
    80203ae8:	fb043783          	ld	a5,-80(s0)
    80203aec:	fb843703          	ld	a4,-72(s0)
    80203af0:	fff8                	sd	a4,248(a5)
    80203af2:	fb043783          	ld	a5,-80(s0)
    80203af6:	08039737          	lui	a4,0x8039
    80203afa:	0712                	slli	a4,a4,0x4
    80203afc:	e798                	sd	a4,8(a5)
    80203afe:	f7043783          	ld	a5,-144(s0)
    80203b02:	faf43423          	sd	a5,-88(s0)
    80203b06:	fc042e23          	sw	zero,-36(s0)
    80203b0a:	a071                	j	80203b96 <proc_load_elf+0x2f2>
    80203b0c:	fdc42783          	lw	a5,-36(s0)
    80203b10:	fa843703          	ld	a4,-88(s0)
    80203b14:	97ba                	add	a5,a5,a4
    80203b16:	0007c783          	lbu	a5,0(a5)
    80203b1a:	873e                	mv	a4,a5
    80203b1c:	02f00793          	li	a5,47
    80203b20:	06f71663          	bne	a4,a5,80203b8c <proc_load_elf+0x2e8>
    80203b24:	fdc42783          	lw	a5,-36(s0)
    80203b28:	2785                	addiw	a5,a5,1
    80203b2a:	fcf42c23          	sw	a5,-40(s0)
    80203b2e:	fc042a23          	sw	zero,-44(s0)
    80203b32:	a03d                	j	80203b60 <proc_load_elf+0x2bc>
    80203b34:	fd842783          	lw	a5,-40(s0)
    80203b38:	0017871b          	addiw	a4,a5,1
    80203b3c:	fce42c23          	sw	a4,-40(s0)
    80203b40:	873e                	mv	a4,a5
    80203b42:	fa843783          	ld	a5,-88(s0)
    80203b46:	973e                	add	a4,a4,a5
    80203b48:	fd442783          	lw	a5,-44(s0)
    80203b4c:	0017869b          	addiw	a3,a5,1
    80203b50:	fcd42a23          	sw	a3,-44(s0)
    80203b54:	00074703          	lbu	a4,0(a4) # 8039000 <_heap_size+0x152a38>
    80203b58:	17c1                	addi	a5,a5,-16
    80203b5a:	97a2                	add	a5,a5,s0
    80203b5c:	f8e78823          	sb	a4,-112(a5)
    80203b60:	fd842783          	lw	a5,-40(s0)
    80203b64:	fa843703          	ld	a4,-88(s0)
    80203b68:	97ba                	add	a5,a5,a4
    80203b6a:	0007c783          	lbu	a5,0(a5)
    80203b6e:	cb81                	beqz	a5,80203b7e <proc_load_elf+0x2da>
    80203b70:	fd442783          	lw	a5,-44(s0)
    80203b74:	0007871b          	sext.w	a4,a5
    80203b78:	47b9                	li	a5,14
    80203b7a:	fae7dde3          	bge	a5,a4,80203b34 <proc_load_elf+0x290>
    80203b7e:	fd442783          	lw	a5,-44(s0)
    80203b82:	17c1                	addi	a5,a5,-16
    80203b84:	97a2                	add	a5,a5,s0
    80203b86:	f8078823          	sb	zero,-112(a5)
    80203b8a:	a02d                	j	80203bb4 <proc_load_elf+0x310>
    80203b8c:	fdc42783          	lw	a5,-36(s0)
    80203b90:	2785                	addiw	a5,a5,1
    80203b92:	fcf42e23          	sw	a5,-36(s0)
    80203b96:	fdc42783          	lw	a5,-36(s0)
    80203b9a:	fa843703          	ld	a4,-88(s0)
    80203b9e:	97ba                	add	a5,a5,a4
    80203ba0:	0007c783          	lbu	a5,0(a5)
    80203ba4:	cb81                	beqz	a5,80203bb4 <proc_load_elf+0x310>
    80203ba6:	fdc42783          	lw	a5,-36(s0)
    80203baa:	0007871b          	sext.w	a4,a5
    80203bae:	47b9                	li	a5,14
    80203bb0:	f4e7dee3          	bge	a5,a4,80203b0c <proc_load_elf+0x268>
    80203bb4:	f8044783          	lbu	a5,-128(s0)
    80203bb8:	ebb1                	bnez	a5,80203c0c <proc_load_elf+0x368>
    80203bba:	fc042e23          	sw	zero,-36(s0)
    80203bbe:	a015                	j	80203be2 <proc_load_elf+0x33e>
    80203bc0:	fdc42783          	lw	a5,-36(s0)
    80203bc4:	f7043703          	ld	a4,-144(s0)
    80203bc8:	973e                	add	a4,a4,a5
    80203bca:	fdc42783          	lw	a5,-36(s0)
    80203bce:	0017869b          	addiw	a3,a5,1
    80203bd2:	fcd42e23          	sw	a3,-36(s0)
    80203bd6:	00074703          	lbu	a4,0(a4)
    80203bda:	17c1                	addi	a5,a5,-16
    80203bdc:	97a2                	add	a5,a5,s0
    80203bde:	f8e78823          	sb	a4,-112(a5)
    80203be2:	fdc42783          	lw	a5,-36(s0)
    80203be6:	f7043703          	ld	a4,-144(s0)
    80203bea:	97ba                	add	a5,a5,a4
    80203bec:	0007c783          	lbu	a5,0(a5)
    80203bf0:	cb81                	beqz	a5,80203c00 <proc_load_elf+0x35c>
    80203bf2:	fdc42783          	lw	a5,-36(s0)
    80203bf6:	0007871b          	sext.w	a4,a5
    80203bfa:	47b9                	li	a5,14
    80203bfc:	fce7d2e3          	bge	a5,a4,80203bc0 <proc_load_elf+0x31c>
    80203c00:	fdc42783          	lw	a5,-36(s0)
    80203c04:	17c1                	addi	a5,a5,-16
    80203c06:	97a2                	add	a5,a5,s0
    80203c08:	f8078823          	sb	zero,-112(a5)
    80203c0c:	f8040713          	addi	a4,s0,-128
    80203c10:	f7c42783          	lw	a5,-132(s0)
    80203c14:	85ba                	mv	a1,a4
    80203c16:	853e                	mv	a0,a5
    80203c18:	c96ff0ef          	jal	802030ae <proc_set_name>
    80203c1c:	f7c42783          	lw	a5,-132(s0)
    80203c20:	853e                	mv	a0,a5
    80203c22:	a4fff0ef          	jal	80203670 <pid_to_slot>
    80203c26:	87aa                	mv	a5,a0
    80203c28:	faf42223          	sw	a5,-92(s0)
    80203c2c:	fa442783          	lw	a5,-92(s0)
    80203c30:	2781                	sext.w	a5,a5
    80203c32:	0007c863          	bltz	a5,80203c42 <proc_load_elf+0x39e>
    80203c36:	f7c42783          	lw	a5,-132(s0)
    80203c3a:	4585                	li	a1,1
    80203c3c:	853e                	mv	a0,a5
    80203c3e:	d50ff0ef          	jal	8020318e <proc_set_state>
    80203c42:	4781                	li	a5,0
    80203c44:	853e                	mv	a0,a5
    80203c46:	60aa                	ld	ra,136(sp)
    80203c48:	640a                	ld	s0,128(sp)
    80203c4a:	6149                	addi	sp,sp,144
    80203c4c:	8082                	ret

0000000080203c4e <user_exit_trampoline>:
    80203c4e:	0000b797          	auipc	a5,0xb
    80203c52:	43a78793          	addi	a5,a5,1082 # 8020f088 <kernel_gp_value>
    80203c56:	639c                	ld	a5,0(a5)
    80203c58:	00011717          	auipc	a4,0x11
    80203c5c:	ec870713          	addi	a4,a4,-312 # 80214b20 <user_kernel_sp>
    80203c60:	6318                	ld	a4,0(a4)
    80203c62:	00011697          	auipc	a3,0x11
    80203c66:	eb668693          	addi	a3,a3,-330 # 80214b18 <user_kernel_ra>
    80203c6a:	6294                	ld	a3,0(a3)
    80203c6c:	81be                	mv	gp,a5
    80203c6e:	813a                	mv	sp,a4
    80203c70:	8682                	jr	a3
    80203c72:	0001                	nop

0000000080203c74 <proc_user_prepare_kernel_return>:
    80203c74:	1141                	addi	sp,sp,-16
    80203c76:	e406                	sd	ra,8(sp)
    80203c78:	e022                	sd	s0,0(sp)
    80203c7a:	0800                	addi	s0,sp,16
    80203c7c:	00000717          	auipc	a4,0x0
    80203c80:	fd270713          	addi	a4,a4,-46 # 80203c4e <user_exit_trampoline>
    80203c84:	0000c797          	auipc	a5,0xc
    80203c88:	d5478793          	addi	a5,a5,-684 # 8020f9d8 <kernel_user_exit_cxt>
    80203c8c:	fff8                	sd	a4,248(a5)
    80203c8e:	00011797          	auipc	a5,0x11
    80203c92:	e9278793          	addi	a5,a5,-366 # 80214b20 <user_kernel_sp>
    80203c96:	6398                	ld	a4,0(a5)
    80203c98:	0000c797          	auipc	a5,0xc
    80203c9c:	d4078793          	addi	a5,a5,-704 # 8020f9d8 <kernel_user_exit_cxt>
    80203ca0:	e798                	sd	a4,8(a5)
    80203ca2:	00011797          	auipc	a5,0x11
    80203ca6:	e7678793          	addi	a5,a5,-394 # 80214b18 <user_kernel_ra>
    80203caa:	6398                	ld	a4,0(a5)
    80203cac:	0000c797          	auipc	a5,0xc
    80203cb0:	d2c78793          	addi	a5,a5,-724 # 8020f9d8 <kernel_user_exit_cxt>
    80203cb4:	e398                	sd	a4,0(a5)
    80203cb6:	0000b797          	auipc	a5,0xb
    80203cba:	3d278793          	addi	a5,a5,978 # 8020f088 <kernel_gp_value>
    80203cbe:	6398                	ld	a4,0(a5)
    80203cc0:	0000c797          	auipc	a5,0xc
    80203cc4:	d1878793          	addi	a5,a5,-744 # 8020f9d8 <kernel_user_exit_cxt>
    80203cc8:	eb98                	sd	a4,16(a5)
    80203cca:	0001                	nop
    80203ccc:	60a2                	ld	ra,8(sp)
    80203cce:	6402                	ld	s0,0(sp)
    80203cd0:	0141                	addi	sp,sp,16
    80203cd2:	8082                	ret

0000000080203cd4 <proc_user_run>:
    80203cd4:	7179                	addi	sp,sp,-48
    80203cd6:	f406                	sd	ra,40(sp)
    80203cd8:	f022                	sd	s0,32(sp)
    80203cda:	1800                	addi	s0,sp,48
    80203cdc:	87aa                	mv	a5,a0
    80203cde:	fcf42e23          	sw	a5,-36(s0)
    80203ce2:	fdc42783          	lw	a5,-36(s0)
    80203ce6:	853e                	mv	a0,a5
    80203ce8:	a99ff0ef          	jal	80203780 <uctx_for_pid>
    80203cec:	fea43423          	sd	a0,-24(s0)
    80203cf0:	fe843783          	ld	a5,-24(s0)
    80203cf4:	e399                	bnez	a5,80203cfa <proc_user_run+0x26>
    80203cf6:	57fd                	li	a5,-1
    80203cf8:	a895                	j	80203d6c <proc_user_run+0x98>
    80203cfa:	8706                	mv	a4,ra
    80203cfc:	00011797          	auipc	a5,0x11
    80203d00:	e1c78793          	addi	a5,a5,-484 # 80214b18 <user_kernel_ra>
    80203d04:	e398                	sd	a4,0(a5)
    80203d06:	870a                	mv	a4,sp
    80203d08:	00011797          	auipc	a5,0x11
    80203d0c:	e1878793          	addi	a5,a5,-488 # 80214b20 <user_kernel_sp>
    80203d10:	e398                	sd	a4,0(a5)
    80203d12:	0000b797          	auipc	a5,0xb
    80203d16:	2f678793          	addi	a5,a5,758 # 8020f008 <current_pid>
    80203d1a:	fdc42703          	lw	a4,-36(s0)
    80203d1e:	c398                	sw	a4,0(a5)
    80203d20:	0000b797          	auipc	a5,0xb
    80203d24:	38078793          	addi	a5,a5,896 # 8020f0a0 <user_trap_save_cxt>
    80203d28:	fe843703          	ld	a4,-24(s0)
    80203d2c:	e398                	sd	a4,0(a5)
    80203d2e:	fdc42783          	lw	a5,-36(s0)
    80203d32:	4589                	li	a1,2
    80203d34:	853e                	mv	a0,a5
    80203d36:	c58ff0ef          	jal	8020318e <proc_set_state>
    80203d3a:	0000b797          	auipc	a5,0xb
    80203d3e:	36e78793          	addi	a5,a5,878 # 8020f0a8 <proc_user_exit_pending>
    80203d42:	0007a023          	sw	zero,0(a5)
    80203d46:	c9cfe0ef          	jal	802021e2 <trap_use_kernel_cxt>
    80203d4a:	fe843503          	ld	a0,-24(s0)
    80203d4e:	ddefc0ef          	jal	8020032c <switch_to>
    80203d52:	0000b797          	auipc	a5,0xb
    80203d56:	34e78793          	addi	a5,a5,846 # 8020f0a0 <user_trap_save_cxt>
    80203d5a:	0007b023          	sd	zero,0(a5)
    80203d5e:	0000b797          	auipc	a5,0xb
    80203d62:	2aa78793          	addi	a5,a5,682 # 8020f008 <current_pid>
    80203d66:	4705                	li	a4,1
    80203d68:	c398                	sw	a4,0(a5)
    80203d6a:	4781                	li	a5,0
    80203d6c:	853e                	mv	a0,a5
    80203d6e:	70a2                	ld	ra,40(sp)
    80203d70:	7402                	ld	s0,32(sp)
    80203d72:	6145                	addi	sp,sp,48
    80203d74:	8082                	ret

0000000080203d76 <proc_user_exit>:
    80203d76:	7179                	addi	sp,sp,-48
    80203d78:	f406                	sd	ra,40(sp)
    80203d7a:	f022                	sd	s0,32(sp)
    80203d7c:	1800                	addi	s0,sp,48
    80203d7e:	87aa                	mv	a5,a0
    80203d80:	872e                	mv	a4,a1
    80203d82:	fcf42e23          	sw	a5,-36(s0)
    80203d86:	87ba                	mv	a5,a4
    80203d88:	fcf42c23          	sw	a5,-40(s0)
    80203d8c:	fdc42783          	lw	a5,-36(s0)
    80203d90:	853e                	mv	a0,a5
    80203d92:	8dfff0ef          	jal	80203670 <pid_to_slot>
    80203d96:	87aa                	mv	a5,a0
    80203d98:	fef42623          	sw	a5,-20(s0)
    80203d9c:	fec42783          	lw	a5,-20(s0)
    80203da0:	2781                	sext.w	a5,a5
    80203da2:	0407c463          	bltz	a5,80203dea <proc_user_exit+0x74>
    80203da6:	00011717          	auipc	a4,0x11
    80203daa:	d3270713          	addi	a4,a4,-718 # 80214ad8 <exit_status>
    80203dae:	fec42783          	lw	a5,-20(s0)
    80203db2:	078a                	slli	a5,a5,0x2
    80203db4:	97ba                	add	a5,a5,a4
    80203db6:	fd842703          	lw	a4,-40(s0)
    80203dba:	c398                	sw	a4,0(a5)
    80203dbc:	fdc42783          	lw	a5,-36(s0)
    80203dc0:	853e                	mv	a0,a5
    80203dc2:	ecaff0ef          	jal	8020348c <proc_mark_zombie>
    80203dc6:	eafff0ef          	jal	80203c74 <proc_user_prepare_kernel_return>
    80203dca:	0000b797          	auipc	a5,0xb
    80203dce:	2de78793          	addi	a5,a5,734 # 8020f0a8 <proc_user_exit_pending>
    80203dd2:	4705                	li	a4,1
    80203dd4:	c398                	sw	a4,0(a5)
    80203dd6:	0000b797          	auipc	a5,0xb
    80203dda:	2ca78793          	addi	a5,a5,714 # 8020f0a0 <user_trap_save_cxt>
    80203dde:	0000c717          	auipc	a4,0xc
    80203de2:	bfa70713          	addi	a4,a4,-1030 # 8020f9d8 <kernel_user_exit_cxt>
    80203de6:	e398                	sd	a4,0(a5)
    80203de8:	a011                	j	80203dec <proc_user_exit+0x76>
    80203dea:	0001                	nop
    80203dec:	70a2                	ld	ra,40(sp)
    80203dee:	7402                	ld	s0,32(sp)
    80203df0:	6145                	addi	sp,sp,48
    80203df2:	8082                	ret

0000000080203df4 <proc_fork>:
    80203df4:	7139                	addi	sp,sp,-64
    80203df6:	fc06                	sd	ra,56(sp)
    80203df8:	f822                	sd	s0,48(sp)
    80203dfa:	0080                	addi	s0,sp,64
    80203dfc:	87aa                	mv	a5,a0
    80203dfe:	fcf42623          	sw	a5,-52(s0)
    80203e02:	fcc42783          	lw	a5,-52(s0)
    80203e06:	85be                	mv	a1,a5
    80203e08:	4501                	li	a0,0
    80203e0a:	8f4ff0ef          	jal	80202efe <proc_alloc>
    80203e0e:	87aa                	mv	a5,a0
    80203e10:	fef42623          	sw	a5,-20(s0)
    80203e14:	fec42783          	lw	a5,-20(s0)
    80203e18:	2781                	sext.w	a5,a5
    80203e1a:	0007d463          	bgez	a5,80203e22 <proc_fork+0x2e>
    80203e1e:	57fd                	li	a5,-1
    80203e20:	a045                	j	80203ec0 <proc_fork+0xcc>
    80203e22:	fcc42783          	lw	a5,-52(s0)
    80203e26:	853e                	mv	a0,a5
    80203e28:	849ff0ef          	jal	80203670 <pid_to_slot>
    80203e2c:	87aa                	mv	a5,a0
    80203e2e:	fef42423          	sw	a5,-24(s0)
    80203e32:	fec42783          	lw	a5,-20(s0)
    80203e36:	853e                	mv	a0,a5
    80203e38:	839ff0ef          	jal	80203670 <pid_to_slot>
    80203e3c:	87aa                	mv	a5,a0
    80203e3e:	fef42223          	sw	a5,-28(s0)
    80203e42:	fe842783          	lw	a5,-24(s0)
    80203e46:	2781                	sext.w	a5,a5
    80203e48:	0007c763          	bltz	a5,80203e56 <proc_fork+0x62>
    80203e4c:	fe442783          	lw	a5,-28(s0)
    80203e50:	2781                	sext.w	a5,a5
    80203e52:	0007d463          	bgez	a5,80203e5a <proc_fork+0x66>
    80203e56:	57fd                	li	a5,-1
    80203e58:	a0a5                	j	80203ec0 <proc_fork+0xcc>
    80203e5a:	fe842783          	lw	a5,-24(s0)
    80203e5e:	00879713          	slli	a4,a5,0x8
    80203e62:	00010797          	auipc	a5,0x10
    80203e66:	c7678793          	addi	a5,a5,-906 # 80213ad8 <uctx_table>
    80203e6a:	97ba                	add	a5,a5,a4
    80203e6c:	fcf43c23          	sd	a5,-40(s0)
    80203e70:	fe442783          	lw	a5,-28(s0)
    80203e74:	00879713          	slli	a4,a5,0x8
    80203e78:	00010797          	auipc	a5,0x10
    80203e7c:	c6078793          	addi	a5,a5,-928 # 80213ad8 <uctx_table>
    80203e80:	97ba                	add	a5,a5,a4
    80203e82:	fcf43823          	sd	a5,-48(s0)
    80203e86:	fd843583          	ld	a1,-40(s0)
    80203e8a:	fd043503          	ld	a0,-48(s0)
    80203e8e:	981ff0ef          	jal	8020380e <uctx_copy>
    80203e92:	fcc42703          	lw	a4,-52(s0)
    80203e96:	fec42783          	lw	a5,-20(s0)
    80203e9a:	85ba                	mv	a1,a4
    80203e9c:	853e                	mv	a0,a5
    80203e9e:	9d3ff0ef          	jal	80203870 <user_mem_copy>
    80203ea2:	fec42783          	lw	a5,-20(s0)
    80203ea6:	4585                	li	a1,1
    80203ea8:	853e                	mv	a0,a5
    80203eaa:	ae4ff0ef          	jal	8020318e <proc_set_state>
    80203eae:	0000b797          	auipc	a5,0xb
    80203eb2:	15678793          	addi	a5,a5,342 # 8020f004 <fork_child_pending>
    80203eb6:	fec42703          	lw	a4,-20(s0)
    80203eba:	c398                	sw	a4,0(a5)
    80203ebc:	fec42783          	lw	a5,-20(s0)
    80203ec0:	853e                	mv	a0,a5
    80203ec2:	70e2                	ld	ra,56(sp)
    80203ec4:	7442                	ld	s0,48(sp)
    80203ec6:	6121                	addi	sp,sp,64
    80203ec8:	8082                	ret

0000000080203eca <proc_wait>:
    80203eca:	7101                	addi	sp,sp,-512
    80203ecc:	ff86                	sd	ra,504(sp)
    80203ece:	fba2                	sd	s0,496(sp)
    80203ed0:	0400                	addi	s0,sp,512
    80203ed2:	87aa                	mv	a5,a0
    80203ed4:	872e                	mv	a4,a1
    80203ed6:	e0f42623          	sw	a5,-500(s0)
    80203eda:	87ba                	mv	a5,a4
    80203edc:	e0f42423          	sw	a5,-504(s0)
    80203ee0:	0000b797          	auipc	a5,0xb
    80203ee4:	12478793          	addi	a5,a5,292 # 8020f004 <fork_child_pending>
    80203ee8:	439c                	lw	a5,0(a5)
    80203eea:	02f05e63          	blez	a5,80203f26 <proc_wait+0x5c>
    80203eee:	0000b797          	auipc	a5,0xb
    80203ef2:	11678793          	addi	a5,a5,278 # 8020f004 <fork_child_pending>
    80203ef6:	439c                	lw	a5,0(a5)
    80203ef8:	e0842703          	lw	a4,-504(s0)
    80203efc:	2701                	sext.w	a4,a4
    80203efe:	02f71463          	bne	a4,a5,80203f26 <proc_wait+0x5c>
    80203f02:	0000b797          	auipc	a5,0xb
    80203f06:	10278793          	addi	a5,a5,258 # 8020f004 <fork_child_pending>
    80203f0a:	439c                	lw	a5,0(a5)
    80203f0c:	fef42223          	sw	a5,-28(s0)
    80203f10:	0000b797          	auipc	a5,0xb
    80203f14:	0f478793          	addi	a5,a5,244 # 8020f004 <fork_child_pending>
    80203f18:	577d                	li	a4,-1
    80203f1a:	c398                	sw	a4,0(a5)
    80203f1c:	fe442783          	lw	a5,-28(s0)
    80203f20:	853e                	mv	a0,a5
    80203f22:	db3ff0ef          	jal	80203cd4 <proc_user_run>
    80203f26:	e1840793          	addi	a5,s0,-488
    80203f2a:	45c1                	li	a1,16
    80203f2c:	853e                	mv	a0,a5
    80203f2e:	bb2ff0ef          	jal	802032e0 <proc_list>
    80203f32:	87aa                	mv	a5,a0
    80203f34:	fef42023          	sw	a5,-32(s0)
    80203f38:	fe042623          	sw	zero,-20(s0)
    80203f3c:	a079                	j	80203fca <proc_wait+0x100>
    80203f3e:	fec42703          	lw	a4,-20(s0)
    80203f42:	87ba                	mv	a5,a4
    80203f44:	078e                	slli	a5,a5,0x3
    80203f46:	8f99                	sub	a5,a5,a4
    80203f48:	078a                	slli	a5,a5,0x2
    80203f4a:	17c1                	addi	a5,a5,-16
    80203f4c:	97a2                	add	a5,a5,s0
    80203f4e:	e287a783          	lw	a5,-472(a5)
    80203f52:	e0842703          	lw	a4,-504(s0)
    80203f56:	2701                	sext.w	a4,a4
    80203f58:	06f71363          	bne	a4,a5,80203fbe <proc_wait+0xf4>
    80203f5c:	fec42703          	lw	a4,-20(s0)
    80203f60:	87ba                	mv	a5,a4
    80203f62:	078e                	slli	a5,a5,0x3
    80203f64:	8f99                	sub	a5,a5,a4
    80203f66:	078a                	slli	a5,a5,0x2
    80203f68:	17c1                	addi	a5,a5,-16
    80203f6a:	97a2                	add	a5,a5,s0
    80203f6c:	e307a703          	lw	a4,-464(a5)
    80203f70:	478d                	li	a5,3
    80203f72:	04f71763          	bne	a4,a5,80203fc0 <proc_wait+0xf6>
    80203f76:	e0842783          	lw	a5,-504(s0)
    80203f7a:	853e                	mv	a0,a5
    80203f7c:	ef4ff0ef          	jal	80203670 <pid_to_slot>
    80203f80:	87aa                	mv	a5,a0
    80203f82:	fcf42e23          	sw	a5,-36(s0)
    80203f86:	fdc42783          	lw	a5,-36(s0)
    80203f8a:	2781                	sext.w	a5,a5
    80203f8c:	0007ce63          	bltz	a5,80203fa8 <proc_wait+0xde>
    80203f90:	00011717          	auipc	a4,0x11
    80203f94:	b4870713          	addi	a4,a4,-1208 # 80214ad8 <exit_status>
    80203f98:	fdc42783          	lw	a5,-36(s0)
    80203f9c:	078a                	slli	a5,a5,0x2
    80203f9e:	97ba                	add	a5,a5,a4
    80203fa0:	439c                	lw	a5,0(a5)
    80203fa2:	fef42423          	sw	a5,-24(s0)
    80203fa6:	a019                	j	80203fac <proc_wait+0xe2>
    80203fa8:	fe042423          	sw	zero,-24(s0)
    80203fac:	e0842783          	lw	a5,-504(s0)
    80203fb0:	4581                	li	a1,0
    80203fb2:	853e                	mv	a0,a5
    80203fb4:	9daff0ef          	jal	8020318e <proc_set_state>
    80203fb8:	fe842783          	lw	a5,-24(s0)
    80203fbc:	a01d                	j	80203fe2 <proc_wait+0x118>
    80203fbe:	0001                	nop
    80203fc0:	fec42783          	lw	a5,-20(s0)
    80203fc4:	2785                	addiw	a5,a5,1
    80203fc6:	fef42623          	sw	a5,-20(s0)
    80203fca:	fec42783          	lw	a5,-20(s0)
    80203fce:	873e                	mv	a4,a5
    80203fd0:	fe042783          	lw	a5,-32(s0)
    80203fd4:	2701                	sext.w	a4,a4
    80203fd6:	2781                	sext.w	a5,a5
    80203fd8:	f6f743e3          	blt	a4,a5,80203f3e <proc_wait+0x74>
    80203fdc:	10500073          	wfi
    80203fe0:	b799                	j	80203f26 <proc_wait+0x5c>
    80203fe2:	853e                	mv	a0,a5
    80203fe4:	70fe                	ld	ra,504(sp)
    80203fe6:	745e                	ld	s0,496(sp)
    80203fe8:	20010113          	addi	sp,sp,512
    80203fec:	8082                	ret

0000000080203fee <proc_spawn_exec_wait>:
    80203fee:	7139                	addi	sp,sp,-64
    80203ff0:	fc06                	sd	ra,56(sp)
    80203ff2:	f822                	sd	s0,48(sp)
    80203ff4:	0080                	addi	s0,sp,64
    80203ff6:	fca43423          	sd	a0,-56(s0)
    80203ffa:	fc843783          	ld	a5,-56(s0)
    80203ffe:	fef43423          	sd	a5,-24(s0)
    80204002:	fe042223          	sw	zero,-28(s0)
    80204006:	a815                	j	8020403a <proc_spawn_exec_wait+0x4c>
    80204008:	fe442783          	lw	a5,-28(s0)
    8020400c:	fc843703          	ld	a4,-56(s0)
    80204010:	97ba                	add	a5,a5,a4
    80204012:	0007c783          	lbu	a5,0(a5)
    80204016:	873e                	mv	a4,a5
    80204018:	02f00793          	li	a5,47
    8020401c:	00f71a63          	bne	a4,a5,80204030 <proc_spawn_exec_wait+0x42>
    80204020:	fe442783          	lw	a5,-28(s0)
    80204024:	0785                	addi	a5,a5,1
    80204026:	fc843703          	ld	a4,-56(s0)
    8020402a:	97ba                	add	a5,a5,a4
    8020402c:	fef43423          	sd	a5,-24(s0)
    80204030:	fe442783          	lw	a5,-28(s0)
    80204034:	2785                	addiw	a5,a5,1
    80204036:	fef42223          	sw	a5,-28(s0)
    8020403a:	fe442783          	lw	a5,-28(s0)
    8020403e:	fc843703          	ld	a4,-56(s0)
    80204042:	97ba                	add	a5,a5,a4
    80204044:	0007c783          	lbu	a5,0(a5)
    80204048:	f3e1                	bnez	a5,80204008 <proc_spawn_exec_wait+0x1a>
    8020404a:	fe042223          	sw	zero,-28(s0)
    8020404e:	a01d                	j	80204074 <proc_spawn_exec_wait+0x86>
    80204050:	fe442783          	lw	a5,-28(s0)
    80204054:	fe843703          	ld	a4,-24(s0)
    80204058:	97ba                	add	a5,a5,a4
    8020405a:	0007c703          	lbu	a4,0(a5)
    8020405e:	fe442783          	lw	a5,-28(s0)
    80204062:	17c1                	addi	a5,a5,-16
    80204064:	97a2                	add	a5,a5,s0
    80204066:	fee78023          	sb	a4,-32(a5)
    8020406a:	fe442783          	lw	a5,-28(s0)
    8020406e:	2785                	addiw	a5,a5,1
    80204070:	fef42223          	sw	a5,-28(s0)
    80204074:	fe442783          	lw	a5,-28(s0)
    80204078:	fe843703          	ld	a4,-24(s0)
    8020407c:	97ba                	add	a5,a5,a4
    8020407e:	0007c783          	lbu	a5,0(a5)
    80204082:	cb81                	beqz	a5,80204092 <proc_spawn_exec_wait+0xa4>
    80204084:	fe442783          	lw	a5,-28(s0)
    80204088:	0007871b          	sext.w	a4,a5
    8020408c:	47b9                	li	a5,14
    8020408e:	fce7d1e3          	bge	a5,a4,80204050 <proc_spawn_exec_wait+0x62>
    80204092:	fe442783          	lw	a5,-28(s0)
    80204096:	17c1                	addi	a5,a5,-16
    80204098:	97a2                	add	a5,a5,s0
    8020409a:	fe078023          	sb	zero,-32(a5)
    8020409e:	fd040793          	addi	a5,s0,-48
    802040a2:	4585                	li	a1,1
    802040a4:	853e                	mv	a0,a5
    802040a6:	e59fe0ef          	jal	80202efe <proc_alloc>
    802040aa:	87aa                	mv	a5,a0
    802040ac:	fef42023          	sw	a5,-32(s0)
    802040b0:	fe042783          	lw	a5,-32(s0)
    802040b4:	2781                	sext.w	a5,a5
    802040b6:	0007d463          	bgez	a5,802040be <proc_spawn_exec_wait+0xd0>
    802040ba:	57fd                	li	a5,-1
    802040bc:	a0a9                	j	80204106 <proc_spawn_exec_wait+0x118>
    802040be:	fe042783          	lw	a5,-32(s0)
    802040c2:	fc843583          	ld	a1,-56(s0)
    802040c6:	853e                	mv	a0,a5
    802040c8:	fdcff0ef          	jal	802038a4 <proc_load_elf>
    802040cc:	87aa                	mv	a5,a0
    802040ce:	0207d063          	bgez	a5,802040ee <proc_spawn_exec_wait+0x100>
    802040d2:	fe042783          	lw	a5,-32(s0)
    802040d6:	4581                	li	a1,0
    802040d8:	853e                	mv	a0,a5
    802040da:	8b4ff0ef          	jal	8020318e <proc_set_state>
    802040de:	00004517          	auipc	a0,0x4
    802040e2:	33250513          	addi	a0,a0,818 # 80208410 <user_code_end+0xa40>
    802040e6:	bbcfd0ef          	jal	802014a2 <uart_puts>
    802040ea:	57fd                	li	a5,-1
    802040ec:	a829                	j	80204106 <proc_spawn_exec_wait+0x118>
    802040ee:	fe042783          	lw	a5,-32(s0)
    802040f2:	853e                	mv	a0,a5
    802040f4:	be1ff0ef          	jal	80203cd4 <proc_user_run>
    802040f8:	fe042783          	lw	a5,-32(s0)
    802040fc:	85be                	mv	a1,a5
    802040fe:	4505                	li	a0,1
    80204100:	dcbff0ef          	jal	80203eca <proc_wait>
    80204104:	87aa                	mv	a5,a0
    80204106:	853e                	mv	a0,a5
    80204108:	70e2                	ld	ra,56(sp)
    8020410a:	7442                	ld	s0,48(sp)
    8020410c:	6121                	addi	sp,sp,64
    8020410e:	8082                	ret

0000000080204110 <prog_is_elf_path>:
    80204110:	7179                	addi	sp,sp,-48
    80204112:	f406                	sd	ra,40(sp)
    80204114:	f022                	sd	s0,32(sp)
    80204116:	1800                	addi	s0,sp,48
    80204118:	fca43c23          	sd	a0,-40(s0)
    8020411c:	fe040793          	addi	a5,s0,-32
    80204120:	4621                	li	a2,8
    80204122:	85be                	mv	a1,a5
    80204124:	fd843503          	ld	a0,-40(s0)
    80204128:	3e9010ef          	jal	80205d10 <fs_read_file>
    8020412c:	87aa                	mv	a5,a0
    8020412e:	fef42623          	sw	a5,-20(s0)
    80204132:	fec42783          	lw	a5,-20(s0)
    80204136:	0007871b          	sext.w	a4,a5
    8020413a:	478d                	li	a5,3
    8020413c:	00e7c463          	blt	a5,a4,80204144 <prog_is_elf_path+0x34>
    80204140:	4781                	li	a5,0
    80204142:	a839                	j	80204160 <prog_is_elf_path+0x50>
    80204144:	fe040793          	addi	a5,s0,-32
    80204148:	4398                	lw	a4,0(a5)
    8020414a:	464c47b7          	lui	a5,0x464c4
    8020414e:	57f78793          	addi	a5,a5,1407 # 464c457f <_heap_size+0x3e5ddfb7>
    80204152:	40f707b3          	sub	a5,a4,a5
    80204156:	0017b793          	seqz	a5,a5
    8020415a:	0ff7f793          	zext.b	a5,a5
    8020415e:	2781                	sext.w	a5,a5
    80204160:	853e                	mv	a0,a5
    80204162:	70a2                	ld	ra,40(sp)
    80204164:	7402                	ld	s0,32(sp)
    80204166:	6145                	addi	sp,sp,48
    80204168:	8082                	ret

000000008020416a <r_sie>:
    8020416a:	1101                	addi	sp,sp,-32
    8020416c:	ec06                	sd	ra,24(sp)
    8020416e:	e822                	sd	s0,16(sp)
    80204170:	1000                	addi	s0,sp,32
    80204172:	104027f3          	csrr	a5,sie
    80204176:	fef43423          	sd	a5,-24(s0)
    8020417a:	fe843783          	ld	a5,-24(s0)
    8020417e:	853e                	mv	a0,a5
    80204180:	60e2                	ld	ra,24(sp)
    80204182:	6442                	ld	s0,16(sp)
    80204184:	6105                	addi	sp,sp,32
    80204186:	8082                	ret

0000000080204188 <w_sie>:
    80204188:	1101                	addi	sp,sp,-32
    8020418a:	ec06                	sd	ra,24(sp)
    8020418c:	e822                	sd	s0,16(sp)
    8020418e:	1000                	addi	s0,sp,32
    80204190:	fea43423          	sd	a0,-24(s0)
    80204194:	fe843783          	ld	a5,-24(s0)
    80204198:	10479073          	csrw	sie,a5
    8020419c:	0001                	nop
    8020419e:	60e2                	ld	ra,24(sp)
    802041a0:	6442                	ld	s0,16(sp)
    802041a2:	6105                	addi	sp,sp,32
    802041a4:	8082                	ret

00000000802041a6 <r_sip>:
    802041a6:	1101                	addi	sp,sp,-32
    802041a8:	ec06                	sd	ra,24(sp)
    802041aa:	e822                	sd	s0,16(sp)
    802041ac:	1000                	addi	s0,sp,32
    802041ae:	144027f3          	csrr	a5,sip
    802041b2:	fef43423          	sd	a5,-24(s0)
    802041b6:	fe843783          	ld	a5,-24(s0)
    802041ba:	853e                	mv	a0,a5
    802041bc:	60e2                	ld	ra,24(sp)
    802041be:	6442                	ld	s0,16(sp)
    802041c0:	6105                	addi	sp,sp,32
    802041c2:	8082                	ret

00000000802041c4 <w_sip>:
    802041c4:	1101                	addi	sp,sp,-32
    802041c6:	ec06                	sd	ra,24(sp)
    802041c8:	e822                	sd	s0,16(sp)
    802041ca:	1000                	addi	s0,sp,32
    802041cc:	fea43423          	sd	a0,-24(s0)
    802041d0:	fe843783          	ld	a5,-24(s0)
    802041d4:	14479073          	csrw	sip,a5
    802041d8:	0001                	nop
    802041da:	60e2                	ld	ra,24(sp)
    802041dc:	6442                	ld	s0,16(sp)
    802041de:	6105                	addi	sp,sp,32
    802041e0:	8082                	ret

00000000802041e2 <trap_ie_enable>:
    802041e2:	1101                	addi	sp,sp,-32
    802041e4:	ec06                	sd	ra,24(sp)
    802041e6:	e822                	sd	s0,16(sp)
    802041e8:	1000                	addi	s0,sp,32
    802041ea:	fea43423          	sd	a0,-24(s0)
    802041ee:	f7dff0ef          	jal	8020416a <r_sie>
    802041f2:	872a                	mv	a4,a0
    802041f4:	fe843783          	ld	a5,-24(s0)
    802041f8:	8fd9                	or	a5,a5,a4
    802041fa:	853e                	mv	a0,a5
    802041fc:	f8dff0ef          	jal	80204188 <w_sie>
    80204200:	0001                	nop
    80204202:	60e2                	ld	ra,24(sp)
    80204204:	6442                	ld	s0,16(sp)
    80204206:	6105                	addi	sp,sp,32
    80204208:	8082                	ret

000000008020420a <task_idle_loop>:
    8020420a:	1141                	addi	sp,sp,-16
    8020420c:	e406                	sd	ra,8(sp)
    8020420e:	e022                	sd	s0,0(sp)
    80204210:	0800                	addi	s0,sp,16
    80204212:	10500073          	wfi
    80204216:	bff5                	j	80204212 <task_idle_loop+0x8>

0000000080204218 <sched_task_count>:
    80204218:	1141                	addi	sp,sp,-16
    8020421a:	e406                	sd	ra,8(sp)
    8020421c:	e022                	sd	s0,0(sp)
    8020421e:	0800                	addi	s0,sp,16
    80204220:	00014797          	auipc	a5,0x14
    80204224:	b1078793          	addi	a5,a5,-1264 # 80217d30 <_top>
    80204228:	439c                	lw	a5,0(a5)
    8020422a:	853e                	mv	a0,a5
    8020422c:	60a2                	ld	ra,8(sp)
    8020422e:	6402                	ld	s0,0(sp)
    80204230:	0141                	addi	sp,sp,16
    80204232:	8082                	ret

0000000080204234 <sched_init>:
    80204234:	1141                	addi	sp,sp,-16
    80204236:	e406                	sd	ra,8(sp)
    80204238:	e022                	sd	s0,0(sp)
    8020423a:	0800                	addi	s0,sp,16
    8020423c:	4509                	li	a0,2
    8020423e:	fa5ff0ef          	jal	802041e2 <trap_ie_enable>
    80204242:	0001                	nop
    80204244:	60a2                	ld	ra,8(sp)
    80204246:	6402                	ld	s0,0(sp)
    80204248:	0141                	addi	sp,sp,16
    8020424a:	8082                	ret

000000008020424c <schedule>:
    8020424c:	1101                	addi	sp,sp,-32
    8020424e:	ec06                	sd	ra,24(sp)
    80204250:	e822                	sd	s0,16(sp)
    80204252:	1000                	addi	s0,sp,32
    80204254:	00014797          	auipc	a5,0x14
    80204258:	adc78793          	addi	a5,a5,-1316 # 80217d30 <_top>
    8020425c:	439c                	lw	a5,0(a5)
    8020425e:	00f04963          	bgtz	a5,80204270 <schedule+0x24>
    80204262:	00004517          	auipc	a0,0x4
    80204266:	1c650513          	addi	a0,a0,454 # 80208428 <user_code_end+0xa58>
    8020426a:	f15fc0ef          	jal	8020117e <panic>
    8020426e:	a889                	j	802042c0 <schedule+0x74>
    80204270:	0000b797          	auipc	a5,0xb
    80204274:	d9c78793          	addi	a5,a5,-612 # 8020f00c <_current>
    80204278:	439c                	lw	a5,0(a5)
    8020427a:	2785                	addiw	a5,a5,1
    8020427c:	0007871b          	sext.w	a4,a5
    80204280:	00014797          	auipc	a5,0x14
    80204284:	ab078793          	addi	a5,a5,-1360 # 80217d30 <_top>
    80204288:	439c                	lw	a5,0(a5)
    8020428a:	02f767bb          	remw	a5,a4,a5
    8020428e:	0007871b          	sext.w	a4,a5
    80204292:	0000b797          	auipc	a5,0xb
    80204296:	d7a78793          	addi	a5,a5,-646 # 8020f00c <_current>
    8020429a:	c398                	sw	a4,0(a5)
    8020429c:	0000b797          	auipc	a5,0xb
    802042a0:	d7078793          	addi	a5,a5,-656 # 8020f00c <_current>
    802042a4:	439c                	lw	a5,0(a5)
    802042a6:	00879713          	slli	a4,a5,0x8
    802042aa:	00013797          	auipc	a5,0x13
    802042ae:	08678793          	addi	a5,a5,134 # 80217330 <ctx_tasks>
    802042b2:	97ba                	add	a5,a5,a4
    802042b4:	fef43423          	sd	a5,-24(s0)
    802042b8:	fe843503          	ld	a0,-24(s0)
    802042bc:	870fc0ef          	jal	8020032c <switch_to>
    802042c0:	60e2                	ld	ra,24(sp)
    802042c2:	6442                	ld	s0,16(sp)
    802042c4:	6105                	addi	sp,sp,32
    802042c6:	8082                	ret

00000000802042c8 <task_create>:
    802042c8:	1101                	addi	sp,sp,-32
    802042ca:	ec06                	sd	ra,24(sp)
    802042cc:	e822                	sd	s0,16(sp)
    802042ce:	1000                	addi	s0,sp,32
    802042d0:	fea43423          	sd	a0,-24(s0)
    802042d4:	00014797          	auipc	a5,0x14
    802042d8:	a5c78793          	addi	a5,a5,-1444 # 80217d30 <_top>
    802042dc:	4398                	lw	a4,0(a5)
    802042de:	47a5                	li	a5,9
    802042e0:	06e7c963          	blt	a5,a4,80204352 <task_create+0x8a>
    802042e4:	00014797          	auipc	a5,0x14
    802042e8:	a4c78793          	addi	a5,a5,-1460 # 80217d30 <_top>
    802042ec:	439c                	lw	a5,0(a5)
    802042ee:	0785                	addi	a5,a5,1
    802042f0:	00a79713          	slli	a4,a5,0xa
    802042f4:	00011797          	auipc	a5,0x11
    802042f8:	83c78793          	addi	a5,a5,-1988 # 80214b30 <task_stack>
    802042fc:	973e                	add	a4,a4,a5
    802042fe:	00014797          	auipc	a5,0x14
    80204302:	a3278793          	addi	a5,a5,-1486 # 80217d30 <_top>
    80204306:	439c                	lw	a5,0(a5)
    80204308:	86ba                	mv	a3,a4
    8020430a:	00013717          	auipc	a4,0x13
    8020430e:	02670713          	addi	a4,a4,38 # 80217330 <ctx_tasks>
    80204312:	07a2                	slli	a5,a5,0x8
    80204314:	97ba                	add	a5,a5,a4
    80204316:	e794                	sd	a3,8(a5)
    80204318:	00014797          	auipc	a5,0x14
    8020431c:	a1878793          	addi	a5,a5,-1512 # 80217d30 <_top>
    80204320:	439c                	lw	a5,0(a5)
    80204322:	fe843703          	ld	a4,-24(s0)
    80204326:	00013697          	auipc	a3,0x13
    8020432a:	00a68693          	addi	a3,a3,10 # 80217330 <ctx_tasks>
    8020432e:	07a2                	slli	a5,a5,0x8
    80204330:	97b6                	add	a5,a5,a3
    80204332:	fff8                	sd	a4,248(a5)
    80204334:	00014797          	auipc	a5,0x14
    80204338:	9fc78793          	addi	a5,a5,-1540 # 80217d30 <_top>
    8020433c:	439c                	lw	a5,0(a5)
    8020433e:	2785                	addiw	a5,a5,1
    80204340:	0007871b          	sext.w	a4,a5
    80204344:	00014797          	auipc	a5,0x14
    80204348:	9ec78793          	addi	a5,a5,-1556 # 80217d30 <_top>
    8020434c:	c398                	sw	a4,0(a5)
    8020434e:	4781                	li	a5,0
    80204350:	a011                	j	80204354 <task_create+0x8c>
    80204352:	57fd                	li	a5,-1
    80204354:	853e                	mv	a0,a5
    80204356:	60e2                	ld	ra,24(sp)
    80204358:	6442                	ld	s0,16(sp)
    8020435a:	6105                	addi	sp,sp,32
    8020435c:	8082                	ret

000000008020435e <task_yield>:
    8020435e:	1141                	addi	sp,sp,-16
    80204360:	e406                	sd	ra,8(sp)
    80204362:	e022                	sd	s0,0(sp)
    80204364:	0800                	addi	s0,sp,16
    80204366:	e41ff0ef          	jal	802041a6 <r_sip>
    8020436a:	87aa                	mv	a5,a0
    8020436c:	0027e793          	ori	a5,a5,2
    80204370:	853e                	mv	a0,a5
    80204372:	e53ff0ef          	jal	802041c4 <w_sip>
    80204376:	0001                	nop
    80204378:	60a2                	ld	ra,8(sp)
    8020437a:	6402                	ld	s0,0(sp)
    8020437c:	0141                	addi	sp,sp,16
    8020437e:	8082                	ret

0000000080204380 <task_exit_to_idle>:
    80204380:	1101                	addi	sp,sp,-32
    80204382:	ec06                	sd	ra,24(sp)
    80204384:	e822                	sd	s0,16(sp)
    80204386:	1000                	addi	s0,sp,32
    80204388:	fea43423          	sd	a0,-24(s0)
    8020438c:	87ae                	mv	a5,a1
    8020438e:	fef42223          	sw	a5,-28(s0)
    80204392:	fe442703          	lw	a4,-28(s0)
    80204396:	fe843783          	ld	a5,-24(s0)
    8020439a:	e7b8                	sd	a4,72(a5)
    8020439c:	00000717          	auipc	a4,0x0
    802043a0:	e6e70713          	addi	a4,a4,-402 # 8020420a <task_idle_loop>
    802043a4:	fe843783          	ld	a5,-24(s0)
    802043a8:	fff8                	sd	a4,248(a5)
    802043aa:	0001                	nop
    802043ac:	60e2                	ld	ra,24(sp)
    802043ae:	6442                	ld	s0,16(sp)
    802043b0:	6105                	addi	sp,sp,32
    802043b2:	8082                	ret

00000000802043b4 <task_delay>:
    802043b4:	1101                	addi	sp,sp,-32
    802043b6:	ec06                	sd	ra,24(sp)
    802043b8:	e822                	sd	s0,16(sp)
    802043ba:	1000                	addi	s0,sp,32
    802043bc:	87aa                	mv	a5,a0
    802043be:	fef42623          	sw	a5,-20(s0)
    802043c2:	fec42783          	lw	a5,-20(s0)
    802043c6:	0007871b          	sext.w	a4,a5
    802043ca:	67b1                	lui	a5,0xc
    802043cc:	3507879b          	addiw	a5,a5,848 # c350 <STACK_SIZE+0xb350>
    802043d0:	02f707bb          	mulw	a5,a4,a5
    802043d4:	2781                	sext.w	a5,a5
    802043d6:	fef42623          	sw	a5,-20(s0)
    802043da:	0001                	nop
    802043dc:	fec42783          	lw	a5,-20(s0)
    802043e0:	2781                	sext.w	a5,a5
    802043e2:	fff7871b          	addiw	a4,a5,-1
    802043e6:	2701                	sext.w	a4,a4
    802043e8:	fee42623          	sw	a4,-20(s0)
    802043ec:	fbe5                	bnez	a5,802043dc <task_delay+0x28>
    802043ee:	0001                	nop
    802043f0:	0001                	nop
    802043f2:	60e2                	ld	ra,24(sp)
    802043f4:	6442                	ld	s0,16(sp)
    802043f6:	6105                	addi	sp,sp,32
    802043f8:	8082                	ret

00000000802043fa <r_tp>:
    802043fa:	1101                	addi	sp,sp,-32
    802043fc:	ec06                	sd	ra,24(sp)
    802043fe:	e822                	sd	s0,16(sp)
    80204400:	1000                	addi	s0,sp,32
    80204402:	8792                	mv	a5,tp
    80204404:	fef43423          	sd	a5,-24(s0)
    80204408:	fe843783          	ld	a5,-24(s0)
    8020440c:	853e                	mv	a0,a5
    8020440e:	60e2                	ld	ra,24(sp)
    80204410:	6442                	ld	s0,16(sp)
    80204412:	6105                	addi	sp,sp,32
    80204414:	8082                	ret

0000000080204416 <r_mhartid>:
    80204416:	1141                	addi	sp,sp,-16
    80204418:	e406                	sd	ra,8(sp)
    8020441a:	e022                	sd	s0,0(sp)
    8020441c:	0800                	addi	s0,sp,16
    8020441e:	fddff0ef          	jal	802043fa <r_tp>
    80204422:	87aa                	mv	a5,a0
    80204424:	853e                	mv	a0,a5
    80204426:	60a2                	ld	ra,8(sp)
    80204428:	6402                	ld	s0,0(sp)
    8020442a:	0141                	addi	sp,sp,16
    8020442c:	8082                	ret

000000008020442e <sys_open>:
    8020442e:	1101                	addi	sp,sp,-32
    80204430:	ec06                	sd	ra,24(sp)
    80204432:	e822                	sd	s0,16(sp)
    80204434:	1000                	addi	s0,sp,32
    80204436:	fea43423          	sd	a0,-24(s0)
    8020443a:	87ae                	mv	a5,a1
    8020443c:	fef42223          	sw	a5,-28(s0)
    80204440:	fe442783          	lw	a5,-28(s0)
    80204444:	85be                	mv	a1,a5
    80204446:	fe843503          	ld	a0,-24(s0)
    8020444a:	3f0010ef          	jal	8020583a <fs_open>
    8020444e:	87aa                	mv	a5,a0
    80204450:	853e                	mv	a0,a5
    80204452:	60e2                	ld	ra,24(sp)
    80204454:	6442                	ld	s0,16(sp)
    80204456:	6105                	addi	sp,sp,32
    80204458:	8082                	ret

000000008020445a <sys_close>:
    8020445a:	1101                	addi	sp,sp,-32
    8020445c:	ec06                	sd	ra,24(sp)
    8020445e:	e822                	sd	s0,16(sp)
    80204460:	1000                	addi	s0,sp,32
    80204462:	87aa                	mv	a5,a0
    80204464:	fef42623          	sw	a5,-20(s0)
    80204468:	fec42783          	lw	a5,-20(s0)
    8020446c:	853e                	mv	a0,a5
    8020446e:	05d010ef          	jal	80205cca <fs_close>
    80204472:	87aa                	mv	a5,a0
    80204474:	853e                	mv	a0,a5
    80204476:	60e2                	ld	ra,24(sp)
    80204478:	6442                	ld	s0,16(sp)
    8020447a:	6105                	addi	sp,sp,32
    8020447c:	8082                	ret

000000008020447e <sys_write>:
    8020447e:	7179                	addi	sp,sp,-48
    80204480:	f406                	sd	ra,40(sp)
    80204482:	f022                	sd	s0,32(sp)
    80204484:	1800                	addi	s0,sp,48
    80204486:	87aa                	mv	a5,a0
    80204488:	fcb43823          	sd	a1,-48(s0)
    8020448c:	8732                	mv	a4,a2
    8020448e:	fcf42e23          	sw	a5,-36(s0)
    80204492:	87ba                	mv	a5,a4
    80204494:	fcf42c23          	sw	a5,-40(s0)
    80204498:	fd043783          	ld	a5,-48(s0)
    8020449c:	c791                	beqz	a5,802044a8 <sys_write+0x2a>
    8020449e:	fd842783          	lw	a5,-40(s0)
    802044a2:	2781                	sext.w	a5,a5
    802044a4:	0007d463          	bgez	a5,802044ac <sys_write+0x2e>
    802044a8:	57fd                	li	a5,-1
    802044aa:	a885                	j	8020451a <sys_write+0x9c>
    802044ac:	fdc42783          	lw	a5,-36(s0)
    802044b0:	0007871b          	sext.w	a4,a5
    802044b4:	4785                	li	a5,1
    802044b6:	00f70963          	beq	a4,a5,802044c8 <sys_write+0x4a>
    802044ba:	fdc42783          	lw	a5,-36(s0)
    802044be:	0007871b          	sext.w	a4,a5
    802044c2:	4789                	li	a5,2
    802044c4:	04f71063          	bne	a4,a5,80204504 <sys_write+0x86>
    802044c8:	fe042623          	sw	zero,-20(s0)
    802044cc:	a005                	j	802044ec <sys_write+0x6e>
    802044ce:	fec42783          	lw	a5,-20(s0)
    802044d2:	fd043703          	ld	a4,-48(s0)
    802044d6:	97ba                	add	a5,a5,a4
    802044d8:	0007c783          	lbu	a5,0(a5)
    802044dc:	853e                	mv	a0,a5
    802044de:	f77fc0ef          	jal	80201454 <uart_putc>
    802044e2:	fec42783          	lw	a5,-20(s0)
    802044e6:	2785                	addiw	a5,a5,1
    802044e8:	fef42623          	sw	a5,-20(s0)
    802044ec:	fec42783          	lw	a5,-20(s0)
    802044f0:	873e                	mv	a4,a5
    802044f2:	fd842783          	lw	a5,-40(s0)
    802044f6:	2701                	sext.w	a4,a4
    802044f8:	2781                	sext.w	a5,a5
    802044fa:	fcf74ae3          	blt	a4,a5,802044ce <sys_write+0x50>
    802044fe:	fec42783          	lw	a5,-20(s0)
    80204502:	a821                	j	8020451a <sys_write+0x9c>
    80204504:	fd842703          	lw	a4,-40(s0)
    80204508:	fdc42783          	lw	a5,-36(s0)
    8020450c:	863a                	mv	a2,a4
    8020450e:	fd043583          	ld	a1,-48(s0)
    80204512:	853e                	mv	a0,a5
    80204514:	5bc010ef          	jal	80205ad0 <fs_write>
    80204518:	87aa                	mv	a5,a0
    8020451a:	853e                	mv	a0,a5
    8020451c:	70a2                	ld	ra,40(sp)
    8020451e:	7402                	ld	s0,32(sp)
    80204520:	6145                	addi	sp,sp,48
    80204522:	8082                	ret

0000000080204524 <sys_read>:
    80204524:	1101                	addi	sp,sp,-32
    80204526:	ec06                	sd	ra,24(sp)
    80204528:	e822                	sd	s0,16(sp)
    8020452a:	1000                	addi	s0,sp,32
    8020452c:	87aa                	mv	a5,a0
    8020452e:	feb43023          	sd	a1,-32(s0)
    80204532:	8732                	mv	a4,a2
    80204534:	fef42623          	sw	a5,-20(s0)
    80204538:	87ba                	mv	a5,a4
    8020453a:	fef42423          	sw	a5,-24(s0)
    8020453e:	fe043783          	ld	a5,-32(s0)
    80204542:	c791                	beqz	a5,8020454e <sys_read+0x2a>
    80204544:	fe842783          	lw	a5,-24(s0)
    80204548:	2781                	sext.w	a5,a5
    8020454a:	00f04463          	bgtz	a5,80204552 <sys_read+0x2e>
    8020454e:	57fd                	li	a5,-1
    80204550:	a80d                	j	80204582 <sys_read+0x5e>
    80204552:	fec42783          	lw	a5,-20(s0)
    80204556:	2781                	sext.w	a5,a5
    80204558:	eb91                	bnez	a5,8020456c <sys_read+0x48>
    8020455a:	fe842783          	lw	a5,-24(s0)
    8020455e:	85be                	mv	a1,a5
    80204560:	fe043503          	ld	a0,-32(s0)
    80204564:	900fd0ef          	jal	80201664 <uart_read_buf>
    80204568:	87aa                	mv	a5,a0
    8020456a:	a821                	j	80204582 <sys_read+0x5e>
    8020456c:	fe842703          	lw	a4,-24(s0)
    80204570:	fec42783          	lw	a5,-20(s0)
    80204574:	863a                	mv	a2,a4
    80204576:	fe043583          	ld	a1,-32(s0)
    8020457a:	853e                	mv	a0,a5
    8020457c:	438010ef          	jal	802059b4 <fs_read>
    80204580:	87aa                	mv	a5,a0
    80204582:	853e                	mv	a0,a5
    80204584:	60e2                	ld	ra,24(sp)
    80204586:	6442                	ld	s0,16(sp)
    80204588:	6105                	addi	sp,sp,32
    8020458a:	8082                	ret

000000008020458c <sys_fork>:
    8020458c:	7179                	addi	sp,sp,-48
    8020458e:	f406                	sd	ra,40(sp)
    80204590:	f022                	sd	s0,32(sp)
    80204592:	1800                	addi	s0,sp,48
    80204594:	fca43c23          	sd	a0,-40(s0)
    80204598:	918ff0ef          	jal	802036b0 <proc_current_pid>
    8020459c:	87aa                	mv	a5,a0
    8020459e:	fef42623          	sw	a5,-20(s0)
    802045a2:	fec42783          	lw	a5,-20(s0)
    802045a6:	2781                	sext.w	a5,a5
    802045a8:	00f04563          	bgtz	a5,802045b2 <sys_fork+0x26>
    802045ac:	fda00793          	li	a5,-38
    802045b0:	a0a9                	j	802045fa <sys_fork+0x6e>
    802045b2:	fec42783          	lw	a5,-20(s0)
    802045b6:	853e                	mv	a0,a5
    802045b8:	83dff0ef          	jal	80203df4 <proc_fork>
    802045bc:	87aa                	mv	a5,a0
    802045be:	fef42423          	sw	a5,-24(s0)
    802045c2:	fe842783          	lw	a5,-24(s0)
    802045c6:	2781                	sext.w	a5,a5
    802045c8:	0007d463          	bgez	a5,802045d0 <sys_fork+0x44>
    802045cc:	57fd                	li	a5,-1
    802045ce:	a035                	j	802045fa <sys_fork+0x6e>
    802045d0:	fe842703          	lw	a4,-24(s0)
    802045d4:	fd843783          	ld	a5,-40(s0)
    802045d8:	e7b8                	sd	a4,72(a5)
    802045da:	00004617          	auipc	a2,0x4
    802045de:	e7e60613          	addi	a2,a2,-386 # 80208458 <user_code_end+0xa88>
    802045e2:	00004597          	auipc	a1,0x4
    802045e6:	e8658593          	addi	a1,a1,-378 # 80208468 <user_code_end+0xa98>
    802045ea:	00004517          	auipc	a0,0x4
    802045ee:	e8650513          	addi	a0,a0,-378 # 80208470 <user_code_end+0xaa0>
    802045f2:	a8afc0ef          	jal	8020087c <osviz_event>
    802045f6:	fe842783          	lw	a5,-24(s0)
    802045fa:	853e                	mv	a0,a5
    802045fc:	70a2                	ld	ra,40(sp)
    802045fe:	7402                	ld	s0,32(sp)
    80204600:	6145                	addi	sp,sp,48
    80204602:	8082                	ret

0000000080204604 <sys_waitpid>:
    80204604:	1101                	addi	sp,sp,-32
    80204606:	ec06                	sd	ra,24(sp)
    80204608:	e822                	sd	s0,16(sp)
    8020460a:	1000                	addi	s0,sp,32
    8020460c:	87aa                	mv	a5,a0
    8020460e:	872e                	mv	a4,a1
    80204610:	fef42623          	sw	a5,-20(s0)
    80204614:	87ba                	mv	a5,a4
    80204616:	fef42423          	sw	a5,-24(s0)
    8020461a:	fec42783          	lw	a5,-20(s0)
    8020461e:	2781                	sext.w	a5,a5
    80204620:	00f04463          	bgtz	a5,80204628 <sys_waitpid+0x24>
    80204624:	57fd                	li	a5,-1
    80204626:	a015                	j	8020464a <sys_waitpid+0x46>
    80204628:	fe842783          	lw	a5,-24(s0)
    8020462c:	2781                	sext.w	a5,a5
    8020462e:	00f04563          	bgtz	a5,80204638 <sys_waitpid+0x34>
    80204632:	fda00793          	li	a5,-38
    80204636:	a811                	j	8020464a <sys_waitpid+0x46>
    80204638:	fe842703          	lw	a4,-24(s0)
    8020463c:	fec42783          	lw	a5,-20(s0)
    80204640:	85ba                	mv	a1,a4
    80204642:	853e                	mv	a0,a5
    80204644:	887ff0ef          	jal	80203eca <proc_wait>
    80204648:	87aa                	mv	a5,a0
    8020464a:	853e                	mv	a0,a5
    8020464c:	60e2                	ld	ra,24(sp)
    8020464e:	6442                	ld	s0,16(sp)
    80204650:	6105                	addi	sp,sp,32
    80204652:	8082                	ret

0000000080204654 <sys_gethid>:
    80204654:	1101                	addi	sp,sp,-32
    80204656:	ec06                	sd	ra,24(sp)
    80204658:	e822                	sd	s0,16(sp)
    8020465a:	1000                	addi	s0,sp,32
    8020465c:	fea43423          	sd	a0,-24(s0)
    80204660:	fe843783          	ld	a5,-24(s0)
    80204664:	e399                	bnez	a5,8020466a <sys_gethid+0x16>
    80204666:	57fd                	li	a5,-1
    80204668:	a811                	j	8020467c <sys_gethid+0x28>
    8020466a:	dadff0ef          	jal	80204416 <r_mhartid>
    8020466e:	87aa                	mv	a5,a0
    80204670:	0007871b          	sext.w	a4,a5
    80204674:	fe843783          	ld	a5,-24(s0)
    80204678:	c398                	sw	a4,0(a5)
    8020467a:	4781                	li	a5,0
    8020467c:	853e                	mv	a0,a5
    8020467e:	60e2                	ld	ra,24(sp)
    80204680:	6442                	ld	s0,16(sp)
    80204682:	6105                	addi	sp,sp,32
    80204684:	8082                	ret

0000000080204686 <do_syscall>:
    80204686:	7179                	addi	sp,sp,-48
    80204688:	f406                	sd	ra,40(sp)
    8020468a:	f022                	sd	s0,32(sp)
    8020468c:	1800                	addi	s0,sp,48
    8020468e:	fca43c23          	sd	a0,-40(s0)
    80204692:	fd843783          	ld	a5,-40(s0)
    80204696:	63dc                	ld	a5,128(a5)
    80204698:	fef42423          	sw	a5,-24(s0)
    8020469c:	fda00793          	li	a5,-38
    802046a0:	fef42623          	sw	a5,-20(s0)
    802046a4:	80cff0ef          	jal	802036b0 <proc_current_pid>
    802046a8:	87aa                	mv	a5,a0
    802046aa:	fef42223          	sw	a5,-28(s0)
    802046ae:	fe842783          	lw	a5,-24(s0)
    802046b2:	0007871b          	sext.w	a4,a5
    802046b6:	40100793          	li	a5,1025
    802046ba:	18f70e63          	beq	a4,a5,80204856 <do_syscall+0x1d0>
    802046be:	fe842783          	lw	a5,-24(s0)
    802046c2:	0007871b          	sext.w	a4,a5
    802046c6:	40100793          	li	a5,1025
    802046ca:	2ae7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    802046ce:	fe842783          	lw	a5,-24(s0)
    802046d2:	0007871b          	sext.w	a4,a5
    802046d6:	40000793          	li	a5,1024
    802046da:	14f70e63          	beq	a4,a5,80204836 <do_syscall+0x1b0>
    802046de:	fe842783          	lw	a5,-24(s0)
    802046e2:	0007871b          	sext.w	a4,a5
    802046e6:	40000793          	li	a5,1024
    802046ea:	28e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    802046ee:	fe842783          	lw	a5,-24(s0)
    802046f2:	0007871b          	sext.w	a4,a5
    802046f6:	3e900793          	li	a5,1001
    802046fa:	28f70163          	beq	a4,a5,8020497c <do_syscall+0x2f6>
    802046fe:	fe842783          	lw	a5,-24(s0)
    80204702:	0007871b          	sext.w	a4,a5
    80204706:	3e900793          	li	a5,1001
    8020470a:	26e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    8020470e:	fe842783          	lw	a5,-24(s0)
    80204712:	0007871b          	sext.w	a4,a5
    80204716:	3e800793          	li	a5,1000
    8020471a:	22f70663          	beq	a4,a5,80204946 <do_syscall+0x2c0>
    8020471e:	fe842783          	lw	a5,-24(s0)
    80204722:	0007871b          	sext.w	a4,a5
    80204726:	3e800793          	li	a5,1000
    8020472a:	24e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    8020472e:	fe842783          	lw	a5,-24(s0)
    80204732:	0007871b          	sext.w	a4,a5
    80204736:	10400793          	li	a5,260
    8020473a:	1af70063          	beq	a4,a5,802048da <do_syscall+0x254>
    8020473e:	fe842783          	lw	a5,-24(s0)
    80204742:	0007871b          	sext.w	a4,a5
    80204746:	10400793          	li	a5,260
    8020474a:	22e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    8020474e:	fe842783          	lw	a5,-24(s0)
    80204752:	0007871b          	sext.w	a4,a5
    80204756:	0dd00793          	li	a5,221
    8020475a:	1af70563          	beq	a4,a5,80204904 <do_syscall+0x27e>
    8020475e:	fe842783          	lw	a5,-24(s0)
    80204762:	0007871b          	sext.w	a4,a5
    80204766:	0dd00793          	li	a5,221
    8020476a:	20e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    8020476e:	fe842783          	lw	a5,-24(s0)
    80204772:	0007871b          	sext.w	a4,a5
    80204776:	0d600793          	li	a5,214
    8020477a:	14f70863          	beq	a4,a5,802048ca <do_syscall+0x244>
    8020477e:	fe842783          	lw	a5,-24(s0)
    80204782:	0007871b          	sext.w	a4,a5
    80204786:	0d600793          	li	a5,214
    8020478a:	1ee7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    8020478e:	fe842783          	lw	a5,-24(s0)
    80204792:	0007871b          	sext.w	a4,a5
    80204796:	0ac00793          	li	a5,172
    8020479a:	08f70463          	beq	a4,a5,80204822 <do_syscall+0x19c>
    8020479e:	fe842783          	lw	a5,-24(s0)
    802047a2:	0007871b          	sext.w	a4,a5
    802047a6:	0ac00793          	li	a5,172
    802047aa:	1ce7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    802047ae:	fe842783          	lw	a5,-24(s0)
    802047b2:	0007871b          	sext.w	a4,a5
    802047b6:	05d00793          	li	a5,93
    802047ba:	10f70563          	beq	a4,a5,802048c4 <do_syscall+0x23e>
    802047be:	fe842783          	lw	a5,-24(s0)
    802047c2:	0007871b          	sext.w	a4,a5
    802047c6:	05d00793          	li	a5,93
    802047ca:	1ae7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    802047ce:	fe842783          	lw	a5,-24(s0)
    802047d2:	0007871b          	sext.w	a4,a5
    802047d6:	04000793          	li	a5,64
    802047da:	08f70963          	beq	a4,a5,8020486c <do_syscall+0x1e6>
    802047de:	fe842783          	lw	a5,-24(s0)
    802047e2:	0007871b          	sext.w	a4,a5
    802047e6:	04000793          	li	a5,64
    802047ea:	18e7ee63          	bltu	a5,a4,80204986 <do_syscall+0x300>
    802047ee:	fe842783          	lw	a5,-24(s0)
    802047f2:	0007871b          	sext.w	a4,a5
    802047f6:	4785                	li	a5,1
    802047f8:	00f70b63          	beq	a4,a5,8020480e <do_syscall+0x188>
    802047fc:	fe842783          	lw	a5,-24(s0)
    80204800:	0007871b          	sext.w	a4,a5
    80204804:	03f00793          	li	a5,63
    80204808:	08f70863          	beq	a4,a5,80204898 <do_syscall+0x212>
    8020480c:	aaad                	j	80204986 <do_syscall+0x300>
    8020480e:	fd843783          	ld	a5,-40(s0)
    80204812:	67bc                	ld	a5,72(a5)
    80204814:	853e                	mv	a0,a5
    80204816:	e3fff0ef          	jal	80204654 <sys_gethid>
    8020481a:	87aa                	mv	a5,a0
    8020481c:	fef42623          	sw	a5,-20(s0)
    80204820:	a251                	j	802049a4 <do_syscall+0x31e>
    80204822:	fe442783          	lw	a5,-28(s0)
    80204826:	0007871b          	sext.w	a4,a5
    8020482a:	00e04363          	bgtz	a4,80204830 <do_syscall+0x1aa>
    8020482e:	4785                	li	a5,1
    80204830:	fef42623          	sw	a5,-20(s0)
    80204834:	aa85                	j	802049a4 <do_syscall+0x31e>
    80204836:	fd843783          	ld	a5,-40(s0)
    8020483a:	67bc                	ld	a5,72(a5)
    8020483c:	873e                	mv	a4,a5
    8020483e:	fd843783          	ld	a5,-40(s0)
    80204842:	6bbc                	ld	a5,80(a5)
    80204844:	2781                	sext.w	a5,a5
    80204846:	85be                	mv	a1,a5
    80204848:	853a                	mv	a0,a4
    8020484a:	be5ff0ef          	jal	8020442e <sys_open>
    8020484e:	87aa                	mv	a5,a0
    80204850:	fef42623          	sw	a5,-20(s0)
    80204854:	aa81                	j	802049a4 <do_syscall+0x31e>
    80204856:	fd843783          	ld	a5,-40(s0)
    8020485a:	67bc                	ld	a5,72(a5)
    8020485c:	2781                	sext.w	a5,a5
    8020485e:	853e                	mv	a0,a5
    80204860:	bfbff0ef          	jal	8020445a <sys_close>
    80204864:	87aa                	mv	a5,a0
    80204866:	fef42623          	sw	a5,-20(s0)
    8020486a:	aa2d                	j	802049a4 <do_syscall+0x31e>
    8020486c:	fd843783          	ld	a5,-40(s0)
    80204870:	67bc                	ld	a5,72(a5)
    80204872:	0007871b          	sext.w	a4,a5
    80204876:	fd843783          	ld	a5,-40(s0)
    8020487a:	6bbc                	ld	a5,80(a5)
    8020487c:	86be                	mv	a3,a5
    8020487e:	fd843783          	ld	a5,-40(s0)
    80204882:	6fbc                	ld	a5,88(a5)
    80204884:	2781                	sext.w	a5,a5
    80204886:	863e                	mv	a2,a5
    80204888:	85b6                	mv	a1,a3
    8020488a:	853a                	mv	a0,a4
    8020488c:	bf3ff0ef          	jal	8020447e <sys_write>
    80204890:	87aa                	mv	a5,a0
    80204892:	fef42623          	sw	a5,-20(s0)
    80204896:	a239                	j	802049a4 <do_syscall+0x31e>
    80204898:	fd843783          	ld	a5,-40(s0)
    8020489c:	67bc                	ld	a5,72(a5)
    8020489e:	0007871b          	sext.w	a4,a5
    802048a2:	fd843783          	ld	a5,-40(s0)
    802048a6:	6bbc                	ld	a5,80(a5)
    802048a8:	86be                	mv	a3,a5
    802048aa:	fd843783          	ld	a5,-40(s0)
    802048ae:	6fbc                	ld	a5,88(a5)
    802048b0:	2781                	sext.w	a5,a5
    802048b2:	863e                	mv	a2,a5
    802048b4:	85b6                	mv	a1,a3
    802048b6:	853a                	mv	a0,a4
    802048b8:	c6dff0ef          	jal	80204524 <sys_read>
    802048bc:	87aa                	mv	a5,a0
    802048be:	fef42623          	sw	a5,-20(s0)
    802048c2:	a0cd                	j	802049a4 <do_syscall+0x31e>
    802048c4:	fe042623          	sw	zero,-20(s0)
    802048c8:	a8f1                	j	802049a4 <do_syscall+0x31e>
    802048ca:	fd843503          	ld	a0,-40(s0)
    802048ce:	cbfff0ef          	jal	8020458c <sys_fork>
    802048d2:	87aa                	mv	a5,a0
    802048d4:	fef42623          	sw	a5,-20(s0)
    802048d8:	a0f1                	j	802049a4 <do_syscall+0x31e>
    802048da:	fe442783          	lw	a5,-28(s0)
    802048de:	0007871b          	sext.w	a4,a5
    802048e2:	00e04363          	bgtz	a4,802048e8 <do_syscall+0x262>
    802048e6:	4785                	li	a5,1
    802048e8:	0007871b          	sext.w	a4,a5
    802048ec:	fd843783          	ld	a5,-40(s0)
    802048f0:	67bc                	ld	a5,72(a5)
    802048f2:	2781                	sext.w	a5,a5
    802048f4:	85be                	mv	a1,a5
    802048f6:	853a                	mv	a0,a4
    802048f8:	d0dff0ef          	jal	80204604 <sys_waitpid>
    802048fc:	87aa                	mv	a5,a0
    802048fe:	fef42623          	sw	a5,-20(s0)
    80204902:	a04d                	j	802049a4 <do_syscall+0x31e>
    80204904:	fe442783          	lw	a5,-28(s0)
    80204908:	2781                	sext.w	a5,a5
    8020490a:	00f04763          	bgtz	a5,80204918 <do_syscall+0x292>
    8020490e:	fda00793          	li	a5,-38
    80204912:	fef42623          	sw	a5,-20(s0)
    80204916:	a079                	j	802049a4 <do_syscall+0x31e>
    80204918:	fd843783          	ld	a5,-40(s0)
    8020491c:	67bc                	ld	a5,72(a5)
    8020491e:	873e                	mv	a4,a5
    80204920:	fe442783          	lw	a5,-28(s0)
    80204924:	85ba                	mv	a1,a4
    80204926:	853e                	mv	a0,a5
    80204928:	f7dfe0ef          	jal	802038a4 <proc_load_elf>
    8020492c:	87aa                	mv	a5,a0
    8020492e:	fef42623          	sw	a5,-20(s0)
    80204932:	fec42783          	lw	a5,-20(s0)
    80204936:	2781                	sext.w	a5,a5
    80204938:	e7ad                	bnez	a5,802049a2 <do_syscall+0x31c>
    8020493a:	fe442783          	lw	a5,-28(s0)
    8020493e:	853e                	mv	a0,a5
    80204940:	b94ff0ef          	jal	80203cd4 <proc_user_run>
    80204944:	a8b9                	j	802049a2 <do_syscall+0x31c>
    80204946:	fd843783          	ld	a5,-40(s0)
    8020494a:	67bc                	ld	a5,72(a5)
    8020494c:	c78d                	beqz	a5,80204976 <do_syscall+0x2f0>
    8020494e:	fd843783          	ld	a5,-40(s0)
    80204952:	6bbc                	ld	a5,80(a5)
    80204954:	c38d                	beqz	a5,80204976 <do_syscall+0x2f0>
    80204956:	fd843783          	ld	a5,-40(s0)
    8020495a:	67bc                	ld	a5,72(a5)
    8020495c:	873e                	mv	a4,a5
    8020495e:	fd843783          	ld	a5,-40(s0)
    80204962:	6bbc                	ld	a5,80(a5)
    80204964:	86be                	mv	a3,a5
    80204966:	fd843783          	ld	a5,-40(s0)
    8020496a:	6fbc                	ld	a5,88(a5)
    8020496c:	863e                	mv	a2,a5
    8020496e:	85b6                	mv	a1,a3
    80204970:	853a                	mv	a0,a4
    80204972:	f0bfb0ef          	jal	8020087c <osviz_event>
    80204976:	fe042623          	sw	zero,-20(s0)
    8020497a:	a02d                	j	802049a4 <do_syscall+0x31e>
    8020497c:	fabfb0ef          	jal	80200926 <osviz_snapshot>
    80204980:	fe042623          	sw	zero,-20(s0)
    80204984:	a005                	j	802049a4 <do_syscall+0x31e>
    80204986:	fe842783          	lw	a5,-24(s0)
    8020498a:	85be                	mv	a1,a5
    8020498c:	00004517          	auipc	a0,0x4
    80204990:	aec50513          	addi	a0,a0,-1300 # 80208478 <user_code_end+0xaa8>
    80204994:	f22fc0ef          	jal	802010b6 <printf>
    80204998:	fda00793          	li	a5,-38
    8020499c:	fef42623          	sw	a5,-20(s0)
    802049a0:	a011                	j	802049a4 <do_syscall+0x31e>
    802049a2:	0001                	nop
    802049a4:	fe842783          	lw	a5,-24(s0)
    802049a8:	0007871b          	sext.w	a4,a5
    802049ac:	0d600793          	li	a5,214
    802049b0:	00f70763          	beq	a4,a5,802049be <do_syscall+0x338>
    802049b4:	fec42703          	lw	a4,-20(s0)
    802049b8:	fd843783          	ld	a5,-40(s0)
    802049bc:	e7b8                	sd	a4,72(a5)
    802049be:	0001                	nop
    802049c0:	70a2                	ld	ra,40(sp)
    802049c2:	7402                	ld	s0,32(sp)
    802049c4:	6145                	addi	sp,sp,48
    802049c6:	8082                	ret

00000000802049c8 <str_len>:
    802049c8:	7179                	addi	sp,sp,-48
    802049ca:	f406                	sd	ra,40(sp)
    802049cc:	f022                	sd	s0,32(sp)
    802049ce:	1800                	addi	s0,sp,48
    802049d0:	fca43c23          	sd	a0,-40(s0)
    802049d4:	fe042623          	sw	zero,-20(s0)
    802049d8:	a031                	j	802049e4 <str_len+0x1c>
    802049da:	fec42783          	lw	a5,-20(s0)
    802049de:	2785                	addiw	a5,a5,1
    802049e0:	fef42623          	sw	a5,-20(s0)
    802049e4:	fd843783          	ld	a5,-40(s0)
    802049e8:	cb89                	beqz	a5,802049fa <str_len+0x32>
    802049ea:	fec42783          	lw	a5,-20(s0)
    802049ee:	fd843703          	ld	a4,-40(s0)
    802049f2:	97ba                	add	a5,a5,a4
    802049f4:	0007c783          	lbu	a5,0(a5)
    802049f8:	f3ed                	bnez	a5,802049da <str_len+0x12>
    802049fa:	fec42783          	lw	a5,-20(s0)
    802049fe:	853e                	mv	a0,a5
    80204a00:	70a2                	ld	ra,40(sp)
    80204a02:	7402                	ld	s0,32(sp)
    80204a04:	6145                	addi	sp,sp,48
    80204a06:	8082                	ret

0000000080204a08 <str_eq>:
    80204a08:	1101                	addi	sp,sp,-32
    80204a0a:	ec06                	sd	ra,24(sp)
    80204a0c:	e822                	sd	s0,16(sp)
    80204a0e:	1000                	addi	s0,sp,32
    80204a10:	fea43423          	sd	a0,-24(s0)
    80204a14:	feb43023          	sd	a1,-32(s0)
    80204a18:	a03d                	j	80204a46 <str_eq+0x3e>
    80204a1a:	fe843783          	ld	a5,-24(s0)
    80204a1e:	0007c703          	lbu	a4,0(a5)
    80204a22:	fe043783          	ld	a5,-32(s0)
    80204a26:	0007c783          	lbu	a5,0(a5)
    80204a2a:	00f70463          	beq	a4,a5,80204a32 <str_eq+0x2a>
    80204a2e:	4781                	li	a5,0
    80204a30:	a0b1                	j	80204a7c <str_eq+0x74>
    80204a32:	fe843783          	ld	a5,-24(s0)
    80204a36:	0785                	addi	a5,a5,1
    80204a38:	fef43423          	sd	a5,-24(s0)
    80204a3c:	fe043783          	ld	a5,-32(s0)
    80204a40:	0785                	addi	a5,a5,1
    80204a42:	fef43023          	sd	a5,-32(s0)
    80204a46:	fe843783          	ld	a5,-24(s0)
    80204a4a:	0007c783          	lbu	a5,0(a5)
    80204a4e:	c791                	beqz	a5,80204a5a <str_eq+0x52>
    80204a50:	fe043783          	ld	a5,-32(s0)
    80204a54:	0007c783          	lbu	a5,0(a5)
    80204a58:	f3e9                	bnez	a5,80204a1a <str_eq+0x12>
    80204a5a:	fe843783          	ld	a5,-24(s0)
    80204a5e:	0007c703          	lbu	a4,0(a5)
    80204a62:	fe043783          	ld	a5,-32(s0)
    80204a66:	0007c783          	lbu	a5,0(a5)
    80204a6a:	2701                	sext.w	a4,a4
    80204a6c:	2781                	sext.w	a5,a5
    80204a6e:	40f707b3          	sub	a5,a4,a5
    80204a72:	0017b793          	seqz	a5,a5
    80204a76:	0ff7f793          	zext.b	a5,a5
    80204a7a:	2781                	sext.w	a5,a5
    80204a7c:	853e                	mv	a0,a5
    80204a7e:	60e2                	ld	ra,24(sp)
    80204a80:	6442                	ld	s0,16(sp)
    80204a82:	6105                	addi	sp,sp,32
    80204a84:	8082                	ret

0000000080204a86 <str_prefix>:
    80204a86:	1101                	addi	sp,sp,-32
    80204a88:	ec06                	sd	ra,24(sp)
    80204a8a:	e822                	sd	s0,16(sp)
    80204a8c:	1000                	addi	s0,sp,32
    80204a8e:	fea43423          	sd	a0,-24(s0)
    80204a92:	feb43023          	sd	a1,-32(s0)
    80204a96:	a03d                	j	80204ac4 <str_prefix+0x3e>
    80204a98:	fe843783          	ld	a5,-24(s0)
    80204a9c:	0007c703          	lbu	a4,0(a5)
    80204aa0:	fe043783          	ld	a5,-32(s0)
    80204aa4:	0007c783          	lbu	a5,0(a5)
    80204aa8:	00f70463          	beq	a4,a5,80204ab0 <str_prefix+0x2a>
    80204aac:	4781                	li	a5,0
    80204aae:	a00d                	j	80204ad0 <str_prefix+0x4a>
    80204ab0:	fe843783          	ld	a5,-24(s0)
    80204ab4:	0785                	addi	a5,a5,1
    80204ab6:	fef43423          	sd	a5,-24(s0)
    80204aba:	fe043783          	ld	a5,-32(s0)
    80204abe:	0785                	addi	a5,a5,1
    80204ac0:	fef43023          	sd	a5,-32(s0)
    80204ac4:	fe043783          	ld	a5,-32(s0)
    80204ac8:	0007c783          	lbu	a5,0(a5)
    80204acc:	f7f1                	bnez	a5,80204a98 <str_prefix+0x12>
    80204ace:	4785                	li	a5,1
    80204ad0:	853e                	mv	a0,a5
    80204ad2:	60e2                	ld	ra,24(sp)
    80204ad4:	6442                	ld	s0,16(sp)
    80204ad6:	6105                	addi	sp,sp,32
    80204ad8:	8082                	ret

0000000080204ada <path_copy>:
    80204ada:	7139                	addi	sp,sp,-64
    80204adc:	fc06                	sd	ra,56(sp)
    80204ade:	f822                	sd	s0,48(sp)
    80204ae0:	0080                	addi	s0,sp,64
    80204ae2:	fca43c23          	sd	a0,-40(s0)
    80204ae6:	87ae                	mv	a5,a1
    80204ae8:	fcc43423          	sd	a2,-56(s0)
    80204aec:	fcf42a23          	sw	a5,-44(s0)
    80204af0:	fe042623          	sw	zero,-20(s0)
    80204af4:	a025                	j	80204b1c <path_copy+0x42>
    80204af6:	fec42783          	lw	a5,-20(s0)
    80204afa:	fc843703          	ld	a4,-56(s0)
    80204afe:	973e                	add	a4,a4,a5
    80204b00:	fec42783          	lw	a5,-20(s0)
    80204b04:	fd843683          	ld	a3,-40(s0)
    80204b08:	97b6                	add	a5,a5,a3
    80204b0a:	00074703          	lbu	a4,0(a4)
    80204b0e:	00e78023          	sb	a4,0(a5)
    80204b12:	fec42783          	lw	a5,-20(s0)
    80204b16:	2785                	addiw	a5,a5,1
    80204b18:	fef42623          	sw	a5,-20(s0)
    80204b1c:	fc843783          	ld	a5,-56(s0)
    80204b20:	c395                	beqz	a5,80204b44 <path_copy+0x6a>
    80204b22:	fec42783          	lw	a5,-20(s0)
    80204b26:	fc843703          	ld	a4,-56(s0)
    80204b2a:	97ba                	add	a5,a5,a4
    80204b2c:	0007c783          	lbu	a5,0(a5)
    80204b30:	cb91                	beqz	a5,80204b44 <path_copy+0x6a>
    80204b32:	fd442783          	lw	a5,-44(s0)
    80204b36:	37fd                	addiw	a5,a5,-1
    80204b38:	2781                	sext.w	a5,a5
    80204b3a:	fec42703          	lw	a4,-20(s0)
    80204b3e:	2701                	sext.w	a4,a4
    80204b40:	faf74be3          	blt	a4,a5,80204af6 <path_copy+0x1c>
    80204b44:	fec42783          	lw	a5,-20(s0)
    80204b48:	fd843703          	ld	a4,-40(s0)
    80204b4c:	97ba                	add	a5,a5,a4
    80204b4e:	00078023          	sb	zero,0(a5)
    80204b52:	0001                	nop
    80204b54:	70e2                	ld	ra,56(sp)
    80204b56:	7442                	ld	s0,48(sp)
    80204b58:	6121                	addi	sp,sp,64
    80204b5a:	8082                	ret

0000000080204b5c <path_normalize>:
    80204b5c:	7171                	addi	sp,sp,-176
    80204b5e:	f506                	sd	ra,168(sp)
    80204b60:	f122                	sd	s0,160(sp)
    80204b62:	ed26                	sd	s1,152(sp)
    80204b64:	1900                	addi	s0,sp,176
    80204b66:	81010113          	addi	sp,sp,-2032
    80204b6a:	77fd                	lui	a5,0xfffff
    80204b6c:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204b6e:	97a2                	add	a5,a5,s0
    80204b70:	78a7bc23          	sd	a0,1944(a5)
    80204b74:	77fd                	lui	a5,0xfffff
    80204b76:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204b78:	97a2                	add	a5,a5,s0
    80204b7a:	78b7b823          	sd	a1,1936(a5)
    80204b7e:	8732                	mv	a4,a2
    80204b80:	77fd                	lui	a5,0xfffff
    80204b82:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204b84:	97a2                	add	a5,a5,s0
    80204b86:	78e7a623          	sw	a4,1932(a5)
    80204b8a:	fc042e23          	sw	zero,-36(s0)
    80204b8e:	fc042c23          	sw	zero,-40(s0)
    80204b92:	77fd                	lui	a5,0xfffff
    80204b94:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204b96:	97a2                	add	a5,a5,s0
    80204b98:	7987b783          	ld	a5,1944(a5)
    80204b9c:	cf99                	beqz	a5,80204bba <path_normalize+0x5e>
    80204b9e:	77fd                	lui	a5,0xfffff
    80204ba0:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204ba2:	97a2                	add	a5,a5,s0
    80204ba4:	7907b783          	ld	a5,1936(a5)
    80204ba8:	cb89                	beqz	a5,80204bba <path_normalize+0x5e>
    80204baa:	77fd                	lui	a5,0xfffff
    80204bac:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204bae:	97a2                	add	a5,a5,s0
    80204bb0:	78c7a783          	lw	a5,1932(a5)
    80204bb4:	2781                	sext.w	a5,a5
    80204bb6:	00f04463          	bgtz	a5,80204bbe <path_normalize+0x62>
    80204bba:	57fd                	li	a5,-1
    80204bbc:	ae35                	j	80204ef8 <path_normalize+0x39c>
    80204bbe:	77fd                	lui	a5,0xfffff
    80204bc0:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204bc2:	97a2                	add	a5,a5,s0
    80204bc4:	7987b783          	ld	a5,1944(a5)
    80204bc8:	0007c783          	lbu	a5,0(a5)
    80204bcc:	873e                	mv	a4,a5
    80204bce:	02f00793          	li	a5,47
    80204bd2:	00f71563          	bne	a4,a5,80204bdc <path_normalize+0x80>
    80204bd6:	4785                	li	a5,1
    80204bd8:	fcf42c23          	sw	a5,-40(s0)
    80204bdc:	77fd                	lui	a5,0xfffff
    80204bde:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204be0:	97a2                	add	a5,a5,s0
    80204be2:	7987b783          	ld	a5,1944(a5)
    80204be6:	fcf43423          	sd	a5,-56(s0)
    80204bea:	aa25                	j	80204d22 <path_normalize+0x1c6>
    80204bec:	fc042223          	sw	zero,-60(s0)
    80204bf0:	a031                	j	80204bfc <path_normalize+0xa0>
    80204bf2:	fc843783          	ld	a5,-56(s0)
    80204bf6:	0785                	addi	a5,a5,1
    80204bf8:	fcf43423          	sd	a5,-56(s0)
    80204bfc:	fc843783          	ld	a5,-56(s0)
    80204c00:	0007c783          	lbu	a5,0(a5)
    80204c04:	873e                	mv	a4,a5
    80204c06:	02f00793          	li	a5,47
    80204c0a:	fef704e3          	beq	a4,a5,80204bf2 <path_normalize+0x96>
    80204c0e:	fc843783          	ld	a5,-56(s0)
    80204c12:	0007c783          	lbu	a5,0(a5)
    80204c16:	10078d63          	beqz	a5,80204d30 <path_normalize+0x1d4>
    80204c1a:	a02d                	j	80204c44 <path_normalize+0xe8>
    80204c1c:	fc843703          	ld	a4,-56(s0)
    80204c20:	00170793          	addi	a5,a4,1
    80204c24:	fcf43423          	sd	a5,-56(s0)
    80204c28:	fc442783          	lw	a5,-60(s0)
    80204c2c:	0017869b          	addiw	a3,a5,1
    80204c30:	fcd42223          	sw	a3,-60(s0)
    80204c34:	00074703          	lbu	a4,0(a4)
    80204c38:	76fd                	lui	a3,0xfffff
    80204c3a:	1681                	addi	a3,a3,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204c3c:	96a2                	add	a3,a3,s0
    80204c3e:	97b6                	add	a5,a5,a3
    80204c40:	7ae78023          	sb	a4,1952(a5)
    80204c44:	fc843783          	ld	a5,-56(s0)
    80204c48:	0007c783          	lbu	a5,0(a5)
    80204c4c:	c395                	beqz	a5,80204c70 <path_normalize+0x114>
    80204c4e:	fc843783          	ld	a5,-56(s0)
    80204c52:	0007c783          	lbu	a5,0(a5)
    80204c56:	873e                	mv	a4,a5
    80204c58:	02f00793          	li	a5,47
    80204c5c:	00f70a63          	beq	a4,a5,80204c70 <path_normalize+0x114>
    80204c60:	fc442783          	lw	a5,-60(s0)
    80204c64:	0007871b          	sext.w	a4,a5
    80204c68:	03e00793          	li	a5,62
    80204c6c:	fae7d8e3          	bge	a5,a4,80204c1c <path_normalize+0xc0>
    80204c70:	77fd                	lui	a5,0xfffff
    80204c72:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204c74:	00878733          	add	a4,a5,s0
    80204c78:	fc442783          	lw	a5,-60(s0)
    80204c7c:	97ba                	add	a5,a5,a4
    80204c7e:	7a078023          	sb	zero,1952(a5)
    80204c82:	77fd                	lui	a5,0xfffff
    80204c84:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204c86:	97a2                	add	a5,a5,s0
    80204c88:	7a07c783          	lbu	a5,1952(a5)
    80204c8c:	cbc1                	beqz	a5,80204d1c <path_normalize+0x1c0>
    80204c8e:	77fd                	lui	a5,0xfffff
    80204c90:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    80204c94:	1781                	addi	a5,a5,-32
    80204c96:	97a2                	add	a5,a5,s0
    80204c98:	00003597          	auipc	a1,0x3
    80204c9c:	7f858593          	addi	a1,a1,2040 # 80208490 <user_code_end+0xac0>
    80204ca0:	853e                	mv	a0,a5
    80204ca2:	d67ff0ef          	jal	80204a08 <str_eq>
    80204ca6:	87aa                	mv	a5,a0
    80204ca8:	ebb5                	bnez	a5,80204d1c <path_normalize+0x1c0>
    80204caa:	77fd                	lui	a5,0xfffff
    80204cac:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    80204cb0:	1781                	addi	a5,a5,-32
    80204cb2:	97a2                	add	a5,a5,s0
    80204cb4:	00003597          	auipc	a1,0x3
    80204cb8:	7e458593          	addi	a1,a1,2020 # 80208498 <user_code_end+0xac8>
    80204cbc:	853e                	mv	a0,a5
    80204cbe:	d4bff0ef          	jal	80204a08 <str_eq>
    80204cc2:	87aa                	mv	a5,a0
    80204cc4:	cf81                	beqz	a5,80204cdc <path_normalize+0x180>
    80204cc6:	fdc42783          	lw	a5,-36(s0)
    80204cca:	2781                	sext.w	a5,a5
    80204ccc:	04f05a63          	blez	a5,80204d20 <path_normalize+0x1c4>
    80204cd0:	fdc42783          	lw	a5,-36(s0)
    80204cd4:	37fd                	addiw	a5,a5,-1
    80204cd6:	fcf42e23          	sw	a5,-36(s0)
    80204cda:	a099                	j	80204d20 <path_normalize+0x1c4>
    80204cdc:	fdc42783          	lw	a5,-36(s0)
    80204ce0:	0007871b          	sext.w	a4,a5
    80204ce4:	47fd                	li	a5,31
    80204ce6:	02e7ce63          	blt	a5,a4,80204d22 <path_normalize+0x1c6>
    80204cea:	fdc42783          	lw	a5,-36(s0)
    80204cee:	0017871b          	addiw	a4,a5,1
    80204cf2:	fce42e23          	sw	a4,-36(s0)
    80204cf6:	777d                	lui	a4,0xfffff
    80204cf8:	7e070713          	addi	a4,a4,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    80204cfc:	1701                	addi	a4,a4,-32
    80204cfe:	9722                	add	a4,a4,s0
    80204d00:	079a                	slli	a5,a5,0x6
    80204d02:	973e                	add	a4,a4,a5
    80204d04:	77fd                	lui	a5,0xfffff
    80204d06:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <_memory_end+0xffffffff77dff7a0>
    80204d0a:	1781                	addi	a5,a5,-32
    80204d0c:	97a2                	add	a5,a5,s0
    80204d0e:	863e                	mv	a2,a5
    80204d10:	04000593          	li	a1,64
    80204d14:	853a                	mv	a0,a4
    80204d16:	dc5ff0ef          	jal	80204ada <path_copy>
    80204d1a:	a021                	j	80204d22 <path_normalize+0x1c6>
    80204d1c:	0001                	nop
    80204d1e:	a011                	j	80204d22 <path_normalize+0x1c6>
    80204d20:	0001                	nop
    80204d22:	fc843783          	ld	a5,-56(s0)
    80204d26:	0007c783          	lbu	a5,0(a5)
    80204d2a:	ec0791e3          	bnez	a5,80204bec <path_normalize+0x90>
    80204d2e:	a011                	j	80204d32 <path_normalize+0x1d6>
    80204d30:	0001                	nop
    80204d32:	fd842783          	lw	a5,-40(s0)
    80204d36:	2781                	sext.w	a5,a5
    80204d38:	10078a63          	beqz	a5,80204e4c <path_normalize+0x2f0>
    80204d3c:	fdc42783          	lw	a5,-36(s0)
    80204d40:	2781                	sext.w	a5,a5
    80204d42:	e785                	bnez	a5,80204d6a <path_normalize+0x20e>
    80204d44:	77fd                	lui	a5,0xfffff
    80204d46:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204d48:	97a2                	add	a5,a5,s0
    80204d4a:	78c7a703          	lw	a4,1932(a5)
    80204d4e:	77fd                	lui	a5,0xfffff
    80204d50:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204d52:	97a2                	add	a5,a5,s0
    80204d54:	00003617          	auipc	a2,0x3
    80204d58:	74c60613          	addi	a2,a2,1868 # 802084a0 <user_code_end+0xad0>
    80204d5c:	85ba                	mv	a1,a4
    80204d5e:	7907b503          	ld	a0,1936(a5)
    80204d62:	d79ff0ef          	jal	80204ada <path_copy>
    80204d66:	4781                	li	a5,0
    80204d68:	aa41                	j	80204ef8 <path_normalize+0x39c>
    80204d6a:	77fd                	lui	a5,0xfffff
    80204d6c:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204d6e:	97a2                	add	a5,a5,s0
    80204d70:	7907b783          	ld	a5,1936(a5)
    80204d74:	00078023          	sb	zero,0(a5)
    80204d78:	fc042a23          	sw	zero,-44(s0)
    80204d7c:	a86d                	j	80204e36 <path_normalize+0x2da>
    80204d7e:	77fd                	lui	a5,0xfffff
    80204d80:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204d82:	97a2                	add	a5,a5,s0
    80204d84:	7907b783          	ld	a5,1936(a5)
    80204d88:	0007c783          	lbu	a5,0(a5)
    80204d8c:	ef8d                	bnez	a5,80204dc6 <path_normalize+0x26a>
    80204d8e:	77fd                	lui	a5,0xfffff
    80204d90:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204d92:	97a2                	add	a5,a5,s0
    80204d94:	78c7a583          	lw	a1,1932(a5)
    80204d98:	77fd                	lui	a5,0xfffff
    80204d9a:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    80204d9e:	1781                	addi	a5,a5,-32
    80204da0:	00878733          	add	a4,a5,s0
    80204da4:	fd442783          	lw	a5,-44(s0)
    80204da8:	079a                	slli	a5,a5,0x6
    80204daa:	973e                	add	a4,a4,a5
    80204dac:	77fd                	lui	a5,0xfffff
    80204dae:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204db0:	97a2                	add	a5,a5,s0
    80204db2:	86ba                	mv	a3,a4
    80204db4:	00003617          	auipc	a2,0x3
    80204db8:	6f460613          	addi	a2,a2,1780 # 802084a8 <user_code_end+0xad8>
    80204dbc:	7907b503          	ld	a0,1936(a5)
    80204dc0:	b4efc0ef          	jal	8020110e <snprintf>
    80204dc4:	a0a5                	j	80204e2c <path_normalize+0x2d0>
    80204dc6:	77fd                	lui	a5,0xfffff
    80204dc8:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204dca:	97a2                	add	a5,a5,s0
    80204dcc:	7907b503          	ld	a0,1936(a5)
    80204dd0:	bf9ff0ef          	jal	802049c8 <str_len>
    80204dd4:	87aa                	mv	a5,a0
    80204dd6:	873e                	mv	a4,a5
    80204dd8:	77fd                	lui	a5,0xfffff
    80204dda:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204ddc:	97a2                	add	a5,a5,s0
    80204dde:	7907b783          	ld	a5,1936(a5)
    80204de2:	00e784b3          	add	s1,a5,a4
    80204de6:	77fd                	lui	a5,0xfffff
    80204de8:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204dea:	97a2                	add	a5,a5,s0
    80204dec:	7907b503          	ld	a0,1936(a5)
    80204df0:	bd9ff0ef          	jal	802049c8 <str_len>
    80204df4:	87aa                	mv	a5,a0
    80204df6:	873e                	mv	a4,a5
    80204df8:	77fd                	lui	a5,0xfffff
    80204dfa:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204dfc:	97a2                	add	a5,a5,s0
    80204dfe:	78c7a783          	lw	a5,1932(a5)
    80204e02:	9f99                	subw	a5,a5,a4
    80204e04:	2781                	sext.w	a5,a5
    80204e06:	85be                	mv	a1,a5
    80204e08:	77fd                	lui	a5,0xfffff
    80204e0a:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    80204e0e:	1781                	addi	a5,a5,-32
    80204e10:	00878733          	add	a4,a5,s0
    80204e14:	fd442783          	lw	a5,-44(s0)
    80204e18:	079a                	slli	a5,a5,0x6
    80204e1a:	97ba                	add	a5,a5,a4
    80204e1c:	86be                	mv	a3,a5
    80204e1e:	00003617          	auipc	a2,0x3
    80204e22:	68a60613          	addi	a2,a2,1674 # 802084a8 <user_code_end+0xad8>
    80204e26:	8526                	mv	a0,s1
    80204e28:	ae6fc0ef          	jal	8020110e <snprintf>
    80204e2c:	fd442783          	lw	a5,-44(s0)
    80204e30:	2785                	addiw	a5,a5,1
    80204e32:	fcf42a23          	sw	a5,-44(s0)
    80204e36:	fd442783          	lw	a5,-44(s0)
    80204e3a:	873e                	mv	a4,a5
    80204e3c:	fdc42783          	lw	a5,-36(s0)
    80204e40:	2701                	sext.w	a4,a4
    80204e42:	2781                	sext.w	a5,a5
    80204e44:	f2f74de3          	blt	a4,a5,80204d7e <path_normalize+0x222>
    80204e48:	4781                	li	a5,0
    80204e4a:	a07d                	j	80204ef8 <path_normalize+0x39c>
    80204e4c:	77fd                	lui	a5,0xfffff
    80204e4e:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204e50:	97a2                	add	a5,a5,s0
    80204e52:	78c7a703          	lw	a4,1932(a5)
    80204e56:	77fd                	lui	a5,0xfffff
    80204e58:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204e5a:	97a2                	add	a5,a5,s0
    80204e5c:	0000a617          	auipc	a2,0xa
    80204e60:	1b460613          	addi	a2,a2,436 # 8020f010 <cwd>
    80204e64:	85ba                	mv	a1,a4
    80204e66:	7907b503          	ld	a0,1936(a5)
    80204e6a:	c71ff0ef          	jal	80204ada <path_copy>
    80204e6e:	fc042a23          	sw	zero,-44(s0)
    80204e72:	a88d                	j	80204ee4 <path_normalize+0x388>
    80204e74:	77fd                	lui	a5,0xfffff
    80204e76:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204e78:	97a2                	add	a5,a5,s0
    80204e7a:	7907b503          	ld	a0,1936(a5)
    80204e7e:	b4bff0ef          	jal	802049c8 <str_len>
    80204e82:	87aa                	mv	a5,a0
    80204e84:	873e                	mv	a4,a5
    80204e86:	77fd                	lui	a5,0xfffff
    80204e88:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204e8a:	97a2                	add	a5,a5,s0
    80204e8c:	7907b783          	ld	a5,1936(a5)
    80204e90:	00e784b3          	add	s1,a5,a4
    80204e94:	77fd                	lui	a5,0xfffff
    80204e96:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204e98:	97a2                	add	a5,a5,s0
    80204e9a:	7907b503          	ld	a0,1936(a5)
    80204e9e:	b2bff0ef          	jal	802049c8 <str_len>
    80204ea2:	87aa                	mv	a5,a0
    80204ea4:	873e                	mv	a4,a5
    80204ea6:	77fd                	lui	a5,0xfffff
    80204ea8:	1781                	addi	a5,a5,-32 # ffffffffffffefe0 <_memory_end+0xffffffff77dfefe0>
    80204eaa:	97a2                	add	a5,a5,s0
    80204eac:	78c7a783          	lw	a5,1932(a5)
    80204eb0:	9f99                	subw	a5,a5,a4
    80204eb2:	2781                	sext.w	a5,a5
    80204eb4:	85be                	mv	a1,a5
    80204eb6:	77fd                	lui	a5,0xfffff
    80204eb8:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <_memory_end+0xffffffff77dff7e0>
    80204ebc:	1781                	addi	a5,a5,-32
    80204ebe:	00878733          	add	a4,a5,s0
    80204ec2:	fd442783          	lw	a5,-44(s0)
    80204ec6:	079a                	slli	a5,a5,0x6
    80204ec8:	97ba                	add	a5,a5,a4
    80204eca:	86be                	mv	a3,a5
    80204ecc:	00003617          	auipc	a2,0x3
    80204ed0:	5dc60613          	addi	a2,a2,1500 # 802084a8 <user_code_end+0xad8>
    80204ed4:	8526                	mv	a0,s1
    80204ed6:	a38fc0ef          	jal	8020110e <snprintf>
    80204eda:	fd442783          	lw	a5,-44(s0)
    80204ede:	2785                	addiw	a5,a5,1
    80204ee0:	fcf42a23          	sw	a5,-44(s0)
    80204ee4:	fd442783          	lw	a5,-44(s0)
    80204ee8:	873e                	mv	a4,a5
    80204eea:	fdc42783          	lw	a5,-36(s0)
    80204eee:	2701                	sext.w	a4,a4
    80204ef0:	2781                	sext.w	a5,a5
    80204ef2:	f8f741e3          	blt	a4,a5,80204e74 <path_normalize+0x318>
    80204ef6:	4781                	li	a5,0
    80204ef8:	853e                	mv	a0,a5
    80204efa:	7f010113          	addi	sp,sp,2032
    80204efe:	70aa                	ld	ra,168(sp)
    80204f00:	740a                	ld	s0,160(sp)
    80204f02:	64ea                	ld	s1,152(sp)
    80204f04:	614d                	addi	sp,sp,176
    80204f06:	8082                	ret

0000000080204f08 <lookup_path>:
    80204f08:	7175                	addi	sp,sp,-144
    80204f0a:	e506                	sd	ra,136(sp)
    80204f0c:	e122                	sd	s0,128(sp)
    80204f0e:	0900                	addi	s0,sp,144
    80204f10:	f6a43c23          	sd	a0,-136(s0)
    80204f14:	f8840793          	addi	a5,s0,-120
    80204f18:	06000613          	li	a2,96
    80204f1c:	85be                	mv	a1,a5
    80204f1e:	f7843503          	ld	a0,-136(s0)
    80204f22:	c3bff0ef          	jal	80204b5c <path_normalize>
    80204f26:	87aa                	mv	a5,a0
    80204f28:	0007d463          	bgez	a5,80204f30 <lookup_path+0x28>
    80204f2c:	4781                	li	a5,0
    80204f2e:	a061                	j	80204fb6 <lookup_path+0xae>
    80204f30:	fe042623          	sw	zero,-20(s0)
    80204f34:	a885                	j	80204fa4 <lookup_path+0x9c>
    80204f36:	00013717          	auipc	a4,0x13
    80204f3a:	e0270713          	addi	a4,a4,-510 # 80217d38 <nodes>
    80204f3e:	fec42683          	lw	a3,-20(s0)
    80204f42:	6791                	lui	a5,0x4
    80204f44:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204f48:	02f687b3          	mul	a5,a3,a5
    80204f4c:	97ba                	add	a5,a5,a4
    80204f4e:	6711                	lui	a4,0x4
    80204f50:	97ba                	add	a5,a5,a4
    80204f52:	57fc                	lw	a5,108(a5)
    80204f54:	c3b1                	beqz	a5,80204f98 <lookup_path+0x90>
    80204f56:	fec42703          	lw	a4,-20(s0)
    80204f5a:	6791                	lui	a5,0x4
    80204f5c:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204f60:	02f70733          	mul	a4,a4,a5
    80204f64:	00013797          	auipc	a5,0x13
    80204f68:	dd478793          	addi	a5,a5,-556 # 80217d38 <nodes>
    80204f6c:	97ba                	add	a5,a5,a4
    80204f6e:	f8840713          	addi	a4,s0,-120
    80204f72:	85ba                	mv	a1,a4
    80204f74:	853e                	mv	a0,a5
    80204f76:	a93ff0ef          	jal	80204a08 <str_eq>
    80204f7a:	87aa                	mv	a5,a0
    80204f7c:	cf99                	beqz	a5,80204f9a <lookup_path+0x92>
    80204f7e:	fec42703          	lw	a4,-20(s0)
    80204f82:	6791                	lui	a5,0x4
    80204f84:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204f88:	02f70733          	mul	a4,a4,a5
    80204f8c:	00013797          	auipc	a5,0x13
    80204f90:	dac78793          	addi	a5,a5,-596 # 80217d38 <nodes>
    80204f94:	97ba                	add	a5,a5,a4
    80204f96:	a005                	j	80204fb6 <lookup_path+0xae>
    80204f98:	0001                	nop
    80204f9a:	fec42783          	lw	a5,-20(s0)
    80204f9e:	2785                	addiw	a5,a5,1
    80204fa0:	fef42623          	sw	a5,-20(s0)
    80204fa4:	fec42783          	lw	a5,-20(s0)
    80204fa8:	0007871b          	sext.w	a4,a5
    80204fac:	03f00793          	li	a5,63
    80204fb0:	f8e7d3e3          	bge	a5,a4,80204f36 <lookup_path+0x2e>
    80204fb4:	4781                	li	a5,0
    80204fb6:	853e                	mv	a0,a5
    80204fb8:	60aa                	ld	ra,136(sp)
    80204fba:	640a                	ld	s0,128(sp)
    80204fbc:	6149                	addi	sp,sp,144
    80204fbe:	8082                	ret

0000000080204fc0 <alloc_node>:
    80204fc0:	1101                	addi	sp,sp,-32
    80204fc2:	ec06                	sd	ra,24(sp)
    80204fc4:	e822                	sd	s0,16(sp)
    80204fc6:	1000                	addi	s0,sp,32
    80204fc8:	fe042623          	sw	zero,-20(s0)
    80204fcc:	a099                	j	80205012 <alloc_node+0x52>
    80204fce:	00013717          	auipc	a4,0x13
    80204fd2:	d6a70713          	addi	a4,a4,-662 # 80217d38 <nodes>
    80204fd6:	fec42683          	lw	a3,-20(s0)
    80204fda:	6791                	lui	a5,0x4
    80204fdc:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204fe0:	02f687b3          	mul	a5,a3,a5
    80204fe4:	97ba                	add	a5,a5,a4
    80204fe6:	6711                	lui	a4,0x4
    80204fe8:	97ba                	add	a5,a5,a4
    80204fea:	57fc                	lw	a5,108(a5)
    80204fec:	ef91                	bnez	a5,80205008 <alloc_node+0x48>
    80204fee:	fec42703          	lw	a4,-20(s0)
    80204ff2:	6791                	lui	a5,0x4
    80204ff4:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80204ff8:	02f70733          	mul	a4,a4,a5
    80204ffc:	00013797          	auipc	a5,0x13
    80205000:	d3c78793          	addi	a5,a5,-708 # 80217d38 <nodes>
    80205004:	97ba                	add	a5,a5,a4
    80205006:	a839                	j	80205024 <alloc_node+0x64>
    80205008:	fec42783          	lw	a5,-20(s0)
    8020500c:	2785                	addiw	a5,a5,1
    8020500e:	fef42623          	sw	a5,-20(s0)
    80205012:	fec42783          	lw	a5,-20(s0)
    80205016:	0007871b          	sext.w	a4,a5
    8020501a:	03f00793          	li	a5,63
    8020501e:	fae7d8e3          	bge	a5,a4,80204fce <alloc_node+0xe>
    80205022:	4781                	li	a5,0
    80205024:	853e                	mv	a0,a5
    80205026:	60e2                	ld	ra,24(sp)
    80205028:	6442                	ld	s0,16(sp)
    8020502a:	6105                	addi	sp,sp,32
    8020502c:	8082                	ret

000000008020502e <parent_path>:
    8020502e:	7139                	addi	sp,sp,-64
    80205030:	fc06                	sd	ra,56(sp)
    80205032:	f822                	sd	s0,48(sp)
    80205034:	0080                	addi	s0,sp,64
    80205036:	fca43c23          	sd	a0,-40(s0)
    8020503a:	fcb43823          	sd	a1,-48(s0)
    8020503e:	87b2                	mv	a5,a2
    80205040:	fcf42623          	sw	a5,-52(s0)
    80205044:	fd843503          	ld	a0,-40(s0)
    80205048:	981ff0ef          	jal	802049c8 <str_len>
    8020504c:	87aa                	mv	a5,a0
    8020504e:	fef42623          	sw	a5,-20(s0)
    80205052:	a031                	j	8020505e <parent_path+0x30>
    80205054:	fec42783          	lw	a5,-20(s0)
    80205058:	37fd                	addiw	a5,a5,-1
    8020505a:	fef42623          	sw	a5,-20(s0)
    8020505e:	fec42783          	lw	a5,-20(s0)
    80205062:	2781                	sext.w	a5,a5
    80205064:	02f05563          	blez	a5,8020508e <parent_path+0x60>
    80205068:	fec42783          	lw	a5,-20(s0)
    8020506c:	17fd                	addi	a5,a5,-1
    8020506e:	fd843703          	ld	a4,-40(s0)
    80205072:	97ba                	add	a5,a5,a4
    80205074:	0007c783          	lbu	a5,0(a5)
    80205078:	873e                	mv	a4,a5
    8020507a:	02f00793          	li	a5,47
    8020507e:	fcf70be3          	beq	a4,a5,80205054 <parent_path+0x26>
    80205082:	a031                	j	8020508e <parent_path+0x60>
    80205084:	fec42783          	lw	a5,-20(s0)
    80205088:	37fd                	addiw	a5,a5,-1
    8020508a:	fef42623          	sw	a5,-20(s0)
    8020508e:	fec42783          	lw	a5,-20(s0)
    80205092:	2781                	sext.w	a5,a5
    80205094:	00f05f63          	blez	a5,802050b2 <parent_path+0x84>
    80205098:	fec42783          	lw	a5,-20(s0)
    8020509c:	17fd                	addi	a5,a5,-1
    8020509e:	fd843703          	ld	a4,-40(s0)
    802050a2:	97ba                	add	a5,a5,a4
    802050a4:	0007c783          	lbu	a5,0(a5)
    802050a8:	873e                	mv	a4,a5
    802050aa:	02f00793          	li	a5,47
    802050ae:	fcf71be3          	bne	a4,a5,80205084 <parent_path+0x56>
    802050b2:	fec42783          	lw	a5,-20(s0)
    802050b6:	2781                	sext.w	a5,a5
    802050b8:	00f04f63          	bgtz	a5,802050d6 <parent_path+0xa8>
    802050bc:	fcc42783          	lw	a5,-52(s0)
    802050c0:	00003617          	auipc	a2,0x3
    802050c4:	3e060613          	addi	a2,a2,992 # 802084a0 <user_code_end+0xad0>
    802050c8:	85be                	mv	a1,a5
    802050ca:	fd043503          	ld	a0,-48(s0)
    802050ce:	a0dff0ef          	jal	80204ada <path_copy>
    802050d2:	4781                	li	a5,0
    802050d4:	a861                	j	8020516c <parent_path+0x13e>
    802050d6:	fec42783          	lw	a5,-20(s0)
    802050da:	0007871b          	sext.w	a4,a5
    802050de:	4785                	li	a5,1
    802050e0:	00f71f63          	bne	a4,a5,802050fe <parent_path+0xd0>
    802050e4:	fcc42783          	lw	a5,-52(s0)
    802050e8:	00003617          	auipc	a2,0x3
    802050ec:	3b860613          	addi	a2,a2,952 # 802084a0 <user_code_end+0xad0>
    802050f0:	85be                	mv	a1,a5
    802050f2:	fd043503          	ld	a0,-48(s0)
    802050f6:	9e5ff0ef          	jal	80204ada <path_copy>
    802050fa:	4781                	li	a5,0
    802050fc:	a885                	j	8020516c <parent_path+0x13e>
    802050fe:	fec42783          	lw	a5,-20(s0)
    80205102:	37fd                	addiw	a5,a5,-1
    80205104:	fef42423          	sw	a5,-24(s0)
    80205108:	fe842783          	lw	a5,-24(s0)
    8020510c:	873e                	mv	a4,a5
    8020510e:	fcc42783          	lw	a5,-52(s0)
    80205112:	2701                	sext.w	a4,a4
    80205114:	2781                	sext.w	a5,a5
    80205116:	00f74463          	blt	a4,a5,8020511e <parent_path+0xf0>
    8020511a:	57fd                	li	a5,-1
    8020511c:	a881                	j	8020516c <parent_path+0x13e>
    8020511e:	fe042623          	sw	zero,-20(s0)
    80205122:	a025                	j	8020514a <parent_path+0x11c>
    80205124:	fec42783          	lw	a5,-20(s0)
    80205128:	fd843703          	ld	a4,-40(s0)
    8020512c:	973e                	add	a4,a4,a5
    8020512e:	fec42783          	lw	a5,-20(s0)
    80205132:	fd043683          	ld	a3,-48(s0)
    80205136:	97b6                	add	a5,a5,a3
    80205138:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    8020513c:	00e78023          	sb	a4,0(a5)
    80205140:	fec42783          	lw	a5,-20(s0)
    80205144:	2785                	addiw	a5,a5,1
    80205146:	fef42623          	sw	a5,-20(s0)
    8020514a:	fec42783          	lw	a5,-20(s0)
    8020514e:	873e                	mv	a4,a5
    80205150:	fe842783          	lw	a5,-24(s0)
    80205154:	2701                	sext.w	a4,a4
    80205156:	2781                	sext.w	a5,a5
    80205158:	fcf746e3          	blt	a4,a5,80205124 <parent_path+0xf6>
    8020515c:	fe842783          	lw	a5,-24(s0)
    80205160:	fd043703          	ld	a4,-48(s0)
    80205164:	97ba                	add	a5,a5,a4
    80205166:	00078023          	sb	zero,0(a5)
    8020516a:	4781                	li	a5,0
    8020516c:	853e                	mv	a0,a5
    8020516e:	70e2                	ld	ra,56(sp)
    80205170:	7442                	ld	s0,48(sp)
    80205172:	6121                	addi	sp,sp,64
    80205174:	8082                	ret

0000000080205176 <fs_mkdir>:
    80205176:	7151                	addi	sp,sp,-240
    80205178:	f586                	sd	ra,232(sp)
    8020517a:	f1a2                	sd	s0,224(sp)
    8020517c:	1980                	addi	s0,sp,240
    8020517e:	f0a43c23          	sd	a0,-232(s0)
    80205182:	f8040793          	addi	a5,s0,-128
    80205186:	06000613          	li	a2,96
    8020518a:	85be                	mv	a1,a5
    8020518c:	f1843503          	ld	a0,-232(s0)
    80205190:	9cdff0ef          	jal	80204b5c <path_normalize>
    80205194:	87aa                	mv	a5,a0
    80205196:	0007d463          	bgez	a5,8020519e <fs_mkdir+0x28>
    8020519a:	57fd                	li	a5,-1
    8020519c:	a23d                	j	802052ca <fs_mkdir+0x154>
    8020519e:	f8040793          	addi	a5,s0,-128
    802051a2:	853e                	mv	a0,a5
    802051a4:	d65ff0ef          	jal	80204f08 <lookup_path>
    802051a8:	87aa                	mv	a5,a0
    802051aa:	c399                	beqz	a5,802051b0 <fs_mkdir+0x3a>
    802051ac:	4781                	li	a5,0
    802051ae:	aa31                	j	802052ca <fs_mkdir+0x154>
    802051b0:	f8040793          	addi	a5,s0,-128
    802051b4:	00003597          	auipc	a1,0x3
    802051b8:	2ec58593          	addi	a1,a1,748 # 802084a0 <user_code_end+0xad0>
    802051bc:	853e                	mv	a0,a5
    802051be:	84bff0ef          	jal	80204a08 <str_eq>
    802051c2:	87aa                	mv	a5,a0
    802051c4:	c7ad                	beqz	a5,8020522e <fs_mkdir+0xb8>
    802051c6:	dfbff0ef          	jal	80204fc0 <alloc_node>
    802051ca:	fea43023          	sd	a0,-32(s0)
    802051ce:	fe043783          	ld	a5,-32(s0)
    802051d2:	e399                	bnez	a5,802051d8 <fs_mkdir+0x62>
    802051d4:	57fd                	li	a5,-1
    802051d6:	a8d5                	j	802052ca <fs_mkdir+0x154>
    802051d8:	fe043783          	ld	a5,-32(s0)
    802051dc:	00003617          	auipc	a2,0x3
    802051e0:	2c460613          	addi	a2,a2,708 # 802084a0 <user_code_end+0xad0>
    802051e4:	06000593          	li	a1,96
    802051e8:	853e                	mv	a0,a5
    802051ea:	8f1ff0ef          	jal	80204ada <path_copy>
    802051ee:	fe043703          	ld	a4,-32(s0)
    802051f2:	6791                	lui	a5,0x4
    802051f4:	97ba                	add	a5,a5,a4
    802051f6:	4705                	li	a4,1
    802051f8:	d3f8                	sw	a4,100(a5)
    802051fa:	fe043703          	ld	a4,-32(s0)
    802051fe:	6791                	lui	a5,0x4
    80205200:	97ba                	add	a5,a5,a4
    80205202:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80205206:	fe043703          	ld	a4,-32(s0)
    8020520a:	6791                	lui	a5,0x4
    8020520c:	97ba                	add	a5,a5,a4
    8020520e:	0607a423          	sw	zero,104(a5) # 4068 <STACK_SIZE+0x3068>
    80205212:	fe043703          	ld	a4,-32(s0)
    80205216:	6791                	lui	a5,0x4
    80205218:	97ba                	add	a5,a5,a4
    8020521a:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    8020521e:	fe043703          	ld	a4,-32(s0)
    80205222:	6791                	lui	a5,0x4
    80205224:	97ba                	add	a5,a5,a4
    80205226:	4705                	li	a4,1
    80205228:	d7f8                	sw	a4,108(a5)
    8020522a:	4781                	li	a5,0
    8020522c:	a879                	j	802052ca <fs_mkdir+0x154>
    8020522e:	f2040713          	addi	a4,s0,-224
    80205232:	f8040793          	addi	a5,s0,-128
    80205236:	06000613          	li	a2,96
    8020523a:	85ba                	mv	a1,a4
    8020523c:	853e                	mv	a0,a5
    8020523e:	df1ff0ef          	jal	8020502e <parent_path>
    80205242:	f2040793          	addi	a5,s0,-224
    80205246:	853e                	mv	a0,a5
    80205248:	cc1ff0ef          	jal	80204f08 <lookup_path>
    8020524c:	fea43423          	sd	a0,-24(s0)
    80205250:	fe843783          	ld	a5,-24(s0)
    80205254:	c799                	beqz	a5,80205262 <fs_mkdir+0xec>
    80205256:	fe843703          	ld	a4,-24(s0)
    8020525a:	6791                	lui	a5,0x4
    8020525c:	97ba                	add	a5,a5,a4
    8020525e:	53fc                	lw	a5,100(a5)
    80205260:	e399                	bnez	a5,80205266 <fs_mkdir+0xf0>
    80205262:	57fd                	li	a5,-1
    80205264:	a09d                	j	802052ca <fs_mkdir+0x154>
    80205266:	d5bff0ef          	jal	80204fc0 <alloc_node>
    8020526a:	fea43023          	sd	a0,-32(s0)
    8020526e:	fe043783          	ld	a5,-32(s0)
    80205272:	e399                	bnez	a5,80205278 <fs_mkdir+0x102>
    80205274:	57fd                	li	a5,-1
    80205276:	a891                	j	802052ca <fs_mkdir+0x154>
    80205278:	fe043783          	ld	a5,-32(s0)
    8020527c:	f8040713          	addi	a4,s0,-128
    80205280:	863a                	mv	a2,a4
    80205282:	06000593          	li	a1,96
    80205286:	853e                	mv	a0,a5
    80205288:	853ff0ef          	jal	80204ada <path_copy>
    8020528c:	fe043703          	ld	a4,-32(s0)
    80205290:	6791                	lui	a5,0x4
    80205292:	97ba                	add	a5,a5,a4
    80205294:	4705                	li	a4,1
    80205296:	d3f8                	sw	a4,100(a5)
    80205298:	fe043703          	ld	a4,-32(s0)
    8020529c:	6791                	lui	a5,0x4
    8020529e:	97ba                	add	a5,a5,a4
    802052a0:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802052a4:	fe043703          	ld	a4,-32(s0)
    802052a8:	6791                	lui	a5,0x4
    802052aa:	97ba                	add	a5,a5,a4
    802052ac:	0607a423          	sw	zero,104(a5) # 4068 <STACK_SIZE+0x3068>
    802052b0:	fe043703          	ld	a4,-32(s0)
    802052b4:	6791                	lui	a5,0x4
    802052b6:	97ba                	add	a5,a5,a4
    802052b8:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    802052bc:	fe043703          	ld	a4,-32(s0)
    802052c0:	6791                	lui	a5,0x4
    802052c2:	97ba                	add	a5,a5,a4
    802052c4:	4705                	li	a4,1
    802052c6:	d7f8                	sw	a4,108(a5)
    802052c8:	4781                	li	a5,0
    802052ca:	853e                	mv	a0,a5
    802052cc:	70ae                	ld	ra,232(sp)
    802052ce:	740e                	ld	s0,224(sp)
    802052d0:	616d                	addi	sp,sp,240
    802052d2:	8082                	ret

00000000802052d4 <fs_create>:
    802052d4:	7151                	addi	sp,sp,-240
    802052d6:	f586                	sd	ra,232(sp)
    802052d8:	f1a2                	sd	s0,224(sp)
    802052da:	1980                	addi	s0,sp,240
    802052dc:	f0a43c23          	sd	a0,-232(s0)
    802052e0:	87ae                	mv	a5,a1
    802052e2:	f0f42a23          	sw	a5,-236(s0)
    802052e6:	f8040793          	addi	a5,s0,-128
    802052ea:	06000613          	li	a2,96
    802052ee:	85be                	mv	a1,a5
    802052f0:	f1843503          	ld	a0,-232(s0)
    802052f4:	869ff0ef          	jal	80204b5c <path_normalize>
    802052f8:	87aa                	mv	a5,a0
    802052fa:	0007d463          	bgez	a5,80205302 <fs_create+0x2e>
    802052fe:	57fd                	li	a5,-1
    80205300:	a0dd                	j	802053e6 <fs_create+0x112>
    80205302:	f8040793          	addi	a5,s0,-128
    80205306:	853e                	mv	a0,a5
    80205308:	c01ff0ef          	jal	80204f08 <lookup_path>
    8020530c:	87aa                	mv	a5,a0
    8020530e:	cb8d                	beqz	a5,80205340 <fs_create+0x6c>
    80205310:	f8040793          	addi	a5,s0,-128
    80205314:	853e                	mv	a0,a5
    80205316:	bf3ff0ef          	jal	80204f08 <lookup_path>
    8020531a:	fea43023          	sd	a0,-32(s0)
    8020531e:	fe043703          	ld	a4,-32(s0)
    80205322:	6791                	lui	a5,0x4
    80205324:	97ba                	add	a5,a5,a4
    80205326:	53fc                	lw	a5,100(a5)
    80205328:	c399                	beqz	a5,8020532e <fs_create+0x5a>
    8020532a:	57fd                	li	a5,-1
    8020532c:	a86d                	j	802053e6 <fs_create+0x112>
    8020532e:	fe043703          	ld	a4,-32(s0)
    80205332:	6791                	lui	a5,0x4
    80205334:	97ba                	add	a5,a5,a4
    80205336:	f1442703          	lw	a4,-236(s0)
    8020533a:	d7b8                	sw	a4,104(a5)
    8020533c:	4781                	li	a5,0
    8020533e:	a065                	j	802053e6 <fs_create+0x112>
    80205340:	f2040713          	addi	a4,s0,-224
    80205344:	f8040793          	addi	a5,s0,-128
    80205348:	06000613          	li	a2,96
    8020534c:	85ba                	mv	a1,a4
    8020534e:	853e                	mv	a0,a5
    80205350:	cdfff0ef          	jal	8020502e <parent_path>
    80205354:	f2040793          	addi	a5,s0,-224
    80205358:	853e                	mv	a0,a5
    8020535a:	bafff0ef          	jal	80204f08 <lookup_path>
    8020535e:	fea43423          	sd	a0,-24(s0)
    80205362:	fe843783          	ld	a5,-24(s0)
    80205366:	c799                	beqz	a5,80205374 <fs_create+0xa0>
    80205368:	fe843703          	ld	a4,-24(s0)
    8020536c:	6791                	lui	a5,0x4
    8020536e:	97ba                	add	a5,a5,a4
    80205370:	53fc                	lw	a5,100(a5)
    80205372:	e399                	bnez	a5,80205378 <fs_create+0xa4>
    80205374:	57fd                	li	a5,-1
    80205376:	a885                	j	802053e6 <fs_create+0x112>
    80205378:	c49ff0ef          	jal	80204fc0 <alloc_node>
    8020537c:	fea43023          	sd	a0,-32(s0)
    80205380:	fe043783          	ld	a5,-32(s0)
    80205384:	e399                	bnez	a5,8020538a <fs_create+0xb6>
    80205386:	57fd                	li	a5,-1
    80205388:	a8b9                	j	802053e6 <fs_create+0x112>
    8020538a:	fe043783          	ld	a5,-32(s0)
    8020538e:	f8040713          	addi	a4,s0,-128
    80205392:	863a                	mv	a2,a4
    80205394:	06000593          	li	a1,96
    80205398:	853e                	mv	a0,a5
    8020539a:	f40ff0ef          	jal	80204ada <path_copy>
    8020539e:	fe043703          	ld	a4,-32(s0)
    802053a2:	6791                	lui	a5,0x4
    802053a4:	97ba                	add	a5,a5,a4
    802053a6:	0607a223          	sw	zero,100(a5) # 4064 <STACK_SIZE+0x3064>
    802053aa:	fe043703          	ld	a4,-32(s0)
    802053ae:	6791                	lui	a5,0x4
    802053b0:	97ba                	add	a5,a5,a4
    802053b2:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802053b6:	fe043783          	ld	a5,-32(s0)
    802053ba:	06078023          	sb	zero,96(a5)
    802053be:	fe043703          	ld	a4,-32(s0)
    802053c2:	6791                	lui	a5,0x4
    802053c4:	97ba                	add	a5,a5,a4
    802053c6:	f1442703          	lw	a4,-236(s0)
    802053ca:	d7b8                	sw	a4,104(a5)
    802053cc:	fe043703          	ld	a4,-32(s0)
    802053d0:	6791                	lui	a5,0x4
    802053d2:	97ba                	add	a5,a5,a4
    802053d4:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    802053d8:	fe043703          	ld	a4,-32(s0)
    802053dc:	6791                	lui	a5,0x4
    802053de:	97ba                	add	a5,a5,a4
    802053e0:	4705                	li	a4,1
    802053e2:	d7f8                	sw	a4,108(a5)
    802053e4:	4781                	li	a5,0
    802053e6:	853e                	mv	a0,a5
    802053e8:	70ae                	ld	ra,232(sp)
    802053ea:	740e                	ld	s0,224(sp)
    802053ec:	616d                	addi	sp,sp,240
    802053ee:	8082                	ret

00000000802053f0 <fs_unlink>:
    802053f0:	7175                	addi	sp,sp,-144
    802053f2:	e506                	sd	ra,136(sp)
    802053f4:	e122                	sd	s0,128(sp)
    802053f6:	0900                	addi	s0,sp,144
    802053f8:	f6a43c23          	sd	a0,-136(s0)
    802053fc:	f8840793          	addi	a5,s0,-120
    80205400:	06000613          	li	a2,96
    80205404:	85be                	mv	a1,a5
    80205406:	f7843503          	ld	a0,-136(s0)
    8020540a:	f52ff0ef          	jal	80204b5c <path_normalize>
    8020540e:	87aa                	mv	a5,a0
    80205410:	0007d463          	bgez	a5,80205418 <fs_unlink+0x28>
    80205414:	57fd                	li	a5,-1
    80205416:	a815                	j	8020544a <fs_unlink+0x5a>
    80205418:	f8840793          	addi	a5,s0,-120
    8020541c:	853e                	mv	a0,a5
    8020541e:	aebff0ef          	jal	80204f08 <lookup_path>
    80205422:	fea43423          	sd	a0,-24(s0)
    80205426:	fe843783          	ld	a5,-24(s0)
    8020542a:	c799                	beqz	a5,80205438 <fs_unlink+0x48>
    8020542c:	fe843703          	ld	a4,-24(s0)
    80205430:	6791                	lui	a5,0x4
    80205432:	97ba                	add	a5,a5,a4
    80205434:	53fc                	lw	a5,100(a5)
    80205436:	c399                	beqz	a5,8020543c <fs_unlink+0x4c>
    80205438:	57fd                	li	a5,-1
    8020543a:	a801                	j	8020544a <fs_unlink+0x5a>
    8020543c:	fe843703          	ld	a4,-24(s0)
    80205440:	6791                	lui	a5,0x4
    80205442:	97ba                	add	a5,a5,a4
    80205444:	0607a623          	sw	zero,108(a5) # 406c <STACK_SIZE+0x306c>
    80205448:	4781                	li	a5,0
    8020544a:	853e                	mv	a0,a5
    8020544c:	60aa                	ld	ra,136(sp)
    8020544e:	640a                	ld	s0,128(sp)
    80205450:	6149                	addi	sp,sp,144
    80205452:	8082                	ret

0000000080205454 <fs_exists>:
    80205454:	1101                	addi	sp,sp,-32
    80205456:	ec06                	sd	ra,24(sp)
    80205458:	e822                	sd	s0,16(sp)
    8020545a:	1000                	addi	s0,sp,32
    8020545c:	fea43423          	sd	a0,-24(s0)
    80205460:	fe843503          	ld	a0,-24(s0)
    80205464:	aa5ff0ef          	jal	80204f08 <lookup_path>
    80205468:	87aa                	mv	a5,a0
    8020546a:	00f037b3          	snez	a5,a5
    8020546e:	0ff7f793          	zext.b	a5,a5
    80205472:	2781                	sext.w	a5,a5
    80205474:	853e                	mv	a0,a5
    80205476:	60e2                	ld	ra,24(sp)
    80205478:	6442                	ld	s0,16(sp)
    8020547a:	6105                	addi	sp,sp,32
    8020547c:	8082                	ret

000000008020547e <fs_is_dir>:
    8020547e:	7179                	addi	sp,sp,-48
    80205480:	f406                	sd	ra,40(sp)
    80205482:	f022                	sd	s0,32(sp)
    80205484:	1800                	addi	s0,sp,48
    80205486:	fca43c23          	sd	a0,-40(s0)
    8020548a:	fd843503          	ld	a0,-40(s0)
    8020548e:	a7bff0ef          	jal	80204f08 <lookup_path>
    80205492:	fea43423          	sd	a0,-24(s0)
    80205496:	fe843783          	ld	a5,-24(s0)
    8020549a:	cb89                	beqz	a5,802054ac <fs_is_dir+0x2e>
    8020549c:	fe843703          	ld	a4,-24(s0)
    802054a0:	6791                	lui	a5,0x4
    802054a2:	97ba                	add	a5,a5,a4
    802054a4:	53fc                	lw	a5,100(a5)
    802054a6:	c399                	beqz	a5,802054ac <fs_is_dir+0x2e>
    802054a8:	4785                	li	a5,1
    802054aa:	a011                	j	802054ae <fs_is_dir+0x30>
    802054ac:	4781                	li	a5,0
    802054ae:	853e                	mv	a0,a5
    802054b0:	70a2                	ld	ra,40(sp)
    802054b2:	7402                	ld	s0,32(sp)
    802054b4:	6145                	addi	sp,sp,48
    802054b6:	8082                	ret

00000000802054b8 <fs_is_executable>:
    802054b8:	7179                	addi	sp,sp,-48
    802054ba:	f406                	sd	ra,40(sp)
    802054bc:	f022                	sd	s0,32(sp)
    802054be:	1800                	addi	s0,sp,48
    802054c0:	fca43c23          	sd	a0,-40(s0)
    802054c4:	fd843503          	ld	a0,-40(s0)
    802054c8:	a41ff0ef          	jal	80204f08 <lookup_path>
    802054cc:	fea43423          	sd	a0,-24(s0)
    802054d0:	fe843783          	ld	a5,-24(s0)
    802054d4:	cf99                	beqz	a5,802054f2 <fs_is_executable+0x3a>
    802054d6:	fe843703          	ld	a4,-24(s0)
    802054da:	6791                	lui	a5,0x4
    802054dc:	97ba                	add	a5,a5,a4
    802054de:	53fc                	lw	a5,100(a5)
    802054e0:	eb89                	bnez	a5,802054f2 <fs_is_executable+0x3a>
    802054e2:	fe843703          	ld	a4,-24(s0)
    802054e6:	6791                	lui	a5,0x4
    802054e8:	97ba                	add	a5,a5,a4
    802054ea:	57bc                	lw	a5,104(a5)
    802054ec:	c399                	beqz	a5,802054f2 <fs_is_executable+0x3a>
    802054ee:	4785                	li	a5,1
    802054f0:	a011                	j	802054f4 <fs_is_executable+0x3c>
    802054f2:	4781                	li	a5,0
    802054f4:	853e                	mv	a0,a5
    802054f6:	70a2                	ld	ra,40(sp)
    802054f8:	7402                	ld	s0,32(sp)
    802054fa:	6145                	addi	sp,sp,48
    802054fc:	8082                	ret

00000000802054fe <fs_getcwd>:
    802054fe:	1141                	addi	sp,sp,-16
    80205500:	e406                	sd	ra,8(sp)
    80205502:	e022                	sd	s0,0(sp)
    80205504:	0800                	addi	s0,sp,16
    80205506:	0000a797          	auipc	a5,0xa
    8020550a:	b0a78793          	addi	a5,a5,-1270 # 8020f010 <cwd>
    8020550e:	853e                	mv	a0,a5
    80205510:	60a2                	ld	ra,8(sp)
    80205512:	6402                	ld	s0,0(sp)
    80205514:	0141                	addi	sp,sp,16
    80205516:	8082                	ret

0000000080205518 <fs_chdir>:
    80205518:	7175                	addi	sp,sp,-144
    8020551a:	e506                	sd	ra,136(sp)
    8020551c:	e122                	sd	s0,128(sp)
    8020551e:	0900                	addi	s0,sp,144
    80205520:	f6a43c23          	sd	a0,-136(s0)
    80205524:	f8840793          	addi	a5,s0,-120
    80205528:	06000613          	li	a2,96
    8020552c:	85be                	mv	a1,a5
    8020552e:	f7843503          	ld	a0,-136(s0)
    80205532:	e2aff0ef          	jal	80204b5c <path_normalize>
    80205536:	87aa                	mv	a5,a0
    80205538:	0007d463          	bgez	a5,80205540 <fs_chdir+0x28>
    8020553c:	57fd                	li	a5,-1
    8020553e:	a83d                	j	8020557c <fs_chdir+0x64>
    80205540:	f8840793          	addi	a5,s0,-120
    80205544:	853e                	mv	a0,a5
    80205546:	9c3ff0ef          	jal	80204f08 <lookup_path>
    8020554a:	fea43423          	sd	a0,-24(s0)
    8020554e:	fe843783          	ld	a5,-24(s0)
    80205552:	c799                	beqz	a5,80205560 <fs_chdir+0x48>
    80205554:	fe843703          	ld	a4,-24(s0)
    80205558:	6791                	lui	a5,0x4
    8020555a:	97ba                	add	a5,a5,a4
    8020555c:	53fc                	lw	a5,100(a5)
    8020555e:	e399                	bnez	a5,80205564 <fs_chdir+0x4c>
    80205560:	57fd                	li	a5,-1
    80205562:	a829                	j	8020557c <fs_chdir+0x64>
    80205564:	f8840793          	addi	a5,s0,-120
    80205568:	863e                	mv	a2,a5
    8020556a:	06000593          	li	a1,96
    8020556e:	0000a517          	auipc	a0,0xa
    80205572:	aa250513          	addi	a0,a0,-1374 # 8020f010 <cwd>
    80205576:	d64ff0ef          	jal	80204ada <path_copy>
    8020557a:	4781                	li	a5,0
    8020557c:	853e                	mv	a0,a5
    8020557e:	60aa                	ld	ra,136(sp)
    80205580:	640a                	ld	s0,128(sp)
    80205582:	6149                	addi	sp,sp,144
    80205584:	8082                	ret

0000000080205586 <fs_listdir>:
    80205586:	714d                	addi	sp,sp,-336
    80205588:	e686                	sd	ra,328(sp)
    8020558a:	e2a2                	sd	s0,320(sp)
    8020558c:	fe26                	sd	s1,312(sp)
    8020558e:	0a80                	addi	s0,sp,336
    80205590:	eaa43c23          	sd	a0,-328(s0)
    80205594:	eab43823          	sd	a1,-336(s0)
    80205598:	fc042c23          	sw	zero,-40(s0)
    8020559c:	f6840793          	addi	a5,s0,-152
    802055a0:	06000613          	li	a2,96
    802055a4:	85be                	mv	a1,a5
    802055a6:	eb843503          	ld	a0,-328(s0)
    802055aa:	db2ff0ef          	jal	80204b5c <path_normalize>
    802055ae:	87aa                	mv	a5,a0
    802055b0:	0007d463          	bgez	a5,802055b8 <fs_listdir+0x32>
    802055b4:	57fd                	li	a5,-1
    802055b6:	aca5                	j	8020582e <fs_listdir+0x2a8>
    802055b8:	f6840793          	addi	a5,s0,-152
    802055bc:	853e                	mv	a0,a5
    802055be:	94bff0ef          	jal	80204f08 <lookup_path>
    802055c2:	87aa                	mv	a5,a0
    802055c4:	cb81                	beqz	a5,802055d4 <fs_listdir+0x4e>
    802055c6:	f6840793          	addi	a5,s0,-152
    802055ca:	853e                	mv	a0,a5
    802055cc:	eb3ff0ef          	jal	8020547e <fs_is_dir>
    802055d0:	87aa                	mv	a5,a0
    802055d2:	e399                	bnez	a5,802055d8 <fs_listdir+0x52>
    802055d4:	57fd                	li	a5,-1
    802055d6:	aca1                	j	8020582e <fs_listdir+0x2a8>
    802055d8:	f6840713          	addi	a4,s0,-152
    802055dc:	f0840793          	addi	a5,s0,-248
    802055e0:	86ba                	mv	a3,a4
    802055e2:	00003617          	auipc	a2,0x3
    802055e6:	ece60613          	addi	a2,a2,-306 # 802084b0 <user_code_end+0xae0>
    802055ea:	06000593          	li	a1,96
    802055ee:	853e                	mv	a0,a5
    802055f0:	b1ffb0ef          	jal	8020110e <snprintf>
    802055f4:	f6840793          	addi	a5,s0,-152
    802055f8:	00003597          	auipc	a1,0x3
    802055fc:	ea858593          	addi	a1,a1,-344 # 802084a0 <user_code_end+0xad0>
    80205600:	853e                	mv	a0,a5
    80205602:	c06ff0ef          	jal	80204a08 <str_eq>
    80205606:	87aa                	mv	a5,a0
    80205608:	cf81                	beqz	a5,80205620 <fs_listdir+0x9a>
    8020560a:	f0840793          	addi	a5,s0,-248
    8020560e:	00003617          	auipc	a2,0x3
    80205612:	e9260613          	addi	a2,a2,-366 # 802084a0 <user_code_end+0xad0>
    80205616:	06000593          	li	a1,96
    8020561a:	853e                	mv	a0,a5
    8020561c:	cbeff0ef          	jal	80204ada <path_copy>
    80205620:	fc042e23          	sw	zero,-36(s0)
    80205624:	aadd                	j	8020581a <fs_listdir+0x294>
    80205626:	00012717          	auipc	a4,0x12
    8020562a:	71270713          	addi	a4,a4,1810 # 80217d38 <nodes>
    8020562e:	fdc42683          	lw	a3,-36(s0)
    80205632:	6791                	lui	a5,0x4
    80205634:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205638:	02f687b3          	mul	a5,a3,a5
    8020563c:	97ba                	add	a5,a5,a4
    8020563e:	6711                	lui	a4,0x4
    80205640:	97ba                	add	a5,a5,a4
    80205642:	57fc                	lw	a5,108(a5)
    80205644:	1a078d63          	beqz	a5,802057fe <fs_listdir+0x278>
    80205648:	fdc42703          	lw	a4,-36(s0)
    8020564c:	6791                	lui	a5,0x4
    8020564e:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205652:	02f70733          	mul	a4,a4,a5
    80205656:	00012797          	auipc	a5,0x12
    8020565a:	6e278793          	addi	a5,a5,1762 # 80217d38 <nodes>
    8020565e:	97ba                	add	a5,a5,a4
    80205660:	f6840713          	addi	a4,s0,-152
    80205664:	85ba                	mv	a1,a4
    80205666:	853e                	mv	a0,a5
    80205668:	ba0ff0ef          	jal	80204a08 <str_eq>
    8020566c:	87aa                	mv	a5,a0
    8020566e:	18079a63          	bnez	a5,80205802 <fs_listdir+0x27c>
    80205672:	f6840793          	addi	a5,s0,-152
    80205676:	00003597          	auipc	a1,0x3
    8020567a:	e2a58593          	addi	a1,a1,-470 # 802084a0 <user_code_end+0xad0>
    8020567e:	853e                	mv	a0,a5
    80205680:	b88ff0ef          	jal	80204a08 <str_eq>
    80205684:	87aa                	mv	a5,a0
    80205686:	efa9                	bnez	a5,802056e0 <fs_listdir+0x15a>
    80205688:	fdc42703          	lw	a4,-36(s0)
    8020568c:	6791                	lui	a5,0x4
    8020568e:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205692:	02f70733          	mul	a4,a4,a5
    80205696:	00012797          	auipc	a5,0x12
    8020569a:	6a278793          	addi	a5,a5,1698 # 80217d38 <nodes>
    8020569e:	97ba                	add	a5,a5,a4
    802056a0:	f0840713          	addi	a4,s0,-248
    802056a4:	85ba                	mv	a1,a4
    802056a6:	853e                	mv	a0,a5
    802056a8:	bdeff0ef          	jal	80204a86 <str_prefix>
    802056ac:	87aa                	mv	a5,a0
    802056ae:	14078c63          	beqz	a5,80205806 <fs_listdir+0x280>
    802056b2:	fdc42703          	lw	a4,-36(s0)
    802056b6:	6791                	lui	a5,0x4
    802056b8:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802056bc:	02f70733          	mul	a4,a4,a5
    802056c0:	00012797          	auipc	a5,0x12
    802056c4:	67878793          	addi	a5,a5,1656 # 80217d38 <nodes>
    802056c8:	00f704b3          	add	s1,a4,a5
    802056cc:	f0840793          	addi	a5,s0,-248
    802056d0:	853e                	mv	a0,a5
    802056d2:	af6ff0ef          	jal	802049c8 <str_len>
    802056d6:	87aa                	mv	a5,a0
    802056d8:	97a6                	add	a5,a5,s1
    802056da:	fcf43823          	sd	a5,-48(s0)
    802056de:	a099                	j	80205724 <fs_listdir+0x19e>
    802056e0:	00012717          	auipc	a4,0x12
    802056e4:	65870713          	addi	a4,a4,1624 # 80217d38 <nodes>
    802056e8:	fdc42683          	lw	a3,-36(s0)
    802056ec:	6791                	lui	a5,0x4
    802056ee:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802056f2:	02f687b3          	mul	a5,a3,a5
    802056f6:	97ba                	add	a5,a5,a4
    802056f8:	0007c783          	lbu	a5,0(a5)
    802056fc:	873e                	mv	a4,a5
    802056fe:	02f00793          	li	a5,47
    80205702:	10f71463          	bne	a4,a5,8020580a <fs_listdir+0x284>
    80205706:	fdc42703          	lw	a4,-36(s0)
    8020570a:	6791                	lui	a5,0x4
    8020570c:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205710:	02f70733          	mul	a4,a4,a5
    80205714:	00012797          	auipc	a5,0x12
    80205718:	62478793          	addi	a5,a5,1572 # 80217d38 <nodes>
    8020571c:	97ba                	add	a5,a5,a4
    8020571e:	0785                	addi	a5,a5,1
    80205720:	fcf43823          	sd	a5,-48(s0)
    80205724:	fc042423          	sw	zero,-56(s0)
    80205728:	fc042623          	sw	zero,-52(s0)
    8020572c:	a03d                	j	8020575a <fs_listdir+0x1d4>
    8020572e:	fcc42783          	lw	a5,-52(s0)
    80205732:	fd043703          	ld	a4,-48(s0)
    80205736:	97ba                	add	a5,a5,a4
    80205738:	0007c783          	lbu	a5,0(a5)
    8020573c:	873e                	mv	a4,a5
    8020573e:	02f00793          	li	a5,47
    80205742:	00f71763          	bne	a4,a5,80205750 <fs_listdir+0x1ca>
    80205746:	fc842783          	lw	a5,-56(s0)
    8020574a:	2785                	addiw	a5,a5,1
    8020574c:	fcf42423          	sw	a5,-56(s0)
    80205750:	fcc42783          	lw	a5,-52(s0)
    80205754:	2785                	addiw	a5,a5,1
    80205756:	fcf42623          	sw	a5,-52(s0)
    8020575a:	fcc42783          	lw	a5,-52(s0)
    8020575e:	fd043703          	ld	a4,-48(s0)
    80205762:	97ba                	add	a5,a5,a4
    80205764:	0007c783          	lbu	a5,0(a5)
    80205768:	f3f9                	bnez	a5,8020572e <fs_listdir+0x1a8>
    8020576a:	fc842783          	lw	a5,-56(s0)
    8020576e:	2781                	sext.w	a5,a5
    80205770:	08f04f63          	bgtz	a5,8020580e <fs_listdir+0x288>
    80205774:	ec840793          	addi	a5,s0,-312
    80205778:	fd043603          	ld	a2,-48(s0)
    8020577c:	04000593          	li	a1,64
    80205780:	853e                	mv	a0,a5
    80205782:	b58ff0ef          	jal	80204ada <path_copy>
    80205786:	eb043783          	ld	a5,-336(s0)
    8020578a:	c7a5                	beqz	a5,802057f2 <fs_listdir+0x26c>
    8020578c:	00012717          	auipc	a4,0x12
    80205790:	5ac70713          	addi	a4,a4,1452 # 80217d38 <nodes>
    80205794:	fdc42683          	lw	a3,-36(s0)
    80205798:	6791                	lui	a5,0x4
    8020579a:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020579e:	02f687b3          	mul	a5,a3,a5
    802057a2:	97ba                	add	a5,a5,a4
    802057a4:	6711                	lui	a4,0x4
    802057a6:	97ba                	add	a5,a5,a4
    802057a8:	53ac                	lw	a1,96(a5)
    802057aa:	00012717          	auipc	a4,0x12
    802057ae:	58e70713          	addi	a4,a4,1422 # 80217d38 <nodes>
    802057b2:	fdc42683          	lw	a3,-36(s0)
    802057b6:	6791                	lui	a5,0x4
    802057b8:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802057bc:	02f687b3          	mul	a5,a3,a5
    802057c0:	97ba                	add	a5,a5,a4
    802057c2:	6711                	lui	a4,0x4
    802057c4:	97ba                	add	a5,a5,a4
    802057c6:	53f0                	lw	a2,100(a5)
    802057c8:	00012717          	auipc	a4,0x12
    802057cc:	57070713          	addi	a4,a4,1392 # 80217d38 <nodes>
    802057d0:	fdc42683          	lw	a3,-36(s0)
    802057d4:	6791                	lui	a5,0x4
    802057d6:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    802057da:	02f687b3          	mul	a5,a3,a5
    802057de:	97ba                	add	a5,a5,a4
    802057e0:	6711                	lui	a4,0x4
    802057e2:	97ba                	add	a5,a5,a4
    802057e4:	57b4                	lw	a3,104(a5)
    802057e6:	ec840713          	addi	a4,s0,-312
    802057ea:	eb043783          	ld	a5,-336(s0)
    802057ee:	853a                	mv	a0,a4
    802057f0:	9782                	jalr	a5
    802057f2:	fd842783          	lw	a5,-40(s0)
    802057f6:	2785                	addiw	a5,a5,1
    802057f8:	fcf42c23          	sw	a5,-40(s0)
    802057fc:	a811                	j	80205810 <fs_listdir+0x28a>
    802057fe:	0001                	nop
    80205800:	a801                	j	80205810 <fs_listdir+0x28a>
    80205802:	0001                	nop
    80205804:	a031                	j	80205810 <fs_listdir+0x28a>
    80205806:	0001                	nop
    80205808:	a021                	j	80205810 <fs_listdir+0x28a>
    8020580a:	0001                	nop
    8020580c:	a011                	j	80205810 <fs_listdir+0x28a>
    8020580e:	0001                	nop
    80205810:	fdc42783          	lw	a5,-36(s0)
    80205814:	2785                	addiw	a5,a5,1
    80205816:	fcf42e23          	sw	a5,-36(s0)
    8020581a:	fdc42783          	lw	a5,-36(s0)
    8020581e:	0007871b          	sext.w	a4,a5
    80205822:	03f00793          	li	a5,63
    80205826:	e0e7d0e3          	bge	a5,a4,80205626 <fs_listdir+0xa0>
    8020582a:	fd842783          	lw	a5,-40(s0)
    8020582e:	853e                	mv	a0,a5
    80205830:	60b6                	ld	ra,328(sp)
    80205832:	6416                	ld	s0,320(sp)
    80205834:	74f2                	ld	s1,312(sp)
    80205836:	6171                	addi	sp,sp,336
    80205838:	8082                	ret

000000008020583a <fs_open>:
    8020583a:	7175                	addi	sp,sp,-144
    8020583c:	e506                	sd	ra,136(sp)
    8020583e:	e122                	sd	s0,128(sp)
    80205840:	0900                	addi	s0,sp,144
    80205842:	f6a43c23          	sd	a0,-136(s0)
    80205846:	87ae                	mv	a5,a1
    80205848:	f6f42a23          	sw	a5,-140(s0)
    8020584c:	f8840793          	addi	a5,s0,-120
    80205850:	06000613          	li	a2,96
    80205854:	85be                	mv	a1,a5
    80205856:	f7843503          	ld	a0,-136(s0)
    8020585a:	b02ff0ef          	jal	80204b5c <path_normalize>
    8020585e:	87aa                	mv	a5,a0
    80205860:	0007d463          	bgez	a5,80205868 <fs_open+0x2e>
    80205864:	57fd                	li	a5,-1
    80205866:	a0c9                	j	80205928 <fs_open+0xee>
    80205868:	f8840793          	addi	a5,s0,-120
    8020586c:	853e                	mv	a0,a5
    8020586e:	e9aff0ef          	jal	80204f08 <lookup_path>
    80205872:	fea43423          	sd	a0,-24(s0)
    80205876:	fe843783          	ld	a5,-24(s0)
    8020587a:	eb95                	bnez	a5,802058ae <fs_open+0x74>
    8020587c:	f7442783          	lw	a5,-140(s0)
    80205880:	8b91                	andi	a5,a5,4
    80205882:	2781                	sext.w	a5,a5
    80205884:	c39d                	beqz	a5,802058aa <fs_open+0x70>
    80205886:	4581                	li	a1,0
    80205888:	f7843503          	ld	a0,-136(s0)
    8020588c:	a49ff0ef          	jal	802052d4 <fs_create>
    80205890:	87aa                	mv	a5,a0
    80205892:	0007d463          	bgez	a5,8020589a <fs_open+0x60>
    80205896:	57fd                	li	a5,-1
    80205898:	a841                	j	80205928 <fs_open+0xee>
    8020589a:	f8840793          	addi	a5,s0,-120
    8020589e:	853e                	mv	a0,a5
    802058a0:	e68ff0ef          	jal	80204f08 <lookup_path>
    802058a4:	fea43423          	sd	a0,-24(s0)
    802058a8:	a019                	j	802058ae <fs_open+0x74>
    802058aa:	57fd                	li	a5,-1
    802058ac:	a8b5                	j	80205928 <fs_open+0xee>
    802058ae:	fe843703          	ld	a4,-24(s0)
    802058b2:	6791                	lui	a5,0x4
    802058b4:	97ba                	add	a5,a5,a4
    802058b6:	53fc                	lw	a5,100(a5)
    802058b8:	c399                	beqz	a5,802058be <fs_open+0x84>
    802058ba:	57fd                	li	a5,-1
    802058bc:	a0b5                	j	80205928 <fs_open+0xee>
    802058be:	f7442783          	lw	a5,-140(s0)
    802058c2:	8ba1                	andi	a5,a5,8
    802058c4:	2781                	sext.w	a5,a5
    802058c6:	c799                	beqz	a5,802058d4 <fs_open+0x9a>
    802058c8:	fe843703          	ld	a4,-24(s0)
    802058cc:	6791                	lui	a5,0x4
    802058ce:	97ba                	add	a5,a5,a4
    802058d0:	0607a023          	sw	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    802058d4:	f7442783          	lw	a5,-140(s0)
    802058d8:	8bc1                	andi	a5,a5,16
    802058da:	2781                	sext.w	a5,a5
    802058dc:	cf81                	beqz	a5,802058f4 <fs_open+0xba>
    802058de:	fe843703          	ld	a4,-24(s0)
    802058e2:	6791                	lui	a5,0x4
    802058e4:	97ba                	add	a5,a5,a4
    802058e6:	53b8                	lw	a4,96(a5)
    802058e8:	fe843683          	ld	a3,-24(s0)
    802058ec:	6791                	lui	a5,0x4
    802058ee:	97b6                	add	a5,a5,a3
    802058f0:	dbb8                	sw	a4,112(a5)
    802058f2:	a039                	j	80205900 <fs_open+0xc6>
    802058f4:	fe843703          	ld	a4,-24(s0)
    802058f8:	6791                	lui	a5,0x4
    802058fa:	97ba                	add	a5,a5,a4
    802058fc:	0607a823          	sw	zero,112(a5) # 4070 <STACK_SIZE+0x3070>
    80205900:	fe843703          	ld	a4,-24(s0)
    80205904:	00012797          	auipc	a5,0x12
    80205908:	43478793          	addi	a5,a5,1076 # 80217d38 <nodes>
    8020590c:	40f707b3          	sub	a5,a4,a5
    80205910:	4027d713          	srai	a4,a5,0x2
    80205914:	00003797          	auipc	a5,0x3
    80205918:	bbc78793          	addi	a5,a5,-1092 # 802084d0 <user_code_end+0xb00>
    8020591c:	639c                	ld	a5,0(a5)
    8020591e:	02f707b3          	mul	a5,a4,a5
    80205922:	2781                	sext.w	a5,a5
    80205924:	278d                	addiw	a5,a5,3
    80205926:	2781                	sext.w	a5,a5
    80205928:	853e                	mv	a0,a5
    8020592a:	60aa                	ld	ra,136(sp)
    8020592c:	640a                	ld	s0,128(sp)
    8020592e:	6149                	addi	sp,sp,144
    80205930:	8082                	ret

0000000080205932 <fs_size>:
    80205932:	7179                	addi	sp,sp,-48
    80205934:	f406                	sd	ra,40(sp)
    80205936:	f022                	sd	s0,32(sp)
    80205938:	1800                	addi	s0,sp,48
    8020593a:	87aa                	mv	a5,a0
    8020593c:	fcf42e23          	sw	a5,-36(s0)
    80205940:	fdc42783          	lw	a5,-36(s0)
    80205944:	37f5                	addiw	a5,a5,-3
    80205946:	fef42623          	sw	a5,-20(s0)
    8020594a:	fdc42783          	lw	a5,-36(s0)
    8020594e:	0007871b          	sext.w	a4,a5
    80205952:	4789                	li	a5,2
    80205954:	02e7da63          	bge	a5,a4,80205988 <fs_size+0x56>
    80205958:	fec42783          	lw	a5,-20(s0)
    8020595c:	0007871b          	sext.w	a4,a5
    80205960:	03f00793          	li	a5,63
    80205964:	02e7c263          	blt	a5,a4,80205988 <fs_size+0x56>
    80205968:	00012717          	auipc	a4,0x12
    8020596c:	3d070713          	addi	a4,a4,976 # 80217d38 <nodes>
    80205970:	fec42683          	lw	a3,-20(s0)
    80205974:	6791                	lui	a5,0x4
    80205976:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020597a:	02f687b3          	mul	a5,a3,a5
    8020597e:	97ba                	add	a5,a5,a4
    80205980:	6711                	lui	a4,0x4
    80205982:	97ba                	add	a5,a5,a4
    80205984:	57fc                	lw	a5,108(a5)
    80205986:	e399                	bnez	a5,8020598c <fs_size+0x5a>
    80205988:	57fd                	li	a5,-1
    8020598a:	a005                	j	802059aa <fs_size+0x78>
    8020598c:	00012717          	auipc	a4,0x12
    80205990:	3ac70713          	addi	a4,a4,940 # 80217d38 <nodes>
    80205994:	fec42683          	lw	a3,-20(s0)
    80205998:	6791                	lui	a5,0x4
    8020599a:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    8020599e:	02f687b3          	mul	a5,a3,a5
    802059a2:	97ba                	add	a5,a5,a4
    802059a4:	6711                	lui	a4,0x4
    802059a6:	97ba                	add	a5,a5,a4
    802059a8:	53bc                	lw	a5,96(a5)
    802059aa:	853e                	mv	a0,a5
    802059ac:	70a2                	ld	ra,40(sp)
    802059ae:	7402                	ld	s0,32(sp)
    802059b0:	6145                	addi	sp,sp,48
    802059b2:	8082                	ret

00000000802059b4 <fs_read>:
    802059b4:	7179                	addi	sp,sp,-48
    802059b6:	f406                	sd	ra,40(sp)
    802059b8:	f022                	sd	s0,32(sp)
    802059ba:	1800                	addi	s0,sp,48
    802059bc:	87aa                	mv	a5,a0
    802059be:	fcb43823          	sd	a1,-48(s0)
    802059c2:	8732                	mv	a4,a2
    802059c4:	fcf42e23          	sw	a5,-36(s0)
    802059c8:	87ba                	mv	a5,a4
    802059ca:	fcf42c23          	sw	a5,-40(s0)
    802059ce:	fdc42783          	lw	a5,-36(s0)
    802059d2:	37f5                	addiw	a5,a5,-3
    802059d4:	fef42423          	sw	a5,-24(s0)
    802059d8:	fe042623          	sw	zero,-20(s0)
    802059dc:	fd043783          	ld	a5,-48(s0)
    802059e0:	c7a9                	beqz	a5,80205a2a <fs_read+0x76>
    802059e2:	fd842783          	lw	a5,-40(s0)
    802059e6:	2781                	sext.w	a5,a5
    802059e8:	04f05163          	blez	a5,80205a2a <fs_read+0x76>
    802059ec:	fdc42783          	lw	a5,-36(s0)
    802059f0:	0007871b          	sext.w	a4,a5
    802059f4:	4789                	li	a5,2
    802059f6:	02e7da63          	bge	a5,a4,80205a2a <fs_read+0x76>
    802059fa:	fe842783          	lw	a5,-24(s0)
    802059fe:	0007871b          	sext.w	a4,a5
    80205a02:	03f00793          	li	a5,63
    80205a06:	02e7c263          	blt	a5,a4,80205a2a <fs_read+0x76>
    80205a0a:	00012717          	auipc	a4,0x12
    80205a0e:	32e70713          	addi	a4,a4,814 # 80217d38 <nodes>
    80205a12:	fe842683          	lw	a3,-24(s0)
    80205a16:	6791                	lui	a5,0x4
    80205a18:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205a1c:	02f687b3          	mul	a5,a3,a5
    80205a20:	97ba                	add	a5,a5,a4
    80205a22:	6711                	lui	a4,0x4
    80205a24:	97ba                	add	a5,a5,a4
    80205a26:	57fc                	lw	a5,108(a5)
    80205a28:	e399                	bnez	a5,80205a2e <fs_read+0x7a>
    80205a2a:	57fd                	li	a5,-1
    80205a2c:	a869                	j	80205ac6 <fs_read+0x112>
    80205a2e:	fe842703          	lw	a4,-24(s0)
    80205a32:	6791                	lui	a5,0x4
    80205a34:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205a38:	02f70733          	mul	a4,a4,a5
    80205a3c:	00012797          	auipc	a5,0x12
    80205a40:	2fc78793          	addi	a5,a5,764 # 80217d38 <nodes>
    80205a44:	97ba                	add	a5,a5,a4
    80205a46:	fef43023          	sd	a5,-32(s0)
    80205a4a:	fe043703          	ld	a4,-32(s0)
    80205a4e:	6791                	lui	a5,0x4
    80205a50:	97ba                	add	a5,a5,a4
    80205a52:	53fc                	lw	a5,100(a5)
    80205a54:	c3b1                	beqz	a5,80205a98 <fs_read+0xe4>
    80205a56:	57fd                	li	a5,-1
    80205a58:	a0bd                	j	80205ac6 <fs_read+0x112>
    80205a5a:	fe043703          	ld	a4,-32(s0)
    80205a5e:	6791                	lui	a5,0x4
    80205a60:	97ba                	add	a5,a5,a4
    80205a62:	5bbc                	lw	a5,112(a5)
    80205a64:	0017871b          	addiw	a4,a5,1 # 4001 <STACK_SIZE+0x3001>
    80205a68:	0007069b          	sext.w	a3,a4
    80205a6c:	fe043603          	ld	a2,-32(s0)
    80205a70:	6711                	lui	a4,0x4
    80205a72:	9732                	add	a4,a4,a2
    80205a74:	db34                	sw	a3,112(a4)
    80205a76:	fec42703          	lw	a4,-20(s0)
    80205a7a:	0017069b          	addiw	a3,a4,1 # 4001 <STACK_SIZE+0x3001>
    80205a7e:	fed42623          	sw	a3,-20(s0)
    80205a82:	86ba                	mv	a3,a4
    80205a84:	fd043703          	ld	a4,-48(s0)
    80205a88:	9736                	add	a4,a4,a3
    80205a8a:	fe043683          	ld	a3,-32(s0)
    80205a8e:	97b6                	add	a5,a5,a3
    80205a90:	0607c783          	lbu	a5,96(a5)
    80205a94:	00f70023          	sb	a5,0(a4)
    80205a98:	fec42783          	lw	a5,-20(s0)
    80205a9c:	873e                	mv	a4,a5
    80205a9e:	fd842783          	lw	a5,-40(s0)
    80205aa2:	2701                	sext.w	a4,a4
    80205aa4:	2781                	sext.w	a5,a5
    80205aa6:	00f75e63          	bge	a4,a5,80205ac2 <fs_read+0x10e>
    80205aaa:	fe043703          	ld	a4,-32(s0)
    80205aae:	6791                	lui	a5,0x4
    80205ab0:	97ba                	add	a5,a5,a4
    80205ab2:	5bb8                	lw	a4,112(a5)
    80205ab4:	fe043683          	ld	a3,-32(s0)
    80205ab8:	6791                	lui	a5,0x4
    80205aba:	97b6                	add	a5,a5,a3
    80205abc:	53bc                	lw	a5,96(a5)
    80205abe:	f8f74ee3          	blt	a4,a5,80205a5a <fs_read+0xa6>
    80205ac2:	fec42783          	lw	a5,-20(s0)
    80205ac6:	853e                	mv	a0,a5
    80205ac8:	70a2                	ld	ra,40(sp)
    80205aca:	7402                	ld	s0,32(sp)
    80205acc:	6145                	addi	sp,sp,48
    80205ace:	8082                	ret

0000000080205ad0 <fs_write>:
    80205ad0:	7179                	addi	sp,sp,-48
    80205ad2:	f406                	sd	ra,40(sp)
    80205ad4:	f022                	sd	s0,32(sp)
    80205ad6:	1800                	addi	s0,sp,48
    80205ad8:	87aa                	mv	a5,a0
    80205ada:	fcb43823          	sd	a1,-48(s0)
    80205ade:	8732                	mv	a4,a2
    80205ae0:	fcf42e23          	sw	a5,-36(s0)
    80205ae4:	87ba                	mv	a5,a4
    80205ae6:	fcf42c23          	sw	a5,-40(s0)
    80205aea:	fdc42783          	lw	a5,-36(s0)
    80205aee:	37f5                	addiw	a5,a5,-3 # 3ffd <STACK_SIZE+0x2ffd>
    80205af0:	fef42423          	sw	a5,-24(s0)
    80205af4:	fd043783          	ld	a5,-48(s0)
    80205af8:	c7a9                	beqz	a5,80205b42 <fs_write+0x72>
    80205afa:	fd842783          	lw	a5,-40(s0)
    80205afe:	2781                	sext.w	a5,a5
    80205b00:	0407c163          	bltz	a5,80205b42 <fs_write+0x72>
    80205b04:	fdc42783          	lw	a5,-36(s0)
    80205b08:	0007871b          	sext.w	a4,a5
    80205b0c:	4789                	li	a5,2
    80205b0e:	02e7da63          	bge	a5,a4,80205b42 <fs_write+0x72>
    80205b12:	fe842783          	lw	a5,-24(s0)
    80205b16:	0007871b          	sext.w	a4,a5
    80205b1a:	03f00793          	li	a5,63
    80205b1e:	02e7c263          	blt	a5,a4,80205b42 <fs_write+0x72>
    80205b22:	00012717          	auipc	a4,0x12
    80205b26:	21670713          	addi	a4,a4,534 # 80217d38 <nodes>
    80205b2a:	fe842683          	lw	a3,-24(s0)
    80205b2e:	6791                	lui	a5,0x4
    80205b30:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205b34:	02f687b3          	mul	a5,a3,a5
    80205b38:	97ba                	add	a5,a5,a4
    80205b3a:	6711                	lui	a4,0x4
    80205b3c:	97ba                	add	a5,a5,a4
    80205b3e:	57fc                	lw	a5,108(a5)
    80205b40:	e399                	bnez	a5,80205b46 <fs_write+0x76>
    80205b42:	57fd                	li	a5,-1
    80205b44:	a07d                	j	80205bf2 <fs_write+0x122>
    80205b46:	fe842703          	lw	a4,-24(s0)
    80205b4a:	6791                	lui	a5,0x4
    80205b4c:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205b50:	02f70733          	mul	a4,a4,a5
    80205b54:	00012797          	auipc	a5,0x12
    80205b58:	1e478793          	addi	a5,a5,484 # 80217d38 <nodes>
    80205b5c:	97ba                	add	a5,a5,a4
    80205b5e:	fef43023          	sd	a5,-32(s0)
    80205b62:	fe043703          	ld	a4,-32(s0)
    80205b66:	6791                	lui	a5,0x4
    80205b68:	97ba                	add	a5,a5,a4
    80205b6a:	53fc                	lw	a5,100(a5)
    80205b6c:	c399                	beqz	a5,80205b72 <fs_write+0xa2>
    80205b6e:	57fd                	li	a5,-1
    80205b70:	a049                	j	80205bf2 <fs_write+0x122>
    80205b72:	fe042623          	sw	zero,-20(s0)
    80205b76:	a081                	j	80205bb6 <fs_write+0xe6>
    80205b78:	fec42783          	lw	a5,-20(s0)
    80205b7c:	fd043703          	ld	a4,-48(s0)
    80205b80:	973e                	add	a4,a4,a5
    80205b82:	fe043683          	ld	a3,-32(s0)
    80205b86:	6791                	lui	a5,0x4
    80205b88:	97b6                	add	a5,a5,a3
    80205b8a:	53bc                	lw	a5,96(a5)
    80205b8c:	0017869b          	addiw	a3,a5,1 # 4001 <STACK_SIZE+0x3001>
    80205b90:	0006861b          	sext.w	a2,a3
    80205b94:	fe043583          	ld	a1,-32(s0)
    80205b98:	6691                	lui	a3,0x4
    80205b9a:	96ae                	add	a3,a3,a1
    80205b9c:	d2b0                	sw	a2,96(a3)
    80205b9e:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    80205ba2:	fe043683          	ld	a3,-32(s0)
    80205ba6:	97b6                	add	a5,a5,a3
    80205ba8:	06e78023          	sb	a4,96(a5)
    80205bac:	fec42783          	lw	a5,-20(s0)
    80205bb0:	2785                	addiw	a5,a5,1
    80205bb2:	fef42623          	sw	a5,-20(s0)
    80205bb6:	fec42783          	lw	a5,-20(s0)
    80205bba:	873e                	mv	a4,a5
    80205bbc:	fd842783          	lw	a5,-40(s0)
    80205bc0:	2701                	sext.w	a4,a4
    80205bc2:	2781                	sext.w	a5,a5
    80205bc4:	00f75b63          	bge	a4,a5,80205bda <fs_write+0x10a>
    80205bc8:	fe043703          	ld	a4,-32(s0)
    80205bcc:	6791                	lui	a5,0x4
    80205bce:	97ba                	add	a5,a5,a4
    80205bd0:	53b8                	lw	a4,96(a5)
    80205bd2:	6791                	lui	a5,0x4
    80205bd4:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    80205bd6:	fae7d1e3          	bge	a5,a4,80205b78 <fs_write+0xa8>
    80205bda:	fe043703          	ld	a4,-32(s0)
    80205bde:	6791                	lui	a5,0x4
    80205be0:	97ba                	add	a5,a5,a4
    80205be2:	53bc                	lw	a5,96(a5)
    80205be4:	fe043703          	ld	a4,-32(s0)
    80205be8:	97ba                	add	a5,a5,a4
    80205bea:	06078023          	sb	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80205bee:	fec42783          	lw	a5,-20(s0)
    80205bf2:	853e                	mv	a0,a5
    80205bf4:	70a2                	ld	ra,40(sp)
    80205bf6:	7402                	ld	s0,32(sp)
    80205bf8:	6145                	addi	sp,sp,48
    80205bfa:	8082                	ret

0000000080205bfc <fs_truncate>:
    80205bfc:	7179                	addi	sp,sp,-48
    80205bfe:	f406                	sd	ra,40(sp)
    80205c00:	f022                	sd	s0,32(sp)
    80205c02:	1800                	addi	s0,sp,48
    80205c04:	87aa                	mv	a5,a0
    80205c06:	872e                	mv	a4,a1
    80205c08:	fcf42e23          	sw	a5,-36(s0)
    80205c0c:	87ba                	mv	a5,a4
    80205c0e:	fcf42c23          	sw	a5,-40(s0)
    80205c12:	fdc42783          	lw	a5,-36(s0)
    80205c16:	37f5                	addiw	a5,a5,-3
    80205c18:	fef42623          	sw	a5,-20(s0)
    80205c1c:	fdc42783          	lw	a5,-36(s0)
    80205c20:	0007871b          	sext.w	a4,a5
    80205c24:	4789                	li	a5,2
    80205c26:	02e7da63          	bge	a5,a4,80205c5a <fs_truncate+0x5e>
    80205c2a:	fec42783          	lw	a5,-20(s0)
    80205c2e:	0007871b          	sext.w	a4,a5
    80205c32:	03f00793          	li	a5,63
    80205c36:	02e7c263          	blt	a5,a4,80205c5a <fs_truncate+0x5e>
    80205c3a:	00012717          	auipc	a4,0x12
    80205c3e:	0fe70713          	addi	a4,a4,254 # 80217d38 <nodes>
    80205c42:	fec42683          	lw	a3,-20(s0)
    80205c46:	6791                	lui	a5,0x4
    80205c48:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205c4c:	02f687b3          	mul	a5,a3,a5
    80205c50:	97ba                	add	a5,a5,a4
    80205c52:	6711                	lui	a4,0x4
    80205c54:	97ba                	add	a5,a5,a4
    80205c56:	57fc                	lw	a5,108(a5)
    80205c58:	e399                	bnez	a5,80205c5e <fs_truncate+0x62>
    80205c5a:	57fd                	li	a5,-1
    80205c5c:	a095                	j	80205cc0 <fs_truncate+0xc4>
    80205c5e:	fd842783          	lw	a5,-40(s0)
    80205c62:	2781                	sext.w	a5,a5
    80205c64:	0007c963          	bltz	a5,80205c76 <fs_truncate+0x7a>
    80205c68:	fd842783          	lw	a5,-40(s0)
    80205c6c:	0007871b          	sext.w	a4,a5
    80205c70:	6791                	lui	a5,0x4
    80205c72:	00f74463          	blt	a4,a5,80205c7a <fs_truncate+0x7e>
    80205c76:	57fd                	li	a5,-1
    80205c78:	a0a1                	j	80205cc0 <fs_truncate+0xc4>
    80205c7a:	00012717          	auipc	a4,0x12
    80205c7e:	0be70713          	addi	a4,a4,190 # 80217d38 <nodes>
    80205c82:	fec42683          	lw	a3,-20(s0)
    80205c86:	6791                	lui	a5,0x4
    80205c88:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205c8c:	02f687b3          	mul	a5,a3,a5
    80205c90:	97ba                	add	a5,a5,a4
    80205c92:	6711                	lui	a4,0x4
    80205c94:	97ba                	add	a5,a5,a4
    80205c96:	fd842703          	lw	a4,-40(s0)
    80205c9a:	d3b8                	sw	a4,96(a5)
    80205c9c:	00012697          	auipc	a3,0x12
    80205ca0:	09c68693          	addi	a3,a3,156 # 80217d38 <nodes>
    80205ca4:	fd842703          	lw	a4,-40(s0)
    80205ca8:	fec42603          	lw	a2,-20(s0)
    80205cac:	6791                	lui	a5,0x4
    80205cae:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205cb2:	02f607b3          	mul	a5,a2,a5
    80205cb6:	97b6                	add	a5,a5,a3
    80205cb8:	97ba                	add	a5,a5,a4
    80205cba:	06078023          	sb	zero,96(a5)
    80205cbe:	4781                	li	a5,0
    80205cc0:	853e                	mv	a0,a5
    80205cc2:	70a2                	ld	ra,40(sp)
    80205cc4:	7402                	ld	s0,32(sp)
    80205cc6:	6145                	addi	sp,sp,48
    80205cc8:	8082                	ret

0000000080205cca <fs_close>:
    80205cca:	7179                	addi	sp,sp,-48
    80205ccc:	f406                	sd	ra,40(sp)
    80205cce:	f022                	sd	s0,32(sp)
    80205cd0:	1800                	addi	s0,sp,48
    80205cd2:	87aa                	mv	a5,a0
    80205cd4:	fcf42e23          	sw	a5,-36(s0)
    80205cd8:	fdc42783          	lw	a5,-36(s0)
    80205cdc:	37f5                	addiw	a5,a5,-3
    80205cde:	fef42623          	sw	a5,-20(s0)
    80205ce2:	fdc42783          	lw	a5,-36(s0)
    80205ce6:	0007871b          	sext.w	a4,a5
    80205cea:	4789                	li	a5,2
    80205cec:	00e7da63          	bge	a5,a4,80205d00 <fs_close+0x36>
    80205cf0:	fec42783          	lw	a5,-20(s0)
    80205cf4:	0007871b          	sext.w	a4,a5
    80205cf8:	03f00793          	li	a5,63
    80205cfc:	00e7d463          	bge	a5,a4,80205d04 <fs_close+0x3a>
    80205d00:	57fd                	li	a5,-1
    80205d02:	a011                	j	80205d06 <fs_close+0x3c>
    80205d04:	4781                	li	a5,0
    80205d06:	853e                	mv	a0,a5
    80205d08:	70a2                	ld	ra,40(sp)
    80205d0a:	7402                	ld	s0,32(sp)
    80205d0c:	6145                	addi	sp,sp,48
    80205d0e:	8082                	ret

0000000080205d10 <fs_read_file>:
    80205d10:	7139                	addi	sp,sp,-64
    80205d12:	fc06                	sd	ra,56(sp)
    80205d14:	f822                	sd	s0,48(sp)
    80205d16:	0080                	addi	s0,sp,64
    80205d18:	fca43c23          	sd	a0,-40(s0)
    80205d1c:	fcb43823          	sd	a1,-48(s0)
    80205d20:	87b2                	mv	a5,a2
    80205d22:	fcf42623          	sw	a5,-52(s0)
    80205d26:	4581                	li	a1,0
    80205d28:	fd843503          	ld	a0,-40(s0)
    80205d2c:	b0fff0ef          	jal	8020583a <fs_open>
    80205d30:	87aa                	mv	a5,a0
    80205d32:	fef42623          	sw	a5,-20(s0)
    80205d36:	fec42783          	lw	a5,-20(s0)
    80205d3a:	2781                	sext.w	a5,a5
    80205d3c:	0007d463          	bgez	a5,80205d44 <fs_read_file+0x34>
    80205d40:	57fd                	li	a5,-1
    80205d42:	a02d                	j	80205d6c <fs_read_file+0x5c>
    80205d44:	fcc42703          	lw	a4,-52(s0)
    80205d48:	fec42783          	lw	a5,-20(s0)
    80205d4c:	863a                	mv	a2,a4
    80205d4e:	fd043583          	ld	a1,-48(s0)
    80205d52:	853e                	mv	a0,a5
    80205d54:	c61ff0ef          	jal	802059b4 <fs_read>
    80205d58:	87aa                	mv	a5,a0
    80205d5a:	fef42423          	sw	a5,-24(s0)
    80205d5e:	fec42783          	lw	a5,-20(s0)
    80205d62:	853e                	mv	a0,a5
    80205d64:	f67ff0ef          	jal	80205cca <fs_close>
    80205d68:	fe842783          	lw	a5,-24(s0)
    80205d6c:	853e                	mv	a0,a5
    80205d6e:	70e2                	ld	ra,56(sp)
    80205d70:	7442                	ld	s0,48(sp)
    80205d72:	6121                	addi	sp,sp,64
    80205d74:	8082                	ret

0000000080205d76 <fs_write_file>:
    80205d76:	7139                	addi	sp,sp,-64
    80205d78:	fc06                	sd	ra,56(sp)
    80205d7a:	f822                	sd	s0,48(sp)
    80205d7c:	0080                	addi	s0,sp,64
    80205d7e:	fca43c23          	sd	a0,-40(s0)
    80205d82:	fcb43823          	sd	a1,-48(s0)
    80205d86:	87b2                	mv	a5,a2
    80205d88:	8736                	mv	a4,a3
    80205d8a:	fcf42623          	sw	a5,-52(s0)
    80205d8e:	87ba                	mv	a5,a4
    80205d90:	fcf42423          	sw	a5,-56(s0)
    80205d94:	4795                	li	a5,5
    80205d96:	fef42623          	sw	a5,-20(s0)
    80205d9a:	fc842783          	lw	a5,-56(s0)
    80205d9e:	2781                	sext.w	a5,a5
    80205da0:	c799                	beqz	a5,80205dae <fs_write_file+0x38>
    80205da2:	fec42783          	lw	a5,-20(s0)
    80205da6:	0087e793          	ori	a5,a5,8
    80205daa:	fef42623          	sw	a5,-20(s0)
    80205dae:	fec42783          	lw	a5,-20(s0)
    80205db2:	85be                	mv	a1,a5
    80205db4:	fd843503          	ld	a0,-40(s0)
    80205db8:	a83ff0ef          	jal	8020583a <fs_open>
    80205dbc:	87aa                	mv	a5,a0
    80205dbe:	fef42423          	sw	a5,-24(s0)
    80205dc2:	fe842783          	lw	a5,-24(s0)
    80205dc6:	2781                	sext.w	a5,a5
    80205dc8:	0007d463          	bgez	a5,80205dd0 <fs_write_file+0x5a>
    80205dcc:	57fd                	li	a5,-1
    80205dce:	a83d                	j	80205e0c <fs_write_file+0x96>
    80205dd0:	fc842783          	lw	a5,-56(s0)
    80205dd4:	2781                	sext.w	a5,a5
    80205dd6:	c799                	beqz	a5,80205de4 <fs_write_file+0x6e>
    80205dd8:	fe842783          	lw	a5,-24(s0)
    80205ddc:	4581                	li	a1,0
    80205dde:	853e                	mv	a0,a5
    80205de0:	e1dff0ef          	jal	80205bfc <fs_truncate>
    80205de4:	fcc42703          	lw	a4,-52(s0)
    80205de8:	fe842783          	lw	a5,-24(s0)
    80205dec:	863a                	mv	a2,a4
    80205dee:	fd043583          	ld	a1,-48(s0)
    80205df2:	853e                	mv	a0,a5
    80205df4:	cddff0ef          	jal	80205ad0 <fs_write>
    80205df8:	87aa                	mv	a5,a0
    80205dfa:	fef42223          	sw	a5,-28(s0)
    80205dfe:	fe842783          	lw	a5,-24(s0)
    80205e02:	853e                	mv	a0,a5
    80205e04:	ec7ff0ef          	jal	80205cca <fs_close>
    80205e08:	fe442783          	lw	a5,-28(s0)
    80205e0c:	853e                	mv	a0,a5
    80205e0e:	70e2                	ld	ra,56(sp)
    80205e10:	7442                	ld	s0,48(sp)
    80205e12:	6121                	addi	sp,sp,64
    80205e14:	8082                	ret

0000000080205e16 <fs_seed_file>:
    80205e16:	7135                	addi	sp,sp,-160
    80205e18:	ed06                	sd	ra,152(sp)
    80205e1a:	e922                	sd	s0,144(sp)
    80205e1c:	1100                	addi	s0,sp,160
    80205e1e:	f6a43c23          	sd	a0,-136(s0)
    80205e22:	f6b43823          	sd	a1,-144(s0)
    80205e26:	87b2                	mv	a5,a2
    80205e28:	f6f42623          	sw	a5,-148(s0)
    80205e2c:	87b6                	mv	a5,a3
    80205e2e:	f6f42423          	sw	a5,-152(s0)
    80205e32:	87ba                	mv	a5,a4
    80205e34:	f6f42223          	sw	a5,-156(s0)
    80205e38:	f8040793          	addi	a5,s0,-128
    80205e3c:	06000613          	li	a2,96
    80205e40:	85be                	mv	a1,a5
    80205e42:	f7843503          	ld	a0,-136(s0)
    80205e46:	d17fe0ef          	jal	80204b5c <path_normalize>
    80205e4a:	87aa                	mv	a5,a0
    80205e4c:	1407cd63          	bltz	a5,80205fa6 <fs_seed_file+0x190>
    80205e50:	f8040793          	addi	a5,s0,-128
    80205e54:	853e                	mv	a0,a5
    80205e56:	8b2ff0ef          	jal	80204f08 <lookup_path>
    80205e5a:	fea43423          	sd	a0,-24(s0)
    80205e5e:	fe843783          	ld	a5,-24(s0)
    80205e62:	eb95                	bnez	a5,80205e96 <fs_seed_file+0x80>
    80205e64:	f6842783          	lw	a5,-152(s0)
    80205e68:	2781                	sext.w	a5,a5
    80205e6a:	c799                	beqz	a5,80205e78 <fs_seed_file+0x62>
    80205e6c:	f8040793          	addi	a5,s0,-128
    80205e70:	853e                	mv	a0,a5
    80205e72:	b04ff0ef          	jal	80205176 <fs_mkdir>
    80205e76:	a809                	j	80205e88 <fs_seed_file+0x72>
    80205e78:	f6442703          	lw	a4,-156(s0)
    80205e7c:	f8040793          	addi	a5,s0,-128
    80205e80:	85ba                	mv	a1,a4
    80205e82:	853e                	mv	a0,a5
    80205e84:	c50ff0ef          	jal	802052d4 <fs_create>
    80205e88:	f8040793          	addi	a5,s0,-128
    80205e8c:	853e                	mv	a0,a5
    80205e8e:	87aff0ef          	jal	80204f08 <lookup_path>
    80205e92:	fea43423          	sd	a0,-24(s0)
    80205e96:	fe843783          	ld	a5,-24(s0)
    80205e9a:	10078863          	beqz	a5,80205faa <fs_seed_file+0x194>
    80205e9e:	f6842783          	lw	a5,-152(s0)
    80205ea2:	2781                	sext.w	a5,a5
    80205ea4:	cb81                	beqz	a5,80205eb4 <fs_seed_file+0x9e>
    80205ea6:	fe843703          	ld	a4,-24(s0)
    80205eaa:	6791                	lui	a5,0x4
    80205eac:	97ba                	add	a5,a5,a4
    80205eae:	4705                	li	a4,1
    80205eb0:	d3f8                	sw	a4,100(a5)
    80205eb2:	a8ed                	j	80205fac <fs_seed_file+0x196>
    80205eb4:	fe843703          	ld	a4,-24(s0)
    80205eb8:	6791                	lui	a5,0x4
    80205eba:	97ba                	add	a5,a5,a4
    80205ebc:	0607a223          	sw	zero,100(a5) # 4064 <STACK_SIZE+0x3064>
    80205ec0:	fe843703          	ld	a4,-24(s0)
    80205ec4:	6791                	lui	a5,0x4
    80205ec6:	97ba                	add	a5,a5,a4
    80205ec8:	f6442703          	lw	a4,-156(s0)
    80205ecc:	d7b8                	sw	a4,104(a5)
    80205ece:	f6c42783          	lw	a5,-148(s0)
    80205ed2:	2781                	sext.w	a5,a5
    80205ed4:	0607d063          	bgez	a5,80205f34 <fs_seed_file+0x11e>
    80205ed8:	fe042223          	sw	zero,-28(s0)
    80205edc:	a025                	j	80205f04 <fs_seed_file+0xee>
    80205ede:	fe442783          	lw	a5,-28(s0)
    80205ee2:	f7043703          	ld	a4,-144(s0)
    80205ee6:	97ba                	add	a5,a5,a4
    80205ee8:	0007c703          	lbu	a4,0(a5) # 4000 <STACK_SIZE+0x3000>
    80205eec:	fe843683          	ld	a3,-24(s0)
    80205ef0:	fe442783          	lw	a5,-28(s0)
    80205ef4:	97b6                	add	a5,a5,a3
    80205ef6:	06e78023          	sb	a4,96(a5)
    80205efa:	fe442783          	lw	a5,-28(s0)
    80205efe:	2785                	addiw	a5,a5,1
    80205f00:	fef42223          	sw	a5,-28(s0)
    80205f04:	fe442783          	lw	a5,-28(s0)
    80205f08:	f7043703          	ld	a4,-144(s0)
    80205f0c:	97ba                	add	a5,a5,a4
    80205f0e:	0007c783          	lbu	a5,0(a5)
    80205f12:	cb89                	beqz	a5,80205f24 <fs_seed_file+0x10e>
    80205f14:	fe442783          	lw	a5,-28(s0)
    80205f18:	0007871b          	sext.w	a4,a5
    80205f1c:	6791                	lui	a5,0x4
    80205f1e:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    80205f20:	fae7dfe3          	bge	a5,a4,80205ede <fs_seed_file+0xc8>
    80205f24:	fe843703          	ld	a4,-24(s0)
    80205f28:	6791                	lui	a5,0x4
    80205f2a:	97ba                	add	a5,a5,a4
    80205f2c:	fe442703          	lw	a4,-28(s0)
    80205f30:	d3b8                	sw	a4,96(a5)
    80205f32:	a8b9                	j	80205f90 <fs_seed_file+0x17a>
    80205f34:	fe042223          	sw	zero,-28(s0)
    80205f38:	a025                	j	80205f60 <fs_seed_file+0x14a>
    80205f3a:	fe442783          	lw	a5,-28(s0)
    80205f3e:	f7043703          	ld	a4,-144(s0)
    80205f42:	97ba                	add	a5,a5,a4
    80205f44:	0007c703          	lbu	a4,0(a5) # 4000 <STACK_SIZE+0x3000>
    80205f48:	fe843683          	ld	a3,-24(s0)
    80205f4c:	fe442783          	lw	a5,-28(s0)
    80205f50:	97b6                	add	a5,a5,a3
    80205f52:	06e78023          	sb	a4,96(a5)
    80205f56:	fe442783          	lw	a5,-28(s0)
    80205f5a:	2785                	addiw	a5,a5,1
    80205f5c:	fef42223          	sw	a5,-28(s0)
    80205f60:	fe442783          	lw	a5,-28(s0)
    80205f64:	873e                	mv	a4,a5
    80205f66:	f6c42783          	lw	a5,-148(s0)
    80205f6a:	2701                	sext.w	a4,a4
    80205f6c:	2781                	sext.w	a5,a5
    80205f6e:	00f75a63          	bge	a4,a5,80205f82 <fs_seed_file+0x16c>
    80205f72:	fe442783          	lw	a5,-28(s0)
    80205f76:	0007871b          	sext.w	a4,a5
    80205f7a:	6791                	lui	a5,0x4
    80205f7c:	17f9                	addi	a5,a5,-2 # 3ffe <STACK_SIZE+0x2ffe>
    80205f7e:	fae7dee3          	bge	a5,a4,80205f3a <fs_seed_file+0x124>
    80205f82:	fe843703          	ld	a4,-24(s0)
    80205f86:	6791                	lui	a5,0x4
    80205f88:	97ba                	add	a5,a5,a4
    80205f8a:	fe442703          	lw	a4,-28(s0)
    80205f8e:	d3b8                	sw	a4,96(a5)
    80205f90:	fe843703          	ld	a4,-24(s0)
    80205f94:	6791                	lui	a5,0x4
    80205f96:	97ba                	add	a5,a5,a4
    80205f98:	53bc                	lw	a5,96(a5)
    80205f9a:	fe843703          	ld	a4,-24(s0)
    80205f9e:	97ba                	add	a5,a5,a4
    80205fa0:	06078023          	sb	zero,96(a5) # 4060 <STACK_SIZE+0x3060>
    80205fa4:	a021                	j	80205fac <fs_seed_file+0x196>
    80205fa6:	0001                	nop
    80205fa8:	a011                	j	80205fac <fs_seed_file+0x196>
    80205faa:	0001                	nop
    80205fac:	60ea                	ld	ra,152(sp)
    80205fae:	644a                	ld	s0,144(sp)
    80205fb0:	610d                	addi	sp,sp,160
    80205fb2:	8082                	ret

0000000080205fb4 <fs_init>:
    80205fb4:	1101                	addi	sp,sp,-32
    80205fb6:	ec06                	sd	ra,24(sp)
    80205fb8:	e822                	sd	s0,16(sp)
    80205fba:	1000                	addi	s0,sp,32
    80205fbc:	fe042623          	sw	zero,-20(s0)
    80205fc0:	a035                	j	80205fec <fs_init+0x38>
    80205fc2:	00012717          	auipc	a4,0x12
    80205fc6:	d7670713          	addi	a4,a4,-650 # 80217d38 <nodes>
    80205fca:	fec42683          	lw	a3,-20(s0)
    80205fce:	6791                	lui	a5,0x4
    80205fd0:	07478793          	addi	a5,a5,116 # 4074 <STACK_SIZE+0x3074>
    80205fd4:	02f687b3          	mul	a5,a3,a5
    80205fd8:	97ba                	add	a5,a5,a4
    80205fda:	6711                	lui	a4,0x4
    80205fdc:	97ba                	add	a5,a5,a4
    80205fde:	0607a623          	sw	zero,108(a5)
    80205fe2:	fec42783          	lw	a5,-20(s0)
    80205fe6:	2785                	addiw	a5,a5,1
    80205fe8:	fef42623          	sw	a5,-20(s0)
    80205fec:	fec42783          	lw	a5,-20(s0)
    80205ff0:	0007871b          	sext.w	a4,a5
    80205ff4:	03f00793          	li	a5,63
    80205ff8:	fce7d5e3          	bge	a5,a4,80205fc2 <fs_init+0xe>
    80205ffc:	00002517          	auipc	a0,0x2
    80206000:	4a450513          	addi	a0,a0,1188 # 802084a0 <user_code_end+0xad0>
    80206004:	972ff0ef          	jal	80205176 <fs_mkdir>
    80206008:	00002517          	auipc	a0,0x2
    8020600c:	4b050513          	addi	a0,a0,1200 # 802084b8 <user_code_end+0xae8>
    80206010:	966ff0ef          	jal	80205176 <fs_mkdir>
    80206014:	00002517          	auipc	a0,0x2
    80206018:	4ac50513          	addi	a0,a0,1196 # 802084c0 <user_code_end+0xaf0>
    8020601c:	95aff0ef          	jal	80205176 <fs_mkdir>
    80206020:	00002617          	auipc	a2,0x2
    80206024:	4a060613          	addi	a2,a2,1184 # 802084c0 <user_code_end+0xaf0>
    80206028:	06000593          	li	a1,96
    8020602c:	00009517          	auipc	a0,0x9
    80206030:	fe450513          	addi	a0,a0,-28 # 8020f010 <cwd>
    80206034:	aa7fe0ef          	jal	80204ada <path_copy>
    80206038:	043010ef          	jal	8020787a <fs_load_home>
    8020603c:	0001                	nop
    8020603e:	60e2                	ld	ra,24(sp)
    80206040:	6442                	ld	s0,16(sp)
    80206042:	6105                	addi	sp,sp,32
    80206044:	8082                	ret

0000000080206046 <r_sstatus>:
    80206046:	1101                	addi	sp,sp,-32
    80206048:	ec06                	sd	ra,24(sp)
    8020604a:	e822                	sd	s0,16(sp)
    8020604c:	1000                	addi	s0,sp,32
    8020604e:	100027f3          	csrr	a5,sstatus
    80206052:	fef43423          	sd	a5,-24(s0)
    80206056:	fe843783          	ld	a5,-24(s0)
    8020605a:	853e                	mv	a0,a5
    8020605c:	60e2                	ld	ra,24(sp)
    8020605e:	6442                	ld	s0,16(sp)
    80206060:	6105                	addi	sp,sp,32
    80206062:	8082                	ret

0000000080206064 <w_sstatus>:
    80206064:	1101                	addi	sp,sp,-32
    80206066:	ec06                	sd	ra,24(sp)
    80206068:	e822                	sd	s0,16(sp)
    8020606a:	1000                	addi	s0,sp,32
    8020606c:	fea43423          	sd	a0,-24(s0)
    80206070:	fe843783          	ld	a5,-24(s0)
    80206074:	10079073          	csrw	sstatus,a5
    80206078:	0001                	nop
    8020607a:	60e2                	ld	ra,24(sp)
    8020607c:	6442                	ld	s0,16(sp)
    8020607e:	6105                	addi	sp,sp,32
    80206080:	8082                	ret

0000000080206082 <cpu_irq_disable>:
    80206082:	1141                	addi	sp,sp,-16
    80206084:	e406                	sd	ra,8(sp)
    80206086:	e022                	sd	s0,0(sp)
    80206088:	0800                	addi	s0,sp,16
    8020608a:	fbdff0ef          	jal	80206046 <r_sstatus>
    8020608e:	87aa                	mv	a5,a0
    80206090:	9bf5                	andi	a5,a5,-3
    80206092:	853e                	mv	a0,a5
    80206094:	fd1ff0ef          	jal	80206064 <w_sstatus>
    80206098:	0001                	nop
    8020609a:	60a2                	ld	ra,8(sp)
    8020609c:	6402                	ld	s0,0(sp)
    8020609e:	0141                	addi	sp,sp,16
    802060a0:	8082                	ret

00000000802060a2 <cpu_irq_enable>:
    802060a2:	1141                	addi	sp,sp,-16
    802060a4:	e406                	sd	ra,8(sp)
    802060a6:	e022                	sd	s0,0(sp)
    802060a8:	0800                	addi	s0,sp,16
    802060aa:	f9dff0ef          	jal	80206046 <r_sstatus>
    802060ae:	87aa                	mv	a5,a0
    802060b0:	0027e793          	ori	a5,a5,2
    802060b4:	853e                	mv	a0,a5
    802060b6:	fafff0ef          	jal	80206064 <w_sstatus>
    802060ba:	0001                	nop
    802060bc:	60a2                	ld	ra,8(sp)
    802060be:	6402                	ld	s0,0(sp)
    802060c0:	0141                	addi	sp,sp,16
    802060c2:	8082                	ret

00000000802060c4 <str_eq>:
    802060c4:	1101                	addi	sp,sp,-32
    802060c6:	ec06                	sd	ra,24(sp)
    802060c8:	e822                	sd	s0,16(sp)
    802060ca:	1000                	addi	s0,sp,32
    802060cc:	fea43423          	sd	a0,-24(s0)
    802060d0:	feb43023          	sd	a1,-32(s0)
    802060d4:	a03d                	j	80206102 <str_eq+0x3e>
    802060d6:	fe843783          	ld	a5,-24(s0)
    802060da:	0007c703          	lbu	a4,0(a5)
    802060de:	fe043783          	ld	a5,-32(s0)
    802060e2:	0007c783          	lbu	a5,0(a5)
    802060e6:	00f70463          	beq	a4,a5,802060ee <str_eq+0x2a>
    802060ea:	4781                	li	a5,0
    802060ec:	a0b1                	j	80206138 <str_eq+0x74>
    802060ee:	fe843783          	ld	a5,-24(s0)
    802060f2:	0785                	addi	a5,a5,1
    802060f4:	fef43423          	sd	a5,-24(s0)
    802060f8:	fe043783          	ld	a5,-32(s0)
    802060fc:	0785                	addi	a5,a5,1
    802060fe:	fef43023          	sd	a5,-32(s0)
    80206102:	fe843783          	ld	a5,-24(s0)
    80206106:	0007c783          	lbu	a5,0(a5)
    8020610a:	c791                	beqz	a5,80206116 <str_eq+0x52>
    8020610c:	fe043783          	ld	a5,-32(s0)
    80206110:	0007c783          	lbu	a5,0(a5)
    80206114:	f3e9                	bnez	a5,802060d6 <str_eq+0x12>
    80206116:	fe843783          	ld	a5,-24(s0)
    8020611a:	0007c703          	lbu	a4,0(a5)
    8020611e:	fe043783          	ld	a5,-32(s0)
    80206122:	0007c783          	lbu	a5,0(a5)
    80206126:	2701                	sext.w	a4,a4
    80206128:	2781                	sext.w	a5,a5
    8020612a:	40f707b3          	sub	a5,a4,a5
    8020612e:	0017b793          	seqz	a5,a5
    80206132:	0ff7f793          	zext.b	a5,a5
    80206136:	2781                	sext.w	a5,a5
    80206138:	853e                	mv	a0,a5
    8020613a:	60e2                	ld	ra,24(sp)
    8020613c:	6442                	ld	s0,16(sp)
    8020613e:	6105                	addi	sp,sp,32
    80206140:	8082                	ret

0000000080206142 <str_prefix>:
    80206142:	1101                	addi	sp,sp,-32
    80206144:	ec06                	sd	ra,24(sp)
    80206146:	e822                	sd	s0,16(sp)
    80206148:	1000                	addi	s0,sp,32
    8020614a:	fea43423          	sd	a0,-24(s0)
    8020614e:	feb43023          	sd	a1,-32(s0)
    80206152:	a03d                	j	80206180 <str_prefix+0x3e>
    80206154:	fe843783          	ld	a5,-24(s0)
    80206158:	0007c703          	lbu	a4,0(a5)
    8020615c:	fe043783          	ld	a5,-32(s0)
    80206160:	0007c783          	lbu	a5,0(a5)
    80206164:	00f70463          	beq	a4,a5,8020616c <str_prefix+0x2a>
    80206168:	4781                	li	a5,0
    8020616a:	a00d                	j	8020618c <str_prefix+0x4a>
    8020616c:	fe843783          	ld	a5,-24(s0)
    80206170:	0785                	addi	a5,a5,1
    80206172:	fef43423          	sd	a5,-24(s0)
    80206176:	fe043783          	ld	a5,-32(s0)
    8020617a:	0785                	addi	a5,a5,1
    8020617c:	fef43023          	sd	a5,-32(s0)
    80206180:	fe043783          	ld	a5,-32(s0)
    80206184:	0007c783          	lbu	a5,0(a5)
    80206188:	f7f1                	bnez	a5,80206154 <str_prefix+0x12>
    8020618a:	4785                	li	a5,1
    8020618c:	853e                	mv	a0,a5
    8020618e:	60e2                	ld	ra,24(sp)
    80206190:	6442                	ld	s0,16(sp)
    80206192:	6105                	addi	sp,sp,32
    80206194:	8082                	ret

0000000080206196 <trim_line>:
    80206196:	7179                	addi	sp,sp,-48
    80206198:	f406                	sd	ra,40(sp)
    8020619a:	f022                	sd	s0,32(sp)
    8020619c:	1800                	addi	s0,sp,48
    8020619e:	fca43c23          	sd	a0,-40(s0)
    802061a2:	fe042623          	sw	zero,-20(s0)
    802061a6:	fe042423          	sw	zero,-24(s0)
    802061aa:	a031                	j	802061b6 <trim_line+0x20>
    802061ac:	fec42783          	lw	a5,-20(s0)
    802061b0:	2785                	addiw	a5,a5,1
    802061b2:	fef42623          	sw	a5,-20(s0)
    802061b6:	fec42783          	lw	a5,-20(s0)
    802061ba:	fd843703          	ld	a4,-40(s0)
    802061be:	97ba                	add	a5,a5,a4
    802061c0:	0007c783          	lbu	a5,0(a5)
    802061c4:	f7e5                	bnez	a5,802061ac <trim_line+0x16>
    802061c6:	a831                	j	802061e2 <trim_line+0x4c>
    802061c8:	fec42783          	lw	a5,-20(s0)
    802061cc:	17fd                	addi	a5,a5,-1
    802061ce:	fd843703          	ld	a4,-40(s0)
    802061d2:	97ba                	add	a5,a5,a4
    802061d4:	00078023          	sb	zero,0(a5)
    802061d8:	fec42783          	lw	a5,-20(s0)
    802061dc:	37fd                	addiw	a5,a5,-1
    802061de:	fef42623          	sw	a5,-20(s0)
    802061e2:	fec42783          	lw	a5,-20(s0)
    802061e6:	2781                	sext.w	a5,a5
    802061e8:	06f05963          	blez	a5,8020625a <trim_line+0xc4>
    802061ec:	fec42783          	lw	a5,-20(s0)
    802061f0:	17fd                	addi	a5,a5,-1
    802061f2:	fd843703          	ld	a4,-40(s0)
    802061f6:	97ba                	add	a5,a5,a4
    802061f8:	0007c783          	lbu	a5,0(a5)
    802061fc:	873e                	mv	a4,a5
    802061fe:	47a9                	li	a5,10
    80206200:	fcf704e3          	beq	a4,a5,802061c8 <trim_line+0x32>
    80206204:	fec42783          	lw	a5,-20(s0)
    80206208:	17fd                	addi	a5,a5,-1
    8020620a:	fd843703          	ld	a4,-40(s0)
    8020620e:	97ba                	add	a5,a5,a4
    80206210:	0007c783          	lbu	a5,0(a5)
    80206214:	873e                	mv	a4,a5
    80206216:	47b5                	li	a5,13
    80206218:	faf708e3          	beq	a4,a5,802061c8 <trim_line+0x32>
    8020621c:	fec42783          	lw	a5,-20(s0)
    80206220:	17fd                	addi	a5,a5,-1
    80206222:	fd843703          	ld	a4,-40(s0)
    80206226:	97ba                	add	a5,a5,a4
    80206228:	0007c783          	lbu	a5,0(a5)
    8020622c:	873e                	mv	a4,a5
    8020622e:	02000793          	li	a5,32
    80206232:	f8f70be3          	beq	a4,a5,802061c8 <trim_line+0x32>
    80206236:	fec42783          	lw	a5,-20(s0)
    8020623a:	17fd                	addi	a5,a5,-1
    8020623c:	fd843703          	ld	a4,-40(s0)
    80206240:	97ba                	add	a5,a5,a4
    80206242:	0007c783          	lbu	a5,0(a5)
    80206246:	873e                	mv	a4,a5
    80206248:	47a5                	li	a5,9
    8020624a:	f6f70fe3          	beq	a4,a5,802061c8 <trim_line+0x32>
    8020624e:	a031                	j	8020625a <trim_line+0xc4>
    80206250:	fe842783          	lw	a5,-24(s0)
    80206254:	2785                	addiw	a5,a5,1
    80206256:	fef42423          	sw	a5,-24(s0)
    8020625a:	fe842783          	lw	a5,-24(s0)
    8020625e:	fd843703          	ld	a4,-40(s0)
    80206262:	97ba                	add	a5,a5,a4
    80206264:	0007c783          	lbu	a5,0(a5)
    80206268:	873e                	mv	a4,a5
    8020626a:	02000793          	li	a5,32
    8020626e:	fef701e3          	beq	a4,a5,80206250 <trim_line+0xba>
    80206272:	fe842783          	lw	a5,-24(s0)
    80206276:	fd843703          	ld	a4,-40(s0)
    8020627a:	97ba                	add	a5,a5,a4
    8020627c:	0007c783          	lbu	a5,0(a5)
    80206280:	873e                	mv	a4,a5
    80206282:	47a5                	li	a5,9
    80206284:	fcf706e3          	beq	a4,a5,80206250 <trim_line+0xba>
    80206288:	fe842783          	lw	a5,-24(s0)
    8020628c:	2781                	sext.w	a5,a5
    8020628e:	04f05c63          	blez	a5,802062e6 <trim_line+0x150>
    80206292:	fe042223          	sw	zero,-28(s0)
    80206296:	a80d                	j	802062c8 <trim_line+0x132>
    80206298:	fe842783          	lw	a5,-24(s0)
    8020629c:	0017871b          	addiw	a4,a5,1
    802062a0:	fee42423          	sw	a4,-24(s0)
    802062a4:	873e                	mv	a4,a5
    802062a6:	fd843783          	ld	a5,-40(s0)
    802062aa:	973e                	add	a4,a4,a5
    802062ac:	fe442783          	lw	a5,-28(s0)
    802062b0:	0017869b          	addiw	a3,a5,1
    802062b4:	fed42223          	sw	a3,-28(s0)
    802062b8:	86be                	mv	a3,a5
    802062ba:	fd843783          	ld	a5,-40(s0)
    802062be:	97b6                	add	a5,a5,a3
    802062c0:	00074703          	lbu	a4,0(a4) # 4000 <STACK_SIZE+0x3000>
    802062c4:	00e78023          	sb	a4,0(a5)
    802062c8:	fe842783          	lw	a5,-24(s0)
    802062cc:	fd843703          	ld	a4,-40(s0)
    802062d0:	97ba                	add	a5,a5,a4
    802062d2:	0007c783          	lbu	a5,0(a5)
    802062d6:	f3e9                	bnez	a5,80206298 <trim_line+0x102>
    802062d8:	fe442783          	lw	a5,-28(s0)
    802062dc:	fd843703          	ld	a4,-40(s0)
    802062e0:	97ba                	add	a5,a5,a4
    802062e2:	00078023          	sb	zero,0(a5)
    802062e6:	0001                	nop
    802062e8:	70a2                	ld	ra,40(sp)
    802062ea:	7402                	ld	s0,32(sp)
    802062ec:	6145                	addi	sp,sp,48
    802062ee:	8082                	ret

00000000802062f0 <skip_word>:
    802062f0:	1101                	addi	sp,sp,-32
    802062f2:	ec06                	sd	ra,24(sp)
    802062f4:	e822                	sd	s0,16(sp)
    802062f6:	1000                	addi	s0,sp,32
    802062f8:	fea43423          	sd	a0,-24(s0)
    802062fc:	a031                	j	80206308 <skip_word+0x18>
    802062fe:	fe843783          	ld	a5,-24(s0)
    80206302:	0785                	addi	a5,a5,1
    80206304:	fef43423          	sd	a5,-24(s0)
    80206308:	fe843783          	ld	a5,-24(s0)
    8020630c:	0007c783          	lbu	a5,0(a5)
    80206310:	cb85                	beqz	a5,80206340 <skip_word+0x50>
    80206312:	fe843783          	ld	a5,-24(s0)
    80206316:	0007c783          	lbu	a5,0(a5)
    8020631a:	873e                	mv	a4,a5
    8020631c:	02000793          	li	a5,32
    80206320:	02f70063          	beq	a4,a5,80206340 <skip_word+0x50>
    80206324:	fe843783          	ld	a5,-24(s0)
    80206328:	0007c783          	lbu	a5,0(a5)
    8020632c:	873e                	mv	a4,a5
    8020632e:	47a5                	li	a5,9
    80206330:	fcf717e3          	bne	a4,a5,802062fe <skip_word+0xe>
    80206334:	a031                	j	80206340 <skip_word+0x50>
    80206336:	fe843783          	ld	a5,-24(s0)
    8020633a:	0785                	addi	a5,a5,1
    8020633c:	fef43423          	sd	a5,-24(s0)
    80206340:	fe843783          	ld	a5,-24(s0)
    80206344:	0007c783          	lbu	a5,0(a5)
    80206348:	873e                	mv	a4,a5
    8020634a:	02000793          	li	a5,32
    8020634e:	fef704e3          	beq	a4,a5,80206336 <skip_word+0x46>
    80206352:	fe843783          	ld	a5,-24(s0)
    80206356:	0007c783          	lbu	a5,0(a5)
    8020635a:	873e                	mv	a4,a5
    8020635c:	47a5                	li	a5,9
    8020635e:	fcf70ce3          	beq	a4,a5,80206336 <skip_word+0x46>
    80206362:	fe843783          	ld	a5,-24(s0)
    80206366:	853e                	mv	a0,a5
    80206368:	60e2                	ld	ra,24(sp)
    8020636a:	6442                	ld	s0,16(sp)
    8020636c:	6105                	addi	sp,sp,32
    8020636e:	8082                	ret

0000000080206370 <find_redirect>:
    80206370:	7139                	addi	sp,sp,-64
    80206372:	fc06                	sd	ra,56(sp)
    80206374:	f822                	sd	s0,48(sp)
    80206376:	0080                	addi	s0,sp,64
    80206378:	fca43c23          	sd	a0,-40(s0)
    8020637c:	fcb43823          	sd	a1,-48(s0)
    80206380:	fcc43423          	sd	a2,-56(s0)
    80206384:	fd843783          	ld	a5,-40(s0)
    80206388:	fef43423          	sd	a5,-24(s0)
    8020638c:	fd043783          	ld	a5,-48(s0)
    80206390:	0007b023          	sd	zero,0(a5)
    80206394:	fc843783          	ld	a5,-56(s0)
    80206398:	0007a023          	sw	zero,0(a5)
    8020639c:	a055                	j	80206440 <find_redirect+0xd0>
    8020639e:	fe843783          	ld	a5,-24(s0)
    802063a2:	0007c783          	lbu	a5,0(a5)
    802063a6:	873e                	mv	a4,a5
    802063a8:	03e00793          	li	a5,62
    802063ac:	04f71463          	bne	a4,a5,802063f4 <find_redirect+0x84>
    802063b0:	fe843783          	ld	a5,-24(s0)
    802063b4:	0785                	addi	a5,a5,1
    802063b6:	0007c783          	lbu	a5,0(a5)
    802063ba:	873e                	mv	a4,a5
    802063bc:	03e00793          	li	a5,62
    802063c0:	02f71a63          	bne	a4,a5,802063f4 <find_redirect+0x84>
    802063c4:	fe843783          	ld	a5,-24(s0)
    802063c8:	00078023          	sb	zero,0(a5)
    802063cc:	fc843783          	ld	a5,-56(s0)
    802063d0:	4705                	li	a4,1
    802063d2:	c398                	sw	a4,0(a5)
    802063d4:	fe843783          	ld	a5,-24(s0)
    802063d8:	00278713          	addi	a4,a5,2
    802063dc:	fd043783          	ld	a5,-48(s0)
    802063e0:	e398                	sd	a4,0(a5)
    802063e2:	fd043783          	ld	a5,-48(s0)
    802063e6:	639c                	ld	a5,0(a5)
    802063e8:	853e                	mv	a0,a5
    802063ea:	dadff0ef          	jal	80206196 <trim_line>
    802063ee:	fe843783          	ld	a5,-24(s0)
    802063f2:	a8a9                	j	8020644c <find_redirect+0xdc>
    802063f4:	fe843783          	ld	a5,-24(s0)
    802063f8:	0007c783          	lbu	a5,0(a5)
    802063fc:	873e                	mv	a4,a5
    802063fe:	03e00793          	li	a5,62
    80206402:	02f71a63          	bne	a4,a5,80206436 <find_redirect+0xc6>
    80206406:	fe843783          	ld	a5,-24(s0)
    8020640a:	00078023          	sb	zero,0(a5)
    8020640e:	fc843783          	ld	a5,-56(s0)
    80206412:	0007a023          	sw	zero,0(a5)
    80206416:	fe843783          	ld	a5,-24(s0)
    8020641a:	00178713          	addi	a4,a5,1
    8020641e:	fd043783          	ld	a5,-48(s0)
    80206422:	e398                	sd	a4,0(a5)
    80206424:	fd043783          	ld	a5,-48(s0)
    80206428:	639c                	ld	a5,0(a5)
    8020642a:	853e                	mv	a0,a5
    8020642c:	d6bff0ef          	jal	80206196 <trim_line>
    80206430:	fe843783          	ld	a5,-24(s0)
    80206434:	a821                	j	8020644c <find_redirect+0xdc>
    80206436:	fe843783          	ld	a5,-24(s0)
    8020643a:	0785                	addi	a5,a5,1
    8020643c:	fef43423          	sd	a5,-24(s0)
    80206440:	fe843783          	ld	a5,-24(s0)
    80206444:	0007c783          	lbu	a5,0(a5)
    80206448:	fbb9                	bnez	a5,8020639e <find_redirect+0x2e>
    8020644a:	4781                	li	a5,0
    8020644c:	853e                	mv	a0,a5
    8020644e:	70e2                	ld	ra,56(sp)
    80206450:	7442                	ld	s0,48(sp)
    80206452:	6121                	addi	sp,sp,64
    80206454:	8082                	ret

0000000080206456 <is_poweroff_cmd>:
    80206456:	1101                	addi	sp,sp,-32
    80206458:	ec06                	sd	ra,24(sp)
    8020645a:	e822                	sd	s0,16(sp)
    8020645c:	1000                	addi	s0,sp,32
    8020645e:	fea43423          	sd	a0,-24(s0)
    80206462:	00002597          	auipc	a1,0x2
    80206466:	07658593          	addi	a1,a1,118 # 802084d8 <user_code_end+0xb08>
    8020646a:	fe843503          	ld	a0,-24(s0)
    8020646e:	c57ff0ef          	jal	802060c4 <str_eq>
    80206472:	87aa                	mv	a5,a0
    80206474:	e78d                	bnez	a5,8020649e <is_poweroff_cmd+0x48>
    80206476:	00002597          	auipc	a1,0x2
    8020647a:	07258593          	addi	a1,a1,114 # 802084e8 <user_code_end+0xb18>
    8020647e:	fe843503          	ld	a0,-24(s0)
    80206482:	c43ff0ef          	jal	802060c4 <str_eq>
    80206486:	87aa                	mv	a5,a0
    80206488:	eb99                	bnez	a5,8020649e <is_poweroff_cmd+0x48>
    8020648a:	00002597          	auipc	a1,0x2
    8020648e:	06658593          	addi	a1,a1,102 # 802084f0 <user_code_end+0xb20>
    80206492:	fe843503          	ld	a0,-24(s0)
    80206496:	c2fff0ef          	jal	802060c4 <str_eq>
    8020649a:	87aa                	mv	a5,a0
    8020649c:	c399                	beqz	a5,802064a2 <is_poweroff_cmd+0x4c>
    8020649e:	4785                	li	a5,1
    802064a0:	a011                	j	802064a4 <is_poweroff_cmd+0x4e>
    802064a2:	4781                	li	a5,0
    802064a4:	853e                	mv	a0,a5
    802064a6:	60e2                	ld	ra,24(sp)
    802064a8:	6442                	ld	s0,16(sp)
    802064aa:	6105                	addi	sp,sp,32
    802064ac:	8082                	ret

00000000802064ae <put_dec>:
    802064ae:	7139                	addi	sp,sp,-64
    802064b0:	fc06                	sd	ra,56(sp)
    802064b2:	f822                	sd	s0,48(sp)
    802064b4:	0080                	addi	s0,sp,64
    802064b6:	87aa                	mv	a5,a0
    802064b8:	fcf42623          	sw	a5,-52(s0)
    802064bc:	fe042623          	sw	zero,-20(s0)
    802064c0:	fe042423          	sw	zero,-24(s0)
    802064c4:	fcc42783          	lw	a5,-52(s0)
    802064c8:	2781                	sext.w	a5,a5
    802064ca:	0007db63          	bgez	a5,802064e0 <put_dec+0x32>
    802064ce:	4785                	li	a5,1
    802064d0:	fef42423          	sw	a5,-24(s0)
    802064d4:	fcc42783          	lw	a5,-52(s0)
    802064d8:	40f007bb          	negw	a5,a5
    802064dc:	fcf42623          	sw	a5,-52(s0)
    802064e0:	fcc42783          	lw	a5,-52(s0)
    802064e4:	2781                	sext.w	a5,a5
    802064e6:	e3c5                	bnez	a5,80206586 <put_dec+0xd8>
    802064e8:	fec42783          	lw	a5,-20(s0)
    802064ec:	0017871b          	addiw	a4,a5,1
    802064f0:	fee42623          	sw	a4,-20(s0)
    802064f4:	17c1                	addi	a5,a5,-16
    802064f6:	97a2                	add	a5,a5,s0
    802064f8:	03000713          	li	a4,48
    802064fc:	fee78423          	sb	a4,-24(a5)
    80206500:	a841                	j	80206590 <put_dec+0xe2>
    80206502:	fcc42783          	lw	a5,-52(s0)
    80206506:	873e                	mv	a4,a5
    80206508:	0007069b          	sext.w	a3,a4
    8020650c:	666667b7          	lui	a5,0x66666
    80206510:	66778793          	addi	a5,a5,1639 # 66666667 <_heap_size+0x5e78009f>
    80206514:	02f687b3          	mul	a5,a3,a5
    80206518:	9381                	srli	a5,a5,0x20
    8020651a:	4027d79b          	sraiw	a5,a5,0x2
    8020651e:	86be                	mv	a3,a5
    80206520:	41f7579b          	sraiw	a5,a4,0x1f
    80206524:	40f687bb          	subw	a5,a3,a5
    80206528:	86be                	mv	a3,a5
    8020652a:	87b6                	mv	a5,a3
    8020652c:	0027979b          	slliw	a5,a5,0x2
    80206530:	9fb5                	addw	a5,a5,a3
    80206532:	0017979b          	slliw	a5,a5,0x1
    80206536:	40f707bb          	subw	a5,a4,a5
    8020653a:	2781                	sext.w	a5,a5
    8020653c:	0ff7f713          	zext.b	a4,a5
    80206540:	fec42783          	lw	a5,-20(s0)
    80206544:	0017869b          	addiw	a3,a5,1
    80206548:	fed42623          	sw	a3,-20(s0)
    8020654c:	0307071b          	addiw	a4,a4,48
    80206550:	0ff77713          	zext.b	a4,a4
    80206554:	17c1                	addi	a5,a5,-16
    80206556:	97a2                	add	a5,a5,s0
    80206558:	fee78423          	sb	a4,-24(a5)
    8020655c:	fcc42783          	lw	a5,-52(s0)
    80206560:	86be                	mv	a3,a5
    80206562:	0006871b          	sext.w	a4,a3
    80206566:	666667b7          	lui	a5,0x66666
    8020656a:	66778793          	addi	a5,a5,1639 # 66666667 <_heap_size+0x5e78009f>
    8020656e:	02f707b3          	mul	a5,a4,a5
    80206572:	9381                	srli	a5,a5,0x20
    80206574:	4027d79b          	sraiw	a5,a5,0x2
    80206578:	873e                	mv	a4,a5
    8020657a:	41f6d79b          	sraiw	a5,a3,0x1f
    8020657e:	40f707bb          	subw	a5,a4,a5
    80206582:	fcf42623          	sw	a5,-52(s0)
    80206586:	fcc42783          	lw	a5,-52(s0)
    8020658a:	2781                	sext.w	a5,a5
    8020658c:	f6f04be3          	bgtz	a5,80206502 <put_dec+0x54>
    80206590:	fe842783          	lw	a5,-24(s0)
    80206594:	2781                	sext.w	a5,a5
    80206596:	c785                	beqz	a5,802065be <put_dec+0x110>
    80206598:	02d00513          	li	a0,45
    8020659c:	eb9fa0ef          	jal	80201454 <uart_putc>
    802065a0:	a839                	j	802065be <put_dec+0x110>
    802065a2:	fec42783          	lw	a5,-20(s0)
    802065a6:	37fd                	addiw	a5,a5,-1
    802065a8:	fef42623          	sw	a5,-20(s0)
    802065ac:	fec42783          	lw	a5,-20(s0)
    802065b0:	17c1                	addi	a5,a5,-16
    802065b2:	97a2                	add	a5,a5,s0
    802065b4:	fe87c783          	lbu	a5,-24(a5)
    802065b8:	853e                	mv	a0,a5
    802065ba:	e9bfa0ef          	jal	80201454 <uart_putc>
    802065be:	fec42783          	lw	a5,-20(s0)
    802065c2:	2781                	sext.w	a5,a5
    802065c4:	fcf04fe3          	bgtz	a5,802065a2 <put_dec+0xf4>
    802065c8:	0001                	nop
    802065ca:	0001                	nop
    802065cc:	70e2                	ld	ra,56(sp)
    802065ce:	7442                	ld	s0,48(sp)
    802065d0:	6121                	addi	sp,sp,64
    802065d2:	8082                	ret

00000000802065d4 <cmd_ps>:
    802065d4:	7141                	addi	sp,sp,-496
    802065d6:	f786                	sd	ra,488(sp)
    802065d8:	f3a2                	sd	s0,480(sp)
    802065da:	1b80                	addi	s0,sp,496
    802065dc:	87aa                	mv	a5,a0
    802065de:	e0f42e23          	sw	a5,-484(s0)
    802065e2:	e2040793          	addi	a5,s0,-480
    802065e6:	45c1                	li	a1,16
    802065e8:	853e                	mv	a0,a5
    802065ea:	cf7fc0ef          	jal	802032e0 <proc_list>
    802065ee:	87aa                	mv	a5,a0
    802065f0:	fef42223          	sw	a5,-28(s0)
    802065f4:	00002517          	auipc	a0,0x2
    802065f8:	f0c50513          	addi	a0,a0,-244 # 80208500 <user_code_end+0xb30>
    802065fc:	ea7fa0ef          	jal	802014a2 <uart_puts>
    80206600:	fe042423          	sw	zero,-24(s0)
    80206604:	a0ed                	j	802066ee <cmd_ps+0x11a>
    80206606:	fe842703          	lw	a4,-24(s0)
    8020660a:	87ba                	mv	a5,a4
    8020660c:	078e                	slli	a5,a5,0x3
    8020660e:	8f99                	sub	a5,a5,a4
    80206610:	078a                	slli	a5,a5,0x2
    80206612:	17c1                	addi	a5,a5,-16
    80206614:	97a2                	add	a5,a5,s0
    80206616:	e387a783          	lw	a5,-456(a5)
    8020661a:	470d                	li	a4,3
    8020661c:	02e78563          	beq	a5,a4,80206646 <cmd_ps+0x72>
    80206620:	470d                	li	a4,3
    80206622:	02f76763          	bltu	a4,a5,80206650 <cmd_ps+0x7c>
    80206626:	4705                	li	a4,1
    80206628:	00e78a63          	beq	a5,a4,8020663c <cmd_ps+0x68>
    8020662c:	4709                	li	a4,2
    8020662e:	02e79163          	bne	a5,a4,80206650 <cmd_ps+0x7c>
    80206632:	05200793          	li	a5,82
    80206636:	fef407a3          	sb	a5,-17(s0)
    8020663a:	a005                	j	8020665a <cmd_ps+0x86>
    8020663c:	05300793          	li	a5,83
    80206640:	fef407a3          	sb	a5,-17(s0)
    80206644:	a819                	j	8020665a <cmd_ps+0x86>
    80206646:	05a00793          	li	a5,90
    8020664a:	fef407a3          	sb	a5,-17(s0)
    8020664e:	a031                	j	8020665a <cmd_ps+0x86>
    80206650:	03f00793          	li	a5,63
    80206654:	fef407a3          	sb	a5,-17(s0)
    80206658:	0001                	nop
    8020665a:	00002517          	auipc	a0,0x2
    8020665e:	ec650513          	addi	a0,a0,-314 # 80208520 <user_code_end+0xb50>
    80206662:	e41fa0ef          	jal	802014a2 <uart_puts>
    80206666:	fe842703          	lw	a4,-24(s0)
    8020666a:	87ba                	mv	a5,a4
    8020666c:	078e                	slli	a5,a5,0x3
    8020666e:	8f99                	sub	a5,a5,a4
    80206670:	078a                	slli	a5,a5,0x2
    80206672:	17c1                	addi	a5,a5,-16
    80206674:	97a2                	add	a5,a5,s0
    80206676:	e307a783          	lw	a5,-464(a5)
    8020667a:	853e                	mv	a0,a5
    8020667c:	e33ff0ef          	jal	802064ae <put_dec>
    80206680:	02000513          	li	a0,32
    80206684:	dd1fa0ef          	jal	80201454 <uart_putc>
    80206688:	fe842703          	lw	a4,-24(s0)
    8020668c:	87ba                	mv	a5,a4
    8020668e:	078e                	slli	a5,a5,0x3
    80206690:	8f99                	sub	a5,a5,a4
    80206692:	078a                	slli	a5,a5,0x2
    80206694:	17c1                	addi	a5,a5,-16
    80206696:	97a2                	add	a5,a5,s0
    80206698:	e347a783          	lw	a5,-460(a5)
    8020669c:	853e                	mv	a0,a5
    8020669e:	e11ff0ef          	jal	802064ae <put_dec>
    802066a2:	00002517          	auipc	a0,0x2
    802066a6:	e8650513          	addi	a0,a0,-378 # 80208528 <user_code_end+0xb58>
    802066aa:	df9fa0ef          	jal	802014a2 <uart_puts>
    802066ae:	fef44783          	lbu	a5,-17(s0)
    802066b2:	853e                	mv	a0,a5
    802066b4:	da1fa0ef          	jal	80201454 <uart_putc>
    802066b8:	00002517          	auipc	a0,0x2
    802066bc:	e7850513          	addi	a0,a0,-392 # 80208530 <user_code_end+0xb60>
    802066c0:	de3fa0ef          	jal	802014a2 <uart_puts>
    802066c4:	e2040693          	addi	a3,s0,-480
    802066c8:	fe842703          	lw	a4,-24(s0)
    802066cc:	87ba                	mv	a5,a4
    802066ce:	078e                	slli	a5,a5,0x3
    802066d0:	8f99                	sub	a5,a5,a4
    802066d2:	078a                	slli	a5,a5,0x2
    802066d4:	97b6                	add	a5,a5,a3
    802066d6:	07b1                	addi	a5,a5,12
    802066d8:	853e                	mv	a0,a5
    802066da:	dc9fa0ef          	jal	802014a2 <uart_puts>
    802066de:	4529                	li	a0,10
    802066e0:	d75fa0ef          	jal	80201454 <uart_putc>
    802066e4:	fe842783          	lw	a5,-24(s0)
    802066e8:	2785                	addiw	a5,a5,1
    802066ea:	fef42423          	sw	a5,-24(s0)
    802066ee:	fe842783          	lw	a5,-24(s0)
    802066f2:	873e                	mv	a4,a5
    802066f4:	fe442783          	lw	a5,-28(s0)
    802066f8:	2701                	sext.w	a4,a4
    802066fa:	2781                	sext.w	a5,a5
    802066fc:	f0f745e3          	blt	a4,a5,80206606 <cmd_ps+0x32>
    80206700:	e1c42783          	lw	a5,-484(s0)
    80206704:	2781                	sext.w	a5,a5
    80206706:	c799                	beqz	a5,80206714 <cmd_ps+0x140>
    80206708:	00002517          	auipc	a0,0x2
    8020670c:	e3050513          	addi	a0,a0,-464 # 80208538 <user_code_end+0xb68>
    80206710:	d93fa0ef          	jal	802014a2 <uart_puts>
    80206714:	0001                	nop
    80206716:	70be                	ld	ra,488(sp)
    80206718:	741e                	ld	s0,480(sp)
    8020671a:	617d                	addi	sp,sp,496
    8020671c:	8082                	ret

000000008020671e <ls_emit>:
    8020671e:	7179                	addi	sp,sp,-48
    80206720:	f406                	sd	ra,40(sp)
    80206722:	f022                	sd	s0,32(sp)
    80206724:	1800                	addi	s0,sp,48
    80206726:	fea43423          	sd	a0,-24(s0)
    8020672a:	87ae                	mv	a5,a1
    8020672c:	8736                	mv	a4,a3
    8020672e:	fef42223          	sw	a5,-28(s0)
    80206732:	87b2                	mv	a5,a2
    80206734:	fef42023          	sw	a5,-32(s0)
    80206738:	87ba                	mv	a5,a4
    8020673a:	fcf42e23          	sw	a5,-36(s0)
    8020673e:	00002517          	auipc	a0,0x2
    80206742:	df250513          	addi	a0,a0,-526 # 80208530 <user_code_end+0xb60>
    80206746:	d5dfa0ef          	jal	802014a2 <uart_puts>
    8020674a:	fe042783          	lw	a5,-32(s0)
    8020674e:	2781                	sext.w	a5,a5
    80206750:	c791                	beqz	a5,8020675c <ls_emit+0x3e>
    80206752:	06400513          	li	a0,100
    80206756:	cfffa0ef          	jal	80201454 <uart_putc>
    8020675a:	a831                	j	80206776 <ls_emit+0x58>
    8020675c:	fdc42783          	lw	a5,-36(s0)
    80206760:	2781                	sext.w	a5,a5
    80206762:	c791                	beqz	a5,8020676e <ls_emit+0x50>
    80206764:	07800513          	li	a0,120
    80206768:	cedfa0ef          	jal	80201454 <uart_putc>
    8020676c:	a029                	j	80206776 <ls_emit+0x58>
    8020676e:	02d00513          	li	a0,45
    80206772:	ce3fa0ef          	jal	80201454 <uart_putc>
    80206776:	02000513          	li	a0,32
    8020677a:	cdbfa0ef          	jal	80201454 <uart_putc>
    8020677e:	fe843503          	ld	a0,-24(s0)
    80206782:	d21fa0ef          	jal	802014a2 <uart_puts>
    80206786:	fe042783          	lw	a5,-32(s0)
    8020678a:	2781                	sext.w	a5,a5
    8020678c:	e395                	bnez	a5,802067b0 <ls_emit+0x92>
    8020678e:	00002517          	auipc	a0,0x2
    80206792:	dba50513          	addi	a0,a0,-582 # 80208548 <user_code_end+0xb78>
    80206796:	d0dfa0ef          	jal	802014a2 <uart_puts>
    8020679a:	fe442783          	lw	a5,-28(s0)
    8020679e:	853e                	mv	a0,a5
    802067a0:	d0fff0ef          	jal	802064ae <put_dec>
    802067a4:	00002517          	auipc	a0,0x2
    802067a8:	dac50513          	addi	a0,a0,-596 # 80208550 <user_code_end+0xb80>
    802067ac:	cf7fa0ef          	jal	802014a2 <uart_puts>
    802067b0:	4529                	li	a0,10
    802067b2:	ca3fa0ef          	jal	80201454 <uart_putc>
    802067b6:	0001                	nop
    802067b8:	70a2                	ld	ra,40(sp)
    802067ba:	7402                	ld	s0,32(sp)
    802067bc:	6145                	addi	sp,sp,48
    802067be:	8082                	ret

00000000802067c0 <cmd_ls>:
    802067c0:	7179                	addi	sp,sp,-48
    802067c2:	f406                	sd	ra,40(sp)
    802067c4:	f022                	sd	s0,32(sp)
    802067c6:	1800                	addi	s0,sp,48
    802067c8:	fca43c23          	sd	a0,-40(s0)
    802067cc:	fd843783          	ld	a5,-40(s0)
    802067d0:	c791                	beqz	a5,802067dc <cmd_ls+0x1c>
    802067d2:	fd843783          	ld	a5,-40(s0)
    802067d6:	0007c783          	lbu	a5,0(a5)
    802067da:	e791                	bnez	a5,802067e6 <cmd_ls+0x26>
    802067dc:	d23fe0ef          	jal	802054fe <fs_getcwd>
    802067e0:	fea43423          	sd	a0,-24(s0)
    802067e4:	a029                	j	802067ee <cmd_ls+0x2e>
    802067e6:	fd843783          	ld	a5,-40(s0)
    802067ea:	fef43423          	sd	a5,-24(s0)
    802067ee:	fe843503          	ld	a0,-24(s0)
    802067f2:	cb1fa0ef          	jal	802014a2 <uart_puts>
    802067f6:	00002517          	auipc	a0,0x2
    802067fa:	d6250513          	addi	a0,a0,-670 # 80208558 <user_code_end+0xb88>
    802067fe:	ca5fa0ef          	jal	802014a2 <uart_puts>
    80206802:	00000597          	auipc	a1,0x0
    80206806:	f1c58593          	addi	a1,a1,-228 # 8020671e <ls_emit>
    8020680a:	fe843503          	ld	a0,-24(s0)
    8020680e:	d79fe0ef          	jal	80205586 <fs_listdir>
    80206812:	87aa                	mv	a5,a0
    80206814:	ef89                	bnez	a5,8020682e <cmd_ls+0x6e>
    80206816:	fe843503          	ld	a0,-24(s0)
    8020681a:	c65fe0ef          	jal	8020547e <fs_is_dir>
    8020681e:	87aa                	mv	a5,a0
    80206820:	e799                	bnez	a5,8020682e <cmd_ls+0x6e>
    80206822:	00002517          	auipc	a0,0x2
    80206826:	d3e50513          	addi	a0,a0,-706 # 80208560 <user_code_end+0xb90>
    8020682a:	c79fa0ef          	jal	802014a2 <uart_puts>
    8020682e:	0001                	nop
    80206830:	70a2                	ld	ra,40(sp)
    80206832:	7402                	ld	s0,32(sp)
    80206834:	6145                	addi	sp,sp,48
    80206836:	8082                	ret

0000000080206838 <cmd_pwd>:
    80206838:	1141                	addi	sp,sp,-16
    8020683a:	e406                	sd	ra,8(sp)
    8020683c:	e022                	sd	s0,0(sp)
    8020683e:	0800                	addi	s0,sp,16
    80206840:	cbffe0ef          	jal	802054fe <fs_getcwd>
    80206844:	87aa                	mv	a5,a0
    80206846:	853e                	mv	a0,a5
    80206848:	c5bfa0ef          	jal	802014a2 <uart_puts>
    8020684c:	4529                	li	a0,10
    8020684e:	c07fa0ef          	jal	80201454 <uart_putc>
    80206852:	0001                	nop
    80206854:	60a2                	ld	ra,8(sp)
    80206856:	6402                	ld	s0,0(sp)
    80206858:	0141                	addi	sp,sp,16
    8020685a:	8082                	ret

000000008020685c <cmd_cd>:
    8020685c:	7179                	addi	sp,sp,-48
    8020685e:	f406                	sd	ra,40(sp)
    80206860:	f022                	sd	s0,32(sp)
    80206862:	1800                	addi	s0,sp,48
    80206864:	fca43c23          	sd	a0,-40(s0)
    80206868:	fd843783          	ld	a5,-40(s0)
    8020686c:	cb99                	beqz	a5,80206882 <cmd_cd+0x26>
    8020686e:	fd843783          	ld	a5,-40(s0)
    80206872:	0007c783          	lbu	a5,0(a5)
    80206876:	c791                	beqz	a5,80206882 <cmd_cd+0x26>
    80206878:	fd843783          	ld	a5,-40(s0)
    8020687c:	fef43423          	sd	a5,-24(s0)
    80206880:	a039                	j	8020688e <cmd_cd+0x32>
    80206882:	00002797          	auipc	a5,0x2
    80206886:	cf678793          	addi	a5,a5,-778 # 80208578 <user_code_end+0xba8>
    8020688a:	fef43423          	sd	a5,-24(s0)
    8020688e:	fe843503          	ld	a0,-24(s0)
    80206892:	c87fe0ef          	jal	80205518 <fs_chdir>
    80206896:	87aa                	mv	a5,a0
    80206898:	0007d863          	bgez	a5,802068a8 <cmd_cd+0x4c>
    8020689c:	00002517          	auipc	a0,0x2
    802068a0:	cec50513          	addi	a0,a0,-788 # 80208588 <user_code_end+0xbb8>
    802068a4:	bfffa0ef          	jal	802014a2 <uart_puts>
    802068a8:	0001                	nop
    802068aa:	70a2                	ld	ra,40(sp)
    802068ac:	7402                	ld	s0,32(sp)
    802068ae:	6145                	addi	sp,sp,48
    802068b0:	8082                	ret

00000000802068b2 <cmd_cat>:
    802068b2:	7169                	addi	sp,sp,-304
    802068b4:	f606                	sd	ra,296(sp)
    802068b6:	f222                	sd	s0,288(sp)
    802068b8:	1a00                	addi	s0,sp,304
    802068ba:	eca43c23          	sd	a0,-296(s0)
    802068be:	4581                	li	a1,0
    802068c0:	ed843503          	ld	a0,-296(s0)
    802068c4:	f77fe0ef          	jal	8020583a <fs_open>
    802068c8:	87aa                	mv	a5,a0
    802068ca:	fef42623          	sw	a5,-20(s0)
    802068ce:	fec42783          	lw	a5,-20(s0)
    802068d2:	2781                	sext.w	a5,a5
    802068d4:	0007db63          	bgez	a5,802068ea <cmd_cat+0x38>
    802068d8:	ed843583          	ld	a1,-296(s0)
    802068dc:	00002517          	auipc	a0,0x2
    802068e0:	cc450513          	addi	a0,a0,-828 # 802085a0 <user_code_end+0xbd0>
    802068e4:	fd2fa0ef          	jal	802010b6 <printf>
    802068e8:	a88d                	j	8020695a <cmd_cat+0xa8>
    802068ea:	ee840713          	addi	a4,s0,-280
    802068ee:	fec42783          	lw	a5,-20(s0)
    802068f2:	0ff00613          	li	a2,255
    802068f6:	85ba                	mv	a1,a4
    802068f8:	853e                	mv	a0,a5
    802068fa:	8baff0ef          	jal	802059b4 <fs_read>
    802068fe:	87aa                	mv	a5,a0
    80206900:	fef42423          	sw	a5,-24(s0)
    80206904:	fec42783          	lw	a5,-20(s0)
    80206908:	853e                	mv	a0,a5
    8020690a:	bc0ff0ef          	jal	80205cca <fs_close>
    8020690e:	fe842783          	lw	a5,-24(s0)
    80206912:	2781                	sext.w	a5,a5
    80206914:	00f04963          	bgtz	a5,80206926 <cmd_cat+0x74>
    80206918:	00002517          	auipc	a0,0x2
    8020691c:	ca050513          	addi	a0,a0,-864 # 802085b8 <user_code_end+0xbe8>
    80206920:	b83fa0ef          	jal	802014a2 <uart_puts>
    80206924:	a81d                	j	8020695a <cmd_cat+0xa8>
    80206926:	fe842783          	lw	a5,-24(s0)
    8020692a:	17c1                	addi	a5,a5,-16
    8020692c:	97a2                	add	a5,a5,s0
    8020692e:	ee078c23          	sb	zero,-264(a5)
    80206932:	ee840793          	addi	a5,s0,-280
    80206936:	853e                	mv	a0,a5
    80206938:	b6bfa0ef          	jal	802014a2 <uart_puts>
    8020693c:	fe842783          	lw	a5,-24(s0)
    80206940:	37fd                	addiw	a5,a5,-1
    80206942:	2781                	sext.w	a5,a5
    80206944:	17c1                	addi	a5,a5,-16
    80206946:	97a2                	add	a5,a5,s0
    80206948:	ef87c783          	lbu	a5,-264(a5)
    8020694c:	873e                	mv	a4,a5
    8020694e:	47a9                	li	a5,10
    80206950:	00f70563          	beq	a4,a5,8020695a <cmd_cat+0xa8>
    80206954:	4529                	li	a0,10
    80206956:	afffa0ef          	jal	80201454 <uart_putc>
    8020695a:	70b2                	ld	ra,296(sp)
    8020695c:	7412                	ld	s0,288(sp)
    8020695e:	6155                	addi	sp,sp,304
    80206960:	8082                	ret

0000000080206962 <cmd_echo>:
    80206962:	7129                	addi	sp,sp,-320
    80206964:	fe06                	sd	ra,312(sp)
    80206966:	fa22                	sd	s0,304(sp)
    80206968:	0280                	addi	s0,sp,320
    8020696a:	eca43c23          	sd	a0,-296(s0)
    8020696e:	ecb43823          	sd	a1,-304(s0)
    80206972:	87b2                	mv	a5,a2
    80206974:	ecf42623          	sw	a5,-308(s0)
    80206978:	ed043783          	ld	a5,-304(s0)
    8020697c:	12078c63          	beqz	a5,80206ab4 <cmd_echo+0x152>
    80206980:	ed043783          	ld	a5,-304(s0)
    80206984:	0007c783          	lbu	a5,0(a5)
    80206988:	12078663          	beqz	a5,80206ab4 <cmd_echo+0x152>
    8020698c:	ecc42783          	lw	a5,-308(s0)
    80206990:	2781                	sext.w	a5,a5
    80206992:	c7d9                	beqz	a5,80206a20 <cmd_echo+0xbe>
    80206994:	45d5                	li	a1,21
    80206996:	ed043503          	ld	a0,-304(s0)
    8020699a:	ea1fe0ef          	jal	8020583a <fs_open>
    8020699e:	87aa                	mv	a5,a0
    802069a0:	fef42023          	sw	a5,-32(s0)
    802069a4:	fe042783          	lw	a5,-32(s0)
    802069a8:	2781                	sext.w	a5,a5
    802069aa:	0007d963          	bgez	a5,802069bc <cmd_echo+0x5a>
    802069ae:	00002517          	auipc	a0,0x2
    802069b2:	c1a50513          	addi	a0,a0,-998 # 802085c8 <user_code_end+0xbf8>
    802069b6:	aedfa0ef          	jal	802014a2 <uart_puts>
    802069ba:	aa21                	j	80206ad2 <cmd_echo+0x170>
    802069bc:	ed843783          	ld	a5,-296(s0)
    802069c0:	c3a1                	beqz	a5,80206a00 <cmd_echo+0x9e>
    802069c2:	ed843783          	ld	a5,-296(s0)
    802069c6:	0007c783          	lbu	a5,0(a5)
    802069ca:	cb9d                	beqz	a5,80206a00 <cmd_echo+0x9e>
    802069cc:	fe042623          	sw	zero,-20(s0)
    802069d0:	a031                	j	802069dc <cmd_echo+0x7a>
    802069d2:	fec42783          	lw	a5,-20(s0)
    802069d6:	2785                	addiw	a5,a5,1
    802069d8:	fef42623          	sw	a5,-20(s0)
    802069dc:	fec42783          	lw	a5,-20(s0)
    802069e0:	ed843703          	ld	a4,-296(s0)
    802069e4:	97ba                	add	a5,a5,a4
    802069e6:	0007c783          	lbu	a5,0(a5)
    802069ea:	f7e5                	bnez	a5,802069d2 <cmd_echo+0x70>
    802069ec:	fec42703          	lw	a4,-20(s0)
    802069f0:	fe042783          	lw	a5,-32(s0)
    802069f4:	863a                	mv	a2,a4
    802069f6:	ed843583          	ld	a1,-296(s0)
    802069fa:	853e                	mv	a0,a5
    802069fc:	8d4ff0ef          	jal	80205ad0 <fs_write>
    80206a00:	fe042783          	lw	a5,-32(s0)
    80206a04:	4605                	li	a2,1
    80206a06:	00002597          	auipc	a1,0x2
    80206a0a:	bda58593          	addi	a1,a1,-1062 # 802085e0 <user_code_end+0xc10>
    80206a0e:	853e                	mv	a0,a5
    80206a10:	8c0ff0ef          	jal	80205ad0 <fs_write>
    80206a14:	fe042783          	lw	a5,-32(s0)
    80206a18:	853e                	mv	a0,a5
    80206a1a:	ab0ff0ef          	jal	80205cca <fs_close>
    80206a1e:	a855                	j	80206ad2 <cmd_echo+0x170>
    80206a20:	fe042423          	sw	zero,-24(s0)
    80206a24:	fe042223          	sw	zero,-28(s0)
    80206a28:	ed843783          	ld	a5,-296(s0)
    80206a2c:	cfa9                	beqz	a5,80206a86 <cmd_echo+0x124>
    80206a2e:	ed843783          	ld	a5,-296(s0)
    80206a32:	0007c783          	lbu	a5,0(a5)
    80206a36:	cba1                	beqz	a5,80206a86 <cmd_echo+0x124>
    80206a38:	a03d                	j	80206a66 <cmd_echo+0x104>
    80206a3a:	fe442783          	lw	a5,-28(s0)
    80206a3e:	0017871b          	addiw	a4,a5,1
    80206a42:	fee42223          	sw	a4,-28(s0)
    80206a46:	873e                	mv	a4,a5
    80206a48:	ed843783          	ld	a5,-296(s0)
    80206a4c:	973e                	add	a4,a4,a5
    80206a4e:	fe842783          	lw	a5,-24(s0)
    80206a52:	0017869b          	addiw	a3,a5,1
    80206a56:	fed42423          	sw	a3,-24(s0)
    80206a5a:	00074703          	lbu	a4,0(a4)
    80206a5e:	17c1                	addi	a5,a5,-16
    80206a60:	97a2                	add	a5,a5,s0
    80206a62:	eee78823          	sb	a4,-272(a5)
    80206a66:	fe442783          	lw	a5,-28(s0)
    80206a6a:	ed843703          	ld	a4,-296(s0)
    80206a6e:	97ba                	add	a5,a5,a4
    80206a70:	0007c783          	lbu	a5,0(a5)
    80206a74:	cb89                	beqz	a5,80206a86 <cmd_echo+0x124>
    80206a76:	fe842783          	lw	a5,-24(s0)
    80206a7a:	0007871b          	sext.w	a4,a5
    80206a7e:	0fd00793          	li	a5,253
    80206a82:	fae7dce3          	bge	a5,a4,80206a3a <cmd_echo+0xd8>
    80206a86:	fe842783          	lw	a5,-24(s0)
    80206a8a:	0017871b          	addiw	a4,a5,1
    80206a8e:	fee42423          	sw	a4,-24(s0)
    80206a92:	17c1                	addi	a5,a5,-16
    80206a94:	97a2                	add	a5,a5,s0
    80206a96:	4729                	li	a4,10
    80206a98:	eee78823          	sb	a4,-272(a5)
    80206a9c:	fe842703          	lw	a4,-24(s0)
    80206aa0:	ee040793          	addi	a5,s0,-288
    80206aa4:	4685                	li	a3,1
    80206aa6:	863a                	mv	a2,a4
    80206aa8:	85be                	mv	a1,a5
    80206aaa:	ed043503          	ld	a0,-304(s0)
    80206aae:	ac8ff0ef          	jal	80205d76 <fs_write_file>
    80206ab2:	a005                	j	80206ad2 <cmd_echo+0x170>
    80206ab4:	ed843783          	ld	a5,-296(s0)
    80206ab8:	cf89                	beqz	a5,80206ad2 <cmd_echo+0x170>
    80206aba:	ed843783          	ld	a5,-296(s0)
    80206abe:	0007c783          	lbu	a5,0(a5)
    80206ac2:	cb81                	beqz	a5,80206ad2 <cmd_echo+0x170>
    80206ac4:	ed843503          	ld	a0,-296(s0)
    80206ac8:	9dbfa0ef          	jal	802014a2 <uart_puts>
    80206acc:	4529                	li	a0,10
    80206ace:	987fa0ef          	jal	80201454 <uart_putc>
    80206ad2:	70f2                	ld	ra,312(sp)
    80206ad4:	7452                	ld	s0,304(sp)
    80206ad6:	6131                	addi	sp,sp,320
    80206ad8:	8082                	ret

0000000080206ada <cmd_touch>:
    80206ada:	1101                	addi	sp,sp,-32
    80206adc:	ec06                	sd	ra,24(sp)
    80206ade:	e822                	sd	s0,16(sp)
    80206ae0:	1000                	addi	s0,sp,32
    80206ae2:	fea43423          	sd	a0,-24(s0)
    80206ae6:	4581                	li	a1,0
    80206ae8:	fe843503          	ld	a0,-24(s0)
    80206aec:	fe8fe0ef          	jal	802052d4 <fs_create>
    80206af0:	87aa                	mv	a5,a0
    80206af2:	0007de63          	bgez	a5,80206b0e <cmd_touch+0x34>
    80206af6:	fe843503          	ld	a0,-24(s0)
    80206afa:	95bfe0ef          	jal	80205454 <fs_exists>
    80206afe:	87aa                	mv	a5,a0
    80206b00:	e799                	bnez	a5,80206b0e <cmd_touch+0x34>
    80206b02:	00002517          	auipc	a0,0x2
    80206b06:	ae650513          	addi	a0,a0,-1306 # 802085e8 <user_code_end+0xc18>
    80206b0a:	999fa0ef          	jal	802014a2 <uart_puts>
    80206b0e:	0001                	nop
    80206b10:	60e2                	ld	ra,24(sp)
    80206b12:	6442                	ld	s0,16(sp)
    80206b14:	6105                	addi	sp,sp,32
    80206b16:	8082                	ret

0000000080206b18 <shell_irq_save>:
    80206b18:	1101                	addi	sp,sp,-32
    80206b1a:	ec06                	sd	ra,24(sp)
    80206b1c:	e822                	sd	s0,16(sp)
    80206b1e:	1000                	addi	s0,sp,32
    80206b20:	d26ff0ef          	jal	80206046 <r_sstatus>
    80206b24:	fea43423          	sd	a0,-24(s0)
    80206b28:	d5aff0ef          	jal	80206082 <cpu_irq_disable>
    80206b2c:	fe843783          	ld	a5,-24(s0)
    80206b30:	853e                	mv	a0,a5
    80206b32:	60e2                	ld	ra,24(sp)
    80206b34:	6442                	ld	s0,16(sp)
    80206b36:	6105                	addi	sp,sp,32
    80206b38:	8082                	ret

0000000080206b3a <shell_irq_restore>:
    80206b3a:	1101                	addi	sp,sp,-32
    80206b3c:	ec06                	sd	ra,24(sp)
    80206b3e:	e822                	sd	s0,16(sp)
    80206b40:	1000                	addi	s0,sp,32
    80206b42:	fea43423          	sd	a0,-24(s0)
    80206b46:	fe843783          	ld	a5,-24(s0)
    80206b4a:	8b89                	andi	a5,a5,2
    80206b4c:	c399                	beqz	a5,80206b52 <shell_irq_restore+0x18>
    80206b4e:	d54ff0ef          	jal	802060a2 <cpu_irq_enable>
    80206b52:	0001                	nop
    80206b54:	60e2                	ld	ra,24(sp)
    80206b56:	6442                	ld	s0,16(sp)
    80206b58:	6105                	addi	sp,sp,32
    80206b5a:	8082                	ret

0000000080206b5c <login_name_plausible>:
    80206b5c:	7179                	addi	sp,sp,-48
    80206b5e:	f406                	sd	ra,40(sp)
    80206b60:	f022                	sd	s0,32(sp)
    80206b62:	1800                	addi	s0,sp,48
    80206b64:	fca43c23          	sd	a0,-40(s0)
    80206b68:	fe042623          	sw	zero,-20(s0)
    80206b6c:	a891                	j	80206bc0 <login_name_plausible+0x64>
    80206b6e:	fec42783          	lw	a5,-20(s0)
    80206b72:	fd843703          	ld	a4,-40(s0)
    80206b76:	97ba                	add	a5,a5,a4
    80206b78:	0007c783          	lbu	a5,0(a5)
    80206b7c:	fef405a3          	sb	a5,-21(s0)
    80206b80:	feb44783          	lbu	a5,-21(s0)
    80206b84:	0ff7f713          	zext.b	a4,a5
    80206b88:	06000793          	li	a5,96
    80206b8c:	00e7fa63          	bgeu	a5,a4,80206ba0 <login_name_plausible+0x44>
    80206b90:	feb44783          	lbu	a5,-21(s0)
    80206b94:	0ff7f713          	zext.b	a4,a5
    80206b98:	07a00793          	li	a5,122
    80206b9c:	00e7f463          	bgeu	a5,a4,80206ba4 <login_name_plausible+0x48>
    80206ba0:	4781                	li	a5,0
    80206ba2:	a83d                	j	80206be0 <login_name_plausible+0x84>
    80206ba4:	fec42783          	lw	a5,-20(s0)
    80206ba8:	2785                	addiw	a5,a5,1
    80206baa:	fef42623          	sw	a5,-20(s0)
    80206bae:	fec42783          	lw	a5,-20(s0)
    80206bb2:	0007871b          	sext.w	a4,a5
    80206bb6:	47a1                	li	a5,8
    80206bb8:	00e7d463          	bge	a5,a4,80206bc0 <login_name_plausible+0x64>
    80206bbc:	4781                	li	a5,0
    80206bbe:	a00d                	j	80206be0 <login_name_plausible+0x84>
    80206bc0:	fec42783          	lw	a5,-20(s0)
    80206bc4:	fd843703          	ld	a4,-40(s0)
    80206bc8:	97ba                	add	a5,a5,a4
    80206bca:	0007c783          	lbu	a5,0(a5)
    80206bce:	f3c5                	bnez	a5,80206b6e <login_name_plausible+0x12>
    80206bd0:	fec42783          	lw	a5,-20(s0)
    80206bd4:	2781                	sext.w	a5,a5
    80206bd6:	00f027b3          	sgtz	a5,a5
    80206bda:	0ff7f793          	zext.b	a5,a5
    80206bde:	2781                	sext.w	a5,a5
    80206be0:	853e                	mv	a0,a5
    80206be2:	70a2                	ld	ra,40(sp)
    80206be4:	7402                	ld	s0,32(sp)
    80206be6:	6145                	addi	sp,sp,48
    80206be8:	8082                	ret

0000000080206bea <login_session>:
    80206bea:	7175                	addi	sp,sp,-144
    80206bec:	e506                	sd	ra,136(sp)
    80206bee:	e122                	sd	s0,128(sp)
    80206bf0:	0900                	addi	s0,sp,144
    80206bf2:	00002517          	auipc	a0,0x2
    80206bf6:	a0650513          	addi	a0,a0,-1530 # 802085f8 <user_code_end+0xc28>
    80206bfa:	8a9fa0ef          	jal	802014a2 <uart_puts>
    80206bfe:	961fa0ef          	jal	8020155e <uart_rx_flush>
    80206c02:	ca0ff0ef          	jal	802060a2 <cpu_irq_enable>
    80206c06:	f7040793          	addi	a5,s0,-144
    80206c0a:	08000593          	li	a1,128
    80206c0e:	853e                	mv	a0,a5
    80206c10:	ad7fa0ef          	jal	802016e6 <uart_read_line>
    80206c14:	87aa                	mv	a5,a0
    80206c16:	06f05063          	blez	a5,80206c76 <login_session+0x8c>
    80206c1a:	f7040793          	addi	a5,s0,-144
    80206c1e:	853e                	mv	a0,a5
    80206c20:	d76ff0ef          	jal	80206196 <trim_line>
    80206c24:	f7044783          	lbu	a5,-144(s0)
    80206c28:	cba9                	beqz	a5,80206c7a <login_session+0x90>
    80206c2a:	f7040793          	addi	a5,s0,-144
    80206c2e:	853e                	mv	a0,a5
    80206c30:	f2dff0ef          	jal	80206b5c <login_name_plausible>
    80206c34:	87aa                	mv	a5,a0
    80206c36:	c7a1                	beqz	a5,80206c7e <login_session+0x94>
    80206c38:	f7040793          	addi	a5,s0,-144
    80206c3c:	853e                	mv	a0,a5
    80206c3e:	819ff0ef          	jal	80206456 <is_poweroff_cmd>
    80206c42:	87aa                	mv	a5,a0
    80206c44:	c399                	beqz	a5,80206c4a <login_session+0x60>
    80206c46:	efbf90ef          	jal	80200b40 <machine_poweroff>
    80206c4a:	f7040793          	addi	a5,s0,-144
    80206c4e:	00002597          	auipc	a1,0x2
    80206c52:	9ca58593          	addi	a1,a1,-1590 # 80208618 <user_code_end+0xc48>
    80206c56:	853e                	mv	a0,a5
    80206c58:	c6cff0ef          	jal	802060c4 <str_eq>
    80206c5c:	87aa                	mv	a5,a0
    80206c5e:	c399                	beqz	a5,80206c64 <login_session+0x7a>
    80206c60:	4781                	li	a5,0
    80206c62:	a005                	j	80206c82 <login_session+0x98>
    80206c64:	00002517          	auipc	a0,0x2
    80206c68:	9bc50513          	addi	a0,a0,-1604 # 80208620 <user_code_end+0xc50>
    80206c6c:	837fa0ef          	jal	802014a2 <uart_puts>
    80206c70:	8effa0ef          	jal	8020155e <uart_rx_flush>
    80206c74:	b779                	j	80206c02 <login_session+0x18>
    80206c76:	0001                	nop
    80206c78:	b769                	j	80206c02 <login_session+0x18>
    80206c7a:	0001                	nop
    80206c7c:	b759                	j	80206c02 <login_session+0x18>
    80206c7e:	0001                	nop
    80206c80:	b749                	j	80206c02 <login_session+0x18>
    80206c82:	853e                	mv	a0,a5
    80206c84:	60aa                	ld	ra,136(sp)
    80206c86:	640a                	ld	s0,128(sp)
    80206c88:	6149                	addi	sp,sp,144
    80206c8a:	8082                	ret

0000000080206c8c <print_help>:
    80206c8c:	1141                	addi	sp,sp,-16
    80206c8e:	e406                	sd	ra,8(sp)
    80206c90:	e022                	sd	s0,0(sp)
    80206c92:	0800                	addi	s0,sp,16
    80206c94:	00002517          	auipc	a0,0x2
    80206c98:	9b450513          	addi	a0,a0,-1612 # 80208648 <user_code_end+0xc78>
    80206c9c:	807fa0ef          	jal	802014a2 <uart_puts>
    80206ca0:	00002517          	auipc	a0,0x2
    80206ca4:	9c850513          	addi	a0,a0,-1592 # 80208668 <user_code_end+0xc98>
    80206ca8:	ffafa0ef          	jal	802014a2 <uart_puts>
    80206cac:	00002517          	auipc	a0,0x2
    80206cb0:	9ec50513          	addi	a0,a0,-1556 # 80208698 <user_code_end+0xcc8>
    80206cb4:	feefa0ef          	jal	802014a2 <uart_puts>
    80206cb8:	00002517          	auipc	a0,0x2
    80206cbc:	a1050513          	addi	a0,a0,-1520 # 802086c8 <user_code_end+0xcf8>
    80206cc0:	fe2fa0ef          	jal	802014a2 <uart_puts>
    80206cc4:	00002517          	auipc	a0,0x2
    80206cc8:	a3c50513          	addi	a0,a0,-1476 # 80208700 <user_code_end+0xd30>
    80206ccc:	fd6fa0ef          	jal	802014a2 <uart_puts>
    80206cd0:	00002517          	auipc	a0,0x2
    80206cd4:	a5050513          	addi	a0,a0,-1456 # 80208720 <user_code_end+0xd50>
    80206cd8:	fcafa0ef          	jal	802014a2 <uart_puts>
    80206cdc:	0001                	nop
    80206cde:	60a2                	ld	ra,8(sp)
    80206ce0:	6402                	ld	s0,0(sp)
    80206ce2:	0141                	addi	sp,sp,16
    80206ce4:	8082                	ret

0000000080206ce6 <shell_loop>:
    80206ce6:	716d                	addi	sp,sp,-272
    80206ce8:	e606                	sd	ra,264(sp)
    80206cea:	e222                	sd	s0,256(sp)
    80206cec:	0a00                	addi	s0,sp,272
    80206cee:	00002517          	auipc	a0,0x2
    80206cf2:	a7250513          	addi	a0,a0,-1422 # 80208760 <user_code_end+0xd90>
    80206cf6:	facfa0ef          	jal	802014a2 <uart_puts>
    80206cfa:	00002517          	auipc	a0,0x2
    80206cfe:	87e50513          	addi	a0,a0,-1922 # 80208578 <user_code_end+0xba8>
    80206d02:	817fe0ef          	jal	80205518 <fs_chdir>
    80206d06:	f87ff0ef          	jal	80206c8c <print_help>
    80206d0a:	b98ff0ef          	jal	802060a2 <cpu_irq_enable>
    80206d0e:	ff0fe0ef          	jal	802054fe <fs_getcwd>
    80206d12:	872a                	mv	a4,a0
    80206d14:	f0040793          	addi	a5,s0,-256
    80206d18:	86ba                	mv	a3,a4
    80206d1a:	00002617          	auipc	a2,0x2
    80206d1e:	a5e60613          	addi	a2,a2,-1442 # 80208778 <user_code_end+0xda8>
    80206d22:	06000593          	li	a1,96
    80206d26:	853e                	mv	a0,a5
    80206d28:	be6fa0ef          	jal	8020110e <snprintf>
    80206d2c:	f6040713          	addi	a4,s0,-160
    80206d30:	f0040793          	addi	a5,s0,-256
    80206d34:	08000613          	li	a2,128
    80206d38:	85ba                	mv	a1,a4
    80206d3a:	853e                	mv	a0,a5
    80206d3c:	b17fa0ef          	jal	80201852 <uart_prompt_and_read_line>
    80206d40:	87aa                	mv	a5,a0
    80206d42:	3c07c563          	bltz	a5,8020710c <shell_loop+0x426>
    80206d46:	f6040793          	addi	a5,s0,-160
    80206d4a:	853e                	mv	a0,a5
    80206d4c:	c4aff0ef          	jal	80206196 <trim_line>
    80206d50:	f6044783          	lbu	a5,-160(s0)
    80206d54:	3a078e63          	beqz	a5,80207110 <shell_loop+0x42a>
    80206d58:	dc1ff0ef          	jal	80206b18 <shell_irq_save>
    80206d5c:	fea43423          	sd	a0,-24(s0)
    80206d60:	f6040793          	addi	a5,s0,-160
    80206d64:	00002597          	auipc	a1,0x2
    80206d68:	a2458593          	addi	a1,a1,-1500 # 80208788 <user_code_end+0xdb8>
    80206d6c:	853e                	mv	a0,a5
    80206d6e:	b56ff0ef          	jal	802060c4 <str_eq>
    80206d72:	87aa                	mv	a5,a0
    80206d74:	ef81                	bnez	a5,80206d8c <shell_loop+0xa6>
    80206d76:	f6040793          	addi	a5,s0,-160
    80206d7a:	00002597          	auipc	a1,0x2
    80206d7e:	a1658593          	addi	a1,a1,-1514 # 80208790 <user_code_end+0xdc0>
    80206d82:	853e                	mv	a0,a5
    80206d84:	b40ff0ef          	jal	802060c4 <str_eq>
    80206d88:	87aa                	mv	a5,a0
    80206d8a:	c781                	beqz	a5,80206d92 <shell_loop+0xac>
    80206d8c:	f01ff0ef          	jal	80206c8c <print_help>
    80206d90:	ae8d                	j	80207102 <shell_loop+0x41c>
    80206d92:	f6040793          	addi	a5,s0,-160
    80206d96:	00002597          	auipc	a1,0x2
    80206d9a:	a0258593          	addi	a1,a1,-1534 # 80208798 <user_code_end+0xdc8>
    80206d9e:	853e                	mv	a0,a5
    80206da0:	b24ff0ef          	jal	802060c4 <str_eq>
    80206da4:	87aa                	mv	a5,a0
    80206da6:	ef81                	bnez	a5,80206dbe <shell_loop+0xd8>
    80206da8:	f6040793          	addi	a5,s0,-160
    80206dac:	00002597          	auipc	a1,0x2
    80206db0:	9f458593          	addi	a1,a1,-1548 # 802087a0 <user_code_end+0xdd0>
    80206db4:	853e                	mv	a0,a5
    80206db6:	b0eff0ef          	jal	802060c4 <str_eq>
    80206dba:	87aa                	mv	a5,a0
    80206dbc:	cb81                	beqz	a5,80206dcc <shell_loop+0xe6>
    80206dbe:	00002517          	auipc	a0,0x2
    80206dc2:	9ea50513          	addi	a0,a0,-1558 # 802087a8 <user_code_end+0xdd8>
    80206dc6:	edcfa0ef          	jal	802014a2 <uart_puts>
    80206dca:	a6a9                	j	80207114 <shell_loop+0x42e>
    80206dcc:	f6040793          	addi	a5,s0,-160
    80206dd0:	853e                	mv	a0,a5
    80206dd2:	e84ff0ef          	jal	80206456 <is_poweroff_cmd>
    80206dd6:	87aa                	mv	a5,a0
    80206dd8:	c399                	beqz	a5,80206dde <shell_loop+0xf8>
    80206dda:	d67f90ef          	jal	80200b40 <machine_poweroff>
    80206dde:	f6040793          	addi	a5,s0,-160
    80206de2:	00002597          	auipc	a1,0x2
    80206de6:	9d658593          	addi	a1,a1,-1578 # 802087b8 <user_code_end+0xde8>
    80206dea:	853e                	mv	a0,a5
    80206dec:	ad8ff0ef          	jal	802060c4 <str_eq>
    80206df0:	87aa                	mv	a5,a0
    80206df2:	c781                	beqz	a5,80206dfa <shell_loop+0x114>
    80206df4:	a45ff0ef          	jal	80206838 <cmd_pwd>
    80206df8:	a629                	j	80207102 <shell_loop+0x41c>
    80206dfa:	f6040793          	addi	a5,s0,-160
    80206dfe:	00002597          	auipc	a1,0x2
    80206e02:	9c258593          	addi	a1,a1,-1598 # 802087c0 <user_code_end+0xdf0>
    80206e06:	853e                	mv	a0,a5
    80206e08:	b3aff0ef          	jal	80206142 <str_prefix>
    80206e0c:	87aa                	mv	a5,a0
    80206e0e:	cf81                	beqz	a5,80206e26 <shell_loop+0x140>
    80206e10:	f6040793          	addi	a5,s0,-160
    80206e14:	0789                	addi	a5,a5,2
    80206e16:	853e                	mv	a0,a5
    80206e18:	cd8ff0ef          	jal	802062f0 <skip_word>
    80206e1c:	87aa                	mv	a5,a0
    80206e1e:	853e                	mv	a0,a5
    80206e20:	a3dff0ef          	jal	8020685c <cmd_cd>
    80206e24:	acf9                	j	80207102 <shell_loop+0x41c>
    80206e26:	f6040793          	addi	a5,s0,-160
    80206e2a:	00002597          	auipc	a1,0x2
    80206e2e:	99e58593          	addi	a1,a1,-1634 # 802087c8 <user_code_end+0xdf8>
    80206e32:	853e                	mv	a0,a5
    80206e34:	a90ff0ef          	jal	802060c4 <str_eq>
    80206e38:	87aa                	mv	a5,a0
    80206e3a:	cb81                	beqz	a5,80206e4a <shell_loop+0x164>
    80206e3c:	00001517          	auipc	a0,0x1
    80206e40:	73c50513          	addi	a0,a0,1852 # 80208578 <user_code_end+0xba8>
    80206e44:	a19ff0ef          	jal	8020685c <cmd_cd>
    80206e48:	ac6d                	j	80207102 <shell_loop+0x41c>
    80206e4a:	f6040793          	addi	a5,s0,-160
    80206e4e:	00002597          	auipc	a1,0x2
    80206e52:	98258593          	addi	a1,a1,-1662 # 802087d0 <user_code_end+0xe00>
    80206e56:	853e                	mv	a0,a5
    80206e58:	aeaff0ef          	jal	80206142 <str_prefix>
    80206e5c:	87aa                	mv	a5,a0
    80206e5e:	cf81                	beqz	a5,80206e76 <shell_loop+0x190>
    80206e60:	f6040793          	addi	a5,s0,-160
    80206e64:	0789                	addi	a5,a5,2
    80206e66:	853e                	mv	a0,a5
    80206e68:	c88ff0ef          	jal	802062f0 <skip_word>
    80206e6c:	87aa                	mv	a5,a0
    80206e6e:	853e                	mv	a0,a5
    80206e70:	951ff0ef          	jal	802067c0 <cmd_ls>
    80206e74:	a479                	j	80207102 <shell_loop+0x41c>
    80206e76:	f6040793          	addi	a5,s0,-160
    80206e7a:	00002597          	auipc	a1,0x2
    80206e7e:	95e58593          	addi	a1,a1,-1698 # 802087d8 <user_code_end+0xe08>
    80206e82:	853e                	mv	a0,a5
    80206e84:	a40ff0ef          	jal	802060c4 <str_eq>
    80206e88:	87aa                	mv	a5,a0
    80206e8a:	c789                	beqz	a5,80206e94 <shell_loop+0x1ae>
    80206e8c:	4501                	li	a0,0
    80206e8e:	933ff0ef          	jal	802067c0 <cmd_ls>
    80206e92:	ac85                	j	80207102 <shell_loop+0x41c>
    80206e94:	f6040793          	addi	a5,s0,-160
    80206e98:	00002597          	auipc	a1,0x2
    80206e9c:	94858593          	addi	a1,a1,-1720 # 802087e0 <user_code_end+0xe10>
    80206ea0:	853e                	mv	a0,a5
    80206ea2:	aa0ff0ef          	jal	80206142 <str_prefix>
    80206ea6:	87aa                	mv	a5,a0
    80206ea8:	cf81                	beqz	a5,80206ec0 <shell_loop+0x1da>
    80206eaa:	f6040793          	addi	a5,s0,-160
    80206eae:	078d                	addi	a5,a5,3
    80206eb0:	853e                	mv	a0,a5
    80206eb2:	c3eff0ef          	jal	802062f0 <skip_word>
    80206eb6:	87aa                	mv	a5,a0
    80206eb8:	853e                	mv	a0,a5
    80206eba:	9f9ff0ef          	jal	802068b2 <cmd_cat>
    80206ebe:	a491                	j	80207102 <shell_loop+0x41c>
    80206ec0:	f6040793          	addi	a5,s0,-160
    80206ec4:	00002597          	auipc	a1,0x2
    80206ec8:	92458593          	addi	a1,a1,-1756 # 802087e8 <user_code_end+0xe18>
    80206ecc:	853e                	mv	a0,a5
    80206ece:	a74ff0ef          	jal	80206142 <str_prefix>
    80206ed2:	87aa                	mv	a5,a0
    80206ed4:	cf81                	beqz	a5,80206eec <shell_loop+0x206>
    80206ed6:	f6040793          	addi	a5,s0,-160
    80206eda:	0795                	addi	a5,a5,5
    80206edc:	853e                	mv	a0,a5
    80206ede:	c12ff0ef          	jal	802062f0 <skip_word>
    80206ee2:	87aa                	mv	a5,a0
    80206ee4:	853e                	mv	a0,a5
    80206ee6:	bf5ff0ef          	jal	80206ada <cmd_touch>
    80206eea:	ac21                	j	80207102 <shell_loop+0x41c>
    80206eec:	f6040793          	addi	a5,s0,-160
    80206ef0:	00002597          	auipc	a1,0x2
    80206ef4:	90058593          	addi	a1,a1,-1792 # 802087f0 <user_code_end+0xe20>
    80206ef8:	853e                	mv	a0,a5
    80206efa:	a48ff0ef          	jal	80206142 <str_prefix>
    80206efe:	87aa                	mv	a5,a0
    80206f00:	cf81                	beqz	a5,80206f18 <shell_loop+0x232>
    80206f02:	f6040793          	addi	a5,s0,-160
    80206f06:	0789                	addi	a5,a5,2
    80206f08:	853e                	mv	a0,a5
    80206f0a:	be6ff0ef          	jal	802062f0 <skip_word>
    80206f0e:	87aa                	mv	a5,a0
    80206f10:	853e                	mv	a0,a5
    80206f12:	702000ef          	jal	80207614 <vi_edit>
    80206f16:	a2f5                	j	80207102 <shell_loop+0x41c>
    80206f18:	f6040793          	addi	a5,s0,-160
    80206f1c:	00002597          	auipc	a1,0x2
    80206f20:	8dc58593          	addi	a1,a1,-1828 # 802087f8 <user_code_end+0xe28>
    80206f24:	853e                	mv	a0,a5
    80206f26:	a1cff0ef          	jal	80206142 <str_prefix>
    80206f2a:	87aa                	mv	a5,a0
    80206f2c:	cbb9                	beqz	a5,80206f82 <shell_loop+0x29c>
    80206f2e:	ee043c23          	sd	zero,-264(s0)
    80206f32:	ee042a23          	sw	zero,-268(s0)
    80206f36:	f6040793          	addi	a5,s0,-160
    80206f3a:	0795                	addi	a5,a5,5
    80206f3c:	fef43023          	sd	a5,-32(s0)
    80206f40:	ef440713          	addi	a4,s0,-268
    80206f44:	ef840793          	addi	a5,s0,-264
    80206f48:	863a                	mv	a2,a4
    80206f4a:	85be                	mv	a1,a5
    80206f4c:	fe043503          	ld	a0,-32(s0)
    80206f50:	c20ff0ef          	jal	80206370 <find_redirect>
    80206f54:	fe043503          	ld	a0,-32(s0)
    80206f58:	a3eff0ef          	jal	80206196 <trim_line>
    80206f5c:	ef843783          	ld	a5,-264(s0)
    80206f60:	c791                	beqz	a5,80206f6c <shell_loop+0x286>
    80206f62:	ef843783          	ld	a5,-264(s0)
    80206f66:	853e                	mv	a0,a5
    80206f68:	a2eff0ef          	jal	80206196 <trim_line>
    80206f6c:	ef843783          	ld	a5,-264(s0)
    80206f70:	ef442703          	lw	a4,-268(s0)
    80206f74:	863a                	mv	a2,a4
    80206f76:	85be                	mv	a1,a5
    80206f78:	fe043503          	ld	a0,-32(s0)
    80206f7c:	9e7ff0ef          	jal	80206962 <cmd_echo>
    80206f80:	a249                	j	80207102 <shell_loop+0x41c>
    80206f82:	f6040793          	addi	a5,s0,-160
    80206f86:	00002597          	auipc	a1,0x2
    80206f8a:	87a58593          	addi	a1,a1,-1926 # 80208800 <user_code_end+0xe30>
    80206f8e:	853e                	mv	a0,a5
    80206f90:	9b2ff0ef          	jal	80206142 <str_prefix>
    80206f94:	87aa                	mv	a5,a0
    80206f96:	cf81                	beqz	a5,80206fae <shell_loop+0x2c8>
    80206f98:	f6040793          	addi	a5,s0,-160
    80206f9c:	0789                	addi	a5,a5,2
    80206f9e:	853e                	mv	a0,a5
    80206fa0:	b50ff0ef          	jal	802062f0 <skip_word>
    80206fa4:	87aa                	mv	a5,a0
    80206fa6:	853e                	mv	a0,a5
    80206fa8:	298000ef          	jal	80207240 <script_run>
    80206fac:	aa99                	j	80207102 <shell_loop+0x41c>
    80206fae:	f6040793          	addi	a5,s0,-160
    80206fb2:	00002597          	auipc	a1,0x2
    80206fb6:	85658593          	addi	a1,a1,-1962 # 80208808 <user_code_end+0xe38>
    80206fba:	853e                	mv	a0,a5
    80206fbc:	986ff0ef          	jal	80206142 <str_prefix>
    80206fc0:	87aa                	mv	a5,a0
    80206fc2:	e39d                	bnez	a5,80206fe8 <shell_loop+0x302>
    80206fc4:	f6044783          	lbu	a5,-160(s0)
    80206fc8:	873e                	mv	a4,a5
    80206fca:	02f00793          	li	a5,47
    80206fce:	04f71563          	bne	a4,a5,80207018 <shell_loop+0x332>
    80206fd2:	f6040793          	addi	a5,s0,-160
    80206fd6:	00002597          	auipc	a1,0x2
    80206fda:	83a58593          	addi	a1,a1,-1990 # 80208810 <user_code_end+0xe40>
    80206fde:	853e                	mv	a0,a5
    80206fe0:	962ff0ef          	jal	80206142 <str_prefix>
    80206fe4:	87aa                	mv	a5,a0
    80206fe6:	eb8d                	bnez	a5,80207018 <shell_loop+0x332>
    80206fe8:	f6040793          	addi	a5,s0,-160
    80206fec:	00002597          	auipc	a1,0x2
    80206ff0:	81c58593          	addi	a1,a1,-2020 # 80208808 <user_code_end+0xe38>
    80206ff4:	853e                	mv	a0,a5
    80206ff6:	94cff0ef          	jal	80206142 <str_prefix>
    80206ffa:	87aa                	mv	a5,a0
    80206ffc:	cb81                	beqz	a5,8020700c <shell_loop+0x326>
    80206ffe:	f6040793          	addi	a5,s0,-160
    80207002:	0789                	addi	a5,a5,2
    80207004:	853e                	mv	a0,a5
    80207006:	fe9fc0ef          	jal	80203fee <proc_spawn_exec_wait>
    8020700a:	a8e5                	j	80207102 <shell_loop+0x41c>
    8020700c:	f6040793          	addi	a5,s0,-160
    80207010:	853e                	mv	a0,a5
    80207012:	fddfc0ef          	jal	80203fee <proc_spawn_exec_wait>
    80207016:	a0f5                	j	80207102 <shell_loop+0x41c>
    80207018:	f6040793          	addi	a5,s0,-160
    8020701c:	00001597          	auipc	a1,0x1
    80207020:	7fc58593          	addi	a1,a1,2044 # 80208818 <user_code_end+0xe48>
    80207024:	853e                	mv	a0,a5
    80207026:	89eff0ef          	jal	802060c4 <str_eq>
    8020702a:	87aa                	mv	a5,a0
    8020702c:	c789                	beqz	a5,80207036 <shell_loop+0x350>
    8020702e:	4501                	li	a0,0
    80207030:	da4ff0ef          	jal	802065d4 <cmd_ps>
    80207034:	a0f9                	j	80207102 <shell_loop+0x41c>
    80207036:	f6040793          	addi	a5,s0,-160
    8020703a:	00001597          	auipc	a1,0x1
    8020703e:	7e658593          	addi	a1,a1,2022 # 80208820 <user_code_end+0xe50>
    80207042:	853e                	mv	a0,a5
    80207044:	880ff0ef          	jal	802060c4 <str_eq>
    80207048:	87aa                	mv	a5,a0
    8020704a:	c789                	beqz	a5,80207054 <shell_loop+0x36e>
    8020704c:	4505                	li	a0,1
    8020704e:	d86ff0ef          	jal	802065d4 <cmd_ps>
    80207052:	a845                	j	80207102 <shell_loop+0x41c>
    80207054:	f6040793          	addi	a5,s0,-160
    80207058:	00001597          	auipc	a1,0x1
    8020705c:	7d058593          	addi	a1,a1,2000 # 80208828 <user_code_end+0xe58>
    80207060:	853e                	mv	a0,a5
    80207062:	862ff0ef          	jal	802060c4 <str_eq>
    80207066:	87aa                	mv	a5,a0
    80207068:	ef81                	bnez	a5,80207080 <shell_loop+0x39a>
    8020706a:	f6040793          	addi	a5,s0,-160
    8020706e:	00001597          	auipc	a1,0x1
    80207072:	7ca58593          	addi	a1,a1,1994 # 80208838 <user_code_end+0xe68>
    80207076:	853e                	mv	a0,a5
    80207078:	84cff0ef          	jal	802060c4 <str_eq>
    8020707c:	87aa                	mv	a5,a0
    8020707e:	cb91                	beqz	a5,80207092 <shell_loop+0x3ac>
    80207080:	d58fc0ef          	jal	802035d8 <proc_spawn_worker_demo>
    80207084:	00001517          	auipc	a0,0x1
    80207088:	7bc50513          	addi	a0,a0,1980 # 80208840 <user_code_end+0xe70>
    8020708c:	c16fa0ef          	jal	802014a2 <uart_puts>
    80207090:	a88d                	j	80207102 <shell_loop+0x41c>
    80207092:	f6040793          	addi	a5,s0,-160
    80207096:	00001597          	auipc	a1,0x1
    8020709a:	7ca58593          	addi	a1,a1,1994 # 80208860 <user_code_end+0xe90>
    8020709e:	853e                	mv	a0,a5
    802070a0:	824ff0ef          	jal	802060c4 <str_eq>
    802070a4:	87aa                	mv	a5,a0
    802070a6:	ef81                	bnez	a5,802070be <shell_loop+0x3d8>
    802070a8:	f6040793          	addi	a5,s0,-160
    802070ac:	00001597          	auipc	a1,0x1
    802070b0:	7c458593          	addi	a1,a1,1988 # 80208870 <user_code_end+0xea0>
    802070b4:	853e                	mv	a0,a5
    802070b6:	80eff0ef          	jal	802060c4 <str_eq>
    802070ba:	87aa                	mv	a5,a0
    802070bc:	c781                	beqz	a5,802070c4 <shell_loop+0x3de>
    802070be:	40a000ef          	jal	802074c8 <demo_run_tasks>
    802070c2:	a081                	j	80207102 <shell_loop+0x41c>
    802070c4:	f6040793          	addi	a5,s0,-160
    802070c8:	00001597          	auipc	a1,0x1
    802070cc:	7b058593          	addi	a1,a1,1968 # 80208878 <user_code_end+0xea8>
    802070d0:	853e                	mv	a0,a5
    802070d2:	ff3fe0ef          	jal	802060c4 <str_eq>
    802070d6:	87aa                	mv	a5,a0
    802070d8:	ef81                	bnez	a5,802070f0 <shell_loop+0x40a>
    802070da:	f6040793          	addi	a5,s0,-160
    802070de:	00001597          	auipc	a1,0x1
    802070e2:	7aa58593          	addi	a1,a1,1962 # 80208888 <user_code_end+0xeb8>
    802070e6:	853e                	mv	a0,a5
    802070e8:	fddfe0ef          	jal	802060c4 <str_eq>
    802070ec:	87aa                	mv	a5,a0
    802070ee:	c781                	beqz	a5,802070f6 <shell_loop+0x410>
    802070f0:	837f90ef          	jal	80200926 <osviz_snapshot>
    802070f4:	a039                	j	80207102 <shell_loop+0x41c>
    802070f6:	00001517          	auipc	a0,0x1
    802070fa:	7a250513          	addi	a0,a0,1954 # 80208898 <user_code_end+0xec8>
    802070fe:	ba4fa0ef          	jal	802014a2 <uart_puts>
    80207102:	fe843503          	ld	a0,-24(s0)
    80207106:	a35ff0ef          	jal	80206b3a <shell_irq_restore>
    8020710a:	b101                	j	80206d0a <shell_loop+0x24>
    8020710c:	0001                	nop
    8020710e:	bef5                	j	80206d0a <shell_loop+0x24>
    80207110:	0001                	nop
    80207112:	bee5                	j	80206d0a <shell_loop+0x24>
    80207114:	60b2                	ld	ra,264(sp)
    80207116:	6412                	ld	s0,256(sp)
    80207118:	6151                	addi	sp,sp,272
    8020711a:	8082                	ret

000000008020711c <console_run>:
    8020711c:	1141                	addi	sp,sp,-16
    8020711e:	e406                	sd	ra,8(sp)
    80207120:	e022                	sd	s0,0(sp)
    80207122:	0800                	addi	s0,sp,16
    80207124:	00001517          	auipc	a0,0x1
    80207128:	79450513          	addi	a0,a0,1940 # 802088b8 <user_code_end+0xee8>
    8020712c:	b76fa0ef          	jal	802014a2 <uart_puts>
    80207130:	abbff0ef          	jal	80206bea <login_session>
    80207134:	bb3ff0ef          	jal	80206ce6 <shell_loop>
    80207138:	0001                	nop
    8020713a:	b7ed                	j	80207124 <console_run+0x8>

000000008020713c <skip_space>:
    8020713c:	1101                	addi	sp,sp,-32
    8020713e:	ec06                	sd	ra,24(sp)
    80207140:	e822                	sd	s0,16(sp)
    80207142:	1000                	addi	s0,sp,32
    80207144:	fea43423          	sd	a0,-24(s0)
    80207148:	a809                	j	8020715a <skip_space+0x1e>
    8020714a:	fe843783          	ld	a5,-24(s0)
    8020714e:	639c                	ld	a5,0(a5)
    80207150:	00178713          	addi	a4,a5,1
    80207154:	fe843783          	ld	a5,-24(s0)
    80207158:	e398                	sd	a4,0(a5)
    8020715a:	fe843783          	ld	a5,-24(s0)
    8020715e:	639c                	ld	a5,0(a5)
    80207160:	0007c783          	lbu	a5,0(a5)
    80207164:	873e                	mv	a4,a5
    80207166:	02000793          	li	a5,32
    8020716a:	fef700e3          	beq	a4,a5,8020714a <skip_space+0xe>
    8020716e:	fe843783          	ld	a5,-24(s0)
    80207172:	639c                	ld	a5,0(a5)
    80207174:	0007c783          	lbu	a5,0(a5)
    80207178:	873e                	mv	a4,a5
    8020717a:	47a5                	li	a5,9
    8020717c:	fcf707e3          	beq	a4,a5,8020714a <skip_space+0xe>
    80207180:	0001                	nop
    80207182:	0001                	nop
    80207184:	60e2                	ld	ra,24(sp)
    80207186:	6442                	ld	s0,16(sp)
    80207188:	6105                	addi	sp,sp,32
    8020718a:	8082                	ret

000000008020718c <line_eq>:
    8020718c:	1101                	addi	sp,sp,-32
    8020718e:	ec06                	sd	ra,24(sp)
    80207190:	e822                	sd	s0,16(sp)
    80207192:	1000                	addi	s0,sp,32
    80207194:	fea43423          	sd	a0,-24(s0)
    80207198:	feb43023          	sd	a1,-32(s0)
    8020719c:	a03d                	j	802071ca <line_eq+0x3e>
    8020719e:	fe843783          	ld	a5,-24(s0)
    802071a2:	0007c703          	lbu	a4,0(a5)
    802071a6:	fe043783          	ld	a5,-32(s0)
    802071aa:	0007c783          	lbu	a5,0(a5)
    802071ae:	00f70463          	beq	a4,a5,802071b6 <line_eq+0x2a>
    802071b2:	4781                	li	a5,0
    802071b4:	a889                	j	80207206 <line_eq+0x7a>
    802071b6:	fe843783          	ld	a5,-24(s0)
    802071ba:	0785                	addi	a5,a5,1
    802071bc:	fef43423          	sd	a5,-24(s0)
    802071c0:	fe043783          	ld	a5,-32(s0)
    802071c4:	0785                	addi	a5,a5,1
    802071c6:	fef43023          	sd	a5,-32(s0)
    802071ca:	fe043783          	ld	a5,-32(s0)
    802071ce:	0007c783          	lbu	a5,0(a5)
    802071d2:	f7f1                	bnez	a5,8020719e <line_eq+0x12>
    802071d4:	fe843783          	ld	a5,-24(s0)
    802071d8:	0007c783          	lbu	a5,0(a5)
    802071dc:	c395                	beqz	a5,80207200 <line_eq+0x74>
    802071de:	fe843783          	ld	a5,-24(s0)
    802071e2:	0007c783          	lbu	a5,0(a5)
    802071e6:	873e                	mv	a4,a5
    802071e8:	02000793          	li	a5,32
    802071ec:	00f70a63          	beq	a4,a5,80207200 <line_eq+0x74>
    802071f0:	fe843783          	ld	a5,-24(s0)
    802071f4:	0007c783          	lbu	a5,0(a5)
    802071f8:	873e                	mv	a4,a5
    802071fa:	47a5                	li	a5,9
    802071fc:	00f71463          	bne	a4,a5,80207204 <line_eq+0x78>
    80207200:	4785                	li	a5,1
    80207202:	a011                	j	80207206 <line_eq+0x7a>
    80207204:	4781                	li	a5,0
    80207206:	853e                	mv	a0,a5
    80207208:	60e2                	ld	ra,24(sp)
    8020720a:	6442                	ld	s0,16(sp)
    8020720c:	6105                	addi	sp,sp,32
    8020720e:	8082                	ret

0000000080207210 <run_echo>:
    80207210:	1101                	addi	sp,sp,-32
    80207212:	ec06                	sd	ra,24(sp)
    80207214:	e822                	sd	s0,16(sp)
    80207216:	1000                	addi	s0,sp,32
    80207218:	fea43423          	sd	a0,-24(s0)
    8020721c:	fe840793          	addi	a5,s0,-24
    80207220:	853e                	mv	a0,a5
    80207222:	f1bff0ef          	jal	8020713c <skip_space>
    80207226:	fe843783          	ld	a5,-24(s0)
    8020722a:	853e                	mv	a0,a5
    8020722c:	a76fa0ef          	jal	802014a2 <uart_puts>
    80207230:	4529                	li	a0,10
    80207232:	a22fa0ef          	jal	80201454 <uart_putc>
    80207236:	0001                	nop
    80207238:	60e2                	ld	ra,24(sp)
    8020723a:	6442                	ld	s0,16(sp)
    8020723c:	6105                	addi	sp,sp,32
    8020723e:	8082                	ret

0000000080207240 <script_run>:
    80207240:	7139                	addi	sp,sp,-64
    80207242:	fc06                	sd	ra,56(sp)
    80207244:	f822                	sd	s0,48(sp)
    80207246:	0080                	addi	s0,sp,64
    80207248:	72f1                	lui	t0,0xffffc
    8020724a:	9116                	add	sp,sp,t0
    8020724c:	77f1                	lui	a5,0xffffc
    8020724e:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207250:	97a2                	add	a5,a5,s0
    80207252:	fca7bc23          	sd	a0,-40(a5)
    80207256:	fe042223          	sw	zero,-28(s0)
    8020725a:	77f1                	lui	a5,0xffffc
    8020725c:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020725e:	97a2                	add	a5,a5,s0
    80207260:	4581                	li	a1,0
    80207262:	fd87b503          	ld	a0,-40(a5)
    80207266:	dd4fe0ef          	jal	8020583a <fs_open>
    8020726a:	87aa                	mv	a5,a0
    8020726c:	fcf42a23          	sw	a5,-44(s0)
    80207270:	fd442783          	lw	a5,-44(s0)
    80207274:	2781                	sext.w	a5,a5
    80207276:	0007df63          	bgez	a5,80207294 <script_run+0x54>
    8020727a:	77f1                	lui	a5,0xffffc
    8020727c:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020727e:	97a2                	add	a5,a5,s0
    80207280:	fd87b583          	ld	a1,-40(a5)
    80207284:	00001517          	auipc	a0,0x1
    80207288:	64c50513          	addi	a0,a0,1612 # 802088d0 <user_code_end+0xf00>
    8020728c:	e2bf90ef          	jal	802010b6 <printf>
    80207290:	57fd                	li	a5,-1
    80207292:	a2f5                	j	8020747e <script_run+0x23e>
    80207294:	77f1                	lui	a5,0xffffc
    80207296:	1781                	addi	a5,a5,-32 # ffffffffffffbfe0 <_memory_end+0xffffffff77dfbfe0>
    80207298:	17c1                	addi	a5,a5,-16
    8020729a:	008786b3          	add	a3,a5,s0
    8020729e:	fd442703          	lw	a4,-44(s0)
    802072a2:	6791                	lui	a5,0x4
    802072a4:	fff78613          	addi	a2,a5,-1 # 3fff <STACK_SIZE+0x2fff>
    802072a8:	85b6                	mv	a1,a3
    802072aa:	853a                	mv	a0,a4
    802072ac:	f08fe0ef          	jal	802059b4 <fs_read>
    802072b0:	87aa                	mv	a5,a0
    802072b2:	fcf42823          	sw	a5,-48(s0)
    802072b6:	fd442783          	lw	a5,-44(s0)
    802072ba:	853e                	mv	a0,a5
    802072bc:	a0ffe0ef          	jal	80205cca <fs_close>
    802072c0:	fd042783          	lw	a5,-48(s0)
    802072c4:	2781                	sext.w	a5,a5
    802072c6:	00f04f63          	bgtz	a5,802072e4 <script_run+0xa4>
    802072ca:	77f1                	lui	a5,0xffffc
    802072cc:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802072ce:	97a2                	add	a5,a5,s0
    802072d0:	fd87b583          	ld	a1,-40(a5)
    802072d4:	00001517          	auipc	a0,0x1
    802072d8:	61c50513          	addi	a0,a0,1564 # 802088f0 <user_code_end+0xf20>
    802072dc:	ddbf90ef          	jal	802010b6 <printf>
    802072e0:	57fd                	li	a5,-1
    802072e2:	aa71                	j	8020747e <script_run+0x23e>
    802072e4:	77f1                	lui	a5,0xffffc
    802072e6:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802072e8:	00878733          	add	a4,a5,s0
    802072ec:	fd042783          	lw	a5,-48(s0)
    802072f0:	97ba                	add	a5,a5,a4
    802072f2:	fe078023          	sb	zero,-32(a5)
    802072f6:	77f1                	lui	a5,0xffffc
    802072f8:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802072fa:	97a2                	add	a5,a5,s0
    802072fc:	fd87b583          	ld	a1,-40(a5)
    80207300:	00001517          	auipc	a0,0x1
    80207304:	60050513          	addi	a0,a0,1536 # 80208900 <user_code_end+0xf30>
    80207308:	daff90ef          	jal	802010b6 <printf>
    8020730c:	fe042423          	sw	zero,-24(s0)
    80207310:	fe042623          	sw	zero,-20(s0)
    80207314:	aa3d                	j	80207452 <script_run+0x212>
    80207316:	fec42783          	lw	a5,-20(s0)
    8020731a:	873e                	mv	a4,a5
    8020731c:	fd042783          	lw	a5,-48(s0)
    80207320:	2701                	sext.w	a4,a4
    80207322:	2781                	sext.w	a5,a5
    80207324:	00f75f63          	bge	a4,a5,80207342 <script_run+0x102>
    80207328:	77f1                	lui	a5,0xffffc
    8020732a:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020732c:	00878733          	add	a4,a5,s0
    80207330:	fec42783          	lw	a5,-20(s0)
    80207334:	97ba                	add	a5,a5,a4
    80207336:	fe07c783          	lbu	a5,-32(a5)
    8020733a:	873e                	mv	a4,a5
    8020733c:	47a9                	li	a5,10
    8020733e:	10f71463          	bne	a4,a5,80207446 <script_run+0x206>
    80207342:	77f1                	lui	a5,0xffffc
    80207344:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207346:	00878733          	add	a4,a5,s0
    8020734a:	fec42783          	lw	a5,-20(s0)
    8020734e:	97ba                	add	a5,a5,a4
    80207350:	fe078023          	sb	zero,-32(a5)
    80207354:	77f1                	lui	a5,0xffffc
    80207356:	1781                	addi	a5,a5,-32 # ffffffffffffbfe0 <_memory_end+0xffffffff77dfbfe0>
    80207358:	17c1                	addi	a5,a5,-16
    8020735a:	00878733          	add	a4,a5,s0
    8020735e:	fe842783          	lw	a5,-24(s0)
    80207362:	97ba                	add	a5,a5,a4
    80207364:	fcf43c23          	sd	a5,-40(s0)
    80207368:	a031                	j	80207374 <script_run+0x134>
    8020736a:	fd843783          	ld	a5,-40(s0)
    8020736e:	0785                	addi	a5,a5,1
    80207370:	fcf43c23          	sd	a5,-40(s0)
    80207374:	fd843783          	ld	a5,-40(s0)
    80207378:	0007c783          	lbu	a5,0(a5)
    8020737c:	873e                	mv	a4,a5
    8020737e:	02000793          	li	a5,32
    80207382:	fef704e3          	beq	a4,a5,8020736a <script_run+0x12a>
    80207386:	fd843783          	ld	a5,-40(s0)
    8020738a:	0007c783          	lbu	a5,0(a5)
    8020738e:	873e                	mv	a4,a5
    80207390:	47a5                	li	a5,9
    80207392:	fcf70ce3          	beq	a4,a5,8020736a <script_run+0x12a>
    80207396:	fd843783          	ld	a5,-40(s0)
    8020739a:	0007c783          	lbu	a5,0(a5)
    8020739e:	cb91                	beqz	a5,802073b2 <script_run+0x172>
    802073a0:	fd843783          	ld	a5,-40(s0)
    802073a4:	0007c783          	lbu	a5,0(a5)
    802073a8:	873e                	mv	a4,a5
    802073aa:	02300793          	li	a5,35
    802073ae:	00f71863          	bne	a4,a5,802073be <script_run+0x17e>
    802073b2:	fec42783          	lw	a5,-20(s0)
    802073b6:	2785                	addiw	a5,a5,1
    802073b8:	fef42423          	sw	a5,-24(s0)
    802073bc:	a071                	j	80207448 <script_run+0x208>
    802073be:	fd843783          	ld	a5,-40(s0)
    802073c2:	0007c783          	lbu	a5,0(a5)
    802073c6:	873e                	mv	a4,a5
    802073c8:	02300793          	li	a5,35
    802073cc:	02f70563          	beq	a4,a5,802073f6 <script_run+0x1b6>
    802073d0:	fd843783          	ld	a5,-40(s0)
    802073d4:	0007c783          	lbu	a5,0(a5)
    802073d8:	873e                	mv	a4,a5
    802073da:	02f00793          	li	a5,47
    802073de:	02f71263          	bne	a4,a5,80207402 <script_run+0x1c2>
    802073e2:	fd843783          	ld	a5,-40(s0)
    802073e6:	0785                	addi	a5,a5,1
    802073e8:	0007c783          	lbu	a5,0(a5)
    802073ec:	873e                	mv	a4,a5
    802073ee:	02f00793          	li	a5,47
    802073f2:	00f71863          	bne	a4,a5,80207402 <script_run+0x1c2>
    802073f6:	fec42783          	lw	a5,-20(s0)
    802073fa:	2785                	addiw	a5,a5,1
    802073fc:	fef42423          	sw	a5,-24(s0)
    80207400:	a0a1                	j	80207448 <script_run+0x208>
    80207402:	00001597          	auipc	a1,0x1
    80207406:	51658593          	addi	a1,a1,1302 # 80208918 <user_code_end+0xf48>
    8020740a:	fd843503          	ld	a0,-40(s0)
    8020740e:	d7fff0ef          	jal	8020718c <line_eq>
    80207412:	87aa                	mv	a5,a0
    80207414:	cb81                	beqz	a5,80207424 <script_run+0x1e4>
    80207416:	fd843783          	ld	a5,-40(s0)
    8020741a:	0791                	addi	a5,a5,4
    8020741c:	853e                	mv	a0,a5
    8020741e:	df3ff0ef          	jal	80207210 <run_echo>
    80207422:	a821                	j	8020743a <script_run+0x1fa>
    80207424:	fd843583          	ld	a1,-40(s0)
    80207428:	00001517          	auipc	a0,0x1
    8020742c:	4f850513          	addi	a0,a0,1272 # 80208920 <user_code_end+0xf50>
    80207430:	c87f90ef          	jal	802010b6 <printf>
    80207434:	57fd                	li	a5,-1
    80207436:	fef42223          	sw	a5,-28(s0)
    8020743a:	fec42783          	lw	a5,-20(s0)
    8020743e:	2785                	addiw	a5,a5,1
    80207440:	fef42423          	sw	a5,-24(s0)
    80207444:	a011                	j	80207448 <script_run+0x208>
    80207446:	0001                	nop
    80207448:	fec42783          	lw	a5,-20(s0)
    8020744c:	2785                	addiw	a5,a5,1
    8020744e:	fef42623          	sw	a5,-20(s0)
    80207452:	fec42783          	lw	a5,-20(s0)
    80207456:	873e                	mv	a4,a5
    80207458:	fd042783          	lw	a5,-48(s0)
    8020745c:	2701                	sext.w	a4,a4
    8020745e:	2781                	sext.w	a5,a5
    80207460:	eae7dbe3          	bge	a5,a4,80207316 <script_run+0xd6>
    80207464:	77f1                	lui	a5,0xffffc
    80207466:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207468:	97a2                	add	a5,a5,s0
    8020746a:	fd87b583          	ld	a1,-40(a5)
    8020746e:	00001517          	auipc	a0,0x1
    80207472:	4ca50513          	addi	a0,a0,1226 # 80208938 <user_code_end+0xf68>
    80207476:	c41f90ef          	jal	802010b6 <printf>
    8020747a:	fe442783          	lw	a5,-28(s0)
    8020747e:	853e                	mv	a0,a5
    80207480:	6291                	lui	t0,0x4
    80207482:	9116                	add	sp,sp,t0
    80207484:	70e2                	ld	ra,56(sp)
    80207486:	7442                	ld	s0,48(sp)
    80207488:	6121                	addi	sp,sp,64
    8020748a:	8082                	ret

000000008020748c <demo_task0_once>:
    8020748c:	1141                	addi	sp,sp,-16
    8020748e:	e406                	sd	ra,8(sp)
    80207490:	e022                	sd	s0,0(sp)
    80207492:	0800                	addi	s0,sp,16
    80207494:	00001517          	auipc	a0,0x1
    80207498:	4bc50513          	addi	a0,a0,1212 # 80208950 <user_code_end+0xf80>
    8020749c:	806fa0ef          	jal	802014a2 <uart_puts>
    802074a0:	0001                	nop
    802074a2:	60a2                	ld	ra,8(sp)
    802074a4:	6402                	ld	s0,0(sp)
    802074a6:	0141                	addi	sp,sp,16
    802074a8:	8082                	ret

00000000802074aa <demo_task1_once>:
    802074aa:	1141                	addi	sp,sp,-16
    802074ac:	e406                	sd	ra,8(sp)
    802074ae:	e022                	sd	s0,0(sp)
    802074b0:	0800                	addi	s0,sp,16
    802074b2:	00001517          	auipc	a0,0x1
    802074b6:	4be50513          	addi	a0,a0,1214 # 80208970 <user_code_end+0xfa0>
    802074ba:	fe9f90ef          	jal	802014a2 <uart_puts>
    802074be:	0001                	nop
    802074c0:	60a2                	ld	ra,8(sp)
    802074c2:	6402                	ld	s0,0(sp)
    802074c4:	0141                	addi	sp,sp,16
    802074c6:	8082                	ret

00000000802074c8 <demo_run_tasks>:
    802074c8:	1141                	addi	sp,sp,-16
    802074ca:	e406                	sd	ra,8(sp)
    802074cc:	e022                	sd	s0,0(sp)
    802074ce:	0800                	addi	s0,sp,16
    802074d0:	00001517          	auipc	a0,0x1
    802074d4:	4c050513          	addi	a0,a0,1216 # 80208990 <user_code_end+0xfc0>
    802074d8:	fcbf90ef          	jal	802014a2 <uart_puts>
    802074dc:	fb1ff0ef          	jal	8020748c <demo_task0_once>
    802074e0:	fcbff0ef          	jal	802074aa <demo_task1_once>
    802074e4:	00001517          	auipc	a0,0x1
    802074e8:	4ec50513          	addi	a0,a0,1260 # 802089d0 <user_code_end+0x1000>
    802074ec:	fb7f90ef          	jal	802014a2 <uart_puts>
    802074f0:	0001                	nop
    802074f2:	60a2                	ld	ra,8(sp)
    802074f4:	6402                	ld	s0,0(sp)
    802074f6:	0141                	addi	sp,sp,16
    802074f8:	8082                	ret

00000000802074fa <os_main>:
    802074fa:	1141                	addi	sp,sp,-16
    802074fc:	e406                	sd	ra,8(sp)
    802074fe:	e022                	sd	s0,0(sp)
    80207500:	0800                	addi	s0,sp,16
    80207502:	0001                	nop
    80207504:	60a2                	ld	ra,8(sp)
    80207506:	6402                	ld	s0,0(sp)
    80207508:	0141                	addi	sp,sp,16
    8020750a:	8082                	ret

000000008020750c <str_eq>:
    8020750c:	1101                	addi	sp,sp,-32
    8020750e:	ec06                	sd	ra,24(sp)
    80207510:	e822                	sd	s0,16(sp)
    80207512:	1000                	addi	s0,sp,32
    80207514:	fea43423          	sd	a0,-24(s0)
    80207518:	feb43023          	sd	a1,-32(s0)
    8020751c:	a03d                	j	8020754a <str_eq+0x3e>
    8020751e:	fe843783          	ld	a5,-24(s0)
    80207522:	0007c703          	lbu	a4,0(a5)
    80207526:	fe043783          	ld	a5,-32(s0)
    8020752a:	0007c783          	lbu	a5,0(a5)
    8020752e:	00f70463          	beq	a4,a5,80207536 <str_eq+0x2a>
    80207532:	4781                	li	a5,0
    80207534:	a0b1                	j	80207580 <str_eq+0x74>
    80207536:	fe843783          	ld	a5,-24(s0)
    8020753a:	0785                	addi	a5,a5,1
    8020753c:	fef43423          	sd	a5,-24(s0)
    80207540:	fe043783          	ld	a5,-32(s0)
    80207544:	0785                	addi	a5,a5,1
    80207546:	fef43023          	sd	a5,-32(s0)
    8020754a:	fe843783          	ld	a5,-24(s0)
    8020754e:	0007c783          	lbu	a5,0(a5)
    80207552:	c791                	beqz	a5,8020755e <str_eq+0x52>
    80207554:	fe043783          	ld	a5,-32(s0)
    80207558:	0007c783          	lbu	a5,0(a5)
    8020755c:	f3e9                	bnez	a5,8020751e <str_eq+0x12>
    8020755e:	fe843783          	ld	a5,-24(s0)
    80207562:	0007c703          	lbu	a4,0(a5)
    80207566:	fe043783          	ld	a5,-32(s0)
    8020756a:	0007c783          	lbu	a5,0(a5)
    8020756e:	2701                	sext.w	a4,a4
    80207570:	2781                	sext.w	a5,a5
    80207572:	40f707b3          	sub	a5,a4,a5
    80207576:	0017b793          	seqz	a5,a5
    8020757a:	0ff7f793          	zext.b	a5,a5
    8020757e:	2781                	sext.w	a5,a5
    80207580:	853e                	mv	a0,a5
    80207582:	60e2                	ld	ra,24(sp)
    80207584:	6442                	ld	s0,16(sp)
    80207586:	6105                	addi	sp,sp,32
    80207588:	8082                	ret

000000008020758a <trim_eol>:
    8020758a:	7179                	addi	sp,sp,-48
    8020758c:	f406                	sd	ra,40(sp)
    8020758e:	f022                	sd	s0,32(sp)
    80207590:	1800                	addi	s0,sp,48
    80207592:	fca43c23          	sd	a0,-40(s0)
    80207596:	fe042623          	sw	zero,-20(s0)
    8020759a:	a031                	j	802075a6 <trim_eol+0x1c>
    8020759c:	fec42783          	lw	a5,-20(s0)
    802075a0:	2785                	addiw	a5,a5,1
    802075a2:	fef42623          	sw	a5,-20(s0)
    802075a6:	fec42783          	lw	a5,-20(s0)
    802075aa:	fd843703          	ld	a4,-40(s0)
    802075ae:	97ba                	add	a5,a5,a4
    802075b0:	0007c783          	lbu	a5,0(a5)
    802075b4:	f7e5                	bnez	a5,8020759c <trim_eol+0x12>
    802075b6:	a829                	j	802075d0 <trim_eol+0x46>
    802075b8:	fec42783          	lw	a5,-20(s0)
    802075bc:	37fd                	addiw	a5,a5,-1
    802075be:	fef42623          	sw	a5,-20(s0)
    802075c2:	fec42783          	lw	a5,-20(s0)
    802075c6:	fd843703          	ld	a4,-40(s0)
    802075ca:	97ba                	add	a5,a5,a4
    802075cc:	00078023          	sb	zero,0(a5)
    802075d0:	fec42783          	lw	a5,-20(s0)
    802075d4:	2781                	sext.w	a5,a5
    802075d6:	02f05a63          	blez	a5,8020760a <trim_eol+0x80>
    802075da:	fec42783          	lw	a5,-20(s0)
    802075de:	17fd                	addi	a5,a5,-1
    802075e0:	fd843703          	ld	a4,-40(s0)
    802075e4:	97ba                	add	a5,a5,a4
    802075e6:	0007c783          	lbu	a5,0(a5)
    802075ea:	873e                	mv	a4,a5
    802075ec:	47a9                	li	a5,10
    802075ee:	fcf705e3          	beq	a4,a5,802075b8 <trim_eol+0x2e>
    802075f2:	fec42783          	lw	a5,-20(s0)
    802075f6:	17fd                	addi	a5,a5,-1
    802075f8:	fd843703          	ld	a4,-40(s0)
    802075fc:	97ba                	add	a5,a5,a4
    802075fe:	0007c783          	lbu	a5,0(a5)
    80207602:	873e                	mv	a4,a5
    80207604:	47b5                	li	a5,13
    80207606:	faf709e3          	beq	a4,a5,802075b8 <trim_eol+0x2e>
    8020760a:	0001                	nop
    8020760c:	70a2                	ld	ra,40(sp)
    8020760e:	7402                	ld	s0,32(sp)
    80207610:	6145                	addi	sp,sp,48
    80207612:	8082                	ret

0000000080207614 <vi_edit>:
    80207614:	7171                	addi	sp,sp,-176
    80207616:	f506                	sd	ra,168(sp)
    80207618:	f122                	sd	s0,160(sp)
    8020761a:	1900                	addi	s0,sp,176
    8020761c:	72f1                	lui	t0,0xffffc
    8020761e:	9116                	add	sp,sp,t0
    80207620:	77f1                	lui	a5,0xffffc
    80207622:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207624:	97a2                	add	a5,a5,s0
    80207626:	f6a7b423          	sd	a0,-152(a5)
    8020762a:	fe042623          	sw	zero,-20(s0)
    8020762e:	77f1                	lui	a5,0xffffc
    80207630:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    80207632:	17c1                	addi	a5,a5,-16
    80207634:	008786b3          	add	a3,a5,s0
    80207638:	77f1                	lui	a5,0xffffc
    8020763a:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020763c:	97a2                	add	a5,a5,s0
    8020763e:	6711                	lui	a4,0x4
    80207640:	fff70613          	addi	a2,a4,-1 # 3fff <STACK_SIZE+0x2fff>
    80207644:	85b6                	mv	a1,a3
    80207646:	f687b503          	ld	a0,-152(a5)
    8020764a:	ec6fe0ef          	jal	80205d10 <fs_read_file>
    8020764e:	87aa                	mv	a5,a0
    80207650:	fef42623          	sw	a5,-20(s0)
    80207654:	fec42783          	lw	a5,-20(s0)
    80207658:	2781                	sext.w	a5,a5
    8020765a:	0007d463          	bgez	a5,80207662 <vi_edit+0x4e>
    8020765e:	fe042623          	sw	zero,-20(s0)
    80207662:	77f1                	lui	a5,0xffffc
    80207664:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207666:	00878733          	add	a4,a5,s0
    8020766a:	fec42783          	lw	a5,-20(s0)
    8020766e:	97ba                	add	a5,a5,a4
    80207670:	fe078c23          	sb	zero,-8(a5)
    80207674:	00001517          	auipc	a0,0x1
    80207678:	37450513          	addi	a0,a0,884 # 802089e8 <user_code_end+0x1018>
    8020767c:	e27f90ef          	jal	802014a2 <uart_puts>
    80207680:	77f1                	lui	a5,0xffffc
    80207682:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207684:	97a2                	add	a5,a5,s0
    80207686:	f687b503          	ld	a0,-152(a5)
    8020768a:	e19f90ef          	jal	802014a2 <uart_puts>
    8020768e:	00001517          	auipc	a0,0x1
    80207692:	36250513          	addi	a0,a0,866 # 802089f0 <user_code_end+0x1020>
    80207696:	e0df90ef          	jal	802014a2 <uart_puts>
    8020769a:	fec42783          	lw	a5,-20(s0)
    8020769e:	2781                	sext.w	a5,a5
    802076a0:	04f05b63          	blez	a5,802076f6 <vi_edit+0xe2>
    802076a4:	00001517          	auipc	a0,0x1
    802076a8:	35450513          	addi	a0,a0,852 # 802089f8 <user_code_end+0x1028>
    802076ac:	df7f90ef          	jal	802014a2 <uart_puts>
    802076b0:	77f1                	lui	a5,0xffffc
    802076b2:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    802076b4:	17c1                	addi	a5,a5,-16
    802076b6:	97a2                	add	a5,a5,s0
    802076b8:	853e                	mv	a0,a5
    802076ba:	de9f90ef          	jal	802014a2 <uart_puts>
    802076be:	fec42783          	lw	a5,-20(s0)
    802076c2:	2781                	sext.w	a5,a5
    802076c4:	cf99                	beqz	a5,802076e2 <vi_edit+0xce>
    802076c6:	fec42783          	lw	a5,-20(s0)
    802076ca:	37fd                	addiw	a5,a5,-1
    802076cc:	2781                	sext.w	a5,a5
    802076ce:	7771                	lui	a4,0xffffc
    802076d0:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802076d2:	9722                	add	a4,a4,s0
    802076d4:	97ba                	add	a5,a5,a4
    802076d6:	ff87c783          	lbu	a5,-8(a5)
    802076da:	873e                	mv	a4,a5
    802076dc:	47a9                	li	a5,10
    802076de:	00f70563          	beq	a4,a5,802076e8 <vi_edit+0xd4>
    802076e2:	4529                	li	a0,10
    802076e4:	d71f90ef          	jal	80201454 <uart_putc>
    802076e8:	00001517          	auipc	a0,0x1
    802076ec:	32850513          	addi	a0,a0,808 # 80208a10 <user_code_end+0x1040>
    802076f0:	db3f90ef          	jal	802014a2 <uart_puts>
    802076f4:	a039                	j	80207702 <vi_edit+0xee>
    802076f6:	00001517          	auipc	a0,0x1
    802076fa:	32a50513          	addi	a0,a0,810 # 80208a20 <user_code_end+0x1050>
    802076fe:	da5f90ef          	jal	802014a2 <uart_puts>
    80207702:	00001517          	auipc	a0,0x1
    80207706:	32e50513          	addi	a0,a0,814 # 80208a30 <user_code_end+0x1060>
    8020770a:	d99f90ef          	jal	802014a2 <uart_puts>
    8020770e:	00001517          	auipc	a0,0x1
    80207712:	34250513          	addi	a0,a0,834 # 80208a50 <user_code_end+0x1080>
    80207716:	d8df90ef          	jal	802014a2 <uart_puts>
    8020771a:	fe042623          	sw	zero,-20(s0)
    8020771e:	77f1                	lui	a5,0xffffc
    80207720:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207722:	97a2                	add	a5,a5,s0
    80207724:	fe078c23          	sb	zero,-8(a5)
    80207728:	77f1                	lui	a5,0xffffc
    8020772a:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    8020772e:	17c1                	addi	a5,a5,-16
    80207730:	97a2                	add	a5,a5,s0
    80207732:	08000613          	li	a2,128
    80207736:	85be                	mv	a1,a5
    80207738:	00001517          	auipc	a0,0x1
    8020773c:	36050513          	addi	a0,a0,864 # 80208a98 <user_code_end+0x10c8>
    80207740:	912fa0ef          	jal	80201852 <uart_prompt_and_read_line>
    80207744:	87aa                	mv	a5,a0
    80207746:	0c07ce63          	bltz	a5,80207822 <vi_edit+0x20e>
    8020774a:	77f1                	lui	a5,0xffffc
    8020774c:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80207750:	17c1                	addi	a5,a5,-16
    80207752:	97a2                	add	a5,a5,s0
    80207754:	853e                	mv	a0,a5
    80207756:	e35ff0ef          	jal	8020758a <trim_eol>
    8020775a:	77f1                	lui	a5,0xffffc
    8020775c:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80207760:	17c1                	addi	a5,a5,-16
    80207762:	97a2                	add	a5,a5,s0
    80207764:	00001597          	auipc	a1,0x1
    80207768:	33c58593          	addi	a1,a1,828 # 80208aa0 <user_code_end+0x10d0>
    8020776c:	853e                	mv	a0,a5
    8020776e:	d9fff0ef          	jal	8020750c <str_eq>
    80207772:	87aa                	mv	a5,a0
    80207774:	c399                	beqz	a5,8020777a <vi_edit+0x166>
    80207776:	57fd                	li	a5,-1
    80207778:	a8d5                	j	8020786c <vi_edit+0x258>
    8020777a:	77f1                	lui	a5,0xffffc
    8020777c:	f7878793          	addi	a5,a5,-136 # ffffffffffffbf78 <_memory_end+0xffffffff77dfbf78>
    80207780:	17c1                	addi	a5,a5,-16
    80207782:	97a2                	add	a5,a5,s0
    80207784:	00001597          	auipc	a1,0x1
    80207788:	32458593          	addi	a1,a1,804 # 80208aa8 <user_code_end+0x10d8>
    8020778c:	853e                	mv	a0,a5
    8020778e:	d7fff0ef          	jal	8020750c <str_eq>
    80207792:	87aa                	mv	a5,a0
    80207794:	ebc9                	bnez	a5,80207826 <vi_edit+0x212>
    80207796:	fe042423          	sw	zero,-24(s0)
    8020779a:	a81d                	j	802077d0 <vi_edit+0x1bc>
    8020779c:	fec42783          	lw	a5,-20(s0)
    802077a0:	0017871b          	addiw	a4,a5,1
    802077a4:	fee42623          	sw	a4,-20(s0)
    802077a8:	7771                	lui	a4,0xffffc
    802077aa:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802077ac:	008706b3          	add	a3,a4,s0
    802077b0:	fe842703          	lw	a4,-24(s0)
    802077b4:	9736                	add	a4,a4,a3
    802077b6:	f7874703          	lbu	a4,-136(a4)
    802077ba:	76f1                	lui	a3,0xffffc
    802077bc:	16c1                	addi	a3,a3,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802077be:	96a2                	add	a3,a3,s0
    802077c0:	97b6                	add	a5,a5,a3
    802077c2:	fee78c23          	sb	a4,-8(a5)
    802077c6:	fe842783          	lw	a5,-24(s0)
    802077ca:	2785                	addiw	a5,a5,1
    802077cc:	fef42423          	sw	a5,-24(s0)
    802077d0:	77f1                	lui	a5,0xffffc
    802077d2:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    802077d4:	00878733          	add	a4,a5,s0
    802077d8:	fe842783          	lw	a5,-24(s0)
    802077dc:	97ba                	add	a5,a5,a4
    802077de:	f787c783          	lbu	a5,-136(a5)
    802077e2:	cb89                	beqz	a5,802077f4 <vi_edit+0x1e0>
    802077e4:	fec42783          	lw	a5,-20(s0)
    802077e8:	0007871b          	sext.w	a4,a5
    802077ec:	6791                	lui	a5,0x4
    802077ee:	17f5                	addi	a5,a5,-3 # 3ffd <STACK_SIZE+0x2ffd>
    802077f0:	fae7d6e3          	bge	a5,a4,8020779c <vi_edit+0x188>
    802077f4:	fec42783          	lw	a5,-20(s0)
    802077f8:	0017871b          	addiw	a4,a5,1
    802077fc:	fee42623          	sw	a4,-20(s0)
    80207800:	7771                	lui	a4,0xffffc
    80207802:	1741                	addi	a4,a4,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207804:	9722                	add	a4,a4,s0
    80207806:	97ba                	add	a5,a5,a4
    80207808:	4729                	li	a4,10
    8020780a:	fee78c23          	sb	a4,-8(a5)
    8020780e:	77f1                	lui	a5,0xffffc
    80207810:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    80207812:	00878733          	add	a4,a5,s0
    80207816:	fec42783          	lw	a5,-20(s0)
    8020781a:	97ba                	add	a5,a5,a4
    8020781c:	fe078c23          	sb	zero,-8(a5)
    80207820:	b721                	j	80207728 <vi_edit+0x114>
    80207822:	0001                	nop
    80207824:	b711                	j	80207728 <vi_edit+0x114>
    80207826:	0001                	nop
    80207828:	fec42603          	lw	a2,-20(s0)
    8020782c:	77f1                	lui	a5,0xffffc
    8020782e:	17e1                	addi	a5,a5,-8 # ffffffffffffbff8 <_memory_end+0xffffffff77dfbff8>
    80207830:	17c1                	addi	a5,a5,-16
    80207832:	00878733          	add	a4,a5,s0
    80207836:	77f1                	lui	a5,0xffffc
    80207838:	17c1                	addi	a5,a5,-16 # ffffffffffffbff0 <_memory_end+0xffffffff77dfbff0>
    8020783a:	97a2                	add	a5,a5,s0
    8020783c:	4685                	li	a3,1
    8020783e:	85ba                	mv	a1,a4
    80207840:	f687b503          	ld	a0,-152(a5)
    80207844:	d32fe0ef          	jal	80205d76 <fs_write_file>
    80207848:	87aa                	mv	a5,a0
    8020784a:	0007da63          	bgez	a5,8020785e <vi_edit+0x24a>
    8020784e:	00001517          	auipc	a0,0x1
    80207852:	26250513          	addi	a0,a0,610 # 80208ab0 <user_code_end+0x10e0>
    80207856:	c4df90ef          	jal	802014a2 <uart_puts>
    8020785a:	57fd                	li	a5,-1
    8020785c:	a801                	j	8020786c <vi_edit+0x258>
    8020785e:	00001517          	auipc	a0,0x1
    80207862:	26a50513          	addi	a0,a0,618 # 80208ac8 <user_code_end+0x10f8>
    80207866:	c3df90ef          	jal	802014a2 <uart_puts>
    8020786a:	4781                	li	a5,0
    8020786c:	853e                	mv	a0,a5
    8020786e:	6291                	lui	t0,0x4
    80207870:	9116                	add	sp,sp,t0
    80207872:	70aa                	ld	ra,168(sp)
    80207874:	740a                	ld	s0,160(sp)
    80207876:	614d                	addi	sp,sp,176
    80207878:	8082                	ret

000000008020787a <fs_load_home>:
    8020787a:	1141                	addi	sp,sp,-16
    8020787c:	e406                	sd	ra,8(sp)
    8020787e:	e022                	sd	s0,0(sp)
    80207880:	0800                	addi	s0,sp,16
    80207882:	4705                	li	a4,1
    80207884:	4681                	li	a3,0
    80207886:	6789                	lui	a5,0x2
    80207888:	1c878613          	addi	a2,a5,456 # 21c8 <STACK_SIZE+0x11c8>
    8020788c:	00002597          	auipc	a1,0x2
    80207890:	96c58593          	addi	a1,a1,-1684 # 802091f8 <home_bin_file_rw.2>
    80207894:	00001517          	auipc	a0,0x1
    80207898:	24450513          	addi	a0,a0,580 # 80208ad8 <user_code_end+0x1108>
    8020789c:	d7afe0ef          	jal	80205e16 <fs_seed_file>
    802078a0:	4701                	li	a4,0
    802078a2:	4681                	li	a3,0
    802078a4:	3fb00613          	li	a2,1019
    802078a8:	00001597          	auipc	a1,0x1
    802078ac:	24858593          	addi	a1,a1,584 # 80208af0 <user_code_end+0x1120>
    802078b0:	00001517          	auipc	a0,0x1
    802078b4:	64050513          	addi	a0,a0,1600 # 80208ef0 <user_code_end+0x1520>
    802078b8:	d5efe0ef          	jal	80205e16 <fs_seed_file>
    802078bc:	4701                	li	a4,0
    802078be:	4681                	li	a3,0
    802078c0:	07600613          	li	a2,118
    802078c4:	00001597          	auipc	a1,0x1
    802078c8:	64458593          	addi	a1,a1,1604 # 80208f08 <user_code_end+0x1538>
    802078cc:	00001517          	auipc	a0,0x1
    802078d0:	6b450513          	addi	a0,a0,1716 # 80208f80 <user_code_end+0x15b0>
    802078d4:	d42fe0ef          	jal	80205e16 <fs_seed_file>
    802078d8:	4701                	li	a4,0
    802078da:	4681                	li	a3,0
    802078dc:	05300613          	li	a2,83
    802078e0:	00001597          	auipc	a1,0x1
    802078e4:	6b858593          	addi	a1,a1,1720 # 80208f98 <user_code_end+0x15c8>
    802078e8:	00001517          	auipc	a0,0x1
    802078ec:	70850513          	addi	a0,a0,1800 # 80208ff0 <user_code_end+0x1620>
    802078f0:	d26fe0ef          	jal	80205e16 <fs_seed_file>
    802078f4:	4705                	li	a4,1
    802078f6:	4681                	li	a3,0
    802078f8:	6789                	lui	a5,0x2
    802078fa:	d0078613          	addi	a2,a5,-768 # 1d00 <STACK_SIZE+0xd00>
    802078fe:	00004597          	auipc	a1,0x4
    80207902:	ac258593          	addi	a1,a1,-1342 # 8020b3c0 <home_bin_hi.1>
    80207906:	00001517          	auipc	a0,0x1
    8020790a:	70250513          	addi	a0,a0,1794 # 80209008 <user_code_end+0x1638>
    8020790e:	d08fe0ef          	jal	80205e16 <fs_seed_file>
    80207912:	4701                	li	a4,0
    80207914:	4681                	li	a3,0
    80207916:	18000613          	li	a2,384
    8020791a:	00001597          	auipc	a1,0x1
    8020791e:	6fe58593          	addi	a1,a1,1790 # 80209018 <user_code_end+0x1648>
    80207922:	00002517          	auipc	a0,0x2
    80207926:	87e50513          	addi	a0,a0,-1922 # 802091a0 <user_code_end+0x17d0>
    8020792a:	cecfe0ef          	jal	80205e16 <fs_seed_file>
    8020792e:	4705                	li	a4,1
    80207930:	4681                	li	a3,0
    80207932:	6789                	lui	a5,0x2
    80207934:	ab878613          	addi	a2,a5,-1352 # 1ab8 <STACK_SIZE+0xab8>
    80207938:	00005597          	auipc	a1,0x5
    8020793c:	78858593          	addi	a1,a1,1928 # 8020d0c0 <home_bin_spin.0>
    80207940:	00002517          	auipc	a0,0x2
    80207944:	87050513          	addi	a0,a0,-1936 # 802091b0 <user_code_end+0x17e0>
    80207948:	ccefe0ef          	jal	80205e16 <fs_seed_file>
    8020794c:	4701                	li	a4,0
    8020794e:	4681                	li	a3,0
    80207950:	4679                	li	a2,30
    80207952:	00002597          	auipc	a1,0x2
    80207956:	86e58593          	addi	a1,a1,-1938 # 802091c0 <user_code_end+0x17f0>
    8020795a:	00002517          	auipc	a0,0x2
    8020795e:	88650513          	addi	a0,a0,-1914 # 802091e0 <user_code_end+0x1810>
    80207962:	cb4fe0ef          	jal	80205e16 <fs_seed_file>
    80207966:	0001                	nop
    80207968:	60a2                	ld	ra,8(sp)
    8020796a:	6402                	ld	s0,0(sp)
    8020796c:	0141                	addi	sp,sp,16
    8020796e:	8082                	ret

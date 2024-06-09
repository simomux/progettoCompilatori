	.text
	.file	"sqrt3.ll"
	.globl	iterate                         // -- Begin function iterate
	.p2align	2
	.type	iterate,@function
iterate:                                // @iterate
	.cfi_startproc
// %bb.0:                               // %entry
	mov	x8, #17197
	fmul	d2, d1, d1
	movk	x8, #60188, lsl #16
	movk	x8, #14050, lsl #32
	movk	x8, #16154, lsl #48
	stp	d0, d1, [sp, #-32]!
	.cfi_def_cfa_offset 32
	fmov	d1, #2.00000000
	str	x8, [sp, #16]
	str	d2, [sp, #24]
.LBB0_1:                                // %cond5
                                        // =>This Inner Loop Header: Depth=1
	ldp	d4, d0, [sp, #16]
	ldr	d2, [sp]
	fsub	d3, d2, d0
	fsub	d0, d0, d2
	fcmp	d3, d4
	fccmp	d0, d4, #0, lt
	ldr	d0, [sp, #8]
	b.lt	.LBB0_3
// %bb.2:                               // %loop14
                                        //   in Loop: Header=BB0_1 Depth=1
	ldp	d3, d2, [sp]
	fdiv	d3, d3, d2
	fmul	d0, d2, d0
	str	d0, [sp, #24]
	fadd	d3, d2, d3
	fdiv	d3, d3, d1
	str	d3, [sp, #8]
	b	.LBB0_1
.LBB0_3:                                // %loopend23
	add	sp, sp, #32
	ret
.Lfunc_end0:
	.size	iterate, .Lfunc_end0-iterate
	.cfi_endproc
                                        // -- End function
	.globl	sqrt                            // -- Begin function sqrt
	.p2align	2
	.type	sqrt,@function
sqrt:                                   // @sqrt
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!                // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	fmov	d1, d0
	fmov	d0, #1.00000000
	fcmp	d1, d0
	str	d1, [sp, #8]
	b.eq	.LBB1_5
	b.vs	.LBB1_5
// %bb.1:                               // %falseexp
	ldr	d0, [sp, #8]
	fmov	d1, #1.00000000
	fcmp	d0, d1
	b.ge	.LBB1_3
// %bb.2:                               // %trueexp4
	fsub	d1, d1, d0
	b	.LBB1_4
.LBB1_3:                                // %falseexp7
	fmov	d1, #2.00000000
	fdiv	d1, d0, d1
.LBB1_4:                                // %endcond
	bl	iterate
.LBB1_5:                                // %endcond11
	ldr	x30, [sp], #16                  // 8-byte Folded Reload
	ret
.Lfunc_end1:
	.size	sqrt, .Lfunc_end1-sqrt
	.cfi_endproc
                                        // -- End function
	.section	".note.GNU-stack","",@progbits

	.text
	.file	"sqrt.ll"
	.globl	err                             // -- Begin function err
	.p2align	2
	.type	err,@function
err:                                    // @err
	.cfi_startproc
// %bb.0:                               // %entry
	fcmp	d0, d1
	stp	d0, d1, [sp, #-16]!
	.cfi_def_cfa_offset 16
	b.ge	.LBB0_2
// %bb.1:                               // %trueexp
	ldp	d0, d1, [sp]
	b	.LBB0_3
.LBB0_2:                                // %falseexp
	ldp	d1, d0, [sp]
.LBB0_3:                                // %endcond
	fsub	d0, d1, d0
	add	sp, sp, #16
	ret
.Lfunc_end0:
	.size	err, .Lfunc_end0-err
	.cfi_endproc
                                        // -- End function
	.globl	iterate                         // -- Begin function iterate
	.p2align	2
	.type	iterate,@function
iterate:                                // @iterate
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	d8, [sp, #32]                   // 8-byte Folded Spill
	str	x30, [sp, #40]                  // 8-byte Folded Spill
	.cfi_offset w30, -8
	.cfi_offset b8, -16
	mov	x8, #17197
	fmul	d2, d1, d1
	movk	x8, #60188, lsl #16
	fmov	d8, #2.00000000
	movk	x8, #14050, lsl #32
	stp	d0, d1, [sp]
	movk	x8, #16154, lsl #48
	str	d2, [sp, #24]
	str	x8, [sp, #16]
.LBB1_1:                                // %cond5
                                        // =>This Inner Loop Header: Depth=1
	ldr	d0, [sp, #24]
	ldr	d1, [sp]
	bl	err
	ldr	d1, [sp, #16]
	fcmp	d1, d0
	ldr	d0, [sp, #8]
	b.ge	.LBB1_3
// %bb.2:                               // %loop9
                                        //   in Loop: Header=BB1_1 Depth=1
	ldp	d2, d1, [sp]
	fdiv	d2, d2, d1
	fmul	d0, d1, d0
	str	d0, [sp, #24]
	fadd	d2, d1, d2
	fdiv	d2, d2, d8
	str	d2, [sp, #8]
	b	.LBB1_1
.LBB1_3:                                // %loopend18
	ldr	x30, [sp, #40]                  // 8-byte Folded Reload
	ldr	d8, [sp, #32]                   // 8-byte Folded Reload
	add	sp, sp, #48
	ret
.Lfunc_end1:
	.size	iterate, .Lfunc_end1-iterate
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
	b.eq	.LBB2_5
	b.vs	.LBB2_5
// %bb.1:                               // %falseexp
	ldr	d0, [sp, #8]
	fmov	d1, #1.00000000
	fcmp	d0, d1
	b.ge	.LBB2_3
// %bb.2:                               // %trueexp4
	fsub	d1, d1, d0
	b	.LBB2_4
.LBB2_3:                                // %falseexp7
	fmov	d1, #2.00000000
	fdiv	d1, d0, d1
.LBB2_4:                                // %endcond
	bl	iterate
.LBB2_5:                                // %endcond11
	ldr	x30, [sp], #16                  // 8-byte Folded Reload
	ret
.Lfunc_end2:
	.size	sqrt, .Lfunc_end2-sqrt
	.cfi_endproc
                                        // -- End function
	.section	".note.GNU-stack","",@progbits

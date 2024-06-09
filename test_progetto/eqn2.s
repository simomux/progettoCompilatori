	.text
	.file	"eqn2.ll"
	.globl	eqn2                            // -- Begin function eqn2
	.p2align	2
	.type	eqn2,@function
eqn2:                                   // @eqn2
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	str	x30, [sp, #80]                  // 8-byte Folded Spill
	.cfi_offset w30, -16
	fmov	d3, #-4.00000000
	fmul	d4, d1, d1
	stp	d0, d1, [sp]
	fmul	d3, d0, d3
	fmul	d3, d3, d2
	fadd	d3, d4, d3
	fcmp	d3, #0.0
	stp	d2, d3, [sp, #16]
	b.ge	.LBB0_3
// %bb.1:                               // %then
	movi	d2, #0000000000000000
	fsub	d1, d2, d3
	fsqrt	d0, d1
	fcmp	d0, d0
	b.vs	.LBB0_9
.LBB0_2:                                // %then.split
	ldp	d1, d3, [sp]
	fadd	d1, d1, d1
	fdiv	d3, d3, d1
	fdiv	d1, d0, d1
	fsub	d3, d2, d3
	stp	d0, d3, [sp, #32]
	str	d1, [sp, #48]
	b	.LBB0_7
.LBB0_3:                                // %else24
	b.mi	.LBB0_5
	b.gt	.LBB0_5
// %bb.4:                               // %then25
	ldp	d0, d1, [sp]
	movi	d2, #0000000000000000
	fadd	d0, d0, d0
	fdiv	d0, d1, d0
	movi	d1, #0000000000000000
	fsub	d0, d1, d0
	str	d0, [sp, #56]
	b	.LBB0_8
.LBB0_5:                                // %else35
	ldr	d1, [sp, #24]
	fsqrt	d0, d1
	fcmp	d0, d0
	b.vs	.LBB0_10
.LBB0_6:                                // %else35.split
	movi	d1, #0000000000000000
	ldr	d2, [sp, #8]
	fsub	d1, d1, d2
	ldr	d2, [sp]
	fadd	d2, d2, d2
	fadd	d3, d1, d0
	fsub	d1, d1, d0
	fdiv	d3, d3, d2
	fdiv	d1, d1, d2
	fmov	d2, #1.00000000
	stp	d0, d3, [sp, #64]
	str	d1, [sp, #88]
.LBB0_7:                                // %ifcont57
	fmov	d0, d3
.LBB0_8:                                // %ifcont57
	bl	printval
	ldr	x30, [sp, #80]                  // 8-byte Folded Reload
	movi	d0, #0000000000000000
	add	sp, sp, #96
	ret
.LBB0_9:                                // %call.sqrt
	fmov	d0, d1
	bl	sqrt
	movi	d2, #0000000000000000
	b	.LBB0_2
.LBB0_10:                               // %call.sqrt1
	fmov	d0, d1
	bl	sqrt
	b	.LBB0_6
.Lfunc_end0:
	.size	eqn2, .Lfunc_end0-eqn2
	.cfi_endproc
                                        // -- End function
	.section	".note.GNU-stack","",@progbits

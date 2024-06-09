	.text
	.file	"floor.ll"
	.globl	pow2                            // -- Begin function pow2
	.p2align	2
	.type	pow2,@function
pow2:                                   // @pow2
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x30, [sp, #16]                  // 8-byte Folded Spill
	.cfi_offset w30, -16
	fadd	d2, d1, d1
	str	d0, [sp, #8]
	str	d1, [sp, #24]
	fcmp	d0, d2
	b.ge	.LBB0_2
// %bb.1:                               // %trueexp
	ldr	d0, [sp, #24]
	b	.LBB0_3
.LBB0_2:                                // %falseexp
	ldr	d0, [sp, #24]
	fadd	d1, d0, d0
	ldr	d0, [sp, #8]
	bl	pow2
.LBB0_3:                                // %endcond
	ldr	x30, [sp, #16]                  // 8-byte Folded Reload
	add	sp, sp, #32
	ret
.Lfunc_end0:
	.size	pow2, .Lfunc_end0-pow2
	.cfi_endproc
                                        // -- End function
	.globl	intpart                         // -- Begin function intpart
	.p2align	2
	.type	intpart,@function
intpart:                                // @intpart
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x30, [sp, #16]                  // 8-byte Folded Spill
	.cfi_offset w30, -16
	fmov	d2, d0
	fmov	d3, #1.00000000
	movi	d0, #0000000000000000
	fcmp	d2, d3
	stp	d2, d1, [sp]
	b.lt	.LBB1_2
// %bb.1:                               // %falseexp
	ldr	d0, [sp]
	fmov	d1, #1.00000000
	bl	pow2
.LBB1_2:                                // %endcond
	fcmp	d0, #0.0
	str	d0, [sp, #24]
	b.mi	.LBB1_4
	b.gt	.LBB1_4
// %bb.3:                               // %trueexp6
	ldr	d0, [sp, #8]
	b	.LBB1_5
.LBB1_4:                                // %falseexp8
	ldp	d0, d2, [sp]
	ldr	d1, [sp, #24]
	fsub	d0, d0, d1
	fadd	d1, d2, d1
	bl	intpart
.LBB1_5:                                // %endcond14
	ldr	x30, [sp, #16]                  // 8-byte Folded Reload
	add	sp, sp, #32
	ret
.Lfunc_end1:
	.size	intpart, .Lfunc_end1-intpart
	.cfi_endproc
                                        // -- End function
	.globl	floor                           // -- Begin function floor
	.p2align	2
	.type	floor,@function
floor:                                  // @floor
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!                // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	movi	d1, #0000000000000000
	str	d0, [sp, #8]
	bl	intpart
	ldr	x30, [sp], #16                  // 8-byte Folded Reload
	ret
.Lfunc_end2:
	.size	floor, .Lfunc_end2-floor
	.cfi_endproc
                                        // -- End function
	.section	".note.GNU-stack","",@progbits

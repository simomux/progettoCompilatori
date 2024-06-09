	.text
	.file	"rand.ll"
	.globl	randk                           // -- Begin function randk
	.p2align	2
	.type	randk,@function
randk:                                  // @randk
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-32]!                // 8-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w30, -32
	adrp	x19, :got:seed
	adrp	x8, :got:a
	adrp	x20, :got:m
	ldr	x19, [x19, :got_lo12:seed]
	ldr	x8, [x8, :got_lo12:a]
	ldr	d0, [x19]
	ldr	d1, [x8]
	ldr	x20, [x20, :got_lo12:m]
	fmul	d1, d1, d0
	ldr	d0, [x20]
	fdiv	d0, d1, d0
	str	d1, [sp, #8]
	bl	floor
	ldr	d1, [x20]
	ldr	d2, [sp, #8]
	fmul	d0, d1, d0
	fsub	d2, d2, d0
	str	d2, [x19]
	fdiv	d0, d2, d1
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldr	x30, [sp], #32                  // 8-byte Folded Reload
	ret
.Lfunc_end0:
	.size	randk, .Lfunc_end0-randk
	.cfi_endproc
                                        // -- End function
	.globl	randinit                        // -- Begin function randinit
	.p2align	2
	.type	randinit,@function
randinit:                               // @randinit
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x30, x19, [sp, #16]             // 16-byte Folded Spill
	.cfi_offset w19, -8
	.cfi_offset w30, -16
	mov	x8, #281474972516352
	adrp	x19, :got:m
	movk	x8, #16863, lsl #48
	adrp	x9, :got:a
	mov	x10, #141012366262272
	ldr	x19, [x19, :got_lo12:m]
	movk	x10, #16592, lsl #48
	fmov	d1, x8
	ldr	x9, [x9, :got_lo12:a]
	str	d0, [sp, #8]
	str	x8, [x19]
	fdiv	d1, d0, d1
	str	x10, [x9]
	fmov	d0, d1
	bl	floor
	ldr	d1, [x19]
	adrp	x8, :got:seed
	fmul	d0, d1, d0
	ldr	d1, [sp, #8]
	ldr	x8, [x8, :got_lo12:seed]
	ldp	x30, x19, [sp, #16]             // 16-byte Folded Reload
	fsub	d1, d1, d0
	movi	d0, #0000000000000000
	str	d1, [x8]
	add	sp, sp, #32
	ret
.Lfunc_end1:
	.size	randinit, .Lfunc_end1-randinit
	.cfi_endproc
                                        // -- End function
	.type	seed,@object                    // @seed
	.comm	seed,8,8
	.type	a,@object                       // @a
	.comm	a,8,8
	.type	m,@object                       // @m
	.comm	m,8,8
	.section	".note.GNU-stack","",@progbits

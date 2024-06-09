	.text
	.file	"fibonacciIt.ll"
	.globl	fibo                            // -- Begin function fibo
	.p2align	2
	.type	fibo,@function
fibo:                                   // @fibo
	.cfi_startproc
// %bb.0:                               // %entry
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	mov	x8, #4607182418800017408
	fmov	d1, #1.00000000
	str	d0, [sp, #8]
	stp	xzr, x8, [sp, #16]
	str	x8, [sp, #32]
.LBB0_1:                                // %cond2
                                        // =>This Inner Loop Header: Depth=1
	ldr	d0, [sp, #8]
	ldr	d2, [sp, #32]
	fcmp	d2, d0
	ldr	d0, [sp, #24]
	b.ge	.LBB0_3
// %bb.2:                               // %loop5
                                        //   in Loop: Header=BB0_1 Depth=1
	ldp	d3, d2, [sp, #16]
	ldr	d4, [sp, #32]
	fadd	d2, d3, d2
	fadd	d3, d4, d1
	stp	d3, d0, [sp, #32]
	stp	d0, d2, [sp, #16]
	b	.LBB0_1
.LBB0_3:                                // %loopend12
	add	sp, sp, #48
	ret
.Lfunc_end0:
	.size	fibo, .Lfunc_end0-fibo
	.cfi_endproc
                                        // -- End function
	.section	".note.GNU-stack","",@progbits

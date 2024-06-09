define double @iterate(double %y, double %x) {
entry:
  %z = alloca double, align 8
  %eps = alloca double, align 8
  %x2 = alloca double, align 8
  %y1 = alloca double, align 8
  store double %y, ptr %y1, align 8
  store double %x, ptr %x2, align 8
  store double 1.000000e-04, ptr %eps, align 8
  br label %init

init:                                             ; preds = %entry
  %x3 = load double, ptr %x2, align 8
  %x4 = load double, ptr %x2, align 8
  %mulres = fmul double %x4, %x3
  store double %mulres, ptr %z, align 8
  br label %cond5

cond5:                                            ; preds = %loop14, %init
  %eps6 = load double, ptr %eps, align 8
  %z7 = load double, ptr %z, align 8
  %y8 = load double, ptr %y1, align 8
  %subres = fsub double %y8, %z7
  %lttest = fcmp ult double %subres, %eps6
  %eps9 = load double, ptr %eps, align 8
  %y10 = load double, ptr %y1, align 8
  %z11 = load double, ptr %z, align 8
  %subres12 = fsub double %z11, %y10
  %lttest13 = fcmp ult double %subres12, %eps9
  %andtest = select i1 %lttest13, i1 %lttest, i1 false
  %nottest = xor i1 %andtest, true
  br i1 %nottest, label %loop14, label %loopend23

loop14:                                           ; preds = %cond5
  %x15 = load double, ptr %x2, align 8
  %x16 = load double, ptr %x2, align 8
  %mulres17 = fmul double %x16, %x15
  store double %mulres17, ptr %z, align 8
  %x18 = load double, ptr %x2, align 8
  %y19 = load double, ptr %y1, align 8
  %addres = fdiv double %y19, %x18
  %x20 = load double, ptr %x2, align 8
  %addres21 = fadd double %x20, %addres
  %addres22 = fdiv double %addres21, 2.000000e+00
  store double %addres22, ptr %x2, align 8
  br label %cond5

loopend23:                                        ; preds = %cond5
  %x24 = load double, ptr %x2, align 8
  ret double %x24
}

define double @sqrt(double %y) {
entry:
  %y1 = alloca double, align 8
  store double %y, ptr %y1, align 8
  %y2 = load double, ptr %y1, align 8
  %eqtest = fcmp ueq double %y2, 1.000000e+00
  br i1 %eqtest, label %trueexp, label %falseexp

trueexp:                                          ; preds = %entry
  br label %endcond11

falseexp:                                         ; preds = %entry
  %y3 = load double, ptr %y1, align 8
  %lttest = fcmp ult double %y3, 1.000000e+00
  br i1 %lttest, label %trueexp4, label %falseexp7

trueexp4:                                         ; preds = %falseexp
  %y5 = load double, ptr %y1, align 8
  %y6 = load double, ptr %y1, align 8
  %subres = fsub double 1.000000e+00, %y6
  %calltmp = call double @iterate(double %y5, double %subres)
  br label %endcond

falseexp7:                                        ; preds = %falseexp
  %y8 = load double, ptr %y1, align 8
  %y9 = load double, ptr %y1, align 8
  %addres = fdiv double %y9, 2.000000e+00
  %calltmp10 = call double @iterate(double %y8, double %addres)
  br label %endcond

endcond:                                          ; preds = %falseexp7, %trueexp4
  %condval = phi double [ %calltmp, %trueexp4 ], [ %calltmp10, %falseexp7 ]
  br label %endcond11

endcond11:                                        ; preds = %endcond, %trueexp
  %condval12 = phi double [ 1.000000e+00, %trueexp ], [ %condval, %endcond ]
  ret double %condval12
}


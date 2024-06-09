define double @err(double %a, double %b) {
entry:
  %b2 = alloca double, align 8
  %a1 = alloca double, align 8
  store double %a, ptr %a1, align 8
  store double %b, ptr %b2, align 8
  %b3 = load double, ptr %b2, align 8
  %a4 = load double, ptr %a1, align 8
  %lttest = fcmp ult double %a4, %b3
  br i1 %lttest, label %trueexp, label %falseexp

trueexp:                                          ; preds = %entry
  %a5 = load double, ptr %a1, align 8
  %b6 = load double, ptr %b2, align 8
  %subres = fsub double %b6, %a5
  br label %endcond

falseexp:                                         ; preds = %entry
  %b7 = load double, ptr %b2, align 8
  %a8 = load double, ptr %a1, align 8
  %subres9 = fsub double %a8, %b7
  br label %endcond

endcond:                                          ; preds = %falseexp, %trueexp
  %condval = phi double [ %subres, %trueexp ], [ %subres9, %falseexp ]
  ret double %condval
}

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

cond5:                                            ; preds = %loop9, %init
  %z6 = load double, ptr %z, align 8
  %y7 = load double, ptr %y1, align 8
  %calltmp = call double @err(double %z6, double %y7)
  %eps8 = load double, ptr %eps, align 8
  %lttest = fcmp ult double %eps8, %calltmp
  br i1 %lttest, label %loop9, label %loopend18

loop9:                                            ; preds = %cond5
  %x10 = load double, ptr %x2, align 8
  %x11 = load double, ptr %x2, align 8
  %mulres12 = fmul double %x11, %x10
  store double %mulres12, ptr %z, align 8
  %x13 = load double, ptr %x2, align 8
  %y14 = load double, ptr %y1, align 8
  %addres = fdiv double %y14, %x13
  %x15 = load double, ptr %x2, align 8
  %addres16 = fadd double %x15, %addres
  %addres17 = fdiv double %addres16, 2.000000e+00
  store double %addres17, ptr %x2, align 8
  br label %cond5

loopend18:                                        ; preds = %cond5
  %x19 = load double, ptr %x2, align 8
  ret double %x19
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

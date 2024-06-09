define double @fibo(double %n) {
entry:
  %oldb = alloca double, align 8
  %i = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  %n1 = alloca double, align 8
  store double %n, ptr %n1, align 8
  store double 0.000000e+00, ptr %a, align 8
  store double 1.000000e+00, ptr %b, align 8
  br label %init

init:                                             ; preds = %entry
  store double 1.000000e+00, ptr %i, align 8
  br label %cond2

cond2:                                            ; preds = %loop5, %init
  %n3 = load double, ptr %n1, align 8
  %i4 = load double, ptr %i, align 8
  %lttest = fcmp ult double %i4, %n3
  br i1 %lttest, label %loop5, label %loopend12

loop5:                                            ; preds = %cond2
  %b6 = load double, ptr %b, align 8
  store double %b6, ptr %oldb, align 8
  %b7 = load double, ptr %b, align 8
  %a8 = load double, ptr %a, align 8
  %addres = fadd double %a8, %b7
  store double %addres, ptr %b, align 8
  %oldb9 = load double, ptr %oldb, align 8
  store double %oldb9, ptr %a, align 8
  %i10 = load double, ptr %i, align 8
  %addres11 = fadd double %i10, 1.000000e+00
  store double %addres11, ptr %i, align 8
  br label %cond2

loopend12:                                        ; preds = %cond2
  %b13 = load double, ptr %b, align 8
  ret double %b13
}


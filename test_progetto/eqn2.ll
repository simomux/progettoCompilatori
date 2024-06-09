declare double @sqrt(double)

declare double @printval(double, double, double)

define double @eqn2(double %a, double %b, double %c) {
entry:
  %x2 = alloca double, align 8
  %x1 = alloca double, align 8
  %delta38 = alloca double, align 8
  %x12 = alloca double, align 8
  %im = alloca double, align 8
  %re = alloca double, align 8
  %delta = alloca double, align 8
  %delta2 = alloca double, align 8
  %c3 = alloca double, align 8
  %b2 = alloca double, align 8
  %a1 = alloca double, align 8
  store double %a, ptr %a1, align 8
  store double %b, ptr %b2, align 8
  store double %c, ptr %c3, align 8
  %c4 = load double, ptr %c3, align 8
  %a5 = load double, ptr %a1, align 8
  %mulres = fmul double 4.000000e+00, %a5
  %mulres6 = fmul double %mulres, %c4
  %b7 = load double, ptr %b2, align 8
  %b8 = load double, ptr %b2, align 8
  %mulres9 = fmul double %b8, %b7
  %subres = fsub double %mulres9, %mulres6
  store double %subres, ptr %delta2, align 8
  %delta210 = load double, ptr %delta2, align 8
  %lttest = fcmp ult double %delta210, 0.000000e+00
  br i1 %lttest, label %then, label %else24

then:                                             ; preds = %entry
  %delta211 = load double, ptr %delta2, align 8
  %subres12 = fsub double 0.000000e+00, %delta211
  %calltmp = call double @sqrt(double %subres12)
  store double %calltmp, ptr %delta, align 8
  %a13 = load double, ptr %a1, align 8
  %mulres14 = fmul double 2.000000e+00, %a13
  %b15 = load double, ptr %b2, align 8
  %addres = fdiv double %b15, %mulres14
  %subres16 = fsub double 0.000000e+00, %addres
  store double %subres16, ptr %re, align 8
  %a17 = load double, ptr %a1, align 8
  %mulres18 = fmul double 2.000000e+00, %a17
  %delta19 = load double, ptr %delta, align 8
  %addres20 = fdiv double %delta19, %mulres18
  store double %addres20, ptr %im, align 8
  %re21 = load double, ptr %re, align 8
  %im22 = load double, ptr %im, align 8
  %calltmp23 = call double @printval(double %re21, double %im22, double 0.000000e+00)
  br label %ifcont57

else24:                                           ; preds = %entry
  %delta227 = load double, ptr %delta2, align 8
  %eqtest = fcmp ueq double %delta227, 0.000000e+00
  br i1 %eqtest, label %then25, label %else35

then25:                                           ; preds = %else24
  %a28 = load double, ptr %a1, align 8
  %mulres29 = fmul double 2.000000e+00, %a28
  %b30 = load double, ptr %b2, align 8
  %addres31 = fdiv double %b30, %mulres29
  %subres32 = fsub double 0.000000e+00, %addres31
  store double %subres32, ptr %x12, align 8
  %x1233 = load double, ptr %x12, align 8
  %calltmp34 = call double @printval(double %x1233, double 0.000000e+00, double 0.000000e+00)
  br label %ifcont2656

else35:                                           ; preds = %else24
  %delta236 = load double, ptr %delta2, align 8
  %calltmp37 = call double @sqrt(double %delta236)
  store double %calltmp37, ptr %delta38, align 8
  %a39 = load double, ptr %a1, align 8
  %mulres40 = fmul double 2.000000e+00, %a39
  %delta41 = load double, ptr %delta38, align 8
  %b42 = load double, ptr %b2, align 8
  %subres43 = fsub double 0.000000e+00, %b42
  %addres44 = fadd double %subres43, %delta41
  %addres45 = fdiv double %addres44, %mulres40
  store double %addres45, ptr %x1, align 8
  %a46 = load double, ptr %a1, align 8
  %mulres47 = fmul double 2.000000e+00, %a46
  %delta48 = load double, ptr %delta38, align 8
  %b49 = load double, ptr %b2, align 8
  %subres50 = fsub double 0.000000e+00, %b49
  %subres51 = fsub double %subres50, %delta48
  %addres52 = fdiv double %subres51, %mulres47
  store double %addres52, ptr %x2, align 8
  %x153 = load double, ptr %x1, align 8
  %x254 = load double, ptr %x2, align 8
  %calltmp55 = call double @printval(double %x153, double %x254, double 1.000000e+00)
  br label %ifcont2656

ifcont2656:                                       ; preds = %else35, %then25
  br label %ifcont57

ifcont57:                                         ; preds = %ifcont2656, %then
  ret double 0.000000e+00
}


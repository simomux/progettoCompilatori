declare double @floor(double)

@seed = common global double 0.000000e+00
@a = common global double 0.000000e+00
@m = common global double 0.000000e+00
define double @randk() {
entry:
  %tmp = alloca double, align 8
  %seed = load double, ptr @seed, align 8
  %a = load double, ptr @a, align 8
  %mulres = fmul double %a, %seed
  store double %mulres, ptr %tmp, align 8
  %m = load double, ptr @m, align 8
  %tmp1 = load double, ptr %tmp, align 8
  %addres = fdiv double %tmp1, %m
  %calltmp = call double @floor(double %addres)
  %m2 = load double, ptr @m, align 8
  %mulres3 = fmul double %m2, %calltmp
  %tmp4 = load double, ptr %tmp, align 8
  %subres = fsub double %tmp4, %mulres3
  store double %subres, ptr @seed, align 8
  %m5 = load double, ptr @m, align 8
  %seed6 = load double, ptr @seed, align 8
  %addres7 = fdiv double %seed6, %m5
  ret double %addres7
}

define double @randinit(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  store double 1.689700e+04, ptr @a, align 8
  store double 0x41DFFFFFFFC00000, ptr @m, align 8
  %m = load double, ptr @m, align 8
  %x2 = load double, ptr %x1, align 8
  %addres = fdiv double %x2, %m
  %calltmp = call double @floor(double %addres)
  %m3 = load double, ptr @m, align 8
  %mulres = fmul double %m3, %calltmp
  %x4 = load double, ptr %x1, align 8
  %subres = fsub double %x4, %mulres
  store double %subres, ptr @seed, align 8
  ret double 0.000000e+00
}


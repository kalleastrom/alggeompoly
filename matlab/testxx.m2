KK = ZZ / 30097;
R = KK[x1,x2,x3,x4,x5,x6,x7,x8];
eq1 = 6*x1 - 12*x3 + 5*x4 - 10*x6 + x7 - 2
eq2 = 2*x1 - 2*x3 + 5*x4 - 5*x6 + x7 - 1
eq3 = 9*x1 - 27*x3 + 9*x4 - 27*x6 + x7 - 3
eq4 = 3*x1 - 21*x3 + 3*x4 - 21*x6 + x7 - 7
eq5 = 6*x2 - 12*x3 + 5*x5 - 10*x6 + x8 - 2
eq6 = 2*x2 - 14*x3 + 5*x5 - 35*x6 + x8 - 7
eq7 = 9*x2 - 54*x3 + 9*x5 - 54*x6 + x8 - 6
eq8 = 3*x2 - 15*x3 + 3*x5 - 15*x6 + x8 - 5
eqs = {eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8};
I = ideal eqs;
gbTrace = 3
dim I, degree I
dimi = dim I;
degreei = degree I;
nrsols = degreei
a = gens gb I
lta = leadTerm a
 "testxx.m2.out" << dimi << endl << nrsols << endl << lta << endl << close
quit

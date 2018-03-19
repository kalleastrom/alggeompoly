with(Groebner):
F:={2*x1 + 5*x2 + x3,2*x1 + x2 + x3,9*x1 + 6*x2 + x3,x1^2 + x2^2 + x3^2 - 1}:
m_ord:=tdeg(x1,x2,x3):
G:=Basis(F,m_ord):
NormalSet(G,m_ord)[1]

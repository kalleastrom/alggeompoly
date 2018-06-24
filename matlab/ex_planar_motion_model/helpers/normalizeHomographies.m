function H = normalizeHomographies(H)

N = length(H);
for j = 1:N
   detH = det(H{j});
   sgn = sign(detH);
   tmp = H{j} / (sgn * det(sgn*detH)^(1/3));
   if ~isreal(tmp)
      warning('Normalization failed. Homography not real.')
   end
   if abs(det(tmp)-1) > 1e-10
      warning('Normalization failed. Determinant not 1.')
   end
   H{j} = tmp;
end

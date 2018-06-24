function K = crossm(k)
if numel(k) ~= 3
   error('Incorrect size of input vector.') 
end
K = [0 -k(3) k(2); k(3) 0 -k(1); -k(2) k(1) 0];
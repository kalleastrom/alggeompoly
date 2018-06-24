function H = solver_homography_planar_25pt_complete(x1, x2)

nbr_pts = 3;
assert(size(x1, 1) == nbr_pts)
assert(size(x2, 1) == nbr_pts)

x1 = double(x1);
x2 = double(x2);

% DLT equations and null space basis
dlt = [];
for k = 1:nbr_pts
    tmp = kron(x1(:,k)', crossm(x2(:,k)));
    dlt = [dlt; tmp(1:2,:)];
end
% Throw away one equation
dlt = dlt(1:5, :);
basis = null(dlt);

if numel(basis) ~= 9*4
    H = {eye(3)};
    return
end


sols = solver_homography_planar(basis(:));
real_sols = sols(:, imag(sols(1, :)) == 0);
nbr_real_sols = size(real_sols, 2);

H = cell(nbr_real_sols, 1);
for j = 1:nbr_real_sols
    coeffs = [real_sols(:, j); 1];   % Append constant term
    H{j} = reshape(sum(repmat(coeffs', 9, 1) .* double(basis), 2), 3, 3);
end


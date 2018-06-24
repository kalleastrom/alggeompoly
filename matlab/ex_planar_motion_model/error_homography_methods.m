function [err25pt, err4pt, reproj25pt, reproj4pt] = error_homography_methods(noise)
if nargin < 1
   noise = 0; 
end

% Generate compatible homographies
theta = rad2deg(20*rand-10);
psi = rad2deg(20*rand-10);
phis = rad2deg(90*rand-45);
ts = 10*rand(2, 1)-5;
data = generate_planar_motion_homographies(theta, psi, phis, ts);
H = data.H{1};

% Generate scene points
nbr_pts = 1000;
x1 = [randn(2, nbr_pts); ones(1, nbr_pts)];
x2 = pflat(H*x1);

x1orig = x1;
x2orig = x2;

% Add noise
x1 = x1+[noise*randn(2,nbr_pts); zeros(1,nbr_pts)];
x2 = x2+[noise*randn(2,nbr_pts); zeros(1,nbr_pts)];

% DLT equations
dlt = [];
for k = 1:4
    tmp = kron(x1(:,k)', crossm(x2(:,k)));
    dlt = [dlt; tmp(1:2,:)];
end

% Check the standard DLT approach (4pt) and use as reference
try
    H4pt = reshape(null(dlt), 3, 3);
    tmp = normalizeHomographies({H4pt});
    H4pt = tmp{1};
catch
    H4pt = eye(3);
end

err4pt = norm(H - H4pt, 'fro');

% Discard one point for minimal solver
x1d = x1(:,1:3);
x2d = x2(:,1:3);

H25pt = solver_homography_planar_25pt_complete(x1d, x2d);
w = warning ('off', 'all');
H25pt = normalizeHomographies(H25pt);
warning(w)
H25pt_opt = eye(3);

err25pt = inf;
for j = 1:length(H25pt)
    if norm(H - H25pt{j}, 'fro') < err25pt
        err25pt = norm(H - H25pt{j});
        H25pt_opt = H25pt{j};
    end
end

% Reprojection errors
x1 = x1orig(:,5:end);
x2 = x2orig(:,5:end);

x25pt = pflat(H25pt_opt*x1) - pflat(x2);
x4pt = pflat(H4pt*x1) - pflat(x2);

reproj25pt = mean(sqrt(sum(x25pt.^2,1)));
reproj4pt = mean(sqrt(sum(x4pt.^2,1)));






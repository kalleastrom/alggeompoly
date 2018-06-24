function data = generate_planar_motion_homographies(theta, psi, phis, ts)

% Sanity
N = length(phis);
if N ~= size(ts, 2) || N <= 0
    error('Wrong input')
end

% Allocate homographies (well, pointers at least...)
H = cell(1, N);

for j = 1:N
    % Fixed matrices
    Rtheta = rotm('y', theta);
    Rpsi = rotm('x', psi);   
    R = Rpsi * Rtheta;
    Tt = transm(ts(:, j));
    Rphi = rotm('z', phis(j));   
    
    % This is the general form as parametrised in the original article
    % by Wadenbäck and Heyden (2013)
    H{j} = R * Rphi * Tt * R';
end

data.H = H;
data.N = N;
end

function R = rotm(axis, angle)
% Generate a rotation matrix by ANGLE about the specified AXIS
if strcmp(axis, 'x')
    R = [1 0 0;
        0 cos(angle) -sin(angle);
        0 sin(angle) cos(angle)];
elseif strcmp(axis, 'y')
    R = [cos(angle) 0 sin(angle);
        0 1 0;
        -sin(angle) 0 cos(angle)];
elseif strcmp(axis, 'z')
    R = [cos(angle) -sin(angle) 0;
        sin(angle) cos(angle) 0;
        0 0 1];
else
    error('Incorrect axis specified.')
end
end

function Tmat = transm(t)
% Generate a translation matrix by translation t = (t_x, t_y)
Tmat = eye(3);
Tmat(1:2, 3) = -t;
end
%%
addpath ..
xx = create_vars(9+4+3);

% The homography consists of the first nine elements. These are the
% ones we want to derive the constraints on, i.e. we wish to find the
% elimination ideal containing only these variables
H = reshape(xx(1:9),3,3);

% We use the alternative parametrization where the camera moves parallell
% to an unknown plane, modeled by a rotation matrix R(q), with q being
% a quaternion.
q = [1;xx(10:12)];

% The scale parameter, due to global scale ambiguity
s = xx(13);

% The plane normal - in this parametrization it is the same as the unknowns
% of the quaternion (the rotation is about the plane normal)
n = q(2:4);

% The unknown translation (in this parametrization we have three unknwons,
% t_x, t_y, t_z, however they are not arbitrary, since the camera has to
% move in a plane parallell to the unknown plane. This gives rise to the
% condition t * n' = 0. (*)
t = xx(14:16);

% Convert quaternion to rotation matrix
R = quat2rot(q);

% Add constraints. The second constraint is due to (*).
eqs = s*H-(R+t*n');
eqs = [eqs(:); t'*n]

% Setup options
opt = default_options();
opt.M2_path = '/usr/bin/M2';

% Dummy, to be compatible with the automatic solver.
opt.variable_order = '';

% New helper function for elimination ideals (generates necessary M2 code)
out = eliminate_vars(eqs, 10:16, opt);

% Note: We only use the first 11 equations (quartic constraints) and
% discard the last (using it takes too much computational effort!)
out = out(1:10)'
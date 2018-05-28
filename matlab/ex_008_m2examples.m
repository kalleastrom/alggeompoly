%% Shared options
shared_opt = [];
shared_opt.M2_path = '/Applications/Macaulay2-1.4/bin/M2';

%% Generate list of problems (just one problem now
names = {};
problems = {};
options = {};
% Relative pose 5pt
addpath ex_relpose_5p
names{end+1} = 'relpose_5p';
problems{end+1} = @problem_relpose_5p;
options{end+1} = [];

%% concatenate options with shared options
k = 1;
opt = default_options(options{k});
opt = setstructfields(opt,shared_opt);
opt.reduce_expansion = 0; % Generate solver without reduction step

%solv_red = generate_solver([solv_name '_red'],problems{k},opt);

%% choose a problem and generate integer data equations
problem = problems{k};
eqs = problem();

%% Find monomial basis of quotient ring
[ basis ] = find_monomial_basis( eqs, opt )
solv.basis = basis;

%% Find multiplication monomials (what monomials to multiply the equations with)
solv.actmon = multipol(1,[1;0;0]); % Chooose action monomial 'x'
solv.reducible = solv.actmon * solv.basis;
solv.reducible(ismember(monvec2matrix(solv.reducible)',monvec2matrix(solv.basis)','rows')) = [];
id = num2str(feature('getpid'));
[As,opt] = find_expansion(eqs,solv.basis,solv.reducible,opt,id);


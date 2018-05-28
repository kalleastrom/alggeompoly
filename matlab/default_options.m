function opt = default_options(opt)
if nargin < 1 || isempty(opt)
    opt = struct();
end


default_opt = [];


% Path to Macaulay2
default_opt.M2_path = 'M2';

% Path to Singular
default_opt.singular_path = 'Singular';

% Backend for algebraic geometry computations
% Supported options are 'M2' and 'Singular'
default_opt.backend = 'M2';

% Action monomial. Can either be specified as an index or a vector.
% i.e. actmon = 3  =>  x3 
%  and actmon = [2;1;0]  =>  x1^2*x2
% Empty => tries to select action mon which gives fewest reducible
default_opt.actmon = [];

% If the integer expansions should be saved for future runs.
default_opt.cache_expansions = 0;

% If the problem has complex coefficients
default_opt.transform_C_to_Zp = 0;

% The number of integer expansions to run. Running multiple expansions for each problem
% is recommended.
default_opt.integer_expansions = 1;

% Linear solver for computing the action matrix
% The options are 'backslash' (default) | 'qr' | 'pinv' | 'qr_basis' | 'svd_basis'
% For the QR solver rank is determined as sum(r/r(1) > 1e-8)
% The options 'qr_basis' and 'svd_basis' corresponds to the online basis selection
% from Byröd et al. It is highly experimental and won't work for many problems.
default_opt.linear_solver = 'backslash';

% Matrix of [d, integer_expansions] where each column contains the data
% which is to be used for generating the integer instances.
% Default: [] => Let problem file generate random data.
default_opt.custom_data = [];

% Custom monomial basis for the quotient space. Note that this does not
% have to be an actual basis, any set of spanning monomials is fine.
default_opt.custom_basis = [];

% If the elimination template should be sparse. Use for large problems.
default_opt.sparse_template = 0;

% Removes 1 from the monomial basis if zero is a solution.
% TODO: think about this.
default_opt.remove_zero_sol = 0;

% Ensure extra monomials are reduced.
default_opt.extra_reducible = [];

% Force variables (x1,x2,x3,...) to be among the reducibles
% Note that this ensures a solution can always be extracted
% Setting this to 1 is equivalent to extra_reducible = create_vars(nvars)
default_opt.force_vars_in_reducibles = 0;

% If the evaluation of the coefficients should be optimized using MuPAD
default_opt.optimize_coefficients = 0;

% If the expansion should be simplified.
default_opt.reduce_expansion = 1;

% Remove unecessary equations after forming the template.
default_opt.equation_pruning = 0;

% If the solver should be written to file. Use for testing.
default_opt.write_to_file = 1;

% Output level for M2 (momomommmomomo?)
default_opt.M2_gbTrace = 0; % 3

% Quit after generating the template. (Useful for testing)
default_opt.stop_after_template = 0;

% Prime field to work in
default_opt.prime_field = 30097;

% Field for coefficients. ('complex' is available for singular).
default_opt.coefficient_field = 'Zp';

% Number of bits to store monomial exponents. Empty => default in M2
default_opt.M2_monomial_size = [];

% Order of variables
% (e.g. [4 3 2 1] to order the 4 variables in reverse order).
default_opt.monomial_order = [];

% Monomial ordering in M2
% e.g. 'GRevLex', 'Lex', 'GLex'
default_opt.M2_monomial_ordering = 'GRevLex';

% Variable weights for the monomial ordering
% Can either be a string or a matrix of weights
% Note that the opt.monomial_order is not taken into account!
default_opt.M2_weights = [];

% If symmetries should be removed.
default_opt.use_sym = 0;

% Check for variable aligned symmetries.
default_opt.find_sym = 0;

% The maximum p to check for find_sym=1.
default_opt.sym_max_p = 4;


% These parameter specify the symmetries, sym_cc specify the weights
% and sym_pp the corresponding degree. If find_sym=1 these will be
% populated automatically. Their sizes should be
%   size(sym_cc) = (number of variables) x (number of symmetries)
%   size(sym_pp) = (number of symmetries) x 1
%
% e.g.
%    sym_cc = [1 0 0; 0 1 1]', sym_pp = [2;2]
% corresponds to two 2-fold symmetries, one in the x1 and one in (x2,x3)
default_opt.sym_cc = [];
default_opt.sym_pp = [];

% The remainder to use for the basis monomials. 
% This can either be specified by a single number, or one per symmetry.
default_opt.sym_rem = 0;


% When generating the code we insert line breaks when printing
% coefficients. Keep default.
default_opt.max_str_len = 50;

% Use fast C++ code to read output from Macaulay2.
% Requires extract_monomials.cpp to be mexed.
default_opt.fast_monomial_extraction = 1;

% Skip computing expansion and load a precomputed result
default_opt.load_external_expansion = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experimental stuff below

default_opt.extract_sols_from_eigenvals = 0;

default_opt.partial_expansion = 0;
default_opt.partial_expansion_timer = 3600;
default_opt.subset_syz_reduction = [];

default_opt.saturate_mon = [];

default_opt.extraction_local_opt = 0;

% For linear_solver = qr_basis
default_opt.custom_permissible = [];

% merge into opt
fields = fieldnames(default_opt);
for k = 1:length(fields)
    if ~isfield(opt,fields{k}) || isempty(getfield(opt,fields{k}))
        opt = setfield(opt,fields{k},getfield(default_opt,fields{k}));
    end
end
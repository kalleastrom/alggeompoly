function [ basis ] = eliminate_vars( eqs, nbr, opt, id )
%ELIMINATE_VARS Computes the elimination ideal containing
%only the first NBR of variables.
%
% Implements the first method of
% http://www2.macaulay2.com/Macaulay2/share/doc/Macaulay2/Macaulay2Doc/html/_elimination_spof_spvariables.html

if isa(nbr, 'multipol')
    error('Not implemented yet.')
elseif isnumeric(nbr)
else
    error('Unsupported type.')
end

if nargin < 4 || isempty(id)
    id = num2str(feature('getpid'));
end


fname = ['test_eliminate_vars.'  id '.m2'];

if exist(fname,'file')
    delete(fname);
end

if ~exist('cache','dir')
    mkdir('cache')
end

fname_b = ['cache/eliminate_vars.' id '.txt'];
% TODO: Implement support for opt.M2_weights
%if ~opt.cache_expansions || ~(ex3ist(fname_b,'file'))
    [C, M] = polynomials2matrix(eqs);
    C = round(C);
    eqs = C*M;

    header = generate_ring_header( nvars(eqs(1)), opt );
        
    fid = fopen(fname,'w');
    fprintf(fid,header);    

    eqname = '';
    for i=1:length(eqs)
        fprintf(fid,'eq%u = %s\n',i,char(eqs(i),0));
        eqname = [eqname sprintf('eq%u,',i)]; %#ok
    end

    fprintf(fid,'eqs = {%s}\n',eqname(1:end-1));
    fprintf(fid,'I = ideal eqs;\n');   

    order = nbr;
    if ~isempty(opt.variable_order)
        % TODO: This probably does not work
        order = order(opt.variable_order);
    end
    varstr = '';
    for i=order
        varstr = [varstr sprintf('x%u,',i)];
    end

    fprintf(fid,'G = eliminate(I,{%s});\n',varstr(1:end-1));         
    fprintf(fid,'%s\n',[' "' fname_b '" << toString G << close']);
    fprintf(fid,'quit();\n');
    fclose(fid);

    eval(['! ' opt.M2_path ' ' fname '']);
    while ~exist(fname_b,'file')
        pause(1);
    end
%end

% read result
basis = readM2ideal(fname_b, nvars(eqs(1)));

if exist(fname,'file')
    delete(fname)
end

% if ~opt.cache_expansions    
%     delete(fname_b);
% end
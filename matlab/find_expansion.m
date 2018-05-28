function [ A, opt ] = find_expansion( eqs, basis, reducible, opt, id )

if nargin < 4 || isempty(id)
    id = num2str(feature('getpid'));
end


fname = ['testxx.'  id '.m2'];

if exist(fname,'file');
    delete(fname);
end

if ~exist('cache','dir')
    mkdir('cache')
end

fname_A = ['cache/matrix.' id '.txt'];


if ~opt.cache_expansions || ~exist(fname_A,'file')

    [C,M] = polynomials2matrix(eqs);
    C = round(C);
    eqs = C*M;

    fid = fopen(fname,'w');

    header = generate_ring_header( nvars(eqs(1)), opt );
    fprintf(fid,header);
    
    redstr = '';
    for i=1:length(reducible)
        redstr = [redstr sprintf('%s,',char(reducible(i),0))];
    end
    fprintf(fid,'red = matrix({{%s}});\n',redstr(1:end-1));

    basisstr = '';
    for i=1:length(basis)
        basisstr = [basisstr sprintf('%s,',char(basis(i),0))];
    end
    fprintf(fid,'b = matrix({{%s}});\n',basisstr(1:end-1));

    
    eqname = '';
    for i=1:length(eqs)
        fprintf(fid,'eq%u = %s\n',i,char(eqs(i),0));
        eqname = [eqname sprintf('eq%u,',i)]; %#ok
    end

    fprintf(fid,'eqs = matrix({{%s}});\n',eqname(1:end-1));
    fprintf(fid,'I = ideal eqs;\n');
    fprintf(fid,'gbTrace = %d;\n',opt.M2_gbTrace);    
    
    if ~isempty(opt.saturate_mon)
        fprintf(fid,'I0 = I;\n');
        fprintf(fid,'satmon = %s;\n',char(opt.saturate_mon,0));
        fprintf(fid,'I = saturate(I0,satmon);\n');
    end
    
    % Find normal set
    fprintf(fid,'Q = R/I;\nb0 = lift(basis Q,R);\nuse R\n');
    
    % Express basis in normal set
    fprintf(fid,'S = (coefficients(b%%I,Monomials => b0))_1;\n');
    
    fprintf(fid,'if numcols b0 <= numcols b then (\n');
    fprintf(fid,'  Sinv = transpose(S)*inverse(S*transpose(S));\n');
    fprintf(fid,') else (\n');
    fprintf(fid,'  Sinv = inverse(transpose(S)*S)*transpose(S);\n');
    fprintf(fid,')\n');
    
    % Construct action matrix
    fprintf(fid,'AM = Sinv*((coefficients(red%%I,Monomials => b0))_1);\n');
    
    % Construct target polynomials
    fprintf(fid,'pp = red - b*AM;\n');
    
    if ~isempty(opt.saturate_mon)  
        % Find N which lifts target polynomials into the original ideal
        fprintf(fid,'N = 0;\n');        
        fprintf(fid,'while pp*satmon^N %% I0 != 0 do (N=N+1);\n');
        fprintf(fid,'pp = pp*satmon^N;\n');
        fname_sat = [ 'cache/saturate_degree.' id '.txt'];        
        fprintf(fid,'%s\n',[' "' fname_sat '" << toString N << close;']);
    end
    
    % Express target polynomials in the generators
    fprintf(fid,'A = pp // eqs;\n');
        
    fprintf(fid,'gbRemove(I);\n');

    
    if opt.reduce_expansion
        fprintf(fid,'M = kernel eqs;\n');
        
        if opt.partial_expansion
            fprintf(fid,[
                'done = 0;\n', ...
                'count = 1;\n', ...
                'while done == 0 do (\n', ...
                ' try (\n', ...
                '  alarm %d;\n', ...
                '  gg = gb(M);\n', ...
                '  done = 1;\n', ...
                ' ) else (\n', ...
                '  print("Saving partial progess ... ", count);\n', ...
                '  gg = gb(M,StopBeforeComputation=>true);\n', ...
                '  A = A %% gg;\n', ...
                '  concatenate("partial_%s_",toString(count),".txt") << toString A << close;\n', ...
                '  count = count + 1;\n', ...
                '  print("Resuming gb computation.");\n', ...
                ' );\n', ...
                ');\n', ...
                'A = A %% gg;\n'], opt.partial_expansion_timer, id);
        else
            fprintf(fid,'A = A %% M;\n');        
        end
    end
    
    if ~isempty(opt.subset_syz_reduction)
        for num = opt.subset_syz_reduction
            fprintf(fid,'%s',subset_syz_reduction(num));
        end
    end
    
    fprintf(fid,'%s\n',[' "' fname_A '" << toString A << close;']);

    fprintf(fid,'quit();\n');
    fclose(fid);

    eval(['! ' opt.M2_path ' ' fname '']);
    while ~exist(fname_A,'file'),
        pause(1);
    end
end

% read result
if opt.fast_monomial_extraction
    A = extract_monomials(fname_A,length(eqs),length(reducible),nvars(eqs(1)));
else
    AA = readM2matrix(fname_A, nvars(eqs(1)));
    A = cell(size(AA));
    for k = 1:numel(A)
        [C,mon] = polynomials2matrix(AA(k));
        if C ~= 0
            A{k} = monvec2matrix(mon);
        else
            A{k} = zeros(nvars(eqs(1)),0);
        end
    end
end

if exist(fname,'file')
    delete(fname)
end

if ~opt.cache_expansions    
    delete(fname_A);    
end

if ~isempty(opt.saturate_mon) && exist(fname_sat,'file')
    fid = fopen(fname_sat);
    opt.saturate_degree = fscanf(fid,'%d');    
    fclose(fid);
    delete(fname_sat);
end





function str = subset_syz_reduction(num)
    str = sprintf('print("Removing syzygies with %d support.");\n',num);
    
    % generate looping
    prev = '0';
    for kk = 1:num
        str = [str sprintf('for i%d from %s to length(eqs)-1 do (\n',kk,prev)];
        prev = sprintf('i%d+1',kk);
    end
    
    % generate eq string
    eqs_str = sprintf('eqs_i%d, ',1:num);
    eqs_str = eqs_str(1:end-2);
    
    str = [str sprintf('SS = syz matrix({{%s}});\n',eqs_str)];
    str = [str sprintf('z = mutableMatrix(map(R^(length(eqs)),R^(numcols(SS)),0));\n')];
    str = [str sprintf('for l from 0 to numcols(SS)-1 do (\n')];
    for kk = 1:num
        str = [str sprintf('z_(i%d,l) = SS_(%d,l);\n',kk,kk-1)];
    end
    str = [str sprintf(');\nz = matrix(z);\nA = A %% z;\n')];
    
    % Close the loops
    for kk = 1:num
        str = [str sprintf(');\n')];        
    end   
end


end

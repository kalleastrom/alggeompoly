function [besterr,err] = benchmark_relpose_5p(rawsols,gt);       
% Compare solution with ground truth

err = zeros(1,length(rawsols));
Etrue = gt.E;
Etrue = Etrue/norm(Etrue,'fro');
for k = 1:length(rawsols);
    err(k) = min( norm( Etrue-rawsols(k).E,'fro') , ...
                  norm(-Etrue-rawsols(k).E,'fro') );
end
besterr = min(err);



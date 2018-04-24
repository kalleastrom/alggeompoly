function [rawsols]=postprocess_relpose_5p(rawdata,data,sols);
%

u = reshape(data,9,4);
for k = 1:size(sols,2);
    etmp = u*[1;sols(:,k)];
    Etmp = reshape(etmp,3,3);
    Etmp = Etmp/norm(Etmp,'fro');
    rawsols(k).E = Etmp;
end





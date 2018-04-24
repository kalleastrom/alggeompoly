function [data]=preprocess_relpose_5p(rawdata)
%

M = zeros(9,5);
for k = 1:5;
    tmp = rawdata.u1(:,k)*rawdata.u2(:,k)';
    M(:,k)=tmp(:);
end
[u,s,v]=svd(M);
data = u(:,6:end);
data = data(:);

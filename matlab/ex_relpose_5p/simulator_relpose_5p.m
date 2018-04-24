function [gt,rawdata] = simulator_relpose_5p();
%

P1 = randrot()*[eye(3) (-randn(3,1))];
P2 = randrot()*[eye(3) (-randn(3,1))];
E = ptobi(P1,P2);
U = [randn(3,5);ones(1,5)];

u1 = pflat(P1*U);
u2 = pflat(P2*U);

gt.P1 = P1;
gt.P2 = P2;
gt.U = U;
gt.E = E;
rawdata.u1 = u1;
rawdata.u2 = u2;

function [y,alpha]=pflat(x);
% [y,alpha]=pflat(x) - normalization of projective points.
% Do a normalization on the projective
% points in x. Each column is considered to
% be a point in homogeneous coordinates.
% Normalize so that the last coordinate becomes 1.
% WARNING! This is not good if the last coordinate is 0.
% INPUT :
%  x     - matrix in which each column is a point.
%        OR structure or imagedata object with points
% OUTPUT :
%  y     - result after normalization (in homogeneous coordinates)
%  alpha - depth

if isa(x,'structure') | isa (x,'imagedata'),
  x=getpoints(x);
end
[a,n]=size(x);
alpha=x(a,:);
y=x./(ones(a,1)*alpha);


function B=ptobi(P1,P2)
% B=ptobi(m,index)
% Calculates the bilinear tensor from the two camera matrices in MOTION m
%   index: specifies camera matrices in m (optional)
%   Default: index = [1 2]

for i=1:3
  for j=1:3
    B(i,j)=det([P1(1+mod(i,3),:) ; P1(1+mod(i+1,3),:) ; P2(1+mod(j,3),:) ; P2(1+mod(j+1,3),:)]);
  end
end



function R=randrot(direction);
% RANDROT - creates a rotation matrix that maps vectors in 'direction'
% towards the z-axis. The orientation around this axis is random.
% 'direction' is optional

if nargin==0,
  direction = 2*rand(3,3)-1;
end


[u,d,v]=svd(direction);

if det(u)<0,
 R=(u(:,[3 2 1]))';
else
 R=(u(:,[2 3 1]))';
end;

fi=rand*2*pi;
R=[cos(fi) sin(fi) 0;-sin(fi) cos(fi) 0;0 0 1]*R;

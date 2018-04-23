%% Generate four random points in image 1 and image 2

data = randi(10,20,1);

HH = randi(10,3,3);
HH(3,3)=1;
hhv = HH(:);
hhv = hhv(1:8)

u2 = [reshape(data(5:8,1),2,2);ones(1,2)];
u1 = HH*u2;

l1 = [reshape(data(9:14,1),3,2)];
%l2 = [reshape(data(15:20,1),3,2)];
l2 = HH'*l1;
%l2(1,1)=randi(20,1,1);

%%

x = create_vars(8);     % 8 unknown variables for the homography;
H = reshape([x;1],3,3);

%% 

% the points constraint is lambda u1 = H u2
% the line constraint is mu l2 = H' l1
%%

tmp1 = [u1(3,:);zeros(1,2);-u1(1,:)];
tmp2 = [zeros(1,2);u1(3,:);-u1(2,:)];

tmpl1 = [l2(3,:);zeros(1,2);-l2(1,:)];
tmpl2 = [zeros(1,2);l2(3,:);-l2(2,:)];


%%

eqs = [sum(tmp1.*(H*u2)) sum(tmp2.*(H*u2)) sum(tmpl1.*(H'*l1)) sum(tmpl2.*(H'*l1))]';

%%


%%

eqs


%%

res = runM2(eqs,'/Applications/Macaulay2-1.4/bin/M2')

%%

%eqs2maple(eqs,'tmp.mpl');


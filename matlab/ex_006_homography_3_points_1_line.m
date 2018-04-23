%% Generate four random points in image 1 and image 2

data = randi(10,18,1);

u1 = [reshape(data(1:6,1),2,3);ones(1,3)];
u2 = [reshape(data(7:12,1),2,3);ones(1,3)];

l1 = [reshape(data(13:15,1),3,1)];
l2 = [reshape(data(16:18,1),3,1)];

%%

x = create_vars(8);     % 8 unknown variables for the homography;
H = reshape([x;1],3,3);

%% 

% the points constraint is lambda u2 = H u1
% the line constraint is mu l1 = H' l2
%%

tmp1 = [ones(1,3);zeros(1,3);-u1(1,:)];
tmp2 = [zeros(1,3);ones(1,3);-u1(2,:)];

tmpl1 = [ones(1,1);zeros(1,1);-l2(1,:)];
tmpl2 = [zeros(1,1);ones(1,1);-l2(2,:)];


%%

eqs = [sum(tmp1.*(H*u2)) sum(tmp2.*(H*u2)) sum(tmpl1.*(H'*l1)) sum(tmpl2.*(H'*l1))]';

%%

eqs


%%

res = runM2(eqs,'/Applications/Macaulay2-1.4/bin/M2')

%%

%eqs2maple(eqs,'tmp.mpl');


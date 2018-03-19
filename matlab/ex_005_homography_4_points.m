%% Generate four random points in image 1 and image 2

data = randi(10,16,1);

u1 = [reshape(data(1:8,1),2,4);ones(1,4)];
u2 = [reshape(data(9:16,1),2,4);ones(1,4)];


%%

x = create_vars(8);     % 8 unknown variables for the homography;
H = reshape([x;1],3,3);


%%

tmp1 = [ones(1,4);zeros(1,4);-u1(1,:)];
tmp2 = [zeros(1,4);ones(1,4);-u1(2,:)];



%%

eqs = [sum(tmp1.*(H*u2)) sum(tmp2.*(H*u2))]';

%%

eqs


%%

res = runM2(eqs,'/Applications/Macaulay2-1.4/bin/M2')

%%

%eqs2maple(eqs,'tmp.mpl');


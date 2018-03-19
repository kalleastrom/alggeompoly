%% Generate a random linear algebra problem with a specific structure

data = randi(10,8,1);
A = [data(1:3) [data(4:5)';zeros(2,2)]];
b = data(6:8);

A

%%

x = create_vars(3);     % 3 unknown variables for the line paramters l = [a b c]';

%%

eqs = A*x-b;            % Three equations in three unknowns


%%

eqs


%%

res = runM2(eqs,'/Applications/Macaulay2-1.4/bin/M2')

%%

%eqs2maple(eqs,'tmp.mpl');


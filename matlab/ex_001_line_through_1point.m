%%

u = [randi(10,2,1);1];  % Generate a random point

%%

l = create_vars(3);     % 3 unknown variables for the line paramters l = [a b c]';

%%

eqs = u'*l;             % One equation that the line should go through the points
eqs = [eqs;l'*l-1];     % one equation that the line parameters should have length 1.
                        % i e the length of the l vector is not important


%%

eqs


%%

res = runM2(eqs,'/Applications/Macaulay2-1.4/bin/M2')


% Recreate the results in Wadenbäck et al. (ICIP 2016)

% The solvers are also available in C++ (approx. 500 times faster) using
% Eigen v.3 at https://github.com/marcusvaltonen/Homographies
% (Disclaimer: Name of repo may change in the future to GPMM (General
% Planar Motion Model).

noise_levels = [1e-3, 10^(-2.5), 1e-2, 10^(-1.5), 1e-1, 10^(-0.5)];
nbr_noise_levels = length(noise_levels);

N = 3000;

err25pt = zeros(nbr_noise_levels, N);
err4pt = zeros(nbr_noise_levels, N);

reproj25pt = zeros(nbr_noise_levels, N);
reproj4pt = zeros(nbr_noise_levels, N);

for j = 1:nbr_noise_levels
    fprintf(1,"%% Noise level %d\n", j)
    noise = noise_levels(j);
    w = warning('off', 'all');
    for k = 1:N
        [err25pt(j,k), err4pt(j,k), reproj25pt(j,k), reproj4pt(j,k)] = error_homography_methods(noise);
    end
    warning(w)
end


%% Plot 1 - Frobenius norm error

err25pt = err25pt';
err25pt = err25pt(:);
err4pt = err4pt';
err4pt = err4pt(:);

x = [err25pt', err4pt'];

arr = 1:2:2*nbr_noise_levels;
group = [reshape(repmat(arr, N, 1), 1, N*nbr_noise_levels),reshape(repmat(arr+1, N, 1), 1, N*nbr_noise_levels)];

spacing = [1 1.3];
positions = [];
for j = 0:nbr_noise_levels-1
    positions = [positions, spacing+j];
end

boxplot(x, group, 'positions', positions, 'OutlierSize',1, ...
    'Symbol', '', 'Colors', [0 0 1; 1 0 0], 'Widths',0.25)
set(gca, 'YScale', 'log')
ylim([0.3e-3, 60])
yticks([1e-3, 1e-1, 1e1])

% Make labels nicer
set(gca,'xtick',[(1:nbr_noise_levels)+0.25])
set(gca,'TickLabelInterpreter', 'latex', 'fontsize', 14);
set(gca,'xticklabel',{'$10^{-3}$','$10^{-2.5}$','$10^{-2}$','$10^{-1.5}$','$10^{-1}$','$10^{-0.5}$'})

color =  repmat('rb',1,nbr_noise_levels);
h = findobj(gca,'Tag','Box');
for j=length(h):-1:1
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.45);
end

c = get(gca, 'Children');

h = legend('2.5 pt' ,'4 pt (DLT)', 'Location', 'southeast');
set(h, 'fontsize', 14);
set(h, 'interpreter', 'latex');

ylabel('$||\mathbf{H}-\hat{\mathbf{H}}||_F$', 'Interpreter', 'latex', 'fontsize', 16)
xlabel('$\sigma_N$', 'Interpreter', 'latex', 'fontsize', 18)
set(gcf, 'position', [1     1   658   302])

%% Plot 2 - Reprojection error
% Note: In the article it was in fact the mean squared reprojection error.
figure(2)

reproj25pt = reproj25pt';
reproj25pt = reproj25pt(:);
reproj4pt = reproj4pt';
reproj4pt = reproj4pt(:);

x = [reproj25pt', reproj4pt'];

arr = 1:2:2*nbr_noise_levels;
group = [reshape(repmat(arr, N, 1), 1, N*nbr_noise_levels), ...
         reshape(repmat(arr+1, N, 1), 1, N*nbr_noise_levels)];

spacing = [1 1.3];
positions = [];
for j = 0:nbr_noise_levels-1
    positions = [positions, spacing+j];
end

boxplot(x, group, 'positions', positions, 'OutlierSize',1, ...
    'Symbol', '', 'Colors', [0 0 1; 1 0 0], 'Widths',0.25)
set(gca, 'YScale', 'log')
ylim([0.3e-3, 1e2])
yticks([1e-2, 1, 1e2])

% Make labels nicer
set(gca,'xtick',(1:nbr_noise_levels)+0.25)
set(gca,'TickLabelInterpreter', 'latex', 'fontsize', 14);
set(gca,'xticklabel',{'$10^{-3}$','$10^{-2.5}$','$10^{-2}$','$10^{-1.5}$','$10^{-1}$','$10^{-0.5}$'})

color =  repmat('rb',1,nbr_noise_levels);
h = findobj(gca,'Tag','Box');
for j=length(h):-1:1
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.45);
end

c = get(gca, 'Children');

h = legend('2.5 pt' ,'4 pt (DLT)', 'Location', 'southeast');
set(h, 'fontsize', 14);
set(h, 'interpreter', 'latex');

ylabel('Mean re-projection error', 'Interpreter', 'latex', 'fontsize', 16)
xlabel('$\sigma_N$', 'Interpreter', 'latex', 'fontsize', 18)
set(gcf, 'position', [1     1   658   302])
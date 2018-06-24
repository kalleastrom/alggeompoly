function x = pflat(x)
n = size(x, 1);
x = x ./ repmat(x(n, :), n, 1);
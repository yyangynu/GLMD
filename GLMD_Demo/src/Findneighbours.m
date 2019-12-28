function [M, distances] = Findneighbours (x, t)

[m, dim] = size(x);
[n, dim] = size(t);
M = zeros (m,1);
xttmp = zeros (n, m);

for i=1:dim
  xtmp = ones(n,1) * x(:,i)';
  ttmp = t(:,i)  * ones(1,m); 
  xttmp = xttmp + (xtmp - ttmp) .* (xtmp - ttmp);
end;

[min_dist, min_index] = min(xttmp);
distances = (sqrt(min_dist))';
M         = min_index';
end
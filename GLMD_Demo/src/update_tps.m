function [w,d,K]=update_tps(x,y,lamda)

n = size (x,1); x = [ones(n,1), x];
m = size (y,1); y = [ones(m,1), y];
K         = cal_K (x, x);
[q1,q2,R] = cal_QR(x);
[w,d]     = cal_wd (lamda,q1,q2,R,K,y);

function [q1,q2,R] = cal_QR(x)

[n,M] = size (x);
[q,r] = qr(x);
q1    = q(:, 1:M);
q2    = q(:, M+1:n);
R     = r(1:M,1:M);

function [K] = cal_K (x,z)

[n, M] = size (x); 
[m, M] = size (z);
dim    = M  - 1;

% 2D: K = r^2 * log r
% 3D: K = -r
K= zeros (n,m);

for it_dim=1:dim
  tmp = x(:,it_dim+1) * ones(1,m) - ones(n,1) * z(:,it_dim+1)';
  tmp = tmp .* tmp;
  K = K + tmp;
end;
  
if dim == 2
  mask = K < 1e-10; % to avoid singularity.  
  K = 0.5 * K .* log(K + mask) .* (K>1e-10);
else  
  mask = K < 1e-10; % to avoid singularity.    
  %K = - sqrt(K).* (K>1e-10);                % For Face3D
  K = 0.5 * K .* log(K + mask) .* (K>1e-10); % For 2D Demo cases
end

function [w,d] = cal_wd (lamda,q1,q2,R,K,y);

[n,M] = size(y);
% gamma = pinv (q2'*K*q2+lamda*eye(n-M, n-M)) * q2' * y;
gamma = (q2'*K*q2+lamda*eye(n-M, n-M))\ q2' * y;
w     =  q2 * gamma;
d     = pinv(R) * q1' * (y-K*q2*gamma);

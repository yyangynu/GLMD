function [xx] = update_xw(x,w,d,K)
  [n,dim] = size(x); x = [ones(n,1), x];
  xx = x*d + K*w;
  xx = xx(:,2:dim+1);
end
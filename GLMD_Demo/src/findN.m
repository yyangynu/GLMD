%==========================================================================
% Find K Closest Neighbor Points:
% -------------------------------------------------------------------------
% Copyright (C) 2012 Yang Yang, 
%                    Kelvin Weng Chiong Foong, 
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function [m] = findN(pointset,sNum)
n=size(pointset,1);
dims=size(pointset,2);
M = zeros (n, n);
m=zeros(n,sNum);
for i=1:dims
    M = M + (pointset(:,i) * ones(1,n) - ones(n,1) * pointset(:,i)').^2;  
end
M=sqrt(M);

for i=1:n
    [V I]=sort(M(i,:));
    m(i,:)=I(1,2:sNum+1);
end

end
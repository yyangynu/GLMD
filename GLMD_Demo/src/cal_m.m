%======================================================
% Calculate Corresponding Matrix
%======================================================
function [M] = cal_m(source,Nm,target,Nf,T) 
[n, dims] = size (source); %n为source点阵的点数
[m, dims] = size (target); %m为target点阵的点数
M0 = ones (n, m);
a00=  zeros (n, m);
%step1 计算source所有点的向量特征（输出点）
%vS

%step2 计算target所有点的向量特征（输出点）
%vT


for i=1:dims %循环dims次，dims代表维度
    a0=((source(:,i) * ones(1,m) - ones(n,1) * target(:,i)').^2); %全局距离
    %a0=((vS(:,i) * ones(1,m) - ones(n,1) * vT(:,i)').^2); 
    a000=(source(:,i) * ones(1,m) - ones(n,1) * target(:,i)'); %a000用于平移
    %计算Local距离
    for j=1:size(Nm,2)
    a00=a00+((source(Nm(:,j),i) * ones(1,m)-a000 - ones(n,1) * target(Nf(:,j),i)').^2);
    end
    M0=M0+a0+size(Nm,2)^2*T*(a00); %混合距离计算（也就是把global和local叠加在一起）
    a00=0;
end

if n==m % for non outlier case
    M=round(M0*1e6);
    M=lap(M);
else % for outlier case
    M=round(M0*1e6);
    M=lap_wrapper(M,1e9);
end

end
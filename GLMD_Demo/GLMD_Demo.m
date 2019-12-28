%==========================================================================
% Robust Global and Local Mixture Distance-based Point Matching (GLMD) Demo:
% -------------------------------------------------------------------------
% Copyright (C) 2012 Yang Yang,  
%                    Sim Heng Ong,
%                    Kelvin Weng Chiong Foong,
% 
%
% Contact Information:
% Yang Yang:		yyang_ynu@163.com
%==========================================================================

clear all


% Add path for reading codes
addpath('src');
% Load source point-set
Mpoints=load('examples\fish.mat'); % you can change to 'line','fish','fish2','fu','bird','Maple','hand','face' and 'face3D'
Mpoints=Mpoints.input;
% Mpoints=csvread('examples\face.csv'); 

% Rescale the source point-set to [0,1]
Mpoints(:,1)=(Mpoints(:,1)-min(Mpoints(:,1)))/(max(Mpoints(:,1))-min(Mpoints(:,1)));
Mpoints(:,2)=(Mpoints(:,2)-min(Mpoints(:,2)))/(max(Mpoints(:,2))-min(Mpoints(:,2)));

if mean(Mpoints(:,3))==0
    % Set control points
    points=[0 0 0;0.5 0 0;1 0 0;1 0.5 0;1 1 0;0.5 1 0;0 1 0;0 0.5 0];
    % Generate a random deformation target point-set
    cNum=size(points,1);
    wpoints=points;
    p1=randperm(cNum);
    xx_init=0.2;
    yy_init=0.2;
    for i=1:8 % The degree of deformation, you can change it to 1,2,3,4,5,6,7,8
        a=randperm(4);
        if a(1,1)==1
           xx_init=-xx_init(1,1);
           yy_init=yy_init(1,1);
        elseif a(1,1)==2
           xx_init=xx_init(1,1);
           yy_init=-yy_init(1,1);
        elseif a(1,1)==3
           xx_init=-xx_init(1,1);
           yy_init=-yy_init(1,1);    
        elseif a(1,1)==4
           xx_init=xx_init(1,1);
           yy_init=yy_init(1,1);
        end
        xx=xx_init;
        yy=yy_init;
        wpoints(p1(1,i),:)=wpoints(p1(1,i),:)+[xx yy 0];
    end

else
    Mpoints(:,3)=(Mpoints(:,3)-min(Mpoints(:,3)))/(max(Mpoints(:,3))-min(Mpoints(:,3)));
    %Set control points
    points=[0.5 0.5 0;0.5 0.5 1;0.5 0 0.5;1 0.5 0.5;0.5 1 0.5;0 0.5 0.5];
    cNum=size(points,1);
    wpoints=points;
    p1=randperm(cNum);   
    for j=1:3
        % Warping template 
        a=randperm(9);
        if a(1,1)==1
           xx=0.2; yy=0.2; zz=0.2;
        elseif a(1,1)==2
           xx=-0.2;yy=-0.2;zz=-0.2;
        elseif a(1,1)==3
           xx=-0.2;yy=-0.2;zz=0.2; 
        elseif a(1,1)==4
           xx=-0.2; yy=0.2;zz=-0.2; 
        elseif a(1,1)==5
           xx=0.2;yy=-0.2;zz=-0.2; 
        elseif a(1,1)==6
           xx=-0.2;yy=0.2;zz=-0.2;  
        elseif a(1,1)==7
           xx=-0.2;yy=0.2;zz=0.2; 
        elseif a(1,1)==8
           xx=0.2;yy=-0.2;zz=0.2;    
        elseif a(1,1)==9
           xx=0.2;yy=0.2;zz=-0.2;                    
        end
        wpoints(p1(1,j),:)=wpoints(p1(1,j),:)+[xx yy zz];
    end   
end


Fpoints=TPS3D(points, wpoints, Mpoints);
aa=randperm(size(Fpoints,1));
Fpoints=Fpoints(aa,:);

Mpoints(:,2)=Mpoints(:,2)+0.5; % This code (slightly translate Mpoints by 0.5 on Y axis) is for deformation Demo only. 
                               % If you want to run the demo on outlier, noise or rotation case, 
                               % please comment this code  

% Outlier Demo Setting
% rate=0.4;
% num=round(size(Fpoints,1)*rate);
% tx=randperm(num)/num;
% ty=randperm(num)/num;
% Fpoints=[Fpoints;[tx(1,1:num)' ty(1,1:num)' zeros(num,1)]];

% Noise Demo Setting
% Fpoints = imnoise(Fpoints,'gaussian',0,(0.02)^2);

% Rotation Demo Setting
% [Fpoints] = RotateObject(Fpoints,45); % For 2D
% [Fpoints] = Rotate3DObject(Fpoints,-15); % For 3D

% Calculate T_init and T_final
sizeM=size(Mpoints,1);
sizeF=size(Fpoints,1);
dis=zeros(sizeM,sizeF);
Tmax=zeros(sizeM,sizeM);
for i=1:3
    dis = dis + (Mpoints(:,i) * ones(1,sizeF) - ones(sizeM,1) * Fpoints(:,i)').^2; 
    Tmax = Tmax + (Mpoints(:,i) * ones(1,sizeM) - ones(sizeM,1) * Mpoints(:,i)').^2;
end
T=sqrt(max(max(dis)))/10
for i=1:sizeM
    [v,ind]=min(Tmax(i,:));
    Tmax(i,ind)=1000;
end
T_final=sum(min(Tmax'))/((sizeM)*8);

% Initial Parameters For display
Source=Mpoints; 
Target=Fpoints;

% Input Data
x= Mpoints; % source point-set
y= Fpoints; % target point-set
xw = x;     % Initial x^w


% Annealing Parameter
lambda_init = length(x);
anneal_rate = 0.7;

% Set 5 closest neighbor points
K=5;
Nm=findN(Mpoints,K);% Nm为（点数，5）的矩阵，第N行表示第N个点最近点的序号；
Nf=findN(Fpoints,K);

% Other parameter initialzations
acc=0;       % Error
flag_stop=0; % Stop fig
btn=0;       % for mouse click 
step=0;
lambda=lambda_init*length(x)*T; % Initial lambda

while (flag_stop ~= 1) 
    % Calculate matching error when T_final is reached
    if T <T_final || btn==1
       flag_stop =1;
       counter=0; 
       r=((Mpoints(aa,1)-Fpoints(1:size(Mpoints,1),1)).^2+(Mpoints(aa,2)-Fpoints(1:size(Mpoints,1),2)).^2+(Mpoints(aa,3)-Fpoints(1:size(Mpoints,1),3)).^2);
       R_Yang=[mean(r) std(r)]; 
       acc=mean(r);
    end
    
    
    %======================================================
    % Setting for display
    %====================================================== 
    figure(1); 
    set(0,'CurrentFigure',1) 
    set (gcf, 'color', [0 0 0]);
    hold off;
    
    % Source point-set   
    h_sub1 = subplot ('position', [0.05 0.6 0.2 0.3]); 
    plot3(Source(:,1),Source(:,2),Source(:,3),'+','color', [0 1 0], 'linewidth', 1,'MarkerSize',4);
    hold on;
    p=max(Source(:,1));
    view(90,90);
    axis ('equal'); axis ('off');
    title(sprintf('Source: %d points',sizeM),'color',[.5 .5 1],'FontWeight','bold');
    set(gca, 'box', 'on');

    % Target point-set
    h_sub2 = subplot ('position', [0.05 0.1 0.2 0.3]);
    plot3(Target(:,1),Target(:,2),Target(:,3),'o','color', [1 1 0], 'linewidth', 1,'MarkerSize',4);
    hold on;  
    axis ('equal'); axis ('off');
    view(90,90);
    title(sprintf('Target: %d points',sizeF),'color',[.5 .5 1],'FontWeight','bold');
    set(gca, 'box', 'on');   
    
    % Initial Poses  
    h_sub4 = subplot ('position', [0.75 0.6 0.2 0.3]); 
    plot3(Target(:,1),Target(:,2),Target(:,3),'o', 'color', [1 1 0], 'linewidth', 1,'MarkerSize',4);
    hold on;
    plot3(Source(:,1),Source(:,2),Source(:,3),'+','color', [0 1 0], 'linewidth', 1,'MarkerSize',4);
    hold on;
    axis ('equal'); axis ('off');
    view(90,90);
    title(sprintf('Initial Poses'),'color',[.5 .5 1],'FontWeight','bold');
    set(gca, 'box', 'on');     
   
    % Display Parameters  
    h_sub5 = subplot ('position', [0.75 0.3 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title('Parameter Setting','color',[.5 .5 1],'FontWeight','bold');
    set(gca, 'box', 'on'); 
    
    h_sub6 = subplot ('position', [0.75 0.25 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title(sprintf('T: %f',T),'color',[1 1 0],'FontWeight','bold');
    set(gca, 'box', 'on'); 
    
    h_sub7 = subplot ('position', [0.75 0.2 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title(sprintf('lambda: %f',lambda),'color',[1 1 0],'FontWeight','bold');
    set(gca, 'box', 'on');  
    
    h_sub8 = subplot ('position', [0.75 0.15 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title(sprintf('alpha: %f',K^2*T),'color',[1 1 0],'FontWeight','bold');
    set(gca, 'box', 'on');  
    
    h_sub9 = subplot ('position', [0.75 0.1 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title(sprintf('Iteration: %d',step),'color',[1 1 0],'FontWeight','bold');
    set(gca, 'box', 'on');  
    
    h_sub10 = subplot ('position', [0.75 0.05 0.2 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title(sprintf('Error: %f',acc),'color',[1 1 0],'FontWeight','bold');
    set(gca, 'box', 'on');

    h_sub11 = subplot ('position', [0.3 0.05 0.4 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title('Click Screen for Starting GLMDTPS Demo','color',[1 0 0],'FontWeight','bold');
    set(gca, 'box', 'on');
    
    h_sub12 = subplot ('position', [0.3 0 0.4 0.05]);
    axis ('equal'); axis ('off');
    hold on;
    view(90,90);   
    title('Copyright (C) 2012 Yang Yang','color',[1 1 1],'FontWeight','bold');
    set(gca, 'box', 'on');

    % Display Matching process
    h_sub3 = subplot ('position', [0.3 0.15 0.4 0.7]);
    plot3(Fpoints(:,1),Fpoints(:,2),Fpoints(:,3),'o', 'color', [1 1 0], 'linewidth', 2,'MarkerSize',6);
    hold on;
    plot3(Mpoints(:,1),Mpoints(:,2),Mpoints(:,3),'+','color', [0 1 0], 'linewidth', 2,'MarkerSize',6);
    hold on;   
    axis ('equal'); axis ('off');   
    view(90,90); 
    title(sprintf('GLMDTPS Demo'),'color',[.5 .5 1],'FontWeight','bold','FontSize',16);
    set(gca, 'box', 'on');     
    drawnow;
    
    if flag_stop==1 
       pause(2)  
       message = sprintf(['*********************************MESSAGE**********************************\n'...
       'The deformation of the target point set presenting here is \n'...
       'randomly set in each launch.\n' ... 
       'To demonstrate more matching examples on different deformations:\n' ...
       '(1): Please close the current window, and run the demo program again;\n'...
       '(2): OR change the source code at line 35.\n \n \n'... 
       'To run a matching demo on noise, outliers or rotation case:\n'... 
       'Please uncomment the source codes\n'... 
       'At line 98~102 for Outliers,\n'...
       'At line 105 for Noise,\n'...
       'At line 108 (or 109) for Rotation.\n\n'...
       '*Please comment the source code at line 93 for noise, outliers and rotation demo.'...
       ]);
       uiwait(msgbox(message));
    end
    %========================================================
    % A Global and Local Distance-based Point Mathicng Method
    %========================================================
    if btn==2
        % Calculate two-way corresponding matrix M    
        [m]=cal_m(xw,Nm,y,Nf,T); 

        % Update the correspondence x^c for the source point-set x
        xc=m*y;

        % Update TPS transformation
        lambda = lambda_init*T; %non-rigid warping
        [w,d,k]  = update_tps(x, xc, lambda);

        % Update the warping template x^w
        xw = update_xw(x,w,d,k);

        % Reduce T
        T  = T * anneal_rate;
        Mpoints=xw; % Output
    end
    
    % Start simulation by clicking GUI window
    if btn==0
       [mousex,mousey,btn] = ginput(1); 
       btn=2;
    end
    step=step+1;
end

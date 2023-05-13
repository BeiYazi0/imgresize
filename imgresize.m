function imgresize(filename,wscale,hscale)% wscale 为图片横向缩放比例, hscale 为图片纵向缩放比例
clear; %清空工作区
close all; %关闭所有窗口
clc; %清空命令区域
if nargin==0
    filename='a.jpg';
    wscale=2;
    hscale=2;
end
srcimg = imread(filename); % 从 filename 指定的文件读取图像
[H,W,~] = size(srcimg); % H 为图片高度, W 为图片宽度
Hnew = floor(H*hscale)+1; % 计算缩放后图片的高度
Wnew = floor(W*wscale)+1; % 计算缩放后图片的宽度
figure
imshow(srcimg) %在图窗中显示原始图片
title('原始图片')
Mnew1 = func_imresize(srcimg,Hnew,Wnew,H,W); 
figure
imshow(Mnew1) %在图窗中显示本实验方法缩放的图片
title('本实验方法运行效果')
Mnew2 = imresize(srcimg,[Hnew,Wnew]);
figure
imshow(Mnew2) %在图窗中显示 MATLAB 自带缩放函数缩放的图片
title('MATLAB 自带缩放函数运行效果')

function Mnew=func_imresize(img,Hnew,Wnew,H,W) % H 为原始图片高度, W 为原始图片宽度，Hnew 为缩放图片高度, Wnew 为缩放图片宽度
si=1:Hnew;       %缩放图片行索引
sj=1:Wnew;       %缩放图片列索引 
x=si*H/Hnew;     %对应点在原图行索引
y=sj*W/Wnew;     %对应点在原图列索引
[X,Y]=meshgrid(x,y);
I=fix(X);        %对应点在原图邻近点行索引
J=fix(Y);        %对应点在原图邻近点列索引
U=X-I;
V=Y-J;
D=U.*V;
A=1-U-V+D;
B=V-D;
C=U-D;
I=I(1,:);        
J=J(:,1);        
I(I==0)=1;       %边界处理
J(J==0)=1;       %边界处理
I(I>H-1)=H-1;    %边界处理
J(J>W-1)=W-1;    %边界处理
img=double(img); %将img矩阵转化为双精度类型
Mnew = uint8((A.').*img(I,J,1:3)+(B.').*img(I,J+1,1:3)+(C.').*img(I+1,J,1:3)+(D.').*img(I+1,J+1,1:3));

function Mnew=func_imresize1(img,Hnew,Wnew,H,W) % H 为原始图片高度, W 为原始图片宽度，Hnew 为缩放图片高度, Wnew 为缩放图片宽度
Mnew = uint8(zeros(Hnew,Wnew,3)); %创建一个三维矩阵用于记录缩放图片的信息
for si=1:Hnew                        %插值方法计算缩放后图片的像素值
    x=si*H/Hnew;
    i=fix(x);
    u=x-i;
    if i<1                    %边界处理
        i=1;
    end
    if i>H-1                  %边界处理
        i=H-1;
    end
    for sj=1:Wnew
        y=sj*W/Wnew;
        j=fix(y);
        v=y-j;
        if j<1                %边界处理
            j=1;
        end
        if j>W-1              %边界处理
            j=W-1;
        end
        a=(1-u)*(1-v);
        b=(1-u)*v;
        c=(1-v)*u;
        d=u*v;
        Mnew(si,sj,1:3)=a*img(i,j,1:3)+b*img(i,j+1,1:3)+c*img(i+1,j,1:3)+d*img(i+1,j+1,1:3);
    end
end
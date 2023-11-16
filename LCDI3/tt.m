clc;clear;close all;
Path_1K = '..\Fast_CGI\bmp_1K\';
Path_960_2160 = '..\Fast_CGI\_960_2160\';
Path_4K = '..\Fast_CGI\bmp_4K\';
Path_bicubic2K = '.\bicubic_2K\';
Path_LCDI3_2K = '.\LCDI3_2K\';
m = 540;
n = 960;
scale = 4;
load(strcat('W_VL1.mat'));
load(strcat('W_VL2.mat'));
load(strcat('W_VU1.mat'));
load(strcat('W_VU2.mat'));
load(strcat('W_HR1.mat'));
load(strcat('W_HR2.mat'));
load(strcat('W_HL1.mat'));  
load(strcat('W_HL2.mat'));
for k=201:225
   img_1K = imread(strcat('E:\Users\MATLAB\image\DIV2K_valid_LR\',num2str(k),'.bmp'));
   img_1K_yuv   = uint8(rgb2ycbcr(img_1K));
   img_1K_gray  = img_1K_yuv(:,:,1);
   img_960_2160_gray_gen = uint8(zeros(scale*m,n));
   img_4K_gray_gen = uint8(zeros(scale*m,scale*n));
   img_4K_gen = uint8(zeros(scale*m,scale*n,3));
   a=img_1K_gray(1,:);
   c=img_1K_gray(m,:);                           
   img_extV=double([a;img_1K_gray;c]);  %扩展两行
   % 垂直插值
   for i=2:m+1
      for j=1:n
         C    = GetC(img_extV, i, j, 1);
         img_960_2160_gray_gen(4*(i-1)-3,j) = img_extV(i-1,j)*W_VU1(C+1,1) + img_extV(i,j)*W_VU1(C+1,2) + img_extV(i+1,j)*W_VU1(C+1,3);
         img_960_2160_gray_gen(4*(i-1)-2,j) = img_extV(i-1,j)*W_VU2(C+1,1) + img_extV(i,j)*W_VU2(C+1,2) + img_extV(i+1,j)*W_VU2(C+1,3);
         img_960_2160_gray_gen(4*(i-1)-1,j) = img_extV(i-1,j)*W_VL1(C+1,1) + img_extV(i,j)*W_VL1(C+1,2) + img_extV(i+1,j)*W_VL1(C+1,3);
         img_960_2160_gray_gen(4*(i-1),j)   = img_extV(i-1,j)*W_VL2(C+1,1) + img_extV(i,j)*W_VL2(C+1,2) + img_extV(i+1,j)*W_VL2(C+1,3);
      end
   end
   
   a=img_960_2160_gray_gen(:,1);
   c=img_960_2160_gray_gen(:,n);                            
   img_extH=double([a img_960_2160_gray_gen c]);  %扩展两列   
   % 水平插值  
   for i=1:m*scale
      for j=2:n+1
         C    = GetC(img_extH, i, j, 2);
         img_4K_gray_gen(i,4*(j-1)-3) = img_extH(i,j-1)*W_HL1(C+1,1) + img_extH(i,j)*W_HL1(C+1,2) + img_extH(i,j+1)*W_HL1(C+1,3);
         img_4K_gray_gen(i,4*(j-1)-2) = img_extH(i,j-1)*W_HL2(C+1,1) + img_extH(i,j)*W_HL2(C+1,2) + img_extH(i,j+1)*W_HL2(C+1,3);
         img_4K_gray_gen(i,4*(j-1)-1) = img_extH(i,j-1)*W_HR1(C+1,1) + img_extH(i,j)*W_HR1(C+1,2) + img_extH(i,j+1)*W_HR1(C+1,3);
         img_4K_gray_gen(i,4*(j-1))   = img_extH(i,j-1)*W_HR2(C+1,1) + img_extH(i,j)*W_HR2(C+1,2) + img_extH(i,j+1)*W_HR2(C+1,3);
      end
   end   
   img_4K_gen(:,:,1) = img_4K_gray_gen;
   img_4K_gen(:,:,2) = imresize(img_1K_yuv(:,:,2), 4, 'bicubic');
   img_4K_gen(:,:,3) = imresize(img_1K_yuv(:,:,3), 4, 'bicubic');
   LCDI3_4K = ycbcr2rgb(img_4K_gen);
   imwrite(LCDI3_4K, strcat('C:\Users\lenovo\Documents\1docs\集创赛\JJW4K\val\LR\',num2str(k),'.bmp'));   
end



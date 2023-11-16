clc;clear;close all;
Path_1K = '..\Fast_CGI\bmp_1K\';
Path_960_2160 = '..\Fast_CGI\_960_2160\';
Path_4K = '..\Fast_CGI\bmp_4K\';
m = 540;
n = 960;

for Cvalue=1:80
   dataC= 1:7;
   for k=0:46
      img_1K = imread(strcat(Path_1K,num2str(k),'.bmp'));
      img_960_2160 = imread(strcat(Path_960_2160,num2str(k),'.bmp'));
      img_1K_yuv   = uint8(rgb2ycbcr(img_1K));
      img_960_2160_yuv   = uint8(rgb2ycbcr(img_960_2160));
      img_1K_gray  = img_1K_yuv(:,:,1);
      img_960_2160_gray  = img_960_2160_yuv(:,:,1);
      % 1.提取V
      for i=2:m-1
         for j=1:n
            C    = GetC(img_1K_gray, i, j, 1);
            if C == Cvalue
            data = [img_1K_gray(i-1,j) img_960_2160_gray(4*i-3,j) img_960_2160_gray(4*i-2,j)...
                    img_1K_gray(i,  j) img_960_2160_gray(4*i-1,j) img_960_2160_gray(4*i,j) img_1K_gray(i+1,j)];
            dataC = [dataC;data];
            end
         end
      end
      [len,~] = size(dataC);
      if len > 200000
         break;
      end
   end
   save(strcat('CV',num2str(Cvalue),'.mat'),'dataC');
end





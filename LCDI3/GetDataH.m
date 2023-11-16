clc;clear;close all;
Path_4K = '..\Fast_CGI\bmp_4K\';
Path_960_2160 = '..\Fast_CGI\_960_2160\';
m = 1080;
n = 960;

for Cvalue=41:80
   dataC= 1:7;
   for k=0:46
      img_960_2160 = imread(strcat(Path_960_2160,num2str(k),'.bmp'));
      img_4K = imread(strcat(Path_4K,num2str(k),'.bmp'));
      img_960_2160_yuv   = uint8(rgb2ycbcr(img_960_2160));
      img_4K_yuv   = uint8(rgb2ycbcr(img_4K));
      img_960_2160_gray  = img_960_2160_yuv(:,:,1);
      img_4K_gray  = img_4K_yuv(:,:,1);
      % 1.提取V
      for i=1:m*2
         for j=2:n-1
            C    = GetC(img_960_2160_gray, i, j, 2);
            if C == Cvalue
            data = [img_960_2160_gray(i,j-1) img_4K_gray(i,4*j-3) img_4K_gray(i,4*j-2)...
                    img_960_2160_gray(i,j)   img_4K_gray(i,4*j-1) img_4K_gray(i,4*j) img_960_2160_gray(i,j+1)];
            dataC = [dataC;data];
            end
         end
      end
      [len,~] = size(dataC);
      if len > 200000
         break;
      end
   end
   save(strcat('CH',num2str(Cvalue),'.mat'),'dataC');
end





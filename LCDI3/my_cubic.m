clc;clear;close all;
Path_1K = '.\downscaled\';
m = 540;
n = 960;
scale = 4;
x = (1:m*4)';
y = (1:n*4)';
[weight_x,indices_x] = sw(x,4,m);
[weight_y,indices_y] = sw(y,4,n);

for i=0:46
   img_1K = imread(strcat(Path_1K,num2str(i),'.bmp'));
   img_1K_yuv = uint8(rgb2ycbcr(img_1K));
   img_gray  = img_1K_yuv(:,:,1);
   img_yuv_2 = img_1K_yuv(:,:,2);
   img_yuv_3 = img_1K_yuv(:,:,3);
%  
   img_gray_4K = resizeAlongX(img_gray, 2160, weight_x, indices_x);
   img_gray_4K = resizeAlongY(img_gray_4K, 3840, weight_y, indices_y);   
% 
   img_4K_recon(:,:,1) = img_gray_4K;
   img_4K_recon(:,:,2) = imresize(img_yuv_2, 4, 'bicubic');
   img_4K_recon(:,:,3) = imresize(img_yuv_3, 4, 'bicubic');
   Mybicubic_4K = ycbcr2rgb(img_4K_recon);
   imwrite(Mybicubic_4K, strcat('.\Mybicubic_4K\',num2str(i),'.bmp'));
end


% [B, map] = postprocessImage(B, params);
function out = resizeAlongX(in, len, weights, indices)
out = uint8(zeros(len, 960));
   for i = 1:len
      sum = 0;
      for j=1:4
      sum = sum + double(in(indices(i,j),:))*weights(i,j);
      end
      out(i,:) = sum;
   end
end

function out = resizeAlongY(in, len, weights, indices)
out = uint8(zeros(2160, len));
   for i = 1:len
      sum = 0;
      for j=1:4
      sum = sum + double(in(:,indices(i,j)))*weights(i,j);
      end
      out(:,i) = sum;
   end
end

function [weights,indices] = sw(x,scale,len)
P = ceil(scale) + 2;             % maximum number of pixels that can be involved in the computation
u = x/scale + 0.5 * (1 - 1/scale);
left = floor(u - scale/2);
indices = bsxfun(@plus, left, 0:P-1);   % indices of the input pixels involved in computing
% aaa = bsxfun(@minus, u, indices);
weights = mycubic(bsxfun(@minus, u, indices));
% Normalize the weights matrix so that each row sums to 1.
weights = bsxfun(@rdivide, weights, sum(weights, 2));
% Mirror out-of-bounds indices; equivalent of doing symmetric padding
aux = [1:len,len:-1:1];
indices = aux(mod(indices-1,length(aux)) + 1);
% If a column in weights is all zero, get rid of it.
kill = find(~any(weights, 1));
   if ~isempty(kill)
       weights(:,kill) = [];
       indices(:,kill) = [];
   end

end

function f = mycubic(x)
absx = abs(x);
absx2 = absx.^2;
absx3 = absx.^3;

f = (1.5*absx3 - 2.5*absx2 + 1) .* (absx <= 1) + ...
    (-0.5*absx3 + 2.5*absx2 - 4*absx + 2) .* ...
    ((1 < absx) & (absx <= 2));
end


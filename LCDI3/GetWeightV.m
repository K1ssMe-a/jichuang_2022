clc;clear;close all;

W_VU1 = 1:3;
W_VU2 = 1:3;
W_VL1 = 1:3;
W_VL2 = 1:3;
for k=0:80
   dataC  = load(strcat('CH', num2str(k),'.mat'));
   [len,~] = size(dataC.dataC);
   x  = dataC.dataC(2:len,1:3);
%    x(:,4) = 1;
   yU1 = dataC.dataC(2:len,4);
   yU2 = dataC.dataC(2:len,5);
   yL1 = dataC.dataC(2:len,6);
   yL2 = dataC.dataC(2:len,7);
   W_VU1 = [W_VU1;regress(double(yU1),double(x))']; 
   W_VU2 = [W_VU2;regress(double(yU2),double(x))'];
   W_VL1 = [W_VL1;regress(double(yL1),double(x))'];
   W_VL2 = [W_VL2;regress(double(yL2),double(x))']; 
end
    
% yyy = dataC.dataC(2:len,1)*W_VU(1)+dataC.dataC(2:len,2)*W_VU(2)+dataC.dataC(2:len,3)*W_VU(3)+W_VU(4);
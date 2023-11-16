clc;clear;close all;

W_HL1 = 1:3;
W_HL2 = 1:3;
W_HR1 = 1:3;
W_HR2 = 1:3;
for k=0:80
   dataC  = load(strcat('CH', num2str(k),'.mat'));
   [len,~] = size(dataC.dataC);
   x  = dataC.dataC(2:len,1:3);
%    x(:,4) = 1;
   yL1 = dataC.dataC(2:len,4);
   yL2 = dataC.dataC(2:len,5);
   yR1 = dataC.dataC(2:len,6);
   yR2 = dataC.dataC(2:len,7);
   W_HL1 = [W_HL1;regress(double(yL1),double(x))']; 
   W_HL2 = [W_HL2;regress(double(yL2),double(x))'];
   W_HR1 = [W_HR1;regress(double(yR1),double(x))'];
   W_HR2 = [W_HR2;regress(double(yR2),double(x))']; 
end
   
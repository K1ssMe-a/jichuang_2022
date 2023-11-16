function img_sharpen = RCAS(img,k) 
% //    w                n
% //  w 1 w  for taps  w m e 
% //    w                s
% //  output = (w*(n+e+w+s)+m)/(4*w+1)
% // RCAS solves for 'w' by seeing where the signal might clip out of the {0 to 1} input range,
% //  0 == (w*(n+e+w+s)+m)/(4*w+1) -> w = -m/(n+e+w+s)
% //  1 == (w*(n+e+w+s)+m)/(4*w+1) -> w = (1-m)/(n+e+w+s-4*1)
% // Then chooses the 'w' which results in no clipping, limits 'w', and multiplies by the 'sharp' amount.
% // This solution above has issues with MSAA input as the steps along the gradient cause edge detection issues.
% // So RCAS uses 4x the maximum and 4x the minimum (depending on equation)in place of the individual taps.
% // As well as switching from 'm' to either the minimum or maximum (depending on side), to help in energy conservation.
% // This stabilizes RCAS.
% // RCAS does a simple highpass which is normalized against the local contrast then shaped,
% //       0.25
% //  0.25  -1  0.25
% //       0.25
% // This is used as a noise detection filter, to reduce the effect of RCAS on grain, and focus on real edges.
[x, y] = size(img);
img_sharpen = double(zeros(x,y));
a=img(1,:);
c=img(x,:);                            
b=[img(1,1);img(:,1);img(x,1)];
d=[img(1,y);img(:,y);img(x,y)];
a1=[a;img;c];
img_ext = double([b a1 d]);   
for i=2:x+1 
   for j=2:y+1
      MIN = min([img_ext(i,j-1),img_ext(i,j+1),img_ext(i,j),img_ext(i-1,j),img_ext(i+1,j)]);
      MAX = max([img_ext(i,j),img_ext(i,j),img_ext(i,j),img_ext(i,j),img_ext(i,j)]);
      weight = max([-MIN/(4*MAX),(1-MAX)/(4*MIN-4)])*k;
      img_sharpen(i-1,j-1) = (weight*(img_ext(i,j-1)+img_ext(i,j+1)+img_ext(i-1,j)+img_ext(i+1,j))+img_ext(i,j))/(4*weight+1);
   end
end

end

function C = GetC(img, i, j, dir)
% img = int8(img);
   switch dir
    case 1   %垂直
       G0 = int8(img(i-1,j))-int8(img(i,j));
       G1 = int8(img(i+1,j))-int8(img(i,j));
    case 2   %水平
       G0 = int8(img(i,j-1))-int8(img(i,j));
       G1 = int8(img(i,j+1))-int8(img(i,j));
   end   
   C = GetSub_C(G0)+GetSub_C(G1)*9;  
end
% 8 = 8+0*9    72 = 0 + 8*9
function Sub_C = GetSub_C(G0)
    if(G0>=-4 && G0<4)
       Sub_C = 4;
    elseif(G0>=-16 && G0<-4)
       Sub_C = 5;
    elseif(G0>=4 && G0<16)
       Sub_C = 3;
    elseif(G0>=-32 && G0<-16)
       Sub_C = 6;
    elseif(G0>=16 && G0<32)
       Sub_C = 2;
    elseif(G0>=-48 && G0<-32)
       Sub_C = 7;
    elseif(G0>=32 && G0<48)
       Sub_C = 1;
    elseif(G0<-48)
       Sub_C = 8;
    else
       Sub_C = 0;
    end
end
             
clear all;
close all;
clc;
% De-noising
load image9.mat;                           %loading the given image
X= IMAGE;
[f1,f2]=freqspace(128);                         %frequency space
[x,y]=meshgrid(f1,f2);
Hd=zeros(size(x));                         
r=sqrt(x.^2 + y.^2);
d=find(r<0.8);
Hd(d)=ones(size(d));
h = fwind1(Hd,boxcar(21),boxcar(21));            %since the noise spectrum has un-sharped edges, boxcar is used
meshgrid(h);
figure
freqz2(h)                                        %frequency response of HPF
title('frequency spectrum');
Y =filter2(h,X);
figure(2)
subplot(1,2,1)
imshow(mat2gray(X));
title('Original image');
subplot(1,2,2)
imshow(mat2gray(Y));
title('De-noised image');
 %Original image vs De-noised image
title('Original image vs De-noised image');
d1 = X-Y;
figure
imshow(d1);
title('The removed noise');

%% De-warping shifting of pixels of image 
R0 = 318;

for i=1:380
    for j=1:380
        x = j - 190.5;
        y = 190.5 - i;
        x1 = abs(x);
        y1 = abs(y);
        angle = atan(y1/x1);
        r1 = x1/cos(angle);
        r = R0 * real(asin((r1/R0)));
        x1 = cos(angle) * r;
        y1 = sin(angle) * r;
        if x < 0
            x1 = -x1;
        end
        if y < 0
            y1 = -y1;
        end
        i1 = round(226 - y1);                                            
        j1 = round(x1 + 226);
        w(i1,j1) = Y(i,j);
    end
end
figure(5);
imshowpair(mat2gray(Y),mat2gray(w),'montage');
title('Un-warped Image');
w1=w;
%% Removing Horizontal and vertical black lines
len = length(w);
for i=2:len-1
   for j=2:len-1
       if(w(i,j)==0)
           w1(i,j)=(w1(i-1,j)+w1(i+1,j)+w1(i+1,j+1)+w1(i,j-1)+w1(i,j+1)+w1(i-1,j-1)+w1(i-1,j+1)+w1(i+1,j-1))/7;
       end
           
   end
end
G2=medfilt2(w1);
% W = imresize(w1,480/length(w1));                      
figure(6),imshowpair(mat2gray(X),mat2gray(w1),'montage');
title('Original image Vs de-warped output');

%% De-blurring
[f1,f2]=freqspace(64);
 [x,y]=meshgrid(f1,f2);
 Hd=zeros(size(x));
 r=sqrt(x.^2 + y.^2);
 d=find(r<0.8);
 Hd(d)=ones(size(d));
 h2=fwind1(Hd,hamming(3));
Y1=inverseFilter(G2,h2,1);  
figure;
imshowpair(mat2gray(G2),mat2gray(Y1),'montage');
title('Deblurred image');
d = G2-Y1;
figure
imshow(d);
title('The removed blurring');


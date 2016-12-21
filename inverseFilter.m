function R = inverseFilter(y,h,g);        %g-gamma(threshold)
N = size(y,1);
Y = fft2(y);
H = fft2(h,N,N);
a = abs(H)>0;
b = abs(H)==0;

Hf = H.*(a)+1/g*(b);
i_Hf = 1./Hf;             %inverse filter response

% invert Hf using threshold gamma
i_Hf = i_Hf.*(abs(H)*g>1)+g*abs(Hf).*i_Hf.*(abs(Hf)*g<=1);     %incuding the threshold gamma
R = real(ifft2(i_Hf.*Y));                                      %final inverse filter response

return

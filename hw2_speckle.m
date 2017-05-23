% B-mode 影像實驗的範例程式
% 若不清楚所使用之MATLAB指令，請查MATLAB help
% Edited by M.-L. Li 05/14/2002
clear;

DR = 60;	% dynamic range (動態範圍) of the image		
                % 因Sonosite無法顯示使用的動態範圍(通常會顯示在其他系統的原始影像上),可直接使用DR=60
			
% 在MATLAB中,imread進來的影像資料 data type 為 "uint8"
OriIm = imread('57-high-res.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% 在MATLAB中，+,-,*,/等數值運算或函式只能使用於data type為double的資料上，
% 因此，在此先將uint8的data type轉成"double"
GrayIm = double(OriIm);	
% figure,imagesc(GrayIm), colormap(gray)

% 將原始影像上，真正屬於仿體影像的部份取出，不同的影像取的區域不同，
% 請自己找出自己擷取影像真正屬於仿體影像的部份
GrayIm = GrayIm(45:428,200:452); %57

% gray to dB 由0-255的灰階轉成 dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% show B-mode image

% % % % % % % % % % % figure
image(dBIm)
colormap(gray(DR))
axis image
% 1
% X = 205;
% Y = 125;
% W = 30;
% H = 30;
% 2
X = 105;
Y = 120;
W = 30;
H = 30;

rectangle('Position' , [X Y W H] , 'Edgecolor' , 'r') % [x y w h]

colorbar
title('B-mode image, dynamic range = 50dB')

% ------------------ speckle std ------------------
% 計算speckle的標準差?
% 將影像上均質的部份選出來計算speckle std
% 可與理論值 4.34 dB做個驗證
speIm = dBIm(Y:Y+H, X:X+W);
figure,imagesc(speIm), colormap(gray)
speckleStd = std(speIm(:));

                                          
% -------------------- speckle histogram -----------------------                                         
% dB to linear, 計算histogram前，得先將dB資料，轉為原來的linear的資料格式
% dB = 20*log10(E), E: amplitude => E = 10^(dB/20)
% dB = 10*log10(I), I: intensity => I = 10^(dB/10)
% 與計算std時一樣，取影像上均質的部份出來計算histogram
% 可使用MATLAB的函式"hist"來求出及畫出histgoram, "hist"僅只處理1-D的data,
% 所以需先使用reshape將2-D data 轉成1-D

% histogram 相當於 機率分布，(即高中所學的長條圖)
%可驗證speckle intensity及amplitude理論上的機率分布 (expenential distribution 及 Reyleigh distribution)

LinearIm_I = 10 .^ (speIm/10);	% intensity 為 10.^(圖像dB值/10)
LinearIm_E = 10 .^ (speIm/20);	% amplitude 為 10.^(圖像dB值/20)

LinearIm_I = LinearIm_I(:);
LinearIm_E = LinearIm_E(:);
figure
% 請先把 LinearIm_I 以及 LinearIm_E 變成column vector, 再使用hist指令畫出機率分布圖
hist(LinearIm_I);	% 像expenential distribution嗎?
title('Speckle Intensity Distribution');xlabel('I');ylabel('P_I')
figure
hist(LinearIm_E);	% 像Reyleigh distribution嗎?
title('Speckle Amplitude Distribution');xlabel('E');ylabel('P_E')

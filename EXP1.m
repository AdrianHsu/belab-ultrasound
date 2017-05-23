% B-mode 影像實驗的範例程式
% 若不清楚所使用之MATLAB指令，請查MATLAB help
% Edited by M.-L. Li 05/14/2002
clear;
DR = 60;	% dynamic range (動態範圍) of the image		
                % 因Sonosite無法顯示使用的動態範圍(通常會顯示在其他系統的原始影像上),可直接使用DR=60
	% 同學也可以嘗試改變DR, 並探討DR對影像呈現上有何作用.
			
% 在MATLAB中,imread進來的影像資料 data type 為 "uint8"
OriIm = imread('57-high-res.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% 在MATLAB中，+,-,*,/等數值運算或函式只能使用於data type為doulbe的資料上，
% 因此，在此先將uint8的data type轉成"double"
OriIm = rgb2gray(OriIm);
GrayIm = double(OriIm);	
figure,imagesc(GrayIm), colormap(gray)

% 將原始影像上，真正屬於仿體影像的部份取出，不同的影像取的區域不同，
% 請自己找出自己擷取影像真正屬於仿體影像的部份
GrayIm = GrayIm(50:430,150:330); 

% gray to dB 由0-255的灰階轉成 dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% show B-mode image
figure
image(dBIm)
colormap(gray(DR))
axis image
rectangle('Position' , [120 280 30 30] , 'Edgecolor' , 'r')
colorbar
title('B-mode image, dynamic range = 50dB')

% ---------------------  estimate PSF size  -----------------
% 請比較不同深度上的點，PSF size有無差別?
% 比較single zone focusing與multi-zone focusing,同一深度的PSF size有無差別?

% 點的範圍
ImPt = dBIm(320:340 , 70:110);    % 請輸入範圍


% 以lateral projection求橫向上的PSF size
ptLalProj = max(ImPt) - max(max(ImPt)); % normalise, in dB

% show lateral projection
figure
plot(ptLalProj)
title('lateral projection')

% axial projection
ptAxiProj = max(ImPt,[],2) - max(max(ImPt,[],2));   % 請transpose 點影像, 再取與lateral projection相同的計算方式
figure
plot(ptAxiProj)
title('axial projection')

% 計算 lateral projection 的-6dB寬度. 此為psf size 
idx = find(ptLalProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! 近似求法，請以較準確的方法求出-6dB寬度?
lastidx = (-6 - ptLalProj(idx(end)))/(ptLalProj(idx(end)+1) - ptLalProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptLalProj(idx(1)))/(ptLalProj(idx(1)-1) - ptLalProj(idx(1)));
Width6dBLal = lastidx - firstidx; % -6 dB width in index, !!! 此為近似的求法 (相當不準確)
							  % 因idx(end)與idx(1)所對應的值未必恰好等於 -6 dB，
                              % 要準確的求出-6dB寬度，至少得將對應-6 dB的index值內插出來再求
                              % 此外要注意，此時求出來的寬度僅為相差的index大小
                              % 若要換算成實際的單位如 mm，得找出兩個連續index間實際間隔多少mm

% 以axis projection求軸向上PSF size
% 幾乎與lateral projection一樣的求法
idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! 近似求法，請以較準確的方法求出-6dB寬度?
lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
Width6dBAxi = lastidx - firstidx;


% ------------------ speckle std ------------------
% 計算speckle的標準差?
% 將影像上均質的部份選出來計算speckle std
% 可與理論值 4.34 dB做個驗證
speIm = dBIm(280:310 , 120:150);
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
%%
% --------------------- CNR estimation ---------------------------
% 請參考講義上的公式分別於ROI及背景取一小區域來計算std及mean
% 可直接使用gray scale的值(為什麼可以?)來計算
% 或使用轉換成dB後的值來計算

%clear all
DR=60;
OriIm = imread('-15res@low.mpg_snapshot_00.04_[2015.03.23_16.31.52].jpg');
GrayIm = rgb2gray(OriIm);
GrayIm = double(GrayIm);
figure;imagesc(GrayIm);colormap(gray)

% 將原始影像上，真正屬於仿體影像的部份取出，不同的影像取的區域不同，
% 請自己找出自己擷取影像真正屬於仿體影像的部份
GrayIm = GrayIm( 50:440 , 165:325); 
% gray to dB 由0-255的灰階轉成 dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;
figure
image(dBIm)
colormap(gray(DR))
rectangle('Position' , [45 240 25 50] , 'Edgecolor' , 'r')
rectangle('Position' , [100 240 15 50] , 'Edgecolor' , 'r')
axis image
colorbar
title('B-mode image')

InIm = dBIm(240:290 , 45:70);
OutIm = dBIm(240:290 , 100:115);

InStd = std2(InIm);
OutStd = std2(OutIm);
InMean = mean2(InIm);
OutMean = mean2(OutIm);

CNR = abs((InMean - OutMean)/(InStd + OutStd));    % 請參考實驗簡介檔

% 分別選取6個圓內及圓外的一小塊區域計算其影像對比度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






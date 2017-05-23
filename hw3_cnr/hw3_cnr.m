clear;
DR=60;
OriIm = imread('-6-15_low_pen.bmp');
GrayIm = rgb2gray(OriIm);
GrayIm = double(GrayIm);
% figure;imagesc(GrayIm);colormap(gray)

% 將原始影像上，真正屬於仿體影像的部份取出，不同的影像取的區域不同，
% 請自己找出自己擷取影像真正屬於仿體影像的部份
GrayIm = GrayIm(45:430, 227:425); %-6-15

% gray to dB 由0-255的灰階轉成 dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;

fig_hw3_1 = figure();
set (fig_hw3_1, 'Visible', 'off');
image(dBIm)
colormap(gray(DR))
rectangle('Position' , [45 260 25 50] , 'Edgecolor' , 'r')
rectangle('Position' , [100 140 15 50] , 'Edgecolor' , 'r')
axis image
colorbar
title('B-mode image')
saveas(fig_hw3_1,'fig_hw3_1.jpg');

InIm = dBIm(260:310 , 45:70);
OutIm = dBIm(140:190 , 100:115);

InStd = std2(InIm);
OutStd = std2(OutIm);
InMean = mean2(InIm);
OutMean = mean2(OutIm);

CNR = abs((InMean - OutMean)/(InStd + OutStd));    % 請參考實驗簡介檔

% % 分別選取6個圓內及圓外的一小塊區域計算其影像對比度
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

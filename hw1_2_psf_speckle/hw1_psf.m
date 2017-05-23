clear;

DR = 60;	% dynamic range (動態範圍) of the image		
                % 因Sonosite無法顯示使用的動態範圍(通常會顯示在其他系統的原始影像上),可直接使用DR=60
			
% 在MATLAB中,imread進來的影像資料 data type 為 "uint8"
OriIm = imread('57-high-res.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% 在MATLAB中，+,-,*,/等數值運算或函式只能使用於data type為double的資料上，
% 因此，在此先將uint8的data type轉成"double"
GrayIm = double(OriIm);	
% figure,imagesc(GrayIm), colormap(gray); 
% fig_hw1_1 = figure();
% set (fig_hw1_1,'Visible','off');
% imagesc(GrayIm), colormap(gray);
% saveas(fig_hw1_1,'fig_hw1_1.jpg');

% 將原始影像上，真正屬於仿體影像的部份取出，不同的影像取的區域不同，
% 請自己找出自己擷取影像真正屬於仿體影像的部份
GrayIm = GrayIm(45:428,200:452); %57, (y1:y2,x1:x2)

% gray to dB 由0-255的灰階轉成 dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% 1
X = 205;
Y = 125;
W = 30;
H = 30;
% show B-mode image
fig_hw1_2 = figure();
set (fig_hw1_2,'Visible','off');
image(dBIm)
colormap(gray(DR))
axis image
rectangle('Position' , [X Y W H] , 'Edgecolor' , 'r') % [x y w h]
colorbar
title('B-mode image, dynamic range = 50dB')
saveas(fig_hw1_2,'fig_hw1_2.jpg');

% 
% ---------------------  estimate PSF size  -----------------
% 請比較不同深度上的點，PSF size有無差別?
% 比較single zone focusing與multi-zone focusing,同一深度的PSF size有無差別?

% 點的範圍
ImPt = dBIm(Y:Y+H,X:X+W);    % 請輸入範圍 %[y1:y2, x1:x2], y2-y1=20, x2-x1=30

% 以lateral projection求橫向上的PSF size
ptLalProj = max(ImPt) - max(max(ImPt)); % normalise, in dB

% show lateral projection
fig_hw1_3 = figure();
set (fig_hw1_3,'Visible','off');
plot(ptLalProj)
title('lateral projection')
saveas(fig_hw1_3,'fig_hw1_3.jpg');

% show axial projection
ptAxiProj =  max(ImPt,[],2) - max(max(ImPt,[],2));   % 請transpose 點影像, 再取與lateral projection相同的計算方式

fig_hw1_4 = figure();
set (fig_hw1_4,'Visible','off');
plot(ptAxiProj)
title('axial projection')
saveas(fig_hw1_4,'fig_hw1_4.jpg');

% 計算 lateral projection 的-6dB寬度. 此為psf size
idx = find(ptLalProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! 近似求法，請以較準確的方法求出-6dB寬度?
% Width6dB = idx(end) - idx(1); % -6 dB width in index, !!! 此為近似的求法 (相當不準確)
							  % 因idx(end)與idx(1)所對應的值未必恰好等於 -6 dB，
                              % 要準確的求出-6dB寬度，至少得將對應-6 dB的index值內插出來再求
                              % 此外要注意，此時求出來的寬度僅為相差的index大小
                              % 若要換算成實際的單位如 mm，得找出兩個連續index間實際間隔多少mm          
lastidx = (-6 - ptLalProj(idx(end)))/(ptLalProj(idx(end)+1) - ptLalProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptLalProj(idx(1)))/(ptLalProj(idx(1)-1) - ptLalProj(idx(1)));
Width6dBLal = lastidx - firstidx;


% 以axis projection求軸向上PSF size
% 幾乎與lateral projection一樣的求法
idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! 近似求法，請以較準確的方法求出-6dB寬度?
lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
Width6dBAxi = lastidx - firstidx;

clear;

DR = 60;
dim57 = [42 428 200 452];
xywh = [205 135 30 20];
OriIm = imread('57-high-res.bmp');
GrayIm = double(OriIm);
GrayIm = GrayIm(dim57(1):dim57(2),dim57(3):dim57(4)); %57
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% show B-mode image
fig_hw1_2 = figure();
set (fig_hw1_2,'Visible','off');
image(dBIm)
colormap(gray(DR))
axis image
rectangle('Position' , [xywh(1), xywh(2), xywh(3), xywh(4)] , 'Edgecolor' , 'r') % [x y w h]
colorbar;
title('B-mode image, dynamic range = 50dB')
saveas(fig_hw1_2,'fig_hw1_2.jpg');


ImPt = dBIm(xywh(2):xywh(2)+xywh(4), xywh(1):xywh(1)+xywh(3));

ptLalProj = max(ImPt) - max(max(ImPt));

fig_hw1_3 = figure();
set (fig_hw1_3,'Visible','off');
plot(ptLalProj)
title('lateral projection')
saveas(fig_hw1_3,'fig_hw1_3.jpg');

ptAxiProj =  max(ImPt,[],2) - max(max(ImPt,[],2)); 
fig_hw1_4 = figure();
set (fig_hw1_4,'Visible','off');
plot(ptAxiProj)
title('axial projection')
saveas(fig_hw1_4,'fig_hw1_4.jpg');


idx = find(ptLalProj >= -6 );	% find the indexes of the values, >= -6 dB
lastidx = (-6 - ptLalProj(idx(end)))/(ptLalProj(idx(end)+1) - ptLalProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptLalProj(idx(1)))/(ptLalProj(idx(1)-1) - ptLalProj(idx(1)));
Width6dBLal = lastidx - firstidx;

idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
Width6dBAxi = lastidx - firstidx;

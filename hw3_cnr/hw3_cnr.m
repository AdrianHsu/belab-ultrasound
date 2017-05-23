clear;
DR=60;
OriIm = imread('-6-15_low_pen.bmp');
GrayIm = rgb2gray(OriIm);
GrayIm = double(GrayIm);
% figure;imagesc(GrayIm);colormap(gray)

% �N��l�v���W�A�u���ݩ����v�����������X�A���P���v�������ϰ줣�P�A
% �Цۤv��X�ۤv�^���v���u���ݩ����v��������
GrayIm = GrayIm(45:430, 227:425); %-6-15

% gray to dB ��0-255���Ƕ��ন dB
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

CNR = abs((InMean - OutMean)/(InStd + OutStd));    % �аѦҹ���²����

% % ���O���6�Ӷꤺ�ζ�~���@�p���ϰ�p���v������
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

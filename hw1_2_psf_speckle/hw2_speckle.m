clear;

DR = 60;	% dynamic range (�ʺA�d��) of the image		
                % �]Sonosite�L�k��ܨϥΪ��ʺA�d��(�q�`�|��ܦb��L�t�Ϊ���l�v���W),�i�����ϥ�DR=60
			
% �bMATLAB��,imread�i�Ӫ��v����� data type �� "uint8"
OriIm = imread('57-high-pen.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% �bMATLAB���A+,-,*,/���ƭȹB��Ψ禡�u��ϥΩ�data type��double����ƤW�A
% �]���A�b�����Nuint8��data type�ন"double"
GrayIm = double(OriIm);

% figure,imagesc(GrayIm), colormap(gray); 
% fig_hw1_1 = figure();
% set (fig_hw1_1,'Visible','off');
% imagesc(GrayIm), colormap(gray);
% saveas(fig_hw1_1,'fig_hw1_1.jpg');

% �N��l�v���W�A�u���ݩ����v�����������X�A���P���v�������ϰ줣�P�A
% �Цۤv��X�ۤv�^���v���u���ݩ����v��������
GrayIm = GrayIm(45:428,200:452); %57

% gray to dB ��0-255���Ƕ��ন dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR
% 2
X = 105;
Y = 120;
W = 30;
H = 20;

% show B-mode image
fig_hw2_1 = figure();
set (fig_hw2_1,'Visible','off');
image(dBIm)
colormap(gray(DR))
axis image
rectangle('Position' , [X Y W H] , 'Edgecolor' , 'r') % [x y w h]
colorbar
title('B-mode image, dynamic range = 50dB')
saveas(fig_hw2_1,'fig_hw2_1.jpg');

% 
% ------------------ speckle std ------------------
% �p��speckle���зǮt?
% �N�v���W���誺������X�ӭp��speckle std
% �i�P�z�׭� 4.34 dB��������

speIm = dBIm(Y:Y+H, X:X+W);
% figure,imagesc(speIm), colormap(gray)
speckleStd = std(speIm(:));
                                          
% -------------------- speckle histogram -----------------------                                         
% dB to linear, �p��histogram�e�A�o���NdB��ơA�ର��Ӫ�linear����Ʈ榡
% dB = 20*log10(E), E: amplitude => E = 10^(dB/20)
% dB = 10*log10(I), I: intensity => I = 10^(dB/10)
% �P�p��std�ɤ@�ˡA���v���W���誺�����X�ӭp��histogram
% �i�ϥ�MATLAB���禡"hist"�ӨD�X�εe�Xhistgoram, "hist"�ȥu�B�z1-D��data,
% �ҥH�ݥ��ϥ�reshape�N2-D data �ন1-D

% histogram �۷�� ���v�����A(�Y�����ҾǪ�������)
%�i����speckle intensity��amplitude�z�פW�����v���� (expenential distribution �� Reyleigh distribution)

LinearIm_I = 10 .^ (speIm/10);	% intensity �� 10.^(�Ϲ�dB��/10)
LinearIm_E = 10 .^ (speIm/20);	% amplitude �� 10.^(�Ϲ�dB��/20)

LinearIm_I = LinearIm_I(:);
LinearIm_E = LinearIm_E(:);

% �Х��� LinearIm_I �H�� LinearIm_E �ܦ�column vector, �A�ϥ�hist���O�e�X���v������
fig_hw2_2 = figure();
set (fig_hw2_2,'Visible','off');
hist(LinearIm_I);	% ��expenential distribution��?
title('Speckle Intensity Distribution');xlabel('I');ylabel('P_I')
saveas(fig_hw2_2,'fig_hw2_2.jpg');

fig_hw2_3 = figure();
set (fig_hw2_3, 'Visible', 'off');
hist(LinearIm_E);	% ��Reyleigh distribution��?
title('Speckle Amplitude Distribution');xlabel('E');ylabel('P_E')
saveas(fig_hw2_3,'fig_hw2_3.jpg');

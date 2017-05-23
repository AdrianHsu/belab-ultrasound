clear;

DR = 60;	% dynamic range (�ʺA�d��) of the image		
                % �]Sonosite�L�k��ܨϥΪ��ʺA�d��(�q�`�|��ܦb��L�t�Ϊ���l�v���W),�i�����ϥ�DR=60
			
% �bMATLAB��,imread�i�Ӫ��v����� data type �� "uint8"
OriIm = imread('57-high-res.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% �bMATLAB���A+,-,*,/���ƭȹB��Ψ禡�u��ϥΩ�data type��double����ƤW�A
% �]���A�b�����Nuint8��data type�ন"double"
GrayIm = double(OriIm);	
figure,imagesc(GrayIm), colormap(gray)

% �N��l�v���W�A�u���ݩ����v�����������X�A���P���v�������ϰ줣�P�A
% �Цۤv��X�ۤv�^���v���u���ݩ����v��������
GrayIm = GrayIm(45:428,200:452); %57

% gray to dB ��0-255���Ƕ��ন dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% show B-mode image
figure
image(dBIm)
colormap(gray(DR))
axis image
% 1
X = 205;
Y = 125;
W = 30;
H = 30;
% 2
% X = 105;
% Y = 120;
% W = 30;
% H = 30;

rectangle('Position' , [X Y W H] , 'Edgecolor' , 'r') % [x y w h]

colorbar
title('B-mode image, dynamic range = 50dB')
% 
% ---------------------  estimate PSF size  -----------------
% �Ф�����P�`�פW���I�APSF size���L�t�O?
% ���single zone focusing�Pmulti-zone focusing,�P�@�`�ת�PSF size���L�t�O?

% �I���d��
ImPt = dBIm(Y:Y+H,X:X+W);    % �п�J�d�� %[y1:y2, x1:x2], y2-y1=20, x2-x1=30

% �Hlateral projection�D��V�W��PSF size
ptLalProj = max(ImPt) - max(max(ImPt)); % normalise, in dB

% show lateral projection
figure
plot(ptLalProj)
title('lateral projection')

% axial projection
ptAxiProj =  max(ImPt,[],2) - max(max(ImPt,[],2));   % ��transpose �I�v��, �A���Plateral projection�ۦP���p��覡
figure
plot(ptAxiProj)
title('axial projection')

% �p�� lateral projection ��-6dB�e��. ����psf size 
idx = find(ptLalProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! ����D�k�A�ХH���ǽT����k�D�X-6dB�e��?
Width6dB = idx(end) - idx(1); % -6 dB width in index, !!! ����������D�k (�۷����ǽT)
							  % �]idx(end)�Pidx(1)�ҹ������ȥ�����n���� -6 dB�A
                              % �n�ǽT���D�X-6dB�e�סA�ܤֱo�N����-6 dB��index�Ȥ����X�ӦA�D
                              % ���~�n�`�N�A���ɨD�X�Ӫ��e�׶Ȭ��ۮt��index�j�p
                              % �Y�n���⦨��ڪ����p mm�A�o��X��ӳs��index����ڶ��j�h��mm

                              
% �Haxis projection�D�b�V�WPSF size
% �X�G�Plateral projection�@�˪��D�k
idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
% !!!!!!!!!!! ����D�k�A�ХH���ǽT����k�D�X-6dB�e��?
lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
Width6dBAxi = lastidx - firstidx;
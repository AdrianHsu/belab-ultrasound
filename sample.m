% B-mode �v�����窺�d�ҵ{��
% �Y���M���ҨϥΤ�MATLAB���O�A�ЬdMATLAB help
% Edited by M.-L. Li 05/14/2002
clear;
DR = 60;	% dynamic range (�ʺA�d��) of the image		
                % �]Sonosite�L�k��ܨϥΪ��ʺA�d��(�q�`�|��ܦb��L�t�Ϊ���l�v���W),�i�����ϥ�DR=60
			
% �bMATLAB��,imread�i�Ӫ��v����� data type �� "uint8"
OriIm = imread('57-high-res.bmp');
%GrayIm = rgb2gray(OriIm);	% rgb to gray scale, data type : uint8

% �bMATLAB���A+,-,*,/���ƭȹB��Ψ禡�u��ϥΩ�data type��double����ƤW�A
% �]���A�b�����Nuint8��data type�ন"double"
GrayIm = double(OriIm);	
% figure,imagesc(GrayIm), colormap(gray)

% �N��l�v���W�A�u���ݩ����v�����������X�A���P���v�������ϰ줣�P�A
% �Цۤv��X�ۤv�^���v���u���ݩ����v��������
GrayIm = GrayIm(45:428,200:452); %57
% GrayIm = GrayIm(45:430, 227:425); %-6-15

% gray to dB ��0-255���Ƕ��ন dB
dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

% show B-mode image
figure
image(dBIm)
colormap(gray(DR))
axis image
colorbar
title('B-mode image, dynamic range = 50dB')
% 
% ---------------------  estimate PSF size  -----------------
% �Ф�����P�`�פW���I�APSF size���L�t�O?
% ���single zone focusing�Pmulti-zone focusing,�P�@�`�ת�PSF size���L�t�O?

% �I���d��
ImPt = dBIm(135:150,210:232);    % �п�J�d��

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
% 
% % �p�� lateral projection ��-6dB�e��. ����psf size 
% idx = find(ptLalProj >= -6 );	% find the indexes of the values, >= -6 dB
% % !!!!!!!!!!! ����D�k�A�ХH���ǽT����k�D�X-6dB�e��?
% Width6dB = idx(end) - idx(1); % -6 dB width in index, !!! ����������D�k (�۷��ǽT)
% 							  % �]idx(end)�Pidx(1)�ҹ������ȥ�����n���� -6 dB�A
%                               % �n�ǽT���D�X-6dB�e�סA�ܤֱo�N����-6 dB��index�Ȥ����X�ӦA�D
%                               % ���~�n�`�N�A���ɨD�X�Ӫ��e�׶Ȭ��ۮt��index�j�p
%                               % �Y�n���⦨��ڪ����p mm�A�o��X��ӳs��index����ڶ��j�h��mm
% 
%                               
% % �Haxis projection�D�b�V�WPSF size
% % �X�G�Plateral projection�@�˪��D�k
% idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
% % !!!!!!!!!!! ����D�k�A�ХH���ǽT����k�D�X-6dB�e��?
% lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
% firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
% Width6dBAxi = lastidx - firstidx;

% % ------------------ speckle std ------------------
% % �p��speckle���зǮt?
% % �N�v���W���誺������X�ӭp��speckle std
% % �i�P�z�׭� 4.34 dB��������
% speckleStd = ?;
%                                           
% % -------------------- speckle histogram -----------------------                                         
% % dB to linear, �p��histogram�e�A�o���NdB��ơA�ର��Ӫ�linear����Ʈ榡
% % dB = 20*log10(E), E: amplitude => E = 10^(dB/20)
% % dB = 10*log10(I), I: intensity => I = 10^(dB/10)
% % �P�p��std�ɤ@�ˡA���v���W���誺�����X�ӭp��histogram
% % �i�ϥ�MATLAB���禡"hist"�ӨD�X�εe�Xhistgoram, "hist"�ȥu�B�z1-D��data,
% % �ҥH�ݥ��ϥ�reshape�N2-D data �ন1-D
% 
% % histogram �۷�� ���v�����A(�Y�����ҾǪ�������)
% %�i����speckle intensity��amplitude�z�פW�����v���� (expenential distribution �� Reyleigh distribution)
% 
% LinearIm_I = ?;	% intensity �� 10.^(�Ϲ�dB��/10)
% LinearIm_E = ?;	% amplitude �� 10.^(�Ϲ�dB��/20)
% 
% figure
% % �Х��� LinearIm_I �H�� LinearIm_E �ܦ�column vector, �A�ϥ�hist���O�e�X���v������
% hist(?);	% ��expenential distribution��?
% title('Speckle Intensity Distribution');xlabel('I');ylabel('P_I')
% figure
% hist(?);	% ��Reyleigh distribution��?
% title('Speckle Amplitude Distribution');xlabel('E');ylabel('P_E')
% 
% % --------------------- CNR estimation ---------------------------
% % �аѦ����q�W���������O��ROI�έI�����@�p�ϰ�ӭp��std��mean
% % �i�����ϥ�gray scale����(������i�H?)�ӭp��
% % �Ψϥ��ഫ��dB�᪺�Ȩӭp��
% 
% %clear all
% DR=60;
% OriIm = imread('EFGH');
% % GrayIm = rgb2gray(OriIm);
% GrayIm = double(GrayIm);
% figure;imagesc(GrayIm);colormap(gray)
% 
% % �N��l�v���W�A�u���ݩ����v�����������X�A���P���v�������ϰ줣�P�A
% % �Цۤv��X�ۤv�^���v���u���ݩ����v��������
% GrayIm = GrayIm(?); 
% % gray to dB ��0-255���Ƕ��ন dB
% dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
% dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
% dBIm = dBIm*DR;
% figure
% image(dBIm)
% colormap(gray(DR))
% axis image
% colorbar
% title('B-mode image')
% 
% CNR = ?;    % �аѦҹ���²����
% 
% % ���O���6�Ӷꤺ�ζ�~���@�p���ϰ�p���v������
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





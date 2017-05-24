clear;

DR = 60;
ENUM = 4;
str_enum = ["57-high-pen", "57-high-res", "57-low-pen", "57-low-res", "71-high-pen", "71-high-res", "71-low-pen", "71-low-res"];

dim = [42 428 200 452]; %57, [y1 y2 x1 x2]
xywh_in = [105 100 30 30]; %57 in
xywh_out = [105 300 30 30]; %57 out

% dim = [45 430 227 425]; %71
% xywh_in = [105 100 30 30]; %71 in
% xywh_out = [105 300 30 30]; %71 out
xywh = [xywh_in;xywh_out];

path = strcat('img/', str_enum(ENUM));
tmp = strcat(path, '.bmp');
OriIm = imread(char(tmp));
GrayIm = double(OriIm);
GrayIm = GrayIm(dim(1):dim(2),dim(3):dim(4));

dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

table = [];

%% hw2

for i=1:2
    speIm = dBIm(xywh(i,2):xywh(i,2)+xywh(i,4), xywh(i,1):xywh(i,1)+xywh(i,3));
    % figure,imagesc(speIm), colormap(gray)
    speckleStd = std(speIm(:));

    fig = figure();
    set (fig,'Visible','off');
    subplot(2,2,[1, 2]);
    image(dBIm)
    colormap(gray(DR));
    axis image;
    rectangle('Position' , [xywh(i,1), xywh(i,2), xywh(i,3), xywh(i,4)] , 'Edgecolor' , 'r') % [x y w h]
    colorbar;
    title('B-mode image, dynamic range = 50dB')
    ImPt = dBIm(xywh(i,2):xywh(i,2)+xywh(i,4), xywh(i,1):xywh(i,1)+xywh(i,3));
    ptLalProj = max(ImPt) - max(max(ImPt));


    LinearIm_I = 10 .^ (speIm/10);	
    LinearIm_E = 10 .^ (speIm/20);

    LinearIm_I = LinearIm_I(:);
    LinearIm_E = LinearIm_E(:);

    subplot(2,2,3);
    hist(LinearIm_I);
    title('Speckle Intensity Distribution');xlabel('I');ylabel('P_I')

    subplot(2,2,4);
    hist(LinearIm_E);
    title('Speckle Amplitude Distribution');xlabel('E');ylabel('P_E')
    io = strcat(int2str(i), '.jpg');
    filename = strcat(str_enum(ENUM), io);
    saveas(fig,char(filename));
    
    table = [table;speckleStd];
end
csv = array2table(table,'VariableNames', {'speckleStd'}, 'RowNames', {'In Focus', 'Out Focus'});
writetable(csv, strcat(str_enum(ENUM),'.csv'), 'WriteRowNames', true);

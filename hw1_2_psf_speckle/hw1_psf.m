clear;

DR = 60;
ENUM = 2;
str_enum = ["57-high-pen", "57-high-res", "57-low-pen", "57-low-res", "71-high-pen", "71-high-res", "71-low-pen", "71-low-res"];

dim = [42 428 200 452]; %57, [y1 y2 x1 x2]
xywh_in = [205 135 30 20]; %57 in
xywh_out = [205 340 30 20]; %57 out

% dim = [45 430 227 425]; %71
% xywh_in = [155 158 30 20]; %71 in
% xywh_out = [155 325 30 20]; %71 out

xywh = [xywh_in;xywh_out];

tmp = strcat(str_enum(ENUM), '.bmp');
OriIm = imread(char(tmp));
GrayIm = double(OriIm);
GrayIm = GrayIm(dim(1):dim(2),dim(3):dim(4));

dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
dBIm = dBIm*DR;							% to dB, 0 - DR

table = [];
for i = 1:2
    % show B-mode image
    fig = figure();
    set (fig,'Visible','off');
    subplot(2,2,[1,2]);
    image(dBIm)
    colormap(gray(DR))
    axis image
    rectangle('Position' , [xywh(i,1), xywh(i,2), xywh(i,3), xywh(i,4)] , 'Edgecolor' , 'r') % [x y w h]
    colorbar;
    title('B-mode image, dynamic range = 50dB')
    ImPt = dBIm(xywh(i,2):xywh(i,2)+xywh(i,4), xywh(i,1):xywh(i,1)+xywh(i,3));
    ptLalProj = max(ImPt) - max(max(ImPt));
    subplot(2,2,3);
    plot(ptLalProj);
    title('lateral projection')
    ptAxiProj =  max(ImPt,[],2) - max(max(ImPt,[],2)); 
    subplot(2,2,4);
    plot(ptAxiProj)
    title('axial projection')
    ch = strcat(int2str(i),'.jpg');
    tmp = strcat(str_enum(ENUM), ch);
    saveas(fig, char(tmp));


    idx = find(ptLalProj >= -6);	% find the indexes of the values, >= -6 dB
    if idx(end) == size(ptLalProj, 2)
        lastidx = idx(end);
    else 
        lastidx = (-6 - ptLalProj(idx(end)))/(ptLalProj(idx(end)+1) - ptLalProj(idx(end)))+idx(end);
    end
    if idx(1) == 1
        firstidx = 1;
    else 
        firstidx = idx(1) - (-6 - ptLalProj(idx(1)))/(ptLalProj(idx(1)-1) - ptLalProj(idx(1)));
    end
    Width6dBLal = lastidx - firstidx;


    idx = find(ptAxiProj >= -6 );	% find the indexes of the values, >= -6 dB
    if idx(end) == size(ptAxiProj, 1)
        lastidx = idx(end);
    else 
        lastidx = (-6 - ptAxiProj(idx(end)))/(ptAxiProj(idx(end)+1) - ptAxiProj(idx(end)))+idx(end);
    end
    if idx(1) == 1
        firstidx = 1;
    else
        firstidx = idx(1) - (-6 - ptAxiProj(idx(1)))/(ptAxiProj(idx(1)-1) - ptAxiProj(idx(1)));
    end
    Width6dBAxi = lastidx - firstidx;
    tmp = [Width6dBLal Width6dBAxi];
    table = [table;tmp];
end
csv = array2table(table,'VariableNames', {'Lateral', 'Axial'} );
writetable(csv,'data.csv');

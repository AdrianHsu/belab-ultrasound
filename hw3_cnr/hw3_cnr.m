clear;

DR=60;
ENUM = 7; % 1, 4, 7, 10
str_enum = ["high_pen_-6-15", "high_pen_+-3", "high_pen_+6+15", ...
            "high_res_-6-15", "high_res_+-3", "high_res_+6+15", ...
            "low_pen_-6-15", "low_pen_+-3", "low_pen_+6+15", ...
            "low_res_-6-15", "low_res_+-3", "low_res_+6+15"];
name_enum = ["high_pen", "high_res", "low_pen", "low_res"]
xywh_in = [40 260 25 50]; 
xywh_out = [95 260 15 50]; 

xywh = [xywh_in;xywh_out];
table = [];
fig_hw3_1 = figure();
set (fig_hw3_1, 'Visible', 'off');
for i = 1:3
    path = strcat('img/', str_enum(ENUM + i - 1));
    filename = strcat(path, '.bmp');
    OriIm = imread(char(filename));
    GrayIm = rgb2gray(OriIm);
    GrayIm = double(GrayIm);
    % figure;imagesc(GrayIm);colormap(gray)

    GrayIm = GrayIm(45:430, 227:425); %-6-15

    dBIm = GrayIm - min(min(GrayIm));	% set min value to 0
    dBIm = dBIm/max(max(dBIm));			% normalization, 0 - 1
    dBIm = dBIm*DR;

    subplot(1,3,i);
    image(dBIm)
    colormap(gray(DR))
    rectangle('Position' , xywh(1,:) , 'Edgecolor' , 'r')
    rectangle('Position' , xywh(2,:) , 'Edgecolor' , 'r')
    axis image
    colorbar
    title('B-mode image')


    InIm = dBIm(260:310 , 45:70);
    OutIm = dBIm(140:190 , 100:115);

    InStd = std2(InIm);
    OutStd = std2(OutIm);
    InMean = mean2(InIm);
    OutMean = mean2(OutIm);

    CNR = abs((InMean - OutMean)/(InStd + OutStd));  
    table = [table CNR];
end
id = uint8(ENUM / 3) + 1;
name = strcat(name_enum(id), '.jpg');
saveas(fig_hw3_1, char(name));

csv = array2table(table,'VariableNames', {'A15dBto6dB', 'B3dBto3dB', 'C6dBto15dB'}, 'RowNames', {'CNR'});
writetable(csv, strcat(name_enum(id),'.csv'), 'WriteRowNames', true);

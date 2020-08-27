function [T, eq] = calc_T(hist, show)
% calc_T - 计算映射函数
%
% input:
%   - hist: n*1, 直方图, n为图像灰度个数
%   - show: bool, 是否显示结果
% output:
%   - T: n*1, 映射函数
%   - eq: n*1, 调整后的直方图
%

grayLevel = length(hist);

if ~exist('show', 'var')
    show = 0;
end

cdf = cumsum(hist);
if cdf(end) > 1
    cdf = cdf / cdf(end);
end

T = fix(cdf * (grayLevel-1)) + 1;

eq = zeros(grayLevel, 1);
for i = 1:grayLevel
    eq(T(i)) = eq(T(i)) + hist(i);
end

if show
    ranges = getRanges(hist, 0.4);
    show_process(hist, eq, cdf, ranges);
end

end

function show_process(hist, eq, cdf, ranges)
% show_process - 显示变换过程
%
% input:
%   - hist: n*1, 直方图, n为图像灰度个数
%   - eq: n*1, 调整后的直方图
%   - cdf: n*1, 累计直方图
%   - ranges: 2*1, 动态范围, [index_low, index_up]
%

figure('NumberTitle', 'off', 'Name', 'Porcess of Histogram Transform')
T = tiledlayout(2,2);

colors = {'r', 'g', 'b', 'c'};

grayVal = 1 : length(hist);
grayVal = grayVal';

CDF = fix(cdf*(length(hist)-1))+1;
RANGES(1) = CDF(ranges(1));
RANGES(2) = CDF(ranges(2));

nexttile(1)
barh(grayVal, eq, 'FaceColor', colors{2}, 'EdgeColor', colors{2}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
set(gca,'XDir','reverse');
ylim([0, length(hist)])

nexttile(2)
plot(grayVal, CDF, 'color', colors{4}, 'linewidth', 1.1);
axis([0, length(hist) 0 length(hist)])
set(gca, 'color', 'none'); % set background

nexttile(4)
bar(grayVal, hist, 'FaceColor', colors{3}, 'EdgeColor', colors{3}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
set(gca,'YDir','reverse');
hold on,

xlim([0, length(hist)])

T.TileSpacing = 'compact';
T.Padding = 'compact';

set(gca, 'color', 'none');
fig_rgb = getframe(gcf);
fig_rgb = fig_rgb.cdata;
alpha = ones(size(fig_rgb, 1), size(fig_rgb, 2));
fig_gray = rgb2gray(fig_rgb);
alpha(fig_gray==240) = 0;
imwrite(fig_rgb, 'transform.png', 'Alpha', alpha);

figure('NumberTitle', 'off', 'Name', 'Porcess1 of Histogram Transform')
T = tiledlayout(2,2);

colors = {'r', 'g', 'b', 'c'};

grayVal = 1 : length(hist);
grayVal = grayVal';

CDF = fix(cdf*(length(hist)-1))+1;
RANGES(1) = CDF(ranges(1));
RANGES(2) = CDF(ranges(2));

nexttile(1)
barh(grayVal, eq, 'FaceColor', colors{2}, 'EdgeColor', colors{2}, 'BarWidth', 1.0);
hold on,
barh(grayVal(RANGES(1):RANGES(2)), eq(RANGES(1):RANGES(2)), 'FaceColor', colors{1}, 'EdgeColor', colors{1}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
set(gca,'XDir','reverse');
ylim([0, length(hist)])

nexttile(2)
plot(grayVal, CDF, 'color', colors{4}, 'linewidth', 1.1);
hold on,
plot(grayVal(ranges(1):ranges(2)), CDF(ranges(1):ranges(2)), 'color', colors{1}, 'linewidth', 1.1);
axis([0, length(hist) 0 length(hist)])
set(gca, 'color', 'none'); % set background

nexttile(4)
bar(grayVal, hist, 'FaceColor', colors{3}, 'EdgeColor', colors{3}, 'BarWidth', 1.0);
hold on,
bar(grayVal(ranges(1):ranges(2)), hist(ranges(1):ranges(2)), 'FaceColor', colors{1}, 'EdgeColor', colors{1}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
set(gca,'YDir','reverse');
hold on,

xlim([0, length(hist)])

T.TileSpacing = 'compact';
T.Padding = 'compact';

set(gca, 'color', 'none');
fig_rgb = getframe(gcf);
fig_rgb = fig_rgb.cdata;
alpha = ones(size(fig_rgb, 1), size(fig_rgb, 2));
fig_gray = rgb2gray(fig_rgb);
alpha(fig_gray==240) = 0;
imwrite(fig_rgb, 'transform1.png', 'Alpha', alpha);

end
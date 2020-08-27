function [outHist] = hist_analysis(hist, show)
% hist_analysis - 直方图分析
%
% input:
%   - hist: 256*1, int/float, 直方图
%   - show: bool, 是否显示结果
% output:
%   - outHist: struct, 结果
%
% usage:
%   [outHist] = hist_analysis(hist)
%
% docs:
%   - 波峰分析: 波峰的个数代表了图像亮度的区分度
%   - 动态范围: 代表了图像对比度
%

if ~exist('show', 'var')
    show = 0;
end

% 波峰
index = 0:255;
gStr = autoGauFit(index, hist');
peaks = getPeaks(index, gStr);

% 动态范围
ratio = [0, 0.01, 0.05, 0.1, 0.2];
ranges = getRanges(hist, ratio);

if show
    visualizationProcess(index, hist', gStr, 'final');
    show_peak_range(index, hist, peaks, ratio, ranges);
end

outHist = struct;
outHist.peaks = peaks;
outHist.ranges = ranges;

end

function show_peak_range(index, hist, peaks, ratio, ranges)
% show_peak - 显示波峰
%
% input:
%   - index: 256*1, 灰度值
%   - hist: 256*1, 直方图
%   - peaks: n*3, n为波峰的个数, 起始位置, 中间位置, 结束位置
%   - ratio: m*1, 刨除比例
%   - ranges: m*2, 动态范围: [第一次出现, 最后一次出现]
%
% usage:
%   show_peak_range(index, hist, peaks, ratio, ranges)
%

colors = {'b', 'r', 'g', 'c', 'm', 'y', 'k', 'w'};

gNum = size(peaks, 1);
rNum = size(ranges, 1);

legend_cell = cell(gNum+rNum, 1);

figure('NumberTitle', 'off', 'Name', 'Peaks and Ranges of Histogram')
for i = 1:gNum
    idx_start = peaks(i, 1);
    idx_end = peaks(i, 3);
    bar(index(idx_start:idx_end), hist(idx_start:idx_end), 'FaceColor', colors{i}, 'BarWidth', 1.0);
    hold on,
    legend_cell{i} = ['第 ', num2str(i) ' 个波峰'];
end

maxVal = max(hist);
step = (0.6 - 0.4) / rNum;
yval = 0.6:-step:0.4;
for i = 1:rNum
    idx_low = ranges(i, 1);
    idx_up = ranges(i, 2);
    range = idx_up - idx_low + 1;
    plot(idx_low:idx_up, ones(range, 1) * maxVal * yval(i), colors{i}, 'linestyle', '--', 'linewidth', 1.1);
    legend_cell{gNum+i} = ['%' num2str(round(ratio(i)*100)) ' 动态范围'];
end

legend(legend_cell)

% save
set(gca, 'color', 'none'); % set background
fig_hist = getframe(gcf);
fig_hist = fig_hist.cdata;
alpha = ones(size(fig_hist, 1), size(fig_hist, 2));
fig_gray = rgb2gray(fig_hist);
alpha(fig_gray==240) = 0; % get alpha
imwrite(fig_hist, 'peak_range.png', 'Alpha', alpha)

end
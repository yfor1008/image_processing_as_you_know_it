function [output] = hist_analysis(hist, show)
% hist_analysis - 直方图分析
%
% input:
%   - hist: 256*1, int/float, 直方图
%   - show: bool, 
% output:
%   - 
%
% usage:
%   [output] = hist_analysis(hist)
%
% docs:
%   - 波峰分析: 波峰的个数代表了图像亮度的区分度
%   - 动态范围: 代表了图像对比度
%

if ~exist('show', 'var')
    show = 0;
end

% peak of wave
index = 0:255;
gStr = autoGauFit(index, hist');
if show
    % visualizationProcess(index, hist', gStr, 'final');
    show_peak(index, hist, gStr);
end

output = 0;

end

function show_peak(index, hist, outStruct)
% show_peak - 显示波峰
%
% input:
%   - index: 256*1, 灰度值
%   - hist: 256*1, 直方图
%   - outStruct: struct, 拟合结果结构体
%
% usage:
%   show_peak(hist, gStr)
%

[~, gNum] = size(outStruct.height);
G = 0;
for i = 1:gNum
    height = outStruct.height(end, i);
    position = outStruct.position(end, i);
    width = outStruct.width(end, i);
    gi = height * exp(-((index-position)/width).^2);
    G = G + gi; % 拟合曲线
end

% 在波峰之间寻找最低点作为2个波峰的分界



end
function [output] = hist_analysis(hist)
% hist_analysis - 直方图分析
%
% input:
%   - hist: 256*1, int/float, 直方图
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

% peak of wave
hist_smooth = medfilt1(hist, 50);

end
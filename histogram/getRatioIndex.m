function [index] = getRatioIndex(hist, ratio)
% getRatioIndex - 获取 ratio 对应的 index
%
% input:
%   - hist: 256*1, int/float, 直方图
%   - ratio: float, 累积比例
% output:
%   - index: int, ratio 对应的 index, [1, 256]
%

cdf = cumsum(hist);
index = find(cdf >= (cdf(end) * ratio), 1);

end
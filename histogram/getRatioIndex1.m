function [index] = getRatioIndex1(hist, ratio)
% getRatioIndex - 获取 ratio 对应的 index
%
% input:
%   - hist: 256*1, int/float, 直方图
%   - ratio: float, 累积值
% output:
%   - index: int, ratio 对应的 index, [1, 256]
%

index = 0;
cdf = 0;
for idx = 1:256
    cdf = cdf + hist(idx);
    if cdf >= ratio
        index = idx;
        break;
    end
end

end
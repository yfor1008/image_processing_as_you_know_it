function [filtered] = meanFilterModify(im, halfRadius)
% meanFilterModify - 改进均值滤波, 更新窗口内数据, 而不用每次计算窗口内所有值
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

filtered = im;
im_pad = impadding(im, halfRadius);

[H, W] = size(im);
rowEnv = mod(H, 2);
blockVal = sum(sum(im_pad(1:halfRadius*2+1, 1:halfRadius*2+1)));
blockSize = (halfRadius*2+1) * (halfRadius*2+1);
for r = halfRadius+1:2:halfRadius+H-rowEnv
    cur_r = r - halfRadius;
    % 当前行第 1 列
    filtered(cur_r,1) = round(blockVal / blockSize);
    % 减去前一个 block 的第一列, 加上当前 block 的最会一列
    for c = halfRadius+2:halfRadius+W
        cur_c = c-halfRadius;
        blockVal = blockVal - sum(im_pad(cur_r:r+halfRadius, cur_c-1)) + sum(im_pad(cur_r:r+halfRadius, c+halfRadius));
        filtered(cur_r,cur_c) = round(blockVal / blockSize);
    end
    % 下一行, 减去当前 block 第一行, 加上下一个 block 的最后一行
    blockVal = blockVal - sum(im_pad(cur_r, cur_c:c+halfRadius)) + sum(im_pad(r+1+halfRadius, cur_c:c+halfRadius));
    filtered(cur_r+1,end) = round(blockVal / blockSize);
    % 减去后一个 block 的最后一列, 加上当前 block 的第一列
    for c = halfRadius+W-1:-1:halfRadius+1
        cur_c = c-halfRadius;
        blockVal = blockVal - sum(im_pad(r+1-halfRadius:r+1+halfRadius, c+halfRadius+1)) + sum(im_pad(r+1-halfRadius:r+1+halfRadius, c-halfRadius));
        filtered(cur_r+1,cur_c) = round(blockVal / blockSize);
    end
    % 更新为下一行第一列
    blockVal = blockVal - sum(im_pad(r+1-halfRadius, cur_c:c+halfRadius)) + sum(im_pad(min(r+1+halfRadius+1, size(im_pad, 1)), cur_c:c+halfRadius));
end

if rowEnv
    % 若图像行为奇数, 则为最后行处理
    filtered(end,1) = round(blockVal / blockSize);
    % 减去前一个 block 的第一列, 加上当前 block 的最会一列
    for c = halfRadius+2:halfRadius+W
        cur_c = c-halfRadius;
        blockVal = blockVal - sum(im_pad(H:H+halfRadius*2, cur_c-1)) + sum(im_pad(H:H+halfRadius*2, c+halfRadius));
        filtered(end,cur_c) = round(blockVal / blockSize);
    end
end

end
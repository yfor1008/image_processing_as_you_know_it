function [labeled] = seedFill(bw, conn)
% seedFill - 区域连通, 基于种子点填充方法
%
% input:
%   - bw: H*W, 二值图像, 1 为前景, 0 为背景
%   - conn: int, 连通区域, 4 or 8
% output:
%   - labeled: H*W, 标注后的图像, 每一个连通区域内的像素值相同
%
% docs:
%   1. 连通区域基本条件: 一是像素值相同, 二是位置相邻
%   2. 基于种子点填充方法的原理为:
%       - 选取一个前景点作P(x,y)为种子点, 并赋予一个 label, 并将该点 conn 邻域内所有前景点添加到栈中;
%       - 弹出栈顶像素, 赋予相同的 label, 并将该点 conn 邻域内所有前景点添加到栈中;
%       - 重复这个步骤, 直到栈中没有元素, 则一个区域标记完成;
%       - 重复上述所有步骤, 完成整个图像标注;
%

if ~exist('conn', 'var')
    conn = 8;
end

labeled = double(bw);

[H, W] = size(labeled);
pixels = H * W;
rows = zeros(pixels, 1);
cols = zeros(pixels, 1);
mask = zeros(H, W); % 标记是否已处理: 0-未处理, 1-已处理
label = 0;
for r = 1:H
    for c = 1:W
        if labeled(r,c) == 1 && mask(r,c) == 0
            label = label + 1;
            
            cr = r;
            cc = c;
            
            mask(cr,cc) = 1;
            labeled(cr,cc) = label;
            
            up = cr-1;
            up = max(up, 1);
            down = cr+1;
            down = min(down, H);
            left = cc-1;
            left = max(left, 1);
            right = cc+1;
            right = min(right, W);
            
            idx_start = 1;
            idx_end = 1;
            if labeled(up,cc) == 1 && mask(up,cc) == 0
                rows(idx_end) = up; cols(idx_end) = cc; % 上
                mask(up,cc) = 1;
                labeled(up,cc) = label;
                idx_end = idx_end + 1;
            end
            if labeled(down,cc) == 1 && mask(down,cc) == 0
                rows(idx_end) = down; cols(idx_end) = cc; % 下
                mask(down,cc) = 1;
                labeled(down,cc) = label;
                idx_end = idx_end + 1;
            end
            if labeled(cr,left) == 1 && mask(cr,left) == 0
                rows(idx_end) = cr; cols(idx_end) = left; % 左
                mask(cr,left) = 1;
                labeled(cr,left) = label;
                idx_end = idx_end + 1;
            end
            if labeled(cr,right) == 1 && mask(cr,right) == 0
                rows(idx_end) = cr; cols(idx_end) = right; % 右
                mask(cr,right) = 1;
                labeled(cr,right) = label;
                idx_end = idx_end + 1;
            end
            if conn == 8
                if labeled(up,left) == 1 && mask(up,left) == 0
                    rows(idx_end) = up; cols(idx_end) = left; % 左上
                    mask(up,left) = 1;
                    labeled(up,left) = label;
                    idx_end = idx_end + 1;
                end
                if labeled(down,left) == 1 && mask(down,left) == 0
                    rows(idx_end) = down; cols(idx_end) = left; % 左下
                    mask(down,left) = 1;
                    labeled(down,left) = label;
                    idx_end = idx_end + 1;
                end
                if labeled(up,right) == 1 && mask(up,right) == 0
                    rows(idx_end) = up; cols(idx_end) = right; % 右上
                    mask(up,right) = 1;
                    labeled(up,right) = label;
                    idx_end = idx_end + 1;
                end
                if labeled(down,right) == 1 && mask(down,right) == 0
                    rows(idx_end) = down; cols(idx_end) = right; % 右下
                    mask(down,right) = 1;
                    labeled(down,right) = label;
                    idx_end = idx_end + 1;
                end
            end

            while idx_start < idx_end
                cr = rows(idx_start);
                cc = cols(idx_start);
                idx_start = idx_start + 1; % 出栈
                up = cr-1;
                down = cr+1;
                left = cc-1;
                right = cc+1;

                if up >= 1 && labeled(up,cc) == 1 && mask(up,cc) == 0
                    rows(idx_end) = up; cols(idx_end) = cc; % 上
                    mask(up,cc) = 1;
                    labeled(up,cc) = label;
                    idx_end = idx_end + 1;
                end
                if down <= H && labeled(down,cc) == 1 && mask(down,cc) == 0
                    rows(idx_end) = down; cols(idx_end) = cc; % 下
                    mask(down,cc) = 1;
                    labeled(down,cc) = label;
                    idx_end = idx_end + 1;
                end
                if left >= 1 && labeled(cr,left) == 1 && mask(cr,left) == 0
                    rows(idx_end) = cr; cols(idx_end) = left; % 左
                    mask(cr,left) = 1;
                    labeled(cr,left) = label;
                    idx_end = idx_end + 1;
                end
                if right <= W && labeled(cr,right) == 1 && mask(cr,right) == 0
                    rows(idx_end) = cr; cols(idx_end) = right; % 右
                    mask(cr,right) = 1;
                    labeled(cr,right) = label;
                    idx_end = idx_end + 1;
                end
                if conn == 8
                    if (up >= 1 && left >= 1) && labeled(up,left) == 1 && mask(up,left) == 0
                        rows(idx_end) = up; cols(idx_end) = left; % 左上
                        mask(up,left) = 1;
                        labeled(up,left) = label;
                        idx_end = idx_end + 1;
                    end
                    if (down <= H && left >= 1) && labeled(down,left) == 1 && mask(down,left) == 0
                        rows(idx_end) = down; cols(idx_end) = left; % 左下
                        mask(down,left) = 1;
                        labeled(down,left) = label;
                        idx_end = idx_end + 1;
                    end
                    if (up >= 1 && right <= W) && labeled(up,right) == 1 && mask(up,right) == 0
                        rows(idx_end) = up; cols(idx_end) = right; % 右上
                        mask(up,right) = 1;
                        labeled(up,right) = label;
                        idx_end = idx_end + 1;
                    end
                    if (down <= H && right <= W) && labeled(down,right) == 1 && mask(down,right) == 0
                        rows(idx_end) = down; cols(idx_end) = right; % 右下
                        mask(down,right) = 1;
                        labeled(down,right) = label;
                        idx_end = idx_end + 1;
                    end
                end
            end

        end
    end
end

end
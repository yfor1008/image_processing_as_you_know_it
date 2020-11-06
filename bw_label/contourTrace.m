function [labeled] = contourTrace(bw)
% contourTrace - 区域连通, 基于轮廓跟踪方法
%
% input:
%   - bw: H*W, 二值图像, 1 为前景, 0 为背景
% output:
%   - labeled: H*W, 标注后的图像, 每一个连通区域内的像素值相同
%
% docs:
%   1. 连通区域基本条件: 一是像素值相同, 二是位置相邻
%   2. 基于轮廓跟踪方法的原理详见: "A linear-time component-labeling algorithm using contour tracing technique"
%

[H, W] = size(bw);
H1 = H + 1;
bw1 = zeros(H1, W);
bw1(2:end, :) = bw; % 最上面一行补0

labeled = zeros(H1, W);
label = 0;

for r = 2:H1
    for c = 1:W

        if bw1(r,c) == 0
            continue;
        end

        if r > 1
            above = bw1(r-1, c);
        else
            above = 0;
        end
        if r < H1
            below = bw1(r+1, c);
            below_label = labeled(r+1, c);
        else
            below = 0;
            below_label = -1;
        end
        if labeled(r, c) == 0 && above == 0
            % 外部轮廓起始位置, 文章中step1
            label = label + 1;
            % 轮廓跟踪
            labeled = tracer(bw1, labeled, label, H1, W, c, r, 1);
        elseif below_label == 0 && below == 0
            % 内部轮廓起始位置, 文章中step2
            if labeled(r, c)
                % 已标注
                cur_label = labeled(r, c);
            else
                % 未标注
                cur_label = labeled(r, c-1);
            end
            labeled = tracer(bw1, labeled, cur_label, H1, W, c, r, 0);
        elseif labeled(r, c) == 0
            % 内部元素, 文章中step3
            if c > 1
                labeled(r, c) = labeled(r, c-1);
            else
                labeled(r, c) = 0;
            end
            
        end

    end
end

labeled(1, :) = [];
labeled(labeled == -1) = 0;

end

function [labeled] = tracer(bw, labeled, label, imH, imW, sp_x, sp_y, ex_in)
% tracer - 轮廓跟踪
%
% input:
%   - bw: 二值图像
%   - labeled: 标注图像
%   - label: 当前轮廓标签
%   - imH: 图像高度
%   - imW: 图像宽度
%   - sp_x: 轮廓起始位置坐标
%   - sp_y: 轮廓起始位置坐标
%   - ex_in: 外部/内部轮廓, 1-外部轮廓, 0-内部轮廓
% output:
%   - labeled: 标注后图像
%

dx = [1, 1, 0, -1, -1, -1, 0, 1];
dy = [0, 1, 1, 1, 0, -1, -1, -1];

% 当前位置
x0 = sp_x;
y0 = sp_y;

% 初始位置及其下一个位置, 对应文章3.1中的S和T
sx = sp_x;
sy = sp_y;
tx = -1;
ty = -1;

% 搜索方向
if ex_in
    d = 7;
else
    d = 3;
end

% 更新标注
labeled(y0,x0) = label;

% 跟踪
condition = 1; % 结束条件
while condition
    % 顺时针方向搜索
    j = 0;
    while j < 8
        x1 = x0 + dx(d+1);
        y1 = y0 + dy(d+1);

        if (x1 < 1) || (x1 > imW) || (y1 < 1) || (y1 > imH) || labeled(y1,x1) == -1
            d = mod(d + 1, 8);
            j = j + 1;
            continue;
        end

        if bw(y1,x1) == 1
            labeled(y1,x1) = label;
            if (tx < 0) && (ty < 0)
                % 初始位置下一个位置, 仅更新一次
                tx = x1;
                ty = y1;
            else
                condition = ~(((x0 == sx) && (y0 == sy)) && ((x1 == tx) && (y1 == ty)));
            end
            x0 = x1;
            y0 = y1;
            break;
        else
            % 背景设置为-1
            labeled(y1,x1) = -1;
        end

        d = mod(d + 1, 8);
        j = j + 1;
    end

    % 孤立点
    if 8 == j
        condition = 0;
    end

    % 更新搜索起始位置
    previous_d = mod(d + 4, 8);
    d = mod(previous_d + 2, 8);

end

end

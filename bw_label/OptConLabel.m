function [labeled] = OptConLabel(bw)
% OptConLabel - 改进的二次扫描方法
%
% input:
%   - bw: H*W, 二值图像, 1 为前景, 0 为背景
% output:
%   - labeled: H*W, 标注后的图像, 每一个连通区域内的像素值相同
%
% docs:
%   1. 改进 union-find 方法, 详见: "Optimizing two-pass connected-component labeling algorithms" 
%   2. 使用一维向量 P 作为 union-find 的数据结构
%   3. P(i) 表示标签为 i 的根节点为 P(i)
%

[H, W] = size(bw);
P = zeros(H*W, 1); % P(i) 表示节点 i 的根节点
L = zeros(H, W);
l = 0;

% first scan
for y = 1:H
    for x = 1:W
        if bw(y, x)
            % 邻域 a b c d
            ay = max(y-1, 1); ax = max(x-1, 1);
            by = max(y-1, 1); bx = x;
            cy = max(y-1, 1); cx = min(x+1, W);
            dy = y; dx = max(x-1, 1);
            a = bw(ay, ax);
            b = bw(by, bx);
            c = bw(cy, cx);
            d = bw(dy, dx);
            La = L(ay, ax);
            Lb = L(by, bx);
            Lc = L(cy, cx);
            Ld = L(dy, dx);

            flag_a = (y-1 > 0) && (x-1 > 0);
            flag_b = (y-1 > 0);
            flag_c = (y-1 > 0) && (x+1 <= W);
            flag_d = (x-1 > 0);
            flag = 0; % 仅判断在图像范围内的像素, 超出范围则不进行判断
            root_labels = zeros(4,1); % 邻域内的标签
            idx = 1;
            if flag_a && a
                flag = flag || La;
                root_la = findRoot(P, La);
                root_labels(idx) = root_la;
                idx = idx + 1;
            end
            if flag_b && b
                flag = flag || Lb;
                root_lb = findRoot(P, Lb);
                root_labels(idx) = root_lb;
                idx = idx + 1;
            end
            if flag_c && c
                flag = flag || Lc;
                root_lc = findRoot(P, Lc);
                root_labels(idx) = root_lc;
                idx = idx + 1;
            end
            if flag_d && d
                flag = flag || Ld;
                root_ld = findRoot(P, Ld);
                root_labels(idx) = root_ld;
                idx = idx + 1;
            end
            root_labels(idx:end) = [];

            if flag
                % 邻域内有其他目标, 取最小标签
                L(y, x) = min(root_labels);
                if La && (La ~= L(y, x))
                    P = setRoot(P, La, L(y, x));
                end
                if Lb && (Lb ~= L(y, x))
                    P = setRoot(P, Lb, L(y, x));
                end
                if Lc && (Lc ~= L(y, x))
                    P = setRoot(P, Lc, L(y, x));
                end
                if Ld && (Ld ~= L(y, x))
                    P = setRoot(P, Ld, L(y, x));
                end
            else
                % 邻域内没有目标, 为新的目标
                l = l + 1;
                L(y, x) = l;
                P(l) = l;
            end
        end
    end
end

% 将 union-find 树拉平, 路径压缩
P = flattenL(P, l);
% P = flatten(P, l);

% second scan
for y = 1:H
    for x = 1:W
        if L(y, x)
            L(y, x) = P(L(y, x));
        end
    end
end

labeled = L;

end

function [root] = findRoot(P, i)
% findRoot - 查找根节点
%
% input:
%   - P: array, 连接表
%   - i: int, 节点
% output:
%   - root: int, 根节点
%

root = i;
while P(root) < root
    root = P(root);
end

end

function [P] = setRoot(P, i, root)
% setRoot - 设置根节点
%
% input:
%   - P: array, 连接表
%   - i: int, 节点
%   - root: int, 根节点
% output:
%   - P: array, 连接表
%
% docs:
%   - 将节点 i 的根节点设置为 root
%

while P(i) < i
    j = P(i);
    P(i) = root;
    i = j;
end
P(i) = root;

end

function [P] = flatten(P, sz)
% flatten - 将 union-find 树拉平(路径压缩)
%
% input:
%   - P: array, 连接表
%   - sz: int, 连接表大小
%   - root: int, 根节点
% output:
%   - P: array, 连接表
%

for i = 1:sz
    P(i) = P(P(i));
end

end

function [P] = flattenL(P, sz)
% flattenL - 将 union-find 树拉平(路径压缩), 重新分配标签, 使其按顺序来
%
% input:
%   - P: array, 连接表
%   - sz: int, 连接表大小
%   - root: int, 根节点
% output:
%   - P: array, 连接表
%

k = 1;
for i = 1:sz
    if P(i) < i
        P(i) = P(P(i));
    else
        P(i) = k;
        k = k + 1;
    end
end

end
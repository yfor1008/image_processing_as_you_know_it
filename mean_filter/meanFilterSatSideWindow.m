function [filtered] = meanFilterSatSideWindow(im, halfRadius)
% meanFilterSatSideWindow - 改进均值滤波, 使用积分图+SideWindow
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
% docs:
%   - side window原理可以查看: "Side Window Filtering"
%

im_pad = impadding(im, halfRadius);
im_pad1 = zeros(size(im_pad)+1); % 增加初始行列, 方便计算
im_pad1(2:end, 2:end) = im_pad;

% 积分图, 这里使用 matlab 自带函数实现, matlab 实现耗时少, 稳定, 详细参看:
% https://github.com/yfor1008/image_processing_as_you_know_it/tree/master/integral_image
im_sat = cumsum(im_pad1, 1);
im_sat = cumsum(im_sat, 2);

size_L = (halfRadius*2+1) * (halfRadius+1);
size_R = size_L;
size_U = size_L;
size_D = size_L;
size_NW = (halfRadius+1) * (halfRadius+1);
size_NE = size_NW;
size_SW = size_NW;
size_SE = size_NW;

% 滤波
[H, W] = size(im);
filtered = zeros(H, W);
blockSize = (halfRadius*2+1) * (halfRadius*2+1);
for r = halfRadius+2:halfRadius+H+1
    for c = halfRadius+2:halfRadius+W+1
        block_L = im_sat(r+halfRadius, c) - im_sat(r-halfRadius-1, c) ...
                    - im_sat(r+halfRadius, c-halfRadius-1) + im_sat(r-halfRadius-1, c-halfRadius-1);
        block_R = im_sat(r+halfRadius, c+halfRadius) - im_sat(r-halfRadius-1, c+halfRadius) ...
                    - im_sat(r+halfRadius, c-1) + im_sat(r-halfRadius-1, c-1);
        block_U = im_sat(r, c+halfRadius) - im_sat(r-halfRadius-1, c+halfRadius) ...
                    - im_sat(r, c-halfRadius-1) + im_sat(r-halfRadius-1, c-halfRadius-1);
        block_D = im_sat(r+halfRadius, c+halfRadius) - im_sat(r-1, c+halfRadius) ...
                    - im_sat(r+halfRadius, c-halfRadius-1) + im_sat(r-1, c-halfRadius-1);
        block_NW = im_sat(r, c) - im_sat(r-halfRadius-1, c) ...
                    - im_sat(r, c-halfRadius-1) + im_sat(r-halfRadius-1, c-halfRadius-1);
        block_NE = im_sat(r, c+halfRadius) - im_sat(r-halfRadius-1, c+halfRadius) ...
                    - im_sat(r, c-1) + im_sat(r-halfRadius-1, c-1);
        block_SW = im_sat(r+halfRadius, c) - im_sat(r-1, c) ...
                    - im_sat(r+halfRadius, c-halfRadius-1) + im_sat(r-1, c-halfRadius-1);
        block_SE = im_sat(r+halfRadius, c+halfRadius) - im_sat(r-1, c+halfRadius) ...
                    - im_sat(r+halfRadius, c-1) + im_sat(r-1, c-1);
        
        block_L = block_L/size_L;
        block_R = block_R/size_R;
        block_U = block_U/size_U;
        block_D = block_D/size_D;
        block_NW = block_NW/size_NW;
        block_NE = block_NE/size_NE;
        block_SW = block_SW/size_SW;
        block_SE = block_SE/size_SE;
        E = [block_L, block_R, block_U, block_D, block_NW, block_NE, block_SW, block_SE];
        E1 = abs(E - im_pad1(r, c));
        [~, idx] = min(E1);
        filtered(r-halfRadius-1, c-halfRadius-1) = E(idx);
    end
end
filtered = round(filtered);

end
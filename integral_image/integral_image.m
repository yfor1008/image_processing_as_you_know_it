function [sat] = integral_image(im)
%integral_image - 积分图, integral image, 也叫 Summed Area Table(SAT)
%
% input:
%   - im: H*W, gray 图像
% output:
%   - sat: H*W, 积分图, Summed Area Table(SAT)
%

[H, W] = size(im);
sat = double(im);

% 行方向求和
for r = 1:H
    for c = 2:W
        sat(r,c) = sat(r,c-1) + im(r,c);
    end
end

% 列方向求和
for c = 1:W
    for r = 2:H
        sat(r,c) = sat(r-1,c) + sat(r,c);
    end
end

end
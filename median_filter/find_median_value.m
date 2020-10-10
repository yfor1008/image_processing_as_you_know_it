close all; clear; clc;
addpath('../histogram/');

% 仿真查找中值过程, 参考: https://blog.51cto.com/qianqing13579/1590217

% 初始化数据
winSize = 15; % 窗口大小, 为奇数
total = winSize * winSize;
iterNum = 100;
im = randi([1, 256], winSize, iterNum+winSize-1)-1;
% save('im.mat', 'im')
% load im.mat

% step1
th = floor(total / 2) + 1;
% step2: 确定直方图中值 med, 小于等于 med 的个数 mNum
hist = hist_count(im(1:winSize, 1:winSize));
hist = hist(1:256)';
med = getRatioIndex1(hist, 0.5*sum(hist));
mNum = sum(hist(1:med));

% figure, fig = bar(hist);
% fig.FaceColor = 'flat';
% fig.CData(med, :) = [1. 0. 0.];

% step3: 去除最左列, 更新 mNum
left = im(1:winSize, 1);
for j = 1:winSize
    hist(left(j) + 1) = hist(left(j) + 1) - 1;
    if left(j)+1 <= med
        mNum = mNum - 1;
    end
end

% time record
run_times_effective = zeros(iterNum-2, 1);
run_times_hist = zeros(iterNum-2, 1);
diffs = zeros(iterNum-2, 1);

% 处理过程
for i = 2:iterNum-1
    % step4: 窗口右移一列, 增加最右列, 更新 mNum
    right = im(1:winSize, i+winSize-1);
    for j = 1:winSize
        hist(right(j) + 1) = hist(right(j) + 1) + 1;
        if right(j)+1 <= med
            mNum = mNum + 1;
        end
    end

    time_start = tic;
    % step6
    while mNum >= th
        mNum = mNum - hist(med);
        med = med - 1;
        while hist(med) == 0
            med = med - 1;
        end
        if mNum <= th
            break;
        end
    end
    % step5
    while mNum < th
        med = med + 1;
        while hist(med) == 0
            med = med + 1;
        end
        mNum = mNum + hist(med);
        if mNum >= th
            break;
        end
    end
    time_elapased = toc(time_start);
    run_times_effective(i-1) = time_elapased;
    
    time_start = tic;
    med1 = getRatioIndex1(hist, 0.5*sum(hist));
    time_elapased = toc(time_start);
    run_times_hist(i-1) = time_elapased;

    diffs(i-1) = med - med1;

    % fig = bar(hist);
    % fig.FaceColor = 'flat';
    % fig.CData(med, :) = [1. 0. 0.];
    % fig.CData(med1, :) = [0. 1. 0.];

    % step3
    left = im(1:winSize, i);
    for j = 1:winSize
        hist(left(j) + 1) = hist(left(j) + 1) - 1;
        if left(j)+1 <= med
            mNum = mNum - 1;
        end
    end
end

subplot(211), plot(diffs)
subplot(212), plot(run_times_effective)
hold on, 
plot(run_times_hist)
legend('effective', 'hist')

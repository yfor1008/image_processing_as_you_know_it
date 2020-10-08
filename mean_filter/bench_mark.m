close all; clear; clc;
addpath('../padding/');

if ~exist('time_elapased.mat', 'file')
    im = imread('./src/lena.jpg');
    gray = rgb2gray(im);

    % time test
    step = 3;
    radius = 1:step:30;
    run_times_origin = zeros(length(radius), 1);
    idx = 1;
    for r = radius
        time_start = tic;
        for i = 1:10
            filtered = meanFilter(gray, r);
        end
        time_elapased = toc(time_start);
        run_times_origin(idx) = time_elapased/10;
        idx = idx + 1;
    end
    run_times_matlab = zeros(length(radius), 1);
    idx = 1;
    for r = radius
        time_start = tic;
        for i = 1:10
            h = ones(2*r+1, 2*r+1) / ((2*r+1) * (2*r+1));
            filtered = imfilter(gray, h, 'replicate');
        end
        time_elapased = toc(time_start);
        run_times_matlab(idx) = time_elapased/10;
        idx = idx + 1;
    end
    run_times_modify = zeros(length(radius), 1);
    idx = 1;
    for r = radius
        time_start = tic;
        for i = 1:10
            filtered = meanFilterModify(gray, r);
        end
        time_elapased = toc(time_start);
        run_times_modify(idx) = time_elapased/10;
        idx = idx + 1;
    end
    run_times_sat = zeros(length(radius), 1);
    idx = 1;
    for r = radius
        time_start = tic;
        for i = 1:10
            filtered = meanFilterSat(gray, r);
        end
        time_elapased = toc(time_start);
        run_times_sat(idx) = time_elapased/10;
        idx = idx + 1;
    end
    save('time_elapased.mat', 'run_times_origin', 'run_times_matlab', 'run_times_modify', 'run_times_sat', 'radius')
else
    load time_elapased.mat
end

% plot
semilogy(radius, run_times_origin*1000, 'LineWidth', 1.1)
hold on,
semilogy(radius, run_times_matlab*1000, 'LineWidth', 1.1)
semilogy(radius, run_times_modify*1000, 'LineWidth', 1.1)
semilogy(radius, run_times_sat*1000, 'LineWidth', 1.1)
legend('origin', 'matlab', 'modify', 'sat')
xlabel('窗口半径, Half Radius')
ylabel('耗时(毫秒), Time Elapased(ms)')
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

set(gca, 'color', 'none');
fig_rgb = getframe(gcf);
fig_rgb = fig_rgb.cdata;
alpha = ones(size(fig_rgb, 1), size(fig_rgb, 2));
fig_gray = rgb2gray(fig_rgb);
alpha(fig_gray==240) = 0;
imwrite(fig_rgb, 'time_elapased_cmp.png', 'Alpha', alpha);

close all; clear; clc;

if ~exist('time_elapased.mat', 'file')
    I = imread('rice.png');
    num = 10;
    scale = sqrt([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    run_times_matlab = zeros(length(scale), 1);
    run_times_seedfill = zeros(length(scale), 1);
    run_times_contourtrace = zeros(length(scale), 1);
    run_times_hybridobject = zeros(length(scale), 1);
    pixels = zeros(length(scale), 1);

    % matlab test
    idx = 1;
    for s = scale
        I1 = imresize(I, s);
        BW = I1 > 128;

        time_start = tic;
        for i = 1:num
            labeled = bwlabel(BW);
        end
        time_elapased = toc(time_start);
        run_times_matlab(idx) = time_elapased/num;
        pixels(idx) = numel(BW);
        idx = idx + 1;
    end

    % seedfill
    idx = 1;
    for s = scale
        I1 = imresize(I, s);
        BW = I1 > 128;

        time_start = tic;
        for i = 1:num
            labeled1 = seedFill(BW);
        end
        time_elapased = toc(time_start);
        run_times_seedfill(idx) = time_elapased/num;
        idx = idx + 1;
    end

    % contourtrace
    idx = 1;
    for s = scale
        I1 = imresize(I, s);
        BW = I1 > 128;

        time_start = tic;
        for i = 1:num
            labeled2 = contourTrace(BW);
        end
        time_elapased = toc(time_start);
        run_times_contourtrace(idx) = time_elapased/num;
        idx = idx + 1;
    end

    % hybridobject
    idx = 1;
    for s = scale
        I1 = imresize(I, s);
        BW = I1 > 128;

        time_start = tic;
        for i = 1:num
            labeled2 = hybridObject(BW);
        end
        time_elapased = toc(time_start);
        run_times_hybridobject(idx) = time_elapased/num;
        idx = idx + 1;
    end

    save('time_elapased.mat', 'run_times_matlab', 'run_times_seedfill', 'run_times_contourtrace', 'run_times_hybridobject', 'pixels')
else
    load time_elapased.mat
end

% plot
plot(pixels, run_times_matlab*1000, 'LineWidth', 1.1)
hold on,
plot(pixels, run_times_seedfill*1000, 'LineWidth', 1.1)
plot(pixels, run_times_contourtrace*1000, 'LineWidth', 1.1)
plot(pixels, run_times_hybridobject*1000, 'LineWidth', 1.1)
legend('matlab', 'seedfill', 'contourtrace', 'hybridobject')
xlabel('像素个数, Pixel Number')
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

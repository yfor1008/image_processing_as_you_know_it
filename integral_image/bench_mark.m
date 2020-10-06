close all; clear; clc;

index = 100;
run_times_sat = zeros(index,1);
run_times_matlab = zeros(index,1);
diff = zeros(index,1);
for i = 1:index
    size_low = 480;
    size_up = 1024;
    imSize = round(size_low + (size_up - size_low) * rand(1));

    im = round(rand(imSize, imSize) * 255);

    num = 20;

    time_start = tic;
    for ii = 1:num
        sat = integral_image(im);
    end
    time_elapased = toc(time_start);
    run_times_sat(i) = time_elapased/num;

    time_start = tic;
    for ii = 1:num
        sat1 = cumsum(im, 1);
        sat1 = cumsum(sat1, 2);
    end
    time_elapased = toc(time_start);
    run_times_matlab(i) = time_elapased/num;

    diff(i) = sum(sum(sat - sat1));
end

plot(run_times_sat, 'LineWidth', 1.1)
hold on,
plot(run_times_matlab, 'LineWidth', 1.1)
legend('sat', 'matlab')
ylabel('耗时(秒), Time Elapased(s)')
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

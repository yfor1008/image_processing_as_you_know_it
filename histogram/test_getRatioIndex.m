close all; clear; clc;

hist = round(rand(256, 1) * 255);
num = 100;

time_start = tic;
for i = 1:num
    index = getRatioIndex(hist, 0.5*sum(hist));
end
time_elapased = toc(time_start);
run_times = time_elapased/num;

time_start = tic;
for i = 1:num
    index1 = getRatioIndex1(hist, 0.5*sum(hist));
end
time_elapased = toc(time_start);
run_times1 = time_elapased/num;

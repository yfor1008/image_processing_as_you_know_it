# 你所知道的直方图

直方图可以反映图像的重要信息:

- 图像动态范围
- 图像场景大致类别

## 使用方法

### 获取直方图

如下所示, 详见`main_test.m`

```matlab
im = imread('./src/timg.jpg');
[h_gray, h_r, h_g, h_b] = hist_count(im, 1); % 获取直方图并显示
```

![rgb 直方图](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histogram/src/hist_rgb.png)

### 对直方图进行分析

对直方图进行 gaussian 拟合, 如下所示:

```matlab
addpath('../gaussian_fit/');
[outHist] = hist_analysis(h_gray, 1); % 分析并显示结果
```

![高斯拟合](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histogram/src/fit_result.png)

![直方图动态范围](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histogram/src/peak_range.png)

### 将结果显示在图像上

如下图所示, 将直方图上得到的不同类别的数据显示在图像上, 以不同的颜色进行区分.

```matlab
show_peak(im, outHist);
```

![场景类别](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histogram/src/peak_area.png)


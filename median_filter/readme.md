# Median Filter

## 原理

计算图像每个像素周围邻域所有像素的中值.

根据原理直接进行计算时, 算法耗时随邻域窗口大小增加而增加. 但经过比较发现, matlab 中实现的中值滤波算法耗时较少, 且算法耗时基本为一个恒定的值, 不随邻域窗口大小变化而变化, 如下所所示.

![算法耗时](https://github.com/yfor1008/image_processing_as_you_know_it/blob/master/median_filter/src/time_elapased.png?raw=true)

## 改进

有以下几种改进:

1. 使用直方图代替排序, 提高算法执行效率, 参考: **A Fast Two-Dimensional Median Filtering Algorithm**;
2. 对上述方法进行改进, 利用空间换时间, 进一步提高执行效率, 参考: **Median Filter in Constant Time**;

结果如下图所示:

![改进方法比较](https://github.com/yfor1008/image_processing_as_you_know_it/blob/master/median_filter/src/time_elapased_cmp.png?raw=true)

**从图中可以看到, 使用改进方法后, 算法耗时为常数, 不随窗口半径变化而变化, 但都不能达到 matlab 实现效果, 可能是 matlab 本身进行了某种优化**.

## 使用方法

```matlab
filtered = medianFilter(gray, r); % gray 为灰度图像, r 为窗口半径
% filtered = medianFilterFast(gray, r); % 改进方法1
% filtered = medianFilterConstant(gray, r); % 改进方法2
```


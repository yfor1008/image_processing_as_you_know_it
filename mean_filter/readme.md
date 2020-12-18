# Mean Filter

## 原理

计算图像每个像素周围邻域所有像素的均值.

根据原理直接进行计算时, 算法耗时随邻域窗口大小增加而增加. 但经过比较发现, matlab 中实现的均值滤波算法耗时较少, 且算法耗时基本为一个恒定的值, 不随邻域窗口大小变化而变化, 如下所所示.

![算法耗时](https://github.com/yfor1008/image_processing_as_you_know_it/blob/master/mean_filter/src/time_elapased.png?raw=true)

## 改进

有以下几种改进:

1. 原始方法每次计算都需要窗口内的所有像素均值; 改进方法为: 由于进行顺序遍历, 可以仅更新其中某些值, 而不需要计算窗口内所有像素;
2. 利用积分图进行加速;
3. 使用[侧窗滤波(SideWindowFilter)](https://arxiv.org/pdf/1905.07177.pdf), 减少对图像边缘的平滑;

结果如下图所示:

![改进方法比较](https://github.com/yfor1008/image_processing_as_you_know_it/blob/master/mean_filter/src/time_elapased_cmp.png?raw=true)

![滤波效果比较](https://github.com/yfor1008/filter/blob/master/SideWindowFilter/src/cmp_median_side.jpg?raw=true)

**从图中可以看到**

- 使用积分图方法基本可以达到 matlab 实现效果,  算法耗时为常数, 不随窗口半径变化而变化
- 使用侧窗滤波可以较少对图像边缘的模糊(图中依次为: 原图, 中止滤波, 侧窗中值滤波)
- 使用侧窗+积分图时, 算法耗时不随窗口半径变化而变化, 没有进行优化的结果可以查看[[这里]](https://github.com/yfor1008/filter/blob/master/SideWindowFilter/src/time_elapased_cmp.png)

## 使用方法

```matlab
filtered = meanFilter(im, r); % im 为灰度图像, r 为窗口半径
% filtered = meanFilterModify(im, r); % 改进方法
% filtered = meanFilterSat(im, r); % 积分图方法
% filtered = meanFilterSatSideWindow(im, r); % 积分图+side window方法
```


# 直方图均衡

## 使用方法

```matlab
show = 1; % show=1 显示处理过程及结果, show=0 不显示
im_eq = imHistEq(im, show); % im 可以为 RGB 或者 Gray
```

## 改进

```matlab
show = 1; % show=1 显示处理过程及结果, show=0 不显示
mode = 0; % 改进方法, 0-开根号, 1-截取
im_eq = imHistEq(im, show, mode); % im 可以为 RGB 或者 Gray
```

## 效果

### gray 图像

![灰度图像均衡](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histeq/src/gray_histeq.png)

### RGB 图像

#### 原始方法

![RGB 图像均衡](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histeq/src/rgb_histeq.png)

#### 改进 0

![改进 0](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histeq/src/rgb_modify0_of_histeq.png)

#### 改进 1

![改进 1](https://raw.githubusercontent.com/yfor1008/image_processing_as_you_know_it/master/histeq/src/rgb_modify1_of_histeq.png)
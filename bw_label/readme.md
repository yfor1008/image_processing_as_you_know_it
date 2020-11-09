# BW Label

区域连通处理

## 算法原理

查看相应文章

## 几种方法对比

如下图所示:

![几种方法对比](https://github.com/yfor1008/image_processing_as_you_know_it/blob/master/bw_label/src/time_elapased_cmp.png?raw=true)

## 使用方法

```matlab
% BW为二值图像
labeled = seedFill(BW); % 种子点方法
% labeled = contourTrace(BW); % 轮廓跟踪方法
% labeled = hybridObject(BW); % 递归方法
```


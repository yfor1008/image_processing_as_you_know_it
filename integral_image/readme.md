# 积分图

## 原理

积分图中每个像素点的值为该点左上角所有像素点的值之和, 详见这篇文章: [Rapid object detection using a boosted cascade of simple features](https://www.cs.utexas.edu/~grauman/courses/spring2007/395T/papers/viola_cvpr2001.pdf)

积分图, integral image, 也叫 Summed Area Table(SAT).

## 使用

```matlab
sat = integral_image(im);
```


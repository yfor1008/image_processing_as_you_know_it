# 图像扩充

## 扩充方法

为方便处理, 对图像边界进行填充, 填充方法为:

1. 在图像边界向外填充
2. 填充值为最近的像素值

## 使用方法

```matlab
impad = impadding(im, rsize); % im 为灰度图像, rsize 为填充长度
```


clear % 清除工作空间的变量
clc % 清除命令窗口

a = imread('ikun.jpg'); % 读取名为'Swan.jpg'的图像文件，并将其存储在变量a中

k = 10; % 设置奇异值的数量，这将决定压缩后的图像质量
[~,~,dim] = size(a); % 获取图像的维度

imshow(a); % 显示原始图像
title('原图') ; % 设置图像标题为'原图'

a = double(a); % 将图像数据转换为双精度数据，以进行数学运算

% 对图像的每个颜色通道进行处理
for i = 1:dim
    rea(:,:,i) = process_channel(a(:,:,i), k); % 调用process_channel函数处理颜色通道，并将结果存储在rea中
end

figure; % 创建新的图像窗口
imshow(rea); % 显示压缩后的图像
title(['图像压缩后，k=',num2str(k)]) ; % 设置图像标题，显示压缩后的奇异值数量

filename = ['kunnitaimei_RGB_k=', num2str(k), '.jpg']; % 生成与k值相关的文件名
imwrite(rea, filename); % 将压缩后的图像保存为生成的文件名

% 定义一个函数，用于进行奇异值分解并返回前k个奇异值及其对应的左右奇异向量
function [u1, s1, v1] = svd_compression(u, s, v, k)
    u1 = u(:, 1:k); % 获取前k个左奇异向量
    v1 = v(:, 1:k); % 获取前k个右奇异向量
    ss = diag(s); % 获取奇异值向量
    sss = ss(1:k); % 获取前k个奇异值
    s1 = diag(sss); % 将前k个奇异值转换为对角矩阵
end

% 定义一个函数，用于处理图像的一个颜色通道
function re = process_channel(a, k)
    [u, s, v] = svd(a); % 对颜色通道进行奇异值分解
    [u1, s1, v1] = svd_compression(u, s, v, k); % 获取前k个奇异值及其对应的左右奇异向量
    re = uint8(u1 * s1 * v1'); % 通过前k个奇异值和对应的左右奇异向量重构颜色通道
end
a=imread('lovely.jpg'); % 读取名为'Cat.jpg'的图像文件，并将其存储在变量a中

k=10; % 设置奇异值的数量，这将决定压缩后的图像质量

[~,~,dim] = size(a); % 获取图像的维度

if dim>1
a=rgb2gray(a); % 如果图像是彩色的（即维度大于1），则将其转换为灰度图像
end

imshow(a); % 显示原始图像
title('原图') ; % 设置图像标题为'原图'

a=double(a); % 将图像数据转换为双精度数据，以进行数学运算
r=rank(a); % 计算图像的秩
[u,s,v]=svd(a); % 对图像进行奇异值分解

u1=u(:,1:k); % 获取前k个左奇异向量
v1=v(:,1:k); % 获取前k个右奇异向量
ss=diag(s); % 获取奇异值向量
sss=ss(1:k); % 获取前k个奇异值
s1=diag(sss); % 将前k个奇异值转换为对角矩阵

re=u1*s1*v1'; % 通过前k个奇异值和对应的左右奇异向量重构图像

re=uint8(re); % 将重构后的图像数据转换为8位无符号整数，以便于显示和保存
figure; % 创建新的图像窗口
imshow(re); % 显示压缩后的图像
title(['图像压缩后，k=',num2str(k)]) ; % 设置图像标题，显示压缩后的奇异值数量

filename = ['lovely_k=', num2str(k), '.jpg']; % 生成与k值相关的文件名
imwrite(re, filename); % 将压缩后的图像保存为生成的文件名



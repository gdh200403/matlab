function Im = seam_carving_resize(width)
    Im=imread('6.jpg');
    figure,imshow(Im);title('Original Image');
    for i = 1:width
        Im = remove_seam(Im);
    end
    figure,imshow(Im);title('Resized Image');
end

function Im = remove_seam(Im)
gauss=fspecial('gaussian',[3,3],2);
% 创建一个3*3的高斯滤波器
Blur=imfilter(Im,gauss,'same');
% 生成模糊后的图像
[m,n,c]=size(Im);
% 获取图像的尺寸信息
Gray=rgb2gray(Im);
%将图像转为灰度图
 
%求梯度图
hy=fspecial('sobel');
hx=hy';
Iy=imfilter(double(Gray),hy,'replicate');
Ix=imfilter(double(Gray),hx,'replicate');
Gradient=sqrt(Ix.^2+Iy.^2);

%归一化
max1=max(max(Gradient)');
Gradient=Gradient./max1;
 
%初始化能量图和路径图
Energy=zeros(m,n);
Path=zeros(m,n);
tmp=0;
for i=1:m
    for j=1:n
        if(i==1)
            Energy(i,j)=Gradient(i,j);
            Path(i,j)=0;
        else
            if(j==1)
                tmp=which_min2(Energy(i-1,j),Energy(i-1,j+1));
                Energy(i,j)=Gradient(i,j)+Energy(i-1,j+tmp);
                Path(i,j)=tmp;
            elseif(j==n)
                tmp=which_min2(Energy(i-1,j-1),Energy(i-1,j));
                Energy(i,j)=Gradient(i,j)+Energy(i-1,j-1+tmp);
                Path(i,j)=tmp-1;
            else
                tmp=which_min3(Energy(i-1,j-1),Energy(i-1,j),Energy(i-1,j+1));
                Energy(i,j)=Gradient(i,j)+Energy(i-1,j-1+tmp);
                Path(i,j)=tmp-1;
            end
        end
    end
end

max2=max(max(Energy)');
Energy=Energy./max2;
%能量最小路径的最后一行的纵坐标

lastCol=find(Energy(m,:)==min(Energy(m,:)));
col=lastCol(1);
%描画出分割线
Line=Im;
for i=m:-1:1
    Line(i,col,:)=[0,255,0];
    col=col+Path(i,col);
end
%消除路径上的点
newIm = zeros(m, n-1, 3, 'like', Im);
for i=m:-1:1
    newIm(i,1:col-1,:) = Im(i,1:col-1,:);
    newIm(i,col:end,:) = Im(i,col+1:end,:);
    col = col + Path(i,col);
end
Im = newIm;
%Gradient是梯度图
%figure,imshow(Gradient);title('Gradient Image');
%Energy是能量图
%figure,imshow(Energy);title('Energy Image');
%Line是标注了分割线的图
%figure,imshow(Line);title('Image with Seam');
%在Im上将分割线切掉
%figure,imshow(Im);title('after Cut Seam');


function tmp = which_min2(x,y)
if(min([x,y])==x)
    tmp=0;
else
    tmp=1;
end
end
    
function tmp=which_min3(x,y,z)
if(min([x,y,z])==y)
    tmp=1;
elseif(min([x,y,z])==x)
    tmp=0;
    else
    tmp=2;
end
end
end
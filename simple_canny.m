clear; close all; clc;

img = imread("test_pic.png");
img_gray = rgb2gray(img); 

subplot(231)
imshow(img_gray);
title("原始图像");
subplot(232)
[qedge, qamp1, qamp2, qamp3] = qcanny(img_gray, 60, 120);
imshow(qedge);
title("自己Canny检测"); 
subplot(233)
imshow(edge(img_gray, "canny"));
title("matlab Canny检测");

subplot(234)
imshow(qamp1)
title("梯度幅值");
subplot(235)
imshow(qamp2)
title("非极大值抑制");
subplot(236)
imshow(qamp3)
title("双边阈值检测");

function [edge, amp1, amp2, amp3] = qcanny(img, th_low, th_high)
    [x_size, y_size] = size(img);
    img = double(img);
%     amp_dir = zeros(x_size, y_size);
    img_amp = zeros(x_size, y_size);
    edge = uint8(zeros(x_size, y_size));
    
    % 求梯度与方向
    for x = 2 : 1 : x_size - 1
        for y = 2 : 1 : y_size - 1
            grad_x = img(x-1, y-1) + 2*img(x-1, y) + img(x-1, y+1) - img(x+1, y-1) - 2*img(x+1, y) - img(x+1, y+1);
            grad_y = img(x-1, y-1) + 2*img(x, y-1) + img(x+1, y-1) - img(x-1, y+1) - 2*img(x, y+1) - img(x+1, y+1);
            img_amp(x, y) = abs(grad_x) + abs(grad_y);
            amp_dir(x, y) = atan_dir(grad_x, grad_y);
        end
    end
    amp1 = uint8(img_amp);
    
    amp_cache = amp1;
    % 非极大值抑制
    for x = 2 : 1 : x_size - 1
        for y = 2 : 1: y_size - 1
            dir = amp_dir(x, y);
            if dir == "LR"
                if (img_amp(x, y) < amp_cache(x+1, y)) || (img_amp(x, y) < amp_cache(x-1, y))
                    img_amp(x, y) = 0;
                end
            elseif dir == "LU"
                if (img_amp(x, y) < amp_cache(x+1, y-1)) || (img_amp(x, y) < amp_cache(x-1, y+1))
                    img_amp(x, y) = 0;
                end
            elseif dir == "UD"
                if (img_amp(x, y) < amp_cache(x, y+1)) || (img_amp(x, y) < amp_cache(x, y-1))
                    img_amp(x, y) = 0;
                end
            elseif dir == "LD"
                if (img_amp(x, y) < amp_cache(x-1, y-1)) || (img_amp(x, y) < amp_cache(x+1, y+1))
                    img_amp(x, y) = 0;
                end
            end
        end
    end
    amp2 = uint8(img_amp);

    % 双边阈值检测
    for x = 1 : 1 : x_size
        for y = 1 : 1: y_size
            if img_amp(x, y) < th_low
                img_amp(x, y) = 0;
            elseif img_amp(x, y) > th_high
                img_amp(x, y) = 255;
            end
        end
    end

    amp3 = uint8(img_amp);
    
    % 边缘连接
    img_cache2 = img_amp;
    for x = 2 : 1 : x_size - 1
        for y = 2 : 1 : y_size - 1
            dir = amp_dir(x,y);
            % 单点消除
            if((sigle_detect(img_cache2, x, y) < 2) && (img_cache2(x, y) ~= 0))
                img_amp(x, y) = 0;
            end

            if(dir == "LR")
                if((img_amp(x, y+1) == 255) || (img_amp(x, y-1) == 255))
                    if(img_amp(x,y) ~= 0)
                        edge(x,y) = 255;
                    end
                end
                if((img_amp(x, y+1) ~= 0) && (img_amp(x, y-1) ~= 0) && (img_amp(x,y) ~= 0))
                    edge(x,y) = 255;
                end
            elseif(dir == "LU")
                if((img_amp(x-1, y-1) == 255) || (img_amp(x+1, y+1) == 255))
                    if(img_amp(x,y) ~= 0)
                        edge(x,y) = 255;
                    end
                end
                if((img_amp(x-1, y-1) ~= 0) && (img_amp(x+1, y+1) ~= 0) && (img_amp(x,y) ~= 0))
                    edge(x,y) = 255;
                end
            elseif(dir == "UD")
                if((img_amp(x-1, y) == 255) || (img_amp(x+1, y) == 255))
                    if(img_amp(x,y) ~= 0)
                        edge(x,y) = 255;
                    end
                end
                if((img_amp(x-1, y) ~= 0) && (img_amp(x+1, y) ~= 0) && (img_amp(x,y) ~= 0))
                    edge(x,y) = 255;
                end
            elseif(dir == "LD")
                if((img_amp(x+1, y-1) == 255) || (img_amp(x-1, y+1) == 255))
                    if(img_amp(x,y) ~= 0)
                        edge(x,y) = 255;
                    end
                end
                if((img_amp(x+1, y-1) ~= 0) && (img_amp(x-1, y+1) ~= 0) && (img_amp(x,y) ~= 0))
                    edge(x,y) = 255;
                end
            end
        end
    end
end

function num = sigle_detect(img, x, y)
    num = 0;
    if(img(x-1, y-1) > 0)
        num = num + 1;
    end
    if(img(x, y-1) > 0)
        num = num + 1;
    end
    if(img(x+1, y-1) > 0)
        num = num + 1;
    end
    if(img(x-1, y) > 0)
        num = num + 1;
    end
    if(img(x+1, y) > 0)
        num = num + 1;
    end
    if(img(x-1, y+1) > 0)
        num = num + 1;
    end
    if(img(x, y+1) > 0)
        num = num + 1;
    end
    if(img(x+1, y-1) > 0)
        num = num + 1;
    end
end

function dir = atan_dir(x, y)
    atan = y/x;
    if atan > -0.41421365 && atan <= 0.41421356
		dir = "LR"; % 水平方向
    elseif atan <= -0.41421356 && atan > -2.41421356
		dir = "LU"; % 右上、左下
    elseif atan > 0.41421356 && atan < 2.41421362
		dir = "LD"; % 左上、右下
    else
		dir = "UD"; % 竖直方向
    end
end

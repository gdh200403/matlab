%   Copyright 漏 2024, Renjie Chen @ USTC


%% read image
im = imread('peppers.png');

%% draw 2 copies of the image
fig=figure('Units', 'pixel', 'Position', [100,100,1000,700], 'toolbar', 'none');
subplot(121); imshow(im); title({'Input image'});
subplot(122); himg = imshow(im*0); title({'Resized Image', 'Use the blue button to resize the input image'});
hToolResize = uipushtool('CData', reshape(repmat([0 0 1], 100, 1), [10 10 3]), 'TooltipString', 'apply seam carving method to resize image', ...
                        'ClickedCallback', @(~, ~) set(himg, 'cdata', seam_carve_image(im, size(im,1:2)-[0 300])));

%% TODO: implement function: searm_carve_image
% check the title above the image for how to use the user-interface to resize the input image
function im = seam_carve_image(im, sz)
    costfunction = @(im) sum( imfilter(im, [.5 1 .5; 1 -6 1; .5 1 .5]).^2, 3 );

    k = size(im,2) - sz(2);
    for i = 1:k
        G = costfunction(im);
        % find a seam in G
        S = find_seam(G);
        % remove seam from im
        im = remove_seam(im, S);
    end
end

function S = find_seam(G)
    [rows, cols] = size(G);
    M = zeros(size(G));
    M(1, :) = G(1, :);
    for i = 2:rows
        for j = 1:cols
            if j == 1
                M(i, j) = G(i, j) + min(M(i-1, 1:2));
            elseif j == cols
                M(i, j) = G(i, j) + min(M(i-1, cols-1:cols));
            else
                M(i, j) = G(i, j) + min(M(i-1, j-1:j+1));
            end
        end
    end
    S = zeros(1, rows);
    [~, S(rows)] = min(M(rows, :));
    for i = rows-1:-1:1
        if S(i+1) == 1
            [~, idx] = min(M(i, 1:2));
            S(i) = idx;
        elseif S(i+1) == cols
            [~, idx] = min(M(i, cols-1:cols));
            S(i) = idx + cols - 2;
        else
            [~, idx] = min(M(i, S(i+1)-1:S(i+1)+1));
            S(i) = idx + S(i+1) - 2;
        end
    end
end

function im = remove_seam(im, S)
    [rows, cols, ~] = size(im);
    new_im = zeros(rows, cols-1, 3);
    for i = 1:rows
        new_im(i, :, :) = [im(i, 1:S(i)-1, :), im(i, S(i)+1:end, :)];
    end
    im = uint8(new_im);
end
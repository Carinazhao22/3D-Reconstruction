clear all ;
close all;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

[rows,cols]=size(im1);
[im1, im2, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

im1=im1(end-rows+1:end,end-cols+1:end);
im2=im2(1:rows,1:cols);
 
maxDisp = 20; 
windowSize = 3;
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
title('DispMap after Rectify');
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
title('DepthMap after Rectify');
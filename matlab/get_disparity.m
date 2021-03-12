function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

% reference from https://www.mathworks.com/matlabcentral/answers/523105-double-summation-of-a-matrix
% reference from https://www.mathworks.com/matlabcentral/answers/263274-move-a-columns-to-the-right
[rows,cols]=size(im1);
mask=ones(windowSize,windowSize);
img1=conv2(im1,mask,'same');
img2_store=ones(rows,cols,maxDisp+1);

for disp=0:maxDisp
    img2=circshift(im2,disp,2);
    img2_store(:,:,disp+1)=(img1-conv2(img2,mask,'same')).^2;
end

[~,idx]=min(img2_store,[],3);
dispM=reshape(idx-1,size(im1));

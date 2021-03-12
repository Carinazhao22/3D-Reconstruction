function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
w=10;
cols=size(im2,2);
cw=cols-2*w;
points=ones(cw,2);
points(:,1)=(w+1:cols-w);
pts2=ones(size(pts1));
 
 
for i =1:size(pts1,1)

    line=F*[pts1(i,:) 1]'; 
   
    for x =1:cw
        y=round(-(line(1)*x+line(3))/line(2));
        points(x,2)=y;
    end
    
    
    window1=double(im1((pts1(i,2)-w):(pts1(i,2)+w),(pts1(i,1)-w):(pts1(i,1)+w)));
    dist=[];
    for j=1:size(points,1)
        window2=double(im2((points(j,2)-w):(points(j,2)+w),(points(j,1)-w):(points(j,1)+w)));
        d=norm(window2-window1);
        dist=[dist,d];
    end
    [~,idx]=min(dist);
    pts2(i,:)=points(idx,:);
end

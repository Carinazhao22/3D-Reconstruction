function [pts3d,count] = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
s=size(pts1,1);
pts3d=ones(s,4);
count=0;
for idx=1:s
    A=[pts1(idx,2)*P1(3,:)-P1(2,:);
       P1(1,:)-pts1(idx,1)*P1(3,:);
       pts2(idx,2)*P2(3,:)-P2(2,:);
       P2(1,:)-pts2(idx,1)*P2(3,:)];
       [~,~,v]=svd(A);
       
       pts3d(idx,:) = v(:,end)';
       pts3d(idx,:) = pts3d(idx,:)/ pts3d(idx,4);
end

% re-projection error
err1=0; err2=0;
for idx=1:s
    x1=pts3d(idx,:)*P1'; 
    if x1(3)>0
        count=count+1;
    end
    x1=x1/x1(3);
    x2=pts3d(idx,:)*P2'; 
    if x2(3)>0
        count=count+1;
    end
    x2=x2/x2(3);
    err1=err1+norm(pts1(idx,:)-x1(1:2));
    err2=err2+norm(pts2(idx,:)-x2(1:2));    
end
err1=err1/s;
err2=err2/s;
fprintf('mean Euclidean error in img1 is: %.2f.\n',err1);
fprintf('mean Euclidean error in img2 is: %.2f.\n',err2);
pts3d = pts3d(:, 1:3);
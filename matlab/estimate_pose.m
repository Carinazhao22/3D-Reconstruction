function [P] = estimate_pose(x, X)
% x: (2,N) X: (3,N) CM (3,4)
A=[];
X=[X;ones(1,size(X,2))];
for idx =1:size(X,2)
     
     A=[A;-X(:,idx)',0,0,0,0,x(1,idx)*X(:,idx)';...
        0,0,0,0,-X(:,idx)',x(2,idx)*X(:,idx)'];
end

[~,~,V]=svd(A);
P=reshape(V(:,end),[4,3])';

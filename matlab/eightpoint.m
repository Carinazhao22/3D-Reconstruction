function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
%% scale data
p1=pts1/M;
p2=pts2/M;

A=[];

for i=1:size(p1,1)
    A=[A;p2(i,1)*p1(i,1), p2(i,1)*p1(i,2),p2(i,1),p2(i,2)*p1(i,1), ...
        p2(i,2)*p1(i,2),p2(i,2),p1(i,1),p1(i,2),1];
end

[~,~,V]=svd(A);

F=reshape(V(:,end),[3,3])';
[U,S,V]=svd(F);
S(3,3)=0;
F=U*S*V';
F = refineF(F,p1,p2);

T=[1/M,0,0;
    0 , 1/M, 0
    0,  0, 1];
F=T*F*T;
end


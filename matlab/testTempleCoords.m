% A test script using templeCoords.mat
%
% Write your code here
%
clear;clc;
I1=imread('../data/im1.png');
I2=imread('../data/im2.png');
%% test 3.1.1
someCoor=load('../data/someCorresp.mat');
F=eightpoint(someCoor.pts1,someCoor.pts2,someCoor.M);
disp(F);
% displayEpipolarF(I1,I2,F);

%% test 3.1.2
temple=load('../data/templeCoords.mat');
estimated_pts2=epipolarCorrespondence(I1, I2, F, temple.pts1);
% figure;
% showMatchedFeatures(I1, I2, temple.pts1, pts2, 'montage');
% [coordsIM1, coordsIM2] = epipolarMatchGUI(I1, I2, F);

%% test 3.1.3
intr=load('../data/intrinsics.mat');
E=essentialMatrix(F, intr.K1, intr.K2);
disp(E);

%% test 3.1.4
% P=K[R T]
R1=eye(3);
t1=zeros(3,1);
P1=intr.K1*[R1,t1];


% 4 candidates extrinsic matrices;
M2s = camera2(E);
best=0; idx=0;
disp('re-produce error for pt1 from templeCoords.mat and computed pt2');
for i=1:size(M2s,3)
    fprintf('Candiates %d\n',i);
    [~,count] = triangulate(P1, temple.pts1,intr.K2*M2s(:,:,i), estimated_pts2);
    if count>best
        best=count;
        idx=i;
    end
end
%%
fprintf('The number of positive depth of best candidate is %d\n',best);
best=M2s(:,:,idx);
R2=best(1:3,1:3);
t2=best(:,end);
P2=intr.K2*best;
fprintf('The best candidate is %d\n',idx);
%%
% disp('re-produce error for pt1,pt2 from someCoords.mat and use the best candidate P2');
% [pts3d,~] = triangulate(P1,someCoor.pts1,P2,someCoor.pts2);
%%
[pts3d,~] = triangulate(P1,temple.pts1,P2,estimated_pts2);
figure;
plot3(pts3d(:,1),pts3d(:,2),pts3d(:,3),'.', 'MarkerSize',8);
grid on; 
axis equal;
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');

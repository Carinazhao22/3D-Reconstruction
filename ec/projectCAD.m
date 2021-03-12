clear all;
close all;
clc;
%% load data and estimate params

data=load('../data/PnP.mat', 'cad', 'image', 'x', 'X');
P = estimate_pose(data.x, data.X);
[K, R, t] = estimate_params(P);
X=[data.X;ones(1,size(data.X,2))];
x=P*X;
x=x(1:2,:)./x(end,:);
%% plot1

figure;
imshow(data.image);
hold on;
plot(data.x(1,:), data.x(2,:), 'go','MarkerSize', 15);
hold on;
plot(x(1, :), x(2, :), 'black.','MarkerSize', 15);
hold off;
%% plot2

CAD=data.cad;
vertices=CAD.vertices;
vertices=vertices*R'+t';

figure;
trimesh(CAD.faces,vertices(:,1),vertices(:,2),vertices(:,3),'edgecolor','b');
%% plot3
vertices=CAD.vertices';
X=[vertices;ones(1,size(CAD.vertices,1))];
x=P*X;
x=x(1:2,:)./x(end,:);

figure;
imshow(data.image);
hold on;
patch('Faces',CAD.faces,'Vertices',x','FaceColor','r','EdgeColor','none','FaceAlpha',0.22);


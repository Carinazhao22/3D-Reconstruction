function [K,R,t]=estimate_params(P)

% reference from https://math.stackexchange.com/questions/1640695/rq-decomposition
M=P(:,1:3);
[~,~,v]=svd(P);
c=v(:,end);
c=c(1:3)./c(end);

I=[0,0,1;
   0,1,0;
   1,0,0];
 
% reverse rows or columns
M=I*M;
[R, K] = qr(M');
R=I*R';
K=I*K'*I;
% reference from https://www.uio.no/studier/emner/matnat/its/nedlagte-emner/UNIK4690/v17/forelesninger/lecture_5_2_pose_from_known_3d_points.pdf
% K and R should have positive diagonal  
T = diag(sign(diag(K)));
K = K * T;
R = T * R;

if det(R)<0
    R=-R;
end
t = -R * c;

end
 
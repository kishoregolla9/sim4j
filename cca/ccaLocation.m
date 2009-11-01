function [C_delta,T,D_dist_mean,D_coordinates_mean,D_coordinates_median]=ccaLocation(Network,epochs,option,r,anchor)
%ccaLocation function applies CCA to compute the coordinates of the nodes 
%in a given network for the required number of tranining cycles. It is a
%centralized algorithm.
%The given network's distance matrix is computed by ccaLocation. 
% Network - input network of nodes
% epochs - required number of training cycles
% option -0/1/2 (connectivity only/knowing local distance/knowing the
% entire distance matrix)
% r -radius of range
% anchor - anchor nodes used for translation
% Output:
% T - elapsed time for CCA computation
% C_delta - difference of C_tranform from real coordinates. C_tranform is the 
% the resulting node coordinates in 2D
% D_dist_mean - the sum of the mean error between the orginal distance matrix of the input
% 'Network' and the distance matrix computed from the resulted node
% coordinates
% D_coordinates_mean - the mean error between the coordinates of the input
% 'Network' and the resulted node coordinates
% D_coordinates_median - the median error between the coordinates of the input
% 'Network' and the resulted node coordinates
D_matrix=sqrt(disteusq(Network,Network,'x')); %the real distance matrix
N=size(Network,1);
if (option==0) %knowing only connectivity. Use the matrix of hop matrix
    for i=1:N
        for j=1:N
            if (D_matrix(i,j)<r)
                D_hopCount(i,j)=1;
            else
                D_hopCount(i,j)=2*N;
            end
        end
    end %get prepared to compute the shortest hop matrix for D

    for k=1:N
        D_hopCount = min(D_hopCount,repmat(D_hopCount(:,k),[1 N])+repmat(D_hopCount(k,:),[N 1])); 
    end %compute the shortest hop matrix using Floyed algorithm
    D=D_hopCount;
end
if (option==1)%knowing local distance with 5% measurement error
    for i=1:N
        for j=1:N
            if D_matrix(i,j)<r
                D_hopDist(i,j)=D_matrix(i,j);
            else
            D_hopDist(i,j)=2*N*r;
            end
        end
    end %get prepared to compute the shortest distance matrix for D

    for k=1:N
        D_hopDist = min(D_hopDist,repmat(D_hopDist(:,k),[1 N])+repmat(D_hopDist(k,:),[N 1])); 
    end %compute the shortest distance matrix using Floyed algorithm
    tmp = 0.05*(randn(size(D_hopDist))); %added 5% error of normal distribution
    D=D_hopDist.*(1+tmp);
end
if(option==2)%if knowing the ditance between every pair of nodes with 5% error
%     tmp = 0.05*(randn(size(D_matrix))); %added 5% error of normal distribution
%     D=D_matrix.*(1+tmp);
    D=D_matrix; 
end
tic;
% C_m=cca_vec(D,2,epochs,D); %used to test cca_vec function
% C=C_m(201:400,:);
C=cca(D,2,epochs,D); %doing cca reduction
T=toc;
N=size(Network,1);
%N1=4;
% N2=int16(N/3);
% N3=int16(N*2/3+3);
% %N2=75;
% N2=75;
% N3=165; %select anchor nodes here. minimum three needed.

Number_anchors=size(anchor,2);
    for i=1:Number_anchors
        Y(i,:)=(C(anchor(i),:))';
        X(i,:)=(Network(anchor(i),:))';
    end
% X1=C(N1,:)';
% X2=C(N2,:)';
% X3=C(N3,:)';
% Y1=Network(N1,:)';
% Y2=Network(N2,:)';
% Y3=Network(N3,:)';
% tic;
% [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);
% C_transform=(Z*C'+Cx)';

% Y(1,:)=C(N1,:);
% Y(2,:)=C(N2,:);
% Y(3,:)=C(N3,:);
% %Y(4,:)=C(N4,:);
% X(1,:)=Network(N1,:);
% X(2,:)=Network(N2,:);
% X(3,:)=Network(N3,:);
%X(4,:)=Network(N4,:);
[d, Z, transform] = procrustes(X, Y);
Cx=transform.c;
for i=1:(N-size(transform.c,1))
      Cx=[Cx;transform.c(1,:)];
end
C_transform=transform.b*C*transform.T+Cx;

    
% T=toc
%T=T1+T2;
D_C = sqrt(disteusq(C,C,'x'));
D_dist_mean = mean((mean(abs(D_C-D)))');
D_coordinates_mean=mean(abs(C_transform-Network));
D_coordinates_median=median(abs(C_transform-Network));
C_delta=C_transform - Network;

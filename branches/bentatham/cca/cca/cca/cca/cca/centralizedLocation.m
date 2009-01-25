function [C_delta,T,D_dist_mean,D_coordinates_mean,D_coordinates_median]=centralizedLocation(Network,epochs,option,m,r,anchor)

% Network - input network of nodes
% epochs - required number of training cycles
% option -0/1/2 (connectivity only/knowing local distance/knowing the
% entire distance matrix)
% m - methods, 1/2 (cca/mds)
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
if(option==2)%if knowing the ditance between every pair of nodes 
%     tmp = 0.05*(randn(size(D_matrix))); %can added 5% error of normal distribution
%     D=D_matrix.*(1+tmp); %code need to change to make a symmetric matrix
    D=D_matrix; 
end

tic;
if m==2 %mds scaling
    
% 	[rawResult,eigvals] = mdscale(distMatrix,2); % li change this into the
% 	next line
    [rawResult,eigvals] = mdscale(D); %added by li for code walkthrough
    C = rawResult(:,1:2);
    T=toc;
end
if m==1 %cca mapping
    C=cca(D,2,epochs,D); %doing cca reduction
    T=toc;
end

N=size(Network,1);

Number_anchors=size(anchor,2);
    for i=1:Number_anchors
        Y(i,:)=(C(anchor(i),:))';
        X(i,:)=(Network(anchor(i),:))';
    end

[d, Z, transform] = procrustes(X, Y);
Cx=transform.c;
for i=1:(N-size(transform.c,1))
      Cx=[Cx;transform.c(1,:)];
end
C_transform=transform.b*C*transform.T+Cx;

D_C = sqrt(disteusq(C,C,'x'));
D_dist_mean = mean((mean(abs(D_C-D)))');
D_coordinates_mean=mean(abs(C_transform-Network));
D_coordinates_median=median(abs(C_transform-Network));
C_delta=C_transform - Network;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y,e] = mdscale(distMatrix)

[N tmp] = size(distMatrix);
D = distMatrix.^2;
opt.disp = 0; 
[V, E] = eigs(-.5*(D - sum(D)'*ones(1,N)/N - ones(N,1)*sum(D)/N + sum(sum(D))/(N^2)), 3, 'LR', opt); 

[e i] = sort(real(diag(E))); e = flipud(e); i = flipud(i); % sort descending
keep = find(e > eps^(3/4)*max(abs(e))); % keep only positive e-vals (beyond roundoff)
if isempty(keep)
    Y = zeros(n,1);
else
    Y = V(:,i(keep)) * diag(sqrt(e(keep)));
end
  
function [D_hopDist, connectivity]=createDistanceMatrix(network,radioRadius)

% N=size(network,1);
D=network.distanceMatrix;
%D=sqrt(disteusq(network,network,'x'));
N=size(D,1);
D_hopDist=zeros(N);
for i=1:N
    for j=1:N
        if D(i,j)<radioRadius
            D_hopDist(i,j)=D(i,j);
        else
            D_hopDist(i,j)=2*N*radioRadius;
        end
    end
end %get prepared to compute the shortest distance matrix for D

for k=1:N
    D_hopDist = min(D_hopDist,repmat(D_hopDist(:,k),[1 N])+repmat(D_hopDist(k,:),[N 1])); 
end %compute the shortest distance matrix using Floyd algorithm

connectivity=zeros(N);
for i=1:N
    for j=1:N
        if (D(i,j)<radioRadius) 
            connectivity(i,j)=1;
        else
            connectivity(i,j)=0;
        end
    end
end
% [node,connectivity_level]=neighborMap(network,radioRadius);


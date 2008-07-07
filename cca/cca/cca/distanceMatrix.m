function [D_hopDist, Connectivity]=distanceMatrix(Network,r)

% N=size(Network,1);
D=sqrt(disteusq(Network,Network,'x'));

radioRadius=r;
N=size(D,1);
for i=1:N
    for j=1:N
        if D(i,j)<r
            D_hopDist(i,j)=D(i,j);
        else
            D_hopDist(i,j)=2*N*r;
        end
    end
end %get prepared to compute the shortest distance matrix for D

for k=1:N
    D_hopDist = min(D_hopDist,repmat(D_hopDist(:,k),[1 N])+repmat(D_hopDist(k,:),[N 1])); 
end %compute the shortest distance matrix using Floyed algorithm

for i=1:N
    for j=1:N
        if (D(i,j)<r) Connectivity(i,j)=1;
        else Connectivity(i,j)=0;
        end
    end
end
% [node,connectivity_level]=network_neighborMap(Network,r);


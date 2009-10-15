function [node_index]=find_neighbors(distanceMatrix,radius,i,k)
% Input:
%   distanceMatrix
%   radius
%   i: the node index to generate list of neighbors for
%   k: multiplicative factor for the radius
% Output:
%   a list that includes the nodes j such that distanceMatrix(i,j) <= k*r.
%
node_count=0;
N=size(distanceMatrix,1);
% node_index=zeros(N,1);
for r=1:size(radius,1)
    for j=1:N
        %look for all the nodes that are within distance k*radius
        if distanceMatrix(i,j) <= k * radius(r)
            node_count = node_count+1;  % count the number of selected nodes
            node_index(node_count)=j;   % save the original index of the selected node
        end
        %The saved node_index is in ascending order
    end
end

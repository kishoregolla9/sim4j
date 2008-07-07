function [node,connectivity_level]=network_neighborMap(Network,r)
%network_neighborMap function generates for each of the
%node in the Network its neighborhood given radius 'r'. 

N=size(Network,1);
D=sqrt(disteusq(Network,Network,'x'));
for i=1:N %compute all the local maps
%get node_i's neighbor nodes within r;
[node(i).nh]=find_nh(D,r,i,1);
end
count=0;
for i=1:N
    count=count+size(node(i).nh,2)-1;
end

connectivity_level=count/N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [node_index]=find_nh(D,r,i,k)
%localDist(D,r) takes a distance matrix D and range r to generate for  
%node 'i' 0<i<size(D) a list that includes the nodes j such that D(i,j)<=kr. 
 
node_count=0;
for j=1:size(D)
    if D(i,j)<=k*r %look for all the nodes that is within distance k*r 
        node_count=node_count+1; %count the number of selected nodes
        node_index(node_count)=j; %save the original index of the selected node
    end
    %The saved node_index is in ascending order
end

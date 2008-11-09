function [node,connectivity_level]=network_neighborMap(network,radius)
  %network_neighborMap function generates for each of the
  %node in the network its neighborhood given radius 'radius'. 

  numberOfNodes=network.numberOfNodes;
  if ( isstruct(network) && isfield(network,'distanceMatrix') )
      distanceMatrix=network.distanceMatrix;
  else
      distanceMatrix=sqrt(disteusq(network.nodes,network.nodes,'x'));
      network.distanceMatrix=distanceMatrix;
  end

  %preallocate node array
  node=repmat(struct('neighbors',zeros(5)),numberOfNodes,1);
  for i=1:numberOfNodes %compute all the local maps
    %get node_i's neighbor nodes within radius;
    [node(i).neighbors]=find_neighbors(distanceMatrix,radius,i,1);
  end
  
  count=0;
  for i=1:numberOfNodes
    count=count+size(node(i).neighbors,2)-1;
  end
  
  connectivity_level=count/numberOfNodes;
  network.neighbors=node;
  network.connectivity_level=connectivity_level;
  
% @param i node index to calculate neighbors for
% @param k 
% @return for node i, a list that includes the nodes j such that
%   distanceMatrix(i,j)<=kr
function [node_index]=find_neighbors(distanceMatrix,radius,i,k)
  node_count=0;
  sizeOfDistanceMatrix=size(distanceMatrix,1);
  node_index=zeros(sizeOfDistanceMatrix,1);
  for j=1:sizeOfDistanceMatrix
    %look for all the nodes that is within distance k*radius 
    if distanceMatrix(i,j) <= k * radius 
        node_count = node_count+1;  % count the number of selected nodes
        node_index(node_count)=j;   % save the original index of the selected node
    end
    %The saved node_index is in ascending order
  end

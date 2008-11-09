function [disconnect]=NetworkConnectivityCheck(network,radius,doPlot)

%Given a network and a radius, this function plots the connectivity of the
%network.

% distanceMatrix=sqrt(disteusq(network,network,'x'));
if ( isstruct(network) && isfield(network,'distanceMatrix') )
    distanceMatrix=network.distanceMatrix;
else
    distanceMatrix=sqrt(disteusq(network.nodes,network.nodes,'x'));
    network.distanceMatrix=distanceMatrix;
end

numberOfNodes=network.numberOfNodes;
connectivity = zeros(numberOfNodes);
for i = 1:numberOfNodes
    for j = 1:numberOfNodes
        if (distanceMatrix(i,j) < radius) 
            connectivity(i,j)=1;
        else
            connectivity(i,j)=0;
        end
    end
end

disconnect=0;

% get prepared to compute the shortest hop matrix for distanceMatrix
D_hopCount=zeros(numberOfNodes);
for i=1:numberOfNodes
    for j=1:numberOfNodes
        if distanceMatrix(i,j) < radius
            D_hopCount(i,j)=1;
        else
            D_hopCount(i,j)=2*numberOfNodes;
        end
    end
end  

% compute the shortest hop matrix using Floyd algorithm
for k=1:numberOfNodes
    D_hopCount = min(D_hopCount,repmat(D_hopCount(:,k),[1 numberOfNodes])+repmat(D_hopCount(k,:),[numberOfNodes 1])); 
end 

for i=1:numberOfNodes
    for j=i:numberOfNodes
        if (D_hopCount(i,j)==2*numberOfNodes)
            disconnect=1;
            break;
        end
    end
end

if (disconnect==1)
  fprintf(2,'network not connected\n');
end

if (disconnect==1 || doPlot==true)
  % plot the network connectivity if needed  
  gplot(connectivity, network.nodes,'-d');
end

network.connectivity=connectivity;

            

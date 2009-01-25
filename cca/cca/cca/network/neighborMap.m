function [network]=neighborMap(network,radius)
% Input:
%   network structure
%   radius: list of radius to calculate for
% Output:
%   nodes: structure
%       .neighbors: a list of neighbor coordinates
%   connectivity_level

D=sqrt(disteusq(network.points,network.points,'x'));
N=size(D,1);

if ( isstruct(network) && isfield(network,'nodes') )
    nodes=network.nodes;
    networkConnectivityLevel=network.networkConnectivityLevel;
else
    %preallocate nodes array
    nodes=repmat(struct('neighbors',zeros(5)),N,1);
    networkConnectivityLevel=0;
    for i=1:N %compute all the local maps
        %get node_i's neighbor nodes within radius;
        [nodes(i).neighbors]=find_neighbors(D,radius,i,1);
        networkConnectivityLevel=networkConnectivityLevel+size(nodes(i).neighbors,2)-1;
    end
    networkConnectivityLevel=networkConnectivityLevel/N;
    fprintf(1,'Network Connectivity Level: %f\n', networkConnectivityLevel);
    network.nodes=nodes;
end

shortestDistanceMatrix=zeros(N,2);
shortestHopMatrix=zeros(N);
for i=1:N
    for j=1:N
        if D(i,j) < radius
            shortestDistanceMatrix(i,j)=D(i,j);
            shortestHopMatrix(i,j)=1;
        else
            shortestDistanceMatrix(i,j)=2*N*radius;
            shortestHopMatrix(i,j)=2*N;
        end
        if(i==j)
            shortestHopMatrix(i,j)=0;
        end        
    end
end %get prepared to compute the shortest distance & hop matrices for D

count=0; % for connectivity_level
connectivity=zeros(N);
for i=1:N
    count=count+size(nodes(i).neighbors,2)-1;

    %compute the shortest distance matrix using Floyd algorithm
    shortestDistanceMatrix = min(shortestDistanceMatrix,...
        repmat(shortestDistanceMatrix(:,i),...
        [1 N])+repmat(shortestDistanceMatrix(i,:),[N 1]));

    %compute the shortest hop matrix using Floyd algorithm
    shortestHopMatrix = min(shortestHopMatrix,...
        repmat(shortestHopMatrix(:,i),...
        [1 N])+repmat(shortestHopMatrix(i,:),[N 1]));
    
    for j=1:N
        if (D(i,j) < radius)
            connectivity(i,j)=1;
        else
            connectivity(i,j)=0;
        end
    end
end

connectivity_level=count/N;
network.connectivity_level=connectivity_level;
network.nodes=nodes;
network.connectivity=connectivity;
network.distanceMatrix=D;
network.shortestDistanceMatrix=shortestDistanceMatrix;
network.shortestHopMatrix=shortestHopMatrix;
network.networkConnectivityLevel=networkConnectivityLevel;
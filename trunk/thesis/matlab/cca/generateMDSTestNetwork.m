function [t,anchor]=generateMDSTestNetwork(type,s,N,CL)
%This function generates t for a network of type, size and node number N.
%Each t(i) holds a set of parameters given the radius in CL(i). t(i) can be
%used as the input for MDSSolver2 and ccaMap or ccaMapVec.
%CL - holds the radio radius values in an ascending order.
%type - 0/1/2/3 (random uniform/grid uniform with 10% average placement 
%errors/C-shape random/C-shape grid)
%s - edge size of a square area for deployment. e.g., if size=r, then
%the deployment area is rxr.
%anchor - holds a set of 3 anchor nodes randomly selected from the network
%that assume various different confugrations among the nodes

disconnect=1;

for ii=1:100
    [network]=netDeployment(type,s,N);
    [disconnect]= NetworkConnectivityCheck(network,CL(1));
    if (disconnect==0) 
        break;
    end
end %for

if (disconnect==1) 
    fprintf(2,'cannot generate a connected network in 100 tries\n');
    return;
end

[anchor]=anchorNodesSelectionSquare100(network);

ss=size(CL,2);

for ii=1:ss
    [node,connectivityLevel]=network_neighborMap(network,CL(ii));
%     CL(2,i)=cl;
    t(ii).radioRadius=CL(1,ii);
    t(ii).xy=network;
    t(ii).connectivityLevel=connectivityLevel;
    [t(ii).distanceMatrix, t(ii).connectivityMatrix]=distanceMatrix(t(ii).xy,CL(ii));
    t(ii).anchorNodes=anchor(1,:);
end

plot(network(:,1),network(:,2),'bo'); %draw the network 

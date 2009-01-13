function [t]=prepareMDSTestNetwork(network,CL,option)
%Li - Mar 2007; Modified April 2007
%This function prepare input network t for its parameters so that the 
%output t can be used in t=MDSSolver2(t).
%Input "network" - Nx2 matrix holds the network.
%CL - holds the radio radius values in an ascending order.
%Each output t(i) holds a set of parameters given the radius in CL(i). t(i) can be
%used as the input for MDSSolver2 and ccaMap or ccaMapVec, after assign it
%with t.anchorNodes field.
%option: 1/0 - range based/range free. 


% [anchor]=anchorNodesSelectionCshape100(network,1,3); %need to change this line for different networks

ss=size(CL,2);

for ii=1:ss
    t(ii).xy=network;
    [node,connectivityLevel]=neighborMap(network,CL(1,ii));
%     CL(2,i)=cl;
    t(ii).radioRadius=CL(1,ii);
    t(ii).xy=network;
    t(ii).connectivityLevel=connectivityLevel;
    [t(ii).distanceMatrix, t(ii).connectivityMatrix]=distanceMatrix(t(ii).xy,CL(1,ii));
%     t(ii).anchorNodes=anchor(5,:);
    t(ii).PMDS=2; %need to change this if use other MDS
    t(ii).rangeBased=option;
end


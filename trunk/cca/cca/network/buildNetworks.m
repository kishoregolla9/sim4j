function [ networks ] = buildNetworks( sourceNetwork, radii, numSteps,  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1 : numSteps+1
    % Build and check the network
    radius=radii(i);
    fprintf(1,'Radius: %.1f\n', radius);

    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end

    if ~exist('networks','var')
        % preallocate
        networks(numSteps+1)=struct(network);
    end
    networks(i)=network;
    
    plotNetwork(network,zeros(0),folder);
    close all
    
    clear network;
end

end


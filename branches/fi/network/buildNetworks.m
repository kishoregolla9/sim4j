function [ networks ] = buildNetworks( sourceNetwork, radii, numRadii, folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1 : numRadii
    % Build and check the network
    radius=radii(i);
    fprintf(1,'Radius: %.1f\n', radius);

    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end

    if ~exist('networks','var')
        % preallocate
        networks(numRadii)=struct(network); %#ok<AGROW>
    end
    networks(i)=network; %#ok<AGROW>
    
%     plotNetwork(network,zeros(0),folder,'');
%     close all;
    
    clear network;
end
close all;
end

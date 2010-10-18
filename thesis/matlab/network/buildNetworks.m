function [ networks ] = buildNetworks( sourceNetwork, radii, numRadii, folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1 : numRadii
    % Build and check the network
    radius=radii(i);
    fprintf(1,'Radius: %.1f\n', radius);

    [network]=checkNetwork(sourceNetwork,radius);
    attempt=1;
    while (~network.connected),
        fprintf(1,'Network not connected -- trying again %i\n',attempt);
        [network]=checkNetwork(sourceNetwork,radius);
        attempt=attempt+1;
    end

    if ~exist('networks','var')
        % preallocate
        networks(numRadii)=struct(network); %#ok<AGROW>
    end
    networks(i)=network; %#ok<AGROW>
    
    h=plotNetwork(network,zeros(0),folder,'');
    filename=sprintf('network-%i',i);
    saveFigure(folder,filename,h);
    close all;
    
    clear network;
end
close all;
end


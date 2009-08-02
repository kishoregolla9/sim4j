function [results]=doMapPatch(networks,allMaps,anchors,folder)

%% Do Map Patching
numSteps=size(networks,2);
for i=1 : size(allMaps,1)
    localMaps=allMaps(i);
    network=networks(i);
    radius=network.radius;
    % Pick nodes from different part of the network.
    % Should form a startNode=[a b c ...] array that contains the 
    % starting node for map patching that want to experiment with.
    % For example,
    %startNode=[5 20 22];
    startNode=20;
    % Also have a startNodeSelection script which may work or may not 
    % work well depending on the network.

    %% Map Patching
    disp('------------------------------------\n')
    patchNumber=sprintf('Map patch #%i of %i for Radius %.1f',i,size(allMaps,1),radius);
    fprintf('Doing %s\n',patchNumber);        
    result=mapPatch(network,localMaps,startNode,anchors,radius,patchNumber);
    fprintf(1,'Done in %f sec for %s\n',result.mapPatchTime,patchNumber);
    
    %% PLOT NETWORK DIFFERENCE
    % plotNetworkDiff(result,anchors,folder);
    % done doMapPatch
      
    if ~exist('results','var')
        % preallocate
        results(size(allMaps,1))=result;
    end
    results(i)=result;
    
    filename=sprintf('%s\\result-%i_%i-%i-%i_%i_%i_%i.mat',folder,i,fix(clock));
    save(filename,'result');
    
    clear result network localMaps;
end
end


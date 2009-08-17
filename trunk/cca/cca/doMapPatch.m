function [results]=doMapPatch(networks,allMaps,anchors,folder)

%% Do Map Patching
for i=1 : size(allMaps,1)
    localMaps=allMaps(i);
    network=networks(i);
    radius=network.radius;
    % Pick nodes from different part of the network.
    % Should form a startNode=[a b c ...] array that contains the 
    % starting node for map patching that want to experiment with.
    % For example,
    %startNodes=[5 20 22];
    startNodes=1:10:size(network.points,1);
    % Also have a startNodeSelection script which may work or may not 
    % work well depending on the network.

    %% Map Patching
    disp('------------------------------------')
    patchNumber=sprintf('Map patch #%i of %i for Radius %.1f',i,size(allMaps,1),radius);
    fprintf('Doing %s\n',patchNumber);        
    result=mapPatch(network,localMaps,startNodes,anchors,radius,patchNumber,folder);
    fprintf(1,'Done in %f sec for %s\n',result.mapPatchTime,patchNumber);
    
    %% PLOT NETWORK DIFFERENCE
    % plotNetworkDiff(result,anchors,folder);
    % done doMapPatch
      
    if ~exist('results','var')
        % preallocate
        results(size(allMaps,1))=result; %#ok<AGROW>
    end
    results(i)=result; %#ok<AGROW>
    
    filename=sprintf('%s\\result-%i_%i-%i-%i_%i_%i_%i.mat',folder,i,fix(clock));
    save(filename,'result');
    
    clear result network localMaps;
end
end


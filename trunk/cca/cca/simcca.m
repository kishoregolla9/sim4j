clear;

%% BuildNetwork
hold off
addpath('cca')
addpath('network')
addpath('plot')

tic;
networkconstants;

minRadius=3.0;
step=1;
numSteps=2;
maxRadius=minRadius+(step*numSteps);

radii=minRadius:step:maxRadius;

clear minRadius maxRadius;

shape=NET.SHAPE_SQUARE;
placement=NET.NODE_RANDOM;
N=324;
networkEdge=18;
ranging=0; % range-free
numAnchors=3;
numAnchorSets=3;

[sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,N);

if exist('folder','var') ~= 1
    folder=sprintf('results\\%i-%i-%i_%i_%i_%i-%s',fix(clock),sourceNetwork.shape);
    mkdir(folder);
end

filename=sprintf('%s\\sourceNetwork.mat',folder);
save(filename, 'sourceNetwork', 'radii');

%% RUNCCA
close(gcf);

[anchors]=buildAnchors(sourceNetwork,NET.ANCHORS_RANDOM,numAnchors,numAnchorSets);
filename=sprintf('%s\\anchors.mat',folder);
save(filename, 'anchors');
allMaps=cell(numSteps+1,1);
%% Make Local Maps
for i=1 : numSteps+1
    
    %% Build and check the network
    radius=radii(i);
    fprintf(1,'Radius: %.1f\n', radius);

    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end

    %% Build Local Maps
    fprintf(1,'Generating local maps for radius %.2f\n',radius);
    localMapStart=tic;
    [localMaps]=localMapComputing(network,radius,ranging);
    fprintf(1,'Done generating local maps for radius %.2f in %f sec\n',radius,toc(localMapStart));
    clear localMapStart;
    if ~exist('networks','var')
        % preallocate
        networks(numSteps+1)=struct(network);
    end
    allMaps(i)=localMaps;
    networks(i)=network;
    
    radius=radii(i);
    clear localMaps network;
end

filename=sprintf('%s\\localMaps.mat',folder);
save(filename, 'allMaps', 'radii');

%% Do Map Patching
for i=1 : numSteps+1
    
    localMaps=allMaps(i);
    network=networks(i);
    
    % Pick nodes from different part of the network.
    % Should form a startNode=[a b c ...] array that contains the 
    % starting node for map patching that want to experiment with.
    % For example,
    startNode=[5 20 22];
    % Also have a startNodeSelection script which may work or may not 
    % work well depending on the network.

    % pick 2 more anchor sets: best and worst set of localMaps
    %myAnchors=[anchors;getBestAndWorstLocalMaps(localMaps)];
    [network,result]=doMapPatch(network,radius,localMaps,startNode,anchors,folder);
    if ~exist('results','var')
        % preallocate
        results(numSteps+1)=result;
    end
    results(i)=result;
    clear result network localMaps;
end

%% PLOT RESULT
filename=sprintf('%s\\cca_results_%i-%i-%i_%i_%i_%i.mat',folder,fix(clock));
save(filename,'results');
plotResult(results,anchors,radii,folder);
totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N))

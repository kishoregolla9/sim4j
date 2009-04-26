clear;

%% BuildNetwork
hold off
addpath('cca')
addpath('network')
addpath('plot')

tic;
networkconstants;

minRadius=2.5;
step=0.5;
numSteps=1;
maxRadius=minRadius+(step*numSteps);

radii=minRadius:step:maxRadius;

shape=SHAPE_SQUARE;
placement=NODE_RANDOM;
N=25;
networkEdge=5;
ranging=0; % range-free
numAnchors=3;
numAnchorSets=3;

[sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,N);
[anchors]=buildAnchors(sourceNetwork,ANCHORS_SPREAD,numAnchors,numAnchorSets);

if exist('folder','var') ~= 1
    folder=sprintf('results\\%i-%i-%i_%i_%i_%i-%s',fix(clock),sourceNetwork.shape);
    mkdir(folder);
end

%% RUNCCA
close(gcf);
for i=1 : numSteps+1
    
    %% Build and check the network
    radius=radii(i);
    fprintf(1,'Radius: %.1f\n', radius);

    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end
    network.anchors=anchors;
    plotNetwork(network,folder);
    
    %to pick nodes from different part of the network. Should form a startNode=[a b c ...] array that
    %contains the starting node for map patching that want to experiment with.
    %For example,
    startNode=[5 20 22];
    % Also have a startNodeSelection script which may work or may not work well depending on the network.

    %% Build Local Maps
    fprintf(1,'Generating local maps for radius %.2f\n',radius);
    localMapStart=tic;
    [localMaps,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,radius,ranging);
    fprintf(1,'Done generating local maps for radius %.2f in %f sec\n',radius,toc(localMapStart));

    %% Map Patching
    disp('------------------------------------')
    fprintf(1,'Doing Map Patch for radius %.1f\n',radius);
    startMapPatch=tic;
    [results(i)]=mapPatch(network,localMaps,startNode,anchors,radius);
    fprintf(1,'Done Map Patch in %f sec for radius %.1f\n',toc(startMapPatch),radius);
    
    %% PLOT NETWORK DIFFERENCE
    plotNetworkDiff(results(i),folder);

end

%% PLOT RESULT
plotResult(results,radii,folder);
filename=sprintf('%s\\cca_workspace_%i-%i-%i_%i_%i_%i.mat',folder,fix(clock));
save(filename);
totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N))
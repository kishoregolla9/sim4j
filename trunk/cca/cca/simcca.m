if exist('folder','var') == 0
    folder='results\\temp';
    mkdir folder
end

%% BuildNetwork
hold off
addpath('cca')
addpath('network')

tic;
networkconstants;

radius=1.5;
step=0.5;
numSteps=3;
minRadius=1.6;
maxRadius=1.4+(step*numSteps);

shape=SHAPE_SQUARE;
placement=NODE_GRID;
N=40;
networkEdge=5;
ranging=0; % range-free
numAnchors=3;
numAnchorSets=1;

[sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,N);
[anchors]=buildAnchors(sourceNetwork,ANCHORS_SPREAD,numAnchors,numAnchorSets);

%% RUNCCA
close(gcf);
for i=1 : numSteps+1

    fprintf(1,'Radius: %.1f\n', radius);

    % Build and check the network
    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end
    network.anchors=anchors;
    plotNetwork(network,folder);
    
    %to pick nodes from different part of the network. Should form a startNode=[a b c ...] array that
    %contains the starting node for map patching that want to experiment with.
    %For example,
    startNode=[5 20 22];
    % Also have a startNodeSelection script which may work or may not work well depending on the network.

    %(5)Compute local maps using localMapComputing.m -
    fprintf(1,'Generating local maps for radius %.1f\n',radius);
    localMapStart=cputime;
    [localMaps,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,radius,ranging);
    fprintf(1,'Done generating local maps: %f\n', cputime-localMapStart);

    
    %(8)To patch local maps to obtain the node coordinates, use function in mapPatch.m,
    %[patchTime,coordinates_median,coordinates_median_average,allResults]=mapPatch(network, radiusNet,startNode,anchor,connectivityLevels)
    %e.g.,
    disp('------------------------------------')
    fprintf(1,'Doing Map Patch\n');
    startMapPatch=cputime;
    [result(i)]=mapPatch(network,localMaps,startNode,anchors,radius);
    fprintf(1,'Done Map Patch in %f\n', cputime-startMapPatch);

    radius = radius + step;
end

plotResult(result,minRadius,maxRadius,folder);

totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N));
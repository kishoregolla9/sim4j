clear;

%% BuildSourceNetwork
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

shape=NET.SHAPE_SQUARE;
placement=NET.NODE_RANDOM;
N=324;
networkEdge=18;
ranging=0; % range-free
numAnchorsPerSet=3;
numAnchorSets=3;

[sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,N);

clear minRadius maxRadius step networkEdge;

if exist('folder','var') ~= 1
    folder=sprintf('results\\%i-%i-%i_%i_%i_%i-%s',fix(clock),sourceNetwork.shape);
    mkdir(folder);
end

filename=sprintf('%s\\sourceNetwork.mat',folder);
save(filename, 'sourceNetwork');

close(gcf);

%% Build Networks
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

filename=sprintf('%s\\networks.mat',folder);
save(filename, 'networks', 'radii', 'numSteps','N','placement','ranging','shape','folder');

%% BuildAnchors
[anchors]=buildAnchors(sourceNetwork,NET.ANCHORS_RANDOM,numAnchorsPerSet,numAnchorSets);
filename=sprintf('%s\\anchors.mat',folder);
save(filename, 'anchors','numAnchorSets');
allMaps=cell(numSteps+1,1);

%% Build Local Maps
for i=1 : numSteps+1
    network=networks(i);
    radius=radii(i);
    fprintf(1,'Generating local maps for radius %.2f\n',radius);
    localMapStart=tic;
    [localMaps]=localMapComputing(network,radius,ranging);
    fprintf(1,'Done generating local maps for radius %.2f in %f sec\n',radius,toc(localMapStart));
    clear localMapStart;
    allMaps(i)=localMaps;
   
    radius=radii(i);
    clear localMaps network;
end

filename=sprintf('%s\\localMaps.mat',folder);
save(filename, 'allMaps', 'radii');

%% MAP PATCHING
[results]=doMapPatch(networks,allMaps,anchors,folder);
filename=sprintf('%s\\cca_results_%i-%i-%i_%i_%i_%i.mat',folder,fix(clock));
save(filename,'results');


%% PLOT RESULT
plotResult(results,anchors,radii,folder,allMaps);
totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N))

%% BuildSourceNetwork
hold off
addpath('cca')
addpath('network')
addpath('plot')

tic;
networkconstants;

minRadius=3.0;
step=1;
numSteps=0;
maxRadius=minRadius+(step*numSteps);

radii=minRadius:step:maxRadius;

shape=NET.SHAPE_SQUARE;
placement=NET.NODE_RANDOM;
N=100;
networkEdge=10;
MOD_RANDOM_ANCHORS=50000;
% N=36;
% networkEdge=6;
% MOD_RANDOM_ANCHORS=50;

ranging=0; % range-free
numAnchorsPerSet=3;
numAnchorSets=2;

shapeLabel=buildNetworkShape(shape,placement,networkEdge,networkEdge,N);
if exist('folder','var') == 0
    folder=sprintf('results\\%i-%i-%i_%i_%i_%i-%s',fix(clock),shapeLabel);
    mkdir(folder);
    f=sprintf('%s\\eps',folder);
    mkdir(f);
    f=sprintf('%s\\png',folder);
    mkdir(f);
end

filename=sprintf('%s\\sourceNetwork.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading source network from %s\n',filename);
    load(filename);
else
    [sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,N);
    save(filename, 'sourceNetwork','N','placement','ranging','shape');
    clear minRadius maxRadius step networkEdge;
    close(gcf);
end

%% Build Networks
filename=sprintf('%s\\networks.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading networks from %s\n',filename);
    load(filename);
else
    [ networks ] = buildNetworks(sourceNetwork, radii, numSteps, folder);
    save(filename, 'networks', 'radii', 'numSteps','folder');
end

%% Build Local Maps
filename=sprintf('%s\\localMaps.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading local maps from %s\n',filename);
    load(filename);
else
    allMaps=cell(numSteps+1,1);
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
    save(filename, 'allMaps', 'radii');
end

%% BuildAnchors
filename=sprintf('%s\\anchors.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading anchors from %s\n',filename);
    load(filename);
else
    [randomAnchors]=buildAnchors(sourceNetwork,NET.ANCHORS_RANDOM,numAnchorsPerSet,numAnchorSets,MOD_RANDOM_ANCHORS);
    [spreadAnchors]=buildAnchors(sourceNetwork,NET.ANCHORS_SPREAD,3,5);
    anchors=[randomAnchors;spreadAnchors];
    save(filename, 'randomAnchors','spreadAnchors','anchors','numAnchorSets');
end

%% MAP PATCHING
filename=sprintf('%s\\cca_results.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading results from %s\n',filename);
    load(filename);
else
    [results]=doMapPatch(networks,allMaps,anchors,folder);
    save(filename,'results');
end

%% PLOT RESULT
plotResult(results,anchors,radii,folder,allMaps);
totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N))

%% PLOT NETWORKS
for a=1:size(anchors,1)
    suffix=sprintf('AnchorSet%i',a);
    plotNetwork(networks,anchors(a,:),folder,suffix);
    close
end

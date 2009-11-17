%% BuildSourceNetwork
hold off
addpath('cca')
addpath('network')
addpath('plot')

tic;
networkconstants;
scale=1000000;
minRadius=2.5*scale;
step=1;
numSteps=1;
maxRadius=minRadius+(step*(numSteps+1));

radii=minRadius:step:maxRadius;

shape=NET.SHAPE_SQUARE;
placement=NET.NODE_RANDOM;
% numNodes=100;
% networkEdge=10;
numNodes=144;
networkEdge=12*scale;
% MOD_RANDOM_ANCHORS=50;

ranging=0; % range-free
numAnchorsPerSet=3;
numAnchorSets=200;
numStartNodes=3;

shapeLabel=buildNetworkShape(shape,placement,networkEdge,networkEdge,numNodes);
if exist('folder','var') == 0
    folder=sprintf('results/%i-%i-%i_%i_%i_%i-%s',fix(clock),shapeLabel);
    mkdir(folder);
    f=sprintf('%s/eps',folder);
    mkdir(f);
    f=sprintf('%s/png',folder);
    mkdir(f);
    f=sprintf('%s/localMaps',folder);
    mkdir(f);    
    f=sprintf('%s/patchedMaps',folder);
    mkdir(f);
end

filename=sprintf('%s/sourceNetwork.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading source network from %s\n',filename);
    load(filename);
else
    [sourceNetwork]=buildNetwork(shape,placement,networkEdge,networkEdge,numNodes);
    % 4 identical triangles, replacing real nodes 1-12
    n=1;
    root=[sourceNetwork.width/4,sourceNetwork.height/4];
    transforms=[[1,1];[-1,1];[1,-1];[-1,-1]];
    for i=1:4
        base=(root.*transforms(i,:)) + [sourceNetwork.width/2,sourceNetwork.height/2];
        sourceNetwork.points(n,:)=[base(1)-1*scale,base(2)];
        sourceNetwork.points(n+1,:)=[base(1)+2*scale,base(2)-1*scale];
        sourceNetwork.points(n+2,:)=[base(1)+1*scale,base(2)+1*scale];
        n=n+3;
    end
    root=[sourceNetwork.width/8,sourceNetwork.height/8];
    transforms=[[1,1];[-1,1];[1,-1];[-1,-1]];
    for i=1:4
        base=(root.*transforms(i,:)) + [sourceNetwork.width/2,sourceNetwork.height/2];
        sourceNetwork.points(n,:)=[base(1)-1,base(2)];
        sourceNetwork.points(n+1,:)=[base(1)+2,base(2)-1];
        sourceNetwork.points(n+2,:)=[base(1)+1,base(2)+1];
        n=n+3;
    end
    
    save(filename, 'sourceNetwork','numNodes','placement','ranging','shape');
    clear step networkEdge;
    close(gcf);
end

%% Build Networks
netfilename=sprintf('%s/networks.mat',folder);
if (exist(netfilename,'file') ~= 0)
    fprintf(1,'Loading networks from %s\n',netfilename);
    load(netfilename);
else
    [ networks ] = buildNetworks(sourceNetwork, radii, numSteps, folder);
    save(netfilename, 'networks', 'radii', 'numSteps');
end

%% Build Local Maps
for i=1 : numSteps
    localMapsFilename=sprintf('%s/localMaps/localMaps-%i.mat',folder,i);
    if (exist(localMapsFilename,'file') == 0)
        network=networks(i);
        radius=radii(i);
        fprintf(1,'Generating local maps for radius %.2f\n',radius);
        localMapStart=tic;
        [localMaps]=localMapComputing(network,radius,ranging,folder);
        fprintf(1,'Done generating local maps for radius %.2f in %f sec\n',radius,toc(localMapStart));
        clear localMapStart;
        
        radius=radii(i);
        save(localMapsFilename, 'localMaps');
        clear network localMaps;
    end
end

%% BuildAnchors
anchorsfilename=sprintf('%s/anchors.mat',folder);
if (exist(anchorsfilename,'file') ~= 0)
    fprintf(1,'Loading anchors from %s\n',anchorsfilename);
    load(anchorsfilename);
else
    [anchors]=buildAnchors(sourceNetwork,NET.ANCHORS_RANDOM,numAnchorsPerSet,numAnchorSets);
    a=1;
    for i=1:4
        for j=1:3
            anchors(i,j)=a;
            a=a+1;
        end
    end
    save(anchorsfilename, 'anchors','numAnchorSets');
end

% Pick nodes from different part of the network.
% Should form a startNode=[a b c ...] array that contains the
% starting node for map patching that want to experiment with.
% For example,
%startNodes=[5 20 22];
startNodeIncrement=floor(numNodes/numStartNodes);
startNodes=1:startNodeIncrement:size(networks(1).points,1);

%% MAP PATCHING
for operations=4:-1:1  % To perform the operations, 4:-1:1
    prefix=getPrefix(operations);
    FILE_PREFIX=prefix;

    for i=numSteps:-1:1
        localMapsFilename=sprintf('%s/localMaps/localMaps-%i.mat',folder,i);
        load(localMapsFilename);
        network=networks(i);
        allMaps(i,:)=localMaps;  %#ok<AGROW>
        
        resultFilename=sprintf('%s/%sresult-%i.mat',folder,prefix,i);
        if (exist(resultFilename,'file') == 2)
            fprintf(1,'Map patch #%i of %i for Radius %.1f - Loading from %s\n',...
                i,numSteps,network.radius,resultFilename);
            load(resultFilename);
        else
            disp('------------------------------------')
            patchNumber=sprintf('Map patch #%i of %i for Radius %.1f',i,...
                numSteps,network.radius);
            result=mapPatch(network,localMaps,startNodes,anchors,...
                network.radius,patchNumber,folder,operations);
            fprintf(1,'Done in %f sec for %s\n',result.mapPatchTime,patchNumber);
            save(resultFilename,'result');
        end
        plotNetworkDiffs(result,anchors, folder,prefix);
        
        if ~exist('results','var')
            % preallocate
            results(size(numSteps,1))=result; %#ok<AGROW>
        end
        results(i)=result; %#ok<AGROW>
    end
    resultsByOperation(operations)=results;%#ok<AGROW>
    %% PLOT RESULT
     resultFolder=sprintf('%s/%s',folder,prefix);
     if exist('folder','var') == 0, mkdir(resultFolder); end
     plotResult(results,anchors,radii,resultFolder,allMaps);

end

%% Plot Results By Transform
filename=sprintf('ErrorByTransform-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
plotErrorsPerTransform(resultsByOperation,folder,filename);


%% Done

totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*numNodes))

%plotNetworks(anchors, results, networks, folder);


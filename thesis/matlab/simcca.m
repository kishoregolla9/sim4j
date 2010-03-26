%% BuildSourceNetwork
addpath('cca')
addpath('network')
addpath('plot')
addpath('plot/addaxis')

networkconstants;

% allows for console loop to set networkScale
if exist('networkScale','var') == 0 || networkScale == 0
    networkScale=1.0; % do not scale by default
end

shape=NET.SHAPE_SQUARE;
placement=NET.NODE_RANDOM;
networkEdge=10 %#ok<NOPTS>
networkHeight=networkEdge;
networkWidth=networkEdge;
numNodes=100 %#ok<NOPTS>
shapeLabel=buildNetworkShape(shape,placement,networkEdge,networkHeight,numNodes) %#ok<NOPTS>

if exist('name','var') == 0
    name='';
end

if exist('folder','var') == 0
    if exist('sourceFolder','var') == 0
        folder=sprintf('../results/%s%i-%i-%i_%i_%i_%i-%s',name,fix(clock),shapeLabel);
    else
        folder=sourceFolder;
    end
end

numAnchorsPerSet=3 %#ok<NOPTS>
numAnchorSets=100 %#ok<NOPTS>
anchorsfilename=sprintf('%s/anchors%iper%isets.mat',...
    folder,numAnchorsPerSet,numAnchorSets);

if networkScale > 1 && exist(folder,'dir') == 7
    save('temp.mat','sourceFolder','networkScale',...
        'numAnchorsPerSet','numAnchorSets','anchorsfilename');
    clear variables
    load('temp.mat');
    networkconstants;
    folder=sprintf('%s-scale%.0e',sourceFolder,networkScale);
    [a,b]=mkdir(folder); %#ok<NASGU>
    src=sprintf('%s/sourceNetwork.mat',sourceFolder);
    dst=sprintf('%s/sourceNetwork.mat',folder);
    copyfile(src,dst);
    src=sprintf('%s/anchors.mat',sourceFolder);
    dst=sprintf('%s/anchors.mat',folder);
    if exist(src,'file') ~= 0
        copyfile(src,dst);
    end
    clear src dst;
    delete('temp.mat');
else
    sourceFolder=folder;
end
[a,b]=mkdir(folder); %#ok<NASGU>
f=sprintf('%s/eps',folder);
[a,b]=mkdir(f); %#ok<NASGU>
f=sprintf('%s/png',folder);
[a,b]=mkdir(f); %#ok<NASGU>
f=sprintf('%s/localMaps',folder);
[a,b]=mkdir(f); %#ok<NASGU>
f=sprintf('%s/patchedMaps',folder);
[a,b]=mkdir(f); %#ok<NASGU>
clear a b;

diaryfile=sprintf('%s/diary.log',folder);
diary(diaryfile);

% mark the diary
sprintf('SIMCCA STARTED %i-%i-%i_%i_%i_%i-%s for network scale: %i',fix(clock),networkScale)

simccaStart=tic;

doOperations=false;
minRadius=2.5*networkScale;
radiusStep=1.0*networkScale;
numRadii=1;
maxRadius=minRadius+(radiusStep*(numRadii-1));

% Print some parameters to the diary
networkScale  %#ok<NOPTS>
radii=minRadius:radiusStep:maxRadius %#ok<NOPTS>

ranging=0; % range-free
numAnchorsPerSet %#ok<NOPTS>
numAnchorSets %#ok<NOPTS>
numStartNodes=1 %#ok<NOPTS>

filename=sprintf('%s/sourceNetwork.mat',folder);
if (exist(filename,'file') ~= 0)
    fprintf(1,'Loading source network from %s\n',filename);
    load(filename);
else
    [sourceNetwork]=buildNetwork(shape,placement,networkWidth,networkHeight,numNodes);
    
    % 4 identical triangles, replacing real nodes 1-12
    %     n=1;
    %     root=[sourceNetwork.width/4,sourceNetwork.height/4];
    %     transforms=[[1,1];[-1,1];[1,-1];[-1,-1]];
    %     for i=1:4
    %         base=(root.*transforms(i,:)) + [sourceNetwork.width/2,sourceNetwork.height/2];
    %         sourceNetwork.points(n,:)=[base(1)-1,base(2)];
    %         sourceNetwork.points(n+1,:)=[base(1)+2,base(2)-1];
    %         sourceNetwork.points(n+2,:)=[base(1)+1,base(2)+1];
    %         n=n+3;
    %     end
    %     root=[sourceNetwork.width/8,sourceNetwork.height/8];
    %     transforms=[[1,1];[-1,1];[1,-1];[-1,-1]];
    %     for i=1:4
    %         base=(root.*transforms(i,:)) + [sourceNetwork.width/2,sourceNetwork.height/2];
    %         sourceNetwork.points(n,:)=[base(1)-1,base(2)];
    %         sourceNetwork.points(n+1,:)=[base(1)+2,base(2)-1];
    %         sourceNetwork.points(n+2,:)=[base(1)+1,base(2)+1];
    %         n=n+3;
    %     end
    save(filename, 'sourceNetwork','numNodes','placement','ranging','shape');
    clear radiusStep networkEdge;
    close(gcf);
end

sourceNetwork.points=sourceNetwork.points.*networkScale;
sourceNetwork.width=sourceNetwork.width*networkScale;
sourceNetwork.height=sourceNetwork.height*networkScale;
%% Build Networks
netfilename=sprintf('%s/networks.mat',folder);
if (exist(netfilename,'file') ~= 0)
    fprintf(1,'Loading networks from %s\n',netfilename);
    load(netfilename);
else
    [ networks ] = buildNetworks(sourceNetwork, radii, numRadii, folder);
    save(netfilename, 'networks', 'radii', 'numRadii');
end

%% Build Local Maps
for i=1 : numRadii
    localMapsFilename=sprintf('%s/localMaps/localMaps-%i.mat',folder,i);
    if (exist(localMapsFilename,'file') == 0)
        network=networks(i);
        radius=radii(i);
        fprintf(1,'Generating local maps for radius %.2f\n',radius);
        localMapStart=tic;
        [localMaps]=localMapComputing(network,radius,ranging,folder); %#ok<NASGU>saved to file below
        fprintf(1,'Done generating local maps for radius %.2f in %f sec\n',radius,toc(localMapStart));
        clear localMapStart;
        
        radius=radii(i);
        save(localMapsFilename, 'localMaps');
        clear network localMaps;
    end
end

clear results localMaps

%% BuildAnchors
if (exist(anchorsfilename,'file') ~= 0)
    fprintf(1,'Loading anchors from %s\n',anchorsfilename);
    load(anchorsfilename);
else
    [anchors]=buildAnchors(sourceNetwork,NET.ANCHORS_RANDOM,...
        numAnchorsPerSet,numAnchorSets);
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
lastOp=4;
if doOperations==true
    lastOp=1;
end
for operations=4:-1:lastOp  % To perform the operations, 4:-1:1
    prefix=getPrefix(operations);
    FILE_PREFIX=prefix;
    
    for i=numRadii:-1:1
        localMapsFilename=sprintf('%s/localMaps/localMaps-%i.mat',folder,i);
        load(localMapsFilename);
        network=networks(i);
        allMaps(i,:)=localMaps;  %#ok
        
        resultFilename=sprintf('%s/%sresult-r%.1f-%iper%isets.mat',...
            folder,prefix,network.radius,numAnchorsPerSet,numAnchorSets);
        if (exist(resultFilename,'file') == 2)
            fprintf(1,'Map patch #%i of %i for Radius %.1f - Loading from %s\n',...
                i,numRadii,network.radius,resultFilename);
            load(resultFilename);
        else
            disp('------------------------------------')
            patchNumber=sprintf('Map patch #%i of %i for Radius %.1f',i,...
                numRadii,network.radius);
            result=mapPatch(network,localMaps,startNodes,anchors,...
                network.radius,patchNumber,folder,operations);
            
            result=addAnchorStats(result,anchors);
            
            bestMean=max([result.errorsPerAnchorSet(:).mean]);
            
            fprintf(1,'Done in %f sec for %s\n',result.mapPatchTime,patchNumber);
            
            allStartsFolder=sprintf('%s/allStarts/',folder);
            if (exist(allStartsFolder,'dir') == 0)
                mkdir(allStartsFolder); 
            end
            x=[result.errors.mean];
            for z=5:-1:1
                f=sprintf('%s/index%i',allStartsFolder,z);
                if (exist(f,'dir') == 0); mkdir(f); end;
                [minValue,minIndex]=min(x);
                allStarts(z)=mapPatch(network,localMaps,1:length(network.points),...
                    anchors(minIndex,:),network.radius,patchNumber,f,operations);%#ok
                x(minIndex)=10000000;
            end
            hold all
            for z=1:5
                plot(sort([allStarts(z).errorsPerStart.mean]))
            end
            hold off
            
            [maxValue,maxIndex]=max([result.errors.mean]);
            worstFolder=sprintf('%s/worst',folder);
            mkdir(worstFolder);
            worst=mapPatch(network,localMaps,1:length(network.points),...
                anchors(maxIndex,:),network.radius,patchNumber,worstFolder,operations);
            
            save(resultFilename,'result','allStarts');
        end
        plotNetworkDiffs(result,anchors,folder,prefix);
        
        if ~exist('results','var')
            % preallocate
            results(size(numRadii,1))=result; %#ok
        end
        results(i)=result; %#ok
        

    end
    resultsByOperation(operations)=results;%#ok
    %% PLOT RESULT
    resultFolder=sprintf('%s/%s',folder,prefix);
    plotResult(results,anchors,radii,resultFolder,allMaps);
    plotRegressions(results,anchors,radii,resultFolder);
    plotJackknife(results,anchors,radii,resultFolder);
    plotHistograms(results,anchors,radii,resultFolder);
    plotCdf(results,anchors,radii,resultFolder);
end

%% Plot Results By Transform Operation
if doOperations == true
    filename=sprintf('ErrorByTransform-%s-Radius%.1f-to-%.1f',...
        network.shape,minRadius,maxRadius);
    plotErrorsPerTransform(resultsByOperation,folder,filename);
end


%% Done
totalTime=toc(simccaStart);
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numRadii,totalTime/60,totalTime/numRadii,totalTime/(numRadii*numNodes))

%plotNetworks(anchors, results, networks, folder);

diary off;


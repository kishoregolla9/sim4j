% Run simcca multiple times, but preserving a single anchor set each time
addpath('cca')
addpath('network')
addpath('plot')
addpath('plot/addaxis')
networkconstants;
multiStart=tic;
if (exist('loadFolderpath.m','file') ~= 0)
    loadFolderpath;
    fprintf(1,'Using previous folderpath: %s',folderpath);
end
    
if (exist('folderpath','var') == 0)
    ccaconfig
    shapeLabel=buildNetworkShape(shape,placement,networkEdge,networkHeight,numNodes) %#ok<NOPTS>
    folderpath=sprintf('../results/multi-%04i%02i%02i_%02i%02i%02i_%s-%iSets-%iNets',...
        fix(clock),shapeLabel,numAnchorSets,numNetworks);
    mkdir(folderpath);
    dst=sprintf('%s/ccaconfig.m',folderpath);
    copyfile('ccaconfig.m',dst);
    simcca
else
    ccaconfigfile=sprintf('%s/ccaconfig.m',folderpath);
    networkconstants;
    run(ccaconfigfile);
    files=dir(folderpath);
    d=files(3);
    folder=sprintf('%s/%s',folderpath,d.name);
    files=dir(folder);
    for j=1:length(files)
        if strcmp(sscanf(files(j).name,'%6s',1),'result') == true || ...
          strcmp(sscanf(files(j).name,'%7s',1),'anchors') == true || ...
          strcmp(sscanf(files(j).name,'%7s',1),'network') == true          
            f=sprintf('%s/%s',folder,files(j).name);
            fprintf(1,'%i Loading \"%s\" ...\n',i,f);
            load(f);
        end
    end
end
x=[result.errors.mean];
errorsWithIndex=[1:length(x);x];

folders=cell(length(anchors),numNetworks);
folders{1,1}=folder;
originalAnchors=anchors;
points=result.network.points;
for anchorSetIndex=1:numAnchorSets
    % Column1:the index, Column2-3: the points (x,y)
    anchorPoints=[originalAnchors(anchorSetIndex,:)',...
        points(originalAnchors(anchorSetIndex,:),:)];
    runCCA(folders, folderpath,...
        anchorSetIndex, anchorPoints, numNetworks);
end

% save(dst,'anchorPoints','folders','anchorSetIndex',...
%     'networkIndex','numNetworks','folderpath','multiStart',...
%     'originalAnchors','numAnchorSets','points');
% f=sprintf('%s/anchorPoints.mat',folderpath);
% save(f,'anchorPoints','folders','anchorSetIndex',...
%     'networkIndex','numNetworks','folderpath','multiStart','originalAnchors','numAnchorSets');
% 
% clear
% load('folderpath.mat');
% dst=sprintf('%s/anchorPoints.mat',folderpath);
% load(dst);
ccaconfigfile=sprintf('%s/ccaconfig.m',folderpath);
networkconstants;
run(ccaconfigfile);
folderAll=sprintf('%s-all',folders{1,1});
mkdir(folderAll);
%% Load and Plot Total Results
meanErrors=zeros(numAnchorSets,numNetworks);
maxErrors=zeros(numAnchorSets,numNetworks);
anchorErrors=zeros(numAnchorSets,numNetworks);
triangleHeights=zeros(numAnchorSets,numNetworks);
triangleAreas=zeros(numAnchorSets,numNetworks);
allAnchors=anchors;
for anchorSet=1:numAnchorSets
    for i=1:numNetworks
        if i == 1
            folder=folders{1,1};
        else
            folder=sprintf('%s/AnchorSet%i/Network%i',folderpath,...
                anchorSet,i);
        end
        files=dir(folder);
        for j=1:length(files)
            if strcmp(sscanf(files(j).name,'%6s',1),'result') == true || ...
                    strcmp(sscanf(files(j).name,'%7s',1),'anchors') == true
                f=sprintf('%s/%s',folder,files(j).name);
                fprintf(1,'%i-%i Loading \"%s\" ...\n',anchorSet,i,f);
                load(f);
            end
        end
        stats=triangleStats(result.network,allAnchors(anchorSet,:));
        if (length(result.errors) > 1)
            meanErrors(anchorSet,i)=result.errors(anchorSet).mean;
            maxErrors(anchorSet,i)=result.errors(anchorSet).max;
            anchorErrors(anchorSet,i)=result.anchorErrors(anchorSet).mean;
            triangleHeights(anchorSet,i)=stats.heights.min;
            triangleAreas(anchorSet,i)=stats.areas;
        else
            meanErrors(anchorSet,i)=result.errors.mean;
            maxErrors(anchorSet,i)=result.errors.max;
            anchorErrors(anchorSet,i)=result.anchorErrors.mean;
            triangleHeights(anchorSet,i)=stats.heights.min;
            triangleAreas(anchorSet,i)=stats.areas;
        end
        
        if (i > 1)
            source=sprintf('%s/png/networkdiffs-nostats/NetDiff-R2.5-Rank1-AnchorSet1-.png',...
                folder);
            destination=sprintf('%s/%.2f-AS%i-NetworkDiff%i.png',...
                folderAll,meanErrors(i),anchorSet,i);
            fprintf(1,'Copy %s\n to  %s\n',source,destination);
            copyfile(source,destination);
        end
        
    end
end
clear result anchors;
%%
run(ccaconfigfile);
shapeLabel=buildNetworkShape(shape,placement,networkEdge,networkHeight,numNodes) %#ok<NOPTS>
plotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,numAnchorSets,maxErrors,meanErrors);

plotMultiData(folderAll,shapeLabel,'Mean Anchor Error',numNetworks,numAnchorSets,maxErrors,meanErrors,anchorErrors);
plotMultiData(folderAll,shapeLabel,'Triangle Height',numNetworks,numAnchorSets,maxErrors,meanErrors,triangleHeights);
plotMultiData(folderAll,shapeLabel,'Triangle Area',numNetworks,numAnchorSets,maxErrors,meanErrors,triangleAreas);

threshold=1.2;
plotMultiData(folderAll,shapeLabel,'Mean Anchor Error',numNetworks,numAnchorSets,maxErrors,meanErrors,anchorErrors,threshold);
plotMultiData(folderAll,shapeLabel,'Triangle Height',numNetworks,numAnchorSets,maxErrors,meanErrors,triangleHeights,threshold);
plotMultiData(folderAll,shapeLabel,'Triangle Area',numNetworks,numAnchorSets,maxErrors,meanErrors,triangleAreas,threshold);


%% Histogram of Moving Anchors
h=figure('Name','Histogram','visible','off');
hist(meanErrors,20);
saveFigure(folderAll,'HistogramSameAnchors',h);

%% Load the original data
i=1;
files=dir(folders{i});
for j=1:length(files)
    if strcmp(sscanf(files(j).name,'%6s',1),'result') == true || ...
            strcmp(sscanf(files(j).name,'%7s',1),'anchors') == true
        f=sprintf('%s/%s',folders{i},files(j).name);
        fprintf(1,'%i Loading \"%s\" ...\n',i,f);
        load(f);
    end
end

%% Plot Errors with Error Bars
hold on
confidence=0.05;
h=figure('Name','Location Error','visible','off');
x=[[result.errors.max];[result.errors.mean]]';
% Sort by mean (column 2)
sorted=sortrows(x,-2);

% Plot max
% subplot(2,1,1);
hold all
[ci]=getConfidenceInterval(confidence,maxErrors);
mu=mean(removeOutliers(sorted(:,1)));
lower=mu-ci;
upper=mu+ci;
% rectangle('Position',[0,lower,length(maxErrors),upper-lower],'FaceColor',[0 0 0.5]);
plot(sorted(:,1),'-^b','MarkerSize',3);
legend('Max');

% plot([0 length(maxErrors)], [lower, lower],'b');
% plot([0 length(maxErrors)], [upper, upper],'b');
plot([0 length(maxErrors)], [mu, mu],'b--');
plot(repmat(length(maxErrors)/2, length(maxErrors), 1), maxErrors,...
    'o','MarkerSize',1);

y=sort(maxErrors);
plot([0 length(meanErrors)], [y(3), y(3)],'r');
plot([0 length(meanErrors)], [y(length(x)-3), y(length(x)-3)],'r');

% Plot mean
% subplot(2,1,2);
[ci]=getConfidenceInterval(confidence,meanErrors);
mu=mean(removeOutliers(sorted(:,2)));
lower=mu-ci;
upper=mu+ci;
% rectangle('Position',[0,lower,length(meanErrors),upper-lower],'FaceColor',[0 0.5 0]);
plot(sorted(:,2),'-og','MarkerSize',3);
legend('Mean');
hold all
% plot([0 length(meanErrors)], [lower, lower],'g');
% plot([0 length(meanErrors)], [mu, mu],'g--');
% plot([0 length(meanErrors)], [upper, upper],'g');

plot([0 length(meanErrors)], [mu, mu],'g--');

y=sort(meanErrors);
plot([0 length(meanErrors)], [y(3), y(3)],'r');
plot([0 length(meanErrors)], [y(length(x)-3), y(length(x)-3)],'r');

% plot all meanErrors, vertically at the anchorSet point
plot(repmat(length(meanErrors)/2, length(meanErrors), 1), meanErrors,...
    'o','MarkerSize',1);

hold off
xlabel('Anchor Set Index (sorted by mean error)')
saveFigure(folderAll,'ErrorBars',h);

%% Done
timeElapsed=toc(multiStart);
fprintf(1,'Done in %.2f sec\n',timeElapsed);


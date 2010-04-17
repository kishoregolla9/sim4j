% Run simcca multiple times, but preserving a single anchor set each time
addpath('cca')
addpath('network')
addpath('plot')
addpath('plot/addaxis')

multiStart=tic;
if (exist('folderpath','var') == 0)
    folderpath=sprintf('../results/multi-%i-%i-%i_%i_%i_%i',fix(clock));
    mkdir(folderpath);
    simcca
else
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
numNetworks=10;

folders=cell(length(anchors),numNetworks);
folders{1,1}=folder;
originalAnchors=anchors;
for anchorSetIndex=1:numAnchorSets
    % Column1:the index, Column2-3: the points (x,y)
    anchorPoints=[originalAnchors(j,:)',...
        result.network.points(originalAnchors(j,:),:)];
    for networkIndex=2:numNetworks
        save('anchorPoints.mat','anchorPoints','folders',...
            'networkIndex','anchorSetIndex','numNetworks','numAnchorSets',...
            'folderpath','multiStart','originalAnchors');
        clear
        load('anchorPoints.mat');
        networkIndex=networkIndex; %#ok 
        anchorSetIndex=anchorSetIndex; %#ok
        folder=folders{1,1};
        f=sprintf('%s/AnchorSet%i/Network%i',folderpath,...
            anchorSetIndex,networkIndex);
        fprintf(1,'%i Folder %s\n',networkIndex,f);
        if ~exist(f,'dir')
            fprintf(1,'**** Running simcca for network #%i of %i\n',...
                i,numNetworks)
            anchorPointsFolder=f;
            simcca
        else
            fprintf(1,'**** Run simcca for network #%i already done\n',i)
            folder=f;
        end
        folders{anchorSetIndex,i}=folder;
    end
end
save('anchorPoints.mat','anchorPoints','folders','anchorSetIndex',...
    'networkIndex','numNetworks','folderpath','multiStart','originalAnchors','numAnchorSets');
f=sprintf('%s/anchorPoints.mat',folderpath);
save(f,'anchorPoints','folders','anchorSetIndex',...
    'networkIndex','numNetworks','folderpath','multiStart','originalAnchors','numAnchorSets');

clear
load('anchorPoints.mat');
folderAll=sprintf('%s-all',folders{1,1});
mkdir(folderAll);
%% Load and Plot Total Results
meanErrors=zeros(length(folders),1);
maxErrors=zeros(length(folders),1);
for i=1:length(folders)
    files=dir(folders{i});
    for j=1:length(files)
        if strcmp(sscanf(files(j).name,'%6s',1),'result') == true || ...
          strcmp(sscanf(files(j).name,'%7s',1),'anchors') == true
            f=sprintf('%s/%s',folders{i},files(j).name);
            fprintf(1,'%i Loading \"%s\" ...\n',i,f);
            load(f);
        end
    end
    if (length(result.errors) > 1)
        meanErrors(i)=result.errors(anchorSet).mean;
        maxErrors(i)=result.errors(anchorSet).max;
    else
        meanErrors(i)=result.errors.mean;
        maxErrors(i)=result.errors.max;
    end

    if (i > 1)
        source=sprintf('%s/png/networkdiffs/NetDiff-R2.5-Rank1-AnchorSet1-.png',...
            folders{i});
        destination=sprintf('%s/png/%.2fNetworkDiff-%i.png',...
            folderAll,meanErrors(i),i);
        copyfile(source,destination);
    end
    
end
clear result anchors;
%% Plot Same-Anchors Data
h=figure('Name','Different Networks around Same Anchors','visible','off');
plot(maxErrors,'-^b');
hold all
plot(meanErrors,'-og');

confidence=0.05;

[ci]=getConfidenceInterval(confidence,maxErrors);
mu=mean(removeOutliers(maxErrors));
lower=mu-ci;
upper=mu+ci;
plot([0 length(maxErrors)], [lower, lower],'b');
plot([0 length(maxErrors)], [upper, upper],'b');

[ci]=getConfidenceInterval(confidence,meanErrors);
mu=mean(removeOutliers(meanErrors));
lower=mu-ci;
upper=mu+ci;
plot([0 length(maxErrors)], [lower, lower],'g');
plot([0 length(maxErrors)], [upper, upper],'g');

xlabel('Network Index');
ylabel('Location Error');
legend({'Max','Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
close

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

plot([0 length(maxErrors)], [lower, lower],'b');
plot([0 length(maxErrors)], [upper, upper],'b');
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
plot([0 length(meanErrors)], [lower, lower],'g');
plot([0 length(meanErrors)], [upper, upper],'g');

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


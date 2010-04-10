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
sorted=sortrows(errorsWithIndex',2);
% Take a random midpoint
anchorSet=sorted(length(sorted)/2,1);
% Column1:the index, Column2-3: the points (x,y)
anchorPoints=[anchors(anchorSet,:)',...
    result.network.points(anchors(anchorSet,:),:)];

numNetworks=100;

folders=cell(numNetworks,1);
folders{1}=folder;
for i=2:numNetworks
    index=i;
    save('anchorPoints.mat','anchorPoints','folders','anchorSet',...
        'index','numNetworks','folderpath','multiStart');
    clear
    load('anchorPoints.mat');
    i=index; %#ok
    folder=folders{1};
    f=sprintf('%s-%i',folder,index);
    fprintf(1,'%i Folder %s\n',i,f);
    if exist(f,'dir') == 0
        simcca
    else
        folder=f;
    end
    folders{index}=folder; 
end
save('anchorPoints.mat','anchorPoints','folders','anchorSet',...
    'index','numNetworks','folderpath','multiStart');
f=sprintf('%s/anchorPoints.mat',folderpath);
save(f,'anchorPoints','folders','anchorSet',...
    'index','numNetworks','folderpath','multiStart');

clear
load('anchorPoints.mat');
folderAll=sprintf('%s-all',folders{1});
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
    
end
clear result anchors;
%% Plot Same-Anchors Data
h=figure('Name','Different Networks around Same Anchors','visible','off');
plot(maxErrors,'-^b');
hold all
plot(meanErrors,'-og');


[lower,upper]=getConfidenceInterval(confidence,maxErrors);
plot([0 length(maxErrors)], [lower, lower],'b');
plot([0 length(maxErrors)], [upper, upper],'b');

[lower,upper]=getConfidenceInterval(confidence,meanErrors);
plot([0 length(maxErrors)], [lower, lower],'g');
plot([0 length(maxErrors)], [upper, upper],'g');

xlabel('Network Index');
ylabel('Location Error');
legend({'Max','Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
close


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
subplot(2,1,1);
plot(sorted(:,1),'-^');
hold all
[ci]=getConfidenceInterval(confidence,maxErrors);
mu=mean(removeOutliers(sorted(:,1)));
lower=mu-ci;
upper=mu+ci;
plot([0 length(maxErrors)], [lower, lower],'r');
plot([0 length(maxErrors)], [upper, upper],'r');
legend('Max');
subplot(2,1,2);
plot(sorted(:,2),'-og');
hold all
[ci]=getConfidenceInterval(confidence,meanErrors);
mu=mean(removeOutliers(sorted(:,2)));
lower=mu-ci;
upper=mu+ci;
plot([0 length(meanErrors)], [lower, lower],'r');
plot([0 length(meanErrors)], [upper, upper],'r');
legend('Mean');
% legend({'Max','Mean'});
xlabel('Anchor Set Index (sorted by mean error)')
saveFigure(folderAll,'ErrorBars',h);
timeElapsed=toc(multiStart);


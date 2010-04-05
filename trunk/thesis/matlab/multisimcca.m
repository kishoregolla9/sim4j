% Run simcca multiple times, but preserving a single anchor set each time
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

numNetworks=50;

folders=cell(numNetworks,1);
folders{1}=folder;
for i=2:numNetworks
    index=i;
    save('anchorPoints.mat','anchorPoints','folders','anchorSet',...
        'index','numNetworks');
    clear
    load('anchorPoints.mat');
    i=index; %#ok
    folder=folders{1};
    f=sprintf('%s-%i',folder,index);
    fprintf(1,'%i Folder %s\n',i,f);
    if exist(f,'dir') == 0
        simcca
    end
    folders{index}=folder; 
end
save('anchorPoints.mat','anchorPoints','folders','anchorSet',...
    'index','numNetworks');

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
h=figure('Name','Different Networks around Same Anchors','visible','off');
plot(maxErrors,'-^');
hold all
plot(meanErrors,'-o');
xlabel('Network Index');
ylabel('Location Error');
legend({'Max','Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
close

%% Plot Errors with Error Bars
hold on
figure('Name','Location Error','visible','off');

files=dir(folders{i});
for j=1:length(files)
    if strcmp(sscanf(files(j).name,'%6s',1),'result') == true || ...
            strcmp(sscanf(files(j).name,'%7s',1),'anchors') == true
        f=sprintf('%s/%s',folders{i},files(j).name);
        fprintf(1,'%i Loading \"%s\" ...\n',i,f);
        load(f);
    end
end



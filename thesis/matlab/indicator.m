
randomsquare={...
    'chapter4',...
    'chapter5b',...
    '2010-11-16_14_7_17-Square-Random-20x20',...
    '2010-11-18_9_15_24-Square-Random-20x20',...
    '2010-11-18_9_31_50-Square-Random-20x20',...
    '2010-11-18_9_48_47-Square-Random-20x20',...
    '2010-11-18_10_7_43-Square-Random-20x20',...
    '2010-11-18_10_25_32-Square-Random-20x20' %,...
%     '2010-11-19_10_53_10-Square-Random-20x20',...
%     '2010-11-19_11_21_34-Square-Random-20x20',...
%     '2010-11-19_11_50_2-Square-Random-20x20'...
%     '2010-11-19_12_18_52-Square-Random-20x20'
    };

cfolders={...
    '2010-11-18_10_52_54-C-Random-20x20',...
    '2010-11-18_11_39_42-C-Random-20x20',...
    '2010-11-18_11_56_23-C-Random-20x20',...
    '2010-11-18_12_13_11-C-Random-20x20',...
    '2010-11-18_12_30_6-C-Random-20x20',...
    '2010-11-18_12_46_25-C-Random-20x20',...
    '2010-11-18_13_19_56-C-Random-20x20',...
    '2010-11-18_13_2_35-C-Random-20x20',...
    '2010-11-18_13_37_11-C-Random-20x20'
    };

folders=randomsquare;
label='square';

allErrors=zeros(0,1);
minHeights=zeros(0,1);
sumDistances=zeros(0,1);
areas=zeros(0,1);
for i=1:length(folders)
    folder=sprintf('../results/%s',folders{i});
    vars=loadFile(folder,'errorsAndAnchors');
    if (isempty(vars))
        vars=loadFile(folder,'result');
        if ~isfield(vars,'result')
            fprintf(2,'Skipping %s',folder);
            continue;
        end
        result=vars.result;
        errors=result.errors;
        network=result.network;
        radius=result.radius;
        vars=loadFile(folder,'anchors');
        anchors=vars.anchors;
        
        savefile=sprintf('%s/errorsAndAnchors.mat',folder);
        save(savefile,'errors','anchors','network','radius');
        clear result
    else
        errors=vars.errors;
        network=vars.network;
        anchors=vars.anchors;
        if (isfield(vars,'radius'))
            radius=vars.radius;
        else
            radius=2.5;
        end
    end
    allErrors=[ allErrors [errors.mean] ]; %#ok grow
    stats=triangleStats(network.points,anchors,network.width,network.height);
    minHeights=[ minHeights [stats.heights.min] ]; %#ok grow
    areas=[ areas stats.areas' ]; %#ok grow
    sums=zeros(1,size(anchors,1));
    d=zeros(1,3);
    for s=1:size(anchors,1)
        anchorNodes=anchors(s,:);
        d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
        d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
        d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
        sums(s)=sum(d);
    end
    sumDistances=[ sumDistances sums  ]; %#ok grow
    
    clear network errors anchors numAnchorSets
end
h=plotIndicators(allErrors,minHeights,radius,{'Minimum Anchor Triangle Height','(factor of radio radius)'},0.1,100);
filename=sprintf('HeightIndicator_%s',label);
saveFigure('..',filename,h);
hold off

% h=plotIndicators(allErrors,sumDistances,radius,{'Sum of Distance between Anchors','(factor of radio radius)'},0.25,2);
% filename=sprintf('SumOfDistanceIndicator_%s',label);
% saveFigure('..',filename,h);
% hold off

h=plotIndicators(allErrors,areas,radius,{'Anchor Triangle Area','(factor of radio radius)'},0.1,100);
filename=sprintf('AreaIndicator_%s',label);
saveFigure('..',filename,h);
hold off

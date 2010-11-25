
randomsquare={...
    'chapter4',...
    'chapter5b',...
    '2010-11-16_14_7_17-Square-Random-20x20',...
    '2010-11-18_9_15_24-Square-Random-20x20',...
    '2010-11-18_9_31_50-Square-Random-20x20',...
    '2010-11-18_9_48_47-Square-Random-20x20',...
    '2010-11-18_10_7_43-Square-Random-20x20',...
    '2010-11-18_10_25_32-Square-Random-20x20',...
    '2010-11-21_15_53_39-Square-Random-20x20',...
    '2010-11-21_16_27_5-Square-Random-20x20',...
    '2010-11-21_16_46_20-Square-Random-20x20',...
    '2010-11-21_17_18_18-Square-Random-20x20',...
    '2010-11-21_17_1_10-Square-Random-20x20',...
    '2010-11-21_17_33_31-Square-Random-20x20',...
    '2010-11-21_17_48_53-Square-Random-20x20',...
    '2010-11-21_18_18_52-Square-Random-20x20',...
    '2010-11-21_18_35_14-Square-Random-20x20',...
    '2010-11-21_18_3_42-Square-Random-20x20',...
    '2010-11-21_18_50_45-Square-Random-20x20',...
    '2010-11-21_19_21_10-Square-Random-20x20',...
    '2010-11-21_19_36_39-Square-Random-20x20',...
    '2010-11-21_19_52_52-Square-Random-20x20',...
    '2010-11-21_19_6_2-Square-Random-20x20',...
    '2010-11-21_20_23_49-Square-Random-20x20',...
    '2010-11-21_20_38_54-Square-Random-20x20',...
    '2010-11-21_20_8_21-Square-Random-20x20',...
    '2010-11-21_21_39_53-Square-Random-20x20'
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
    '2010-11-18_13_37_11-C-Random-20x20',...
    ' 2010-11-21_21_44_47-C-Random-20x20'
    };

pipelines={...
    '2010-11-23_20_16_5-Rectangle-Random-20x2',...
    '2010-11-23_20_47_32-Rectangle-Random-20x2',...
    '2010-11-23_22_37_54-Rectangle-Random-20x2',...
    '2010-11-23_22_6_17-Rectangle-Random-20x2',...
    '2010-11-24_20_27_30-Rectangle-Random-20x2',...
    '2010-11-24_20_2_31-Rectangle-Random-20x2'
    };

folders=pipelines;
label='pipeline';

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
h=plotIndicators(allErrors,minHeights,radius,{'Minimum Anchor Triangle Height','(factor of radio radius)'},0.1,false,'log');
filename=sprintf('HeightIndicator_%s',label);
saveFigure('..',filename,h);
hold off

h=plotIndicators(allErrors,areas,radius,{'Anchor Triangle Area','(factor of radio radius)'},0.1,true,'log');
filename=sprintf('AreaIndicator_%s',label);
saveFigure('..',filename,h);
hold off

% outliers=find(allErrors>2.5);
% allErrors(outliers)=[];
% sumDistances(outliers)=[];

h=plotIndicators(allErrors,sumDistances,radius,{'Sum of Distance between Anchors','(factor of radio radius)'},2,false,'linear');
filename=sprintf('SumOfDistanceIndicator_%s',label);
saveFigure('..',filename,h);
hold off


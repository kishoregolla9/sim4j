
randomsquare={...
    '2010-11-16_14_25_47-Square-Random-20x20',...
    '2010-11-16_14_7_17-Square-Random-20x20',...
    '2010-11-18_9_15_24-Square-Random-20x20',...
    '2010-11-18_9_31_50-Square-Random-20x20',...
    '2010-11-18_9_48_47-Square-Random-20x20',...
    '2010-11-18_10_7_43-Square-Random-20x20',...
    '2010-11-18_10_25_32-Square-Random-20x20'
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

folders=cfolders;
label='cshape';

allErrors=zeros(0,1);
heights=zeros(0,1);
for i=1:length(folders)
    folder=sprintf('../results/%s',folders{i});
    vars=loadFile(folder,'errorsAndAnchors');
    if (isempty(vars))
        vars=loadFile(folder,'result');
        result=vars.result;
        errors=result.errors;
        network=result.network;
        radius=result.radius;
        vars=loadFile(folder,'anchors');
        anchors=vars.anchors;
        
        savefile=sprintf('%s/errorsAndAnchors.mat',folder);
        save(savefile,'errors','anchors','network','radius');
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
    heights=[ heights [stats.heights.min] ]; %#ok grow
    %     clear network errors anchors numAnchorSets
end
h=plotIndicators(allErrors,heights,radius);
filename=sprintf('HeightIndicator_%s',label);
saveFigure('..',filename,h);


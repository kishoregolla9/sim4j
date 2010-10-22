function plotAnchorAreaVsError( results,anchors,radii,folder,threshold )
% Plot distance between the anchors themselves vs error
network=results(1).network;

%% Plot by Area

figName='Anchor Area vs Error';
dataName='Area of Anchor Triangle';    

stats=triangleStats(network,anchors);

if (exist('threshold','var')==0)
    plotSingleDataSet(figName,dataName,results,anchors,radii,stats.areas',...
        folder);
else
    plotSingleDataSet(figName,dataName,results,anchors,radii,stats.areas',...
        folder,threshold);
end

end
function plotAnchorAreaVsError( results,anchors,radii,folder,threshold )
% Plot distance between the anchors themselves vs error
network=results(1).network;

%% Plot by Area

figName='Anchor Area vs Error';
dataName='Area of Anchor Triangle';    
stats=triangleStats(network.points,anchors,network.width,network.height);

if (exist('threshold','var')==0)
    threshold=100;
end

plotSingleDataSet(figName,dataName,results,anchors,radii,(stats.areas')/radii,...
    folder,threshold,{dataName,'(factor of radio radius)'});

end
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

% result=results(1);
% width=result.network.width;
% height=result.network.height;
% numAnchorSets=size(anchors,1);
% mappedareas=zeros(1,numAnchorSets,1);
% for s=1:numAnchorSets
%     mappedstats=triangleStats(result.patchedMap(s).mappedPoints,anchors(s,:),width,height);
%     mappedareas(s)=mappedstats.areas;
% end

plotSingleDataSet(figName,dataName,results,anchors,radii,stats.areas'/radii(1),...
    folder,threshold,{dataName,'(factor of radio radius)'});
% plotSingleDataSet(figName,dataName,results,anchors,radii,mappedareas/radii(1),...
%     folder,threshold,{dataName,'(factor of radio radius)'},h,{'s'});

end
function plotDissimilarity( results,anchors,radii,folder )
% Plot rotation and reflection vs error

result=results(1);
figName='Dissimilarity vs Error';

if (exist('threshold','var')==0)
    threshold=100;
end

plotSingleDataSet(figName,'Dissimilarity measure',results,anchors,radii,...
    result.dissimilarity,folder,threshold);
end

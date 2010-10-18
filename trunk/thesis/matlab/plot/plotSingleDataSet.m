function plotSingleDataSet( figName,dataName,...
    results,anchors,radii,allData,folder,threshold)
% Plot number of unique anchor neighbors (unique among all anchors in the
% set) vs location error

if (exist('threshold','var')==0)
    threshold=100;
end

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);
numRadii=size(results,2);

figure('Name',figName,'visible','off');
plotTitle=sprintf('Network %s',strrep(network.shape,'-',' '));
if (threshold < 100)
    plotTitle=sprintf('%s\nExcluding errors >%0.1f',plotTitle,threshold);
end
title(plotTitle);
hold all
grid on
labels=cell(1, numRadii);
for r=1:numRadii
    data=allData(r,:,:)';
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).mean];
    end
    
    % Remove outliers greater than threshold
    outliers=find(errorPerAnchorSet>threshold);
    errorPerAnchorSet(outliers)=[];
    data(outliers)=[];
    
    dataToPlot=[data, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'ok');
    
    p = polyfit(data, errorPerAnchorSet, 2);
    Output = polyval(p,data);
    correlation = corrcoef(errorPerAnchorSet, Output);
    
    if (numRadii > 1)
        labels{r}=sprintf('Radius=%.1f,Correlation=%.2f',...
            results(r).radius,correlation(1,2));
    end
end
%legend(labels,'Location','NorthEast');
if (numRadii == 1)
    dataName=sprintf('%s\nCorrelation Coefficient=%.2f',...
        dataName,correlation(1,2));
end
xlabel(dataName);
ylabel('Mean Location Error');
hold off
prefix=strrep(figName,' ','_');
filename=sprintf('%s-%s-Radius%.1f-to-%.1f',...
    prefix,network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end

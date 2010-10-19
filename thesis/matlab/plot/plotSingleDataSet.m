function plotSingleDataSet( figName,dataName,...
    results,anchors,radii,allData,folder,threshold,dataLabels)
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

if iscell(allData)
    numData=size(allData{1},2);
else
    numData=size(allData,3);
end

labels=cell(1, numRadii * numData);
p=1;
for r=1:numRadii
    y=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        y(s)=[results(r).errors(s,1).mean];
    end

    outliers=find(y>threshold);
    y(outliers)=[];
    
    markers={ 'o' 'v' 'd' };
    
    for d=1:numData
        if iscell(allData)
            x=allData{r};
            x=x(:,d);
        else
            x=allData(r,:,d)';
        end
        
        % Remove outliers greater than threshold
        x(outliers)=[];
        
        dataToPlot=[x, y];
        dataToPlot=sortrows(dataToPlot,1);
        ls=sprintf('%sk',markers{d});
        plot(dataToPlot(:,1),dataToPlot(:,2),ls);
        
        fit = polyfit(x, y, 2);
        Output = polyval(fit,x);
        correlation = corrcoef(y, Output);
        
        if (exist('dataLabels','var') == 1)
            lab=sprintf('%s - Correlation=%.2f',...
                dataLabels{d},correlation(1,2));
            if (numRadii > 1)
                lab=sprintf('%s - Radius=%.1f',lab,results(r).radius);
            end
            labels{p}=lab;
        elseif (numRadii > 1)
            lab=sprintf('%s  - Radius=%.1f - Correlation=%.2f',...
                results(r).radius,correlation(1,2));
            labels{p}=lab;
        end
        p=p+1;
    end
end

legend(labels,'Location','NorthEast');
if (numRadii == 1 && exist('dataLabels','var')==0)
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

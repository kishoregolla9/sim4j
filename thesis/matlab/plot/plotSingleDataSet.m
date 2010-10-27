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
title(plotTitle,'fontsize',15);
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
    
    markers={ '.' 'o' 'v' };
    
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
        x=dataToPlot(:,1);
        y=dataToPlot(:,2);
%         plot(dataToPlot(:,1),dataToPlot(:,2),ls);
        
        [correlation,pvalue] = corrcoef(x,y);
        r2=zeros(2,1);
        fit = polyfit(x,y,1);
        y1=polyval(fit,x);
        r2(1) = rsquare(y, y1);

        fit = polyfit(x,y,2);
        y2=polyval(fit,x);
        r2(2) = rsquare(y, y2);

        plot(x,y,ls,x,y1,'-',x,y2,'--');

        correlation=correlation(1,2);
        pvalue=pvalue(1,2);
        
        statsString=sprintf('correlation coeff: %.2f p-value: %.2f',...
            correlation,pvalue);
        
        if (exist('dataLabels','var') == 1)
            lab=sprintf('%s',...
                statsString);
            if (numRadii > 1)
                lab=sprintf('%s: Radius=%.1f',lab,results(r).radius);
            end
            labels{p}=lab;
        elseif (numRadii > 1)
            lab=sprintf('%s: Radius=%.1f\n  ',...
                results(r).radius,statsString);
            labels{p}=lab;
        end
        labels{p+1}=sprintf('Line of best fit, 1st order (r^{2}: %.2f)',r2(1));
        labels{p+2}=sprintf('Line of best fit, 2nd order (r^{2}: %.2f)',r2(2));
        p=p+3;
    end
end
if (iscell(labels) && ischar(labels{1}))
    legend(labels,'Location','NorthEast','FontSize',15);
end

if (numRadii == 1 && exist('dataLabels','var')==0)
    dataName=sprintf('%s\n%s',...
        dataName,statsString);
end
xlabel(dataName,'fontsize',12);
ylabel('Mean Location Error','fontsize',12);
hold off
prefix=strrep(figName,' ','_');
filename=sprintf('%s-%s-Radius%.1f-to-%.1f',...
    prefix,network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end

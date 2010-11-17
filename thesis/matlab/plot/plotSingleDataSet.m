function [h] = plotSingleDataSet( figName,dataName,...
    results,anchors,radii,allData,folder,threshold,doBestFit,h,markers,ax)
% Plot number of unique anchor neighbors (unique among all anchors in the
% set) vs location error

if (exist('threshold','var')==0)
    threshold=100;
end

if (exist('doBestFit','var')==0)
    doBestFit=true;
elseif (ischar(doBestFit) || iscell(doBestFit))
    xlab=doBestFit;
    doBestFit=true;
end

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);
numRadii=size(results,2);

if (~exist('h','var') || h==0)
    h=figure('Name',figName,'visible','off');
end
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
    
    if (~exist('markers','var'))
        markers={ '.' 'o' 'v' };
    end
    
    for d=1:numData
        if iscell(allData)
            x=allData{r};
            x=x(:,d);
        else
            x=allData(r,:,d)';
        end
        
        % Remove outliers greater than threshold
        x(outliers)=[];
        nulls=find(isnan(x));
        x(nulls)=[];
        y(nulls)=[];
        
        dataToPlot=[x, y];
        dataToPlot=sortrows(dataToPlot,1);
        ls=sprintf('%sk',markers{d});
        x=dataToPlot(:,1);
        y=dataToPlot(:,2);
        if (doBestFit)
            [correlation,pvalue] = corrcoef(x, y);
            fit = polyfit(x, y, 1);
            f = polyval(fit,x);
            r2 = rsquare(f, y);
            plot(dataToPlot(:,1),dataToPlot(:,2),ls,x,f,'-');
            statsString=sprintf('correlation coeff: %.2f p-value: %.2f',...
                correlation,pvalue);            
        else
            if (exist('ax','var'))
                plot(ax,dataToPlot(:,1),dataToPlot(:,2),ls);
            else
                plot(dataToPlot(:,1),dataToPlot(:,2),ls);
            end
            statsString='';
        end
        
        if (numRadii > 1)
            lab=sprintf('%s: Radius=%.1f\n  ',...
                results(r).radius,statsString);
            labels{p}=lab;
        end
        
        if (doBestFit)
            labels{p+1}=sprintf('Line of best fit, 1st order (r^{2}: %.2f)',r2(1));
        end

        p=p+3;
    end
end
if (iscell(labels) && ischar(labels{1}))
    legend(labels,'Location','NorthEast');
end

if (exist('xlab','var'))
    xlabel(xlab);
else
    xlabel(dataName);
end

if (doBestFit)
    label1=sprintf('%s\nCorrelation Coefficient=%.2f\np-value=%.2f',...
        dataName,correlation(1,2),pvalue(1,2));
    label2=sprintf('Line of best fit, 1st order (r^{2}: %.2f)',r2);
    legend({label1,label2});
else
    legend({dataName});
end

ylabel({'Mean Location Error';'(factor of radio radius)'});

prefix=strrep(figName,' ','_');
filename=sprintf('%s-%s-Radius%.1f-to-%.1f',...
    prefix,network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end


function [r2]=rsquare(x,y)
  r = corrcoef(x,y);   
  R=r(1,2);
  r2=R^2;
end

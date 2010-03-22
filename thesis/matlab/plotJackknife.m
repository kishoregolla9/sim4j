function [h] = plotJackknife(results,anchors,radii,folder)

network=results.network;

for r=1:size(results,2)
    result=results(r);
    figureName=sprintf('The Jackknife Results for Radius %.1f',...
        result.radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    
    doPlotJackknife(...
        [result.errors.mean],...
        'Mean Error',4);
   
    filename=sprintf('Jackknife-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

function doPlotJackknife(x,xLabel,factorOfStd)
a=1:size(x,2);
[x,outliers]=removeOutliers(x,factorOfStd);
y=jackknife(@var,x);
a(outliers)=[];

data=sortrows([a;x;y']',-2);

[ax,h1,h2]=plotyy(1:size(x,2),data(:,2),1:size(x,2),data(:,3));
set(h1,'LineStyle','--','Marker','*')
set(h2,'LineStyle',':','Marker','s')

legend(xLabel,'Jackknife Stat');
xlabel('Index');
set(get(ax(1),'Ylabel'),'String',xLabel);
set(get(ax(2),'Ylabel'),'String','Jackknife');
t=sprintf('Jackknife removing outliers greater than %i std',factorOfStd);
title(t);
end

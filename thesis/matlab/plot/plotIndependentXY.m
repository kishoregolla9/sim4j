function [ h ] = plotIndependentXY( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('The Results for Radius %.1f with IndependentXY',...
        results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off

    grid on
    plotTitle=sprintf('%s - Network %s',figureName,network.shape);
    addaxislabel(1,'Location Error (factor of radius)');
    hold all
    
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,3);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).max],2);
        startNodeData(s,2)=mean([results(r).errors(:,s).mean],2);
        startNodeData(s,3)=mean([results(r).errors(:,s).min],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    data=zeros(numAnchorSets,16);
    for a=1:numAnchorSets
        data(a,1)=a;
        data(a,2)=results(r).errorsPerAnchorSet(a).max;
        data(a,3)=results(r).errorsPerAnchorSet(a).mean;
        data(a,4)=results(r).errorsPerAnchorSet(a).min;

        data(a,5)=results(r).ixy.errorsPerAnchorSet(a).max;
        data(a,6)=results(r).ixy.errorsPerAnchorSet(a).mean;
        data(a,7)=results(r).ixy.errorsPerAnchorSet(a).min;
    end
    
    data=sortrows(data, -3);
    
    ax1 = gca;
    set(ax1,'XScale','log');
    legends=cell(4,1);
    p=plot([data(:,2),data(:,3),data(:,5),data(:,6)],'-o');
    
    plots(1)=p(1);
    legends{1}=sprintf('Max (Sum XY)');
    
    plots(2)=p(2);
    legends{2}=sprintf('Mean (Sum XY)');
   
    plots(3)=p(3);    
    set(plots(3),'LineStyle','-.','Marker','s');
    legends{3}=sprintf('Max (Independent XY)');
    
    plots(4)=p(4);
    set(plots(4),'LineStyle','-.','Marker','s');
    legends{4}=sprintf('Mean (Independent XY)');
        
    n=10;
    nWorst=sprintf('%i ',data(1:n,1));
    nBest=sprintf('%i ',data(end:-1:size(data,1)-n-1,1));
    temp=sprintf('Best: %s',nBest);
    nWorst %#ok<NOPRT>
    title({plotTitle,temp});
    temp=sprintf('Sorted by Mean Error - %s\nWorst: %s',results(r).reflect,nWorst);
    xlabel(temp);
    legendHandle=legend(plots,legends,'Location','NorthWestOutside','FontSize',6);
    l=get(legendHandle,'Position');
    set(legendHandle,'Position',[l(1)+.05,l(2)+0.05,l(3),l(4)]);
    
    filename=sprintf('IndependentXY-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off;
end

end
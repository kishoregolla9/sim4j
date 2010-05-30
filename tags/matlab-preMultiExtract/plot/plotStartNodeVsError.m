function [  ] = plotStartNodeVsError( results,folder )

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('The Results for Radius %.1f by Start Node and Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off

    grid on
    plotTitle=sprintf('Network %s',network.shape);
    xlabel({'Index','(Start Node is normalized)'});
    ylabel('Location Error (factor of radius)');
    hold all
    
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,3);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).max],2);
        startNodeData(s,2)=mean([results(r).errors(:,s).mean],2);
        startNodeData(s,3)=mean([results(r).errors(:,s).min],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    anchorSetData=zeros(numAnchorSets,3);
    for a=1:numAnchorSets
        anchorSetData(a,1)=mean([results(r).errors(a,:).max],2);
        anchorSetData(a,2)=mean([results(r).errors(a,:).mean],2);
        anchorSetData(a,3)=mean([results(r).errors(a,:).min],2);
    end
    
    sortable=[(1:numAnchorSets)' anchorSetData(:,1)];
    sorted=sortrows(sortable,2);
    fiveBest=sprintf('Best Anchor Sets: %i %i %i %i %i',sorted(1:5,1));
    fifthWorst=size(sorted,1)-4;
    fiveWorst=sprintf('Worst Anchor Sets: %i %i %i %i %i',sorted(end:-1:fifthWorst,1));
    title({figureName,plotTitle,fiveBest,fiveWorst});
    
    % errors=[results.errors];
    x=(1:numAnchorSets);
    plots(4)=plot(x,anchorSetData(:,1),'-o');
    plots(5)=plot(x,anchorSetData(:,2),'-o');
    plots(6)=plot(x,anchorSetData(:,3),'-o');
    
    x=(1:numStartNodes).*numAnchorSets./numStartNodes;
    plots(1)=plot(x,startNodeData(:,1),'-s');
    plots(2)=plot(x,startNodeData(:,2),'-s');
    plots(3)=plot(x,startNodeData(:,3),'-s');

    startNodeLegend=sprintf('Start Node (avg over all %i anchor sets)',numAnchorSets);
    anchorSetLegend=sprintf('Anchor Sets (avg over all %i start nodes)',numStartNodes);
    a=sprintf('%s (Max)',startNodeLegend);
    b=sprintf('%s (Mean)',startNodeLegend);
    c=sprintf('%s (Min)',startNodeLegend);
    d=sprintf('%s (Max)',anchorSetLegend);
    e=sprintf('%s (Mean)',anchorSetLegend);
    f=sprintf('%s (Min)',anchorSetLegend);    
    l=legend(plots,a,b,c,d,e,f);
    set(l,'FontSize',6);
   
    filename=sprintf('StartNodeAndAnchorSets-vs-Error-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);

    hold off
    close
end

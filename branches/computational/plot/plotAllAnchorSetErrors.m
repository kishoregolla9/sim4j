function [  ] = plotAllAnchorSetErrors( results,folder,prefix )

network=results.network;

if nargin<3, prefix=''; end

for r=1:size(results,2)
    figureName=sprintf('The Results for Radius %.1f by Start Node and Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off

    grid on
    plotTitle=sprintf('Network %s %s',network.shape,prefix);
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
        anchorSetData(a,1)=results(r).errorsPerAnchorSet(a).max;
        anchorSetData(a,2)=results(r).errorsPerAnchorSet(a).mean;
        anchorSetData(a,3)=results(r).errorsPerAnchorSet(a).min;
    end
    
    sortable=[(1:numAnchorSets)' anchorSetData(:,1)];
    sorted=sortrows(sortable,2);
    fiveBest=sprintf('Best Anchor Sets: %i %i %i %i %i',sorted(1:5,1));
    fifthWorst=size(sorted,1)-4;
    fiveWorst=sprintf('Worst Anchor Sets: %i %i %i %i %i',sorted(end:-1:fifthWorst,1));
    title({figureName,plotTitle,fiveBest,fiveWorst});
    
    % errors=[results.errors];
    plots(1)=plot(anchorSetData(:,1),'-o');
    plots(2)=plot(anchorSetData(:,2),'-o');
    plots(3)=plot(anchorSetData(:,3),'-o');
    
    anchorSetLegend=sprintf('Anchor Sets (avg over all %i start nodes)',numStartNodes);
    d=sprintf('%s (Max)',anchorSetLegend);
    e=sprintf('%s (Mean)',anchorSetLegend);
    f=sprintf('%s (Min)',anchorSetLegend);    

    cosTheta=zeros(size(results(r).transform,2),1);
    for s=1:numAnchorSets
        T=results(r).transform(s).T;
        if int32(T(1,1)) == -int32(T(2,2))
            fprintf('Anchor Set #%i Reflected\n',s);
        else
            cosTheta(s)=T(1,1);
        end
    end

    ax1 = gca;
    ax2 = axes();
    plots(4)=plot(ax2,acos(cosTheta),'-o','Color','m');
    g=sprintf('Rotation Angle');
    
    set(ax2,'ActivePositionProperty',get(ax1,'ActivePositionProperty'));
    set(ax2,'Position',get(ax1,'Position'));
    set(ax2,'OuterPosition',get(ax1,'OuterPosition'));
    set(ax2,'Color','none');
    set(ax2,'YAxisLocation','right');
    set(ax2,'XColor','k','YColor','k');
    set(ax2,'Box','off');

    legend(plots,d,e,f,g,'Location','Best');
    
    filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);

    hold off
end

function [  ] = plotAllAnchorSetErrors( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('The Results for Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off

    grid on
    plotTitle=sprintf('Network %s',network.shape);
    xlabel({'Sorted by Mean Error'});
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
    anchorSetData=zeros(numAnchorSets,7);
    for a=1:numAnchorSets
        anchorSetData(a,1)=a;
        anchorSetData(a,2)=results(r).errorsPerAnchorSet(a).max;
        anchorSetData(a,3)=results(r).errorsPerAnchorSet(a).mean;
        anchorSetData(a,4)=results(r).errorsPerAnchorSet(a).min;
        T=results(r).transform(a).T;
        anchorSetData(a,5)=acos(T(1,1)) * 180/pi;
        
        if int32(T(1,1)) == int32(T(2,2))
           % Not Reflected
           anchorSetData(a,6)=0;
        else
            fprintf('Anchor Set %i reflected\n',a);
            anchorSetData(a,6)=90;
        end
        
        % Anchor Error
        anchorError=zeros(size(anchors,2),1);
        for i=1:size(anchors,2)
            anchorError(i)=...
                sum(results(r).patchedMap(a).differenceVector(anchors(a,i),:));
        end
        anchorSetData(a,7)=mean(anchorError);
        
    end

    anchorSetData=sortrows(anchorSetData, -3);
    
    ax1 = gca;
    plots(1)=plot(anchorSetData(:,2),'-o');
    plots(2)=plot(anchorSetData(:,3),'-o');
    plots(3)=plot(anchorSetData(:,4),'-o');
    plots(6)=plot(anchorSetData(:,7),'-o');
    
    ax2 = axes();
    hold(ax2,'all')
    plots(4)=plot(ax2,anchorSetData(:,5),'-d','Color','m');
    plots(5)=plot(ax2,anchorSetData(:,6),'*','MarkerSize',10);
    
    set(ax2,'ActivePositionProperty',get(ax1,'ActivePositionProperty'));
    set(ax2,'Position',get(ax1,'Position'));
    set(ax2,'OuterPosition',get(ax1,'OuterPosition'));
    set(ax2,'Color','none');
    set(ax2,'YAxisLocation','right');
    set(ax2,'XColor','k','YColor','k');
    set(ax2,'Box','off');
    ylabel(ax2,'Transform Rotation Angle');
    legends=cell(4,1);
    legends{1}=sprintf('Max');
    legends{2}=sprintf('Mean');
    legends{3}=sprintf('Min');    
    legends{4}=sprintf('Rotation Angle');
    legends{5}=sprintf('Is Reflected');
    
    legend(plots,legends,'Location','Best');
    
    set(ax1,'XScale','log');
    set(ax2,'XScale','log');
    
    fiveBest=sprintf('Best: %i %i %i %i %i',anchorSetData(1:5,1));
    fifthWorst=size(anchorSetData,1)-4;
    fiveWorst=sprintf('Worst: %i %i %i %i %i',anchorSetData(end:-1:fifthWorst,1));
    temp=sprintf('%s %s',fiveBest, fiveWorst);
    title({figureName,plotTitle,temp});
    
    filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);

    hold off
end

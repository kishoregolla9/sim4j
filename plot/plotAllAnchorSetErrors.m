function [ h ] = plotAllAnchorSetErrors( results,anchors,folder)

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
    data=zeros(numAnchorSets,8);
    for a=1:numAnchorSets
        data(a,1)=a;
        data(a,2)=results(r).errorsPerAnchorSet(a).max;
        data(a,3)=results(r).errorsPerAnchorSet(a).mean;
        data(a,4)=results(r).errorsPerAnchorSet(a).min;
        T=results(r).transform(a).T;
        data(a,5)=acos(T(1,1)) * 180/pi;
        
        if int32(T(1,1)) == int32(T(2,2))
            % Not Reflected
            data(a,6)=0;
        else
            fprintf('Anchor Set %i reflected\n',a);
            data(a,6)=90;
        end
        
        % Anchor Error
        anchorError=zeros(size(anchors,2),1);
        triangle=zeros(3,2);
        for i=1:size(anchors,2)
            anchorError(i)=...
                sum(results(r).patchedMap(a).differenceVector(anchors(a,i),:));
            triangle(i,:)=results(r).network.points(anchors(a,i),:);
        end
        data(a,7)=mean(anchorError);
        data(a,8)=triangleArea(triangle);
    end
    
    data=sortrows(data, -3);
    
    ax1 = gca;
    set(ax1,'XScale','log');
    legends=cell(7,1);
    p=plot([data(:,2),data(:,3),data(:,4),data(:,7)],'-o');
    plots(1)=p(1);
    legends{1}=sprintf('Max');
    plots(2)=p(2);
    legends{2}=sprintf('Mean');
    plots(3)=p(3);
    legends{3}=sprintf('Min');
    plots(4)=p(4);
    legends{4}=sprintf('Anchor Error');
    
%     ax2 = axes();
%     ax3 = axes();
%     hold(ax2,'all')
%     hold(ax3,'all')
    X=1:size(data,1);
    plots(5)=addaxis(X,data(:,5),'-d','Color','m');
    legends{5}=sprintf('Rotation Angle');
    addaxislabel(2,'Rotation Angle');
    
    plots(6)=addAxis(X,data(:,6),'*','MarkerSize',10);
    legends{6}=sprintf('Is Reflected');
    addaxislabel(3,'Is Reflected');

    plots(7)=addaxis(X,data(:,8),':s'); % Triangle Area
    legends{7}=sprintf('Triangle Area');
    addaxislabel(3,'Triangle Area');
    
%     overlapAxes(ax1,ax2,'Transform Rotation Angle');
%     overlapAxes(ax2,ax3,'Triangle Area');

    fiveBest=sprintf('Best: %i %i %i %i %i',data(1:5,1));
    fifthWorst=size(data,1)-4;
    fiveWorst=sprintf('Worst: %i %i %i %i %i',data(end:-1:fifthWorst,1));
    temp=sprintf('%s %s',fiveBest, fiveWorst);
    title({figureName,plotTitle,temp});
    legendHandle=legend(plots,legends,'Location','NorthEast');
    l=get(legendHandle,'Position');
    set(legendHandle,'Position',[l(1)+.05,l(2)+.15,l(3),l(4)]);
    
    filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off
end

end

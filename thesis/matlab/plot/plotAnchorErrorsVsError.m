function [ h ] = plotAnchorErrorsVsError( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('Location Error - Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off
   
    grid on
    plotTitle=sprintf('Mean Anchor Node Errors vs Network Location Error\n%s Radius %.1f',...
        strrep(network.shape,'-',' '),results(r).radius);
    title(plotTitle);
    addaxislabel(1,'Location Error (factor of radius)');
    hold all
    
    numAnchorSets=size(results(r).errors,1);
    data=zeros(numAnchorSets,5);
    for a=1:numAnchorSets
        data(a,1)=a;
        data(a,2)=results(r).errorsPerAnchorSet(a).max;
        data(a,3)=results(r).errorsPerAnchorSet(a).mean;
        data(a,4)=results(r).errorsPerAnchorSet(a).min;
        anchorError=zeros(size(anchors,2),1);
        for i=1:size(anchors,2)
            anchorError(i)=...
                results(r).patchedMap(a).distanceVector(anchors(a,i),:);
        end
        
%         data(a,5)=results(r).anchorErrors(a).mean;
        data(a,5)=mean(anchorError);
    end
    x=data(:,5);
    y=data(:,3);
    plot([x,y],'-ok');
    
    filename=sprintf('AnchorErrorsVsError-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off;
    close(h);
end

end
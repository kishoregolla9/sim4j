function [ h ] = plotAnchorErrorsVsError( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('Location Error - Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off
   
    grid on
    plotTitle=sprintf('Mean Anchor Node Errors vs Network Location Error\n%s Radius %.1f',...
        strrep(network.shape,'-',' '),results(r).radius);
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
        
        data(a,5)=results(r).anchorErrors(a).mean;
    end
    plot([data(:,5),data(:,3)],'-ok');
    
    filename=sprintf('AnchorErrorsVsError-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off;
    close(h);
end

end
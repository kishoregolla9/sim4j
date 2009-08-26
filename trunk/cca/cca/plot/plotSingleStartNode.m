function [ h ] = plotSingleStartNode( results,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

numStartNodes=size(results(1).errors,2);
for startNodeIndex=1:numStartNodes
    n=sprintf('The Results for Start Node %i',startNodeIndex);
    h=figure('Name',n,'visible','off');
    hold off
    
    grid on
    plotTitle=sprintf('Network %s',network.shape);
    title({'Localization Error',plotTitle});
    xlabel('Anchor Set Index');
    ylabel('Location Error (factor of radius)');
    hold all
    
    for r=1:size(results,2)
        
        numAnchorSets=size(results(r).errors,1);
        anchorSetData=zeros(numAnchorSets,3);
        for a=1:numAnchorSets
            anchorSetData(a,1)=mean([results(r).errors(a,startNodeIndex).max],2);
            anchorSetData(a,2)=mean([results(r).errors(a,startNodeIndex).mean],2);
            anchorSetData(a,3)=mean([results(r).errors(a,startNodeIndex).min],2);
        end
        
        sortable=[(1:numAnchorSets)' anchorSetData(:,2)];
        sorted=sortrows(sortable,2);
        fprintf(1,'Worst\n');
        sorted(size(sorted,1)-5:size(sorted,1),:)
        fprintf(1,'Best\n');
        sorted(1:5,:)
        
        % errors=[results.errors];
        x=(1:numAnchorSets);
        plots(1)=plot(x,anchorSetData(:,1),'-d');
        plots(2)=plot(x,anchorSetData(:,2),'-d');
        plots(3)=plot(x,anchorSetData(:,3),'-d');
        anchorSetLegend=sprintf('Anchor Sets');
        d=sprintf('%s (Max)',anchorSetLegend);
        e=sprintf('%s (Mean)',anchorSetLegend);
        f=sprintf('%s (Min)',anchorSetLegend);
        legend(plots,d,e,f);
        hold off
    end
    f=sprintf('%s/eps/byStartNode',folder);
    if (exist(f,'file') == 0)
        mkdir(f);
    end
    f=sprintf('%s/png/byStartNode',folder);
    if (exist(f,'file') == 0)
        mkdir(f);
    end
    filename=sprintf('byStartNode/SingleStartNode-%i-vs-Error-%s-Radius%i-to-%i',...
        startNodeIndex,network.shape,minRadius,maxRadius);
    saveFigure(folder,filename);
    close all
end

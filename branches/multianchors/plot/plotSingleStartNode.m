function [ h ] = plotSingleStartNode( results,folder )

network=results.network;
numStartNodes=size(results(1).errors,2);
for startNodeIndex=1:numStartNodes
    for r=1:size(results,2)
        n=sprintf('The Results Radius %.1f for Start Node %i',results(r).radius,startNodeIndex);
        h=figure('Name',n,'visible','off');
        hold off

        grid on
        plotTitle=sprintf('Network %s',network.shape);
        xlabel('Anchor Set Index');
        ylabel('Location Error (factor of radius)');
        hold all
        
        numAnchorSets=size(results(r).errors,1);
        anchorSetData=zeros(numAnchorSets,3);
        for a=1:numAnchorSets
            anchorSetData(a,1)=mean([results(r).errors(a,startNodeIndex).max],2);
            anchorSetData(a,2)=mean([results(r).errors(a,startNodeIndex).mean],2);
            anchorSetData(a,3)=mean([results(r).errors(a,startNodeIndex).min],2);
        end
        
        sortable=[(1:numAnchorSets)' anchorSetData(:,1)];
        sorted=sortrows(sortable,2);
        fiveBest=sprintf('Best Anchor Sets: %i %i %i %i %i',sorted(1:5,1));
        fifthWorst=size(sorted,1)-4;
        fiveWorst=sprintf('Worst Anchor Sets: %i %i %i %i %i',sorted(end:-1:fifthWorst,1));
        title({n,plotTitle,fiveBest,fiveWorst});
        
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
        f=sprintf('%s/eps/byStartNode',folder);
        if (exist(f,'file') == 0)
            mkdir(f);
        end
        f=sprintf('%s/png/byStartNode',folder);
        if (exist(f,'file') == 0)
            mkdir(f);
        end
        filename=sprintf('byStartNode/SingleStartNode-%i-vs-Error-%s-Radius%.1f',...
            startNodeIndex,network.shape,results(r).radius);
        saveFigure(folder,filename);
        hold off
        close all
    end
end

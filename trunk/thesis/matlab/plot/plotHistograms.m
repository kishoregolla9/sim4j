function [h] = plotHistograms(results,anchors,radii,folder)

network=results.network;

for r=1:size(results,2)
    result=results(r);
    figureName=sprintf('The Histogram of Results for Radius %.1f',...
        result.radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    
    hold all;
    [n,xout] = hist(removeOutliers([result.errors.max]),25);
    bar(xout,n,'b','LineWidth',1);
    [n,xout] = hist(removeOutliers([result.errors.mean]),25);
    bar(xout,n,'c','LineWidth',1);
    legend({'Max Error','Mean Error'});
    hold off;
    
    filename=sprintf('Histogram-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end


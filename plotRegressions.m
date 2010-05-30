function [h] = plotRegressions(results,anchors,radii,folder)

network=results.network;

for r=1:size(results,2)
    result=results(r);
    figureName=sprintf('The Regression Results for Radius %.1f',...
        result.radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    
    plotRegression(...
        [result.errors.min],...
        [result.anchorStats.realAreas],...
        'Min Error','Triangle Area');
   
    filename=sprintf('Regressions-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

function plotRegression(x,y,xLabel,yLabel)
[x,outliers]=removeOutliers(x,5);
y(outliers)=[]; % remove the outliers from y
corrcoef(x,y)

data=[x;y];
data=sortrows(data,1);
x=data(1,:);
y=data(2,:);

% Calculate fit parameters
[p,ErrorEst] = polyfit(x,y,2);
% Evaluate the fit
y_fit = polyval(p,x,ErrorEst);
% Plot the data and the fit
plot(x,y_fit,'-',x,y,'+');
% Annotate the plot
legend('Polynomial Model','Data');
xlabel(xLabel);
ylabel(yLabel);
end

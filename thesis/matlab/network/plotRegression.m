function [h]= plotRegression( results,anchors,radii,folder,threshold  )
network=results(1).network;

%% Regression of Height and Area

stats=triangleStats(network,anchors);

if (exist('threshold','var')==0)
    threshold=100;
end
numAnchorSets=size(anchors,1);
x1 = [ stats.heights.min ]';
x2 = stats.areas;

plotSingleDataSet('HeightAndArea','Height x Area',results,anchors,radii,(x1.*x2)',...
    folder,threshold);

y=zeros(numAnchorSets,1);
for s=1:numAnchorSets
    % For one start node
    y(s)=[results(1).errors(s,1).mean];
end
outliers=find(y>threshold);
y(outliers)=[];
x1(outliers)=[];
x2(outliers)=[];

% Compute regression coefficients for a linear model with an interaction term:



X = [ones(size(x1)) x1 x2 x1.*x2];
b = regress(y,X); % Removes NaN data

% Plot the data and the model:
h=figure('Name','Regression','visible','on');
scatter3(x1,x2,y,'.')
hold on
x1fit = min(x1):1:max(x1);
x2fit = min(x2):1:max(x2);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
colormap(summer);
colorbar();
mesh(X1FIT,X2FIT,YFIT)
t=sprintf('Regression of Triangle Height and Area\nb=%.2f',b(4));
title(t);
xlabel('Triangle Height')
ylabel('Triangle Area')
zlabel('Mean location error')
view(165,15)

filename=sprintf('Regression-%s',...
    network.shape);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end
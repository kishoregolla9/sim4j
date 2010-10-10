%% Plot Multiple Simulation Data vs max/mean errors
function []=plotMultiData(folderAll,shapeLabel,description,...
    numNetworks,numAnchorSets,maxErrors,meanErrors,data,...
    threshold,doConfidenceIntervals)

if (exist('doConfidenceIntervals','var')==0)
    doConfidenceIntervals=false;
end
if (exist('threshold','var')==0)
    threshold=100;
end

networkconstants;
% run(ccaconfigfile);

confidence=0.05;

name=sprintf(description);
h=figure('Name',name,'visible','off');
grid on;
hold all;

if (threshold ~= 100)
    x=sprintf('Excluding values < %0.2f',threshold);
else
    x='';
end
s=strrep(shapeLabel,'-',' ');
t=sprintf('%s\n%i networks, %i anchor sets\n%s %s',...
    s,numNetworks,numAnchorSets,description,x);
title(t);

errors=meanErrors;
numSamples=size(data,1)*size(data,2);
x=zeros(numSamples,1);
y=zeros(numSamples,1);
index=1;
for i=1:size(data,1)
    for j=1:size(data,2)
        x(index,1)=data(i,j);
        y(index,1)=errors(i,j);
        index=index+1;
    end
end

if (threshold ~= 100)
    %Remove points where error > threshold times the radio range
   outliers=find(y>threshold);
   x(outliers)=[]; 
   y(outliers)=[];
end

% plot the actual y points
plot(x,y,'.');

r=corrcoef(x,y);
coef=sprintf('Correlation Coefficient: %.2f',r(1,2));
bottomlabel=sprintf('%s\n%s',description,coef);

if (doConfidenceIntervals)
    sortable=[x,y];
    d=sortrows(sortable);
    x=d(:,1);
    y=d(:,2);
    
    % Make bins based on the sample size of all x data
    numBins=20;
    pointsPerBin=size(x,1)/numBins;
    bx=zeros(pointsPerBin,numBins);
    by=zeros(pointsPerBin,numBins);
    index=1;
    for b=1:numBins
        for j=1:pointsPerBin
            bx(b,j)=x(index);
            by(b,j)=y(index);
            index=index+1;
        end
    end
    
    for b=1:numBins
        [ci]=getConfidenceInterval(confidence,by(b,:));
        mu=mean(by(b,:));
        errorbar(mean(bx(b,:)),mu,ci,'o','LineWidth',1.5);
    end
end
xlabel(bottomlabel);
ylabel('Location Error');
numAnchorSets %#ok<NOPRT>
% axis( [0 size(maxErrors,1) 0 1] )
% legend(p,{d});
desc=strrep(description,' ','_');
if (threshold ~= 100)
    name=sprintf('SameAnchors-%s-exclude%0.2f',desc,threshold);
else
    name=sprintf('SameAnchors-%s',desc);
end
saveFigure(folderAll,name,h);
hold off
end
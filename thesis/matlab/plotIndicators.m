function [h]=plotIndicators(errors,heights,radius)

h=figure('Name','Outlier Indicator','visible','off');
dataToPlot=[heights/radius; errors]';
dataToPlot=sortrows(dataToPlot,1);
x=dataToPlot(:,1);
y=dataToPlot(:,2);
plot(x,y,'g.');

confidence=0.05;


% plot(x,y,'.');
hold all

grid on
set(gca,'XScale','log');
xlabel({'Minimum Anchor Triangle Height','(factor of radio radius)'});
ylabel({'Mean Location Error';'(factor of radio radius)'});

inc=0.1;
bins=0:inc:max(x);
bins=[ bins bins(length(bins))+inc ];
% n=zeros(size(bins,2),1);
mu=zeros(size(bins,2),1);
for i=2:length(bins)
    bottom=bins(1,i-1);
    top=bins(1,i);
    v=y(x>bottom & x<=top);
    criticalT=tinv(0.05,size(v,1));
    ci=(criticalT*std(v)/sqrt(length(v)));
    mu(i)=mean(v);
%     plot(repmat(bins(i),length(v),1),v,'g.');
    errorbar(bins(i)-(inc/2),mu(i),ci,'.k');
    
end
l=ylim;
ylim([0 l(2)])

    % plot a line through the mean points
plot(bins(2:length(bins))-(inc/2),mu(2:length(bins)),'-k');


end
function plotIndicators(errors,heights,radius)
dataToPlot=[heights/radius; errors]';
dataToPlot=sortrows(dataToPlot,1);
x=dataToPlot(:,1);
y=dataToPlot(:,2);

confidence=0.5;

figure
plot(x,y,'.');

[n,bin]=histc(x,0:0.5:max(x));
mu=zeros(size(n));
start=1;
for i=1:size(n)
    count=n(i);
    mu(i)=mean(y(start:count));
    start=count+1;
end
[ci]=getConfidenceInterval(confidence,y');
% mu=mean(dataToPlot,2);
size(mu)
size(ci)
errorbar(mu,ci,'o');

grid on
% set(gca,'XScale','log');
xlabel({'Minimum Anchor Triangle Height','(factor of radio radius)'});
ylabel({'Mean Location Error';'(factor of radio radius)'});
end
function [h1]=plotResult(result,minRadius,maxRadius)

network=result.network;
h1=figure('Name','The Results');
hold off
plot([result.connectivity],[result.meanError],'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title(plotTitle);
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
hold all
plot([result.connectivity],[result.maxError],'-d');
plot([result.connectivity],[result.minError],'-s');
legend('Mean Error','Max Error','Min Error');
hold off

%filename=sprintf('results\\NetworkConn_vs_Error_%s_%.1f_to_%.1fradius_%.0f.fig',...
%    network.shape,minRadius,maxRadius,network.numberOfNodes);
%hgsave(filename);

h2=figure('Name','The Results By Anchor');

medians=zeros(size(result,2),size(result(1).anchors,1));
mins=zeros(size(result,2),size(result(1).anchors,1));
maxs=zeros(size(result,2),size(result(1).anchors,1));
for i=1:size(result,2)
    if result(i).connectivity > 10
        medians(i,:)=result(i).medianErrorPerAnchorSet;
        mins(i,:)=result(i).minErrorPerAnchorSet;
        maxs(i,:)=result(i).maxErrorPerAnchorSet;
    else
        fprintf(1,'Result %.0f has a low connectivity\n',i);
    end
end

hold off
plot(1:6,median(medians),'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title(plotTitle);
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
hold all
plot(1:6,median(maxs),'-d');
plot(1:6,median(mins),'-s');
legend('Median Error','Max Error','Min Error');
hold off



function [result]=plotResult(result,minRadius,maxRadius)

network=result.network;
figure('Name','The Results');
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

filename=sprintf('results\\NetworkConn_vs_Error_%s_%.1f_to_%.1fradius_%.0f.fig',...
    network.shape,minRadius,maxRadius,network.numberOfNodes);
hgsave(filename);

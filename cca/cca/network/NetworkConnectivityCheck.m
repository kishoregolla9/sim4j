function [disconnect]=NetworkConnectivityCheck(network,radius,doPlot)

%Given a network and a radius, this function plots the connectivity of the
%network.

N=size(network.points,1);
connectivity=network.connectivity;
shortestDistanceMatrix=network.shortestDistanceMatrix; % see neighborMap.m
disconnect=0;

for i=1:N
    for j=i:N
        if (shortestDistanceMatrix(i,j)==2*N)
            disconnect=1;
            break;
        end
    end
end

if (disconnect==1)
    fprintf(2,'Network is not connected!\n');
else
    fprintf(1,'Network is connected\n');
end

if (disconnect==1 || doPlot==true)
    gplot(connectivity, network.points,'-d');
    filename=sprintf('results\\network_%s_%f.fig',network.shape,radius);
    hgsave(filename);
end

network.connectivity=connectivity;



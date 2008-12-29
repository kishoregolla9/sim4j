function [disconnect]=NetworkConnectivityCheck(network,radius,doPlot)

%Given a network and a radius, this function plots the connectivity of the
%network.

N=size(network.points,1);
connectivity=network.connectivity;
disconnect=0;

gplot(connectivity, network.points,'-d');

for i=1:N
    nodeConnected=0;
    for j=1:N
        if (i == j), continue, end
        if (connectivity(i,j) == 1)
            nodeConnected=1;
            break;
        end;
    end
    if (nodeConnected==0)
        disconnect=1;
        fprintf(2,'Node [%i,%i] is not connected!\n',i,j);
        break;
    end
end

if (disconnect==1)
    fprintf(2,'Network is not connected!\n');
else
    fprintf(1,'Network is connected\n');
end

if (disconnect==1 || doPlot==true)
    gplot(connectivity, network.points,'-d');
    filename=sprintf('results\\network_%s_%.1f.fig',network.shape,radius);
    hgsave(filename);
end

network.connectivity=connectivity;



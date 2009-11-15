function [disconnect]=NetworkConnectivityCheck(network,radius)

%Given a network and a radius, this function plots the connectivity of the
%network.

N=size(network.points,1);
disconnect=0;

for i=1:N
    nodeConnected=0;
    for j=1:N
        if (i == j), continue, end
        if (network.connectivity(i,j) == 1)
            nodeConnected=1;
            break;
        end;
    end
    if (nodeConnected==0)
        disconnect=1;
        fprintf(2,'Node [%i,%i]@(%.1f,%.1f) is not connected!\n',i,j,network.points(i,1),network.points(i,2));
        break;
    end
end

if (disconnect==1)
    fprintf(2,'Network is not connected!\n');
    gplot(network.connectivity, network.points,'-d');
else
    fprintf(1,'Network is connected\n');
end


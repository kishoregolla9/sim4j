function [network]=checkNetwork(sourceNetwork,radius)

network=struct();
network.shape=sourceNetwork.shape;
network.points=sourceNetwork.points;
network.numberOfNodes=sourceNetwork.numberOfNodes;
[network]=neighborMap(network,radius);
[disconnect]=NetworkConnectivityCheck(network,radius,true);
network.connected=~disconnect;
return;
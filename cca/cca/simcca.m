clear
hold off
addpath('cca')
addpath('network')

tic;

ranging=0; % range-free

radius=1.4;
step=0.4;
numSteps=8;
minRadius=1.4;
maxRadius=1.4+(step*numSteps);

networkType=0;
%  0:random, 1:grid, 2:C-shape random, 3:C-shape grid, 4:rectangle random,
%  5:rectangle grid with 10% placement error (length=N, width=size)
%  6:L-shape random, 7:L-shape grid with 10% placement error)
%  8:loop random, 9:loop grid with 10% placement error, 10:irregular
N=100;
networkEdge=sqrt(N)
[sourceNetwork]=buildNetwork(networkType,networkEdge,N);

for i=1 : numSteps+1

    fprintf(1,'Radius: %.1f\n', radius);

    % Build and check the network
    [network]=checkNetwork(sourceNetwork,radius);
    if (~network.connected), return, end

    anchors=selectAnchorNodesBad(network,3);
    % Plot the network, showing the anchor nodes with red circles
    hold off
    gplot(network.connectivity, network.points,'-db');
    hold all
    for g=1:size(anchors)
        plot(network.points(anchors(g),1),network.points(anchors(g),2),'-or');
    end
    hold off
    filename=sprintf('results\\network_%s_%.1f.fig',network.shape,radius);
    hgsave(filename);    
    
    %or anchorNodesSelectionSquare100.m or other similar functions (e.g., SingleNodeSelection.m)
    %to get anchors or anchor sets. Sometimes, you get error when running these scripts/functions.
    %That often means the area where you want to select an anchor node has no node in it to be selected.
    %The SingleNodeSelection.m may be used to get anchor nodes in desired area one by one.
    %Can also randomly pick up the node index to form the "anchor",
    %e.g.,
%    anchors=[2, 3, 5];
    %has two three anchor node sets.
    % Can have multiple anchor sets. So may need to form
    %'anchor' which is an matrix of MxN (M sets with each set has N anchor nodes. M>=1, N>=3)

    %(7)Select starting nodes for map patch. May use

    % minNodeChoice=1;
    % anchorSelectX1=1;
    % anchorSelectY1=4;
    % anchorSelectX2=3;
    % anchorSelectY2=6;
    % [startNode]=SingleNodeSelection(network,minNodeChoice,anchorSelectX1,anchorSelectX2,anchorSelectY1,anchorSelectY2);

    %to pick nodes from different part of the network. Should form a startNode=[a b c ...] array that
    %contains the starting node for map patching that want to experiment with.
    %For example,
    startNode=[5 20 22];
    % Also have a startNodeSelection script which may work or may not work well depending on the network.

    %(5)Compute local maps using localMapComputing.m -
    fprintf(1,'Generating local maps for radius %.1f\n',radius);
    localMapStart=cputime;
    [localMaps,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,radius,ranging);
    fprintf(1,'Done generating local maps: %f\n', cputime-localMapStart);

    
    %(8)To patch local maps to obtain the node coordinates, use function in mapPatch.m,
    %[patchTime,coordinates_median,coordinates_median_average,allResults]=mapPatch(network, radiusNet,startNode,anchor,connectivityLevels)
    %e.g.,
    disp('------------------------------------')
    fprintf(1,'Doing Map Patch\n');
    startMapPatch=cputime;
    [result(i)]=mapPatch(network,localMaps,startNode,anchors,radius);
    fprintf(1,'Done Map Patch in %f\n', cputime-startMapPatch);

    radius = radius + step;

end

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
    network.shape,minRadius,maxRadius,N);
hgsave(filename);

totalTime=toc;
fprintf(1,'Done %i radius steps in %.3f min (%.3f sec/step) (%.3f sec/node)\n',...
    numSteps,totalTime/60,totalTime/numSteps,totalTime/(numSteps*N));
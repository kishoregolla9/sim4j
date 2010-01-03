function plotNetworks( anchors, results, networks, folder)

%% PLOT NETWORKS WITH ANCHORS
for s=1:size(anchors,1)
    for r=1:size(results,2);
        radius=results(r).radius;
        network=networks(r);
        suffix=sprintf('AnchorSet%i',s);
        filename=sprintf('networks/radius%.1f/network-%s-Radius%.1f-%s',radius,network.shape,radius,suffix);
        if (exist(sprintf('%s/png/%s.png',folder,filename),'file') == 0)
            fprintf('Plotting anchor set %i of %i for radius %.1f\n',s,size(anchors,1),radius);
            h=plotNetwork(network,anchors(s,:),folder,suffix,results(r),s);
            saveFigure(folder,filename,h);
            close
        end
    end
end

end
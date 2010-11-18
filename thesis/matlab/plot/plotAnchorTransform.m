function [h] =plotAnchorTransform(folder,label,X,Y,Z)
filename=sprintf('transforms/anchorTransformMap-%s',label);
if figureExists(folder,filename) == 0
    h=figure('Name','Anchor Transform Map','visible','off');
    hold all;
    px=plot(X(:,1),X(:,2),'-db','MarkerSize',3);
    py=plot(Y(:,1),Y(:,2),'-dg','MarkerSize',3);
    pz=plot(Z(:,1),Z(:,2),'-dr','MarkerSize',3);
    legend([px py pz],{'Real Points','Local','Global (transformed)'},'Location','bestOUTSIDE');
    grid on;
    saveFigure(folder, filename);
    hold off;
end

end
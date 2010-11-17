function[]=plotContours(x,y,z,cmap,threeD)

if (~exist('threeD','var'))
    threeD=false;
end

if (~exist('ax','var'))
    ax=gca;
end

% Determine the minimum and the maximum x and y values:
xmin = min(x); ymin = min(y);
xmax = max(x); ymax = max(y);
% Define the resolution of the grid:
if (threeD)
    res=20;
else
    res=200;
end
% Define the range and spacing of the x- and y-coordinates,
% and then fit them into X and Y
xv = linspace(xmin, xmax, res);
yv = linspace(ymin, ymax, res);
[Xinterp,Yinterp] = meshgrid(xv,yv);
% Calculate Z in the X-Y interpolation space, which is an
% evenly spaced grid:
Zinterp = griddata(x,y,z,Xinterp,Yinterp);
% Generate the mesh plot (CONTOUR can also be used):
if (threeD)
      [DX,DY] = gradient(Zinterp,.2,.2);
      quiver(Xinterp,Yinterp,DX,DY,'k-');
%      scatter(x,y,z,'EraseMode','none');
%     colormap(ax,cmap);
%     scatter(ax,x,y,5,z,'filled','EraseMode','none');
%     colorbar('location','eastoutside')
else
    colormap(ax,cmap);
    contourf(ax,Xinterp,Yinterp,Zinterp,'k-','EraseMode','xor');
    colorbar('location','eastoutside')
end

end
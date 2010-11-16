function[]=plotContours(x,y,z,cmap)

% Determine the minimum and the maximum x and y values:
xmin = min(x); ymin = min(y);
xmax = max(x); ymax = max(y);
% Define the resolution of the grid:
res=200;
% Define the range and spacing of the x- and y-coordinates,
% and then fit them into X and Y
xv = linspace(xmin, xmax, res);
yv = linspace(ymin, ymax, res);
[Xinterp,Yinterp] = meshgrid(xv,yv);
% Calculate Z in the X-Y interpolation space, which is an
% evenly spaced grid:
Zinterp = griddata(x,y,z,Xinterp,Yinterp);
% Generate the mesh plot (CONTOUR can also be used):
colormap(cmap);
contourf(Xinterp,Yinterp,Zinterp,'k-');
% alpha(a);
colorbar('location','eastoutside')
end
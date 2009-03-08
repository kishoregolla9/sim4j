function saveFigure( folder, name )
%SAVEFIGURE Summary of this function goes here
%   Detailed explanation goes here

maximize(gcf);

filename=sprintf('%s\\%s.eps',folder,name);
print('-depsc',filename);
filename=sprintf('%s\\%s.png',folder,name);
print('-dpng',filename);

function saveFigure( folder, name, h )
%SAVEFIGURE Summary of this function goes here
%   Detailed explanation goes here

if exist('h','var') == 0
   h=gcf; 
end

maximize(h);

% filename=sprintf('%s/eps/%s.eps',folder,name);
% [pathstr]=fileparts(filename);
% if exists(pathstr,'file')==0
%     mkdir(pathstr);
% end
% print('-depsc',filename);

filename=sprintf('%s/png/%s.png',folder,name);
[pathstr]=fileparts(filename);
if exist(pathstr,'file')==0
    mkdir(pathstr);
end
print('-dpng',filename);

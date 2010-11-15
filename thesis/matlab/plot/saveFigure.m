function saveFigure( folder, name, h )
%SAVEFIGURE Summary of this function goes here
%   Detailed explanation goes here

if exist('h','var') == 0
   h=gcf; 
end

maximize(h);

filename=sprintf('%s/png/%s.png',folder,name);
[pathstr]=fileparts(filename);
if exist(pathstr,'file')==0
    [a,b]=mkdir(pathstr); %#ok<NASGU>
end
fprintf(1,'Saving %s\n',filename);
print(h,'-dpng',filename);

% addpath('plot2svg_20100306');

% filename=strrep(filename,'.png','.svg');
% plot2svg(filename, h, 'png'); 

filename=sprintf('%s/eps/%s.eps',folder,name);
[pathstr]=fileparts(filename);
if exist(pathstr,'file')==0
    [a,b]=mkdir(pathstr); %#ok<NASGU>
end
fprintf(1,'Saving %s\n',filename);
print(h, '-depsc',filename);


function [ e ] = figureExists( folder,name )
% Return 0 if does not exist
% See doc exist for meaning of other results
pngfilename=sprintf('%s/png/%s.png',folder,name);
e=exist(pngfilename,'file');

end
